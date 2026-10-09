report 50225 "Loan Provision Summary"
{
    ApplicationArea = All;
    Caption = 'Loan Provision Summary';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/LoanProvisionSummary.rdl';
    dataset
    {
        dataitem(loans; Loans)
        {

            RequestFilterFields = "No.", "Product Type", "Account No.", "Date Filter";
             DataItemTableView = where("Approval Status" = CONST(Posted), "Disbursement Date" = filter(<> ''));

            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
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
            column(Tcount; Tcount)
            { }
            column(Portfolio; Portfolio)
            { }
            column(Tprovision; Tprovision)
            { }
            column(CompanyInformation; CompanyInformation.Name)
            { }
            trigger OnPreDataItem()
            begin
                DateFilter := '..' + Format(CUTOFFDATE);
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
                SetRange("Date Filter",0D,CUTOFFDATE);
                CalcFields("Outstanding Balance", "Outstanding Principal", "Outstanding Interest");

                if "Outstanding Balance" = 0 then
                    CurrReport.Skip();

                    
            

                    if "Sasra Category" = "Sasra Category"::Performing then begin
                        PerformBal := PerformBal + "Outstanding Principal";
                        PerformBalCount := PerformBalCount + 1;
                        PerformBalProv := PerformBal * 0.01;
                    end else
                        if "Sasra Category" = "Sasra Category"::Watch then begin
                            WatchBal := WatchBal + "Outstanding Principal";
                            WatchBalCount := WatchBalCount + 1;
                            WatchBalProv := WatchBal * 0.05;
                        end else
                            if "Sasra Category" = "Sasra Category"::Substandard then begin
                                SubstandardBal := SubstandardBal + "Outstanding Principal";
                                SubstandardBalCount := SubstandardBalCount + 1;
                                SubstandardBalProv := SubstandardBal * 0.25;
                            end else
                                if "Sasra Category" = "Sasra Category"::Doubtful then begin
                                    DoubtFullBal := DoubtFullBal + "Outstanding Principal";
                                    DoubtFullBalCount := DoubtFullBalCount + 1;
                                    DoubtFullBalProv := DoubtFullBal * 0.5;
                                end else begin
                                    LossBal := LossBal + "Outstanding Principal";
                                    LossBalCount := LossBalCount + 1;
                                    LossBalProv := LossBal * 1.0;
                                end;

                    Tcount := (PerformBalCount + WatchBalCount + SubstandardBalCount + DoubtFullBalCount + LossBalCount);
                    Portfolio := (PerformBal + WatchBal + SubstandardBal + DoubtFullBal + LossBal);
                    Tprovision := (PerformBalProv + WatchBalProv + SubstandardBalProv + DoubtFullBalProv + LossBalProv);

                

                
            END;

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
                    field(CUTOFFDATE; CUTOFFDATE)
                    {
                        ApplicationArea = All;
                        Caption = 'Cutoff Date';
                    }

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
        CompanyAddress, DateFilter : Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CUTOFFDATE: Date;
        loanscate: Record "Loans Categorization";
}



