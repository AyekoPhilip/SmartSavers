page 50459 "Attachments Setup"
{
    PageType = List;
    SourceTable = Attachments;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Attachment; Rec.Attachment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attachment field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
            }
        }
    }

    actions
    {
    }
}


