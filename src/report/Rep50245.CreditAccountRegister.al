report 50245 "Credit Account Register"
{
    ApplicationArea = All;
    Caption = 'Credit Account Register';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CreditAcRegister.rdl';
    dataset
    {
        dataitem(AccountCredit; "Account Credit")
        {
            RequestFilterFields="No.","Product Type",Status,"Employer Code";
            column(CompanyInformation_Name; CompanyInformation.Name)
            { }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(MemberNo; "Member No.")
            { }
            column(LastTransactionDate; "Last Transaction Date")
            { }
            column(ProductName; "Product Name")
            { }
            column(PhoneNo; "Phone No.")
            { }
            column(RegistrationDate; "Registration Date")
            { }
            column(ProductType; "Product Type")
            { }
            column(Status; Status)
            { }
            column(IDPassportNo; "ID/Passport No.")
            { }
            column(EmployerCode; "Employer Code")
            { }
            column(AccountCategory; "Account Category")
            { }
            column(AccountDimension; "Account Dimension")
            { }
            column(BalanceLCY; "Balance (LCY)")
            { }
            column(DateofBirth; "Date of Birth")
            { }
            column(StaffPayrollNo; "Staff/Payroll No.")
            { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
               // CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin

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
        SNo: Integer;
}



