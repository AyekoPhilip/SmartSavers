report 50310 "Cashier Transactions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CashierTransactions.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Teller Transaction"; "Teller Transaction")
        {
            RequestFilterFields = "No.", "Account No.", Type, Posted, "Transaction Date", "Cheque Date", "Expected Maturity Date", Cashier;
            column(Picture; CompanyInfo.Picture)
            {
            }
            /* column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            } */
            column(us; UserId)
            {
            }
            column(date; Format(Today, 0, 4))
            {
            }
            column(CompName; CompanyName)
            {
            }
            column(No; "Teller Transaction"."No.")
            {
            }
            column(Acount; "Teller Transaction"."Account No.")
            {
            }
            column(TransType; "Teller Transaction".Type)
            {
            }
            column(TransDate; "Teller Transaction"."Transaction Date")
            {
            }
            column(Amount; "Teller Transaction".Amount)
            {
            }
            column(Cashier; "Teller Transaction".Cashier)
            {
            }
            column(CheDate; "Teller Transaction"."Cheque Date")
            {
            }
            column(CheqNo; "Teller Transaction"."Cheque No")
            {
            }
            column(ExpectedMaturity; "Teller Transaction"."Expected Maturity Date")
            {
            }
            column(BankerCheqNo; "Teller Transaction"."Bankers Cheque No")
            {
            }
            column(Dim2; "Teller Transaction"."Global Dimension 2 Code")
            {
            }
            column(Posti; "Teller Transaction".Posted)
            {
            }
            column(MemberName; MemberName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if SavingsAccounts.Get(SavingsAccounts."No.") then
                    MemberName := SavingsAccounts.Name;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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
        CompanyInfo: Record "Company Information";
        MemberName: Text;
        SavingsAccounts: Record "Account Banking";
}




