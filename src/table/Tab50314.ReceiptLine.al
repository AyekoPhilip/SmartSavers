table 50314 "Receipt Line"
{


    fields
    {
        field(50009; "No"; Code[20])
        {
            NotBlank = false;
            TableRelation = "Receipts Header"."No.";
        }
        field(50010; "Date"; Date)
        {
            CalcFormula = Lookup("Receipts Header".Date WHERE("No." = FIELD(No)));
            FieldClass = FlowField;
        }
        field(50011; "Type"; Code[100])
        {
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Receipt),
                                                                     Blocked = CONST(false));
        
            trigger OnValidate()
            var
                RecHeader: Record "Receipts Header";
            begin

                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Receipt);
                if RecPayTypes.Find('-') then begin

                    case RecPayTypes."Account Type" of
                        RecPayTypes."Account Type"::Saving,
                        RecPayTypes."Account Type"::Loan,
                        RecPayTypes."Account Type"::Credit:
                            begin
                                RecHeader.Reset();
                                RecHeader.SetRange("No.", No);
                                if RecHeader.FindFirst() then begin
                                end;
                            end;
                    end;

                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;
                    Grouping := RecPayTypes."Default Grouping";
                    Remarks := RecPayTypes."Transation Remarks";
                    "Customer Payment On Account" := RecPayTypes."Customer Payment On Account";
                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                        if "Account No." <> '' then
                            RecPayTypes.TestField(RecPayTypes."Account Type");
                        "Account No." := RecPayTypes."Account No.";
                        if "Account No." <> '' then
                            Validate("Account No.");
                    end;
                end;

                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Receipt);

                RHead.Reset;
                RHead.SetRange(RHead."No.", No);
                if RHead.FindFirst then begin
                    "Global Dimension 1 Code" := RHead."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := RHead."Shortcut Dimension 2 Code";
                    "Dimension Set ID" := RHead."Dimension Set ID";
                    "Group Code" := RHead."Group Code";
                end;

            end;
        }
        field(50012; "Pay Mode"; Enum "PaymentMode")
        {

        
            trigger OnValidate()
            begin
                GenLedgerSetup.Reset;
                GenLedgerSetup.Get();

            end;
        }
        field(50013; "Cheque/Deposit Slip No"; Code[20])
        {

        
            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(50014; "Cheque/Deposit Slip Date"; Date)
        {

        }

        field(50015; "Cheque/Deposit Slip Type"; Option)
        {
            OptionMembers = " "," Local","Up Country";
        }
        field(50016; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account"."No." WHERE("Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code"));
        }
        field(50017; "Received From"; Text[100])
        {

        }
        field(50018; "On Behalf Of"; Text[100])
        {

        }
        field(50019; "Cashier"; Code[50])
        {

        }
        field(50020; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            Editable = false;
        }
        field(50021; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
             WHERE("Account Type" = CONST(Posting), Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer where("Customer Posting Group" = field(Grouping))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee
            ELSE

            IF ("Account Type" = const(Saving), "Allow Multiple Receipts" = filter(No)) "Account Banking"
            where(Status = filter(Active | Dormant | New), "Member No." = field("Member No."),
            "Customer Posting Group" = field(Grouping))
            else
            IF ("Account Type" = const(Credit), "Allow Multiple Receipts" = filter(No))
            "Account Credit" where(Status = filter(Active | New | Dormant | Defaulter),
            "Member No." = field("Member No."), "Customer Posting Group" = field(Grouping))
            else
            if ("Account Type" = const(Loan), "Allow Multiple Receipts" = filter(No)) "Credit Account"
            where("Member No." = field("Member No."), "Balance (LCY)" = filter(> 0))

            else if ("Account Type" = const(Saving), "Allow Multiple Receipts" = filter(Yes))
            "Account Banking" where(Status = filter(Active | Dormant | New)) else

            if ("Account Type" = const(Credit), "Allow Multiple Receipts" = filter(Yes))
             "Account Credit" where(Status = filter(Active | Dormant | New)) else

            if ("Account Type" = const(Loan), "Allow Multiple Receipts" = filter(No))
            "Credit Account" where(Status = filter(Active | Dormant | New));
        
            trigger OnValidate()
            begin

                "Account Name" := '';

                if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::Customer,
                   "Account Type"::Vendor, "Account Type"::"IC Partner", "Account Type"::Employee,
                   "Account Type"::Saving, "Account Type"::Credit, "Account Type"::Prepayment, "Account Type"::Loan] then
                    case "Account Type" of
                        "Account Type"::"G/L Account":
                            begin
                                GLAcc.Get("Account No.");
                                "Account Name" := GLAcc.Name;
                                "Global Dimension 1 Code" := GLAcc."Global Dimension 1 Code";
                                "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
                                "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                                "Gen. Posting Type" := GLAcc."Gen. Posting Type";
                                "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                                "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                                VATSetup.Reset;
                                VATSetup.SetRange(VATSetup."VAT Bus. Posting Group", "VAT Bus. Posting Group");
                                VATSetup.SetRange(VATSetup."VAT Prod. Posting Group", "VAT Prod. Posting Group");
                                if VATSetup.Find('-') then begin
                                    "VAT %" := VATSetup."VAT %";
                                end;
                            end;
                        "Account Type"::Customer:
                            begin
                                GetHeader();
                                Cust.Get("Account No.");
                                "Account Name" := Cust.Name;
                                RHead."Received From" := "Account Name";
                                "Product Type" := Cust."Product Type";
                            end;
                        "Account Type"::Vendor:
                            begin
                                Vend.Get("Account No.");
                                "Account Name" := Vend.Name;
                                "Product Type" := Vend."Product Type"

                            end;
                        "Account Type"::"Bank Account":
                            begin
                                BankAcc.Get("Account No.");
                                "Account Name" := BankAcc.Name;
                            end;
                        "Account Type"::"Fixed Asset":
                            begin
                                FA.Get("Account No.");
                                "Account Name" := FA.Description;
                            end;
                        "Account Type"::"IC Partner":
                            begin
                                ICPartner.Reset;
                                ICPartner.Get("Account No.");
                                "Account Name" := ICPartner.Name;
                            end;

                        "Account Type"::Saving:
                            begin

                                if SavingsAcc.Get("Account No.") then begin
                                    SavingsAcc.CalcFields("Balance (LCY)");
                                    "Account Name" := SavingsAcc."Product Name";
                                    Balance := SavingsAcc."Balance (LCY)";
                                    "Product Category" := SavingsAcc."Account Category";
                                    "Product Description" := SavingsAcc."Product Name";
                                    "Product Type" := SavingsAcc."Product Type";
                                    "Account Status" := SavingsAcc.Status;
                                end;
                                Validate("Member No.");
                            end;

                        "Account Type"::Credit:
                            begin
                                if AccCredit.Get("Account No.") then begin
                                    AccCredit.CalcFields("Balance (LCY)");
                                    "Account Name" := AccCredit."Product Name";
                                    Balance := AccCredit."Balance (LCY)";
                                    "Product Category" := AccCredit."Account Category";
                                    "Product Description" := AccCredit."Product Name";
                                    "Product Type" := AccCredit."Product Type";
                                    "Account Status" := AccCredit.Status;
                                end;
                                Validate("Member No.");
                            end;

                        "Account Type"::Loan:
                            begin
                                if LoanAcc.Get("Account No.") then begin
                                    "Account Name" := LoanAcc."Product Name";
                                    "Product Type" := LoanAcc."Product Type";
                                    "Product Description" := LoanAcc."Product Name";
                                end;
                                Validate("Member No.");
                            end;

                        "Account Type"::Prepayment:
                            begin
                                if CreditRepayAcc.Get("Account No.") then begin
                                    "Account Name" := CreditRepayAcc.Name;
                                    "Product Description" := CreditRepayAcc."Product Name";
                                end;
                                Validate("Member No.");
                            end;

                    end;
            end;
        }
        field(50022; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50023; "Account Name"; Text[150])
        {

        }
        field(50024; "Posted"; Boolean)
        {

        }
        field(50025; "Date Posted"; Date)
        {

        }
        field(50026; "Time Posted"; Time)
        {

        }
        field(50027; "Posted By"; Code[50])
        {

        }
        field(50028; "Amount"; Decimal)
        {

        
            trigger OnValidate()
            var
                CredAccount: Record "Account Credit";
                ProdFact: Record "Product Factory";
                CurrencyExchangeRate: Record "Currency Exchange Rate";
                ReceiptHeader: Record "Receipts Header";
            begin

                if "Loan No." <> '' then begin
                    if Loans.Get("Loan No.") then begin
                        Loans.CalcFields("Outstanding Principal", "Outstanding Balance", "Outstanding Interest", "Outstanding Insurance");

                        if Loans."Outstanding Balance" > 0 then begin

                            case "Transaction Type" of
                                "Transaction Type"::Repayment:
                                    begin

                                        if Amount > Loans."Outstanding Balance" then begin
                                            Amount := Loans."Outstanding Balance"
                                        end else begin
                                            Amount := Amount;
                                        end;
                                    end;
                                "Transaction Type"::"Interest Paid":
                                    begin

                                        if Amount >= Loans."Outstanding Interest" then
                                            Amount := Loans."Outstanding Interest" else
                                            Amount := Amount;
                                    end;
                                "Transaction Type"::"Insurance Paid":
                                    begin
                                        if Amount > Loans."Outstanding Insurance" then
                                            Amount := Loans."Outstanding Insurance" else
                                            Amount := Amount;
                                    end
                            end
                        end;
                    end;
                end;
                "Total Amount" := Amount;
                "Amount (LCY)" := Amount;

                ReceiptHeader.Reset();
                ReceiptHeader.SetRange("No.", No);
                if ReceiptHeader.FindFirst() then
                    if ReceiptHeader."Currency Code" <> '' then begin
                        "Amount (LCY)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                                                        ReceiptHeader."Document Date",
                                                        ReceiptHeader."Currency Code",
                                                        Amount, CurrencyExchangeRate.ExchangeRate(ReceiptHeader.Date, ReceiptHeader."Currency Code"));
                    end else
                        "Amount (LCY)" := Amount;
                "Accrued Intrest FCY" := "Accrued Intrest";
                "Outstanding Intrest FCY" := "Interest Balance";

                ReceiptHeader.Reset();
                ReceiptHeader.SetRange("No.", No);
                if ReceiptHeader.FindFirst() then
                    if ReceiptHeader."Currency Code" <> '' then
                        "Outstanding Intrest FCY" := Round(CurrencyExchangeRate.ExchangeAmtLCYToFCY(ReceiptHeader.Date,
                                                       ReceiptHeader."Currency Code", "Interest Balance", CurrencyExchangeRate.ExchangeRate(ReceiptHeader.Date, ReceiptHeader."Currency Code")), 0.01, '>')

                    else
                        "Outstanding Intrest FCY" := "Interest Balance";
            end;
        }
        field(50029; "Remarks"; Text[250])
        {

        }
        field(50030; "Transaction Name"; Text[100])
        {

        }
        field(50031; "Branch Code"; Code[20])
        {

        }
        field(50032; "Agent Code"; Code[20])
        {

        }
        field(50033; "Grouping"; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(50034; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(50035; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50036; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            // DecimalPlaces is unspecified in the supplied symbols.
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(50037; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(50038; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            // DecimalPlaces is unspecified in the supplied symbols.
            Editable = false;
            MinValue = 0;
        }
        field(50039; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        
            trigger OnValidate()
            begin
                if "Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] then
                    TestField("VAT Bus. Posting Group", '');
                Validate("VAT Prod. Posting Group");
            end;
        }
        field(50040; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        
            trigger OnValidate()
            begin
                if "Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] then
                    TestField("VAT Prod. Posting Group", '');

                "VAT %" := 0;
                "VAT Calculation Type" := "VAT Calculation Type"::"Normal VAT";
                if "Gen. Posting Type" <> "Gen. Posting Type"::" " then begin

                    if not VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                        VATPostingSetup.Init;
                    "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                    case "VAT Calculation Type" of
                        "VAT Calculation Type"::"Normal VAT":
                            "VAT %" := VATPostingSetup."VAT %";
                        "VAT Calculation Type"::"Full VAT":
                            case "Gen. Posting Type" of
                                "Gen. Posting Type"::Sale:
                                    begin
                                        VATPostingSetup.TestField("Sales VAT Account");
                                        TestField("Account No.", VATPostingSetup."Sales VAT Account");
                                    end;
                                "Gen. Posting Type"::Purchase:
                                    begin
                                        VATPostingSetup.TestField("Purchase VAT Account");
                                        TestField("Account No.", VATPostingSetup."Purchase VAT Account");
                                    end;
                            end;
                    end;
                end;
                Validate("VAT %");
            end;
        }
        field(50041; "Gen. Posting Type"; Enum "General Posting Type")
        {
            Caption = 'Gen. Posting Type';
        
            trigger OnValidate()
            begin
                if "Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] then
                    TestField("Gen. Posting Type", "Gen. Posting Type"::" ");
                if ("Gen. Posting Type" = "Gen. Posting Type"::Settlement) and (CurrFieldNo <> 0) then
                    Error(Text001, "Gen. Posting Type");

                if "Gen. Posting Type" <> "Gen. Posting Type"::" " then
                    Validate("VAT Prod. Posting Group");
            end;
        }
        field(50042; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        
            trigger OnValidate()
            begin

                if "Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] then
                    TestField("Gen. Bus. Posting Group", '');
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(50043; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        
            trigger OnValidate()
            begin

                if "Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] then
                    TestField("Gen. Prod. Posting Group", '');
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(50044; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
        }
        field(50045; "VAT Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(50046; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(50047; "User ID"; Code[50])
        {

        }
        field(50048; "Apply to"; Code[20])
        {

        }
        field(50049; "Apply to ID"; Code[20])
        {
            Editable = true;
        }
        field(50050; "Dest Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50051; "Dest Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50052; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(50053; "Print No."; Integer)
        {

        }
        field(50054; "Status"; Option)
        {
            OptionMembers = " ","Normal","Post Dated","Posted";
        }
        field(50055; "Deposit Slip Time"; Time)
        {

        
            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(50056; "Teller ID"; Code[50])
        {

        
            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(50057; "Customer Payment On Account"; Boolean)
        {

        }
        field(50058; "Select"; Boolean)
        {

        }
        field(50059; "Batch Posted"; Boolean)
        {

        }
        field(50060; "Transaction No."; Code[20])
        {

        }
        field(50061; "Cheque/Deposit Slip Bank"; Code[20])
        {

        }
        field(50062; "Bank Account"; Code[30])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50063; "Confirmed"; Boolean)
        {

        }
        field(50064; "Reconciled"; Boolean)
        {

        }
        field(50065; "Orig. Cashier"; Code[50])
        {
            CalcFormula = Lookup("Receipts Header".Cashier WHERE("No." = FIELD(No)));
            FieldClass = FlowField;
        }
        field(50066; "Cancelled"; Boolean)
        {

        }
        field(50067; "Cancelled By"; Code[50])
        {

        }
        field(50068; "Cancelled Date"; Date)
        {

        }
        field(50069; "Cancelled Time"; Time)
        {

        }
        field(50070; "Post Dated"; Boolean)
        {

        }
        field(50071; "Cheque Retrieved"; Boolean)
        {

        }
        field(50072; "Register Number"; Integer)
        {

        }
        field(50073; "From Entry No"; Integer)
        {

        }
        field(50074; "To Entry No"; Integer)
        {

        }
        field(50075; "Batch Posted UserID"; Code[50])
        {

        }
        field(50076; "BD Register Number"; Integer)
        {

        }
        field(50077; "BD From Number"; Integer)
        {

        }
        field(50078; "BD To Number"; Integer)
        {

        }
        field(50079; "Reversal By"; Code[50])
        {

        }
        field(50080; "Reversal Date"; Date)
        {

        }
        field(50081; "Reversal Time"; Time)
        {

        }
        field(50082; "Reversal Register No."; Integer)
        {

        }
        field(50083; "Reversal From Entry No."; Integer)
        {

        }
        field(50084; "Reversal To Entry No."; Integer)
        {

        }
        field(50085; "Reversed"; Boolean)
        {

        }
        field(50087; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";
        }
        field(50088; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        
            trigger OnLookup()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                BilToCustNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
                CustLedgerEntry1: Record "Cust. Ledger Entry";
                NetAmount: Decimal;
            begin

                if "Account Type" in ["Account Type"::Customer] then begin
                    CustLedgEntry.Reset;
                    CustLedgEntry.SetCurrentKey(CustLedgEntry."Customer No.", Open, "Document No.");
                    CustLedgEntry.SetRange(CustLedgEntry."Customer No.", "Account No.");
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.CalcFields("Remaining Amount");
                    if PAGE.RunModal(0, CustLedgEntry) = ACTION::LookupOK then begin
                        if CustLedgEntry."Applies-to ID" <> '' then begin
                            CustLedgerEntry1.Reset;
                            CustLedgerEntry1.SetCurrentKey(CustLedgerEntry1."Customer No.", Open, "Applies-to ID");
                            CustLedgerEntry1.SetRange(CustLedgerEntry1."Customer No.", "Account No.");
                            CustLedgerEntry1.SetRange(Open, true);
                            CustLedgerEntry1.SetRange(CustLedgerEntry1."Applies-to ID", CustLedgEntry."Applies-to ID");
                            if CustLedgerEntry1.Find('-') then begin
                                repeat
                                    CustLedgerEntry1.CalcFields(CustLedgerEntry1."Remaining Amount");
                                    NetAmount := NetAmount + Abs(CustLedgerEntry1."Remaining Amount");
                                until CustLedgerEntry1.Next = 0;
                            end;
                            if NetAmount <> NetAmount then
                                if Amount = 0 then
                                    Amount := NetAmount;
                            Validate(Amount);
                            "Applies-to Doc. No." := CustLedgEntry."Document No.";
                        end else begin
                            if Amount <> Abs(CustLedgEntry."Remaining Amount") then
                                CustLedgEntry.CalcFields(CustLedgEntry."Remaining Amount");
                            if Amount = 0 then
                                Amount := Abs(CustLedgEntry."Remaining Amount");

                            Validate(Amount);
                            "Applies-to Doc. No." := CustLedgEntry."Document No.";
                        end;
                    end;
                    Amount := Abs(CustLedgEntry."Remaining Amount");
                    Validate(Amount);
                end;

            end;

            trigger OnValidate()
            begin

                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
                   ("Applies-to Doc. No." <> '')
                then begin
                    SetAmountToApply("Applies-to Doc. No.", "Account No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
                end else
                    if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." = '') then
                        SetAmountToApply("Applies-to Doc. No.", "Account No.")
                    else
                        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and ("Applies-to Doc. No." = '') then
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
            end;
        }
        field(50089; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
        
            trigger OnValidate()
            var
                TempCustLedgEntry: Record "Cust. Ledger Entry";
            begin
                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                    CustLedgEntry.SetCurrentKey("Customer No.", Open);
                    CustLedgEntry.SetRange("Customer No.", "Account No.");
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.SetRange("Applies-to ID", xRec."Applies-to ID");
                    if CustLedgEntry.FindFirst then
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                    CustLedgEntry.Reset;
                end;
            end;
        }
        field(50090; "Grant No"; Code[20])
        {

        }
        field(50091; "Installment Number"; Integer)
        {

        }
        field(50092; "Next Installment Date"; Date)
        {

        }
        field(50093; "Performance Indicator"; Enum "LoanPerformanceIndicator")
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Performance Indicator';
            Editable = false;
        }
        field(50094; "Account Status"; Enum "MemberStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Status';
            Editable = false;
        }
        field(50098; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        
            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50099; "Group Code"; Code[20])
        {

        }
        field(50100; "Donor"; Code[30])
        {

        }
        field(50101; "Loan No."; Code[20])
        {
            TableRelation = Loans."No." where("Loan Account" = field("Account No."), "Outstanding Balance" = filter(> 0));
        
            trigger OnValidate()
            var
                PLoans: Record Loans;
            begin
                "Transaction Type" := "Transaction Type"::Repayment;

                if LoanCategory.Get("Loan No.") then begin
                    LoanCategory.CalcFields("Outstanding Balance", "Outstanding Interest");
                    "Performance Indicator" := LoanCategory."Performance Indicator";
                end;
                if Loans.Get("Loan No.") then begin
                    Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Insurance");
                    "Outstanding Insurance" := Loans."Outstanding Insurance";
                    "Interest Balance" := Loans."Outstanding Interest";
                    Balance := Loans."Outstanding Balance";
                end;

            end;
        }

        field(50102; "Transaction Type"; Enum "LoanTransactionType")
        {

        
            trigger OnValidate()
            begin
                if "Transaction Type" <> "Transaction Type"::Repayment then
                    Error('Transaction Type not supported');

                TestField("Loan No.");
                TestField("Account Type", "Account Type"::Loan);
                if Loans.Get("Loan No.") then begin
                    Loans.CalcFields("Outstanding Principal", "Outstanding Balance",
                    "Outstanding Interest", "Outstanding Insurance");

                    case "Transaction Type" of
                        "Transaction Type"::Repayment:
                            begin
                                Amount := Loans.Repayment;
                                Balance := Loans."Outstanding Principal";
                                "Interest Balance" := (Loans."Outstanding Interest")
                            end;
                        "Transaction Type"::"Interest Paid":
                            begin
                                Loans.CalcFields("Outstanding Interest");
                                Amount := Loans."Outstanding Interest";
                                "Interest Balance" := (Loans."Outstanding Interest")
                            end;
                        "Transaction Type"::"Insurance Paid":
                            begin
                                Amount := Round(((Loans."Approved Amount" * 0.01) / Loans.Installments), 1, '=');
                            end
                    end
                end;
            end;
        }
        field(50103; "Balance"; Decimal)
        {
            Editable = false;
        }
        field(50104; "Product Category"; Enum "ProductAccountCategory")
        {
            Description = 'Option to help identify type of savings accounts';
            Editable = false;
        }
        field(50105; "Member No."; Code[100])
        {
            TableRelation = Member where(Status = filter(Active | Dormant | New | Defaulter | Withdrawn));
        
            trigger OnValidate()
            begin
                if CustRecord.Get("Member No.") then begin

                end;
            end;
        }
        field(50106; "Product Description"; Text[80])
        {

        }
        field(50107; "Charge Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "Product Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Product Factory"."Product ID";
        }
        field(50109; "Charge Late Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Charge Fee Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "Interest Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50112; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50113; "Accrued Intrest"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50114; "Accrued Intrest FCY"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50115; "Outstanding Intrest FCY"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50086; "Clear Loan"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = true;
        
            trigger OnValidate()
            begin
                Rec.TestField("Loan No.");
                "Transaction Type" := "Transaction Type"::Repayment;
                case Rec."Clear Loan" of
                    true:
                        begin
                            Getsetup.Get();
                            case Getsetup."Interest Posting Method" of
                                Getsetup."Interest Posting Method"::"Charge Daily":
                                    begin
                                        if Loans.Get("Loan No.") then begin
                                            Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill", "Outstanding Insurance");
                                            EndDate := Today;
                                            StartDate := CalcDate('-CM', Today);
                                            IntDays := (EndDate - StartDate) + 1;
                                            "Accrued Intrest" := Round((PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate)), 0.5, '=');
                                            "Settlement Fee" := Round((RegMngt.getsettlementFee("Loan No.")), 0.5, '=');
                                            Balance := (Loans."Outstanding Balance" + "Accrued Intrest" + "Settlement Fee");
                                            "Interest Balance" := (Loans."Outstanding Interest" + "Accrued Intrest");
                                            Amount := (Loans."Outstanding Balance" + "Accrued Intrest" + "Settlement Fee");
                                            "Amount (LCY)" := Amount;
                                        end;
                                    end;
                            end;
                        end;
                    false:
                        begin
                            if Loans.Get("Loan No.") then begin
                                Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill", "Outstanding Insurance");
                                "Accrued Intrest" := 0;
                                "Settlement Fee" := 0;
                                Balance := Loans."Outstanding Balance";
                                "Interest Balance" := Loans."Outstanding Interest";
                                Amount := Loans."Outstanding Balance";
                                "Amount (LCY)" := Amount;
                            end;
                        end;
                end;
            end;
        }

        field(50095; "Settlement Fee"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50096; "Outstanding Insurance"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50097; "Allow Multiple Receipts"; Option)
        {
            Caption = 'Allow Multiple Receipts';
            Editable = false;
            OptionMembers = "No","Yes";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("Key1"; "Account No.", "No", "Member No.", "Loan No.", "Allow Multiple Receipts")
        {
            Clustered = true;
            SumIndexFields = "Amount","Total Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Posted then
            Error('The transaction has already been posted and therefore cannot be modified.');
    end;

    trigger OnInsert()
    begin
        RHead.Reset;
        RHead.SetRange(RHead."No.", No);
        if RHead.FindFirst then begin
            RHead.TestField("Responsibility Center");
            "Global Dimension 1 Code" := RHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RHead."Shortcut Dimension 2 Code";
            "Dimension Set ID" := RHead."Dimension Set ID";
        end;
    end;

    trigger OnModify()
    begin

        RHead.Reset;
        RHead.SetRange(RHead."No.", No);
        if RHead.FindFirst then begin
            "Global Dimension 1 Code" := RHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RHead."Shortcut Dimension 2 Code";

            if RHead.Posted then
                Error('The transaction has already been posted and therefore cannot be modified.');
        end;
    end;

    trigger OnRename()
    begin
        if Posted = true then
            Error('The transaction has already been posted and therefore cannot be modified.');
    end;

    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        SavingsAcc: Record "Account Banking";
        CreditAcc: Record "Credit Account";
        CreditRepayAcc: Record "Repayment Account";
        NoSeriesMgt: Codeunit "No. Series";
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        RegMngt: Codeunit "Register Management";
        EndDate: Date;
        IntDays: Integer;
        GenLedgerSetup: Record "Cash Management Setups";
        RecPayTypes: Record "Receipts and Payment Types";
        VATPostingSetup: Record "VAT Posting Setup";
        Text001: Label 'The %1 option can only be used internally in the system.';
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust2: Record Customer;
        Vend2: Record Vendor;
        BankAcc2: Record "Bank Account";
        BankAcc3: Record "Bank Account";
        Text002: Label 'LCY';
        VATSetup: Record "VAT Posting Setup";
        RecLine: Record "Receipt Line";
        SRSetup: Record "Sales & Receivables Setup";
        ICPartner: Record "IC Partner";
        RHead: Record "Receipts Header";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        ApplyCustEntries: Page "Apply Customer Entries";
        DimMgt: Codeunit DimensionManagement;
        Loans: Record Loans;
        CustRecord: Record Member;
        AccCredit: Record "Account Credit";
        LoanAcc: Record "Credit Account";
        Getsetup: Record "General Set-Up";
        LoanCategory: Record "Loans Categorization";

    local procedure SetCurrencyCode(AccType2: Option "G/L Account",Customer,Vendor,"Bank Account"; AccNo2: Code[20]): Boolean
    begin
        "Currency Code" := '';
        if AccNo2 <> '' then
            case AccType2 of
                AccType2::Customer:
                    if Cust2.Get(AccNo2) then
                        "Currency Code" := Cust2."Currency Code";
                AccType2::Vendor:
                    if Vend2.Get(AccNo2) then
                        "Currency Code" := Vend2."Currency Code";
                AccType2::"Bank Account":
                    if BankAcc2.Get(AccNo2) then
                        "Currency Code" := BankAcc2."Currency Code";
            end;
        exit("Currency Code" <> '');
    end;

    local procedure GetCurrency()
    begin
    end;


    procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        if CurrencyCode <> '' then
            exit(CurrencyCode)
        else
            exit(Text002);
    end;

    procedure CheckSlipDetails()
    var
        IsExistent: Boolean;
    begin


        IsExistent := false;

        case "Pay Mode" of
            "Pay Mode"::"Deposit Slip", "Pay Mode"::Cheque:
                begin

                    RecLine.Reset;
                    RecLine.SetRange(RecLine."Cheque/Deposit Slip No", "Cheque/Deposit Slip No");
                    if RecLine.Find('-') then begin
                        repeat
                            if (RecLine."Line No." <> "Line No.") then begin
                                IsExistent := true;
                            end;
                        until RecLine.Next = 0;
                    end;
                end;
        end;
        if IsExistent then begin
            Error('Bank Deposit Slip(s) with the same details exist.%1', RecLine."Cheque/Deposit Slip No")
        end;
    end;


    procedure SetAmountToApply(AppliesToDocNo: Code[20]; CustomerNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentKey("Document No.");
        CustLedgEntry.SetRange("Document No.", AppliesToDocNo);
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange(Open, true);
        if CustLedgEntry.FindFirst then begin
            if CustLedgEntry."Amount to Apply" = 0 then begin
                CustLedgEntry.CalcFields("Remaining Amount");
                CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
            end else
                CustLedgEntry."Amount to Apply" := 0;
            CustLedgEntry."Accepted Payment Tolerance" := 0;
            CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
            CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", CustLedgEntry);
        end;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Receipt', "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;

        "Global Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        if (OldDimSetID <> "Dimension Set ID") then begin
            Modify;

        end;
    end;

    local procedure GetHeader()
    begin
        IF RHead.Get(No) then;
    end;

    procedure ConvertIntresttoFCY()
    var
        ExchRate2: Record "Currency Exchange Rate";
        ReceiptHeader: Record "Receipts Header";
    begin
        if ReceiptHeader."Currency Code" <> '' then
            "Accrued Intrest FCY" := ExchRate2.ExchangeAmtLCYToFCY(Date, ReceiptHeader."Currency Code", "Interest Balance", ExchRate2.ExchangeRate(date, "Currency Code"))
        else
            "Accrued Intrest FCY" := "Interest Balance";


    end;
}




