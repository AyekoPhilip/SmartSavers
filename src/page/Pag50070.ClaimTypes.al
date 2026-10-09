page 50070 "Claim Types"
{
    PageType = List;
    SourceTable = "Receipts and Payment Types";
    SourceTableView = where(Type = filter(Claim));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field';
                }
                field("Based On Travel Rates Table"; Rec."Based On Travel Rates Table")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Based On Travel Rates Table field';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field';
                }
                field("VAT Chargeable"; Rec."VAT Chargeable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Chargeable field';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field';
                }
                field("Withholding Tax Chargeable"; Rec."Withholding Tax Chargeable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Withholding Tax Chargeable field';
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Code field';
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Withholding Tax Code field';
                }
                field("Default Grouping"; Rec."Default Grouping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Grouping field';
                }
                field("Pending Voucher"; Rec."Pending Voucher")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pending Voucher field';
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account field';
                }
                field("Transation Remarks"; Rec."Transation Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transation Remarks field';
                }
                field("Cost of Sale"; Rec."Cost of Sale")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost of Sale field';
                }
                field("Check Medical Ceiling"; Rec."Check Medical Ceiling")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check Medical Ceiling field';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Claim;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Claim;
    end;
}


