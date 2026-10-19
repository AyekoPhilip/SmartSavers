table 99000 "Loans Liquidation"
{
    DataClassification = CustomerContent;
    Caption = 'Loans Liquidation';
    LookupPageID = "Loan Liquidation";
    DrillDownPageID = "Loan Liquidation";

    fields
    {
        field(50009; "No."; Code[50])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan Top Up"; Code[50])
        {
            TableRelation = Loans."No." where("Account No." = field("Account No."), "Outstanding Balance" = filter(> 0));
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var

                Gensetup: Record "General Set-Up";
            begin

                Gensetup.Get();
                PaidPercentage := 0;
                TotalInt := 0;
                if Loans.Get("Loan Top Up") then
                    Loans.CalcFields("Outstanding Balance");
                if LoanApp.Get("No.") then begin
                    "Application Type" := LoanApp."Application Type";
                    pfact.Get(Loans."Product Type");
                    LoanApp.TestField("Product Dimension", pfact."Product Dimension");
                end;

                CopyFromLoanEntries(Loans);

                if ApplicLoan.Get("No.") then begin
                    ApplicLoan.TestField("Product Type");

                    if ApplicLoan."Application Type" = ApplicLoan."Application Type"::Normal then begin

                        LoanToBridge.Reset();
                        LoanToBridge.SetRange("Product Code", ApplicLoan."Product Type");
                        LoanToBridge.SetRange("Product To Bridge", Loans."Product Type");
                        if LoanToBridge.FindFirst() then begin

                            if LoanToBridge."Refinance %" <> 0 then begin

                                Lshedule.Reset();
                                Lshedule.SetRange("No.", Loans."No.");
                                if not Lshedule.Find('-') then begin
                                    CredMngt.fncreateRepayschedule(false, Loans."No.", 0);
                                end;

                                DateFilter := Format(Loans."Repayment Start Date") + '..' + Format(Today);

                                Rshedule.Reset();
                                Rshedule.SetRange("No.", Loans."No.");
                                if Rshedule.FindSet() then begin
                                    Rshedule.CalcSums("Monthly Repayment");
                                    TotalInt := (Rshedule."Monthly Repayment" / 2);
                                end;
                                AmountPaid := 0;
                                AmountPaid := (Loans."Approved Amount" - Loans."Outstanding Balance");

                                if AmountPaid < 0 then
                                    AmountPaid := 0;

                                PaidPercentage := Loans."Outstanding Balance";
                                if Loans."Product Type" = ApplicLoan."Product Type" then begin
                                    if DetermineTotalDebt(Loans."No.") then begin
                                        if Confirm(Text0002, true) = false then
                                            Error(Text002, TotalInt, PaidPercentage);
                                    end;

                                end;
                            end;
                        end
                    end;
                end;
            end;
        }
        field(50011; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = Member;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Product Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Outstanding Principle"; Decimal)
        {

            Caption = 'Outstanding Principle';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin


                if "Outstanding Principle" > 0 then begin
                    Loans.Reset();
                    Loans.SetRange("No.", "Loan Top Up");
                    if Loans.FindFirst() then begin
                        Loans.CalcFields("Outstanding Balance", "Outstanding Principal");
                        if "Outstanding Principle" > Loans."Outstanding Principal" then
                            Error('The Outstanding Principle cannot be greater than the actual outstanding principle of the loan %1 which is %2', Loans."No.", Loans."Outstanding Principal");
                    end
                end;
                "Total Total Up" := "Outstanding Interest" + "Outstanding Principle";
                "Total Outstanding Amount" := "Total Total Up";
            end;
        }
        field(50014; "Outstanding Interest"; Decimal)
        {

            Caption = 'Outstanding Interest';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Outstanding Interest" > 0 then begin
                    Loans.Reset();
                    Loans.SetRange("No.", "Loan Top Up");
                    if Loans.FindFirst() then begin
                        Loans.CalcFields("Outstanding Interest");
                        if "Outstanding Interest" > Loans."Outstanding Interest" then
                            Error('The Outstanding Interest cannot be greater than the actual outstanding interest of the loan %1 which is %2', Loans."No.", Loans."Outstanding Interest");
                    end;
                    "Total Total Up" := "Outstanding Interest" + "Outstanding Principle";
                    "Total Outstanding Amount" := "Total Total Up";
                end
            end;
        }
        field(50015; "Total Outstanding Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Total Outstanding Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "Outstanding Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50017; Commision; Decimal)
        {
            Editable = false;
            Caption = 'Fee & Charges';
            DataClassification = CustomerContent;
        }
        field(50018; "Outstanding Bill"; Decimal)
        {
            Caption = 'Outstanding Bill';
            DataClassification = CustomerContent;
        }
        field(50019; "Untransfered Interest"; Decimal)
        {
            Caption = 'Untransfered Interest';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50020; "Outstanding Fee"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Outstanding Fee';
        }
        field(50021; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Loans;
            Caption = 'Loan No.';
        }
        field(50022; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Created By';
        }
        field(50023; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Created';
        }
        field(50024; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified Date';
        }
        field(50025; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Last Modified By';
        }
        field(50026; "Approval Status"; Enum ApprovalStatus)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Approval Status';
        }
        field(50027; "Monthly Repayment"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Repayment';
        }
        field(50028; "Exclude From Related Balance"; Boolean)
        {
            Editable = false;
        }
        field(50029; "Ignore Related Balance"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ignore Related Balance';
            Editable = false;
        }
        field(50030; "Exclude Sacco Deduction"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50031; "Outstanding Insurance"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Insurance';
            DataClassification = CustomerContent;
        }
        field(50032; "Total Total Up"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50033; "Application Type"; Enum LoanApplictionType)
        {
            Editable = false;
            Caption = 'Application Type';
            DataClassification = CustomerContent;
        }
        field(50034; "Settlement Fee"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50035; "Restructure Fee"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50036; "Ignore Charges"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50037; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Loan Topup","Loan Liquidation";
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "No.", "Loan Top Up", "Account No.")
        {
            Clustered = true;
            SumIndexFields = "Total Outstanding Amount", "Outstanding Principle";
        }
        key(Key2; "Outstanding Principle")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Loan Top Up", "Account No.", "Outstanding Principle", "Outstanding Interest", "Outstanding Bill")
        {
        }
    }

    trigger OnDelete()
    begin
        fnCheckValidRequirement("No.");

        Loans.Reset();
        Loans.SetRange("No.", "Loan Top Up");
        if Loans.FindFirst() then begin
            Loans."Topped Up Loan" := false;
            Loans.Modify(true)
        end;
        ApplicLoan.Reset();
        ApplicLoan.SetRange("No.", "No.");
        if ApplicLoan.FindFirst() then begin
            TestField("Approval Status", ApplicLoan."Approval Status"::Open);
            ApplicLoan.Validate("Requested Amount", 0);
            ApplicLoan."Recommended Amount" := 0;
            ApplicLoan."Interest Repayment" := 0;
            ApplicLoan.Repayment := 0;
            ApplicLoan.Modify(true)
        end;

        ApplicationCharge.Reset();
        ApplicationCharge.SetRange("Application No.", "No.");
        if ApplicationCharge.FindSet() then begin
            ApplicationCharge.ModifyAll("Amount to Post", 0);
        end;
    end;

    trigger OnInsert()
    begin
        "Date Created" := CurrentDateTime;
        "Created By" := UserId
    end;

    trigger OnModify()
    begin
        fnCheckValidRequirement("No.");
        "Last Modified Date" := CurrentDateTime;
        "Last Modified By" := UserId
    end;

    trigger OnRename()
    begin
        fnCheckValidRequirement("No.")
    end;

    var
        Loans: Record Loans;
        pfact: Record "Product Factory";
        TotalInt: Decimal;
        RegMngt: Codeunit "Register Management";
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        CredLedger: Record "Detailed Cust. Ledg. Entry";
        EndDate: Date;
        Rshedule: Record "Repayment Schedule";
        DateFilter: Text[50];
        IntDays: Integer;
        LoanApp: Record "Loan Application";
        ApplicationCharge: Record "Loan Application Charge";
        Lshedule: Record "Repayment Schedule";
        CredMngt: Codeunit "Credit Mgmt.";
        PaidPercentage: Decimal;
        AmountPaid: Decimal;
        LnProdCharge: Record "Loan Product Charges";
        Gensetup: Record "General Set-Up";
        ApplicLoan: Record "Loan Application";
        LoanToBridge: Record "Loan Products to Bridge";
        Text001: Label 'This product %1 is not allowed for offset by %2';
        Text002: Label 'Member must have serviced atleast %1 of the outstanding balance to be allowed to offset. The Outstanding balance is %2';
        Text0002: Label 'Member must have serviced atleast %1 of the outstanding balance to be allowed to offset.';

    local procedure fnCheckValidRequirement(LoanNo: Code[20])
    var
        LoanApp: Record "Loan Application";
    begin
        // if LoanApp.Get(LoanNo) then
        //    LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
    end;

    local procedure getTopupComms()
    begin
        RegMngt.ComputeLoanCharges("Product Type", '', 0, "Total Outstanding Amount")
    end;

    procedure CopyFromLoanEntries(Loans: Record Loans)
    var
        PLoan: Record Loans;
        PFact: Record "Product Factory";
        CustRecord: Record Member;
        TempFile: Record "Temp. Files";
        RegMngt: Codeunit "Register Management";
        ChargeType: Enum ChargeType;

    begin

        Gensetup.Get();
        Gensetup.TestField("Refinance Options");
        Loans.CalcFields("Outstanding Principal", "Outstanding Bill", "Outstanding Interest",
        "Outstanding Balance", "Outstanding Insurance");
        "Product Type" := Loans."Product Type";

        if LoanApp.Get("No.") then begin
            if LoanApp."Product Type" <> Loans."Product Type" then begin
                "Ignore Charges" := true;
            end else begin
                if LoanApp."Interest Calculation Method" = LoanApp."Interest Calculation Method"::"Zero Interest"
                then
                    "Ignore Charges" := true else
                    "Ignore Charges" := false;
            end;
        end;
        "Settlement Fee" := RegMngt.getsettlementFee("Loan Top Up");

        EndDate := Today;
        StartDate := CalcDate('-CM', EndDate);
        IntDays := (EndDate - StartDate) + 1;
        case Gensetup."Interest Posting Method" of
            Gensetup."Interest Posting Method"::"Charge Daily":
                begin
                    if Loans."Interest Calculation Method" <> Loans."Interest Calculation Method"::"Zero Interest" then
                        "Untransfered Interest" := PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1,
                        IntDays, StartDate)
                    else
                        "Untransfered Interest" := 0;
                end;
        end;

        if PFact.Get(Loans."Product Type") then begin
            "Ignore Related Balance" := PFact."Ignore Related Balance";
            "Exclude Sacco Deduction" := PFact."Exclude Sacco Deduction";
        end;

        "Outstanding Principle" := Loans."Outstanding Principal";
        "Outstanding Bill" := Loans."Outstanding Bill";
        "Outstanding Insurance" := Loans."Outstanding Insurance";
        "Outstanding Interest" := Loans."Outstanding Interest";
        "Outstanding Balance" := (Loans."Outstanding Balance" + "Untransfered Interest");
        "Monthly Repayment" := Loans.Repayment;

    end;

    procedure fngetLoanAge(LoanNo: Code[100]): Integer
    var
        LedgerEntry: Record "Cust. Ledger Entry";
        LoanAge: Integer;
        DateFilter: Text[100];
        Lshedule: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        CredMngt: Codeunit "Credit Mgmt.";
        ToDate: Date;
        LoanT: Record Loans;
    begin

        if LoanT.Get(LoanNo) then begin
            Lshedule.Reset();
            Lshedule.SetRange("No.", LoanT."No.");
            if not Lshedule.Find('-') then begin
                CredMngt.fncreateRepayschedule(false, LoanT."No.", 0);
            end;
            DateFilter := Format(LoanT."Repayment Start Date") + '..' + Format(Today);

            Rshedule.Reset();
            Rshedule.SetRange("No.", LoanT."No.");
            Rshedule.SetFilter("Repayment Date", DateFilter);
            if Rshedule.FindSet() then begin
                LoanAge := Rshedule.Count;
                exit(LoanAge)
            end;
        end else begin
            exit(0)
        end;
        exit(0)
    end;

    procedure fnInterestPaid(LoanNo: Code[100]): Decimal
    var
        LedgerEntry: Record "Cust. Ledger Entry";
        TotLoan: Decimal;
        DateFilter: Text[100];
        Lshedule: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        CredMngt: Codeunit "Credit Mgmt.";
        ToDate: Date;
        LoanT: Record Loans;
    begin
        TotLoan := 0;

        if LoanT.Get(LoanNo) then begin
            Lshedule.Reset();
            Lshedule.SetRange("No.", LoanT."No.");
            if not Lshedule.Find('-') then begin
                CredMngt.fncreateRepayschedule(false, LoanT."No.", 0);
            end;
            DateFilter := Format(LoanT."Repayment Start Date") + '..' + Format(Today);

            Rshedule.Reset();
            Rshedule.SetRange("No.", LoanT."No.");
            Rshedule.SetFilter("Repayment Date", DateFilter);
            if Rshedule.FindSet() then begin
                Rshedule.CalcSums("Monthly Repayment");
                TotLoan := Round(Rshedule."Monthly Repayment", 0.5, '=');
                exit(TotLoan)
            end;

        end else begin
            exit(0)
        end;
        exit(0)
    end;

    procedure DetermineExpectedRepay(LoanNo: Code[100]): Decimal
    Var
        Lshedule: Record "Repayment Schedule";
        CredMngt: Codeunit "Credit Mgmt.";
        TotalDebt: Decimal;
        LoanAge: Integer;
        TotalAmtPaid: Decimal;
        ErrorOnLessApprvdAmount: Label 'Total Amount paid cannot be less than zero';

    begin
        TotalDebt := 0;
        TotalAmtPaid := 0;
        if Loans.Get(LoanNo) then begin

            DateFilter := Format(Loans."Repayment Start Date") + '..' + Format(Today);
            Lshedule.Reset();
            Lshedule.SetRange("No.", LoanNo);
            if not Lshedule.Find('-') then begin
                CredMngt.fncreateRepayschedule(false, "No.", 0);
            end;

            Rshedule.Reset();
            Rshedule.SetRange("No.", LoanNo);
            Rshedule.SetFilter("Repayment Date", DateFilter);
            if Rshedule.FindSet() then begin
                LoanAge := Rshedule.Count;
                Rshedule.CalcSums("Monthly Repayment");
                TotalDebt := (Rshedule."Monthly Repayment" / 2);
                exit(TotalDebt)
            end;
        end;
    end;

    procedure DetermineTotalDebt(LoanNo: Code[100]): Boolean
    Var
        Lshedule: Record "Repayment Schedule";
        CredMngt: Codeunit "Credit Mgmt.";
        Rshedule: Record "Repayment Schedule";
        DateFilter: Text[50];
        TotalDebt: Decimal;
        LoanAge: Integer;
        TotalAmtPaid: Decimal;
        ErrorOnLessApprvdAmount: Label 'Total Amount paid cannot be less than zero';

    begin
        TotalDebt := 0;
        TotalAmtPaid := 0;
        if Loans.Get(LoanNo) then begin

            Loans.CalcFields("Outstanding Principal", "Outstanding Balance");
            DateFilter := Format(Loans."Repayment Start Date") + '..' + Format(Today);

            Lshedule.Reset();
            Lshedule.SetRange("No.", LoanNo);
            if not Lshedule.Find('-') then begin
                CredMngt.fncreateRepayschedule(false, "No.", 0);
            end;

            LoanAge := Round((Loans.Installments / 2), 1, '=');

            Rshedule.Reset();
            Rshedule.SetRange("No.", LoanNo);
            Rshedule.SetRange("Instalment No", LoanAge);
            if Rshedule.FindSet() then begin
                Rshedule.CalcSums("Monthly Repayment");
                TotalDebt := Rshedule."Loan Balance";
            end;

            case Loans."Product Type" of
                'A104',
                'A102':
                    begin
                        if "Outstanding Balance" > TotalDebt then
                            exit(true) else
                            exit(false)
                    end;
                'A101':
                    begin
                        if "Outstanding Balance" > TotalDebt then
                            exit(true) else
                            exit(false)
                    end;
            end;
        end;
        exit(false)
    end;
}




