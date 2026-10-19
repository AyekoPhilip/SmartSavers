report 50286 "Dividend Loan Appraisal Score"
{
    ApplicationArea = All;
    Caption = 'Dividend Loan Appraisal Score';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DividendAppraisalScore.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            column(MemberNo; "No.")
            { }

            dataitem(DSCAppraisalScoring; "DSC Appraisal Scoring")
            {
                DataItemLink = "Account No." = field("No.");

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
                column(AccountName; "Account Name")
                { }
                column(AccountNo; "Account No.")
                { }
                column(BankingRemittance; "Banking Remittance")
                { }
                column(CreditHistory; "Credit History")
                { }
                column(DepositExposure; "Deposit Exposure")
                { }
                column(EntryNo; "Entry No.")
                { }
                column(IndividualScore; "Individual Score")
                { }
                column(MembershipAge; "Membership Age")
                { }
                column(MonthlyDeposit; "Monthly Deposit")
                { }
                column(Parameter; Parameter)
                { }
                column(RegistrationDate; "Registration Date")
                { }
                column(ScoreMaxScore; "Score (Max. Score)")
                { }
                column(TotalDeposits; "Total Deposits")
                { }
                column(Total_Score; "Total Score")
                { }
                column(Qualify_Amount; "Qualify Amount")
                { }
                column(Shares_Banding; "Shares Banding")
                { }
                column(Monthly_Contribution; "Monthly Contribution")
                { }
                column(ProdDescription; ProdDescription)
                { }
                column(ShowOutPut; ShowOutPut)
                { }
                dataitem("Contribution Schedule"; "Contribution Schedule")
                {
                    DataItemLink = "Member No." = field("Account No.");
                    DataItemTableView = where(Amount = filter(<> 0));
                    column(Account_No_; "Account No.")
                    { }
                    column(Posting_Date; "Posting Date")
                    { }
                    column(Amount; Amount)
                    { }
                    column(Installment_No_; "Installment No.")
                    { }
                    column(Member_No_; "Member No.")
                    { }
                }
                dataitem("Dividend Progression"; "Dividend Progression")
                {
                    DataItemLink = "Member No" = field("Account No.");
                    column(Account_No; "Account No")
                    { }
                    column(Entry_No_; "Entry No.")
                    { }
                    column(ProductType; ProductType)
                    { }
                    column(Dividend_Calc__Method; "Dividend Calc. Method")
                    { }
                    column(Net_Dividends; "Net Dividends")
                    { }
                    column(Gross_Dividends; "Gross Dividends")
                    { }
                    column(Product_Name; "Product Name")
                    { }
                    column(Shares; Shares)
                    { }
                    column(Qualifying_Shares; "Qualifying Shares")
                    { }
                    column(End_Date; "End Date")
                    { }
                    column(Start_Date; "Start Date")
                    { }
                    column(Witholding_Tax; "Witholding Tax")
                    { }
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
                    //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                    //CompanyInformation."Home Page";

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
                    RegMnt.GetDivLoanMaxCreditLimitScore(Member, 'DIVIDEND', 90, 0);
                end;

                trigger OnPostDataItem()
                begin

                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Product Type")
                {
                    field(ProductType; ProductType)
                    {
                        Visible = false;
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
}




