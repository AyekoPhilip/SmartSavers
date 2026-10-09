report 90002 "Dividend Slip Portal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DivSlip2.rdl';
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(DividendProgression; "Dividend Progression")
        {
            DataItemTableView =sorting("Rcv Deposit Date") where("Rcv Document Source" = filter("Online Slip"));
            RequestFilterFields = "Member No", "Start Date", "End Date", "Employer Code";
            column(CompanyInformation_Name; CompanyInformation.Name)
            {}
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {}
            column(CompanyAddress; CompanyAddress)
            {}
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(Start_Date; "Start Date")
            { }
            column(GrossNegatedDiv; GrossNegatedDiv)
            { }
            column(NetNegatedDiv; NetNegatedDiv) { }
            column(WTaxNegatedDiv; WTaxNegatedDiv) { }
            column(End_Date; "End Date")
            { }
            column(MonthText; "Rcv Deposit Date")
            { }
            column(StartDate_DividendProgression; DividendProgression."End Date")
            { }
            column(Account_Category; "Rcv Account Category")
            { }
            column(Account_Dimension; "Rcv Account Dimension")
            { }
            column(ProductType_DividendProgression; DividendProgression."Product Type")
            { }
            column(ProductName_DividendProgression; DividendProgression."Product Name")
            { }
            column(QualifyingShares_DividendProgression; DividendProgression."Qualifying Shares")
            { }
            column(Shares_DividendProgression; DividendProgression.Shares)
            { }
            column(GrossDividends_DividendProgression; DividendProgression."Gross Dividends")
            { }
            column(WitholdingTax_DividendProgression; DividendProgression."Witholding Tax")
            {
            }
            column(NetDividends_DividendProgression; DividendProgression."Net Dividends")
            { }
            column(No_Members; DividendProgression."Member No")
            { }
            column(ElectrolZone; ElectrolZone)
            { }
            column(Maddress; Maddress)
            { }
            column(Mcity; Mcity)
            { }
            column(Mname; MName)
            { }
            column(MPayrollNo; MPayrollNo)
            {
            }
            column(MNo; MNo)
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
            column(Status; Status)
            {
            }
            column(Retained; Retained)
            {
            }
            column(RetainedTotal; RetainedTotal)
            {
            }
            column(rates; rates)
            {
            }
            column(RateRetained; RateRetained)
            {
            }
            trigger OnPreDataItem()
            begin
                ShowAll := true;
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' + CompanyInformation."Post Code" + ' -City:' + CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";
            end;

            trigger OnAfterGetRecord()
            begin

                RetainedTotal := 0;
                rates := 0;
                IntRate := 0;

                DividendSetUp.Get();
                DividendSetUp.TestField("Start Date");
                DividendSetUp.TestField("End Date");

                ShowAll := false;

                InterestOptions := InterestOptions::"Daily Basis";
                Retained := getnegatedvalue("Member No", "Header No.");
                GrossNegatedDiv := getnegatedvalueGrossDiv("Member No", "Header No.");
                WTaxNegatedDiv := getnegatedvalueWTax("Member No", "Header No.");
                NetNegatedDiv := getnegatedvalueNetDiv("Member No", "Header No.");

                if not ShowAll then begin
                    if "Gross Dividends" < 0 then CurrReport.Skip();
                end;

                Members.Reset;
                Members.SetRange("No.", DividendProgression."Member No");
                if Members.Find('-') then begin
                    ElectrolZone := Members."Electrol Zone";
                    Maddress := Members."E-Mail";
                    Mcity := Members.City;
                    MName := Members.Name;
                    MNo := Members."No.";
                    MPayrollNo := Members."Payroll/Staff No.";
                    Status := Members.Status;
                end;

                CredAccount.Reset();
                CredAccount.SetRange("Member No.", DividendProgression."Member No");
                CredAccount.SetFilter("Date Filter", Datefilter);
                CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Deposit");
                if CredAccount.FindFirst() then begin
                    CredAccount.CalcFields("Balance (LCY)");
                    RetainedTotal := CredAccount."Balance (LCY)"
                end;

                MonthText := '';
                if "Rcv Interest Options" = "Rcv Interest Options"::" " then
                    MonthText := Format("Start Date", 0, '<Month Text>') else
                    MonthText := Format("Rcv Deposit Date", 0, '<Month Text>');

                ProductFactory.Reset();
                ProductFactory.SetRange("Product ID", "Product Type");
                if ProductFactory.FindFirst() then begin
                    case ProductFactory."Account Category" of
                        ProductFactory."Account Category"::"Shares Capital":
                            begin
                                DivRate := ProductFactory."Interest Rate (Max.)";
                                WthTax := ProductFactory."WithHolding Tax";
                            end;
                        ProductFactory."Account Category"::"Shares Deposit":
                            begin
                                IntRate := ProductFactory."Interest Rate (Max.)";
                                WthTax := ProductFactory."WithHolding Tax";
                            end;
                    end;
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
            area(Content)
            {
                group(Option)

                {
                    field(ShowAll; ShowAll)
                    {
                        Caption = 'Show All';
                        ApplicationArea = All;
                    }
                }
            }
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

    end;

    local procedure getnegatedvalue(CustNo: Code[50]; DocumenNo: Code[50]): Decimal

    begin
        DividendProgression1.Reset();
        DividendProgression1.SetRange("Member No", CustNo);
        DividendProgression1.SetFilter(Shares, '< 0');
        DividendProgression1.SetRange("Header No.", DocumenNo);
        if DividendProgression1.FindSet() then begin
            DividendProgression1.CalcSums(Shares);
            exit(DividendProgression1.Shares * -1)
        end;
    end;

    local procedure getnegatedvalueGrossDiv(CustNo: Code[50]; DocumenNo: Code[50]): Decimal

    begin
        DividendProgression1.Reset();
        DividendProgression1.SetRange("Member No", CustNo);
        DividendProgression1.SetFilter(Shares, '< 0');
        DividendProgression1.SetRange("Header No.", DocumenNo);
        if DividendProgression1.FindSet() then begin
            DividendProgression1.CalcSums("Gross Dividends");
            exit(DividendProgression1."Gross Dividends" * -1)
        end;
    end;

    local procedure getnegatedvalueWTax(CustNo: Code[50]; DocumenNo: Code[50]): Decimal

    begin
        DividendProgression1.Reset();
        DividendProgression1.SetRange("Member No", CustNo);
        DividendProgression1.SetFilter(Shares, '< 0');
        DividendProgression1.SetRange("Header No.", DocumenNo);
        if DividendProgression1.FindSet() then begin
            DividendProgression1.CalcSums("Witholding Tax");
            exit(DividendProgression1."Witholding Tax" * -1)
        end;
    end;

    local procedure getnegatedvalueNetDiv(CustNo: Code[50]; DocumenNo: Code[50]): Decimal

    begin
        DividendProgression1.Reset();
        DividendProgression1.SetRange("Member No", CustNo);
        DividendProgression1.SetFilter(Shares, '< 0');
        DividendProgression1.SetRange("Header No.", DocumenNo);
        if DividendProgression1.FindSet() then begin
            DividendProgression1.CalcSums("Net Dividends");
            exit(DividendProgression1."Net Dividends" * -1)
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        GrossNegatedDiv: Decimal;
        NetNegatedDiv: Decimal;
        WTaxNegatedDiv: Decimal;
        Dividendsetup: Record "Dividend SetUp";
        ShowAll: Boolean;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        MNo: Code[100];
        WithAmount: Decimal;
        MName: Text;
        MPayrollNo: Code[50];
        Members: Record Member;
        ElectrolZone: Text;
        Maddress: Text[250];
        Mcity: Text[220];
        SkipBBFentry: Boolean;
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
        MonthText: Text;
        Datefilter: Text;
        CredAccount: Record "Account Credit";
        DivProcMgt: Codeunit "Dividend Process";
        InterestOptions: Enum "Rcv12 Dividend Interest Option";
}

