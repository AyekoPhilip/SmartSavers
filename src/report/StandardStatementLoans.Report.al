report 50356 "Standard Statement-Loans"
{
    ApplicationArea = All;
    Caption = 'Standard Statement-Loans';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/StandardStatementLoans.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
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
            column(StartDate; StartDate)
            { }
            column(EndDate; EndDate)
            { }
            column(No_; "No.")
            { }
            column(Name; Name)
            { }
            column(Old_Member_No_; "Old Member No.")
            { }
            column(PayrollStaffNo; "Payroll/Staff No.")
            { }
            column(Employer_Code; EmployerName)
            { }
            dataitem(Loans; Loans)
            {
                DataItemLink = "Account No." = field("No.");
                DataItemTableView = where("Outstanding Balance" = filter(<> 0), "Loan Status" = filter(<> Reversed));
                column(LoanNo; "No.")
                { }
                column(Product_Description; "Product Description")
                { }
                column(Disbursement_Date; "Disbursement Date")
                { }
                column(Expected_Date_of_Completion; "Expected Date of Completion")
                { }
                column(Approved_Amount; "Approved Amount")
                { }
                column(Repayment; Repayment)
                { }
                column(BalanceBF; BalanceBF)
                { }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Customer No." = field("Loan Account"), "Loan No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date");
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
                    column(LoanDescriptionTxt; DescriptionTxt)
                    { }
                    column(RunningBal; RunningBal)
                    { }
                    trigger OnPreDataItem()
                    begin

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        DescriptionTxt := '';
                        if SkipReversedUnapplied("Detailed Cust. Ledg. Entry") then
                            CurrReport.Skip();
                        RunningBal += "Detailed Cust. Ledg. Entry"."Amount (LCY)";
                        DescriptionTxt := UpdateDescription("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.", 1);
                    end;
                    trigger OnPostDataItem()
                    begin

                    end;
                }
                trigger OnPreDataItem()
                begin
                    RunningBal := BalanceBF
                end;

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill", "Outstanding Principal");
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        BalanceBF := 0;
                        Account4 := Loans;
                        Account4.SetRange("Date Filter", 0D, StartDate - 1);
                        Account4.CalcFields("Outstanding Balance");
                        BalanceBF := Account4."Outstanding Balance";
                        SetRange("Date Filter", StartDate, EndDate);
                        RunningBal := BalanceBF
                    end else begin
                        RunningBal := 0;
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
                CompanyInformation."Post Code" + ' -City: ' + CompanyInformation.City;
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
                if StartDate = 0D then StartDate := 20220101D;
                if EndDate = 0D then EndDate := Today;
                ShowReversedEntries := true;

            end;

            trigger OnAfterGetRecord()
            begin
                ChargeAccountStatement();
                if Employer.Get("Employer Code") then
                    EmployerName := Employer.Name
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
                    field(ChargeStatement; ChargeStatement)
                    {
                        Caption = 'Charge Statement';
                        ApplicationArea = All;

                    }
                    field(NoOfPage; NoOfPage)
                    {
                        Caption = 'No of Pages';
                        Enabled = ChargeStatement;
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

    procedure SkipReversedUnapplied(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"): Boolean
    begin
        if ShowReversedEntries then begin
            CustLedgerEntry.Get(DetailedCustLedgEntry."Cust. Ledger Entry No.");
            if CustLedgerEntry.Reversed then
                exit(true);
        end;

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

    local procedure ChargeAccountStatement()
    begin
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

    procedure GetDefaults(var FromDate: Date; var ToDate: Date)
    begin
        StartDate := FromDate;
        EndDate := ToDate;
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        AccBanking: Record "Account Banking";
        CompanyTelephone: Text;
        ReversedEntry: Boolean;
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        BalanceBF: Decimal;
        RunningBal: Decimal;
        DescriptionTxt: Text;
        Account4: Record Loans;
        NoOfPage: Integer;
        ChargeStatement: Boolean;
        ShowReversedEntries: Boolean;
        EmployerName: Text[150];
        Employer: Record Customer;
        RegMngt: Codeunit "Registry Mngt.";
        BnkProcMngt: Codeunit "Banking Procedure Mngt.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
}



