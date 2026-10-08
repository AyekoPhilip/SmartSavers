table 50411 "Partial Disbursement Schedule"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = Loans where("Mode of Disbursement" = filter("Partial Disbursement"), "Approval Status" = filter(Posted));
        
            trigger OnValidate()
            var
                PLoan: Record Loans;
                PartLoan: Record "Partial Disbursement Schedule";
            begin
                if PLoan.Get("Loan No.") then begin
                    PLoan.CalcFields("Outstanding Balance", "Outstanding Bill", "Outstanding Insurance",
                    "Outstanding Interest", "Total Amount Disbursed");
                    "Account Name" := PLoan."Account Name";
                    "Account No." := PLoan."Loan Account";
                    "Application No." := PLoan."Application No.";
                    "Amount Disbursed" := PLoan."Total Amount Disbursed";
                    "Outstanding Balance" := PLoan."Outstanding Balance";
                    "Member No." := PLoan."Account No.";

                    PartLoan.Reset();
                    PartLoan.SetRange("Loan No.", "Loan No.");
                    PartLoan.SetFilter("Approval Status", '<>%1 & <>%2', PartLoan."Approval Status"::Posted,
                    PartLoan."Approval Status"::Rejected);
                    if PartLoan.Find('-') then begin
                        Error(ErrorOnExistPartialLoan, PartLoan."Entry No");
                    end;
                end;

            end;
        }
        field(50010; "Scheduled Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ("Scheduled Disbursement Date" < Today) or ("Scheduled Disbursement Date" > Today) then
                    Error(DateErr);
            end;
        }
        field(50011; "Amount"; Decimal)
        {
            MinValue = 0;
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                CredMgt: Codeunit "Credit Mgmt.";
            begin
                if LoanApp.Get("Loan No.") then begin
                    LoanApp.CalcFields("Amount to Post");
                    "Member No." := LoanApp."Account No.";
                    "Amount Approved" := LoanApp."Approved Amount";
                    UpdateApprovedAmt();
                    Commit();
                    CredMgt.fncreateRepayschedule(false, LoanApp."No.", 0);
                end;
            end;
        }
        field(50012; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50013; "Entry No"; Code[50])
        {
            Editable = false;
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50014; "Disbursement Destination"; Option)
        {
            OptionCaption = 'Front Office,Cheque,MPesa,Bank Transfer';
            OptionMembers = "Front Office","Cheque","MPesa","Bank Transfer";
            Caption = 'Disbursement Destination';
            DataClassification = CustomerContent;
        }
        field(50015; "Suggested for Disbursement"; Boolean)
        {
            Caption = 'Suggested for Disbursement';
            DataClassification = CustomerContent;
        }

        field(50016; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50017; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = const(Vendor), Type = filter(Account)) Vendor where(Blocked = const(" "), "Account Type" = filter(Others | " "))
            else
            if ("Account Type" = const("Bank Account")) "Bank Account";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if Vend.Get("Account No.") then
                    "Account Name" := Vend.Name
            end;
        }
        field(50018; "Application No."; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50019; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                appStatus: Enum ApprovalStatus;
            begin
                if LoanApp.Get("Loan No.") then begin
                    CredMngt.OnValidateLoanStatusTxt("Approval Status", LoanApp."Account No.",
                    Amount, LoanApp.Repayment, LoanApp."No.", LoanApp."Disbursement Account No.",
                    Amount, LoanApp."Loan Rejection Reason", LoanApp."Product Description")
                end;
            end;
        }
        field(50020; "Repayment"; Decimal)
        {
            Editable = false;
            Caption = 'Repayment';
            DataClassification = CustomerContent;
        }
        field(50021; "Recipient Reference"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50022; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50023; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50024; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Time Posted';
        }
        field(50025; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50026; "Member No."; Code[20])
        {
            TableRelation = Member."No." where(Status = filter(Active));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            var
                ObjCust: Record Member;
                ErrorMembAgeTxt: Label 'Member due to retire before loan repayment is complete. Do you wish to continue?';
                STermLoan: Record Loans;
                MaxLoan: Decimal;
                SalDetails: Record "Appraisal Salary Details";
                TestD: Integer;
            begin

            end;
        }
        field(50027; "Account Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50028; "Responsibility Centre"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50029; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code")
            end;
        }
        field(50030; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(50031; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50032; "Captured By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50033; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50034; "Type"; Option)
        {
            OptionMembers = "Account","Bank Code";
            DataClassification = CustomerContent;
        }
        field(50035; "Payment Destination"; Code[100])
        {
            TableRelation = "Cust. Bank Account"."Bank Account No." where(Code = field("Payment Destination Code"));
            DataClassification = CustomerContent;
            Caption = 'Destination A/c';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50036; "Payment Destination Code"; Code[100])
        {
            TableRelation = Banks.Code;
            DataClassification = CustomerContent;
            Caption = 'Pay Point';
        
            trigger OnValidate()
            var
                BanksList: Record Banks;
            begin

                TestField("External Account No.");
                BanksList.Reset();
                BanksList.Setrange(Code, Rec."Payment Destination Code");
                if BanksList.FindFirst() then begin
                    BanksList.TestField("Bank No.");

                    "Bank Name" := BanksList.Name;
                    if BanksList."Institution Type" = BanksList."Institution Type"::Bank then begin
                        Rec."Institution Type" := Rec."Institution Type"::Bank;
                        Rec."Own Reference" := Rec."Member No.";
                        Rec."Society Code" := '';

                    end else begin
                        BanksList.TestField("Society Code");
                        Rec.Validate("External Account No.", BanksList."Society Code");
                        Rec."Institution Type" := Rec."Institution Type"::"Building Society";
                        Rec."Society Code" := BanksList."Society Code";
                        Rec."Own Reference" := Rec."Member No.";
                        Rec."External Account No." := BanksList."Society Code";
                    end;
                    Rec.Validate("Branch Code", BanksList."Bank No.");
                end;
            end;
        }
        field(50037; "Mobile Phone No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50038; "Institution Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Bank","Building Society";
            Editable = false;
        }
        field(50039; "Society Code"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50040; "Branch Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50041; "External Account No."; Text[100])
        {
            Caption = 'External Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if StrLen("External Account No.") > 100 then
                    Error('Destnation account no %1 more than 14 characters.', "External Account No.");
            end;
        }

        field(50042; "Bank Code"; Code[10])
        {
            TableRelation = Banks;
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                BankCodes: Record Banks;
            begin
                BankCodes.Reset;
                BankCodes.SetRange(Code, "Bank Code");
                if BankCodes.Find('-') then
                    "Bank Name" := BankCodes.Name;
            end;
        }
        field(50043; "Branch Code"; Code[10])
        {
            TableRelation = Banks."Bank No.";
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                BankBranch: Record "Bank Branches";
            begin

                BankBranch.Reset();
                BankBranch.SetRange("Branch Code", "Branch Code");
                BankBranch.SetRange("Bank Code", "Bank Code");
                if BankBranch.FindFirst() then
                    "Branch Name" := BankBranch."Branch Name"
            end;
        }
        field(50044; "Bank Name"; Text[100])
        {
            Editable = false;
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(50045; "External Account Name"; Text[250])
        {
            Caption = 'External Account Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var

            begin
            end;
        }
        field(50046; "Own Reference"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50047; "EFT Options"; Enum "EFTPaymentOptions")
        {
            DataClassification = CustomerContent;
        }
        field(50048; "Amount Disbursed"; Decimal)
        {
            Editable = false;
            Caption = 'Amount Disbursed';
            DataClassification = CustomerContent;
        }
        field(50049; "Outstanding Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50050; "Amount Approved"; Decimal)
        {
            Editable = false;
            Caption = 'Approved Amount';
            DataClassification = CustomerContent;
        }
        field(50051; "Preview Journal"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key("Key1"; "Entry No", "Loan No.", "Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    { }

    trigger OnDelete()
    begin
        TestField("Approval Status", "Approval Status"::Open);
    end;

    trigger OnInsert()
    var
        
        ExemptionsApprvl: Record "User Setup";
    begin

        if "Entry No" = '' then begin
            MembNoSeries.Get();

            MembNoSeries.TestField("Partial Loans Nos.");
            "No. Series" := MembNoSeries."Partial Loans Nos.";
            if NoSeriesMgt.AreRelated(MembNoSeries."Partial Loans Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "Entry No" := NoSeriesMgt.GetNextNo("No. Series");

            ExemptionsApprvl.Get(UserId);
            ExemptionsApprvl.TestField("Responsibility Centre");
            ExemptionsApprvl.TestField("Global Dimension 1 Code");
            ExemptionsApprvl.TestField("Global Dimension 2 Code");
            "Responsibility Centre" := ExemptionsApprvl."Responsibility Centre";
            "Global Dimension 1 Code" := ExemptionsApprvl."Global Dimension 1 Code";
            "Global Dimension 2 Code" := ExemptionsApprvl."Global Dimension 2 Code";

        end;

        "Captured By" := UserId;
        "Application Date" := Today;
        "Scheduled Disbursement Date" := Today;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Partial Disbursement Schedule";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "Entry No" <> xRec."Entry No" then
            if not RecRefHeader.Get(Rec."Entry No") then begin
                MembNoSeries.Get();
                NoSeriesMgt.TestManual(MembNoSeries."Partial Loans Nos.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Partial Disbursement Schedule"; xRecRef: Record "Partial Disbursement Schedule"; var IsHandled: Boolean)
    begin
    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No.") then begin

        end;
    end;

    var
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        DateErr: Label 'Scheduled disbursement date cannot be earlier than today';
        PostedErr: Label 'You cannot modify a posted disbursement';
        Text001: Label 'Loan is already %1 and cannot modify';
        LoanApp: Record Loans;
        TellMngt: Codeunit "Teller-Post (Yes/No)";

        ErrorOnExistPartialLoan: Label 'There is a pending application on partial disbursement that has not been posted.- %1';
        CredMngt: Codeunit "Credit Mgmt.";
        ErrorOnExistPostEntry: Label 'Application No. %1 already posted';


    procedure getDisbursedSchedule() Amt: Decimal
    var
        PartialDisb: Record "Partial Disbursement Schedule";
    begin
        PartialDisb.SetRange(Posted, true);
        PartialDisb.SetRange("Loan No.", Rec."Loan No.");
        PartialDisb.SetRange("Application No.", Rec."Application No.");
        PartialDisb.SetRange("Approval Status", PartialDisb."Approval Status"::Posted);
        if PartialDisb.FindSet() then begin
            PartialDisb.CalcSums(Amount);
            Amt := PartialDisb.Amount
        end;
    end;

    procedure getTotalDisbursedSchedule() Amt: Decimal
    var
        PartialDisb: Record "Partial Disbursement Schedule";
    begin

        PartialDisb.SetRange("Loan No.", Rec."Loan No.");
        if PartialDisb.FindSet() then begin
            PartialDisb.CalcSums(Amount);
            Amt := PartialDisb.Amount
        end;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"Partial Disbursement Schedule", Format("Entry No"), FieldNumber, ShortcutDimCode);
        Modify;
    end;

    procedure CheckMinRequirement(ValuePost: Integer)
    Var
        ApprovalMgt: Codeunit "Approval Mgmt.";
    begin
        case ValuePost of
            1:
                ApprovalMgt.OnSendPartialDisbApprovalRequest(Rec);
            2:
                ApprovalMgt.OnCancelPartialDisbApprovalRequest(Rec, true, true);
            3:
                ApprovalMgt.OnOpenPartialDisbApprovalRequest(Rec, true, true);
            4:
                begin
                    TestField("Approval Status", "Approval Status"::Approved);
                end;
            5:
                begin
                    TestField("EFT Options");
                    TestField("External Account Name");
                    TestField("External Account No.");
                    TestField("Payment Destination Code");
                    TestField(Amount);
                    TestField("Branch Code");
                    TestField("Own Reference");
                    TestField("Recipient Reference");
                    case "EFT Options" of
                        "EFT Options"::"Mobile Money",
                        "EFT Options"::"Money Wallet":
                            begin
                                TestField("Mobile Phone No.");
                            end;
                    end;

                end;
        end;

    end;

    local procedure UpdateApprovedAmt()
    var
        ErrorOnApprovedAmtErrTxt: Label 'Approved Amount cannot be more than Requested amount';
        ErrorOnDiffAmounttxt: Label 'Approved Amount cannot be more than different of Max. loan amount less total loan balance';
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        InterestRate: Decimal;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        ShareBanding: Record "Shares Banding";
        BandingShare: Decimal;
        AccDredit: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        TempAmt: Decimal;
        FactProd: Record "Product Factory";

        CustRec: Record Member;
        TieredRates: Record "Interest Rates Banding";
        SettlementFee: Decimal;
        InsuranceFee: Decimal;
        TopUpFacility: Record "Loans Top up";
        TotalTopup: Decimal;
        Loan: Record Loans;
        TopupLoan: Record "Loans Top up";
        PostedFacility: Record Loans;
        TopUpRepayment: Decimal;
        Mcontrib: Decimal;
        TotalDeduct: Decimal;
        InstallPeriod: Integer;

        CollateralReg: Record "Collateral Register";
        GuarantPosted: Record "Loan Guarantors and Security";
        HrDate: Codeunit "Date Conversion";
        GeneralSetUp: Record "General Set-Up";
        Text006: Label 'The value exceeds the maximum installments of %1';

    begin

        TotalMRepay := 0;
        LPrincipal := 0;
        LInterest := 0;
        SettlementFee := 0;
        InsuranceFee := 0;
        TotalTopup := 0;
        InstallPeriod := 0;

        if LoanApp.Get("Loan No.") then begin

            LoanApp.TestField("Product Type");
            LoanApp.CalcFields("Total TopUp");

            GeneralSetUp.Get();
            GeneralSetUp.TestField("Max. Member Age");

            if Amount > (LoanApp."Approved Amount" - LoanApp."Outstanding Balance") then
                Error(ErrorOnApprovedAmtErrTxt);

            LoanAmount := (Amount + "Outstanding Balance");
            LBalance := (Amount + "Outstanding Balance");

            LoanApp.TestField(Installments);

            InterestRate := LoanApp."Interest Rate";
            RepayPeriod := LoanApp.Installments;

            if CustRec.Get(LoanApp."Account No.") then
                CustRec.TestField("Date of Birth");
            if CalcDate(GeneralSetUp."Max. Member Age", CustRec."Date of Birth") <= Today then
                InsuranceFee := 0 else
                InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 1000)) / 2));

            case LoanApp."Interest Calculation Method" of
                LoanApp."Interest Calculation Method"::Amortised:
                    begin
                        LoanApp.TestField("Interest Rate");
                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 -
                        Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount));
                        LInterest := Round(LBalance * InterestRate / 12 / 100);
                        LPrincipal := (TotalMRepay - LInterest);
                        Repayment := Round((LPrincipal + LInterest + InsuranceFee), 1, '=');
                    end;
                LoanApp."Interest Calculation Method"::"Straight Line":
                    begin
                        LoanApp.TestField("Interest Rate");
                        LPrincipal := Round(LoanAmount / RepayPeriod, 1, '=');
                        LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '=');
                        Repayment := Round((LPrincipal + LInterest + InsuranceFee), 1, '=');
                    end;
                LoanApp."Interest Calculation Method"::"Reducing Balance":
                    begin
                        LoanApp.TestField("Interest Rate");
                        LPrincipal := LoanAmount / RepayPeriod;
                        LInterest := (InterestRate / 12 / 100) * LBalance;
                        Repayment := Round((LPrincipal + LInterest + InsuranceFee), 1, '=');

                    end;
                LoanApp."Interest Calculation Method"::"Reducing Flat":
                    begin
                        LoanApp.TestField("Interest Rate");
                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                        LInterest := Round((LoanAmount * 0.6) * (LoanApp.Installments + 1) / (LoanApp.Installments * 100), 1, '=');
                        Repayment := Round((LPrincipal + LInterest + InsuranceFee), 1, '=');

                    end;
                LoanApp."Interest Calculation Method"::"Zero Interest":
                    begin
                        LPrincipal := Round(LoanAmount / RepayPeriod);
                        Repayment := Round((LPrincipal + InsuranceFee), 1, '=');
                    end
            end;
        end;
    end;

    procedure fnCheckMinRequirement(ActionItem: Enum PageActionItem)
    begin
        case ActionItem of
            ActionItem::"Send Approval Request":
                begin
                    TestField("Loan No.");
                    TestField("Member No.");
                    TestField("EFT Options");
                    TestField(Amount);
                    TestField("External Account No.");
                    TestField("External Account Name");
                    TestField("Payment Destination Code");
                    TestField("Own Reference");
                    TestField("Recipient Reference");
                    TestField(Remarks);
                    TestField(Posted, false);
                end;
            ActionItem::"Post Application":
                begin
                    TestField("Loan No.");
                    TestField("Member No.");
                    TestField("EFT Options");
                    TestField(Amount);
                    TestField("External Account No.");
                    TestField("External Account Name");
                    TestField("Payment Destination Code");
                    TestField("Own Reference");
                    TestField("Recipient Reference");
                    TestField(Remarks);
                    TestField("Suggested for Disbursement", true);
                    TestField(Posted, false);
                    TestField("Approval Status", "Approval Status"::Approved);

                    if TellMngt.TestNoEntriesExist("Account Name", "Entry No", 0) then
                        Error(ErrorOnExistPostEntry, "Entry No");

                end;
        end;

    end;
}




