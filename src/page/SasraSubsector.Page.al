page 50708 "Sasra Subsector"
{
    ApplicationArea = All;
    Caption = 'Sasra Subsector';
    PageType = List;
    SourceTable = "Sasra-Sub Sector";
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
                field(Sector; Rec.Sector)
                {
                    ToolTip = 'Specifies the value of the Sector field.';
                    ApplicationArea = All;
                }
               
            }
        }
    }
}



