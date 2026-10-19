namespace SaccoDatabase.SaccoDatabase;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;

report 90018 "Loan Register List"
{
    ApplicationArea = All;
    Caption = 'Loan Register List';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    ExcelLayout = './src/report_layout/RegisteredLoanlist.xlsx';
    RDLCLayout = './src/report_layout/RegisteredLoanlist.rdl';

    dataset
    {
        dataitem(Loans; Loans)
        {
            //DataItemTableView = where("Outstanding Balance" = filter(<> 0));
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Date Filter";
            column(No; "No.")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(Gender; Gender)
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApprovalDate; "Approval Date")
            {
            }
            column(InterestPaid; "Rcv Interest Paid") { }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(Installments; Installments)
            {
            }
            column(LoanStatus; "Loan Status")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(Repayment; Repayment)
            {
            }
            column(RepaymentFrequency; "Repayment Frequency")
            {
            }
            column(employername; employername)
            {

            }

            column(Months_In_arrears; "Months In arrears")
            {

            }
            column(Amount_in_Arrears; "Amount in Arrears")
            {

            }
            trigger OnPreDataItem()
            begin



                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
            end;

            trigger OnAfterGetRecord()
            begin

                employername := '';
                if memberlist.get(Loans."Account No.") then begin

                    if employee.get(memberlist."Employer Code") then begin
                        employername := employee.Name;

                    end;



                end;
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
        Company: Record "Company Information";
        LoanAppcharges: Record "Loan Product Charges";
        TopUpComms: Decimal;
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CompanyInformation: Record "Company Information";
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        ExciseDuty: Decimal;
        GeneralSetUp: Record "General Set-Up";
        Loan: Record Loans;
        MinuteNo: Code[50];
        IntRate: Decimal;
        FactP: Record "Product Factory";
        ShowAccountZeroBal: Boolean;
        BosaAc: Record "Account Credit";
        BalanceLCY: Decimal;
        memberlist: Record Member;
        employername: code[150];
        employee: Record Customer;

}





