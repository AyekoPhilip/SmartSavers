table 50393 "Banking A/c Ledger Entry"
{
    Caption = 'Banking A/c Ledger Entry';
    DrillDownPageID = "Savings Ledger Entries";
    LookupPageID = "Savings Ledger Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50012; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50015; "Currency Code."; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50016; "Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50017; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Remaining Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50018; "Original Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Original Amt. (LCY)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50019; "Remaining Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Amt. (LCY)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50020; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50021; "Sales (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Sales (LCY)';
            DataClassification = CustomerContent;
        }
        field(50022; "Profit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Profit (LCY)';
            DataClassification = CustomerContent;
        }
        field(50023; "Inv. Discount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount (LCY)';
            DataClassification = CustomerContent;
        }
        field(50024; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = "Account Banking"."No.";
            DataClassification = CustomerContent;
        }
        field(50025; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
        }
        field(50026; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50027; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50028; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(50029; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
            DataClassification = CustomerContent;
        }
        field(50030; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
        field(50031; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
            DataClassification = CustomerContent;
        }
        field(50032; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = CustomerContent;
        }
        field(50033; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Open"; Boolean)
        {
            Caption = 'Open';
            DataClassification = CustomerContent;
        }
        field(50035; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ReminderEntry: Record "Reminder/Fin. Charge Entry";
                ReminderIssue: Codeunit "Reminder-Issue";
            begin
                TestField(Open, true);
                if "Due Date" <> xRec."Due Date" then begin
                    ReminderEntry.SetCurrentKey("Customer Entry No.", Type);
                    ReminderEntry.SetRange("Customer Entry No.", "Entry No.");
                    ReminderEntry.SetRange(Type, ReminderEntry.Type::Reminder);
                    ReminderEntry.SetRange("Reminder Level", "Last Issued Reminder Level");
                    if ReminderEntry.FindLast then
                        ReminderIssue.ChangeDueDate(ReminderEntry, "Due Date", xRec."Due Date");
                end;
            end;
        }
        field(50036; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(50037; "Original Pmt. Disc. Possible"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Original Pmt. Disc. Possible';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50038; "Pmt. Disc. Given (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Disc. Given (LCY)';
            DataClassification = CustomerContent;
        }
        field(50039; "Positive"; Boolean)
        {
            Caption = 'Positive';
            DataClassification = CustomerContent;
        }
        field(50040; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            TableRelation = "Cust. Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(50041; "Closed at Date"; Date)
        {
            Caption = 'Closed at Date';
            DataClassification = CustomerContent;
        }
        field(50042; "Closed by Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Closed by Amount';
            DataClassification = CustomerContent;
        }
        field(50043; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(50044; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
        field(50045; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;
        }
        field(50046; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            DataClassification = CustomerContent;
        }
        field(50047; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
            DataClassification = CustomerContent;
        }
        field(50048; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
        }
        field(50049; "Closed by Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Closed by Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(50050; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50051; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50052; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50053; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50054; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(50055; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(50056; "Calculate Interest"; Boolean)
        {
            Caption = 'Calculate Interest';
            DataClassification = CustomerContent;
        }
        field(50057; "Closing Interest Calculated"; Boolean)
        {
            Caption = 'Closing Interest Calculated';
            DataClassification = CustomerContent;
        }
        field(50058; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50059; "Closed by Currency Code"; Code[10])
        {
            Caption = 'Closed by Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50060; "Closed by Currency Amount"; Decimal)
        {
            AutoFormatExpression = "Closed by Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Currency Amount';
            DataClassification = CustomerContent;
        }
        field(50061; "Adjusted Currency Factor"; Decimal)
        {
            Caption = 'Adjusted Currency Factor';
            // DecimalPlaces is unspecified in the supplied symbols.
            DataClassification = CustomerContent;
        }
        field(50062; "Original Currency Factor"; Decimal)
        {
            Caption = 'Original Currency Factor';
            // DecimalPlaces is unspecified in the supplied symbols.
            DataClassification = CustomerContent;
        }
        field(50063; "Original Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Original Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50064; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50065; "Remaining Pmt. Disc. Possible"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Remaining Pmt. Disc. Possible';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Open, true);
                //CALCFIELDS(Amount,"Original Amount");

                if "Remaining Pmt. Disc. Possible" * Amount < 0 then
                    FieldError("Remaining Pmt. Disc. Possible", StrSubstNo(Text000, FieldCaption(Amount)));

                if Abs("Remaining Pmt. Disc. Possible") > Abs("Original Amount") then
                    FieldError("Remaining Pmt. Disc. Possible", StrSubstNo(Text001, FieldCaption("Original Amount")));
            end;
        }
        field(50066; "Pmt. Disc. Tolerance Date"; Date)
        {
            Caption = 'Pmt. Disc. Tolerance Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(50067; "Max. Payment Tolerance"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Max. Payment Tolerance';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Open, true);
                //CALCFIELDS(Amount,"Remaining Amount");

                if "Max. Payment Tolerance" * Amount < 0 then
                    FieldError("Max. Payment Tolerance", StrSubstNo(Text000, FieldCaption(Amount)));

                if Abs("Max. Payment Tolerance") > Abs("Remaining Amount") then
                    FieldError("Max. Payment Tolerance", StrSubstNo(Text001, FieldCaption("Remaining Amount")));
            end;
        }
        field(50068; "Last Issued Reminder Level"; Integer)
        {
            Caption = 'Last Issued Reminder Level';
            DataClassification = CustomerContent;
        }
        field(50069; "Accepted Payment Tolerance"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Accepted Payment Tolerance';
            DataClassification = CustomerContent;
        }
        field(50070; "Accepted Pmt. Disc. Tolerance"; Boolean)
        {
            Caption = 'Accepted Pmt. Disc. Tolerance';
            DataClassification = CustomerContent;
        }
        field(50071; "Pmt. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Tolerance (LCY)';
            DataClassification = CustomerContent;
        }
        field(50072; "Amount to Apply"; Decimal)
        {
            AutoFormatExpression = "Currency Code.";
            AutoFormatType = 1;
            Caption = 'Amount to Apply';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Open, true);
                //CALCFIELDS("Remaining Amount");

                if "Amount to Apply" * "Remaining Amount" < 0 then
                    FieldError("Amount to Apply", StrSubstNo(Text000, FieldCaption("Remaining Amount")));

                if Abs("Amount to Apply") > Abs("Remaining Amount") then
                    FieldError("Amount to Apply", StrSubstNo(Text001, FieldCaption("Remaining Amount")));
            end;
        }
        field(50073; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
            DataClassification = CustomerContent;
        }
        field(50074; "Applying Entry"; Boolean)
        {
            Caption = 'Applying Entry';
            DataClassification = CustomerContent;
        }
        field(50075; "Reversed"; Boolean)
        {
            BlankZero = true;
            Caption = 'Reversed';
            DataClassification = CustomerContent;
        }
        field(50076; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            DataClassification = CustomerContent;
        }
        field(50077; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            DataClassification = CustomerContent;
        }
        field(50078; "Prepayment"; Boolean)
        {
            Caption = 'Prepayment';
            DataClassification = CustomerContent;
        }
        field(50079; "Group Code"; Code[20])
        {
            Caption = 'Group Code';
            DataClassification = CustomerContent;
        }
        field(50080; "Member Name"; Text[30])
        {
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(50081; "Bulk Process"; Boolean)
        {
            Caption = 'Bulk Process';
            DataClassification = CustomerContent;
        }
        field(50082; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
            DataClassification = CustomerContent;
        }
        field(50083; "Approver ID"; Code[50])
        {
            CalcFormula = Lookup("Approval Entry"."Approver ID" WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
            Caption = 'Approver ID';
        }
        field(50084; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50085; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
    }

    keys
    {
        key("Key1"; "Entry No.")
        {
            Clustered = true;
        }
        key("Key2"; "Customer No.", "Posting Date", "Currency Code.")
        {
            SumIndexFields = "Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)";
        }
        key("Key3"; "Customer No.", "Currency Code.", "Posting Date")
        {

        }
        key("Key4"; "Document No.")
        {

        }
        key("Key5"; "External Document No.")
        {

        }
        key("Key6"; "Customer No.", "Open", "Positive", "Due Date", "Currency Code.")
        {

        }
        key("Key7"; "Open", "Due Date")
        {

        }
        key("Key8"; "Document Type", "Customer No.", "Posting Date", "Currency Code.")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)";
        }
        key("Key9"; "Salesperson Code", "Posting Date")
        {

        }
        key("Key10"; "Closed by Entry No.")
        {

        }
        key("Key11"; "Transaction No.")
        {

        }
        key("Key12"; "Customer No.", "Open", "Positive", "Calculate Interest", "Due Date")
        {

        }
        key("Key13"; "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code.")
        {
            SumIndexFields = "Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)";
        }
        key("Key14"; "Customer No.", "Open", "Global Dimension 1 Code", "Global Dimension 2 Code", "Positive", "Due Date", "Currency Code.")
        {
            SumIndexFields = "Amount (LCY)","Amount";
        }
        key("Key15"; "Open", "Global Dimension 1 Code", "Global Dimension 2 Code", "Due Date")
        {

        }
        key("Key16"; "Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code.")
        {

        }
        key("Key17"; "Customer No.", "Applies-to ID", "Open", "Positive", "Due Date")
        {

        }
        key("Key18"; "Customer No.")
        {
            SumIndexFields = "Amount (LCY)","Amount";
        }
        key("Key19"; "Posting Date", "Customer No.")
        {
            SumIndexFields = "Amount (LCY)","Amount";
        }
        key("Key20"; "Amount", "Customer No.")
        {
            SumIndexFields = "Amount (LCY)","Amount";
        }
        key("Key21"; "Customer Posting Group")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //ERROR('');
    end;

    trigger OnInsert()
    begin
        //GenJnlPostPreview.SaveBankAccLedgEntry(Rec);
    end;

    trigger OnModify()
    begin
        //ERROR('');
    end;

    var
        Text000: Label 'must have the same sign as %1';
        Text001: Label 'must not be larger than %1';


    procedure DrillDownOnEntries(var CustLedger: Record "Banking A/c Ledger Entry")
    var
        CustLedgEntry: Record "Banking A/c Ledger Entry";
    begin

        //DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
        //DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
        //DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
        //DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentKey("Customer No.", "Posting Date");
        CustLedgEntry.SetRange(CustLedgEntry."Customer No.", CustLedger."Customer No.");
        CustLedgEntry.SetRange(Open, true);
        PAGE.Run(0, CustLedgEntry);
    end;


    procedure DrillDownOnOverdueEntries(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.Reset;
        DtldCustLedgEntry.CopyFilter("Customer No.", CustLedgEntry."Customer No.");
        DtldCustLedgEntry.CopyFilter("Currency Code", CustLedgEntry."Currency Code");
        DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 1", CustLedgEntry."Global Dimension 1 Code");
        DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 2", CustLedgEntry."Global Dimension 2 Code");
        CustLedgEntry.SetCurrentKey("Customer No.", "Posting Date");
        CustLedgEntry.SetFilter("Date Filter", '..%1', WorkDate);
        CustLedgEntry.SetFilter("Due Date", '..%1', WorkDate);
        CustLedgEntry.SetFilter("Remaining Amount", '<>%1', 0);
        PAGE.Run(0, CustLedgEntry);
    end;


    procedure GetOriginalCurrencyFactor(): Decimal
    begin
        if "Original Currency Factor" = 0 then
            exit(1);
        exit("Original Currency Factor");
    end;

    local procedure CheckGLAcc(AccNo: Code[20]; CheckProdPostingGroup: Boolean; CheckDirectPosting: Boolean)
    begin
        /*
        IF AccNo <> '' THEN BEGIN
          GLAcc.GET(AccNo);
          GLAcc.CheckGLAcc;
          IF CheckProdPostingGroup THEN
            GLAcc.TESTFIELD("Gen. Prod. Posting Group");
          IF CheckDirectPosting THEN
            GLAcc.TESTFIELD("Direct Posting",TRUE);
        END;
        */

    end;


    procedure TestNoEntriesExist(CurrentFieldName: Text[100]; GLNO: Code[20])
    var
        MemberLedgEntry: Record "Banking A/c Ledger Entry";
    begin
        //To prevent change of field
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange(MemberLedgEntry."Customer No.", "Customer No.");
        if MemberLedgEntry.Find('-') then
            Error(
            Text000,
             CurrentFieldName);
    end;


    procedure RecalculateAmounts(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; PostingDate: Date)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if ToCurrencyCode = FromCurrencyCode then
            exit;

        "Remaining Amount" :=
          CurrExchRate.ExchangeAmount("Remaining Amount", FromCurrencyCode, ToCurrencyCode, PostingDate);
        "Remaining Pmt. Disc. Possible" :=
          CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible", FromCurrencyCode, ToCurrencyCode, PostingDate);
        "Accepted Payment Tolerance" :=
          CurrExchRate.ExchangeAmount("Accepted Payment Tolerance", FromCurrencyCode, ToCurrencyCode, PostingDate);
        "Amount to Apply" :=
          CurrExchRate.ExchangeAmount("Amount to Apply", FromCurrencyCode, ToCurrencyCode, PostingDate);
    end;


    procedure CopyFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        "Customer No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        "Currency Code." := GenJnlLine."Currency Code";
        "Sales (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
        "Profit (LCY)" := GenJnlLine."Profit (LCY)";
        "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
        "Sell-to Customer No." := GenJnlLine."Sell-to/Buy-from No.";
        "Customer Posting Group" := GenJnlLine."Posting Group";
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Salesperson Code" := GenJnlLine."Salespers./Purch. Code";
        "Source Code" := GenJnlLine."Source Code";
        "On Hold" := GenJnlLine."On Hold";
        "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
        "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
        "Due Date" := GenJnlLine."Due Date";
        "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
        "Applies-to ID" := GenJnlLine."Applies-to ID";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "User ID" := UserId;
        "Bal. Account Type" := GenJnlLine."Bal. Account Type";
        "Bal. Account No." := GenJnlLine."Bal. Account No.";
        "No. Series" := GenJnlLine."Posting No. Series";
        "IC Partner Code" := GenJnlLine."IC Partner Code";
        Prepayment := GenJnlLine.Prepayment;
        "Debit Amount" := GenJnlLine."Debit Amount";
        "Credit Amount" := GenJnlLine."Credit Amount";
    end;


    procedure UpdateDebitCredit(Correction: Boolean)
    begin
        if ((Amount > 0) or ("Amount (LCY)" > 0)) and not Correction or
           ((Amount < 0) or ("Amount (LCY)" < 0)) and Correction
        then begin
            "Debit Amount" := Amount;
            "Credit Amount" := 0;
            "Debit Amount (LCY)" := "Amount (LCY)";
            "Credit Amount (LCY)" := 0;
        end else begin
            "Debit Amount" := 0;
            "Credit Amount" := -Amount;
            "Debit Amount (LCY)" := 0;
            "Credit Amount (LCY)" := -"Amount (LCY)";
        end;
    end;


    procedure ShowDimensions()
    begin
        //DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;
}




