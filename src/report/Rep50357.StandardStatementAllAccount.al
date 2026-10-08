report 50357 "Standard Statement-All Account"
{
    ApplicationArea = All;
    Caption = 'Standard Statement-All Account';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/StandardStatementAllAccounts.rdl';
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
            column(EmployerCode; EmployerName)
            {
            }
            column(Old_Member_No_; "Old Member No.")
            { }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(OldMemberNo; "Old Member No.")
            {
            }
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
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(AccountType; AccountType)
            { }
            column(ShowBosaAc; ShowBosaAc)
            { }
            column(ShowFosaAc; ShowFosaAc)
            { }
            column(ShowLoanAc; ShowLoanAc)
            { }
            dataitem("Account Banking"; "Account Banking")
            {
                DataItemLink = "Member No." = field("No.");
                DataItemTableView = where("Account Category" = filter(Junior | "Money Market" | "Specialty Savings" | "Islamic Banking"));
                column(BankingNo; "No.")
                { }
                column(BankingProduct_Type; "Product Type")
                { }
                column(Product_Name; "Product Name")
                { }
                column(BankingCustName; Name)
                { }
                column(BankingBalBF; BankingBalBF)
                { }
                dataitem(BankingDetailedLedgEntry; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date");
                    column(BnkPosting_Date; "Posting Date")
                    { }
                    column(BnkDocument_No_; "Document No.")
                    { }
                    column(BnkAmount; "Amount (LCY)")
                    { }
                    column(BnkDebit_Amount; "Debit Amount (LCY)")
                    { }
                    column(BnkCredit_Amount; "Credit Amount (LCY)")
                    { }
                    column(BnkDescriptionTxt; DescriptionTxt[1])
                    { }
                    column(BankingRunBalance; BankingRunBalance)
                    { }
                    trigger OnPreDataItem()
                    begin

                        // GetDefaults(StartDate, EndDate);
                        if StartDate = 0D then StartDate := 20221230D;
                        if EndDate = 0D then EndDate := Today;

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        DescriptionTxt[1] := UpdateDescription(BankingDetailedLedgEntry."Vendor Ledger Entry No.", 0);
                        if SkipReversedVendorUnapplied(BankingDetailedLedgEntry) then
                            CurrReport.Skip();
                        BankingRunBalance += -BankingDetailedLedgEntry."Amount (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin


                    end;
                }
                trigger OnPreDataItem()
                begin
                    BankingRunBalance := BankingBalBF

                end;

                trigger OnAfterGetRecord()
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        BankingBalBF := 0;
                        Account2 := "Account Banking";
                        Account2.SetRange("Date Filter", 0D, StartDate - 1);
                        Account2.CalcFields("Balance (LCY)");
                        BankingBalBF := Account2."Balance (LCY)";
                        SetRange("Date Filter", StartDate, EndDate);
                        BankingRunBalance := BankingBalBF
                    end else begin
                        BankingRunBalance := 0;
                    end

                end;

                trigger OnPostDataItem()
                begin


                end;
            }
            dataitem("Account Credit"; "Account Credit")
            {
                DataItemLink = "Member No." = field("No.");
                DataItemTableView = where("Account Category" = filter("Shares Capital" | "Shares Deposit"));
                column(AccNo; "No.")
                { }
                column(CredProduct_Type; "Product Type")
                { }
                column(CredProduct_Name; "Account Category")
                { }
                column(CredAccBalBF; CredAccBalBF)
                { }

                dataitem(CreditCustLedgEntry; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date");
                    column(CredPosting_Date; "Posting Date")
                    { }
                    column(CredDocument_No_; "Document No.")
                    { }
                    column(CredAmount; Amount)
                    { }
                    column(CredDebit_Amount; "Debit Amount (LCY)")
                    { }
                    column(CredCredit_Amount; "Credit Amount (LCY)")
                    { }
                    column(CredDescriptionTxt; DescriptionTxt[2])
                    { }

                    column(CredAccRunBalance; CredAccRunBalance)
                    { }
                    trigger OnPreDataItem()
                    begin

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        DescriptionTxt[2] := UpdateDescription(CreditCustLedgEntry."Cust. Ledger Entry No.", 1);
                        if SkipReversedUnapplied(CreditCustLedgEntry) then
                            CurrReport.Skip();
                        CredAccRunBalance += -CreditCustLedgEntry."Amount (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin

                    end;
                }
                trigger OnPreDataItem()
                begin
                    CredAccRunBalance := CredAccBalBF

                end;

                trigger OnAfterGetRecord()
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        CredAccBalBF := 0;
                        Account3 := "Account Credit";
                        Account3.SetRange("Date Filter", 0D, StartDate - 1);
                        Account3.CalcFields("Balance (LCY)");
                        CredAccBalBF := Account3."Balance (LCY)";
                        SetRange("Date Filter", StartDate, EndDate);
                        CredAccRunBalance := CredAccBalBF;

                    end else begin
                        CredAccRunBalance := 0;
                    end

                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            dataitem("Repayment Account"; "Repayment Account")
            {
                DataItemLink = "Member No." = field("No.");
                column(RepayNo; "No.")
                { }
                column(RepayAccProductName; "Product Name")
                { }
                column(RepayBalanceBF; RepayBalanceBF)
                { }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date");
                    column(RepayAccPostingDate; "Posting Date")
                    { }
                    column(RepayAccDocumentNo; "Document No.")
                    { }
                    column(RepayAccAmountLCY; "Amount (LCY)")
                    { }
                    column(RepayAccDebitAmount; "Debit Amount")
                    { }
                    column(RepayAccCreditAmount; "Credit Amount")
                    { }
                    column(RepayDescriptionTxt; DescriptionTxt[7])
                    { }
                    column(RepayRunningBal; RepayRunningBal)
                    { }
                    trigger OnPreDataItem()
                    begin

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        DescriptionTxt[7] := UpdateDescription("Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No.", 0);
                        if SkipReversedVendorUnapplied("Detailed Vendor Ledg. Entry") then
                            CurrReport.Skip();
                        RepayRunningBal += -"Detailed Vendor Ledg. Entry"."Amount (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin

                    end;
                }
                trigger OnPreDataItem()
                begin
                    RepayRunningBal := RepayBalanceBF
                end;

                trigger OnAfterGetRecord()
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        RepayBalanceBF := 0;
                        RepayAccount2 := "Repayment Account";
                        RepayAccount2.SetRange("Date Filter", 0D, StartDate - 1);
                        RepayAccount2.CalcFields("Balance (LCY)");
                        BankingBalBF := RepayAccount2."Balance (LCY)";
                        SetRange("Date Filter", StartDate, EndDate);
                        RepayRunningBal := RepayBalanceBF
                    end else begin
                        RepayRunningBal := 0;
                    end

                end;

                trigger OnPostDataItem()
                begin

                end;

            }
            dataitem("Loans Categorization"; Loans)
            {
                DataItemLink = "Account No." = field("No.");
                DataItemTableView = where("Approval Status" = filter(Posted), "Loan Status" = filter(<> Reversed));
                column(LoanNo; "No.")
                { }
                column(Product_Description; "Product Description")
                { }
                column(Approved_Amount; "Approved Amount")
                { }
                column(Repayment; Repayment)
                { }
                column(Disbursement_Date; "Disbursement Date")
                { }
                column(Expected_Date_of_Completion; "Expected Date of Completion")
                { }
                column(LoanRunBalanceBF; LoanRunBalanceBF)
                { }
                dataitem("LoanLedgEntry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Customer No." = field("Loan Account"), "Loan No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date");
                    column(Amount; Amount)
                    { }
                    column(Posting_Date; "Posting Date")
                    { }
                    column(Document_No_; "Document No.")
                    { }
                    column(Debit_Amount; "Debit Amount (LCY)")
                    { }
                    column(Credit_Amount; "Credit Amount (LCY)")
                    { }
                    column(Transaction_Type; "Transaction Type")
                    { }
                    column(LoanDescriptionTxt; DescriptionTxt[3])
                    { }
                    column(LoanRunBalance; LoanRunBalance)
                    { }

                    trigger OnPreDataItem()
                    begin

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        DescriptionTxt[3] := UpdateDescription(LoanLedgEntry."Cust. Ledger Entry No.", 1);
                        if SkipReversedUnapplied(LoanLedgEntry) then
                            CurrReport.Skip();
                        LoanRunBalance += LoanLedgEntry."Amount (LCY)"

                    end;

                    trigger OnPostDataItem()
                    begin

                    end;
                }
                trigger OnPreDataItem()
                begin
                    LoanRunBalance := LoanRunBalanceBF;
                end;

                trigger OnAfterGetRecord()
                begin

                    CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill", "Outstanding Principal");

                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        LoanRunBalanceBF := 0;
                        Account4 := "Loans Categorization";
                        Account4.SetRange("Date Filter", 0D, StartDate - 1);
                        Account4.CalcFields("Outstanding Balance");
                        LoanRunBalanceBF := Account4."Outstanding Balance";
                        SetRange("Date Filter", StartDate, EndDate);
                        LoanRunBalance := LoanRunBalanceBF
                    end else begin
                        LoanRunBalance := 0;
                    end;

                    if not ShowClosedAccount then begin
                        if "Outstanding Balance" = 0 then CurrReport.Skip();
                    end;
                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City;
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
                SavingsAccountName := '';

                GetDefaults(StartDate, EndDate);
                if not GuiAllowed then
                    ConstructStartEndDates(Member.GetFilter("Date Filter"), StartDate, EndDate);
                if StartDate = 0D then StartDate := 20220101D;
                if EndDate = 0D then EndDate := Today;
                ShowReversedEntries := true;
            end;

            trigger OnAfterGetRecord()
            begin
                EmployerName := '';
                if Employer.Get("Employer Code") then
                    EmployerName := Employer.Name;

                Case AccountType of
                    AccountType::"All Accounts":
                        begin
                            ShowBosaAc := true;
                            ShowFosaAc := true;
                            ShowLoanAc := true;
                        end;
                    AccountType::"Bosa Accounts":
                        begin
                            ShowBosaAc := true;
                            ShowFosaAc := false;
                            ShowLoanAc := false;

                        end;
                    AccountType::"Fosa Accounts":
                        begin
                            ShowBosaAc := false;
                            ShowFosaAc := true;
                            ShowLoanAc := false;
                        end;
                    AccountType::"Loan Accounts":
                        begin
                            ShowBosaAc := false;
                            ShowFosaAc := false;
                            ShowLoanAc := true;
                        end;
                end;

                AccBanking.Reset();
                AccBanking.SetRange("Member No.", Member."No.");
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then begin

                    RegMngt.RestrictedAccountMngt(AccBanking."No.", UserId);

                    if ChargeStatement then begin
                        if NoOfPage <> 0 then begin
                            BnkProcMngt.ChargeAccountStatement(AccBanking."No.", ChargeStatement, NoOfPage);
                        end else begin
                            Error('Kindly Specify the No. of Pages');
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
            area(content)
            {
                group(Option)
                {
                    Caption = 'Options';
                    field(ShowClosedAccount; ShowClosedAccount)
                    {
                        Caption = 'Show Closed Accounts';
                        ApplicationArea = All;

                    }
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
                    field(AccountType; AccountType)
                    {
                        Caption = 'Account Type';
                        ApplicationArea = All;
                        Editable = true;
                    }
                    field(ShowReversedEntries; ShowReversedEntries)
                    {
                        Caption = 'Include Reversed Entries';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(ChargeStatement; ChargeStatement)
                    {
                        Caption = 'Charge Statement';
                        ApplicationArea = All;

                    }
                    field(NoOfPage; NoOfPage)
                    {
                        Caption = 'No of Pages';
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
    procedure ConstructStartEndDates(DateFilter: Text; var SDate: Date; var EDate: Date)
    var
        DateRec: Record Date;
        Part, Test : Text;
    begin
        if DateFilter = '' then
            exit;
        DateRec.Reset();
        DateRec.SetFilter("Period Start", DateFilter);
        SDate := DateRec.GetRangeMin("Period Start");
        EDate := DateRec.GetRangeMax("Period Start");
    end;

    var
        BalanceBF: Decimal;
        SavingsAccountName: Text;
        ShowClosedAccount: Boolean;
        EmployerName: Text[250];
        Employer: Record Customer;
        RepayAccount2: Record "Repayment Account";
        RepayRunningBal: Decimal;
        RepayBalanceBF: Decimal;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        ReversedEntry: Boolean;
        CommunicationOnline: Text;
        StartDate: Date;
        PLoan: Record "Loans Categorization";
        PLoan3: Record "Loans Categorization";
        EndDate: Date;
        Account2: Record "Account Banking";
        Account3: Record "Account Credit";
        Account4: Record Loans;
        StaffNo: Code[10];
        GlEntries: Record "G/L Entry";
        CustAddress: Code[100];
        BankingBalBF: Decimal;
        BankingRunBalance: Decimal;
        ShowReversedEntries: Boolean;
        CredAccBalBF: Decimal;
        CredAccRunBalance: Decimal;
        BankingAccounts: Boolean;
        CredicAccounts: Boolean;
        LoanAccounts: Boolean;
        AccBanking: Record "Account Banking";
        ChargeStatement: Boolean;
        NoOfPage: Integer;
        LoanRunBalance: Decimal;
        LoanRunBalanceBF: Decimal;
        ShowSplitTransactions: Boolean;
        RegMngt: Codeunit "Registry Mngt.";
        BnkProcMngt: Codeunit "Banking Procedure Mngt.";
        PrincBalance: Decimal;
        InterestBalance: Decimal;
        BillBalance: Decimal;
        PrincBalanceBF: Decimal;
        InterestBalanceBF: Decimal;
        BillBalanceBF: Decimal;
        DescriptionTxt: array[7] of Text[250];
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        AccountType: Option "All Accounts","Fosa Accounts","Bosa Accounts","Loan Accounts";
        ShowFosaAc: Boolean;
        ShowBosaAc: Boolean;
        ShowLoanAc: Boolean;

    procedure SkipReversedUnapplied(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"): Boolean
    begin
        if ShowReversedEntries then begin
            CustLedgerEntry.Get(DetailedCustLedgEntry."Cust. Ledger Entry No.");
            if CustLedgerEntry.Reversed then
                exit(true);
        end;
        exit(false);

    end;

    procedure SkipReversedVendorUnapplied(var DetailedCustLedgEntry: Record "Detailed Vendor Ledg. Entry"): Boolean
    begin
        if ShowReversedEntries then begin
            VendLedgerEntry.Get(DetailedCustLedgEntry."Vendor Ledger Entry No.");
            if VendLedgerEntry.Reversed then
                exit(true);
        end;
        exit(false);

    end;

    procedure UpdateDescription(EntryNo: Integer; PostInt: Integer): Text[250]
    begin
        case PostInt of
            0:
                begin
                    VendLedgerEntry.Reset();
                    VendLedgerEntry.SetRange("Entry No.", EntryNo);
                    if VendLedgerEntry.FindFirst() then begin
                        exit(VendLedgerEntry.Description)
                    end;
                end;
            1:
                begin
                    CustLedgerEntry.SetRange("Entry No.", EntryNo);
                    if CustLedgerEntry.FindFirst() then begin
                        exit(CustLedgerEntry.Description)

                    end;

                end;
        end;
        exit('')
    end;

    procedure GetDefaults(var FromDate: Date; var ToDate: Date)
    begin
        StartDate := FromDate;
        EndDate := ToDate;
        if (FromDate <> 0D) or (ToDate <> 0D) then
            AccountType := AccountType::"All Accounts";
    end;
}





