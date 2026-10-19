report 50267 "Account Balance-Credit"
{
    ApplicationArea = All;
    Caption = 'Account Balances';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/AccountCreditBalance.rdl';
    dataset
    {
        dataitem(AccountBanking; "Account Credit")
        {
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
            {
            }
            column(Gender;Gender)
            {}
            column(Name; Name)
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(LastTransactionDate; "Last Transaction Date")
            {
            }

            column(Last_Date_Modified_Dormancy; "Last Date Modified-Dormancy")
            { }
            column(ProductName; "Product Name")
            {
            }

            column(PhoneNo; "Phone No.")
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(Status; Status)
            {
            }

            column(IDPassportNo; "ID/Passport No.")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(BalanceLCY; "Balance (LCY)")
            {
            }
            column(DateofBirth; "Date of Birth")
            {
            }
            column(EMail; EmailAdress)
            {
            }

            column(StaffPayrollNo; "Staff/Payroll No.")
            {
            }
            trigger OnPreDataItem()
            begin

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                if CustMember.Get("Member No.") then
                    EmailAdress := CustMember."E-Mail";

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
        CustMember: Record Member;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        SNo: Integer;
        EmailAdress: Code[50];
}



