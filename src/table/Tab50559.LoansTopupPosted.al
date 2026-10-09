table 50559 "Loans Top up Posted"
{
    DrillDownPageID = "Loans Top Up Posted";
    LookupPageID = "Loans Top Up Posted";
    DataClassification = CustomerContent;
    fields
    {

        field(50009; "No."; Code[50])
        {
            TableRelation = Loans."No.";
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan Top Up"; Code[50])
        {
            TableRelation = Loans."No." WHERE("Account No." = FIELD("Account No."),
                                               "Outstanding Balance" = FILTER(> '0'));
            Caption = 'Loan Top Up';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanApp: Record "Loan Application";
            begin
                if Loans.Get("Loan Top Up") then
                    Loans.CalcFields("Outstanding Balance");
                if LoanApp.Get("No.") then begin
                    "Application Type" := LoanApp."Application Type";
                    pfact.Get(Loans."Product Type");
                    LoanApp.TestField("Product Dimension", pfact."Product Dimension");
                end;
                CopyFromLoanEntries(Loans);
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
        field(50015; "Total Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Total Amount';
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
        field(50018; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
        }
        field(50019; "Outstanding Bill"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Bill';
            DataClassification = CustomerContent;
        }
        field(50020; "Untransfered Interest"; Decimal)
        {
            Caption = 'Untransfered Interest';
            DataClassification = CustomerContent;
        }
        field(50021; "Outstanding Fee"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Outstanding Fee';
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
        field(50026; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Deffered,Posted';
            OptionMembers = "Open","Pending Approval","Approved","Rejected","Deffered","Posted";
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
        field(50031; "Total Total Up"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50032; "Outstanding Insurance"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Insurance';
            DataClassification = CustomerContent;
        }
        field(50033; "Total Outstanding Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Total Outstanding Amount';
            DataClassification = CustomerContent;
        }
        field(50034; "Application Type"; Enum "LoanApplictionType")
        {
            Editable = false;
            Caption = 'Application Type';
            DataClassification = CustomerContent;
        }
        field(50035; "Settlement Fee"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50036; "Restructure Fee"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50037; "Ignore Charges"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.", "Account No.", "Loan Top Up", "Loan No.")
        {
            Clustered = true;
            SumIndexFields = "Total Amount","Outstanding Principle";
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

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
    procedure fnCheckValidRequirement(LoanNo: Code[20])
    var
        LoanApp: Record "Loan Application";
    begin
        LoanApp.Get(LoanNo);
    end;

    local procedure getTopupComms()
    begin
        RegMngt.ComputeLoanCharges("Product Type", '', 0, "Total Amount")
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
        Loans.CalcFields("Outstanding Principal", "Outstanding Bill", "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
        "Product Type" := Loans."Product Type";

        if LoanApp.Get("No.") then begin
            if LoanApp."Product Type" <> "Product Type" then
                "Ignore Charges" := true;
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
        "Total Total Up" := Loans."Outstanding Balance";

        LnProdCharge.Reset();
        LnProdCharge.SetRange("Product Code", "Product Type");
        LnProdCharge.SetRange("Charge Type", LnProdCharge."Charge Type"::"Top up");
        if LnProdCharge.FindFirst() then begin
            case LnProdCharge."Charging Option" of
                LnProdCharge."Charging Option"::"On Outstanding Balance":
                    begin
                        "Total Outstanding Amount" := Loans."Outstanding Balance";
                    end;
                LnProdCharge."Charging Option"::"On Principle Balance":
                    begin
                        "Total Outstanding Amount" := Loans."Outstanding Principal";
                    end;
            end;
        end else begin

            "Total Outstanding Amount" := Loans."Outstanding Balance";
        end;

        case "Application Type" of
            "Application Type"::"Loan Restructure":
                begin
                    "Restructure Fee" := RegMngt.ComputeLoanApplicationCharges("Product Type", "No.", 0, "Total Outstanding Amount", ChargeType::Restructure);
                end else begin
                "Restructure Fee" := 0;
            end;
        end;

        if not "Ignore Charges" then
            Commision := ("Restructure Fee" + RegMngt.ComputeLoanApplicationCharges("Product Type", "No.", 0, "Total Outstanding Amount", ChargeType::"Top up"))
        else
            Commision := 0;

        if not "Ignore Charges" then
            "Total Total Up" := ("Total Outstanding Amount" + Commision + "Settlement Fee" + Loans."Outstanding Interest") else
            "Total Total Up" := ("Total Outstanding Amount" + "Settlement Fee" + Loans."Outstanding Interest")
    end;

    procedure CopyFromLoansTopup(LoansTopup: Record "Loans Top up")

    begin
        "Product Type" := LoansTopup."Product Type";
        "Outstanding Principle" := LoansTopup."Outstanding Principle";
        "Outstanding Interest" := LoansTopup."Outstanding Interest";
        "Total Amount" := LoansTopup."Total Outstanding Amount";
        "Outstanding Balance" := LoansTopup."Outstanding Balance";
        Commision := LoansTopup.Commision;
        "Settlement Fee" := LoansTopup."Settlement Fee";
        "Untransfered Interest" := LoansTopup."Untransfered Interest";
        "Outstanding Bill" := LoansTopup."Outstanding Balance";
        "Outstanding Fee" := LoansTopup."Outstanding Fee";
        "Total Total Up" := LoansTopup."Total Total Up";
        "Application Type" := LoansTopup."Application Type";
        "Restructure Fee" := LoansTopup."Restructure Fee";
        "Ignore Charges" := LoansTopup."Ignore Charges";
        "Ignore Related Balance" := LoansTopup."Ignore Related Balance";

    end;

    procedure getAcruedInterest(LoanNo: Code[100])
    var
        Loans: Record Loans;
    begin
        if Loans.Get(LoanNo) then begin
            Loans.CalcFields("Outstanding Principal", "Outstanding Bill",
        "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");

            if Loans."Outstanding Balance" > 0 then begin

                //   EndDate := Today;
                //   StartDate := CalcDate('-CM', EndDate);
                // IntDays := (EndDate - StartDate) + 1;
                //"Untransfered Interest" := PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate);
                "Outstanding Principle" := Loans."Outstanding Principal";
                "Outstanding Bill" := Loans."Outstanding Bill";
                "Outstanding Insurance" := Loans."Outstanding Insurance";
                "Outstanding Interest" := Loans."Outstanding Interest";
                "Outstanding Balance" := (Loans."Outstanding Balance" + "Untransfered Interest");
                "Total Outstanding Amount" := (Loans."Outstanding Balance" + "Untransfered Interest");
                "Monthly Repayment" := Loans.Repayment;
                case "Application Type" of
                    "Application Type"::"Loan Restructure":
                        begin
                            Commision := RegMngt.ComputeLoanApplicationCharges("Product Type", "No.", 0, "Total Outstanding Amount", ChargeType::Restructure);
                        end else begin
                        Commision := RegMngt.ComputeLoanApplicationCharges("Product Type", "No.", 0, "Total Outstanding Amount", ChargeType::"Top up");
                    end;
                end;
                "Total Total Up" := "Total Outstanding Amount" + Commision;
                Modify(true)
            end
        end;
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

}




