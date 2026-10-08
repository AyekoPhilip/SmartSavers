table 50438 "Account Transfer Header"
{
    DrillDownPageID = "SMS Series";
    LookupPageID = "SMS Series";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();

            end;
        }
        field(50010; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST(Transfers));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50013; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50014; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50015; "Remarks"; Code[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50016; "Status"; Enum "ApprovalStatus")
        {
            Editable = true;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50017; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50018; "Transaction Time"; Time)
        {
            Editable = false;
            Caption = 'Transaction Time';
            DataClassification = CustomerContent;
        }
        field(50019; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(50020; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(50021; "Total Debits"; Decimal)
        {
            CalcFormula = Sum("Account Transfer Source".Amount WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            // DecimalPlaces is unspecified in the supplied symbols.
            Caption = 'Total Debits';
        }
        field(50022; "Total Credits"; Decimal)
        {
            CalcFormula = Sum("Account Transfer Destination".Amount WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Credits';
            // DecimalPlaces is unspecified in the supplied symbols.
        }
        field(50023; "Member No"; Code[20])
        {
            TableRelation = if ("Transfer Type" = filter(Self)) Member where(Status = filter(Active | New | Dormant | Defaulter)) else
            if ("Transfer Type" = filter("Share Transfer" | "Share Transfer(Close Account)")) Member where(Status = filter(Withdrawn)) else
            if ("Transfer Type" = filter("Account Zerolize")) Member where(Status = filter(Deceased | Closed | Withdrawn));
            Caption = 'Member No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50024; "Transfer Type"; Option)
        {
            OptionCaption = 'Self,Other,Share Transfer,Share Transfer(Close Account),Account Zerolize';
            OptionMembers = "Self","Other","Share Transfer","Share Transfer(Close Account)","Account Zerolize";
            Caption = 'Transfer Type';
            DataClassification = CustomerContent;
        }

        field(50025; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50026; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50027; "Non-Member A/c"; Boolean)
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
        key("Key2"; "Member No")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TextFields
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get;
            NoSetup.TestField(NoSetup."Account Transfer Nos");

            "No. Series" := NoSetup."Account Transfer Nos";
            if NoSeriesMgt.AreRelated(NoSetup."Account Transfer Nos", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")

        end;

        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if UserSetup.Find('-') then begin
            UserSetup.TestField(UserSetup."Global Dimension 1 Code");
            UserSetup.TestField(UserSetup."Global Dimension 2 Code");
            UserSetup.TestField(UserSetup."Responsibility Centre");
            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            "Responsibility Center" := UserSetup."Responsibility Centre";
        end;

        "Transaction Date" := Today;
        "Transaction Time" := Time;
        "Created By" := UserId;
    end;

    trigger OnModify()
    begin
        //TextFields
    end;

    trigger OnRename()
    begin

    end;

    var
        NoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";

    local procedure TextFields()
    var
        CurrentFieldErrorTxt: Label 'Cannot modify a posted record';
    begin
        if Posted then
            Error(CurrentFieldErrorTxt);
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Account Transfer Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                NoSetup.Get();
                NoSeriesMgt.TestManual(NoSetup."Account Transfer Nos");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Account Transfer Header"; xRecRef: Record "Account Transfer Header"; var IsHandled: Boolean)
    begin

    end;
}




