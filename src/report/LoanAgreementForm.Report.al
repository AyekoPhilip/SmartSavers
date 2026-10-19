report 50387 "Loan Agreement Form"
{
    ApplicationArea = All;
    Caption = 'Loan Agreement Form';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoanAgreementForm.rdl';
    dataset
    {
        dataitem(LoanApplication; "Loan Application")
        {
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(EFT_Options; "EFT Options")
            { }
            column(No; "No.")
            { }
            column(AccountNo; "Account No.")
            { }
            column(AccountName; "Account Name")
            { }
            column(ApplicationDate; "Application Date")
            { }
            column(DisbursementDate; "Disbursement Date")
            { }
            column(ApprovedAmount; "Approved Amount")
            { }
            column(Installments; Installments)
            { }
            column(InterestRate; "Interest Rate")
            { }
            column(Repayment; Repayment)
            { }
            column(RepaymentStartDate; "Repayment Start Date")
            { }
            column(PrincipleRepayment; "Principle Repayment")
            { }
            column(ProductDescription; "Product Description")
            { }
            column(ProductType; "Product Type")
            { }
            column(Interest_Repayment; "Interest Repayment")
            { }
            column(DayOfMonth; DayOfMonth)
            { }
            column(CustAddress; CustAddress)
            { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City: ' + CompanyInformation.City;
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' ,Office Tel: ' +
                CompanyInformation."Phone No. 2";
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '  |  Website: ' +
                //CompanyInformation."Home Page";
            end;

            trigger OnAfterGetRecord()
            begin
                DayOfMonth := 0;
                DayOfMonth := Date2DMY("Repayment Start Date", 1);
                CustAddress := '';

                if CustMember.Get("Account No.") then
                    CustAddress := CustMember."Current Address";
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
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        DayOfMonth: Integer;
        CustMember: Record Member;
        CustAddress: Text[100];


}
