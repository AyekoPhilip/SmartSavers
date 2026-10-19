namespace DynamicsNav.SaccoDatabase;

using Microsoft.Bank.Reconciliation;
using Microsoft.Bank.Ledger;
using Microsoft.Bank.Check;

codeunit 90008 "Match Bank Rec. Line Mgt"
{
    trigger OnRun()
    begin

    end;

    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        AppliedStatementEntry: Record "Bank Acc. Reconciliation Line";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
}
