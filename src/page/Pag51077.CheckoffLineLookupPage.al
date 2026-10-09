page 51077 "Checkoff Line Lookup Page"
{
    ApplicationArea = All;
    Caption = 'Checkoff Line Lookup Page';
    PageType = List;
    SourceTable = "Checkoff Receipt Lines";
    UsageCategory = Lists;
    Editable=false;
    ModifyAllowed=false;
    InsertAllowed=false;
    DeleteAllowed=false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Line Validated"; Rec."Line Validated")
                {
                    ToolTip = 'Specifies the value of the Line Validated field.';
                }
                field("Upload ID"; Rec."Upload ID")
                {
                    ToolTip = 'Specifies the value of the Upload ID field.';
                }
                field("Upload Response"; Rec."Upload Response")
                {
                    ToolTip = 'Specifies the value of the Upload Response field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ToolTip = 'Specifies the value of the Employer Code field.';
                }
                field("Account Found"; Rec."Account Found")
                {
                    ToolTip = 'Specifies the value of the Account Found field.';
                }
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    ToolTip = 'Specifies the value of the Payroll/Staff No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
            }
        }
    }
}
