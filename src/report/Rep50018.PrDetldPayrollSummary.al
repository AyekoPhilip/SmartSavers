namespace DynamicsNav.SaccoDatabase.PayrollMgt;
using Microsoft.Sales.Customer;

report 50018 "Pr Detld. Payroll Summary"
{
    ApplicationArea = All;
    Caption = 'Detailed Payroll Summary';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/DetailedPayrollSummary.rdl';
    dataset
    {
        dataitem(PrPeriodTransaction; "Pr Period Transaction")
        {
            RequestFilterFields = "Employee Code", "Transaction Code", "Payroll Period";
            DataItemTableView = sorting("Transaction Type") order(ascending);
            column(EmployeeCode; "Employee Code")
            {
            }
            column(TransactionCode; "Transaction Code")
            {
            }
            column(TransactionName; "Transaction Name")
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Balance; Balance)
            {
            }
            column(CoopParameters; "Coop Parameters")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(GroupText; "Group Text")
            {
            }
            column(GroupOrder; "Group Order")
            {
            }
            column(PayrollPeriod; "Payroll Period")
            {
            }
            column(PeriodFilter; "Period Filter")
            {
            }
            column(PeriodMonth; "Period Month")
            {
            }
            column(PeriodYear; "Period Year")
            {
            }
            column(PostAs; "Post As")
            {
            }
            column(ReferenceNo; "Reference No.")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                case "Transaction Code" of
                    'DEFCON',
                    'HSELVR',
                    'NHIFR',
                    'PNSR',
                    'PSNR',
                    'TXBP',
                    'TXCHRG':
                        begin
                            CurrReport.Skip();
                        end;
                end;

            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
    CustRec: Record Customer;

}
