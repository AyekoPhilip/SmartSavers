codeunit 50003 "Gen. Jnl.-Post-No Confirm2"
{
    EventSubscriberInstance = Manual;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Copy(Rec);
        Code(GenJnlLine);
        rec.Copy(GenJnlLine);
    end;

    var
        PreviewMode: Boolean;
        Text006: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text002: Label 'There is nothing to post.';
        Text005: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';

    procedure Preview(var GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
    begin
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.Preview(GenJnlPost, GenJournalLineSource);
    end;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line")
    var
        FALedgEntry: Record "FA Ledger Entry";
        GenJnlTemplate: Record "Gen. Journal Template";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
    begin
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        if GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs then begin
            SourceCodeSetup.Get();
            if GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" then
                Error(Text006, GenJnlTemplate.FieldCaption("Source Code"), GenJnlTemplate.TableCaption,
                  SourceCodeSetup.FieldCaption("Job G/L WIP"), SourceCodeSetup.TableCaption);
        end;
        GenJnlTemplate.TestField("Force Posting Report", false);
        if GenJnlTemplate.Recurring and (GenJnlLine.GetFilter("Posting Date") <> '') then
            GenJnlLine.FieldError("Posting Date", Text000);
        //  IF NOT PreviewMode THEN
        //    IF NOT CONFIRM(Text001,FALSE) THEN
        //      EXIT;
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" then begin
            FALedgEntry.SetRange("FA No.", GenJnlLine."Account No.");
            FALedgEntry.SetRange("FA Posting Type", GenJnlLine."FA Posting Type"::"Acquisition Cost");
            if FALedgEntry.FindFirst() and GenJnlLine."Depr. Acquisition Cost" then
                if not Confirm(Text005, false, GenJnlLine.FieldCaption("Depr. Acquisition Cost")) then
                    exit;
        end;
        TempJnlBatchName := GenJnlLine."Journal Batch Name";
        GenJnlPostBatch.SetPreviewMode(PreviewMode);
        GenJnlPostBatch.Run(GenJnlLine);
        if PreviewMode then
            exit;
        if GenJnlLine."Line No." = 0 then
            Message(Text002);
        //  ELSE
        //    IF TempJnlBatchName = "Journal Batch Name" THEN
        //      MESSAGE(Text003)
        //    ELSE
        //      MESSAGE(
        //        Text004,
        //        "Journal Batch Name");
        if not GenJnlLine.Find('=><') or (TempJnlBatchName <> GenJnlLine."Journal Batch Name") then begin
            GenJnlLine.Reset();
            GenJnlLine.FilterGroup(2);
            GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLine.FilterGroup(0);
            GenJnlLine."Line No." := 1;
        end;
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
}


