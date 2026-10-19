page 51084 "EFT Reciept Line"
{
    ApplicationArea = All;
    Caption = 'EFT Reciept Line';
    PageType = ListPart;
    SourceTable = "EFT Transfer Lines";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Style = StandardAccent;
                    ValuesAllowed = 1;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Style = StandardAccent;
                    ValuesAllowed = 7, 8;
                    StyleExpr = true;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Style = StandardAccent;
                    caption = 'Member No.';
                    StyleExpr = true;
                }

                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Available Balance"; Rec."Available Balance")
                {
                    ToolTip = 'Specifies the value of the Available Balance field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Book Balance"; Rec."Book Balance")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Destination"; Rec."Payment Destination")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = Rec."Source of funds" <> Rec."Source of funds"::Junior;
                }
                field("External Account No."; Rec."External Account No.")
                {
                    ToolTip = 'Specifies the value of the External Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("External Account Name"; Rec."External Account Name")
                {
                    ToolTip = 'Specifies the value of the External Account Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                    Visible = false;
                }

                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    Style = StandardAccent;
                    Editable = true;
                    StyleExpr = true;
                }

                field("Own Reference"; Rec."Own Reference")
                {
                    ToolTip = 'Specifies the value of the Own Reference field.';
                    Style = StandardAccent;
                    Editable = true;
                    StyleExpr = true;
                }
                field("Recipient Reference"; Rec."Recipient Reference")
                {
                    ToolTip = 'Specifies the value of the Recipient Reference field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ToolTip = 'Specifies the value of the EFT Options field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Institution Type"; Rec."Institution Type")
                {
                    ToolTip = 'Specifies the value of the Institution Type field.';
                    Style = StandardAccent;
                    Editable = true;
                    StyleExpr = true;
                }
                field("Society Code"; Rec."Society Code")
                {
                    ToolTip = 'Specifies the value of the Society Code field.';
                    Style = StandardAccent;

                    StyleExpr = true;
                }
                field("IBAN No."; Rec."IBAN No.")
                {
                    ToolTip = 'Specifies the value of the IBAN/Swift Code field.';
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Source of funds"; Rec."Source of funds")
                {
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Application Source"; Rec."Application Source")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Account;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Account;
    end;
}
