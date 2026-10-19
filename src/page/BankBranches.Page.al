page 50434 "Bank Branches"
{
    PageType = List;
    SourceTable = "Bank Branches";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Code field';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Name field';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Stopped; Rec.Stopped)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stopped field.';
                }
            }
        }
    }

    actions
    {
    }
}


