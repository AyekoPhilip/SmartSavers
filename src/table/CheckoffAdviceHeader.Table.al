table 50458 "Checkoff Advice Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Employer Code"; Code[20])
        {
            TableRelation = Customer;
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Emp.Get("Employer Code") then begin
                    "Employer Name" := Emp.Name;
                end;
            end;
        }
        field(50011; "Employer Name"; Text[50])
        {
            Caption = 'Employer Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Period := Format("Start Date", 0, Text000);
                Validate(Period);
            end;
        }
        field(50013; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //"End Date":=CALCDATE('CM',"Start Date");
            end;
        }
        field(50014; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50015; "Captured By"; Code[50])
        {
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50016; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50017; "Period"; Code[20])
        {
            Caption = 'Period';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Period := Period + ' ' + Format(Date2DMY("Start Date", 3));
                Validate("End Date");
            end;
        }
        field(50018; "Processed"; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(50019; "Loan Issue Cut OFF Date"; Date)
        {
            Caption = 'Loan Issue Cut OFF Date';
            DataClassification = CustomerContent;
        }
        field(50020; "Loan Interest Cut OFF Date"; Date)
        {
            Caption = 'Loan Interest Cut OFF Date';
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

    trigger OnDelete()
    begin
        if Processed = true then
            Error(Txt0001)
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Advice No.");
            "No. Series" := NoSetup."Advice No.";
            if NoSeriesMgt.AreRelated(NoSetup."Advice No.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")

        end;

        "Date Entered" := Today;
        "Captured By" := UserId;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Checkoff Advice Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                NoSetup.Get();
                NoSeriesMgt.TestManual(NoSetup."Advice No.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Checkoff Advice Header"; xRecRef: Record "Checkoff Advice Header"; var IsHandled: Boolean)
    begin
    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Text000: Label '<Month Text>';
        Emp: Record Customer;
        Txt0001: Label 'You cannot delete processed buffer';
}




