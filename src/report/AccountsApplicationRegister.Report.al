report 50298 "Accounts Application Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/AccountsApplicationRegister.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(MemberApplication; "Account Application")
        {
            RequestFilterFields = "No.", "Negotiated Interest Rate", "Account Type", "Account Source", "Fixed Deposit Type";
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
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
            column(No_MemberApplication; MemberApplication."No.")
            {
            }
            column(Name_MemberApplication; MemberApplication.Name)
            {
            }
            column(GlobalDimension1Code_MemberApplication; MemberApplication.Blocked)
            {
            }
            column(GlobalDimension2Code_MemberApplication; MemberApplication."Last Date Modified")
            {
            }
            column(RegistrationDate_MemberApplication; MemberApplication."Application Date")
            {
            }
            column(EmployerCode_MemberApplication; MemberApplication."Negotiated Interest Rate")
            {
            }
            column(Nationality_MemberApplication; MemberApplication."Registration Date")
            {
            }
            column(PayrollStaffNo_MemberApplication; MemberApplication."Fixed Deposit Cert. No.")
            {
            }
            column(PhoneNo_MemberApplication; MemberApplication."Application Date")
            {
            }
            column(IDNumber_MemberApplication; MemberApplication."Group Type")
            {
            }
            column(BirthCertificateNo_MemberApplication; MemberApplication."Birth Certificate No.")
            {
            }
            column(GroupAccountNo_MemberApplication; MemberApplication."Account Source")
            {
            }
            column(SalespersonCode_MemberApplication; MemberApplication."Global Dimension 2 Filter")
            {
            }
            column(CreatedBy_MemberApplication; MemberApplication."Created By")
            {
            }
            column(Source_MemberApplication; MemberApplication."Account Source")
            {
            }
            column(Status_MemberApplication; MemberApplication."Account Type")
            {
            }
            column(SCount; SNo)
            {
            }
            column(ProductType_MemberApplication; MemberApplication."Posted By")
            {
            }
            column(ProductName_MemberApplication; MemberApplication."CRM Application No.")
            {
            }
            column(ParentAccountNo_MemberApplication; MemberApplication."Parent Account No.")
            {
            }
            column(ProductCategory_MemberApplication; MemberApplication."Account Type")
            {
            }
            column(ApplicationDate_MemberApplication; MemberApplication."Application Date")
            {
            }

            trigger OnAfterGetRecord()
            begin
                SNo += 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if CompanyInformation.Get then
            CompanyInformation.CalcFields(CompanyInformation.Picture);
        CompanyAddress := CompanyInformation.Address + ' -Post Code: ' + CompanyInformation."Post Code" + ' -City:' + CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
        CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
        //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' + CompanyInformation."Home Page";
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        SNo: Integer;
}




