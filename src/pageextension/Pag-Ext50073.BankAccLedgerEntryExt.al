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

        RecHeader.Reset();
        RecHeader.SetRange("No.", Rec."Document No.");
        if RecHeader.Find('-') then begin
            Rec."Member No" := RecHeader."Member No.";
        end else begin
            Rec."Member No" := '';
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin


    end;

    var
        RecHeader: Record "Receipts Header";
}
