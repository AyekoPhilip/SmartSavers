table 50009 "Payment Lines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No';
        }
        field(50010; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No';
        }
        field(50011; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(50012; "Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Type';
        }
        field(50013; "Account No."; Code[100])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset" where(Blocked = const(false))
            else
            if ("Account Type" = filter(Customer)) Customer where(Blocked = const(" "),
             "Customer Posting Group" = field(Grouping))
            else
            if ("Account Type" = filter(Credit)) "Account Credit" where(Blocked = const(" "),
            "Customer Posting Group" = field(Grouping))
            else
            if ("Account Type" = const("Bank Account")) "Bank Account" where(Blocked = const(false))
            else
            if ("Account Type" = const(Vendor)) Vendor where(
            "Vendor Posting Group" = field(Grouping)) else if
            ("Account Type" = const(Saving)) "Account Banking" where(
            "Customer Posting Group" = field(Grouping));
            DataClassification = CustomerContent;
            Caption = 'Account No';
        
            trigger OnValidate()
            var
                PH: Record "Payments Header";
                GLAcc: Record "G/L Account";
                Cust: Record Customer;
                Vend: Record Vendor;
                BankAcc: Record "Bank Account";
                AccBanking: Record "Account Banking";
                AccCredit: Record "Account Credit";
            begin

                "Account Name" := '';
                RecPayTypes.Reset();
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
                if RecPayTypes.FindFirst() then begin

                    if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner",
                        "Account Type"::"Bank Account", "Account Type"::Employee, "Account Type"::Saving, "Account Type"::Credit] then
                        case "Account Type" of

                            "Account Type"::"G/L Account":
                                begin
                                    if GLAcc.GET("Account No.") then begin
                                        "Account Name" := GLAcc.Name;
                                        Description := GLAcc.Name;
                                        "Shortcut Dimension 1 Code" := GLAcc."Global Dimension 1 Code";
                                        "Shortcut Dimension 2 Code" := GLAcc."Global Dimension 2 Code";
                                    end;
                                end;
                            "Account Type"::Customer:
                                begin
                                    Cust.GET("Account No.");
                                    "Account Name" := Cust.Name;
                                    Description := Cust.Name;
                                    "Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    "Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";

                                end;
                            "Account Type"::Vendor:
                                begin
                                    Vend.GET("Account No.");
                                    Vend.CALCFIELDS("Balance (LCY)");
                                    "Account Name" := Vend.Name;
                                    Description := Vend.Name;
                                    "Shortcut Dimension 1 Code" := Vend."Global Dimension 1 Code";
                                    "Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                                end;
                            "Account Type"::"Bank Account":
                                begin
                                    BankAcc.GET("Account No.");
                                    "Account Name" := BankAcc.Name;
                                    Description := BankAcc.Name;
                                    "Shortcut Dimension 1 Code" := BankAcc."Global Dimension 1 Code";
                                    "Shortcut Dimension 2 Code" := BankAcc."Global Dimension 2 Code";

                                end;
                            "Account Type"::Saving:
                                begin
                                    AccBanking.Get("Account No.");
                                    "Account Name" := AccBanking.Name;
                                    Description := AccBanking."Product Name";
                                    "Shortcut Dimension 1 Code" := AccBanking."Global Dimension 1 Code";
                                    "Shortcut Dimension 2 Code" := AccBanking."Global Dimension 2 Code";
                                end;
                            "Account Type"::Credit:
                                begin
                                    AccCredit.Get("Account No.");
                                    "Account Name" := AccCredit.Name;
                                    Description := AccCredit."Product Name";
                                    "Shortcut Dimension 1 Code" := AccCredit."Global Dimension 1 Code";
                                    "Shortcut Dimension 2 Code" := AccCredit."Global Dimension 2 Code";
                                end;

                        end;
                end;
                if "Account Type" = "Account Type"::Vendor then
                    "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
            end;
        }
        field(50014; "Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account Name';
        }
        field(50015; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50016; "Amount"; Decimal)
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Amount';
        
            trigger OnValidate()
            begin

                CalculateTax();
                CurrencyRec.InitRoundingPrecision();
                if Currency = '' then
                    "Amount (LCY)" := Round(Amount, CurrencyRec."Amount Rounding Precision")
                else begin
                    if CurrencyRec.Get(Currency) then
                        "Amount (LCY)" := Round(
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            Date, Currency,
                            Amount, CurrExchRate.ExchangeRate(Date, Currency)),
                            CurrencyRec."Amount Rounding Precision");
                end;
            end;
        }
        field(50017; "Posted"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Posted';
        }
        field(50018; "Posted Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Date';
        }
        field(50019; "Posted Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Time';
        }
        field(50020; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 1 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(50021; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50022; "Type"; Code[20])
        {
            TableRelation = "Receipts and Payment Types" where(Type = filter(Payment), Blocked = filter(false));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                GetPaymentLineType();
            end;
        }
        field(50023; "VAT Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            Caption = 'VAT Code';
        
            trigger OnValidate()
            begin
                "VAT Rate" := 0;
                CalculateTax();
                Validate(Amount);
            end;
        }
        field(50024; "W/Tax Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            Caption = 'W/Tax Code';
        
            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(50025; "Retention Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            Caption = 'Retention Code';
        
            trigger OnValidate()
            begin
                IF TariffCode.GET("Retention Code") THEN
                    "Retention Rate" := TariffCode.Percentage
                ELSE
                    "Retention Rate" := 0;

                CalculateTax();
            end;
        }
        field(50026; "VAT Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Amount';
        }
        field(50027; "W/Tax Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'W/Tax Amount';
        }
        field(50028; "Retention Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Amount';
        
            trigger OnValidate()
            begin
                Validate(Amount)
            end;
        }
        field(50029; "Net Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Amount';
        
            trigger OnValidate()
            begin
                IF "Currency Factor" <> 0 THEN
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                ELSE
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(50030; "W/T VAT Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            Caption = 'W/T VAT Code';
        
            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(50031; "W/T VAT Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'W/T VAT Amount';
        }
        field(50032; "Currency Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'W/T VAT Amount';
        }
        field(50033; "Grouping"; Code[20])
        {
            TableRelation = if ("Account Type" = filter(Vendor)) "Vendor Posting Group".Code else if
            ("Account Type" = filter("G/L Account")) "G/L Account" else if
            ("Account Type" = filter(Customer)) "Customer Posting Group";
            DataClassification = CustomerContent;
            Caption = 'Grouping';
        }
        field(50034; "Payment Type"; Enum "PvPaymentType")
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Type';
        }
        field(50035; "Purpose"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purpose';
        }
        field(50036; "VAT Prod. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = filter("G/L Account")) "VAT Product Posting Group".Code;
        }
        field(50037; "Committed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Committed';
        }
        field(50038; "NetAmount LCY"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'NetAmount LCY';
        }
        field(50039; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(50040; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            var
                Amt: Decimal;
            begin
                CheckPayHeaderApprovalStatus();
                if (Rec."Account Type" <> Rec."Account Type"::Customer) and (Rec."Account Type" <> Rec."Account Type"::Vendor) then
                    Error('You cannot apply to %1', "Account Type");

                "Applies-to Doc. No." := '';
                Amt := 0;
                VATAmount := 0;
                "W/TAmount" := 0;
                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            CustLedger.RESET;
                            CustLedger.SETCURRENTKEY(CustLedger."Customer No.", Open, "Document No.");
                            CustLedger.SETRANGE(CustLedger."Customer No.", "Account No.");
                            CustLedger.SETRANGE(Open, TRUE);
                            CustLedger.SETRANGE(Positive, FALSE);
                            CustLedger.CALCFIELDS(CustLedger.Amount);
                            IF PAGE.RUNMODAL(0, CustLedger) = ACTION::LookupOK THEN BEGIN

                                IF CustLedger."Applies-to ID" <> '' THEN BEGIN
                                    CustLedger1.RESET;
                                    CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.", Open, "Applies-to ID");
                                    CustLedger1.SETRANGE(CustLedger1."Customer No.", "Account No.");
                                    CustLedger1.SETRANGE(Open, TRUE);
                                    CustLedger1.SETRANGE("Applies-to ID", CustLedger."Applies-to ID");
                                    CustLedger.SETRANGE(Positive, FALSE);
                                    IF CustLedger1.FIND('-') THEN BEGIN
                                        REPEAT
                                            CustLedger1.CALCFIELDS(CustLedger1."Remaining Amount");
                                            Amt := Amt + ABS(CustLedger1."Remaining Amount");
                                        UNTIL CustLedger1.NEXT = 0;
                                    END;

                                    IF Amt <> Amt THEN
                                        IF Amount = 0 THEN
                                            Amount := Amt;
                                    VALIDATE(Amount);
                                    "Applies-to Doc. No." := CustLedger."Document No.";
                                    "Applies-to Doc. Type" := CustLedger."Document Type";
                                END ELSE BEGIN
                                    IF Amount <> ABS(CustLedger.Amount) THEN
                                        CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                                    IF Amount = 0 THEN
                                        Amount := ABS(CustLedger."Remaining Amount");
                                    VALIDATE(Amount);
                                    "Applies-to Doc. No." := CustLedger."Document No.";
                                    "Applies-to Doc. Type" := CustLedger."Document Type";
                                END;
                            END;
                            VALIDATE(Amount);
                        END;

                    "Account Type"::Vendor:
                        BEGIN
                            VendLedgEntry.RESET;
                            VendLedgEntry.SETCURRENTKEY(VendLedgEntry."Vendor No.", Open, "Document No.");
                            VendLedgEntry.SETRANGE(VendLedgEntry."Vendor No.", "Account No.");
                            VendLedgEntry.SETRANGE(Open, TRUE);
                            VendLedgEntry.SETRANGE(Positive, FALSE);
                            VendLedgEntry.CALCFIELDS("Remaining Amount");
                            IF PAGE.RUNMODAL(0, VendLedgEntry) = ACTION::LookupOK THEN BEGIN

                                IF VendLedgEntry."Applies-to ID" <> '' THEN BEGIN
                                    
                                    VendLedger1.RESET;
                                    VendLedger1.SETCURRENTKEY(VendLedger1."Vendor No.", Open, "Applies-to ID");
                                    VendLedger1.SETRANGE(VendLedger1."Vendor No.", "Account No.");
                                    VendLedgEntry.SETRANGE(Positive, FALSE);
                                    VendLedger1.SETRANGE(Open, TRUE);
                                    VendLedger1.SETRANGE(VendLedger1."Applies-to ID", VendLedgEntry."Applies-to ID");
                                    IF VendLedger1.FIND('-') THEN BEGIN
                                        REPEAT
                                            VendLedger1.CALCFIELDS(VendLedger1."Remaining Amount");
                                            NetAmount := NetAmount + ABS(VendLedger1."Remaining Amount");
                                        UNTIL VendLedger1.NEXT = 0;
                                    END;

                                    IF NetAmount <> NetAmount THEN
                                        IF Amount = 0 THEN
                                            Amount := NetAmount;

                                    VALIDATE(Amount);
                                    "Applies-to Doc. No." := VendLedgEntry."Document No.";
                                    "Applies-to Doc. Type" := VendLedgEntry."Applies-to Doc. Type";

                                    Description := VendLedgEntry.Description;
                                    VendLedgEntry.RESET;
                                    VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                    IF VendLedgEntry.FINDFIRST THEN BEGIN
                                        Transactionref := 'REF-' + VendLedgEntry."External Document No.";
                                    END;
                                END ELSE BEGIN
                                    IF Amount <> ABS(VendLedgEntry."Remaining Amount") THEN
                                        VendLedgEntry.CALCFIELDS(VendLedgEntry."Remaining Amount");
                                    IF Amount = 0 THEN
                                        Amount := ABS(VendLedgEntry."Remaining Amount");
                                    VALIDATE(Amount);
                                    "Applies-to Doc. No." := VendLedgEntry."Document No.";
                                    "Applies-to ID":=VendLedgEntry."Document No.";
                                    Description := VendLedgEntry."External Document No.";
                                    VendLedgEntry.RESET;
                                    VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                    IF VendLedgEntry.FINDFIRST THEN BEGIN
                                        Transactionref := 'REF-' + VendLedgEntry."External Document No.";
                                    END;
                                END;
                            END;
                            Amount := ABS(VendLedgEntry."Remaining Amount");
                            VALIDATE(Amount);
                        END;
                END;

            end;

            trigger OnValidate()
            begin
                CheckPayHeaderApprovalStatus();
                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
                  ("Applies-to Doc. No." <> '') then begin
                    SetAmountToApply("Applies-to Doc. No.", "Account No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
                end else
                    if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." = '') then
                        SetAmountToApply("Applies-to Doc. No.", "Account No.")
                    else
                        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') then
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
            end;
        }
        field(50041; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CheckPayHeaderApprovalStatus();
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open);
                    VendLedgEntry.SETRANGE("Vendor No.", "Account No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    VendLedgEntry.SETRANGE("Applies-to ID", xRec."Applies-to ID");
                    IF VendLedgEntry.FINDFIRST THEN
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                    VendLedgEntry.Reset();
                end;
            end;

            trigger OnLookup()
            begin
                CheckPayHeaderApprovalStatus()

            end;
        }

        field(50042; "Remaining Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Amount';
        }
        field(50043; "Actual Spent (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual Spent (LCY)';
        }
        field(50044; "Remaining Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Amount (LCY)';
        }
        field(50045; "Cash Receipt Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cash Receipt Amount';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50046; "Cash Receipt Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cash Receipt Amount (LCY)';
        }
        field(50047; "Comments"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comments';
        }
        field(50048; "VAT Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Rate';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50049; "W/Tax Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'W/Tax Rate';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50050; "Retention Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Rate';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50051; "VAT Withholding Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Withholding Rate';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50052; "Withholding Tax Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Withholding Tax Amount';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50053; "VAT Withholding Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Withholding Amount';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50054; "VAT Deductible"; Boolean)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50055; "Withholding Tax Code"; Code[20])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CalculateTax();

            end;
        }
        field(50061; "VAT Withholding Code"; Code[20])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CalculateTax();

            end;
        }
        field(50062; "Transaction Name"; Code[20])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50056; "Invoice No."; Code[50])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                VendLedgEntry.Reset();
                VendLedgEntry.RESET;
                VendLedgEntry.SETRANGE(VendLedgEntry."Document No.", "Invoice No.");
                VendLedgEntry.SETRANGE(VendLedgEntry."Vendor No.", "Account No.");
                VendLedgEntry.SETRANGE(VendLedgEntry."Document Type", VendLedgEntry."Document Type"::Invoice);
                IF VendLedgEntry.FindFirst() then begin
                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                    Amount := -VendLedgEntry."Remaining Amount";
                    "Due Date" := VendLedgEntry."Due Date";
                end;

            end;
        }
        field(50057; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50058; "Require Surrender"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50059; "Payment Reference"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Normal","Farmer Purchase";
            Caption = 'Payment Reference';
        }
        field(50060; "Budgetary Control A/c"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Budgetary Control A/c';
        }
        field(50063; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }

        field(50064; "Vendor Invoice"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Invoice';
        }
        field(50065; "Shortcut Dimension 3 Code"; Code[20])
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
        field(50066; "Shortcut Dimension 4 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Code';
        }

        field(50067; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
            DataClassification = CustomerContent;
        }

        field(50068; "Gen. Posting Type"; Enum "General Posting Type")
        {
            Caption = 'Gen. Posting Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
            end;
        }
        field(50069; "Currency"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency;
            Caption = 'Currency';
        
            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(50070; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount (LCY)';
        }
    }

    keys
    {
        key("Key1"; "No", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

    end;

    var
        Bank: Record "Bank Account";
        CSetup: Record "Cash Management Setups";
        CurrencyRec: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Customer: Record Customer;
        FixedAsset: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        PaymentLines: Record "Payment Lines";
        PaymentLines2: Record "Payment Lines";
        PaymentRec: Record "Payments Header";
        RecTypes: Record "Receipts and Payment Types";
        Ok: Boolean;
        Transactionref: Code[50];
        VATSetup: Record "VAT Posting Setup";
        VATSetup2: Record "VAT Posting Setup";
        Vendor: Record Vendor;
        DimMgt: Codeunit DimensionManagement;
        HasGotGLSetup: Boolean;
        TariffCode: Record "Tariff Codes";
        RecPayTypes: Record "Receipts and Payment Types";
        GLSetupShortcutDimCode: array[8] of Code[20];
        StaffNo: Code[50];
        NetAmount: Decimal;
        TarrifCode: Record "Tariff Codes";

        CalculationType: Enum TaxCalculationType;
        VATAmount: Decimal;
        "W/TAmount": Decimal;
        PHead: Record "Payments Header";
        TempVendLedgEntry: Record "Vendor Ledger Entry";
        VendLedger1: Record "Vendor Ledger Entry";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        WTVATAmount: Decimal;
        ApplyVendEntries: Page "Apply Vendor Entries";
        CustLedger: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";

        AccName: Text;
        Direction: Text[30];
        TotalTax: Decimal;
        FundsMngt: Codeunit "Funds. Post Mngt.";
        PayToVendorNo: Code[100];
        Text000: Label 'You must specify %1 or %2.';
        VendLedgEntry: Record "Vendor Ledger Entry";
        ErrorModfDocumentTxt: Label 'You Cannot modify documents that are approved/posted/Send for Approval';

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; VendorNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";

    begin
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", AppliesToDocNo);
        VendLedgEntry.SETRANGE("Vendor No.", VendorNo);
        VendLedgEntry.SETRANGE(Open, TRUE);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
            IF VendLedgEntry."Amount to Apply" = 0 THEN BEGIN
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            END ELSE
                VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
        end;

    end;

    procedure CalculateTax()
    begin
        "VAT Amount" := 0;
        "Withholding Tax Amount" := 0;
        "Retention Amount" := 0;
        TotalTax := 0;
        "Net Amount" := 0;
        "VAT Withholding Amount" := 0;
        IF Amount <> 0 THEN BEGIN
            IF "VAT Rate" <> 0 THEN BEGIN

                "VAT Amount" := FundsMngt.CalculateTax(Rec, CalculationType::VAT);

                TotalTax := TotalTax + "VAT Amount"
            END;

            IF "W/Tax Rate" <> 0 THEN BEGIN
                "Withholding Tax Amount" := FundsMngt.CalculateTax(Rec, CalculationType::"W/Tax");
                TotalTax := TotalTax + "Withholding Tax Amount"
            END;

            IF "Retention Rate" <> 0 THEN BEGIN
                "Retention Amount" := FundsMngt.CalculateTax(Rec, CalculationType::Retention);
                TotalTax := TotalTax + "Retention Amount"
            END;

            IF "VAT Withholding Rate" <> 0 THEN BEGIN
                "VAT Withholding Amount" := FundsMngt.CalculateTax(Rec, CalculationType::"W/VAT");
                TotalTax := TotalTax + "VAT Withholding Amount";
            END;

        END;

        IF "VAT Deductible" = TRUE THEN
            "Net Amount" := Amount - TotalTax
        ELSE
            "Net Amount" := Amount - TotalTax + "VAT Amount";
        Validate("Net Amount");
    end;

    procedure GetAppliedDoc(): Code[50]
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        if "Applies-to ID" <> '' then begin
            case "Account Type" of
                "Account Type"::Customer:
                    begin
                        DetailedCustLedgEntry.Reset();
                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Customer No.", "Account No.");
                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", No);
                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Credit Amount", Amount);
                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
                        if DetailedCustLedgEntry.Find('-') then begin
                            DetailedCustLedgEntry2.Reset();
                            DetailedCustLedgEntry2.SetRange(DetailedCustLedgEntry2."Cust. Ledger Entry No.", DetailedCustLedgEntry."Cust. Ledger Entry No.");
                            if DetailedCustLedgEntry2.Find('-') then
                                exit(DetailedCustLedgEntry2."Document No.");
                        end;
                    end;

                "Account Type"::Vendor:
                    begin
                        DetailedVendorLedgEntry.Reset();
                        DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Vendor No.", "Account No.");
                        DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Document No.", No);
                        DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Debit Amount", Amount);
                        DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Entry Type", DetailedVendorLedgEntry."Entry Type"::Application);
                        if DetailedVendorLedgEntry.Find('-') then begin
                            DetailedVendorLedgEntry2.Reset();
                            DetailedVendorLedgEntry2.SetRange(DetailedVendorLedgEntry2."Vendor Ledger Entry No.", DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                            if DetailedVendorLedgEntry2.Find('-') then
                                exit(DetailedVendorLedgEntry2."Document No.");
                        end;

                    end;
            end;
        end;
    end;

    procedure GetCurrency()
    begin
    end;

    procedure GetGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if not HasGotGLSetup then begin
            GLSetup.Get();
            GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
            HasGotGLSetup := true;
        end;
    end;


    procedure ShowDimensions()
    begin

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Payment Type", No, "Line No"));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        GLBudget: Record "G/L Budget Entry";
        PaymentRec: Record "Payments Header";
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if (OldDimSetID <> "Dimension Set ID") and ((No <> '') and ("Line No" <> 0)) then begin
        end;

    end;

    local procedure CheckPayHeaderApprovalStatus()
    Phead: Record "Payments Header";
    begin
        Phead.Reset();
        Phead.SetRange("No.", No);
        if Phead.FindFirst() then begin
            case Phead."Approval Status" of
                Phead."Approval Status"::Approved,
                Phead."Approval Status"::Posted,
                Phead."Approval Status"::Rejected,
                Phead."Approval Status"::"Pending Approval":
                    begin
                        Error(ErrorModfDocumentTxt);

                    end;

            end;
        end;


    end;

    procedure ValidateSurrenderLines()
    var
        ShortcutDimCode: array[8] of Code[20];
    begin
        TestField(Purpose);
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
        GetGLSetup();
    end;

    procedure PayLinesExist(): Boolean
    var
        PayLine: Record "Payment Lines";
    begin
        PayLine.Reset();
        PayLine.SetRange(No, No);
        exit(PayLine.FindFirst());
    end;

    procedure GetPaymentLineType()
    begin

        "Account No." := '';
        "Account Name" := '';

        RecPayTypes.Reset();
        RecPayTypes.SetRange(RecPayTypes.Code, Type);
        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
        if RecPayTypes.FindFirst() then begin
            Grouping := RecPayTypes."Default Grouping";
            "Require Surrender" := RecPayTypes."Pending Voucher";
            "Payment Reference" := RecPayTypes."Payment Reference";
            "Budgetary Control A/C" := RecPayTypes."Direct Expense";
            "VAT Deductible" := RecPayTypes."VAT Deductable";

            if RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes then begin
                "VAT Code" := RecPayTypes."VAT Code";
                if TarrifCode.GET("VAT Code") then
                    "VAT Rate" := TarrifCode.Percentage;
            end;
            if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes then begin
                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                if TarrifCode.GET("Withholding Tax Code") then
                    "W/Tax Rate" := TarrifCode.Percentage;
            end;


            if RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes then begin
                "VAT Withholding Code" := RecPayTypes."VAT Withholding Code";
                IF TarrifCode.GET("VAT Withholding Code") THEN
                    "VAT Withholding Rate" := TarrifCode.Percentage;
            end;


            IF RecPayTypes."Calculate Retention" = RecPayTypes."Calculate Retention"::Yes THEN BEGIN
                "Retention Code" := RecPayTypes."Retention Code";
                IF TarrifCode.GET("Retention Code") THEN
                    "Retention Rate" := TarrifCode.Percentage;
            end;
            Validate("Account Type", RecPayTypes."Account Type");
            "Transaction Name" := RecPayTypes.Description;
            "Budgetary Control A/C" := RecPayTypes."Direct Expense";

            if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                if "Account No." <> '' then begin
                    RecPayTypes.TestField(RecPayTypes."Account Type");
                    "Account No." := RecPayTypes."Account No.";
                end;
                if "Account No." <> '' then
                    Validate("Account No.");
            end;
        end;

        PHead.Reset();
        PHead.SetRange(PHead."No.", No);
        if PHead.FindFirst() then begin
            Date := PHead.Date;
            PHead.TestField("Responsibility Center");
            "Shortcut Dimension 1 Code" := PHead."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := PHead."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := PHead."Shortcut Dimension 4 Code";
            "Dimension Set ID" := PHead."Dimension Set ID";
            "Payment Type" := PHead."Payment Type";
        end;
    end;
}


