codeunit 50047 "Gen. Jnl.-Post (Yes/No)"
{
    EventSubscriberInstance = Manual;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Copy(Rec);
        Code(GenJnlLine);
        Rec.Copy(GenJnlLine);
    end;

    var
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text002: Label 'There is nothing to post.';
        Text005: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        Text006: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        PreviewMode: Boolean;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        FALedgEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
    begin
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        if GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs then begin
            SourceCodeSetup.Get;
            if GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" then
                Error(Text006, GenJnlTemplate.FieldCaption("Source Code"), GenJnlTemplate.TableCaption,
                  SourceCodeSetup.FieldCaption("Job G/L WIP"), SourceCodeSetup.TableCaption);
        end;
        GenJnlTemplate.TestField("Force Posting Report", false);
        if GenJnlTemplate.Recurring and (GenJnlLine.GetFilter("Posting Date") <> '') then
            GenJnlLine.FieldError("Posting Date", Text000);

        //Yafesi Unecessary Dialog Box PopUp
        //  IF NOT PreviewMode THEN
        //    IF NOT CONFIRM(Text001,FALSE) THEN
        //      EXIT;

        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" then begin
            FALedgEntry.SetRange("FA No.", GenJnlLine."Account No.");
            FALedgEntry.SetRange("FA Posting Type", GenJnlLine."FA Posting Type"::"Acquisition Cost");
            if FALedgEntry.FindFirst and GenJnlLine."Depr. Acquisition Cost" then
                if not Confirm(Text005, false, GenJnlLine.FieldCaption("Depr. Acquisition Cost")) then
                    exit;
        end;

        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        GenJnlPostBatch.SetPreviewMode(PreviewMode);
        GenJnlPostBatch.Run(GenJnlLine);

        if PreviewMode then
            exit;

        if GenJnlLine."Line No." = 0 then
            Message(Text002)
        else
            //Yafesi Unecessary For Now
            //    IF TempJnlBatchName = "Journal Batch Name" THEN
            //      MESSAGE(Text003)
            //    ELSE
            //      MESSAGE(
            //        Text004,
            //        "Journal Batch Name");
            PostIfSuccessful(1);
        if not GenJnlLine.Find('=><') or (TempJnlBatchName <> GenJnlLine."Journal Batch Name") then begin
            GenJnlLine.Reset;
            GenJnlLine.FilterGroup(2);
            GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLine.FilterGroup(0);
            GenJnlLine."Line No." := 1;
        end;
    end;


    procedure Preview(var GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.Preview(GenJnlPost, GenJournalLineSource);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJnlPost := Subscriber;
        GenJournalLine.Copy(RecVar);
        PreviewMode := true;
        Result := GenJnlPost.Run(GenJournalLine);
    end;


    procedure PostIfSuccessful(ValuePosting: Integer)
    var
        ValPost: Record "Value Posting";
    begin
        ValPost.SetRange(ValPost.UserID, UserId);
        if ValPost.Find('-') then begin
            ValPost."Value Posting" := ValuePosting;
            ValPost.Modify;
        end
        else begin
            ValPost.Init;
            ValPost.UserID := UserId;
            ValPost."Value Posting" := ValuePosting;
            ValPost.Insert;
        end;
    end;
}




