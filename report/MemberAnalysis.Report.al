report 50205 "Member Analysis"
{
    ApplicationArea = All;
    Caption = 'Member Analysis';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MemberAnalysis.rdl';
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
            column(TotalLoanBal; TotalLoanBal)
            { }
            dataitem("Account Banking"; "Account Banking")
            {
                DataItemLink = "Member No." = field("No.");
                column(BankingNo; "No.")
                { }
                column(BankingProduct_Type; "Product Type")
                { }
                column(Product_Name; "Product Name")
                { }
                column(BankingCustName; Name)
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
                    column(BankingBalBF; BankingBalBF)
                    { }
                    column(BankingRunBalance; BankingRunBalance)
                    { }
                    trigger OnPreDataItem()
                    begin

                        if StartDate = 0D then StartDate := 20200101D;
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
                column(CredProduct_Name; "Product Name")
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
                    column(CredAccBalBF; CredAccBalBF)
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
                        CredAccRunBalance := CredAccBalBF
                    end else begin
                        CredAccRunBalance := 0;
                    end

                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            dataitem("Loans Categorization"; Loans)
            {
                DataItemLink = "Account No." = field("No.");
                column(LoanNo; "No.")
                { }
                column(Product_Description; "Product Description")
                { }
                column(Approved_Amount; "Approved Amount")
                { }
                column(Disbursement_Date; "Disbursement Date")
                { }
                column(Expected_Date_of_Completion; "Expected Date of Completion")
                { }
                column(Outstanding_Bill; "Outstanding Bill")
                { }
                column(Outstanding_Insurance; "Outstanding Insurance")
                { }
                column(Outstanding_Interest; "Outstanding Interest")
                { }
                column(Outstanding_Principal; "Outstanding Principal")
                { }
                column(Outstanding_Balance; "Outstanding Balance")
                { }
                column(MonthlyAccruedInt; MonthlyAccruedInt)
                { }
                column(AccreuedInt; AccreuedInt)
                { }
                column(SettlementFee; SettlementFee)
                { }
                column(Requested_Amount; "Requested Amount")
                { }
                column(Repayment; Repayment)
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
                    column(LoanRunBalanceBF; LoanRunBalanceBF)
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

                end;

                trigger OnAfterGetRecord()
                begin


                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        LoanRunBalanceBF := 0;
                        Account4 := "Loans Categorization";
                        Account4.SetRange("Date Filter", 0D, StartDate - 1);
                        Account4.CalcFields("Outstanding Balance");
                        LoanRunBalanceBF := Account4."Outstanding Balance";
                        SetRange("Date Filter", StartDate, EndDate);
                        LoanRunBalance := LoanRunBalanceBF;
                    end else begin
                        LoanRunBalance := 0;
                    end;

                    CalcFields("Outstanding Balance");

                    AccreuedInt := 0;
                    SettlementFee := 0;
                    IntDays := 0;
                    DaysInMonths := 0;
                    MonthlyAccruedInt := 0;

                    TempFile.Reset();
                    TempFile.SetRange(Posted, false);
                    TempFile.SetRange("Loan No.", "No.");
                    TempFile.SetRange("Product Type", "Product Type");
                    if TempFile.FindFirst() then begin
                        SettlementFee := TempFile.Amount;
                    end;

                    FirstDate := CalcDate('-CM', Today);
                    LastDate := CalcDate('14D', Today);
                    IntDays := (LastDate - FirstDate) + 1;

                    if IntDays > 0 then
                        AccreuedInt := Round(PeriodAct.fnIntEntriesonSpecificLoan("Loans Categorization", Today, "No.", 1, IntDays, FirstDate), 0.05, '>');
                    "Outstanding Balance" := ("Outstanding Balance" + AccreuedInt + SettlementFee);
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

                if StartDate = 0D then StartDate := 20200101D;
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

                LoansT.Reset();
                LoansT.SetRange("Account No.", "No.");
                if LoansT.FindSet() then begin
                    repeat
                        LoansT.CalcFields("Outstanding Balance");
                        TotalLoanBal := (TotalLoanBal + LoansT."Outstanding Balance");

                        TempFile.Reset();
                        TempFile.SetRange(Posted, false);
                        TempFile.SetRange("Loan No.", LoansT."No.");
                        TempFile.SetRange("Product Type", LoansT."Product Type");
                        if TempFile.FindFirst() then begin
                            SettlementFee := (SettlementFee + TempFile.Amount);
                        end;

                        Date1 := CalcDate('-CM', Today);
                        Date2 := CalcDate('14D', Today);
                        DaysTo := (Date2 - Date1) + 1;
                        if DaysTo > 0 then
                            TotAccreuedInt := (TotAccreuedInt + Round(PeriodAct.fnIntEntriesonSpecificLoan(LoansT, Today, "No.", 1, DaysTo, Date1), 0.05, '>'));

                    until LoansT.Next() = 0;
                end;
                TotalLoanBal := (TotalLoanBal + TotAccreuedInt + SettlementFee);
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
                        Caption = 'Account Types';
                        ApplicationArea = All;
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
    var
        BalanceBF: Decimal;
        Date1: Date;
        Date2: Date;
        TotAccreuedInt: Decimal;
        DaysTo: Integer;
        TotLoanBal: Decimal;
        TotalsettFee: Decimal;
        SavingsAccountName: Text;
        EmployerName: Text[250];
        Employer: Record Customer;
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

        TellMngt: Codeunit "Teller-Post (Yes/No)";
        AccreuedInt: Decimal;

        IntDays: Decimal;
        BillBalanceBF: Decimal;
        DescriptionTxt: array[7] of Text[250];
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        AccountType: Option "All Accounts","Fosa Accounts","Bosa Accounts","Loan Accounts";
        ShowFosaAc: Boolean;
        ShowBosaAc: Boolean;
        LoanT: Record Loans;
        TempFile: Record "Temp. Files";
        SettlementFee: Decimal;
        TotalLoanBal: Decimal;
        TotalIntAcrued: Decimal;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        ShowLoanAc: Boolean;
        MonthlyAccruedInt: Decimal;
        CredAcc: Record "Account Credit";
        LoansT: Record Loans;
        DepShare: Decimal;
        FirstDate: Date;
        LastDate: Date;
        SharesCapital: Decimal;
        CustAge: Integer;
        DaysInMonths: Integer;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        DepMultiplier: array[5] of Decimal;
        CustEmail: Text[150];

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
        BankingAccounts := true;
        CredicAccounts := true;
        LoanAccounts := true;
    end;




}




