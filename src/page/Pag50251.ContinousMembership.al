page 50251 "Continous Membership"
{
    ApplicationArea = All;
    Caption = 'Continous Membership';
    PageType = List;
    SourceTable = "DSC Continous Membership";
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Score Type"; Rec."Score Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Score Type field.';

                }
                field(Parameter; Rec.Parameter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parameter field.';
                }

                field("Min. Age"; Rec."Min. Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Min. Age field.';
                }
                field("Max. Age"; Rec."Max. Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Age field.';
                }

                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Score field.';
                }
            }
        }
    }
}



