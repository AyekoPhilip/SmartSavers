page 50761 "Notice List-Approved"
{
    CardPageID = "Member withdrawal Notice";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Member withdrawal Notice";
    SourceTableView = WHERE("Approval Status" = CONST(Approved),
                            Paid = CONST(false));
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
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Reason for withdrawal"; Rec."Reason for withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Withdrawa Noticel Date"; Rec."Withdrawal Notice Date")
                {
                    Caption = 'Withdrawal Notice Date';
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
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




