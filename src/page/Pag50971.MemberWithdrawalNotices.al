page 50971 "Member Withdrawal Notices"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Member withdrawal Notice";
    SourceTableView = where(Paid = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                 field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Closure Type";Rec."Closure Type")
                {
                    ApplicationArea = All;

                }
               
                field("Reason for withdrawal"; Rec."Reason for withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Description For Withdrawal"; Rec."Description For Withdrawal")
                {
                    ApplicationArea = All;
                    ShowCaption = false;

                }
                field("Withdrawa Noticel Date"; Rec."Withdrawal Notice Date")
                {
                    ApplicationArea = All;
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
                {
                    ApplicationArea = All;
                }
                field(Expired; Rec.Expired)
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




