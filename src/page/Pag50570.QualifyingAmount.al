page 50570 "Qualifying Amount"
{
    ApplicationArea = All;
    Caption = 'Qualifying Amount';
    PageType = List;
    SourceTable = "QC Qualifying Tiers";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Min. Point";Rec."Min. Point")
                {
                    ApplicationArea = All;

                }
                field("Max. Point";Rec."Max. Point")
                {
                    ApplicationArea = All;
                }
                field("Min. Amount"; Rec."Min. Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Min. Amount field.';
                }
                field("Max. Amount"; Rec."Max. Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Amount field.';
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



