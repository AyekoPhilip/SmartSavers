report 50312 "Treasury Coinage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/TreasuryCoinage.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Treasury Cashier Transaction"; "Treasury Cashier Transaction")
        {
            column(No_TreasuryCashierTransactions; "Treasury Cashier Transaction".No)
            {
            }
            column(TransactionDate_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Transaction Date")
            {
            }
            column(TransactionType_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Transaction Type")
            {
            }
            column(FromAccount_TreasuryCashierTransactions; "Treasury Cashier Transaction"."From Account")
            {
            }
            column(ToAccount_TreasuryCashierTransactions; "Treasury Cashier Transaction"."To Account")
            {
            }
            column(Description_TreasuryCashierTransactions; "Treasury Cashier Transaction".Description)
            {
            }
            column(Amount_TreasuryCashierTransactions; "Treasury Cashier Transaction".Amount)
            {
            }
            column(Posted_TreasuryCashierTransactions; "Treasury Cashier Transaction".Posted)
            {
            }
            column(DatePosted_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Date Posted")
            {
            }
            column(TimePosted_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Time Posted")
            {
            }
            column(FromAccountName_TreasuryCashierTransactions; "Treasury Cashier Transaction"."From Account Name")
            {
            }
            column(ToAccountName_TreasuryCashierTransactions; "Treasury Cashier Transaction"."To Account Name")
            {
            }
            column(ActualCashAtHand_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Actual Cash At Hand")
            {
            }
            column(ResponsibilityCenter_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Responsibility Center")
            {
            }
            column(Status_TreasuryCashierTransactions; "Treasury Cashier Transaction".Status)
            {
            }
            column(Type_TreasuryCashierTransactions; "Treasury Cashier Transaction".Type)
            {
            }
            column(FromTill_TreasuryCashierTransactions; "Treasury Cashier Transaction"."From Till")
            {
            }
            column(ToTill_TreasuryCashierTransactions; "Treasury Cashier Transaction"."To Till")
            {
            }
            column(ExcessShortageAmount_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Excess/Shortage Amount")
            {
            }
            column(DateIssued_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Date Issued")
            {
            }
            column(TimeIssued_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Time Issued")
            {
            }
            column(IssueReceived_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Issue Received")
            {
            }
            column(DateReceived_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Date Received")
            {
            }
            column(TimeReceived_TreasuryCashierTransactions; "Treasury Cashier Transaction"."Time Received")
            {
            }
            column(KampInfoName; KampInfo.Name)
            {
            }
            column(KampInfoAddress; KampInfo.Address)
            {
            }
            column(KampInfoPicture; KampInfo.Picture)
            {
            }
            dataitem(Coinage; Coinage)
            {
                DataItemLink = No = FIELD(No);
                column(No_Coinage; Coinage.No)
                {
                }
                column(Code_Coinage; Coinage.Code)
                {
                }
                column(Description_Coinage; Coinage.Description)
                {
                }
                column(Type_Coinage; Coinage.Type)
                {
                }
                column(Value_Coinage; Coinage.Value)
                {
                }
                column(Quantity_Coinage; Coinage.Quantity)
                {
                }
                column(TotalAmount_Coinage; Coinage."Total Amount")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                KampInfo.Get;
                KampInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        KampInfo: Record "Company Information";
}




