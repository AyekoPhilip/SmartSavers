report 50386 "EFT Bank Details"
{
    ApplicationArea = All;
    Caption = 'EFT Bank Details';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/EFTBankDetails.rdl';
    dataset
    {
        dataitem("EFT Transfer Lines"; "EFT Transfer Lines")
        {
            RequestFilterFields = "Date Posted", "Posted By";

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
            column(External_Account_No_; "External Account No.")
            { }
            column(EFT_Options; "EFT Options")
            { }
            column(External_Account_Name; "External Account Name")
            { }
            column(Mobile_Phone_No_; "Mobile Phone No.")
            { }
            column(Bank_Code; "Bank Code")
            { }
            column(Bank_Name; "Bank Name")
            { }
            column(Member_No_; "Member No.")
            { }
            column(LineAmount; Amount)
            { }
            column(Recipient_Reference; "Recipient Reference")
            { }
            column(Own_Reference; "Own Reference")
            { }
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
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                //CompanyInformation."Home Page";

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
}
