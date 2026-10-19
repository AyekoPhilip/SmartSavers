report 50296 "Dividend Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DividendStatement2.rdl';
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(DividendProgression; "Dividend Progression")
        {
            RequestFilterFields = "Start Date", "End Date";
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
            column(StartDate_DividendProgression; CalcDate('-CM', DividendProgression."Start Date"))
            {
            }
            column(ProductType_DividendProgression; DividendProgression."Product Type")
            {
            }
            column(ProductName_DividendProgression; DividendProgression."Product Name")
            {
            }
            column(QualifyingShares_DividendProgression; DividendProgression."Qualifying Shares")
            {
            }
            column(Shares_DividendProgression; DividendProgression.Shares)
            {
            }
            column(GrossDividends_DividendProgression; DividendProgression."Gross Dividends")
            {
            }
            column(WitholdingTax_DividendProgression; DividendProgression."Witholding Tax")
            {
            }
            column(NetDividends_DividendProgression; DividendProgression."Net Dividends")
            {
            }
            column(No_Members; DividendProgression."Member No")
            {
            }
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
}




