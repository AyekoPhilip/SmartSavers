namespace SaccoDatabase.SaccoDatabase;

using Microsoft.Bank.Statement;
using Microsoft.Bank.Check;
using Microsoft.Bank.Ledger;
using Microsoft.Bank.Reconciliation;

tableextension 50006 "Bank Acc. Statement Line Ext" extends "Bank Account Statement Line"
{
    fields
    {
        field(50000; "Reconciled"; Boolean)
        {
            Caption = 'Reconciled';
            DataClassification = ToBeClassified;
        }
    }
}
