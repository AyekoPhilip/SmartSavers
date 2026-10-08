namespace DynamicsNav.SaccoDatabase.PayrollMgt;

using Microsoft.Foundation.Company;
using DynamicsNav.SaccoDatabase.HrManagementMgt;

report 50027 "Payroll Loan Deductions"
{
    ApplicationArea = All;
    Caption = 'Payroll Loan Deductions';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/PayrollSaccodeduction.rdl';
    dataset
    {
        dataitem(PrPeriodTransaction; "Pr Period Transaction")
        {
            RequestFilterFields = "Employee Code", "Payroll Period", "Account Type";
            DataItemTableView = where("Account Type" = filter(Loan | Credit));

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
            column(Description; Description)
            { }
            column(EmployeeCode; "Employee Code")
            {
            }
            column(TransactionCode; "Transaction Code")
            {
            }
            column(TransactionName; "Transaction Name")
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
            column(ProdType; ProdType)
            { }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Balance; Balance)
            {
            }
            column(PayrollPeriod; "Payroll Period")
            {
            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City;
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";
                // + '- Website: ' +CompanyInformation."Home Page";
            end;

            trigger OnAfterGetRecord()
            begin
                Description := '';
                ProdType := '';
                if HrObject.Get("Employee Code") then begin
                    Description := HrObject.Name
                end;

                case "Account Type" of

                    "Account Type"::Loan:
                        begin
                            if Loan.Get("Loan No.") then
                                ProdType := Loan."Product Description"
                        end;
                    "Account Type"::Credit:
                        begin
                            if CredAcc.Get("Account No.") then begin
                                ProdType := CredAcc."Product Name"
                            end
                        end;
                    "Account Type"::Saving:
                        begin
                            if AccBanking.Get("Account No.") then begin
                                ProdType := AccBanking."Product Name"
                            end
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
        ProdType: Text[150];
        Pfact: Record "Product Factory";
        AccBanking: Record "Account Banking";
        CredAcc: Record "Account Credit";

}
