page 50963 "Loan Purpose"
{
    PageType = List;
    SourceTable = "Loan Purpose";
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Date Filter";Rec."Date Filter")
                {

                }
                field(Sector; Rec.Sector)
                {
                    ApplicationArea = All;
                }
                field("Sub Sector"; Rec."Sub Sector")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
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




