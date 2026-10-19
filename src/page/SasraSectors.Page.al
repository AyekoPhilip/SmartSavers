page 50707 "Sasra Sectors"
{
    ApplicationArea = All;
    Caption = 'Sasra Sectors';
    PageType = List;
    SourceTable = "Sasra Sector";
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
               
            }
        }
    }
}



