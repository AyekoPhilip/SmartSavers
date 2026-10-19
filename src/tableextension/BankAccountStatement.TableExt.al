namespace SaccoDatabase.SaccoDatabase;

using Microsoft.Bank.Statement;

tableextension 50007 "Bank Account Statement" extends "Bank Account Statement"
{
    fields
    {
        field(50000; "Cash Book Balance"; Decimal)
        {
            Caption = 'Cash Book Balance';
            DataClassification = ToBeClassified;
        }
    }
}
