report 50337 "Statement of Account-Repayment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StatementofAccountRepayment.rdl';
    ApplicationArea = All;
    dataset
    {
        dataitem(AccountBanking; "Repayment Account")
        {
            RequestFilterFields = "No.";
            column(MemberNo_AccountBanking; AccountBanking."Member No.")
            {
            }
            column(ProductType_AccountBanking; AccountBanking."Product Type")
            {
            }
            column(ProductName_AccountBanking; AccountBanking."Product Name")
            {
            }
            column(MobileNo_AccountBanking; AccountBanking."Phone No.")
            {
            }
            column(No_AccountBanking; AccountBanking."No.")
            {
            }
            column(Name_AccountBanking; AccountBanking.Name)
            {
            }
            column(PhoneNo_AccountBanking; AccountBanking."Phone No.")
            {
            }
            column(GlobalDimension1Code_AccountBanking; AccountBanking."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_AccountBanking; AccountBanking."Global Dimension 2 Code")
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
            column(StaffNo; StaffNo)
            {
            }
            column(CustAddress; CustAddress)
            {
            }
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
                column(Description; DescriptionTxt[1])
                { }
                column(BankingBalBF; BankingBalBF)
                { }
                column(BankingRunBalance; BankingRunBalance)
                { }
                trigger OnPreDataItem()
                begin

                    GetDefaults(StartDate, EndDate);
                    if StartDate = 0D then StartDate := 20200101D;
                    if EndDate = 0D then EndDate := Today;

                end;

                trigger OnAfterGetRecord()
                begin
                   
                    DescriptionTxt[1] := UpdateDescription(BankingDetailedLedgEntry."Vendor Ledger Entry No.", 0);
                    if SkipReversedVendorUnapplied(BankingDetailedLedgEntry) then
                        CurrReport.Skip();
                    BankingRunBalance += BankingDetailedLedgEntry."Amount (LCY)";
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
                BankingRunBalance := BankingBalBF

            end;

            trigger OnAfterGetRecord()
            begin
                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                    BankingBalBF := 0;
                    Account2 := AccountBanking;
                    Account2.SetRange("Date Filter", 0D, StartDate - 1);
                    Account2.CalcFields("Balance (LCY)");
                    BankingBalBF := Account2."Balance (LCY)";
                    SetRange("Date Filter", StartDate, EndDate);
                    BankingRunBalance := BankingBalBF
                end else begin
                    BankingRunBalance := 0;
                end;

                EmployerName := '';
                if Employer.Get("Employer Code") then
                    EmployerName := Employer.Name;
                AccBanking.Reset();
                AccBanking.SetRange("No.", "No.");
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
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(ShowReversedEntries; ShowReversedEntries)
                    {
                        Caption = 'Include Reversed Entries';
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
        Account2: Record "Repayment Account";
        Account3: Record "Account Credit";
        Account4: Record "Loans Categorization";
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
        BankingAccounts := true;
        CredicAccounts := true;
        LoanAccounts := true;
    end;

}




