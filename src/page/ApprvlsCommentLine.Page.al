page 50752 "Apprvls Comment Line"
{
    Caption = 'Approval Comment';
    PageType = StandardDialog;
    SourceTable = "Apprvals. Comment Line";
    Editable = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Comment; Rec.Comment)
                {
                    Caption = 'Comment';
                    ApplicationArea = All;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the value of the Comment field';
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;

                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;

                }
                field("Table ID"; Rec."Table ID")
                {
                    Editable = false;

                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
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



