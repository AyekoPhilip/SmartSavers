page 51091 "Loan Accrual Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Accrual Entries";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    Caption = 'Loan Accruals';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; Rec."Entry No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }

            }
        }
        area(Factboxes)
        {

        }
    }
}