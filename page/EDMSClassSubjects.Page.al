page 50278 "EDMS Class Subjects"
{
    Caption = 'EDMS Class Subjects';
    PageType = ListPart;
    SourceTable = "EDMS Class Subject";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("S/No."; Rec."S/No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the S/No. field.';
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Subject field.';
                }
                field("Reference Number"; Rec."Reference Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference Number field.';
                }
            }
        }
    }
}



