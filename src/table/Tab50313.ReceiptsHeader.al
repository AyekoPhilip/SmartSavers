table 50313 "Receipts Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[20])
        {
            Description = 'Stores the code of the receipt in the database';
            DataClassification = CustomerContent;
            Caption = 'No.';
        
            trigger OnValidate()
            begin
                TestNoSeriesMgt();
            end;
        }
        field(50010; "Date"; Date)
        {
            Description = 'Stores the date when the receipt was entered into the system';
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(50011; "Cashier"; Code[50])
        {
            Description = 'Stores the user id of the cashier';
            Editable = false;
            TableRelation = "Banking User Template"."Account ID";
            DataClassification = CustomerContent;
            Caption = 'Cashier';
        }
        field(50012; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50013; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Posted';
        }
        field(50014; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted';
        }
        field(50015; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
        }
        field(50016; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
            DataClassification = CustomerContent;
            Caption = 'Bank Code';
        
            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code');
                end;
                if bank.Get("Bank Code") then
                    "Bank Name" := bank.Name;
            end;
        }
        field(50017; "Received From"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Received From';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50018; "On Behalf Of"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'On Behalf Of';
        }
        field(50019; "Amount Recieved"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Recieved';
        }
        field(50020; "Amount Recieved LCY"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Recieved LCY';
        }
        field(50021; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(50022; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50023; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CurrencyExchangerates.GetLastestExchangeRate("Currency Code", "Document Date", ExchangeRate);
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code');

                end else begin
                    "Bank Code" := '';
                end;
            end;
        }
        field(50024; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            // DecimalPlaces is unspecified in the supplied symbols.
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(50025; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Receipt Line".Amount WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Amount';
        }
        field(50026; "Posted By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Posted By';
        }
        field(50027; "Print No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Print No.';
        }
        field(50028; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Status';
        }
        field(50029; "Cheque No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque No.';
        }
        field(50030; "No. Printed"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. Printed';
        }
        field(50031; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(50032; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Created Date Time';
        }
        field(50033; "Register No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Register No.';
        }
        field(50034; "From Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'From Entry No.';
        }
        field(50035; "To Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'To Entry No.';
        }
        field(50036; "Document Date"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Document Date';
        }
        field(50037; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code');
                end else begin
                    "Bank Code" := '';
                end;

                TestField("Approval Status", "Approval Status"::Open);
                if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
            end;
        }
        field(50038; "Shortcut Dimension 3 Code"; Code[100])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin
                LookupShortcutDimCode(3, "Shortcut Dimension 3 Code");
                Validate("Shortcut Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(50039; "Shortcut Dimension 4 Code"; Code[100])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin
                LookupShortcutDimCode(4, "Shortcut Dimension 4 Code");
                Validate("Shortcut Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(50040; "Dim3"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Dim3';
        }
        field(50041; "Dim4"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Dim4';
        }
        field(50042; "Bank Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Name';
        }
        field(50043; "Receipt Type"; Option)
        {
            OptionCaption = 'Bank,Cash';
            OptionMembers = "Bank","Cash";
            DataClassification = CustomerContent;
            Caption = 'Receipt Type';
        }
        field(50044; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50045; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
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
            else
            if ("Account Type" = const(Saving)) "Account Banking" where(Status = const(Active))
            else
            if ("Account Type" = const(Credit)) "Account Credit" where(Status = const(Active))
            else
            if ("Account Type" = const(Loan)) "Credit Account" where(Status = const(Active));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                BankAccounts.Reset;
                BankAccounts.SetRange("No.", "Account No.");
                if BankAccounts.FindFirst then begin
                    "Bank Name" := BankAccounts.Name;
                end;
            end;
        }

        field(50046; "Receipt Journal Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the receipt journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const("Cash Receipts"));
            Caption = 'Receipt Journal Template';
            Editable = false;
        }
        field(50047; "Receipt Journal Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the receipt journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Receipt Journal Template"));
            Caption = 'Receipt Journal Batch';
            Editable = false;
        
            trigger OnValidate()
            begin
            end;
        }
        field(50048; "Transaction Options"; Enum "OptionsCreditReceipts")
        {
            Caption = 'Transaction Options-Credit Receipts';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                RegMngt: Codeunit "Register Management";
            begin
                RegMngt.InitializeReceiptLines("No.");
            end;
        }
        field(50049; "Accrue Interest"; Boolean)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                RegMngt: Codeunit "Register Management";
            begin
                RegMngt.InitializeReceiptLines("No.");
            end;
        }
        field(50050; "Check Line"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50051; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(50052; "Dim1"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Dim1';
        }
        field(50053; "Dim2"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Dim2';
        }
        field(50054; "Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Code';
        
            trigger OnValidate()
            begin
                if Members.Get("Group Code") then
                    "Group Name" := Members.Name;
            end;
        }
        field(50055; "Group Name"; Text[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Group Name';
        }
        field(50056; "Bank Transction No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Transction No';
        
            trigger OnValidate()
            var

            begin

            end;
        }
        field(50057; "Bank Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Receipt No.';
        }
        field(50058; "Email"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50059; "Member No."; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = Member where(Status = filter(Active | Dormant | New | Defaulter));
            Caption = 'Member No.';
        
            trigger OnValidate()
            Var
                RegMgt: Codeunit "Register Management";
                Cust: Record Member;
                Temp: Record "User Setup";
                ObjectEmp: Record Employee;
                BnkMngt: Codeunit "Banking Procedure Mngt.";
            begin
                case "Allow Multiple Receipts" of
                    "Allow Multiple Receipts"::No:
                        begin
                            if "Application Type" = "Application Type"::Member then begin
                                TestField("Amount Recieved");
                                if Cust.Get("Member No.") then
                                    "Received From" := Cust.Name;
                                "On Behalf Of" := Cust.Name;

                                Temp.Get(UserId);
                                Temp.TestField("Member No.");
                                if Temp."Member No." = "Member No." then
                                    Error('You cannot transact in your own account');
                                BnkMngt.CreateFinanceReceiptLine(Rec, 0, "Transaction Options");
                            end
                        end;
                end;
            end;
        }
        field(50060; "From Prepayment"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'From Prepayment';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50061; "Reversed"; Boolean)
        {
            Editable = false;
            Enabled = false;
            FieldClass = Normal;
            DataClassification = CustomerContent;
            Caption = 'Reversed';
        }
        field(50062; "ExchangeRate"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Exchange Rate';
        }
        field(50063; "Application Type"; Option)
        {
            OptionMembers = " ","Agency","Member";
            DataClassification = CustomerContent;
            Caption = 'Receipt Type';
        }
        field(50064; "Copy Receipt No."; Code[50])
        {
            Caption = 'Copy Receipt No.';
            DataClassification = CustomerContent;
            TableRelation = "Receipts Header"."No." where("Member No." = field("Member No."), Posted = const(true));
        
            trigger OnValidate()
            var
                ReceiptHeader: Record "Receipts Header";
                ReceiptLine, ReceiptLineCopy : Record "Receipt Line";
                ConfirmReceiptCopyMsg: Label 'Are you sure you want to Copy Receipt lines for Receipt No. %1';
            begin
                ReceiptLine.SetRange(No, "No.");
                ReceiptLine.DeleteAll();

                if ("Copy Receipt") and (Confirm(ConfirmReceiptCopyMsg, false, "Copy Receipt No.")) then begin
                    if ReceiptHeader.Get("Copy Receipt No.") then begin
                        ReceiptLine.Reset();
                        ReceiptLine.SetRange(No, ReceiptHeader."No.");
                        if ReceiptLine.FindSet() then begin
                            repeat
                                ReceiptLineCopy.Init();
                                ReceiptLineCopy.TransferFields(ReceiptLine);

                                ReceiptLineCopy.No := "No.";
                                ReceiptLineCopy.Posted := false;
                                ReceiptLine."Date Posted" := Today;
                                ReceiptLineCopy.Insert();
                            until ReceiptLine.Next() = 0;
                        end;
                    end;
                end;
            end;
        }
        field(50065; "Copy Receipt"; Boolean)
        {
            Caption = 'Copy Receipt';
            DataClassification = CustomerContent;
        }
        field(50066; "Bulk Receipt"; Boolean)
        {
            Caption = 'Bulk Receipt';
            DataClassification = CustomerContent;
        }
        field(50067; "Allow Multiple Receipts"; Option)
        {
            Caption = 'Allow Multiple Receipts';
            OptionMembers = "No","Yes";
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
        key("Key2"; "Bank Transction No", "Member No.", "Allow Multiple Receipts")
        {

        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Member No.", "Received From", "Total Amount")
        {
        }
    }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get;
            TestNoSeries;

            "No. Series" := GenLedgerSetup."Receipt Nos";
            if NoSeriesMgt.AreRelated(GenLedgerSetup."Receipt Nos", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")

        end;

        UserTemplate.Get(UserId);
        UserTemplate.TestField("Receipt Journal Template");
        UserTemplate.TestField("Receipt Journal Batch");
        Cashier := UserId;
        "Created By" := UserId;
        "Document Date" := Today;
        Date := Today;
        "Created Date Time" := CreateDateTime(Today, Time);
        "Receipt Journal Template" := UserTemplate."Receipt Journal Template";
        "Receipt Journal Batch" := UserTemplate."Receipt Journal Batch";

        Usersetup.Get(UserId);
        Usersetup.TestField("Global Dimension 1 Code");
        Usersetup.TestField("Global Dimension 2 Code");
        Usersetup.TestField("Responsibility Centre");
        "Global Dimension 1 Code" := Usersetup."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Usersetup."Global Dimension 2 Code";
        "Responsibility Center" := Usersetup."Responsibility Centre";
    end;

    local procedure TestNoSeriesMgt()
    var
        RecRefHeader: Record "Receipts Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                 GenLedgerSetup.Get();
                NoSeriesMgt.TestManual(GenLedgerSetup."Receipt Nos");
                "No. Series" := '';
            end;
    end;

[IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Receipts Header"; xRecRef: Record "Receipts Header"; var IsHandled: Boolean)
    begin
    end;





    trigger OnModify()
    begin
        RLine.Reset;
        RLine.SetRange(RLine.No, "No.");
        if RLine.FindFirst then begin
            repeat
                RLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                RLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                RLine."Dimension Set ID" := "Dimension Set ID";
                RLine.Modify;
            until RLine.Next = 0;
        end;
    end;




    var
        GenLedgerSetup: Record "Cash Management Setups";
        NoSeriesMgt: Codeunit "No. Series";
        UserTemplate: Record "Cash Office User Template";
        RLine: Record "Receipt Line";
        RespCenter: Record "Responsibility Center BR";
        UserMgt: Codeunit "User Setup Management BR";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        DimVal: Record "Dimension Value";
        bank: Record "Bank Account";
        DimMgt: Codeunit DimensionManagement;
        Members: Record Member;
        Usersetup: Record "User Setup";
        BankAccounts: Record "Bank Account";

        Currency: Record Currency;

        CurrencyExchangerates: Record "Currency Exchange Rate";

    procedure PayLinesExist(): Boolean
    begin
        RLine.Reset;
        RLine.SetRange(RLine.No, "No.");
        exit(RLine.FindFirst);
    end;

    local procedure TestNoSeries(): Boolean
    begin
        if "Receipt Type" = "Receipt Type"::Bank then
            GenLedgerSetup.TestField(GenLedgerSetup."Receipt Nos")
        else
            GenLedgerSetup.TestField(GenLedgerSetup."Receipt Nos")
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Receipt', "No."));

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

    procedure CheckMinRequiredItem()
    begin

        CalcFields("Total Amount");
        TestField("Total Amount", "Amount Recieved");
        TestField(Posted, false);
        TestField(Date);
        TestField("Account No.");
        TestField("Global Dimension 1 Code");
        TestField("Shortcut Dimension 2 Code");
        TestField("Received From");
        TestField("Receipt Journal Template");
        TestField("Receipt Journal Batch");
    end;
}




