namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using Microsoft.Inventory.Journal;

codeunit 90010 "Hr Leave Jnl. -Post"
{
    TableNo = "Item Journal Line";

    trigger OnRun()
    begin
        HrJournalLine.Copy(Rec);
        fnCode(Rec);
        Rec.Copy(HrJournalLine);
    end;

    var
        Text000: Label 'Do you want to post the journal lines?';
        Text001: Label 'There is nothing to post.';
        Text002: Label 'The journal lines were successfully posted.';
        Text003: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text004: Label 'Since you are making a Negative Adjustment, "Number of Days" Should be Less Than Zero and not %1';
        HrJournalLineTemplate: Record "Item Journal Template";
        HrJournalLine: Record "Item Journal Line";
        //HRJournalPostBatch:	Codeunit	HR Leave Jnl.- Post Batch	
        TempJnlBatchName: Code[10];

    local procedure fnCode(RecRef: Record "Item Journal Line")
    begin

        HRJournalLineTemplate.Get(RecRef."Journal Template Name");
        HRJournalLineTemplate.TestField("Force Posting Report", false);
        TempJnlBatchName := RecRef."Journal Batch Name";
        //  HRJournalPostBatch.RUN(HRJournalLine);
        if RecRef."Line No." = 0 then
            Message(Text001)
        else
            if TempJnlBatchName = RecRef."Journal Batch Name" then begin
                Message(Text002);
                RecRef.DeleteAll();
            end
            else begin
                Message(
                  Text003,
              RecRef."Journal Batch Name");
            end;
        if not RecRef.Find('=><') or (TempJnlBatchName <> RecRef."Journal Batch Name") then begin
            RecRef.Reset();
            RecRef.FilterGroup := 2;
            RecRef.SetRange("Journal Template Name", RecRef."Journal Template Name");
            RecRef.SetRange("Journal Batch Name", RecRef."Journal Batch Name");
            RecRef.FilterGroup := 0;
            RecRef."Line No." := 1;
        end
    end;

}
