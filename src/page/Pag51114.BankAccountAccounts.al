page 51114 "Bank Account-Accounts"
{
    ApplicationArea = All;
    Caption = 'Bank Account-Accounts';
    PageType = ListPart;
    SourceTable = "Cust. Bank Applic Change";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Bank Code';

                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Caption = 'Branch Code';
                    StyleExpr = true;
                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
