report 50253 "Existing Deposit Multiplier"
{
    ApplicationArea = All;
    Caption = 'Existing Deposit Multiplier';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DepositMultiplier.rdl';
    dataset
    {
        dataitem(DepositMultiplier; "Deposit Multiplier")
        {
            column(AccountNo; "Account No.")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(DepositMultiplierL; "Deposit Multiplier")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}



