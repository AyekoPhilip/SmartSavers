table 50025 "Interbank Transfer"
{
    Caption = 'Interbank Transfer';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Description = 'Stores the code of the receipt in the database';
            DataClassification = CustomerContent;
            Caption = 'No.';
            Editable = false;
        
            trigger OnValidate()
            begin
                TestNoSeries();
               
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
            TableRelation = "User Setup"."User ID";
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
        field(50016; "Received From"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Received From';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50017; "Remarks"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
        field(50018; "Amount Recieved"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(50019; "Amount Recieved LCY"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount (LCY)';
        }
        field(50020; "Paying Account No."; Code[20])
        {
            Caption = 'Paying Account No.';
            TableRelation = if ("Account Type" = filter("Bank Account")) "Bank Account" where(Blocked = filter(false));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if BankAcc.Get("Paying Account No.") then begin
                    "Bank Name" := BankAcc.Name;
                    "Currency Code" := BankAcc."Currency Code";
                end
            end;
        }
        field(50021; "Paying Account Name"; Text[150])
        {
            Caption = 'Paying Account Name.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50022; "Global Dimension 1 Code"; Code[20])
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
        field(50023; "Shortcut Dimension 2 Code"; Code[20])
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
        field(50024; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50025; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            // DecimalPlaces is unspecified in the supplied symbols.
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(50026; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Receipt Line".Amount WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Amount';
        }
        field(50027; "Posted By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Posted By';
        }
        field(50028; "Print No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Print No.';
        }
        field(50029; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Status';
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

        field(50033; "Document Date"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Document Date';
        }
        field(50034; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50035; "Shortcut Dimension 3 Code"; Code[100])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin

            end;

            trigger OnValidate()
            begin

            end;
        }
        field(50036; "Shortcut Dimension 4 Code"; Code[100])
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
            end;
        }

        field(50037; "Bank Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Receiving Bank Name';
        }
        field(50038; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50039; "Account No."; Code[20])
        {
            Caption = 'Reciving Account No.';
            TableRelation = if ("Account Type" = filter("Bank Account")) "Bank Account" where(Blocked = filter(false));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if BankAcc.Get("Account No.") then begin
                    "Bank Name" := BankAcc.Name;
                    "Currency Code" := BankAcc."Currency Code";
                end
            end;
        }

        field(50040; "Interbank Journal Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the receipt journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            Caption = 'Interbank Journal Template';
            Editable = false;
        }
        field(50041; "Interbank Journal Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the receipt journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Interbank Journal Template"));
            Caption = 'Interbank Journal Batch';
            Editable = false;
        
            trigger OnValidate()
            begin
            end;
        }

        field(50042; "Dimension Set ID"; Integer)
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
         field(50043; "Check Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField("Interbank Nos");
            "No. Series" := GenLedgerSetup."Interbank Nos";
            if NoSeriesMgt.AreRelated(GenLedgerSetup."Interbank Nos" , xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
            
        end;

        UserTemplate.Get(UserId);
        UserTemplate.TestField("Inter Bank Template Name");
        UserTemplate.TestField("Inter Bank Batch Name");
        Cashier := UserId;
        "Created By" := UserId;
        "Document Date" := Today;
        Date := Today;
        "Created Date Time" := CreateDateTime(Today, Time);
        "Interbank Journal Template" := UserTemplate."Inter Bank Template Name";
        "Interbank Journal Batch" := UserTemplate."Inter Bank Batch Name";

        Usersetup.Get(UserId);
        Usersetup.TestField("Global Dimension 1 Code");
        Usersetup.TestField("Global Dimension 2 Code");
        Usersetup.TestField("Responsibility Centre");
        "Global Dimension 1 Code" := Usersetup."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Usersetup."Global Dimension 2 Code";
        "Responsibility Center" := Usersetup."Responsibility Centre";

    end;

    trigger OnDelete()
    begin

    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Dividend Simulation Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                GenLedgerSetup .Get();
                NoSeriesMgt.TestManual(GenLedgerSetup."Interbank Nos");
                "No. Series" := '';
            end;
    end;

[IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Interbank Transfer"; xRecRef: Record "Interbank Transfer"; var IsHandled: Boolean)
    begin
    end;



    var
        GenLedgerSetup: Record "Cash Management Setups";
        NoSeriesMgt: Codeunit "No. Series";
        UserTemplate: Record "Cash Office User Template";
        RLine: Record "Receipt Line";
        RespCenter: Record "Responsibility Center BR";
        BankAcc: Record "Bank Account";
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

    procedure CheckRequiredItem(ValuePost: Integer)
    begin
        case ValuePost of
            0:
                begin
                    TestField("Account No.");
                    TestField("Amount Recieved");
                end;
                1:begin
                    TestField("Account No.");
                    TestField("Amount Recieved");
                    TestField("Approval Status","Approval Status"::Approved);
                end;
        end;

    end;
}
