page 50641 "Rejection Comments"
{
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;

                field(RejectComment; RejectComment)
                {
                    Caption = 'Comment';
                    MultiLine = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field';
                }
            }
        }
    }

    actions
    {
    }

    var
        RejectComment: Text;

    procedure GetRejectComment(): Text
    begin
        exit(RejectComment);
    end;

    procedure SetRejectComment(Comment: Text)
    begin
        RejectComment := Comment;
    end;
}


