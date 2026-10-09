namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.Company;

report 50026 "PrAllowanceDeduct"
{
    ApplicationArea = All;
    Caption = 'Allowance and Deductions';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/PayrollAllowance.rdl';
    dataset
    {
        dataitem(PrPeriodTrans; "Pr Period Transaction")
        {
            RequestFilterFields = "Employee Code", "Payroll Period";
            DataItemTableView = where("Transaction Type" = filter(Income));
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
            column(Employee_Code; "Employee Code")
            {
            }
            column(Transaction_Code; "Transaction Code")
            { }
            column(Transaction_Name; "Transaction Name")
            { }
            column(SelectedPeriod;"Payroll Period")
            { }
            column(AmountPosted; AmountPosted)
            { }
            column(BasicPay; BasicPay)
            { }
            column(Description; Description)
            { }
            column(Amount; Amount)
            { }
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
                if HrObject.Get("Employee Code") then begin
                    Description := HrObject.Name
                end;
                if "Transaction Code" = 'BPAY' then begin
                end else begin

                    PrTransactioncode.Reset();
                    PrTransactioncode.SetRange(Code, "Transaction Code");
                    if not PrTransactioncode.Find('-') then begin
                        CurrReport.Skip();
                    end
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
                group(Period)
                {
                    field(SelectedPeriod; SelectedPeriod)
                    {
                        ApplicationArea = All;
                        Caption = 'Payroll Period';
                        TableRelation = "Pr Payroll Period";
                    }
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
}
