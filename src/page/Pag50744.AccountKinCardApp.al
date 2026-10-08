page 50744 "Account Kin Card App"
{
    Caption = 'Account Kin Card App';
    PageType = Card;
    SourceTable = "Account Kins-Applications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Relationship field.';
                }
            }
        }
        area(FactBoxes)
        {

            part(Picture; "Kin Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Account No." = FIELD("Account No."), "ID No." = FIELD("ID No.");
                ApplicationArea = All;
            }
            part(Signature; "Kin Signature Image")
            {
                Caption = 'Signature';
                SubPageLink = "Account No." = FIELD("Account No."), "ID No." = FIELD("ID No.");
                ApplicationArea = All;
            }
            systempart(Control13; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control12; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control14; Links)
            {
                ApplicationArea = All;
            }

        }
    }
}



