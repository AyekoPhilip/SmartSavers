report 50353 "Mobile Loan Score"
{
    ApplicationArea = All;
    Caption = 'Mobile Loan Score';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    RDLCLayout = './src/report_layout/DSCAppraisalScore.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Status; Status)
            {
            }
            column(IDNo; "ID No.")
            {
            }
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
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                ProdDescription := '';

                if PFact.Get(ProductType) then begin
                    ProdDescription := PFact.Description;
                    if PFact."Loan Span" = PFact."Loan Span"::"Mobile Loan" then
                        ShowOutPut := false else
                        ShowOutPut := true;
                end;
                RegMnt.GetLoanMaxCreditLimitScoreQC(Member, ProductType, 0, 0);
            end;

            trigger OnPostDataItem()
            begin
                DscApp.Reset();
                DscApp.SetRange("Account No.", Member."No.");
                if DscApp.FindFirst() then
                    Report.Run(Report::"Mob.Appraisal score", true, false, DscApp);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ProductType; ProductType)
                    {
                        Caption = 'Product Type';
                        TableRelation = "Product Factory" where("Product Class" = const(Loan), "Loan Span" = filter("Mobile Loan" | Dividends), Status = const(Active));
                        ApplicationArea = All;
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
        BankingAcc: Record "Account Banking";
        CredAcc: Record "Account Credit";
        LoansT: Record Loans;
        RegMngt: Codeunit "Register Management";
        SharesCapital: Decimal;
        CustAge: Integer;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        DepMultiplier: array[5] of Decimal;
        CustEmail: Text[150];
        DscApp: Record "DSC Appraisal Scoring";
        CustomerRec: Record Member;
        BalanceBF: Decimal;
        CName: Text[150];
        AppAmount: Decimal;
        Disdate: Date;
        OutBal: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        LoanGuarantTotal: Decimal;
        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[10];
        MembershipAge: Integer;
        QualifyAmt: Decimal;
        ProductType: Code[20];
        RegMnt: Codeunit "Register Management";
        ShowOutPut: Boolean;
        PFact: Record "Product Factory";
        ProdDescription: Text[150];
        AccountNo: Code[100];
}



