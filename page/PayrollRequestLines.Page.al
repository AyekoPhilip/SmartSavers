page 50579 "Payroll Request Lines"
{
    PageType = ListPart;
    SourceTable = "Payroll Request Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name field';
                }
                field("Previous Value"; Rec."Previous Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Previous Value field';
                }
                field("New Value"; Rec."New Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Value field';
                }
                field(Change; Rec.Change)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Change field';
                }
            }
        }
    }

    actions
    {
    }
}


