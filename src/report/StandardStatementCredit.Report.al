report 90005 "Standard Statement Credit"
{
    ApplicationArea = All;
    Caption = 'Standard Statement-Credit';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/StandardStatementCredt.rdl';
    dataset
    {
        dataitem("Account Credit"; "Account Credit")
        {

            column(No; "Member No.")
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
            column(PayrollStaffNo; "Staff/Payroll No.")
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

                CredAccRunBalance := CredAccBalBF;

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
                    ConstructStartEndDates("Account Credit".GetFilter("Date Filter"), StartDate, EndDate);
                if StartDate = 0D then StartDate := 20220101D;
                if EndDate = 0D then EndDate := Today;
                ShowReversedEntries := true;
                
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
                end;

                EmployerName := '';
                if Employer.Get("Employer Code") then
                    EmployerName := Employer.Name;

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
                    
                    field(ShowReversedEntries; ShowReversedEntries)
                    {
                        Caption = 'Include Reversed Entries';
                        Editable = false;
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





