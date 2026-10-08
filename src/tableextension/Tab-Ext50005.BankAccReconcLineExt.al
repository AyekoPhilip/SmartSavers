namespace DynamicsNav.SaccoDatabase;

using Microsoft.Bank.Reconciliation;
using Microsoft.Bank.Ledger;
using Microsoft.Bank.Check;


tableextension 50005 "Bank Acc. Reconc Line Ext" extends "Bank Acc. Reconciliation Line"
{


    fields
    {
        field(50000; "Reconciled"; Boolean)
        {
            Caption = 'Reconciled';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if (Difference <> 0) or ("Document No." = '') then
                    Error('Differences cannot be reconciled');
            end;
        }
        field(50001; "Imported"; Boolean)
        {
            Caption = 'Imported';
            DataClassification = CustomerContent;
        }
        field(50002; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = CustomerContent;
        }
        field(50003; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = CustomerContent;
        }
        field(50004; "Suggested"; Boolean)
        {
            Caption = 'Suggested';
            DataClassification = CustomerContent;
        }
        field(50005; "External Document No."; Code[50])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(50006; "Bank Ledger Entry No."; Integer)
        {
            Caption = 'Bank Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(50007; "Entry Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Bank Account Ledger Entry,Check Ledger Entry,Difference';
            OptionMembers = "Bank Account Ledger Entry","Check Ledger Entry","Difference";
        }
        field(50008; "Open Type"; Option)
        {
            Caption = 'Open Type';
            OptionMembers = " ","Unpresented","Uncredited","Manual";
        }
        field(50009; "Statement Amount(LCY)"; Decimal)
        {
            Caption = 'Statement Amount(LCY)';
        }
    }

    var
        CheckLedgEntry: Record "Check Ledger Entry";

    procedure Unapply()
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin

        BankAccLedgEntry.Reset();
        BankAccLedgEntry.SetCurrentKey("Bank Account No.", Open);
        BankAccLedgEntry.SetRange("Bank Account No.", "Bank Account No.");
        BankAccLedgEntry.SetRange(Open, true);
        BankAccLedgEntry.SetRange("Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
        BankAccLedgEntry.SetRange("Statement No.", "Statement No.");
        BankAccLedgEntry.SetRange("Statement Line No.", "Statement Line No.");
        BankAccLedgEntry.LockTable();
        CheckLedgEntry.LockTable();
        if BankAccLedgEntry.Find('-') then
            repeat
                BankRecPostMtg.RemoveReconNo(BankAccLedgEntry, Rec, true);
            until BankAccLedgEntry.Next() = 0;
        "Applied Entries" := 0;
        Validate("Applied Amount", 0);
        Modify(true);
    end;

    var
        BankRecPostMtg: Codeunit SaccoDatabase.SaccoDatabase."Bank Acc. Recon.  Post Mgt";


}
