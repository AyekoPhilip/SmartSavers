report 50235 "Loan Provision-Products"
{
    ApplicationArea = All;
    Caption = 'Loan Provision-Products';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoanProvisionProduct.rdl';

    dataset
    {
        dataitem(ProductFactory; "Product Factory")
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
            column(ProductID; "Product ID")
            { }
            column(Description; Description)
            { }
            column(PerformBal; PerformBal)
            { }
            column(PerformBalCount; PerformBalCount)
            { }
            column(PerformBalProv; PerformBalProv)
            { }
            column(WatchBal; WatchBal)
            { }
            column(WatchBalCount; WatchBalCount)
            { }
            column(WatchBalProv; WatchBalProv)
            { }
            column(SubstandardBal; SubstandardBal)
            { }
            column(SubstandardBalCount; SubstandardBalCount)
            { }
            column(SubstandardBalProv; SubstandardBalProv)
            { }
            column(DoubtFullBal; DoubtFullBal)
            { }
            column(DoubtFullBalCount; DoubtFullBalCount)
            { }
            column(DoubtFullBalProv; DoubtFullBalProv)
            { }
            column(LossBal; LossBal)
            { }
            column(LossBalCount; LossBalCount)
            { }
            column(LossBalProv; LossBalProv)
            { }
            trigger OnPreDataItem()
            begin
                if EndDate = 0D then EndDate := Today;
                if StartDate = 0D then StartDate := 20190101D;

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";



            end;

            trigger OnAfterGetRecord()
            begin
                PerformBal := 0;
                PerformBalCount := 0;
                PerformBalProv := 0;
                WatchBal := 0;
                WatchBalCount := 0;
                WatchBalProv := 0;
                SubstandardBal := 0;
                SubstandardBalCount := 0;
                SubstandardBalProv := 0;
                DoubtFullBal := 0;
                DoubtFullBalCount := 0;
                DoubtFullBalProv := 0;
                LossBal := 0;
                LossBalCount := 0;
                LossBalProv := 0;


                DateFilter := Format(StartDate) + '..' + Format(EndDate);

                PostedLoan.Reset();
                PostedLoan.SetFilter("Date Filter", DateFilter);
                PostedLoan.SetRange("Product Type", "Product ID");
                PostedLoan.SetFilter("Outstanding Balance", '>0');
                PostedLoan.SetRange("Performance Indicator", PostedLoan."Performance Indicator"::Performing);
                if PostedLoan.FindSet() then begin
                    PerformBalCount := PostedLoan.Count;
                    repeat
                        PostedLoan.CalcFields("Outstanding Interest", "Outstanding Balance");
                        PerformBal := PerformBal + PostedLoan."Outstanding Balance";
                        PerformBalProv := PerformBalProv + (PerformBal * 0.01);
                    until PostedLoan.Next() = 0;
                end;

                PostedLoan.Reset();
                PostedLoan.SetFilter("Date Filter", DateFilter);
                PostedLoan.SetRange("Product Type", "Product ID");
                PostedLoan.SetFilter("Outstanding Balance", '>0');
                PostedLoan.SetRange("Performance Indicator", PostedLoan."Performance Indicator"::Watch);
                if PostedLoan.FindSet() then begin
                    WatchBalCount := PostedLoan.Count;
                    repeat
                        PostedLoan.CalcFields("Outstanding Interest", "Outstanding Balance");
                        WatchBal := WatchBal + PostedLoan."Outstanding Balance";
                        WatchBalProv := WatchBalProv + (WatchBal * 0.01);
                    until PostedLoan.Next() = 0;
                end;

                PostedLoan.Reset();
                PostedLoan.SetFilter("Date Filter", DateFilter);
                PostedLoan.SetRange("Product Type", "Product ID");
                PostedLoan.SetFilter("Outstanding Balance", '>0');
                PostedLoan.SetRange("Performance Indicator", PostedLoan."Performance Indicator"::Substandard);
                if PostedLoan.FindSet() then begin
                    SubstandardBalCount := PostedLoan.Count;
                    repeat
                        PostedLoan.CalcFields("Outstanding Interest", "Outstanding Balance");
                        SubstandardBal := SubstandardBal + PostedLoan."Outstanding Balance";
                        SubstandardBalProv := SubstandardBalProv + (SubstandardBal * 0.01);
                    until PostedLoan.Next() = 0;
                end;

                PostedLoan.Reset();
                PostedLoan.SetFilter("Date Filter", DateFilter);
                PostedLoan.SetRange("Product Type", "Product ID");
                PostedLoan.SetFilter("Outstanding Balance", '>0');
                PostedLoan.SetRange("Performance Indicator", PostedLoan."Performance Indicator"::Doubtfull);
                if PostedLoan.FindSet() then begin
                    DoubtFullBalCount := PostedLoan.Count;
                    repeat
                        PostedLoan.CalcFields("Outstanding Interest", "Outstanding Balance");
                        DoubtFullBal := DoubtFullBal + PostedLoan."Outstanding Balance";
                        DoubtFullBalProv := DoubtFullBalProv + (DoubtFullBal * 0.01);
                    until PostedLoan.Next() = 0;
                end;

                PostedLoan.Reset();
                PostedLoan.SetFilter("Date Filter", DateFilter);
                PostedLoan.SetRange("Product Type", "Product ID");
                PostedLoan.SetFilter("Outstanding Balance", '>0');
                PostedLoan.SetRange("Performance Indicator", PostedLoan."Performance Indicator"::Loss);
                if PostedLoan.FindSet() then begin
                    LossBalCount := PostedLoan.Count;
                    repeat
                        PostedLoan.CalcFields("Outstanding Interest", "Outstanding Balance");
                        LossBal := LossBal + PostedLoan."Outstanding Balance";
                        LossBalProv := LossBalProv + (LossBal * 0.01);
                    until PostedLoan.Next() = 0;
                end;


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
        DateFilter: Text[100];
        StartDate: Date;
        EndDate: Date;
        PostedLoan: Record "Loans Categorization";
        PerformBal: Decimal;
        WatchBal: Decimal;
        SubstandardBal: Decimal;
        DoubtFullBal: Decimal;
        LossBal: Decimal;
        PerformBalProv: Decimal;
        WatchBalProv: Decimal;
        SubstandardBalProv: Decimal;
        DoubtFullBalProv: Decimal;
        Tcount: Integer;
        Portfolio: Decimal;
        Tprovision: Decimal;
        LossBalProv: Decimal;
        PerformBalCount: Integer;
        WatchBalCount: Integer;
        SubstandardBalCount: Integer;
        DoubtFullBalCount: Integer;
        LossBalCount: Integer;
        Over3Month: Decimal;
        TotMonths: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
}



