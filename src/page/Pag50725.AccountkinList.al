page 50725 "Account kin List"
{
    ApplicationArea = All;
    Caption = 'Account kin List';
    PageType = List;
    SourceTable = "Account Kins";
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    CardPageId = "Account kin Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Relationship; Rec.Relationship)
                {
                    ToolTip = 'Specifies the value of the Relationship field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}



