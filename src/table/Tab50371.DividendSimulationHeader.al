table 50371 "Dividend Simulation Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[10])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();

            end;
        }
        field(50010; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if xRec."Start Date" <> 0D then
                    if Confirm(ConfirmChange, false) then
                        ClearDividendLines("No.")
                    else
                        Error(ExitProcessErr);
            end;
        }
        field(50011; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if xRec."End Date" <> 0D then
                    if Confirm(ConfirmChange, false) then
                        ClearDividendLines("No.")
                    else
                        Error(ExitProcessErr);
            end;
        }
        field(50012; "Deposits"; Decimal)
        {
            CalcFormula = Sum("Dividend Simulation Lines".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Deposits';
        }
        field(50013; "Weighted Amount"; Decimal)
        {
            CalcFormula = Sum("Dividend Simulation Lines"."Weighted Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Weighted Amount';
        }
        field(50014; "Total Payout"; Decimal)
        {
            Editable = false;
            Caption = 'Total Payout';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50015; "Rate"; Decimal)
        {
            Caption = 'Rate';
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin

            end;

            trigger OnValidate()
            begin
                CalcFields(Deposits, "Weighted Amount");
                if (Deposits <> 0) and ("Weighted Amount" <> 0) and (Rate <> 0) then
                    "Total Payout" := (Rate * "Weighted Amount") / 100;
            end;
        }
        field(50016; "Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50017; "Product Type"; Code[10])
        {
            TableRelation = "Product Factory" where("Product Class" = const(Account), "Earns Interest" = filter(true));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ProductFactory: Record "Product Factory";
                CustomerPostingGroup: Record "Customer Posting Group";
            begin
                if ProductFactory.Get("Product Type") then begin
                    "Product Name" := ProductFactory.Description;
                    if CustomerPostingGroup.Get(ProductFactory."Posting Group") then
                        "G/L Account" := CustomerPostingGroup."Receivables Account";
                end;
            end;
        }
        field(50018; "Product Name"; Text[80])
        {
            Editable = false;
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50019; "G/L Account"; Code[20])
        {
            Editable = false;
            TableRelation = "G/L Account";
            Caption = 'G/L Account';
            DataClassification = CustomerContent;
        }
        field(50020; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50021; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50022; "Operation Type"; Option)
        {
            OptionMembers = " ","All Products","Individual Product";
            OptionCaption = ' ,All Products,Individual Product';
        }
        field(50023; "Deduct Dividend Loan"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50024; "Deduct Non-Performing Loans"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50025; "Post Capitalization"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50026; "Deduct QC Recovery"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Recover Mobile Loan';
        }
        field(50027; "Posting Type"; Option)
        {
            OptionMembers = "All","Subsiquent Posting";
            DataClassification = CustomerContent;
        }
        field(50028; "Post Deposit Capitalization"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Deposit Capitalization';
        }
        field(50029; "Document Type"; Option)
        {
            OptionMembers = " ","Prorate Monthly","Prorate Daily";
            DataClassification = CustomerContent;
        }
        field(50030; "Deduct Deposit Arrears"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Post Deposit Arrears';
        }
        field(50031; "Posting Options"; Option)
        {
            OptionMembers = " ","Post Application","Generate Batch";
            OptionCaption = ' ,Post Application,Generate Batch';
            DataClassification = CustomerContent;
        }
        field(50032; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
        field(50033; "Ignore Withholding Tax"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ignore W/Tax';

        }
        field(50034; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
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
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Dividend Rate No.");
            "No. Series" := SeriesSetup."Dividend Rate No.";
            if NoSeriesMgt.AreRelated(SeriesSetup."Dividend Rate No.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;

        "Created By" := UserId;
        Dividendsetup.Get();
        Rec."Operation Type" := "Operation Type"::"Individual Product";
        "Document Type" := "Document Type"::"Prorate Monthly";
        if Dividendsetup.Status = Dividendsetup.Status::Ready then begin
            "Start Date" := Dividendsetup."Start Date";
            "End Date" := Dividendsetup."End Date";
        end;
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
                SeriesSetup.Get();
                NoSeriesMgt.TestManual(SeriesSetup."Dividend Rate No.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Dividend Simulation Header"; xRecRef: Record "Dividend Simulation Header"; var IsHandled: Boolean)
    begin
    end;

    var
        ExitProcessErr: Label 'You have selected to abort process date Change will be rolled back';
        ConfirmChange: Label 'The Change you want to will  affect any processed data do you wish to continue?';
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Dividendsetup: Record "Dividend SetUp";

    local procedure ClearDividendLines(No: Code[20])
    var
        DividendSimulationLines: Record "Standing Order Header";
    begin
        DividendSimulationLines.Reset;
        DividendSimulationLines.SetRange(DividendSimulationLines."No.", No);
        if DividendSimulationLines.Find('-') then
            DividendSimulationLines.DeleteAll;
    end;
}




