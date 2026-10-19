page 50262 "EDMS Class Setup"
{
    ApplicationArea = All;
    Caption = 'EDMS Class Setup';
    PageType = List;
    SourceTable = "EDMS Class Setup";
    UsageCategory = Administration;

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
                field("Class Name"; Rec."Class Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class Name field.';
                }
                field("Class Number"; Rec."Class Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class Number field.';
                }
                field("Ref. Code"; Rec."Ref. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ref. Code field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Subjects)
            {
                ApplicationArea = All;
                Caption = 'EDMS Subjects', comment = 'NLB="DMS Subjects"';
                Image = SuggestBin;
                RunObject = page "EDMS Class Subjects";
                RunPageLink = "Class S/No." = field("S/No.");
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Subjects_Promoted; Subjects)
                {
                }
            }
        }
    }
}



