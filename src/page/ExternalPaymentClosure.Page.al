page 51106 "External Payment-Closure"
{
    ApplicationArea = All;
    Caption = 'External Payment-Closure';
    PageType = List;
    SourceTable = "External Payment";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Kin Account"; Rec."Kin Account")
                {
                    ToolTip = 'Specifies the value of the Kin Account field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Type"; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("External Account No."; Rec."External Account No.")
                {
                    ToolTip = 'Specifies the value of the External Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("External Account Name"; Rec."External Account Name")
                {
                    ToolTip = 'Specifies the value of the External Account Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Recipient Reference"; Rec."Recipient Reference")
                {
                    ToolTip = 'Specifies the value of the Recipient Reference field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    ToolTip = 'Specifies the value of the Pay Point field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ToolTip = 'Specifies the value of the EFT Options field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Own Reference"; Rec."Own Reference")
                {
                    ToolTip = 'Specifies the value of the Own Reference field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Society Code"; Rec."Society Code")
                {
                    ToolTip = 'Specifies the value of the Society Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Institution Type"; Rec."Institution Type")
                {
                    ToolTip = 'Specifies the value of the Institution Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

}
