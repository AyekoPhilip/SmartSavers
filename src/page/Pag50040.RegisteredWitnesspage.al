page 50040 "Registered Witness page"
{
    ApplicationArea = All;
    Caption = 'Registered Witness page';
    PageType = List;
    SourceTable = "Segment/County/Dividend/Signat";
    UsageCategory = Lists;
    Editable=false;
    ModifyAllowed=false;
    DeleteAllowed=false;
    InsertAllowed=false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}



