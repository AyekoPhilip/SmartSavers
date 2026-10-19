pageextension 50073 BankAccLedgerEntryExt extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field("Member No"; Rec."Member No")
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin

        Rec.ResolveMemberNo();
    end;

    trigger OnAfterGetCurrRecord()
    begin


    end;

}
