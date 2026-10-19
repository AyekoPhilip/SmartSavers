namespace DynamicsNav.SaccoDatabase;

using Microsoft.Bank.Reconciliation;

tableextension 50008 "Bank Acc. Recon. Ext." extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(50017; "Reconciliation Option"; Option)
        {
            OptionMembers = "Automated","Manual";
        }
    }

    procedure fnMatchCandidateFilterDate(): Date
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliationLine.SetRange("Statement Type", "Statement Type");
        BankAccReconciliationLine.SetRange("Statement No.", "Statement No.");
        BankAccReconciliationLine.SetRange("Bank Account No.", "Bank Account No.");
        BankAccReconciliationLine.SetCurrentKey("Transaction Date");
        BankAccReconciliationLine.Ascending := false;
        if BankAccReconciliationLine.FindFirst() then
            if BankAccReconciliationLine."Transaction Date" > "Statement Date" then
                exit(BankAccReconciliationLine."Transaction Date");

        exit("Statement Date");
    end;
}
