namespace AltChannelPostMgt.AltChannelPostMgt;

page 90003 "Rcv04 Graduation Scale"
{
    ApplicationArea = All;
    Caption = 'Graduation Scale';
    PageType = List;
    SourceTable = "Rcv04 Graduation Scale";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    ToolTip = 'Specifies the value of the Lower Limit field.', Comment = '%';
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    ToolTip = 'Specifies the value of the Upper Limit field.', Comment = '%';
                }
                field("Max. Amount"; Rec."Max. Amount")
                {
                    ToolTip = 'Specifies the value of the Max. Amount field.', Comment = '%';
                }
                field(Scale; Rec.Scale)
                {
                    ToolTip = 'Specifies the value of the Scale field.', Comment = '%';
                }
            }
        }
    }
}
