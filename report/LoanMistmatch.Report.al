report 50406 "Loan Mistmatch"
{
    ApplicationArea = All;
    Caption = 'Loan Mistmatch';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/LoanMismatch.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(LoanAccount; "Loan Account")
            {
            }
            column(CustLoanAcc; CustLoanAcc)
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

                CustLoanAcc := '';

                DetldCust.Reset();
                DetldCust.SetRange("Loan No.", "No.");
                DetldCust.SetRange("Transaction Type", DetldCust."Transaction Type"::Loan);
                if DetldCust.Find('-') then begin
                    CustLoanAcc := DetldCust."Customer No.";
                    if DetldCust."Customer No." = "Loan Account" then CurrReport.Skip();
                end;
            end;
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
    var
        DetldCust: Record "Detailed Cust. Ledg. Entry";
        CustLoanAcc: Code[100];
}
