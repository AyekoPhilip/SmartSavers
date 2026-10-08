page 50732 "Shares Banding"
{
    ApplicationArea = All;
    Caption = 'Shares Banding';
    PageType = List;
    SourceTable = "Shares Banding";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Minimum; Rec.Minimum)
                {
                    ToolTip = 'Specifies the value of the Minimum field.';
                    ApplicationArea = All;
                }
                field(Maximum; Rec.Maximum)
                {
                    ToolTip = 'Specifies the value of the Maximum field.';
                    ApplicationArea = All;
                }
                field("Shares Amount"; Rec."Shares Amount")
                {
                    ToolTip = 'Specifies the value of the Shares Amount field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}



