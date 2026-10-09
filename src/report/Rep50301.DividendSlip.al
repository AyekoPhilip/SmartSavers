report 50301 "Dividend Slip"
{
    DefaultLayout = RDLC;

    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    ApplicationArea = All;
    RDLCLayout = './src/report_layout/DividendSlip2.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            column(No_; "No.")
            { }
            column(Name; Name)
            { }
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
            dataitem(DividendProgression; "Dividend Progression")
            {
                DataItemTableView = ORDER(Ascending);
                DataItemLink = "Member No" = field("No.");
                RequestFilterFields = "Member No", "Start Date", "End Date", "Employer Code";
                column(StartDate_DividendProgression; DividendProgression."End Date")
                {
                }
                column(ProductType_DividendProgression; DividendProgression."Product Type")
                {
                }
                column(ProductName_DividendProgression; DividendProgression."Product Name")
                {
                }
                column(Witholding_Tax; "Witholding Tax")
                { }
                column(QualifyingShares_DividendProgression; DividendProgression."Qualifying Shares")
                {
                }
                column(Shares_DividendProgression; DividendProgression.Shares)
                {
                }
                column(GrossDividends_DividendProgression; DividendProgression."Gross Dividends")
                {
                }
                column(Weighted_Factor;"Weighted Factor")
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

                column(Mname; MName)
                {
                }

                column(DivRate; DivRate)
                {
                }
                column(IntRate; IntRate)
                {
                }
                column(WthTax; WthTax)
                {
                }
                column(YearText;YearText)
                {}

                column(RateRetained; RateRetained)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    Retained := 0;
                    RetainedTotal := 0;
                    rates := 0;
                    MName := '';
                    YearText := '';
                    YearText := Format("Start Date", 0, '<Month Text> ');
                    if ProductFactory.Get("Product Type") then begin
                        MName := ProductFactory.Description
                    end
                end;
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
        MNo: Code[50];
        MName: Text;
        MPayrollNo: Code[10];
        Members: Record Member;
        ElectrolZone: Text;
        YearText: Text[50];
        Maddress: Text[20];
        Mcity: Text[20];
        ProductFactory: Record "Product Factory";
        DivRate: Decimal;
        IntRate: Decimal;
        WthTax: Decimal;
        Status: Enum MemberStatus;
        Retained: Decimal;
        DividendProgression1: Record "Dividend Progression";
        RetainedTotal: Decimal;
        ShareCp: Decimal;
        DepContr: Decimal;
        rates: Decimal;
        RateRetained: Text;
}




