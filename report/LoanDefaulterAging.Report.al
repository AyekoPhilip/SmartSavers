report 50224 "Loan Defaulter Aging"
{
    ApplicationArea = All;
    Caption = 'Loan Defaulter Aging';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/LoanDefaulterAging.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            
            column(No; "No.")
            { }
            column(ProductType; "Product Type")
            { }
            column(Product_Description; "Product Description")
            { }
            column(Repayment; Repayment)
            { }
            column(AccountName; "Account Name")
            { }
            column(AccountNo; "Account No.")
            { }
            column(ExpectedDateofCompletion; "Expected Date of Completion")
            { }
            column(LastPayDate; "Last Pay Date")
            { }
            column(AmountInArrears; "Amount In Arrears")
            { }
            column(OutstandingBalance; "Outstanding Balance")
            { }
            column(OutstandingInterest; "Outstanding Interest")
            { }
            column(OutstandingPrincipal; "Outstanding Principal")
            { }
            column(Month0; Month0)
            { }
            column(Month1; Month1)
            { }
            column(Month2; Month2)
            { }
            column(Month3; Month3)
            { }
            column(Month4; Month4)
            { }
            column(TotMonths; TotMonths)
            { }
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
            column(PRODUCTNAME; PRODUCTNAME)
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
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +
                //CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                Month0 := 0;
                Month1 := 0;
                Month2 := 0;
                Month3 := 0;
                Month4 := 0;
                TotMonths := 0;
                PRODUCTNAME := '';
                IF LOANST.Get("No.") THEN
                    PRODUCTNAME := LOANST."Product Description";

                CalcFields("Outstanding Balance", "Outstanding Principal", "Outstanding Interest", "Loan principal Schedule");

                if "Outstanding Balance" = 0 then
                    CurrReport.Skip();


               
                    if "Sasra Category" = "Sasra Category"::Performing then begin
                   Month0 := "Outstanding Principal";
                    end else
                        if "Sasra Category" = "Sasra Category"::Watch then begin
                            Month1 := "Outstanding Principal";
                        end else
                            if "Sasra Category" = "Sasra Category"::Substandard then begin
                                Month2 := "Outstanding Principal";
                            end else
                                if "Sasra Category" = "Sasra Category"::Doubtful then begin
                                    Month3 := "Outstanding Principal";
                                end else
                                    if "Sasra Category" = "Sasra Category"::Loss then begin
                                        Month4 := "Outstanding Principal";
                                    end;

              
                TotMonths := (Month0 + Month1 + Month2 + Month3 + Month4);
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
        Month0: Decimal;
        Month1: Decimal;
        Month2: Decimal;
        Month3: Decimal;
        Month4: Decimal;
        Over3Month: Decimal;
        TotMonths: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        LOANST: Record Loans;

        PRODUCTNAME: TEXT;



}



