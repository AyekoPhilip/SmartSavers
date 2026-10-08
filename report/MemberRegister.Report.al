report 50243 "Member Register"
{
    ApplicationArea = All;
    Caption = 'Member Register';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MemberRegister.rdl';

    dataset
    {
        dataitem(Member; Member)
        {
            DataItemTableView = where("Customer Type" = filter(<> "Non-Member"));

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
            column(MemberCategory; "Member Category")
            { }
            column(Nationality; Nationality)
            { }
            column(CountryRegion; "Country/Region")
            { }
            column(County; County)
            { }
            column(CurrentAddress; "Current Address")
            { }
            column(DateofBirth; "Date of Birth")
            { }
            column(EMail; "E-Mail")
            { }
            column(EmployerCode; "Employer Code")
            { }
            column(Gender; Gender)
            { }
            column(IDNo; "ID No.")
            { }
            column(IdentificationType; "Identification Type")
            { }
            column(PINNo; "PIN No.")
            { }
            column(PassportNo; "Passport No.")
            { }
            column(PayrollStaffNo; "Payroll/Staff No.")
            { }
            column(PhoneNo; "Phone No.")
            { }
            column(RegistrationDate; "Registration Date")
            { }
            column(Status; Status)
            { }
            column(HomeAddress; "Home Address")
            { }
            column(PlotBldgStreetRoad; "Plot/Bldg/Street/Road")
            { }
            column(RejoiningDate; "Rejoining Date")
            { }
            column(StationDepartment; "Station/Department")
            { }
            column(RecruitedBy; "Recruited By")
            { }
            column(RecruitedByName; "Recruited By Name")
            { }
            column(RecruitedbyType; "Recruited by Type")
            { }
            column(MemberStation; "Member Station")
            { }
            column(MaritalStatus; "Marital Status")
            { }
            column(MemberSegment; "Member Segment")
            { }
            column(MobilePhoneNo; "Mobile Phone No")
            { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' + CompanyInformation."Home Page";

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



