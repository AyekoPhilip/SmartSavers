report 50280 "Teller Cheque Report"
{
    ApplicationArea = All;
    Caption = 'Teller Cheque Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/TellerCheques.rdl';
    dataset
    {
        dataitem(TellerTransaction; "Teller Transaction")
        {
            DataItemTableView = where(Posted = const(true), Type = filter("Cheque Deposit" | "Bankers Cheque"));
            column(CompInformation; CompanyInformation.Name)
            {
            }
            column(CompanyInformationPicture; CompanyInformation.Picture)
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
            column(AccountDimension; "Account Dimension")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AllocatedAmount; "Allocated Amount")
            {
            }
            column(Amount; Amount)
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(AttemptedSelfTransaction; "Attempted Self Transaction")
            {
            }
            column(AvailableBalance; "Available Balance")
            {
            }
            column(BankAccount; "Bank Account")
            {
            }
            column(BankedBy; "Banked By")
            {
            }
            column(BankersChequeNo; "Bankers Cheque No")
            {
            }
            column(BookBalance; "Book Balance")
            {
            }
            column(Cashier; Cashier)
            {
            }
            column(ChangeLog; "Change Log")
            {
            }
            column(ChequeDate; "Cheque Date")
            {
            }
            column(ChequeIssueingBank; "Cheque Issueing Bank")
            {
            }
            column(ChequeNo; "Cheque No")
            {
            }
            column(ChequeStatus; "Cheque Status")
            {
            }
            column(ChequeType; "Cheque Type")
            {
            }
            column(ClearedBy; "Cleared By")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(DateBanked; "Date Banked")
            {
            }
            column(DateCleared; "Date Cleared")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(DiscountedAmount; "Discounted Amount")
            {
            }
            column(DiscountingAmount; "Discounting Amount")
            {
            }
            column(DraweeBankBranch; "Drawee Bank Branch")
            {
            }
            column(DraweeBankCode; "Drawee Bank Code")
            {
            }
            column(Dublicate; Dublicate)
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(ExpectedMaturityDate; "Expected Maturity Date")
            {
            }
            column(ExpiryDate; "Expiry Date")
            {
            }
            column(FingerPrintVerified; "FingerPrint Verified")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(IDNo; "ID No")
            {
            }
            column(JournalBatchName; "Journal Batch Name")
            {
            }
            column(JournalTemplateName; "Journal Template Name")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(NewAccountBalance; "New Account Balance")
            {
            }
            column(No; "No.")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(Overdraft; Overdraft)
            {
            }
            column(Payee; Payee)
            {
            }
            column(PostDated; "Post Dated")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(Printed; Printed)
            {
            }
            column(ProductCategory; "Product Category")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProtectedAccount; "Protected Account")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(ResponsibilityCentre; "Responsibility Centre")
            {
            }
            column(Select; Select)
            {
            }
            column(SigningInstructions; "Signing Instructions")
            {
            }
            column(TillCode; "Till Code")
            {
            }
            column(TillName; "Till Name")
            {
            }
            column(TimeBanked; "Time Banked")
            {
            }
            column(TimeCleared; "Time Cleared")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(TransactionDate; "Transaction Date")
            {
            }
            column(TransactionDescription; "Transaction Description")
            {
            }
            column(TransactionTime; "Transaction Time")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(Type; "Type")
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
}



