page 50854 "Treasury Cashier List"
{
    CardPageID = "Treasury Cashier Transaction";
    Editable = false;
    PageType = List;
    SourceTable = "Treasury Cashier Transaction";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field("From Account"; Rec."From Account")
                {
                    ApplicationArea = All;
                }
                field("To Account"; Rec."To Account")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    OptionCaption = 'Teller Request,Return To Treasury,Issue From Bank,Return To Bank,Inter Teller Transfers,Branch Treasury Transactions,End of Day Return to Treasury';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;

                }
                field("Date Issued"; Rec."Date Issued")
                {
                    ApplicationArea = All;

                }
                field("Date Received"; Rec."Date Received")
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




