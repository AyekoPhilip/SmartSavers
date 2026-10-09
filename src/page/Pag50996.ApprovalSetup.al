page 50996 "Approval Setup"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Approval Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Due Date Formula"; Rec."Due Date Formula")
                {
                    ApplicationArea = All;
                }
                field("Approval Administrator"; Rec."Approval Administrator")
                {
                    ApplicationArea = All;
                }
                field("Request Rejection Comment"; Rec."Request Rejection Comment")
                {
                    ApplicationArea = All;
                }
                field(Approvals; Rec.Approvals)
                {
                    ApplicationArea = All;
                }
                field(Cancellations; Rec.Cancellations)
                {
                    ApplicationArea = All;
                }
                field(Rejections; Rec.Rejections)
                {
                    ApplicationArea = All;
                }
                field(Delegations; Rec.Delegations)
                {
                    ApplicationArea = All;
                }
                field("Last Run Time"; Rec."Last Run Time")
                {
                    ApplicationArea = All;
                }
                field("Last Run Date"; Rec."Last Run Date")
                {
                    ApplicationArea = All;
                }
                field("Overdue Template"; Rec."Overdue Template")
                {
                    ApplicationArea = All;
                }
                field("Approval Template"; Rec."Approval Template")
                {
                    ApplicationArea = All;
                }
                field("Set As Product";Rec."Set As Product")
                {
                    ApplicationArea = All;

                }
                field("Responsibility Center Required"; Rec."Responsibility Center Required")
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




