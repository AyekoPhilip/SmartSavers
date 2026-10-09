page 50847 "Cheque Type"
{
    PageType = List;
    SourceTable = "Cheque Type";
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Clearing Days"; Rec."Clearing Days")
                {
                    ApplicationArea = All;
                }
                field("Clearing  Days"; Rec."Clearing  Days")
                {
                    ApplicationArea = All;
                }
                field("Cheque Period"; Rec."Cheque Period")
                {
                    ApplicationArea = All;

                }
                field("Cheque Time"; Rec."Cheque Time")
                {
                    ApplicationArea = All;

                }
                field("Cheque Limit"; Rec."Cheque Limit")
                {
                    ApplicationArea = All;
                }
                field("Clearing Charge Code"; Rec."Clearing Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Clearing Charges GL Account"; Rec."Clearing Charges GL Account")
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




