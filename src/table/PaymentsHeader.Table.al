table 50008 "Payments Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Date"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Date';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50011; "Pay Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Code';
        }
        field(50012; "Pay Mode"; Enum "PaymentMode")
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Mode';
        }
        field(50013; "Cheque No"; Code[20])
        {
            TableRelation = if ("Cheque Type" = filter("Computer Check")) "Cheque Register"."Cheque No." where("Bank Account No." = field("Paying Bank Account"),
                                                                                                              Issued = const(false),
                                                                                                              Voided = const(false),
                                                                                                              Cancelled = const(false));
            DataClassification = CustomerContent;
            Caption = 'Cheque No';
        
            trigger OnValidate()
            begin

                if "Cheque No" <> '' then begin
                    FieldLength("Cheque No", 6, 6);

                    if "Cheque Type" = "Cheque Type"::"Computer Check" then begin
                        if Confirm('Are you sure you want to issue Cheque No. %1', false, "Cheque No") then begin

                            ChequeRegister.Reset();
                            ChequeRegister.SetRange(ChequeRegister."Cheque No.", "Cheque No");
                            if ChequeRegister.FindFirst() then begin
                                ChequeRegister."Entry Status" := ChequeRegister."Entry Status"::Issued;
                                ChequeRegister."Issued By" := UserId;
                                ChequeRegister."Issued Doc No." := "No.";
                                ChequeRegister."Cheque Date" := "Cheque Date";
                                ChequeRegister.Issued := true;
                                ChequeRegister.Modify();

                            end;
                        end else
                            "Cheque No" := '';
                    end;
                end;

            end;
        }
        field(50014; "Cheque Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque Date';
        }
        field(50015; "Check Printed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Payee"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Payee';
            Editable = false;
        }
        field(50017; "On behalf of"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'On behalf of';
            Editable = false;
        }
        field(50018; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(50019; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted';
        }
        field(50020; "Posted By"; Code[50])
        {
            Editable = true;
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50021; "Posted Date"; Date)
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Posted Date';
        }
        field(50022; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 1 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(50023; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50024; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Posted';
        }
        field(50025; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines".Amount where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Amount';
        }
        field(50026; "Paying Bank Account"; Code[20])
        {
            TableRelation = if ("Payment Type" = filter("Petty Cash")) "Bank Account" where("Bank Type" = const("Petty Cash"))
            else
            if ("Payment Type" = filter(Normal)) "Bank Account" where("Bank Type" = filter(Normal));
            DataClassification = CustomerContent;
            Caption = 'Paying Bank Account';
        
            trigger OnValidate()
            begin
                if Bank.Get("Paying Bank Account") then begin
                    "Bank Name" := Bank.Name;
                    Currency := Bank."Currency Code";
                end;
            end;
        }
        field(50027; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Approval Status';
        }
        field(50028; "Payment Type"; Enum "PvPaymentType")
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Type';
        }
        field(50029; "Currency"; Code[20])
        {
            TableRelation = Currency;
            DataClassification = CustomerContent;
            Caption = 'Currency';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50030; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
        }
        field(50031; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Account Type';
        }
        field(50032; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const("Bank Account"), "Payment Type" = filter("Petty Cash")) "Bank Account" where("Bank Type" = filter("Petty Cash"))

            else if ("Account Type" = const("Bank Account"), "Payment Type" = filter(Normal)) "Bank Account" where("Bank Type" = filter(Normal))
            else if ("Account Type" = const(Vendor)) Vendor;
            DataClassification = CustomerContent;
            Caption = 'Account No.';
        
            trigger OnValidate()
            begin
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        begin
                            if GLAccount.Get("Account No.") then;
                            GLAccount.TestField("Direct Posting", true);
                            "Account Name" := GLAccount.Name;
                        end;
                    "Account Type"::Vendor:
                        begin
                            if Vendor.Get("Account No.") then;
                            Vendor.TestField(Blocked, Vendor.Blocked::" ");
                            "Account Name" := Vendor.Name;
                            Payee := Vendor.Name;
                        end;
                    "Account Type"::Customer:
                        begin
                            Customer.Get("Account No.");
                            Customer.TestField(Blocked, Customer.Blocked::" ");
                            "Account Name" := Customer.Name;
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            Bank.Get("Account No.");
                            "Account Name" := Bank.Name;
                            Currency := Bank."Currency Code";
                            Validate("Paying Bank Account", "Account No.");
                        end;
                    "Account Type"::"Fixed Asset":
                        begin
                            FixedAsset.Get("Account No.");
                            "Account Name" := FixedAsset.Description;
                        end;
                end;
            end;
        }
        field(50033; "Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account Name';
        }
        field(50034; "Bank Name"; Text[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50035; "Applies- To Doc No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Applies- To Doc No.';
        
            trigger OnLookup()
            begin


            end;
        }
        field(50036; "Total Witholding Tax"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."Withholding Tax Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Withholding Tax';
        }
        field(50037; "Total Witholding VAT Tax"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."VAT Withholding Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total VAT Withholding Tax';
        }
        field(50038; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }

        field(50039; "Cashier"; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Caption = 'Cashier ID';
        }
        field(50040; "Payment Release Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Release Date';
        }
        field(50041; "No. Printed"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. Printed';
        }

        field(50042; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50043; "Cheque Type"; Enum "ChequeType")
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque Type';
        }
        field(50044; "Payment Narration"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Narration';
        }
        field(50045; "Total VAT Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."VAT Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total VAT Amount';
        }
        field(50046; "Total Witholding Tax Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."W/Tax Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Witholding Tax Amount';
        }
        field(50047; "Total Net Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."Net Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Net Amount';
        }
        field(50048; "Total Payment Amount LCY"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."NetAmount LCY" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Payment Amount LCY';
        }
        field(50049; "Total Retention Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."Retention Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Retention Amount';
        }
        field(50050; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 3 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50051; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
        }
        field(50052; "Grouping"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50053; "Currency Factor"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50054; "Bankers Cheque No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50055; "Check Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50056; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(50057; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 5 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(50058; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 6 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(50059; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 7 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(50060; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 8 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(50061; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
            Caption = 'Dimension Set ID';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
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
        fieldgroup(DropDown; "No.", "Account Name")
        {
        }
    }

    trigger OnInsert()
    begin
        CashMgt.Get();
        CashMgt.TestField("Max Open Documents");
        GeneralLedgerSetup.Get();
        if "No." = '' then begin

            case "Payment Type" of
                "Payment Type"::Normal:
                    begin
                        CashMgt.TestField("PV Nos");
                        "No. Series" := CashMgt."PV Nos";
                        if NoSeriesMgt.AreRelated(CashMgt."PV Nos", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")
                    end;

                "Payment Type"::"Petty Cash":
                    begin
                        CashMgt.TestField("Petty Cash Nos");
                        "No. Series" := CashMgt."Petty Cash Nos";
                        if NoSeriesMgt.AreRelated(CashMgt."Petty Cash Nos", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")

                    end;
                "Payment Type"::"Benevolent Claim":
                    begin
                        CashMgt.TestField("Benevolent Claim Nos");
                        "No. Series" := CashMgt."Benevolent Claim Nos";
                        if NoSeriesMgt.AreRelated(CashMgt."Benevolent Claim Nos", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")

                    end;
            end;
        end;

        Usersetup.Get(UserId);
        Usersetup.TestField("Global Dimension 1 Code");
        Usersetup.TestField("Global Dimension 2 Code");
        Usersetup.TestField("Responsibility Centre");
        "Shortcut Dimension 1 Code" := Usersetup."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Usersetup."Global Dimension 2 Code";
        "Responsibility Center" := Usersetup."Responsibility Centre";
        Date := Today;
        Cashier := UserId;
        "Created By" := UserId;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Payments Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                CashMgt.Get();

                case "Payment Type" of
                    "Payment Type"::Normal:
                        begin
                            NoSeriesMgt.TestManual(CashMgt."PV Nos");
                            "No. Series" := '';

                        end;
                    "Payment Type"::"Petty Cash":
                        begin
                            NoSeriesMgt.TestManual(CashMgt."Petty Cash Nos");
                            "No. Series" := '';

                        end;
                    "Payment Type"::"Benevolent Claim":
                        begin
                            NoSeriesMgt.TestManual(CashMgt."Benevolent Claim Nos");
                            "No. Series" := '';

                        end;
                end;




            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Payments Header"; xRecRef: Record "Payments Header"; var IsHandled: Boolean)
    begin
    end;

    var
        Bank: Record "Bank Account";
        CashMgt: Record "Cash Management Setups";
        ChequeRegister: Record "Cheque Register";
        CurrencyRec: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Customer: Record Customer;
        RecPayTypes: Record "Receipts and Payment Types";
        Employee: Record Employee;
        FixedAsset: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        GenJnlLine: Record "Gen. Journal Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ImpSurrLines: Record "Payment Lines";
        PaymentLine: Record "Payment Lines";
        PaymentRec: Record "Payments Header";
        UserSetup: Record "User Setup";
        Vendor: Record Vendor;
        PHead: Record "Payments Header";
        Temp: Record "Cash Office User Template";
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit "No. Series";
        ImpBalance: Decimal;
        Text003: Label 'By disabling Multi-Donor the dimensions on the lines shall be reset \ You wish to proceed?';
        SurrExistsError: Label 'Imprest issued document %1 has been used in another Imprest Surrender document %2';
        MultiDocError: Label 'Kindly utilize your open documents before creating a new one';
        AccountError: Label 'Please account for your previous %1 before applying for a new one';
        NoStaffNoError: Label 'Staff No. %1 can not be found in the Employees List. Kindly contact the system administrator.';
        Text001: Label 'The imprest %1 has been fully surrendered';
        Text000: Label 'Do you want to Void Check No %1';
        PayLine: Record "Payment Lines";
        Text00001: Label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text002: Label 'The petty cash %1 has been fully surrendered';
        NoUserAcc: Label 'You do not have a user account. Please contact the system administrator.';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        CompletionDateFormula: Text;


    procedure DefaultPettyCash(var BankCode: Code[20]): Code[20]
    var
        BankRec: Record "Bank Account";
        PaymentMethod: Record "Payment Method";
    begin
        BankRec.Reset();
        BankRec.SetRange("Bank Type", BankRec."Bank Type"::"Petty Cash");
        if BankRec.Find('-') then
            BankCode := BankRec."No.";

        PaymentMethod.Reset();
        PaymentMethod.SetRange("Bal. Account Type", PaymentMethod."Bal. Account Type"::"Bank Account");
        if PaymentMethod.Find('-') then
            exit(PaymentMethod.Code);
    end;

    procedure DeletePaymentLines(): Boolean
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Payment Type", "Payment Type");
        PaymentLine.SetRange(No, "No.");
        if PaymentLine.Find('-') then
            repeat
                PaymentLine."Shortcut Dimension 1 Code" := '';
                PaymentLine."Shortcut Dimension 2 Code" := '';
                PaymentLine."Dimension Set ID" := 0;
                PaymentLine.Modify();
            until PaymentLine.Next() = 0;
    end;

    procedure GetAccountNo(): Code[20]
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then;
        UserSetup.TestField("Employee No.");
        exit(UserSetup."Employee No.");
    end;

    procedure GetPettyCashBank() PettyBank: Code[50]
    var
        Banks: Record "Bank Account";
    begin
        Banks.Reset();
        Banks.SetRange("Bank Type", Banks."Bank Type"::"Petty Cash");
        if Banks.FindFirst() then begin
            PettyBank := Banks."No.";
            exit(PettyBank);
        end;
    end;

    procedure MarkAsPosted()
    begin
        Posted := true;
        "Posted By" := UserId;
        "Posted Date" := Today;
        "Time Posted" := Time;
        Modify();
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posted Date", "No.");
        NavigateForm.Run();
    end;


    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text051) then
            exit;

        PaymentLine.Reset();
        PaymentLine.SetRange("Payment Type", "Payment Type");
        PaymentLine.SetRange(PaymentLine.No, "No.");
        if PaymentLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(PaymentLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PaymentLine."Dimension Set ID" <> NewDimSetID then begin
                    PaymentLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PaymentLine."Dimension Set ID", PaymentLine."Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 2 Code");
                    PaymentLine.Modify();
                end;
            until PaymentLine.Next() = 0;

    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

        if OldDimSetID <> "Dimension Set ID" then begin
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure CheckPVRequiredItems()
    var
        CheckLedger: Record "Check Ledger Entry";
        CheckManagement: Codeunit CheckManagement;
    begin
        TESTFIELD("Approval Status", "Approval Status"::Approved);
        TESTFIELD("Paying Bank Account");
        TESTFIELD("Pay Mode");
        TestField("On behalf of");
        TESTFIELD("Payment Release Date");
        if "Pay Mode" = "Pay Mode"::Cash then
            // CheckBudgetAvail.CheckFundsAvailability(Rec);
            if not LinesExists() then Error('There are no payment lines for this document');

        Temp.GET(UserId);
        Temp.TestField("Payment Journal Template");
        Temp.TestField("Payment Journal Batch");

        CheckLedger.RESET;
        CheckLedger.SETRANGE("Document No.", "No.");
        CheckLedger.SETRANGE("Entry Status", CheckLedger."Entry Status"::Printed);
        if CheckLedger.Find('-') then begin

            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", Temp."Payment Journal Template");
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", Temp."Payment Journal Batch");
            GenJnlLine.FINDFIRST;
            if Confirm(Text000, false, CheckLedger."Check No.") then
                CheckManagement.VoidCheck(GenJnlLine)
            else
                Error(Text00001, "No.", CheckLedger."Check No.");
        end;
    end;

    procedure LinesExists(): Boolean
    var
        HasLines: Boolean;
        PayLines: Record "Payment Lines";
    begin
        HasLines := false;
        PayLines.Reset();
        PayLines.SetRange(PayLines.No, "No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
        exit(false)
    end;

    procedure AllFieldsEntered(): Boolean
    var
        AllKeyFieldsEntered: Boolean;
    begin
        AllKeyFieldsEntered := true;
        PayLine.Reset();
        PayLine.SetRange(PayLine.No, "No.");
        IF PayLine.Find('-') then begin
            repeat
                if (PayLine."Account No." = '') or (PayLine.Amount = 0) then
                    AllKeyFieldsEntered := false;
            until PayLine.Next() = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    procedure CustomerPayLinesExist(): Boolean
    var
        PayLine1: Record "Payment Lines";

    begin
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, "No.");
        PayLine.SETRANGE(PayLine."Account Type", PayLine."Account Type"::Customer);
        IF PayLine.FINDFIRST THEN
            EXIT(TRUE)
        ELSE BEGIN
            PayLine1.RESET;
            PayLine1.SETRANGE(PayLine1.No, "No.");
            PayLine1.SETFILTER(PayLine1."Net Amount", '<%1', 0);
            IF PayLine1.FINDFIRST THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE)
        END
    end;

    procedure CheckRequiredItem()
    begin
        if ("Pay Mode" = "Pay Mode"::Cheque) and ("Cheque Type" = "Cheque Type"::" ") then
            Error('Cheque type has to be specified');
        if "Pay Mode" = "Pay Mode"::Cheque then begin
            if ("Cheque No" = '') and ("Cheque Type" = "Cheque Type"::"Manual Check") and ("Bankers Cheque No." = '') then begin
                Error('Please ensure that the cheque number is inserted');
            end;
        end;
        if "Pay Mode" = "Pay Mode"::EFT then begin
            if "Cheque No" = '' then begin
                Error('Please ensure that the EFT number is inserted');
            end;
        end;

        if "Pay Mode" = "Pay Mode"::"Letter of Credit" then begin
            if "Cheque No" = '' then begin
                Error('Please ensure that the Letter of Credit ref no. is entered.');
            end;
        end;
    end;

    procedure FieldLength(VarVariant: Text; MinLength: Integer; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be less than %1 or more than %2 Characters.';
    begin
        if (StrLen(VarVariant) < MinLength) or (StrLen(VarVariant) > FldLength) then
            Error(FieldLengthError, MinLength, FldLength);
    end;
}



