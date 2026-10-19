namespace DynamicsNav.SaccoDatabase.PayrollMgt;

using Microsoft.Foundation.Company;
using DynamicsNav.SaccoDatabase.HrManagementMgt;

report 90012 "Payroll Deduction"
{
    ApplicationArea = All;
    Caption = 'Payroll Deduction';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/GroupedPayrollDeduction.rdl';
    dataset
    {
        dataitem(PrPeriodTransaction; "Pr Period Transaction")
        {
            RequestFilterFields = "Employee Code", "Payroll Period", "Transaction Code";
            column(CompInformation; CompanyInformation.Name)
            {
            }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyTelephone; CompanyTelephone)
            {
            }
            column(CommunicationOnline; CommunicationOnline)
            {
            }
            column(EmployeeCode; "Employee Code")
            {
            }
            column(PeriodMonth; "Period Month")
            {
            }
            column(PeriodYear; "Period Year")
            {
            }
            column(TransactionCode; "Transaction Code")
            {
            }
            column(TransactionName; "Transaction Name")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(LoanTransactionType; "Loan Transaction Type")
            {
            }
            column(CoopParameters; "Coop Parameters")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Balance; Balance)
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(PayrollPeriod; "Payroll Period")
            {
            }
            column(SubGroupOrder; "Sub Group Order")
            {
            }
            column(GroupOrder; "Group Order")
            {
            }
            column(strnlNameTxt; strnlNameTxt)
            { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
            end;
            trigger OnAfterGetRecord()
            begin
                strnlNameTxt := '';
                if HrEmployee.Get("Employee Code") then begin
                    strnlNameTxt := HrEmployee.Name
                end
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
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;

    var

        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        PrTransactioncode: Record "Pr Transaction Code";
        CompanyTelephone: Text;
        HrObject: Record "Hr Employees";
        CommunicationOnline: Text;
        SelectedPeriod: Date;
        Loan: Record Loans;
        Description: Text[150];
        AmountPosted: Decimal;
        BasicPay: Decimal;
        LoanBal: Decimal;
        HrEmployee: Record "Hr Employees";
        strnlNameTxt: Text[150];
}
