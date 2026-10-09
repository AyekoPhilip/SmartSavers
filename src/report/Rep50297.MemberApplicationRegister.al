report 50297 "Member Application Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MemberApplicationRegister.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(MemberApplication; "Member Application")
        {
            RequestFilterFields = "No.", "Application Date", "Employer Code", "Recruited By", "Approval Status", "Application Type";
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
            column(AccountType_MemberApplication; MemberApplication."Single Party/Multiple/Business")
            {
            }
            column(Name_MemberApplication; MemberApplication.Name)
            {
            }
            column(GlobalDimension1Code_MemberApplication; MemberApplication."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_MemberApplication; MemberApplication."Global Dimension 2 Code")
            {
            }
            column(RegistrationDate_MemberApplication; MemberApplication."Application Date")
            {
            }
            column(EmployerCode_MemberApplication; MemberApplication."Employer Code")
            {
            }
            column(Nationality_MemberApplication; MemberApplication.Nationality)
            {
            }
            column(PayrollStaffNo_MemberApplication; MemberApplication."Payroll No.")
            {
            }
            column(PhoneNo_MemberApplication; MemberApplication."Phone No.")
            {
            }
            column(IDNumber_MemberApplication; MemberApplication."ID No.")
            {
            }
            column(GenderMemberApplication; MemberApplication.Gender)
            {
            }
            column(DOBMemberApplication; MemberApplication."Date of Birth")
            {
            }
            column(SalespersonCode_MemberApplication; MemberApplication."Recruited By")
            {
            }
            column(MemberCategory_MemberApplication; MemberApplication."Member Category")
            {
            }
            column(CreatedBy_MemberApplication; MemberApplication."Created By")
            {
            }
            column(CountryRegionMemberApplication; MemberApplication."Country/Region")
            {
            }
            column(EmailAdd; MemberApplication."E-Mail")
            {
            }
            column(SCount; SNo)
            {
            }
            column(PINMemberApplication; MemberApplication."PIN No.")
            {
            }
            column(DutyStationMemberApplication; MemberApplication."Station/Department")
            {
            }
            column(IDTypeMemberApplication; MemberApplication."Identification Type")
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
        CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' + CompanyInformation."Home Page";
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        SNo: Integer;
}




