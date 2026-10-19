page 50003 "SC Nominee List"
{
    ApplicationArea = All;
    Caption = 'SC Nominee List';
    PageType = List;
    SourceTable = "Collateral Register";
    UsageCategory = Lists;
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    Editable=false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable=false;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Third Party Access"; Rec."Third Party Access")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Third Party Nominee field.';
                }
                field("Third Party Access ID/Passport"; Rec."Third Party Access ID/Passport")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Third Party Access ID/Passport field.';
                }
            }
        }
        area(factboxes)
        {
           
            part(Control16; "SC Nominee Picture")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }

            systempart(Control5; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control6; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; Links)
            {
                ApplicationArea = All;
            }
        }
    }
}



