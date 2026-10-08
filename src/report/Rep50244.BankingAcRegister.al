report 50244 "Banking Ac Register"
{
    ApplicationArea = All;
    Caption = 'Banking Ac Register';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/BankingAcRegister.rdl';

    dataset
    {
        dataitem(AccountBanking; "Account Banking")
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
            
            column(Last_Transaction_Date; "Last Transaction Date")
            { }
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(Old_Account_No_;"Old Account No.")
            {
                
            }
            column(LastTransactionDate; "Last Transaction Date")
            {
            }
            column(LastWithdrawalDate; "Last Withdrawal Date")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(ParentAccountNo; "Parent Account No.")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(Last_Date_Modified_Dormancy;"Last Date Modified-Dormancy")
            {

            }
            column(ProductType; "Product Type")
            {
            }
            column(Status; Status)
            {
            }
            column(UnclearedCheques; "Uncleared Cheques")
            {
            }
            column(UntranferredInterest; "Untranferred Interest")
            {
            }
            column(InterestTransferred; "Interest Transferred")
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
            column(ATMTransactions; "ATM Transactions")
            {
            }
            column(BalanceLCY; "Balance (LCY)")
            {
            }
            column(DateofBirth; "Date of Birth")
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(LienPlaced; "Lien Placed")
            {
            }
            column(StaffPayrollNo; "Staff/Payroll No.")
            {
            }
            column(Withdrawal_Date;"Withdrawal Date")
            {}
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



