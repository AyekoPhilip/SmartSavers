table 50593 "Loans Topup-Ln. Calculator"
{
    Caption = 'Loans Topup-Ln. Calculator';
    DataClassification = CustomerContent;
    
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
            TableRelation = Loans."No." WHERE("Account No." = FIELD("Account No."), "Outstanding Balance" = filter(> 0));
            Caption = 'Loan Top Up';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanApp: Record "Loan Application";
                Gensetup: Record "General Set-Up";
            begin
                Gensetup.Get();

                PaidPercentage := 0;
                if Loans.Get("Loan Top Up") then
                    Loans.CalcFields("Outstanding Balance");
                CopyFromLoanEntries(Loans);

                if ApplicLoan.Get("No.") then begin
                    ApplicLoan.TestField("Product Type");

                    if ApplicLoan."Application Type" = ApplicLoan."Application Type"::Normal then begin

                        LoanToBridge.Reset();
                        LoanToBridge.SetRange("Product Code", ApplicLoan."Product Type");
                        LoanToBridge.SetRange("Product To Bridge", "Product Type");
                        if not LoanToBridge.find('-') then begin
                            error(Text001, LoanToBridge."Product To Bridge", "Product Type");

                            if LoanToBridge."Refinance %" <> 0 then begin
                                PaidPercentage := (Loans."Approved Amount" * (LoanToBridge."Refinance %" / 100));
                                if Loans."Outstanding Balance" > (Loans."Approved Amount" - PaidPercentage) then
                                    Error(Text002, (Loans."Approved Amount" - PaidPercentage));
                            end;
                        end;
                    end;

                end;

                if LoanApp.Get("No.") then begin
                    "Application Type" := LoanApp."Application Type"
                end
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
            Editable = false;
            Caption = 'Outstanding Principle';
            DataClassification = CustomerContent;
        }
        field(50014; "Outstanding Interest"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Interest';
            DataClassification = CustomerContent;
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
        field(50017; "Commision"; Decimal)
        {
            Editable = false;
            Caption = 'Commision';
            DataClassification = CustomerContent;
        }
        field(50018; "Outstanding Bill"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Bill';
            DataClassification = CustomerContent;
        }
        field(50019; "Untransfered Interest"; Decimal)
        {
            Caption = 'Untransfered Interest';
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
        field(50026; "Approval Status"; Enum "ApprovalStatus")
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
        field(50033; "Application Type"; Enum "LoanApplictionType")
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

    }

    keys
    {
        key("Key1"; "No.", "Loan Top Up", "Account No.")
        {
            Clustered = true;
            SumIndexFields = "Total Outstanding Amount","Outstanding Principle";
        }
        key("Key2"; "Outstanding Principle")
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
        RegMngt: Codeunit "Register Management";
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        PaidPercentage: Decimal;
        ApplicLoan: Record "Loan Application";
        LoanToBridge: Record "Loan Products to Bridge";
        Text001: Label 'This product %1 is not allowed for offset by %2';
        Text002: Label 'Member must have paid atleast %1 of the oustanding balance to be allowed for offset.';

    local procedure fnCheckValidRequirement(LoanNo: Code[20])
    var
        LoanApp: Record "Loan Application";
    begin
        if LoanApp.Get(LoanNo) then
            LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
    end;

    local procedure getTopupComms()
    begin
        RegMngt.ComputeLoanCharges(
        "Product Type", '', 0, "Total Outstanding Amount")
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

        Loans.CalcFields("Outstanding Principal", "Outstanding Bill",
        "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
        "Product Type" := Loans."Product Type";
        "Settlement Fee" := RegMngt.getsettlementFee("Loan Top Up");
        EndDate := Today;
        StartDate := CalcDate('-CM', EndDate);
        IntDays := (EndDate - StartDate) + 1;
        if Loans."Interest Calculation Method" <> Loans."Interest Calculation Method"::"Zero Interest" then
            "Untransfered Interest" := PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate) else
            "Untransfered Interest" := 0;
        if PFact.Get(Loans."Product Type") then begin
            "Ignore Related Balance" := PFact."Ignore Related Balance";
            "Exclude Sacco Deduction" := PFact."Exclude Sacco Deduction";
        end;

        "Outstanding Principle" := Loans."Outstanding Principal";
        "Outstanding Bill" := Loans."Outstanding Bill";
        "Outstanding Insurance" := Loans."Outstanding Insurance";
        "Outstanding Interest" := Loans."Outstanding Interest";
        "Outstanding Balance" := (Loans."Outstanding Balance" + "Untransfered Interest");
        "Total Outstanding Amount" := (Loans."Outstanding Balance" + "Untransfered Interest");
        "Monthly Repayment" := Loans.Repayment;
        Commision := RegMngt.ComputeLoanApplicationCharges("Product Type", "No.", 0, "Total Outstanding Amount",ChargeType::"Top up");
        "Total Total Up" := ("Total Outstanding Amount" + Commision + "Settlement Fee");

        if Ploan.Get(Loans."No.") then begin
            PLoan.Validate("Requested Amount", "Total Total Up");
            PLoan."Topped Up Loan" := true;
            PLoan.Modify(true)
        end;
    end;
}
