table 50464 "Recovery Header"
{
    DrillDownPageID = "Recovery List";
    LookupPageID = "Recovery List";
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();

            end;
        }
        field(50010; "Account No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ProdtCategory: Enum ProductAccountCategory;
                FosaAc: Record "Account Banking";
                TellMngt: Codeunit "Teller-Post (Yes/No)";
                ErrorOnNonAvailableShares: Label 'Member has %1 Shares and therefore cannot be allowed to recover loan from shares';
            begin

                fnUpdateField();
                if Members.Get("Account No.") then begin
                    Name := Members.Name;
                    FosaAc.Reset();
                    FosaAc.SetRange("Member No.", "Account No.");
                    FosaAc.SetRange("Account Category", FosaAc."Account Category"::Savings);
                    if FosaAc.FindFirst() then
                        "Account to Debit" := FosaAc."No.";
                    if "Application Source" = "Application Source"::Manual then begin
                        "Shares Deposits" := RegMngt.GetOperationAccNoBalanceTxt(ProdtCategory::"Shares Deposit", "Account No.", 2);
                        if "Application Type" = "Application Type"::"Recovery from Shares" then
                            if "Shares Deposits" <= 0 then Error(ErrorOnNonAvailableShares, "Shares Deposits");
                    end else begin
                        if Members.Status = Members.Status::Defaulter then
                            "Shares Deposits" := 0 else
                            "Shares Deposits" := RegMngt.GetOperationAccNoBalanceTxt(ProdtCategory::"Shares Deposit", "Account No.", 2);
                    end;

                    case "Application Type" of
                        "Application Type"::"Fosa Recovery":
                            begin
                                FosaAc.Reset();
                                FosaAc.SetRange("Member No.", "Account No.");
                                FosaAc.SetRange("Account Category", FosaAc."Account Category"::"Specialty Savings");
                                if FosaAc.FindFirst() then
                                    FosaAc.CalcFields("Balance (LCY)");

                                if TellMngt.CalcAvailableBal(FosaAc."No.") <= 0 then
                                    Error(ErrorOnNonAvailableShares, TellMngt.CalcAvailableBal(FosaAc."No."));
                                Validate("Account to Debit", FosaAc."No.");
                            end;
                    end;
                end else begin
                    Name := ''
                end;

            end;
        }
        field(50011; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Loan No."; Code[20])
        {
            TableRelation = IF ("Recovery Type" = CONST("Specific Loan"))
            Loans."No." WHERE("Outstanding Balance" = FILTER(> 0), "Account No." = FIELD("Account No."));
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                PLoan: Record Loans;
                PFact: Record "Product Factory";
                LoanApp: Record Loans;
                Guarantor: Record "Guarantor & Security Posted";
            begin

                TestField("Recovery Type", "Recovery Type"::"Specific Loan");
                TestField("Account No.");
                TestField("Application Type");
                fnClearLines();

                if LoanApp.Get("Loan No.") then begin
                    if "Guarantor Recovery Options" = "Guarantor Recovery Options"::"Recovery Shares" then begin
                 LoanApp.InsertSelfGuaranteedEntry(LoanApp."Product Type", LoanApp."Account No.",LoanApp."No.", LoanApp."Application No.");
                    end;
                    PurchRecMgt.fngetLoanBalance(Rec, 1);
                    getloanGuarantor();
                end;
            end;
        }
        field(50013; "Date Entered"; Date)
        {
            Editable = false;
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50014; "Entered By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50015; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
            begin
                PurchRecMgt.CreatLoanAcc(Rec);
            end;
        }
        field(50016; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50017; "Outstanding Interest"; Decimal)
        {
            Caption = 'Outstanding Interest';
            DataClassification = CustomerContent;
        }
        field(50018; "Shares Deposits"; Decimal)
        {
            Caption = 'Shares Deposits';
            DataClassification = CustomerContent;
        }
        field(50019; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50020; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50021; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50022; "Recovery Type"; Option)
        {
            OptionCaption = ' ,Specific Loan,All Loans';
            OptionMembers = " ","Specific Loan","All Loans";
            Caption = 'Recovery Type';
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Account No.");
                TestField("Application Type");

                fnClearLines();
                if "Recovery Type" = "Recovery Type"::"All Loans" then begin
                    "Loan No." := '';
                    PurchRecMgt.fngetLoanBalance(Rec, 2);
                    getloanGuarantor();
                end;

            end;
        }
        field(50023; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Posted';
        }
        field(50024; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50025; "Outstanding Bill"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Outstanding Bill';
        }
        field(50026; "Outstanding Principal"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Outstanding Principal';
        }
        field(50027; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(50028; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(50029; "Responsibility Centre"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Responsibility Center".Code;
            Caption = 'Responsibility Centre';
        }
        field(50030; "Total Amount LCY"; Decimal)
        {
            CalcFormula = Sum("Loan Disbursement Lines".Amount WHERE(No = FIELD("No."),
                                                                      "Default Account No." = FIELD("Account No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Amount LCY';
        }
        field(50031; "Shares Deductable"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50032; "No of Active Loans"; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50033; "Application Type"; Enum "LoanRecoveryType")
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DisburseLine: Record "Loan Disbursement Lines";
            begin
                fnClearLines();
                "Total Loans Bal." := 0;
                "No of Active Loans" := 0;

                case "Application Type" of
                    "Application Type"::"Fosa Recovery":
                        begin
                            "Shares Recovery Options" := "Shares Recovery Options"::" ";
                            "Account Type" := "Account Type"::Savings;
                            "Guarantor Recovery Options" := "Guarantor Recovery Options"::" ";
                        end;
                    "Application Type"::"Place Lien":
                        begin
                            "Shares Recovery Options" := "Shares Recovery Options"::" ";
                            "Guarantor Recovery Options" := "Guarantor Recovery Options"::" ";
                        end;
                    "Application Type"::"Recovery from Shares":
                        begin
                            "Guarantor Recovery Options" := "Guarantor Recovery Options"::" ";
                            "Shares Recovery Options" := "Shares Recovery Options"::"Recovery All Shares";
                            "Account Type" := "Account Type"::Credit;
                        end;
                    "Application Type"::"Recover from guarantors":
                        begin
                            "Shares Recovery Options" := "Shares Recovery Options"::" ";
                            "Account Type" := "Account Type"::Credit;
                            "Guarantor Recovery Options" := "Guarantor Recovery Options"::"Create Loan";
                        end;
                end;
            end;
        }
        field(50034; "Total Loans Bal."; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Total Loans Bal.';
        }
        field(50035; "Transaction Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50036; "Post As"; Option)
        {
            OptionMembers = " ","Post as User","Post Automatically";
        }
        field(50037; "Account Type"; Enum "AccountTypesExtended")
        {
            Caption = 'Account Type';
            ValuesAllowed = 7, 8;
            DataClassification = CustomerContent;
        }
        field(50038; "Account to Debit"; Code[20])
        {
            TableRelation = if ("Account Type" = const(Savings)) "Account Banking" where(Blocked = const(" "), "Account Category" = filter(Savings | "Specialty Savings"), Status = const(Active), "Balance (LCY)" = filter(> 0), "Member No." = field("Account No."), "Account Category" = filter(<> "Certificates of Deposit"))
            else
            if ("Account Type" = const(Credit)) "Account Credit" where(Blocked = const(" "), Status = const(Active), "Balance (LCY)" = filter('>0'), "Member No." = field("Account No."), "Account Category" = filter("Shares Deposit"));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                AccBanking: Record "Account Banking";
                AcBosa: Record "Account Credit";
                LoansT: Record Loans;
                TellMngt: Codeunit "Teller-Post (Yes/No)";

            begin

                case "Application Type" of
                    "Application Type"::"Recovery from Shares":
                        begin
                            AccBanking.Reset();
                            AccBanking.SetRange("No.", "Account to Debit");
                            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                            if AccBanking.FindFirst() then begin
                                AccBanking.CalcFields("Balance (LCY)");
                                "Available Balance" := TellMngt.CalcAvailableBal(AccBanking."No.");
                            end;

                            AcBosa.Reset();
                            AcBosa.SetRange("Member No.", "Account No.");
                            AcBosa.SetRange("Account Category", AcBosa."Account Category"::"Shares Deposit");
                            if AcBosa.FindFirst() then begin
                                AcBosa.CalcFields("Balance (LCY)");
                                Amount := AcBosa."Balance (LCY)"
                            end;
                        end;

                    "Application Type"::"Fosa Recovery":
                        begin
                            AccBanking.Reset();
                            AccBanking.SetRange("No.", "Account to Debit");
                            AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Specialty Savings");
                            if AccBanking.FindFirst() then begin
                                AccBanking.CalcFields("Balance (LCY)");
                                "Available Balance" := TellMngt.CalcAvailableBal(AccBanking."No.");
                                Amount := "Available Balance";
                            end;
                        end;
                end;
            end;
        }
        field(50039; "Available Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50040; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                TellMngt: Codeunit "Teller-Post (Yes/No)";
                AccBanking: Record "Account Banking";
            begin
                TestField("Account to Debit");
                case "Application Type" of
                    "Application Type"::" ",
                    "Application Type"::"Recover from guarantors",
                    "Application Type"::"Recovery from Shares":
                        begin
                            Error('Option(s) not allowed %1', "Application Type");
                        end;
                end;
                if Amount > TellMngt.CalcAvailableBal("Account to Debit") then
                    Error('Amount cannot be more than Available balance');
            end;
        }
        field(50041; "Acrued Interest Options"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Charge Accrued Interest","Ignore Acrued Interest";
            Editable = false;
        
            trigger OnValidate()
            var
                DisburseLine: Record "Loan Disbursement Lines";
            begin

                case "Acrued Interest Options" of
                    "Acrued Interest Options"::"Ignore Acrued Interest":
                        begin
                            "Loan No." := '';
                            fnClearLines();
                        end
                end;
            end;
        }
        field(50042; "Application Source"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "","Manual","Automated";
        }
        field(50043; "Accrued Interest"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50044; "Outstanding Insurance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50045; "Send Notification"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,SMS,Email,SMS+Email';
            OptionMembers = " ","SMS","Email","SMS+E-Mail";
        }
        field(50046; "Guarantor Recovery Options"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Create New Loan,Recovery Shares';
            OptionMembers = " ","Create Loan","Recovery Shares";
        
            trigger OnValidate()
            begin
                TestField("Application Type", "Application Type"::"Recover from guarantors");

            end;
        }

        field(50047; "Shares Recovery Options"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Recovery All Shares,Aportion Shares';
            OptionMembers = " ","Recovery All Shares","Aportion Shares";
        
            trigger OnValidate()
            begin
                TestField("Application Type", "Application Type"::"Recovery from Shares");
            end;
        }
        field(50048; "Recovery On Collateral"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50049; "Post Journal"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            CreditNosSeries.Get;
            case Rec."Application Source" of
                Rec."Application Source"::Manual:
                    begin
                        CreditNosSeries.TestField(CreditNosSeries."Loan Recovery");
                        "No. Series" := CreditNosSeries."Loan Recovery";
                        if NoSeriesMgt.AreRelated(CreditNosSeries."Loan Recovery", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")

                    end;
                Rec."Application Source"::Automated:
                    begin
                        CreditNosSeries.TestField(CreditNosSeries."QC Recovery Nos");
                        "No. Series" := CreditNosSeries."Loan Recovery";
                        if NoSeriesMgt.AreRelated(CreditNosSeries."QC Recovery Nos", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")

                    end;
            end;
        end;
        PassDocumentNo();

    end;


    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Recovery Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                CreditNosSeries.Get();

                case Rec."Application Source" of
                    Rec."Application Source"::Manual:
                        begin
                            CreditNosSeries.TestField(CreditNosSeries."Loan Recovery");
                            NoSeriesMgt.TestManual(CreditNosSeries."Loan Recovery");
                            "No. Series" := '';

                        end;
                    Rec."Application Source"::Automated:
                        begin
                            CreditNosSeries.TestField(CreditNosSeries."QC Recovery Nos");
                            NoSeriesMgt.TestManual(CreditNosSeries."QC Recovery Nos");
                            "No. Series" := '';

                        end;
                end;
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Recovery Header"; xRecRef: Record "Recovery Header"; var IsHandled: Boolean)
    begin
    end;

    var
        CreditNosSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Members: Record Member;
        Loans: Record Loans;
        CredAcc: Record "Account Credit";
        RegMngt: Codeunit "Register Management";
        ProdType: Record "Product Factory";
        PeriodicMgt: Codeunit "Periodic Activities Mgt.";
        PurchRecMgt: Codeunit "Purch. Recov.-Post (Yes/No)";
        DisbursementLine: Record "Loan Disbursement Lines";
        GuarantorSecurity: Record "Guarantor & Security Posted";
        ErrorOnNoLineExist: Label 'There are no payment lines for this document';

    procedure getloanGuarantor()
    var
        AccountCredit: Record "Account Credit";
        AccBanking: Record "Account Banking";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        RunBal: array[12] of Decimal;
        NoOfGuarantTxt: Integer;
        NoOfGuarant: Integer;
        CountLoop: Integer;
        Guarant: Record "Guarantor & Security Posted";
        NoOfSelfGuarant: Integer;
        StartDate: Date;
        EndDate: Date;
        DisburseLine: Record "Loan Disbursement Lines";
        IntDays: Integer;
        RegMgt: Codeunit "Register Management";
        PostdLoan: Record Loans;
        TLoan: Record Loans;
        CustLoan: Record Loans;

    begin

        fnClearLines();

        case "Application Type" of
            "Application Type"::"Recovery from Shares":
                begin

                    case "Shares Recovery Options" of
                        "Shares Recovery Options"::"Aportion Shares":
                            fnAportionShares();
                        "Shares Recovery Options"::"Recovery All Shares":
                            fnRecoverAllShares();
                    end;
                end;
            "Application Type"::"Recover from guarantors":
                begin
                    case "Guarantor Recovery Options" of
                        "Guarantor Recovery Options"::"Create Loan":
                            begin
                                fnCreateGuarantorLoan();
                            end;
                        "Guarantor Recovery Options"::"Recovery Shares":
                            begin
                                fnRecoverGuarantor();
                            end;
                    end;
                end;
            "Application Type"::"Fosa Recovery":
                begin
                    fnRecoveryFromBankingAc();
                end;
            "Application Type"::"Place Lien":
                begin

                end;
        end;
    end;

    procedure CountGuarantor(LoanNo: Code[20]): Integer
    var
        NoOfGuarantor: Integer;
        Accredit: Record "Account Credit";
    begin
        GuarantorSecurity.Reset;
        GuarantorSecurity.SetRange("Loan No.", LoanNo);
        GuarantorSecurity.SetRange(Substituted, false);
        if GuarantorSecurity.Find('-') then begin
            repeat
                if Accredit.Get(GuarantorSecurity."Account No.") then begin
                    Accredit.CalcFields("Balance (LCY)");
                    if Accredit."Balance (LCY)" > 0 then begin
                        NoOfGuarantor := NoOfGuarantor + 1;
                    end;
                end;
            Until GuarantorSecurity.Next() = 0;
        end;
        exit(NoOfGuarantor)
    end;

    local procedure LoanAmtAcruedInt(AccountNo: Code[100]) TotalLoan: Decimal;
    var
        EndDate: Date;
        StartDate: Date;
        IntDays: Integer;
        PeriodicMgt: Codeunit "Periodic Activities Mgt.";
        AcruedInt: Decimal;
    begin

        Loans.Reset;
        Loans.SetRange("Account No.", AccountNo);
        Loans.SetFilter("Deposits Appraisal Parameter", '<>%1', Loans."Deposits Appraisal Parameter"::Collateral);
        if Loans.FindSet() then begin
            repeat
                Loans.CalcFields("Outstanding Balance");
                if Loans."Outstanding Balance" > 0 then begin

                    EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;
                    AcruedInt := AcruedInt + PeriodicMgt.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate);
                    TotalLoan := TotalLoan + Loans."Outstanding Balance";
                end;
            until Loans.Next = 0;
        end;
        exit(TotalLoan + AcruedInt);
    end;

    local procedure fnTotalGuarantorAmt(LoanNo: Code[20]): Decimal
    var
        TotAmt: Decimal;
    begin
        GuarantorSecurity.Reset;
        GuarantorSecurity.SetRange("Loan No.", LoanNo);
        GuarantorSecurity.SetRange(Substituted, false);
        if GuarantorSecurity.Find('-') then begin
            GuarantorSecurity.CalcSums("Amount Guaranteed");
            repeat
                if CredAcc.Get(GuarantorSecurity."Account No.") then begin
                    CredAcc.CalcFields("Balance (LCY)");
                    TotAmt := TotAmt + CredAcc."Balance (LCY)";
                end;
            until GuarantorSecurity.Next = 0;
        end;
        exit(TotAmt)
    end;

    local procedure fnTotalLoanGuaranteedAmt(LoanNo: Code[50]): Decimal
    var
        TotAmt: Decimal;
        GuarantorSec: Record "Guarantor & Security Posted";

    begin
        GuarantorSec.Reset;
        GuarantorSec.SetRange("Loan No.", LoanNo);
        GuarantorSec.SetRange(Substituted, false);
        if GuarantorSec.FindSet() then begin
            GuarantorSec.CalcSums("Amount Guaranteed");
            TotAmt := GuarantorSec."Amount Guaranteed";
            exit(TotAmt)
        end;
        exit(0)
    end;

    local procedure NoofLoanAmt(AccountNo: Code[100]) TotalLoan: Decimal;
    var

    begin
        Loans.Reset;
        Loans.SetRange("Account No.", AccountNo);
        Loans.SetFilter("Outstanding Balance", '>0');
        Loans.SetFilter("Deposits Appraisal Parameter", '<>%1', Loans."Deposits Appraisal Parameter"::Collateral);
        if Loans.FindSet() then begin
            repeat
                Loans.CalcFields("Outstanding Balance");
                TotalLoan := TotalLoan + Loans."Outstanding Balance";
            until Loans.Next = 0;
        end;
        exit(TotalLoan);

    end;

    local procedure NoofLoanCount(AccountNo: Code[100]): Integer
    var
        LoanCount: Decimal;
    begin
        Loans.Reset;
        Loans.SetRange("Account No.", AccountNo);
        Loans.SetFilter("Outstanding Balance", '>0');
        Loans.SetFilter("Deposits Appraisal Parameter", '<>%1', Loans."Deposits Appraisal Parameter"::Collateral);
        if Loans.FindSet() then begin
            LoanCount := Loans.Count
        end;
        exit(LoanCount)
    end;

    procedure fnCheckMinRequirement()
    var
        AccBanking: Record "Account Banking";
        AvailBal: Decimal;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
    begin
        TestField("Post As");
        TestField("Application Type");
        TestField("Account No.");
        TestField("Loan No.");
        TestField("Posting Date");
        if "Application Type" = "Application Type"::"Recovery from Shares" then
            TestField("Shares Recovery Options");
        if "Application Type" = "Application Type"::"Recover from guarantors" then begin
            TestField("Guarantor Recovery Options");
            if "Guarantor Recovery Options" = "Guarantor Recovery Options"::"Create Loan" then
                CheckIfLoanMarked();
        end;

        TestField("Recovery Type");
        case "Recovery Type" of
            "Recovery Type"::"Specific Loan":
                TestField("Loan No.");
        end;

        if not LinesExists() then Error(ErrorOnNoLineExist);
        AllFieldsEntered();

        AvailBal := 0;
        if "Application Type" = "Application Type"::"Fosa Recovery" then begin
            AccBanking.Reset();
            AccBanking.SetRange("No.", "Account to Debit");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange(Status, AccBanking.Status::Active);
            if AccBanking.FindFirst() then begin
                AccBanking.CalcFields("Balance (LCY)");
                AvailBal := TellMngt.CalcAvailableBal(AccBanking."No.");
                if AccBanking."Balance (LCY)" > 0 then begin
                    if (Amount > AvailBal) or (AccBanking."Balance (LCY)" = 0) then begin
                        Error('No enough funds in member account to execute this transaction');
                    end
                end else begin
                    Error('No enough funds in member account to execute this transaction');
                end;
            end
        end;
    end;

    procedure CheckIfLoanMarked()
    var
        LoanDisLine: Record "Loan Disbursement Lines";
        LoanApp: Record Loans;
        PLoan: Record Loans;
    begin
        LoanApp.Reset();
        LoanApp.SetRange("Recovery No.", "No.");
        if LoanApp.FindSet() then begin
            repeat
                LoanDisLine.Reset();
                LoanDisLine.SetRange(Amount, LoanApp."Approved Amount");
                LoanDisLine.SetRange(No, LoanApp."Recovery No.");
                if LoanDisLine.FindFirst() then begin
                    LoanDisLine."Application No." := LoanApp."Application No.";
                    LoanDisLine."Loan Entry No." := LoanApp."No.";
                    LoanDisLine."Member No." := LoanApp."Account No.";
                    LoanDisLine.Modify(true);
                end;
            until LoanApp.Next() = 0;
        end;
    end;

    procedure LinesExists(): Boolean
    var
        HasLines: Boolean;
        PayLines: Record "Loan Disbursement Lines";
    begin
        HasLines := false;
        PayLines.Reset();
        PayLines.SetRange(No, "No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end else begin
            exit(false)
        end;

    end;

    procedure AllFieldsEntered()
    var
        AllKeyFieldsEntered: Boolean;
        PayLine: Record "Loan Disbursement Lines";
    begin

        PayLine.Reset();
        PayLine.SetRange(No, "No.");
        IF PayLine.Find('-') then begin
            repeat
                PayLine.TestField("Account No.");
                PayLine.TestField(Amount);
            until PayLine.Next() = 0;
        end;
    end;

    procedure fnUpdateField()
    begin
        "Loan No." := '';
        Amount := 0;
        "Available Balance" := 0;
        "Shares Deposits" := 0;
        "Accrued Interest" := 0;
        "Outstanding Balance" := 0;
        "Outstanding Bill" := 0;
        "Outstanding Interest" := 0;
        "Outstanding Principal" := 0;
        "Total Amount LCY" := 0;
        "Total Loans Bal." := 0;
    end;

    local procedure PassDocumentNo()
    var
        ExemptionsApprvl: Record "User Setup";
        PFact: Record "Product Factory";
        ObjectEmp: Record Employee;
    begin

        ExemptionsApprvl.Get(UserId);
        ExemptionsApprvl.TestField("Responsibility Centre");
        ExemptionsApprvl.TestField("Global Dimension 1 Code");
        ExemptionsApprvl.TestField("Global Dimension 2 Code");

        "Responsibility Centre" := ExemptionsApprvl."Responsibility Centre";
        "Shortcut Dimension 1 Code" := ExemptionsApprvl."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := ExemptionsApprvl."Global Dimension 2 Code";
        "Entered By" := UserId;
        "Date Entered" := Today;
        "Posting Date" := Today;
        "Recovery Type" := "Recovery Type"::"Specific Loan";

    end;

    local procedure fnRecoverAllShares()
    var
        AccountCredit: Record "Account Credit";
        AccBanking: Record "Account Banking";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        RunBal: array[12] of Decimal;
        NoOfGuarantTxt: Integer;
        NoOfGuarant: Integer;
        CountLoop: Integer;
        Guarant: Record "Guarantor & Security Posted";
        NoOfSelfGuarant: Integer;
        StartDate: Date;
        EndDate: Date;
        DisburseLine: Record "Loan Disbursement Lines";
        IntDays: Integer;
        RegMgt: Codeunit "Register Management";
        PostdLoan: Record Loans;
        TLoan: Record Loans;
        CustLoan: Record Loans;
    begin

        if "Recovery Type" = "Recovery Type"::"All Loans" then begin

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");
                if AccountCredit."Balance (LCY)" > 0 then begin

                    PostdLoan.Reset();
                    PostdLoan.SetRange("Account No.", "Account No.");
                    if PostdLoan.Find('-') then begin
                        repeat
                            PostdLoan.CalcFields("Outstanding Balance", "Outstanding Bill",
                            "Outstanding Interest", "Outstanding Principal");

                            if PostdLoan."Outstanding Balance" > 0 then begin

                                RunBal[1] := 0;
                                RunBal[2] := 0;
                                RunBal[3] := 0;
                                RunBal[5] := 0;
                                RunBal[6] := 0;
                                RunBal[8] := 0;

                                NoOfSelfGuarant := 0;
                                NoOfGuarantTxt := 0;

                                EndDate := Today;
                                StartDate := CalcDate('-CM', Today);
                                IntDays := (EndDate - StartDate) + 1;

                                case "Acrued Interest Options" of
                                    "Acrued Interest Options"::"Charge Accrued Interest":
                                        begin

                                            RunBal[6] := LoanAmtAcruedInt("Account No.");
                                            if RunBal[6] < 0 then
                                                RunBal[6] := 0;

                                            RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                            "Accrued Interest" := ("Accrued Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate));
                                            "Outstanding Interest" := "Outstanding Interest" + PostdLoan."Outstanding Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                            "Outstanding Balance" := "Outstanding Balance" + PostdLoan."Outstanding Balance" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                        end;
                                    "Acrued Interest Options"::"Ignore Acrued Interest":
                                        begin
                                            RunBal[6] := NoofLoanAmt("Account No.");
                                            if RunBal[6] < 0 then
                                                RunBal[6] := 0;
                                            RunBal[8] := 0;
                                            "Accrued Interest" := 0;
                                        end;
                                end;

                                Guarant.Reset;
                                Guarant.SetRange("Loan No.", PostdLoan."No.");
                                Guarant.SetRange(Substituted, false);
                                if Guarant.Find('-') then begin
                                    NoOfSelfGuarant := Guarant.Count;
                                end;

                                if (NoOfSelfGuarant = 1) and (PostdLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                                    RunBal[5] := AccountCredit."Balance (LCY)"

                                end else begin

                                    if RunBal[6] = 0 then
                                        RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                        RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                                end;

                                RunBal[1] := AccountCredit."Balance (LCY)";

                                if RunBal[5] >= RunBal[1] then
                                    RunBal[5] := RunBal[1] else
                                    RunBal[5] := RunBal[5];

                                "Shares Deductable" := RunBal[5];
                                "No of Active Loans" := NoofLoanCount("Account No.");
                                "Total Loans Bal." := RunBal[5];
                                NoOfGuarantTxt := 0;
                                NoOfGuarantTxt := CountGuarantor(PostdLoan."No.");

                                if RunBal[5] > 0 then begin

                                    if ProdType.Get(PostdLoan."Product Type") then
                                        if "Recovery On Collateral" then begin

                                            DisbursementLine.LockTable;
                                            PeriodicMgt.InitializeRecoveryHeaderEntry(DisbursementLine, "No.", AccountCredit."Balance (LCY)",
                                            "Account No.", PostdLoan."No.");
                                            DisbursementLine."Account No." := AccountCredit."No.";
                                            DisbursementLine.Date := "Posting Date";
                                            DisbursementLine."Loan No." := PostdLoan."No.";
                                            DisbursementLine."Account Name" := Name;
                                            if PostdLoan."Outstanding Interest" <> 0 then
                                                DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                                DisbursementLine."Interest Balance" := 0;
                                            DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                            DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                            DisbursementLine."Accrued Interest" := RunBal[8];
                                            if RunBal[5] > (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                                DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                                DisbursementLine.Amount := RunBal[5];
                                            DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                            DisbursementLine.Insert(true);
                                        end else begin

                                            GuarantorSecurity.Reset;
                                            GuarantorSecurity.SetRange("Loan No.", PostdLoan."No.");
                                            GuarantorSecurity.SetRange(Substituted, false);
                                            if GuarantorSecurity.Find('-') then begin

                                                DisbursementLine.LockTable;
                                                PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                                DisbursementLine."Account No." := AccountCredit."No.";
                                                DisbursementLine."Loan No." := PostdLoan."No.";
                                                DisbursementLine.Date := "Posting Date";
                                                DisbursementLine."Account Name" := Name;
                                                if PostdLoan."Outstanding Interest" <> 0 then
                                                    DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                                    DisbursementLine."Interest Balance" := 0;
                                                DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                                DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                DisbursementLine."Accrued Interest" := RunBal[8];
                                                if RunBal[5] >= (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                                    DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                                    DisbursementLine.Amount := RunBal[5];
                                                DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                                DisbursementLine.Insert(true);
                                            end else begin
                                                Error('There are No Guarantors attached to this loan');
                                            end;
                                        end;
                                end;
                            end;
                        until PostdLoan.Next() = 0;
                    end;
                end
            end;

        end else begin
            TestField("Loan No.");

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");
                if AccountCredit."Balance (LCY)" > 0 then begin

                    PostdLoan.Reset();
                    PostdLoan.SetRange("No.", "Loan No.");
                    if PostdLoan.Find('-') then begin

                        PostdLoan.CalcFields("Outstanding Balance", "Outstanding Bill", "Outstanding Interest",
                        "Outstanding Principal");

                        if PostdLoan."Outstanding Balance" > 0 then begin

                            RunBal[1] := 0;
                            RunBal[2] := 0;
                            RunBal[3] := 0;
                            RunBal[5] := 0;
                            RunBal[6] := 0;
                            RunBal[8] := 0;

                            NoOfSelfGuarant := 0;
                            NoOfGuarantTxt := 0;

                            EndDate := Today;
                            StartDate := CalcDate('-CM', Today);
                            IntDays := (EndDate - StartDate) + 1;

                            case "Acrued Interest Options" of
                                "Acrued Interest Options"::"Charge Accrued Interest":
                                    begin

                                        RunBal[6] := LoanAmtAcruedInt("Account No.");
                                        if RunBal[6] < 0 then
                                            RunBal[6] := 0;

                                        RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                        "Accrued Interest" := ("Accrued Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate));
                                        "Outstanding Interest" := "Outstanding Interest" + PostdLoan."Outstanding Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                        "Outstanding Balance" := "Outstanding Balance" + PostdLoan."Outstanding Balance" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                    end;
                                "Acrued Interest Options"::"Ignore Acrued Interest":
                                    begin
                                        RunBal[6] := NoofLoanAmt("Account No.");
                                        if RunBal[6] < 0 then
                                            RunBal[6] := 0;
                                        RunBal[8] := 0;
                                        "Accrued Interest" := 0;
                                    end;
                            end;

                            Guarant.Reset;
                            Guarant.SetRange("Loan No.", PostdLoan."No.");
                            Guarant.SetRange(Substituted, false);
                            if Guarant.Find('-') then begin
                                NoOfSelfGuarant := Guarant.Count;
                            end;

                            if (NoOfSelfGuarant = 1) and (PostdLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                                RunBal[5] := AccountCredit."Balance (LCY)"
                            end else begin

                                if RunBal[6] = 0 then
                                    RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                    RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                            end;

                            RunBal[1] := AccountCredit."Balance (LCY)";

                            if RunBal[5] >= RunBal[1] then
                                RunBal[5] := RunBal[1] else
                                RunBal[5] := RunBal[5];

                            "Shares Deductable" := RunBal[5];
                            "No of Active Loans" := NoofLoanCount("Account No.");
                            "Total Loans Bal." := RunBal[5];
                            NoOfGuarantTxt := 0;
                            NoOfGuarantTxt := CountGuarantor(PostdLoan."No.");

                            if RunBal[5] > 0 then begin

                                if ProdType.Get(PostdLoan."Product Type") then
                                    if "Recovery On Collateral" then begin

                                        DisbursementLine.LockTable;
                                        PeriodicMgt.InitializeRecoveryHeaderEntry(DisbursementLine, "No.", AccountCredit."Balance (LCY)",
                                        "Account No.", PostdLoan."No.");
                                        DisbursementLine."Account No." := AccountCredit."No.";
                                        DisbursementLine.Date := "Posting Date";
                                        DisbursementLine."Loan No." := PostdLoan."No.";
                                        DisbursementLine."Account Name" := Name;
                                        if PostdLoan."Outstanding Interest" <> 0 then
                                            DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                            DisbursementLine."Interest Balance" := 0;
                                        DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                        DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                        DisbursementLine."Accrued Interest" := RunBal[8];
                                        if RunBal[5] > (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                            DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                            DisbursementLine.Amount := RunBal[5];
                                        DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                        DisbursementLine.Insert(true);
                                    end else begin

                                        GuarantorSecurity.Reset;
                                        GuarantorSecurity.SetRange("Loan No.", PostdLoan."No.");
                                        GuarantorSecurity.SetRange(Substituted, false);
                                        if GuarantorSecurity.Find('-') then begin

                                            DisbursementLine.LockTable;
                                            PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                            DisbursementLine."Account No." := AccountCredit."No.";
                                            DisbursementLine."Loan No." := PostdLoan."No.";
                                            DisbursementLine.Date := "Posting Date";
                                            DisbursementLine."Account Name" := Name;
                                            if PostdLoan."Outstanding Interest" <> 0 then
                                                DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                                DisbursementLine."Interest Balance" := 0;
                                            DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                            DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                            DisbursementLine."Accrued Interest" := RunBal[8];
                                            if RunBal[5] >= (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                                DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                                DisbursementLine.Amount := RunBal[5];
                                            DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                            DisbursementLine.Insert(true);
                                        end else begin

                                            Error('There are No Guarantors attached to this loan');
                                        end;
                                    end;
                            end;
                        end;

                    end;
                end
            end;
        end;
    end;

    local procedure fnAportionShares()
    var
        AccountCredit: Record "Account Credit";
        AccBanking: Record "Account Banking";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        RunBal: array[12] of Decimal;
        NoOfGuarantTxt: Integer;
        NoOfGuarant: Integer;
        CountLoop: Integer;
        Guarant: Record "Guarantor & Security Posted";
        NoOfSelfGuarant: Integer;
        StartDate: Date;
        EndDate: Date;
        DisburseLine: Record "Loan Disbursement Lines";
        IntDays: Integer;
        RegMgt: Codeunit "Register Management";
        PostdLoan: Record Loans;
        TLoan: Record Loans;
        CustLoan: Record Loans;
    begin


        if "Recovery Type" = "Recovery Type"::"All Loans" then begin

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");
                if AccountCredit."Balance (LCY)" > 0 then begin

                    PostdLoan.Reset();
                    PostdLoan.SetRange("Account No.", "Account No.");
                    if PostdLoan.Find('-') then begin
                        repeat
                            PostdLoan.CalcFields("Outstanding Balance", "Outstanding Bill",
                            "Outstanding Interest", "Outstanding Principal");
                            if PostdLoan."Outstanding Balance" > 0 then begin

                                RunBal[1] := 0;
                                RunBal[2] := 0;
                                RunBal[3] := 0;
                                RunBal[5] := 0;
                                RunBal[6] := 0;
                                RunBal[8] := 0;
                                NoOfSelfGuarant := 0;
                                NoOfGuarantTxt := 0;

                                EndDate := Today;
                                StartDate := CalcDate('-CM', Today);
                                IntDays := (EndDate - StartDate) + 1;

                                case "Acrued Interest Options" of
                                    "Acrued Interest Options"::"Charge Accrued Interest":
                                        begin

                                            RunBal[6] := LoanAmtAcruedInt("Account No.");
                                            if RunBal[6] < 0 then
                                                RunBal[6] := 0;

                                            RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                            "Accrued Interest" := ("Accrued Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate));
                                            "Outstanding Interest" := "Outstanding Interest" + PostdLoan."Outstanding Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                            "Outstanding Balance" := "Outstanding Balance" + PostdLoan."Outstanding Balance" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                        end;
                                    "Acrued Interest Options"::"Ignore Acrued Interest":
                                        begin
                                            RunBal[6] := NoofLoanAmt("Account No.");
                                            if RunBal[6] < 0 then
                                                RunBal[6] := 0;
                                            RunBal[8] := 0;
                                            "Accrued Interest" := 0;
                                        end;
                                end;

                                Guarant.Reset;
                                Guarant.SetRange("Loan No.", PostdLoan."No.");
                                Guarant.SetRange(Substituted, false);
                                if Guarant.Find('-') then begin
                                    NoOfSelfGuarant := Guarant.Count;
                                end;

                                if (NoOfSelfGuarant = 1) and (PostdLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                                    RunBal[5] := AccountCredit."Balance (LCY)"

                                end else begin

                                    if RunBal[6] = 0 then
                                        RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                        RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                                end;

                                RunBal[1] := AccountCredit."Balance (LCY)";
                                if RunBal[5] >= RunBal[1] then
                                    RunBal[5] := RunBal[1] else
                                    RunBal[5] := RunBal[5];

                                "Shares Deductable" := RunBal[5];
                                "No of Active Loans" := NoofLoanCount("Account No.");
                                "Total Loans Bal." := RunBal[5];
                                NoOfGuarantTxt := 0;
                                NoOfGuarantTxt := CountGuarantor(PostdLoan."No.");

                                if RunBal[5] > 0 then begin

                                    if ProdType.Get(PostdLoan."Product Type") then
                                        if "Recovery On Collateral" then begin

                                            DisbursementLine.LockTable;
                                            PeriodicMgt.InitializeRecoveryHeaderEntry(DisbursementLine, "No.", AccountCredit."Balance (LCY)",
                                            "Account No.", PostdLoan."No.");
                                            DisbursementLine."Account No." := AccountCredit."No.";
                                            DisbursementLine.Date := "Posting Date";
                                            DisbursementLine."Loan No." := PostdLoan."No.";
                                            DisbursementLine."Account Name" := Name;
                                            if PostdLoan."Outstanding Interest" <> 0 then
                                                DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                                DisbursementLine."Interest Balance" := 0;
                                            DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                            DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                            DisbursementLine."Accrued Interest" := RunBal[8];
                                            if RunBal[5] > (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                                DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                                DisbursementLine.Amount := RunBal[5];
                                            DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                            DisbursementLine.Insert(true);
                                        end else begin

                                            GuarantorSecurity.Reset;
                                            GuarantorSecurity.SetRange("Loan No.", PostdLoan."No.");
                                            GuarantorSecurity.SetRange(Substituted, false);
                                            if GuarantorSecurity.Find('-') then begin

                                                DisbursementLine.LockTable;
                                                PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                                DisbursementLine."Account No." := AccountCredit."No.";
                                                DisbursementLine."Loan No." := PostdLoan."No.";
                                                DisbursementLine.Date := "Posting Date";
                                                DisbursementLine."Account Name" := Name;
                                                if PostdLoan."Outstanding Interest" <> 0 then
                                                    DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                                    DisbursementLine."Interest Balance" := 0;
                                                DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                                DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                DisbursementLine."Accrued Interest" := RunBal[8];
                                                if RunBal[5] >= (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                                    DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                                    DisbursementLine.Amount := RunBal[5];
                                                DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                                DisbursementLine.Insert(true);
                                            end;
                                        end;
                                end;
                            end;
                        until PostdLoan.Next() = 0;
                    end;
                end
            end;

        end else begin

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");

                "Outstanding Interest" := 0;
                "Outstanding Bill" := 0;
                "Outstanding Principal" := 0;
                "Outstanding Balance" := 0;

                RunBal[5] := 0;
                RunBal[6] := 0;
                RunBal[8] := 0;

                CustLoan.Reset();
                CustLoan.SetRange("No.", "Loan No.");
                if CustLoan.FindFirst() then begin
                    CustLoan.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");

                    EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;

                    case "Acrued Interest Options" of
                        "Acrued Interest Options"::"Charge Accrued Interest":
                            begin

                                RunBal[6] := LoanAmtAcruedInt("Account No.");
                                if RunBal[6] < 0 then
                                    RunBal[6] := 0;

                                RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(CustLoan, Today, CustLoan."No.", 1, IntDays, StartDate);
                                "Accrued Interest" := RunBal[8];
                                "Outstanding Principal" := CustLoan."Outstanding Principal";
                                "Outstanding Bill" := CustLoan."Outstanding Bill";
                                "Outstanding Interest" := CustLoan."Outstanding Interest" + "Accrued Interest";
                                "Outstanding Balance" := CustLoan."Outstanding Balance" + "Accrued Interest";
                            end;
                        "Acrued Interest Options"::"Ignore Acrued Interest":
                            begin

                                RunBal[6] := NoofLoanAmt("Account No.");
                                if RunBal[6] < 0 then
                                    RunBal[6] := 0;

                                RunBal[8] := 0;
                                "Accrued Interest" := 0;
                                "Outstanding Interest" := CustLoan."Outstanding Interest";
                                "Outstanding Bill" := CustLoan."Outstanding Bill";
                                "Outstanding Principal" := CustLoan."Outstanding Principal";
                                "Outstanding Balance" := CustLoan."Outstanding Balance";
                            end
                    end;

                    Guarant.Reset;
                    Guarant.SetRange("Loan No.", CustLoan."No.");
                    Guarant.SetRange(Substituted, false);
                    if Guarant.Find('-') then begin
                        NoOfSelfGuarant := Guarant.Count;
                    end;

                    if "Application Source" = "Application Source"::Manual then begin
                        if (NoOfSelfGuarant = 1) and (CustLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                            RunBal[5] := AccountCredit."Balance (LCY)"

                        end else begin
                            if RunBal[6] = 0 then
                                RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                        end;
                    end else begin
                        RunBal[5] := AccountCredit."Balance (LCY)"
                    end;

                    RunBal[1] := AccountCredit."Balance (LCY)";
                    if RunBal[5] >= RunBal[1] then
                        RunBal[5] := RunBal[1] else
                        RunBal[5] := RunBal[5];

                    "Shares Deductable" := RunBal[5];
                    "No of Active Loans" := NoofLoanCount("Account No.");
                    "Total Loans Bal." := RunBal[5];
                    NoOfGuarantTxt := 0;
                    NoOfGuarantTxt := CountGuarantor(CustLoan."No.");

                    NoOfGuarant := 0;
                    NoOfGuarant := CountGuarantor(CustLoan."No.");
                    RunBal[2] := 0;
                    RunBal[2] := fnTotalGuarantorAmt(CustLoan."No.");
                    if "Application Type" = "Application Type"::"Recovery from Shares" then begin

                        GuarantorSecurity.Reset;
                        GuarantorSecurity.SetRange("Loan No.", CustLoan."No.");
                        GuarantorSecurity.SetRange(Substituted, false);
                        if GuarantorSecurity.Find('-') then begin

                            DisbursementLine.LockTable;
                            PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                            DisbursementLine."Account No." := AccountCredit."No.";
                            DisbursementLine."Loan No." := CustLoan."No.";
                            DisbursementLine.Date := "Posting Date";
                            DisbursementLine."Account Name" := Name;
                            if CustLoan."Outstanding Interest" <> 0 then
                                DisbursementLine."Interest Balance" := CustLoan."Outstanding Interest" else
                                DisbursementLine."Interest Balance" := 0;
                            DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            DisbursementLine."Accrued Interest" := RunBal[8];
                            if RunBal[5] >= (CustLoan."Outstanding Balance" + RunBal[8]) then
                                DisbursementLine.Amount := (CustLoan."Outstanding Balance" + RunBal[8]) else
                                DisbursementLine.Amount := RunBal[5];
                            DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                            DisbursementLine.Insert(true);
                        end;
                    end;

                    if "Application Type" = "Application Type"::"Recover from guarantors" then begin
                        RunBal[3] := (CustLoan."Outstanding Balance" + "Accrued Interest");

                        GuarantorSecurity.Reset;
                        GuarantorSecurity.SetRange(Substituted, false);
                        GuarantorSecurity.SetRange("Loan No.", "Loan No.");
                        if GuarantorSecurity.Find('-') then begin
                            repeat

                                if GuarantorSecurity."Amount Guaranteed" = 0 then begin
                                    AccountCredit.Reset();
                                    AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                    if AccountCredit.FindFirst() then begin
                                        AccountCredit.CalcFields("Balance (LCY)");
                                        GuarantorSecurity."Amount Guaranteed" := AccountCredit."Balance (LCY)";
                                        GuarantorSecurity.Modify(true)
                                    end;
                                end;
                            until GuarantorSecurity.Next() = 0;
                        end;

                        GuarantorSecurity.Reset;
                        GuarantorSecurity.SetCurrentKey("Amount Guaranteed");
                        GuarantorSecurity.Ascending(true);
                        GuarantorSecurity.SetRange("Loan No.", CustLoan."No.");
                        GuarantorSecurity.SetRange(Substituted, false);
                        if GuarantorSecurity.Find('-') then begin
                            repeat
                                AccountCredit.Reset();
                                AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                if AccountCredit.FindFirst() then begin
                                    AccountCredit.CalcFields("Balance (LCY)");
                                    if AccountCredit."Balance (LCY)" > 0 then begin

                                        if RunBal[3] > 0 then begin

                                            if NoOfGuarant = CountLoop then
                                                RunBal[4] := RunBal[3] else
                                                RunBal[4] := (RunBal[3] / (NoOfGuarant - CountLoop));

                                            if CredAcc.Get(GuarantorSecurity."Account No.") then begin
                                                CredAcc.CalcFields("Balance (LCY)");

                                                DisbursementLine.LockTable;
                                                PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                                DisbursementLine."Account No." := GuarantorSecurity."Account No.";
                                                DisbursementLine.Date := "Posting Date";
                                                DisbursementLine."Loan No." := CustLoan."No.";
                                                DisbursementLine."No. of Guarantors" := NoOfGuarant;
                                                DisbursementLine."Interest Balance" := ("Outstanding Interest" / NoOfGuarant);
                                                DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                                DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                DisbursementLine."Account Name" := GuarantorSecurity.Name;
                                                DisbursementLine."Shares Deposit" := CredAcc."Balance (LCY)";
                                                DisbursementLine."Accrued Interest" := Round((RunBal[8] / NoOfGuarant));

                                                if CredAcc."Balance (LCY)" <= RunBal[4] then
                                                    DisbursementLine.Amount := CredAcc."Balance (LCY)" else
                                                    DisbursementLine.Amount := RunBal[4];
                                                DisbursementLine.Insert(true);
                                                CountLoop := CountLoop + 1;
                                                RunBal[3] := (RunBal[3] - DisbursementLine.Amount);

                                            end;
                                        end;
                                    end;
                                end;
                            until GuarantorSecurity.Next = 0;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure fnRecoverGuarantor()
    var
        AccountCredit: Record "Account Credit";
        AccBanking: Record "Account Banking";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        RunBal: array[12] of Decimal;
        NoOfGuarantTxt: Integer;
        NoOfGuarant: Integer;
        CountLoop: Integer;
        Guarant: Record "Guarantor & Security Posted";
        NoOfSelfGuarant: Integer;
        StartDate: Date;
        EndDate: Date;
        DisburseLine: Record "Loan Disbursement Lines";
        IntDays: Integer;
        RegMgt: Codeunit "Register Management";
        PostdLoan: Record Loans;
        TLoan: Record Loans;
        CustLoan: Record Loans;
    begin

        if "Recovery Type" = "Recovery Type"::"All Loans" then begin

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");
                if AccountCredit."Balance (LCY)" > 0 then begin

                    PostdLoan.Reset();
                    PostdLoan.SetRange("Account No.", "Account No.");
                    if PostdLoan.Find('-') then begin
                        repeat
                            PostdLoan.CalcFields("Outstanding Balance", "Outstanding Bill",
                            "Outstanding Interest", "Outstanding Principal");
                            if PostdLoan."Outstanding Balance" > 0 then begin

                                RunBal[1] := 0;
                                RunBal[2] := 0;
                                RunBal[3] := 0;
                                RunBal[5] := 0;
                                RunBal[6] := 0;
                                RunBal[8] := 0;
                                RunBal[9] := 0;
                                NoOfSelfGuarant := 0;
                                NoOfGuarantTxt := 0;

                                EndDate := Today;
                                StartDate := CalcDate('-CM', Today);
                                IntDays := (EndDate - StartDate) + 1;

                                case "Acrued Interest Options" of
                                    "Acrued Interest Options"::"Charge Accrued Interest":
                                        begin

                                            RunBal[6] := LoanAmtAcruedInt("Account No.");
                                            if RunBal[6] < 0 then
                                                RunBal[6] := 0;

                                            RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                            "Accrued Interest" := ("Accrued Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate));
                                            "Outstanding Interest" := "Outstanding Interest" + PostdLoan."Outstanding Interest" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                            "Outstanding Balance" := "Outstanding Balance" + PostdLoan."Outstanding Balance" + PeriodicMgt.fnIntEntriesonSpecificLoan(PostdLoan, Today, PostdLoan."No.", 1, IntDays, StartDate);
                                        end;
                                    "Acrued Interest Options"::"Ignore Acrued Interest":
                                        begin
                                            RunBal[6] := NoofLoanAmt("Account No.");
                                            if RunBal[6] < 0 then
                                                RunBal[6] := 0;
                                            RunBal[8] := 0;
                                            "Accrued Interest" := 0;
                                        end;
                                end;

                                Guarant.Reset;
                                Guarant.SetRange("Loan No.", PostdLoan."No.");
                                Guarant.SetRange(Substituted, false);
                                if Guarant.Find('-') then begin
                                    NoOfSelfGuarant := Guarant.Count;
                                end;

                                if (NoOfSelfGuarant = 1) and (PostdLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                                    RunBal[5] := AccountCredit."Balance (LCY)"

                                end else begin

                                    if RunBal[6] = 0 then
                                        RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                        RunBal[5] := ((PostdLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                                end;

                                RunBal[1] := AccountCredit."Balance (LCY)";
                                if RunBal[5] >= RunBal[1] then
                                    RunBal[5] := RunBal[1] else
                                    RunBal[5] := RunBal[5];

                                "Shares Deductable" := RunBal[5];
                                "No of Active Loans" := NoofLoanCount("Account No.");
                                "Total Loans Bal." := RunBal[5];
                                NoOfGuarantTxt := 0;
                                NoOfGuarantTxt := CountGuarantor(PostdLoan."No.");

                                if RunBal[5] > 0 then begin

                                    if ProdType.Get(PostdLoan."Product Type") then
                                        if "Recovery On Collateral" then begin

                                            DisbursementLine.LockTable;
                                            PeriodicMgt.InitializeRecoveryHeaderEntry(DisbursementLine, "No.", AccountCredit."Balance (LCY)",
                                            "Account No.", PostdLoan."No.");
                                            DisbursementLine."Account No." := AccountCredit."No.";
                                            DisbursementLine.Date := "Posting Date";
                                            DisbursementLine."Loan No." := PostdLoan."No.";
                                            DisbursementLine."Account Name" := Name;
                                            if PostdLoan."Outstanding Interest" <> 0 then
                                                DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                                DisbursementLine."Interest Balance" := 0;
                                            DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                            DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                            DisbursementLine."Accrued Interest" := RunBal[8];
                                            if RunBal[5] > (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                                DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                                DisbursementLine.Amount := RunBal[5];
                                            DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                            DisbursementLine.Insert(true);
                                        end else begin

                                            GuarantorSecurity.Reset;
                                            GuarantorSecurity.SetRange("Loan No.", PostdLoan."No.");
                                            GuarantorSecurity.SetRange(Substituted, false);
                                            if GuarantorSecurity.Find('-') then begin

                                                DisbursementLine.LockTable;
                                                PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                                DisbursementLine."Account No." := AccountCredit."No.";
                                                DisbursementLine."Loan No." := PostdLoan."No.";
                                                DisbursementLine.Date := "Posting Date";
                                                DisbursementLine."Account Name" := Name;
                                                if PostdLoan."Outstanding Interest" <> 0 then
                                                    DisbursementLine."Interest Balance" := PostdLoan."Outstanding Interest" else
                                                    DisbursementLine."Interest Balance" := 0;
                                                DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                                DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                DisbursementLine."Accrued Interest" := RunBal[8];
                                                if RunBal[5] >= (PostdLoan."Outstanding Balance" + RunBal[8]) then
                                                    DisbursementLine.Amount := (PostdLoan."Outstanding Balance" + RunBal[8]) else
                                                    DisbursementLine.Amount := RunBal[5];
                                                DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                                                DisbursementLine.Insert(true);
                                            end;
                                        end;
                                end;
                            end;
                        until PostdLoan.Next() = 0;
                    end;
                end
            end;

        end else begin

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");

                "Outstanding Interest" := 0;
                "Outstanding Bill" := 0;
                "Outstanding Principal" := 0;
                "Outstanding Balance" := 0;

                RunBal[5] := 0;
                RunBal[6] := 0;
                RunBal[8] := 0;
                RunBal[9] := 0;

                CustLoan.Reset();
                CustLoan.SetRange("No.", "Loan No.");
                if CustLoan.FindFirst() then begin
                    CustLoan.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");

                    EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;

                    case "Acrued Interest Options" of
                        "Acrued Interest Options"::"Charge Accrued Interest":
                            begin

                                RunBal[6] := LoanAmtAcruedInt("Account No.");
                                if RunBal[6] < 0 then
                                    RunBal[6] := 0;

                                RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(CustLoan, Today, CustLoan."No.", 1, IntDays, StartDate);
                                "Accrued Interest" := RunBal[8];
                                "Outstanding Principal" := CustLoan."Outstanding Principal";
                                "Outstanding Bill" := CustLoan."Outstanding Bill";
                                "Outstanding Interest" := CustLoan."Outstanding Interest" + "Accrued Interest";
                                "Outstanding Balance" := CustLoan."Outstanding Balance" + "Accrued Interest";
                            end;
                        "Acrued Interest Options"::"Ignore Acrued Interest":
                            begin

                                RunBal[6] := NoofLoanAmt("Account No.");
                                if RunBal[6] < 0 then
                                    RunBal[6] := 0;

                                RunBal[8] := 0;
                                "Accrued Interest" := 0;
                                "Outstanding Interest" := CustLoan."Outstanding Interest";
                                "Outstanding Bill" := CustLoan."Outstanding Bill";
                                "Outstanding Principal" := CustLoan."Outstanding Principal";
                                "Outstanding Balance" := CustLoan."Outstanding Balance";
                            end
                    end;

                    Guarant.Reset;
                    Guarant.SetRange("Loan No.", CustLoan."No.");
                    Guarant.SetRange(Substituted, false);
                    if Guarant.Find('-') then begin
                        NoOfSelfGuarant := Guarant.Count;
                    end;

                    if "Application Source" = "Application Source"::Manual then begin
                        if (NoOfSelfGuarant = 1) and (CustLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                            RunBal[5] := AccountCredit."Balance (LCY)"

                        end else begin
                            if RunBal[6] = 0 then
                                RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                        end;
                    end else begin
                        RunBal[5] := AccountCredit."Balance (LCY)"
                    end;

                    RunBal[1] := AccountCredit."Balance (LCY)";
                    if RunBal[5] >= RunBal[1] then
                        RunBal[5] := RunBal[1] else
                        RunBal[5] := RunBal[5];

                    "Shares Deductable" := RunBal[5];
                    "No of Active Loans" := NoofLoanCount("Account No.");
                    "Total Loans Bal." := RunBal[5];
                    NoOfGuarantTxt := 0;
                    NoOfGuarantTxt := CountGuarantor(CustLoan."No.");

                    NoOfGuarant := 0;
                    NoOfGuarant := CountGuarantor(CustLoan."No.");
                    RunBal[2] := 0;
                    RunBal[2] := fnTotalGuarantorAmt(CustLoan."No.");

                    if "Application Type" = "Application Type"::"Recover from guarantors" then begin
                        RunBal[3] := (CustLoan."Outstanding Balance" + "Accrued Interest");

                        GuarantorSecurity.Reset;
                        GuarantorSecurity.SetRange(Substituted, false);
                        GuarantorSecurity.SetRange("Loan No.", "Loan No.");
                        if GuarantorSecurity.Find('-') then begin
                            repeat

                                if GuarantorSecurity."Amount Guaranteed" = 0 then begin
                                    AccountCredit.Reset();
                                    AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                    if AccountCredit.FindFirst() then begin
                                        AccountCredit.CalcFields("Balance (LCY)");
                                        GuarantorSecurity."Amount Guaranteed" := AccountCredit."Balance (LCY)";
                                        GuarantorSecurity.Modify(true)
                                    end;
                                end;
                            until GuarantorSecurity.Next() = 0;
                        end;

                        GuarantorSecurity.Reset;
                        GuarantorSecurity.SetCurrentKey("Amount Guaranteed");
                        GuarantorSecurity.Ascending(true);
                        GuarantorSecurity.SetRange("Loan No.", CustLoan."No.");
                        GuarantorSecurity.SetRange(Substituted, false);
                        if GuarantorSecurity.Find('-') then begin
                            repeat
                                AccountCredit.Reset();
                                AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                if AccountCredit.FindFirst() then begin
                                    AccountCredit.CalcFields("Balance (LCY)");
                                    if AccountCredit."Balance (LCY)" > 0 then begin

                                        if RunBal[3] > 0 then begin

                                            if NoOfGuarant = CountLoop then
                                                RunBal[4] := RunBal[3] else
                                                RunBal[4] := (RunBal[3] / (NoOfGuarant - CountLoop));

                                            if CredAcc.Get(GuarantorSecurity."Account No.") then begin
                                                CredAcc.CalcFields("Balance (LCY)");

                                                DisbursementLine.LockTable;
                                                PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                                DisbursementLine."Account No." := GuarantorSecurity."Account No.";
                                                DisbursementLine.Date := "Posting Date";
                                                DisbursementLine."Loan No." := CustLoan."No.";
                                                DisbursementLine."No. of Guarantors" := NoOfGuarant;
                                                DisbursementLine."Interest Balance" := ("Outstanding Interest" / NoOfGuarant);
                                                DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                                DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                DisbursementLine."Account Name" := GuarantorSecurity.Name;
                                                DisbursementLine."Shares Deposit" := CredAcc."Balance (LCY)";
                                                DisbursementLine."Accrued Interest" := Round((RunBal[8] / NoOfGuarant));

                                                if CredAcc."Balance (LCY)" <= RunBal[4] then
                                                    DisbursementLine.Amount := CredAcc."Balance (LCY)" else
                                                    DisbursementLine.Amount := RunBal[4];
                                                DisbursementLine.Insert(true);
                                                CountLoop := CountLoop + 1;
                                                RunBal[3] := (RunBal[3] - DisbursementLine.Amount);

                                            end;
                                        end;
                                    end;
                                end;
                            until GuarantorSecurity.Next = 0;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure fnCreateGuarantorLoan()
    var
        AccountCredit: Record "Account Credit";
        AccBanking: Record "Account Banking";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        RunBal: array[12] of Decimal;
        NoOfGuarantTxt: Integer;
        NoOfGuarant: Integer;
        CountLoop: Integer;
        Guarant: Record "Guarantor & Security Posted";
        NoOfSelfGuarant: Integer;
        StartDate: Date;
        EndDate: Date;
        DisburseLine: Record "Loan Disbursement Lines";
        IntDays: Integer;
        RegMgt: Codeunit "Register Management";
        PostdLoan: Record Loans;
        TLoan: Record Loans;
        CustLoan: Record Loans;
    begin

        if "Recovery Type" = "Recovery Type"::"All Loans" then begin

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");

                "Outstanding Interest" := 0;
                "Outstanding Bill" := 0;
                "Outstanding Principal" := 0;
                "Outstanding Balance" := 0;

                RunBal[5] := 0;
                RunBal[6] := 0;
                RunBal[8] := 0;
                RunBal[9] := 0;

                CustLoan.Reset();
                CustLoan.SetRange("Account No.", "Account No.");
                if CustLoan.FindFirst() then begin
                    repeat
                        RunBal[5] := 0;
                        RunBal[6] := 0;
                        RunBal[8] := 0;
                        RunBal[9] := 0;

                        NoOfSelfGuarant := 0;
                        IntDays := 0;

                        CustLoan.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");
                        if CustLoan."Outstanding Balance" > 0 then begin

                            EndDate := Today;
                            StartDate := CalcDate('-CM', Today);
                            IntDays := (EndDate - StartDate) + 1;

                            case "Acrued Interest Options" of
                                "Acrued Interest Options"::"Charge Accrued Interest":
                                    begin

                                        RunBal[6] := LoanAmtAcruedInt("Account No.");
                                        if RunBal[6] < 0 then
                                            RunBal[6] := 0;

                                        RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(CustLoan, Today, CustLoan."No.", 1, IntDays, StartDate);
                                        "Accrued Interest" := RunBal[8];
                                        "Outstanding Principal" := CustLoan."Outstanding Principal";
                                        "Outstanding Bill" := CustLoan."Outstanding Bill";
                                        "Outstanding Interest" := CustLoan."Outstanding Interest" + "Accrued Interest";
                                        "Outstanding Balance" := CustLoan."Outstanding Balance" + "Accrued Interest";
                                    end;
                                "Acrued Interest Options"::"Ignore Acrued Interest":
                                    begin

                                        RunBal[6] := NoofLoanAmt("Account No.");
                                        if RunBal[6] < 0 then
                                            RunBal[6] := 0;

                                        RunBal[8] := 0;
                                        "Accrued Interest" := 0;
                                        "Outstanding Interest" := CustLoan."Outstanding Interest";
                                        "Outstanding Bill" := CustLoan."Outstanding Bill";
                                        "Outstanding Principal" := CustLoan."Outstanding Principal";
                                        "Outstanding Balance" := CustLoan."Outstanding Balance";
                                    end
                            end;

                            Guarant.Reset;
                            Guarant.SetRange("Loan No.", CustLoan."No.");
                            Guarant.SetRange(Substituted, false);
                            if Guarant.Find('-') then begin
                                NoOfSelfGuarant := Guarant.Count;
                            end;

                            if "Application Source" = "Application Source"::Manual then begin
                                if (NoOfSelfGuarant = 1) and (CustLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                                    RunBal[5] := AccountCredit."Balance (LCY)"

                                end else begin
                                    if RunBal[6] = 0 then
                                        RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                        RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                                end;
                            end else begin
                                RunBal[5] := AccountCredit."Balance (LCY)"
                            end;

                            RunBal[1] := AccountCredit."Balance (LCY)";
                            if RunBal[5] >= RunBal[1] then
                                RunBal[5] := RunBal[1] else
                                RunBal[5] := RunBal[5];

                            "Shares Deductable" := RunBal[5];
                            "No of Active Loans" := NoofLoanCount("Account No.");
                            "Total Loans Bal." := RunBal[5];
                            NoOfGuarantTxt := 0;
                            NoOfGuarantTxt := CountGuarantor(CustLoan."No.");

                            NoOfGuarant := 0;
                            NoOfGuarant := CountGuarantor(CustLoan."No.");
                            RunBal[2] := 0;
                            RunBal[2] := fnTotalGuarantorAmt(CustLoan."No.");
                            RunBal[9] := fnTotalLoanGuaranteedAmt(CustLoan."No.");
                            RunBal[3] := 0;

                            if "Application Type" = "Application Type"::"Recover from guarantors" then begin
                                RunBal[3] := (CustLoan."Outstanding Balance" + RunBal[8]);

                                GuarantorSecurity.Reset;
                                GuarantorSecurity.SetRange(Substituted, false);
                                GuarantorSecurity.SetRange("Loan No.", "Loan No.");
                                if GuarantorSecurity.Find('-') then begin
                                    repeat

                                        if GuarantorSecurity."Amount Guaranteed" = 0 then begin
                                            AccountCredit.Reset();
                                            AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                            if AccountCredit.FindFirst() then begin
                                                AccountCredit.CalcFields("Balance (LCY)");
                                                GuarantorSecurity."Amount Guaranteed" := AccountCredit."Balance (LCY)";
                                                GuarantorSecurity.Modify(true)
                                            end;
                                        end;
                                    until GuarantorSecurity.Next() = 0;
                                end;

                                GuarantorSecurity.Reset;
                                GuarantorSecurity.SetRange("Loan No.", CustLoan."No.");
                                GuarantorSecurity.SetRange(Substituted, false);
                                if GuarantorSecurity.Find('-') then begin
                                    repeat

                                        AccountCredit.Reset();
                                        AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                        if AccountCredit.FindFirst() then begin
                                            AccountCredit.CalcFields("Balance (LCY)");
                                            if AccountCredit."Balance (LCY)" > 0 then begin
                                                RunBal[4] := 0;

                                                if RunBal[3] > 0 then begin
                                                    RunBal[4] := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * GuarantorSecurity."Outstanding Balance");

                                                    if CredAcc.Get(GuarantorSecurity."Account No.") then begin
                                                        CredAcc.CalcFields("Balance (LCY)");

                                                        DisbursementLine.LockTable;
                                                        PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                                        DisbursementLine."Account No." := GuarantorSecurity."Account No.";
                                                        DisbursementLine."Loan No." := CustLoan."No.";
                                                        DisbursementLine."Member No." := "Account No.";
                                                        DisbursementLine.Date := "Posting Date";
                                                        DisbursementLine."No. of Guarantors" := NoOfGuarant;
                                                        
                                                        DisbursementLine."Interest Balance" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Interest");
                                                        DisbursementLine."Principal Balance" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Principal");
                                                        DisbursementLine."Outstanding Bills" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Bill");
                                                        DisbursementLine."Outstanding Insurance" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Insurance");
                                                        DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                                        DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                        DisbursementLine."Account Name" := GuarantorSecurity.Name;
                                                        DisbursementLine."Shares Deposit" := CredAcc."Balance (LCY)";
                                                        DisbursementLine."Accrued Interest" := Round((RunBal[8] / NoOfGuarant));
                                                        DisbursementLine.Amount := RunBal[4];
                                                        DisbursementLine."Application No." := PeriodicMgt.InitiPostEntry("No.", CustLoan."No.",CredAcc."Member No.",RunBal[4],'Loan Recovery-'+GuarantorSecurity.Name);
                                                        if RunBal[4] > 0 then
                                                          DisbursementLine.Insert(true);
                                                          ///  PeriodicMgt.InitializeLoanRecoveryEntry(AccountCredit."Member No.", RunBal[4], "No.", CustLoan."No.",DisbursementLine."Application No.");
                                                        
                                                    end;
                                                end;
                                            end;
                                        end;
                                    until GuarantorSecurity.Next = 0;
                                end;
                            end;
                        end;
                    until CustLoan.Next() = 0;
                end;
            end;

        end else begin

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", "Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");

                "Outstanding Interest" := 0;
                "Outstanding Bill" := 0;
                "Outstanding Principal" := 0;
                "Outstanding Balance" := 0;

                RunBal[5] := 0;
                RunBal[6] := 0;
                RunBal[8] := 0;
                RunBal[9] := 0;

                CustLoan.Reset();
                CustLoan.SetRange("No.", "Loan No.");
                if CustLoan.FindFirst() then begin
                    CustLoan.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");

                    EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;

                    case "Acrued Interest Options" of
                        "Acrued Interest Options"::"Charge Accrued Interest":
                            begin

                                RunBal[6] := LoanAmtAcruedInt("Account No.");
                                if RunBal[6] < 0 then
                                    RunBal[6] := 0;

                                RunBal[8] := PeriodicMgt.fnIntEntriesonSpecificLoan(CustLoan, Today, CustLoan."No.", 1, IntDays, StartDate);
                                "Accrued Interest" := RunBal[8];
                                "Outstanding Principal" := CustLoan."Outstanding Principal";
                                "Outstanding Bill" := CustLoan."Outstanding Bill";
                                "Outstanding Interest" := CustLoan."Outstanding Interest" + "Accrued Interest";
                                "Outstanding Balance" := CustLoan."Outstanding Balance" + "Accrued Interest";
                            end;

                        "Acrued Interest Options"::"Ignore Acrued Interest":
                            begin

                                RunBal[6] := NoofLoanAmt("Account No.");
                                if RunBal[6] < 0 then
                                    RunBal[6] := 0;

                                RunBal[8] := 0;
                                "Accrued Interest" := 0;
                                "Outstanding Interest" := CustLoan."Outstanding Interest";
                                "Outstanding Bill" := CustLoan."Outstanding Bill";
                                "Outstanding Principal" := CustLoan."Outstanding Principal";
                                "Outstanding Balance" := CustLoan."Outstanding Balance";
                            end
                    end;

                    Guarant.Reset;
                    Guarant.SetRange("Loan No.", CustLoan."No.");
                    Guarant.SetRange(Substituted, false);
                    if Guarant.Find('-') then begin
                        NoOfSelfGuarant := Guarant.Count;
                    end;

                    if "Application Source" = "Application Source"::Manual then begin
                        if (NoOfSelfGuarant = 1) and (CustLoan."Account No." = Guarant."Member No. (Loanee)") then begin
                            RunBal[5] := AccountCredit."Balance (LCY)"

                        end else begin
                            if RunBal[6] = 0 then
                                RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8])) * AccountCredit."Balance (LCY)" else
                                RunBal[5] := ((CustLoan."Outstanding Balance" + RunBal[8]) / RunBal[6]) * AccountCredit."Balance (LCY)";
                        end;
                    end else begin
                        RunBal[5] := AccountCredit."Balance (LCY)"
                    end;

                    RunBal[1] := AccountCredit."Balance (LCY)";

                    if RunBal[5] >= RunBal[1] then
                        RunBal[5] := RunBal[1] else
                        RunBal[5] := RunBal[5];

                    "Shares Deductable" := RunBal[5];
                    "No of Active Loans" := NoofLoanCount("Account No.");
                    "Total Loans Bal." := RunBal[5];
                    NoOfGuarantTxt := 0;
                    NoOfGuarantTxt := CountGuarantor(CustLoan."No.");

                    NoOfGuarant := 0;
                    NoOfGuarant := CountGuarantor(CustLoan."No.");
                    RunBal[2] := 0;
                    RunBal[2] := fnTotalGuarantorAmt(CustLoan."No.");
                    RunBal[9] := fnTotalLoanGuaranteedAmt(CustLoan."No.");

                    if "Application Type" = "Application Type"::"Recover from guarantors" then begin
                        RunBal[3] := (CustLoan."Outstanding Balance" + "Accrued Interest");

                        GuarantorSecurity.Reset;
                        GuarantorSecurity.SetRange(Substituted, false);
                        GuarantorSecurity.SetRange("Loan No.", "Loan No.");
                        if GuarantorSecurity.Find('-') then begin
                            repeat

                                if GuarantorSecurity."Amount Guaranteed" = 0 then begin
                                    AccountCredit.Reset();
                                    AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                    if AccountCredit.FindFirst() then begin
                                        AccountCredit.CalcFields("Balance (LCY)");
                                        GuarantorSecurity."Amount Guaranteed" := AccountCredit."Balance (LCY)";
                                        GuarantorSecurity.Modify(true)
                                    end;
                                end;
                            until GuarantorSecurity.Next() = 0;
                        end;

                        GuarantorSecurity.Reset;
                        GuarantorSecurity.SetCurrentKey("Amount Guaranteed");
                        GuarantorSecurity.Ascending(true);
                        GuarantorSecurity.SetRange("Loan No.", CustLoan."No.");
                        GuarantorSecurity.SetRange(Substituted, false);
                        if GuarantorSecurity.Find('-') then begin
                            repeat
                                GuarantorSecurity.CalcFields("Outstanding Balance");
                                GuarantorSecurity.TestField("Amount Guaranteed");
                                if GuarantorSecurity."Outstanding Balance" > 0 then begin

                                    AccountCredit.Reset();
                                    AccountCredit.SetRange("No.", GuarantorSecurity."Account No.");
                                    if AccountCredit.FindFirst() then begin
                                        AccountCredit.CalcFields("Balance (LCY)");
                                        if AccountCredit."Balance (LCY)" > 0 then begin
                                            RunBal[4] := 0;

                                            if RunBal[3] > 0 then begin
                                                RunBal[4] := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * GuarantorSecurity."Outstanding Balance");

                                                if CredAcc.Get(GuarantorSecurity."Account No.") then begin
                                                    CredAcc.CalcFields("Balance (LCY)");

                                                    DisbursementLine.LockTable;
                                                    PeriodicMgt.InitializeRecoveryEntry(GuarantorSecurity, DisbursementLine, "No.");
                                                    DisbursementLine."Account No." := GuarantorSecurity."Account No.";
                                                    DisbursementLine.Date := "Posting Date";
                                                    DisbursementLine."Loan No." := CustLoan."No.";
                                                    DisbursementLine."Member No." := "Account No.";
                                                    DisbursementLine."No. of Guarantors" := NoOfGuarant;
                                                    //DisbursementLine."Application No." := PeriodicMgt.InitiPostEntry("No.", CustLoan."No.");
                                                    DisbursementLine."Interest Balance" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Interest");
                                                    DisbursementLine."Principal Balance" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Principal");
                                                    DisbursementLine."Outstanding Bills" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Bill");
                                                    DisbursementLine."Outstanding Insurance" := ((GuarantorSecurity."Amount Guaranteed" / RunBal[9]) * CustLoan."Outstanding Insurance");
                                                    DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                                    DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                    DisbursementLine."Account Name" := GuarantorSecurity.Name;
                                                    DisbursementLine."Shares Deposit" := CredAcc."Balance (LCY)";
                                                    DisbursementLine."Accrued Interest" := Round((RunBal[8] / NoOfGuarant));
                                                    DisbursementLine.Amount := RunBal[4];
                                                    DisbursementLine."Application No." := PeriodicMgt.InitiPostEntry("No.", CustLoan."No.",CredAcc."Member No.",RunBal[4],'Loan Recovery-'+GuarantorSecurity.Name);
                                                    if RunBal[4] > 0 then
                                                        DisbursementLine.Insert(true);
                                                end;
                                            end;
                                        end;
                                    end;
                                end
                            until GuarantorSecurity.Next = 0;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure fnRecoveryFromBankingAc()
    var
        AccountCredit: Record "Account Credit";
        AccBanking: Record "Account Banking";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        RunBal: array[12] of Decimal;
        NoOfGuarantTxt: Integer;
        NoOfGuarant: Integer;
        CountLoop: Integer;
        Guarant: Record "Guarantor & Security Posted";
        NoOfSelfGuarant: Integer;
        StartDate: Date;
        EndDate: Date;
        DisburseLine: Record "Loan Disbursement Lines";
        IntDays: Integer;
        RegMgt: Codeunit "Register Management";
        PostdLoan: Record Loans;
        TLoan: Record Loans;
        CustLoan: Record Loans;
    begin
        fnClearLines();

        AccBanking.Reset();
        AccBanking.SetRange("No.", "Account to Debit");
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
        AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
        if AccBanking.FindFirst() then begin
            AccBanking.CalcFields("Balance (LCY)");
            if AccBanking."Balance (LCY)" > 0 then begin

                if Amount <= TellMngt.CalcAvailableBal(AccBanking."No.") then begin

                    AccountCredit.Reset();
                    AccountCredit.SetRange("Member No.", "Account No.");
                    AccountCredit.SetRange(Blocked, AccountCredit.Blocked::" ");
                    AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
                    if AccountCredit.FindFirst() then begin
                        AccountCredit.CalcFields("Balance (LCY)");

                        DisbursementLine.LockTable;
                        DisbursementLine.Init;
                        DisbursementLine."Line No." := RegMgt.InitNextLineEntryNo;
                        DisbursementLine.No := "No.";
                        DisbursementLine."Loan No." := '';
                        DisbursementLine.Date := "Posting Date";
                        DisbursementLine."Account Name" := Name;
                        DisbursementLine."Account No." := AccBanking."No.";
                        DisbursementLine."Interest Balance" := 0;
                        DisbursementLine."Default Account No." := "Account No.";
                        DisbursementLine."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                        DisbursementLine."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                        DisbursementLine."Accrued Interest" := 0;
                        DisbursementLine.Amount := Amount;
                        DisbursementLine."Loan No." := '';
                        DisbursementLine."Shares Deposit" := AccountCredit."Balance (LCY)";
                        DisbursementLine.Insert(true);
                    end;
                end
            end;
        end;
    end;

    local procedure fnClearLines()
    var
        DisburseLine: Record "Loan Disbursement Lines";
        LoanApp: Record "Loan Application";
        LoansT: Record Loans;
    begin
        DisburseLine.Reset;
        DisburseLine.SetRange(No, "No.");
        DisburseLine.DeleteAll;
        if "Guarantor Recovery Options" = "Guarantor Recovery Options"::"Create Loan" then begin
            LoanApp.Reset();
            LoanApp.SetRange("Recovery Header No.", "No.");
            LoanApp.DeleteAll();

            LoansT.Reset();
            LoansT.SetRange("Recovery No.", "No.");
            LoansT.DeleteAll();
        end;
    end;

    local procedure AttachLoanToGuarantors()
    var

    begin
        Loans.Reset();
        Loans.SetRange("Account No.", "Account No.");
        if Loans.FindSet() then begin
            Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill");
        end;

    end;


}




