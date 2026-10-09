page 50592 "Banks List"
{
    PageType = List;
    SourceTable = Banks;
    ApplicationArea = All;
    Editable = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Code field';
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Name field';
                }
                field("Bank Account No.";Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Name field';
                }
                field("Bank No.";Rec."Bank No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Name field';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Address field';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ToolTip = 'Specifies the value of the City field';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Post Code field';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Contact field';
                }
                field("Mobile Money Code"; Rec."Mobile Money Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Society Code"; Rec."Society Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Institution Type"; Rec."Institution Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Code field';

                }
                field("Bank Type"; Rec."Bank Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
    }
}


