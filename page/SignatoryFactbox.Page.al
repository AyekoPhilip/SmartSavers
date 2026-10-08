page 50985 "Signatory Factbox"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Account Signatories";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control6)
            {
                ShowCaption = false;
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                }
                field(Signatory; Rec.Signatory)
                {
                    ApplicationArea = All;
                }
                field("Must Sign"; Rec."Must Sign")
                {
                    ApplicationArea = All;
                }
                field("Must be Present"; Rec."Must be Present")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




