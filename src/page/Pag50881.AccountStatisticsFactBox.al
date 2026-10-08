page 50881 "Account Statistics FactBox"
{
    PageType = CardPart;
    SourceTable = "Account Banking";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Balance Details")
            {
                Caption = 'Balance Details';

            }
            field("Product Name"; Rec."Account Category")
            {
                ApplicationArea = All;
                Style = StandardAccent;
                ShowMandatory = true;
                StyleExpr = TRUE;
            }
            field("No."; Rec."No.")
            {
                Caption = 'Account No.';
                ApplicationArea = All;
                Style = StandardAccent;
                ShowMandatory = true;
                StyleExpr = TRUE;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
                Style = StandardAccent;
                ShowMandatory = true;
                StyleExpr = TRUE;
                trigger OnDrillDown()
                begin
                    Rec.OpenVendorLedgerEntries(false);
                end;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                Visible = true;
                ApplicationArea = All;
                Style = StandardAccent;
                ShowMandatory = true;
                StyleExpr = TRUE;

                trigger OnDrillDown()
                begin
                    Rec.OpenVendorLedgerEntries(false);

                end;
            }
            group(OD)
            {
                Caption = 'Overdraft';
               
                field("Authorised Over Draft"; Rec."Authorised Over Draft")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
            }
            group(UE)
            {
                Caption = 'Uncleared Effects';
                
                field("ATM Transactions"; Rec."ATM Transactions")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Uncleared Cheques"; Rec."Uncleared Cheques")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Lien Placed"; Rec."Lien Placed")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
            }
            group(AB)
            {
                Caption = 'Available Balance';
                
                field(MinBalance; MinBalance)
                {
                    Caption = 'Minumum Balance';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("(""Balance (LCY)""+""Authorised Over Draft"")-(""Uncleared Cheques""+""ATM Transactions""+MinBalance+""Lien Placed"")"; (Rec."Balance (LCY)" + Rec."Authorised Over Draft") - (Rec."Uncleared Cheques" + Rec."ATM Transactions" + MinBalance + Rec."Lien Placed"))
                {
                    Caption = 'Available Balance';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
            }
            group(IND)
            {
                Caption = 'Account Interest';
                
                field("Interest Transferred"; Rec."Interest Transferred")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Untranferred Interest"; Rec."Untranferred Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
            }
            group(Dates)
            {
                
                field("Last Withdrawal Date"; Rec."Last Withdrawal Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Last Transaction Date"; Rec."Last Transaction Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Next Withdrawal Date"; Rec."Next Withdrawal Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
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




