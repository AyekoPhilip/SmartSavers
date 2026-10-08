pageextension 50038 "BankAccountCardExt" extends "Bank Account Card"
{
    
    layout
    {
        modify("No.")
        {
            Editable = true;
            Visible = true;
        }
        modify("Name")
        {
            ShowMandatory = true;
        }
        modify("Bank Account No.")
        {
            ShowMandatory = true;
        }
        modify("Bank Acc. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Currency Code")
        {
            ShowMandatory = true;
        }
        modify("SWIFT Code")
        {
            ShowMandatory = true;
        }

        addlast(Posting)
        
        {
            field("Responsibility Centre";Rec."Responsibility Centre")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Responsibility Centre field';

            }
            field("Bank Type"; Rec."Bank Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Type field';
            }
            field(CashierID; Rec.CashierID)
            {
                ApplicationArea = All;
                Caption = 'Cashier ID';
                ToolTip = 'Specifies the value of the CashierID field';
            }
            field("Sort Code"; Rec."Sort Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sort Code field';
            }
            field("Check Bank Limit"; Rec."Check Bank Limit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Check Bank Limit field';
            }
            field("Bank Limit (LCY)"; Rec."Bank Limit (LCY)")
            {
                Editable = Rec."Check Bank Limit";
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Limit (LCY) field';
            }

        }

    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var

    begin

        case Rec."Bank Type" of
            Rec."Bank Type"::Bank,
            Rec."Bank Type"::"Fixed Deposit",
            Rec."Bank Type"::Normal:
                begin
                    Rec.Testfield(Name);
                    Rec.Testfield("Bank Acc. Posting Group");
                    Rec.Testfield("Bank Type");
                    Rec.Testfield("Responsibility Centre");
                end;
        end

    end;
}




