page 51009 "Credit Statistics FactBox"
{
    PageType = CardPart;
    SourceTable = "Account Credit";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Balance Details")
            {
                Caption = 'Balance Details';
            }
            field("No."; Rec."No.")
            {
                Caption = 'Account No.';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Account Category"; Rec."Account Category")
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;

            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                begin
                    Rec.OpenCustomerLedgerEntries(false);
                end;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                Visible = true;
                ApplicationArea = All;
                trigger OnDrillDown()
                begin
                    Rec.OpenCustomerLedgerEntries(false);

                end;
            }
            group("Other Details")
            {
                Visible = false;
                field(MinBalance; MinBalance)
                {
                    Caption = 'Minumum Balance';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("(""Balance (LCY)""+""Authorised Over Draft"")-(""Uncleared Cheques""+""ATM Transactions""+MinBalance+""Lien Placed"")"; (Rec."Balance (LCY)") - (MinBalance))
                {
                    Caption = 'Available Balance';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        MinBalance := 0;
        if ProdType.Get(Rec."Product Type") then begin
            MinBalance := ProdType."Minimum Balance";
        end;
    end;

    var
        ProdType: Record "Product Factory";
        MinBalance: Decimal;

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Savings Account Card", Rec);
    end;
}




