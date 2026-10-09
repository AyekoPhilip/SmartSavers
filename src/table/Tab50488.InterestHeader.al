table 50488 "Interest Header"
{
    DrillDownPageID = "Interest Header List";
    LookupPageID = "Interest Header List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[30])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Posting Date" > Today then
                    Error('Posting Date must not be greater than today');
            end;
        }
        field(50011; "Document No."; Code[30])
        {
            Editable = true;
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Distributed Amount"; Decimal)
        {
            CalcFormula = Sum("Interest Line".Amount WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Distributed Amount';
        }
        field(50013; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50014; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50015; "Cashier ID"; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Cashier ID';
            DataClassification = CustomerContent;
        }
        field(50016; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50017; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50018; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50019; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50020; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50021; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50022; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50023; "Employer Code"; Code[20])
        {
            TableRelation = Customer;
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50024; "loan Issued Date"; Date)
        {
            Caption = 'loan Issued Date';
            DataClassification = CustomerContent;
        }
        field(50025; "Bill Loan"; Boolean)
        {
            InitValue = true;
            Caption = 'Bill Loan';
            DataClassification = CustomerContent;
        }
        field(50026; "Charge Interest"; Boolean)
        {
            InitValue = true;
            Caption = 'Charge Interest';
            DataClassification = CustomerContent;
        }
        field(50027; "Interest Due Date"; Date)
        {
            Caption = 'Interest Due Date';
            TableRelation = "Interest Due Period" WHERE(Closed = FILTER(false));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Description := 'Int Due' + ' ' + CopyStr(Format("Interest Due Date", 0, '<Month Text>'), 1, 3) + ' ' + Format(Date2DMY("Interest Due Date", 3));
                "Document No." := 'IntDue' + '-' + CopyStr(Format("Interest Due Date", 0, '<Month Text>'), 1, 3) + ' ' + Format(Date2DMY("Interest Due Date", 3));
            end;
        }
        field(50028; "Charge Penalty"; Boolean)
        {
            Caption = 'Charge Penalty';
            DataClassification = CustomerContent;
        }
        field(50029; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(50030; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50031; "Application Type"; Enum "CreditBillingType")
        {
            Caption = 'Application Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50032; "Loan Count"; Integer)
        {
            CalcFormula = Count("Interest Line" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Loan Count';
        }
        field(50033; "Interest Total"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Interest Total';
        }
        field(50034; "Posted Loans"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Loans';
        }
        field(50035; "Reversed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Reversed';
        }
        field(50036; "Interest Frequency"; Enum "RepaymentFrequency")
        {
            DataClassification = CustomerContent;
            Caption = 'Interest Frequency';
        }
        field(50037; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50038; "Application Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Application Date';
        }

    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
        key("Key2"; "Document No.")
        {

        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get();

            case "Application Type" of
                "Application Type"::"Benevolent Recovery":
                    begin
                        NoSetup.TestField(NoSetup."BBF Claims");
                        "No. Series" := NoSetup."BBF Claims";
                        if NoSeriesMgt.AreRelated(NoSetup."Billing Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")

                    end;
                "Application Type"::" ",
            "Application Type"::Penalty,
            "Application Type"::Commisions,
            "Application Type"::Insurance,
            "Application Type"::"Transfer Interest(Banking)",
            "Application Type"::"Transfer Interest(G/L)",
            "Application Type"::"Loan Interest":
                    begin
                        NoSetup.TestField(NoSetup."Billing Nos.");
                        "No. Series" := NoSetup."Billing Nos.";
                        if NoSeriesMgt.AreRelated(NoSetup."Billing Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")
                    end;
            end;

        end;

        "Cashier ID" := UserId;
        "Document No." := "No.";
        "Application Date" := Today;

        UserSetup.Get(UserId);
        UserSetup.TestField("Responsibility Centre");
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        Validate("Responsibility Center", UserSetup."Responsibility Centre");
        Validate("Shortcut Dimension 1 Code", UserSetup."Global Dimension 1 Code");
        Validate("Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");

        Gensetup.Get();
        if Gensetup."Billing Type" = Gensetup."Billing Type"::" " then
            Error('Kindly Specify Interest Billing Type on General setup');

        case Gensetup."Interest Posting Method" of
            Gensetup."Interest Posting Method"::"Charge Daily":
                "Interest Frequency" := "Interest Frequency"::Daily;
            Gensetup."Interest Posting Method"::"Accrual Basis":
                "Interest Frequency" := "Interest Frequency"::Monthly;
            else
                Error('Interest Frequency not defined in General Setup', Gensetup.FieldCaption("Interest Posting Method"));
        end;

        "Application Type" := Gensetup."Billing Type";

        PrIntPeriods.SetRange(Closed, false);
        if PrIntPeriods.FindFirst() then begin
            if PrIntPeriods."Date Opened" <= Today then begin
                "Start Date" := PrIntPeriods."Date Opened";
                "End Date" := PrIntPeriods."Date Closed";
                "Posting Date" := PrIntPeriods."Date Closed";
                Description := Format("Application Type") + ' / ' + Format(PrIntPeriods."Date Opened", 0, '<Month Text>') + ' / ' + Format(Date2DMY(PrIntPeriods."Date Opened", 3));
            end else begin
                Error(ErrorPostDate, PrIntPeriods."Date Opened", Today);
            end;
        end else begin
            Error(ErrorOnNoInterestPeriod);
        end;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Interest Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                NoSetup.Get();
                case "Application Type" of
                    "Application Type"::"Benevolent Recovery":
                        NoSeriesMgt.TestManual(NoSetup."BBF Claims") else
                                                                         NoSeriesMgt.TestManual(NoSetup."Billing Nos.");
                end;

                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Interest Header"; xRecRef: Record "Interest Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnBeforeReverseEntriesOnPostInt(var RecRef: Record "Interest Header"; CallingFieldNo: Integer)
    begin

    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";
        Gensetup: Record "General Set-Up";
        NoSetup: Record "Credit Nos. Series";
        PrIntPeriods: Record "Loan Interest Periods";
        ErrorPostDate: Label 'Interest Period of %1 cannot be greater than %2';
        ErrorOnNoInterestPeriod: Label 'No Interest Period found. Create Interest period before you can Create Interest Entries';

    procedure CheckRequirement()
    begin
        TestField("Posting Date");
        TestField("Document No.");
        TestField(Description);
    end;

    procedure fnCheckIfIntPeriodExist(): Boolean
    var
        PrIntPeriods: Record "Loan Interest Periods";
    begin

        PrIntPeriods.Reset();
        PrIntPeriods.SetRange(Closed, false);
        if not PrIntPeriods.Find('-') then begin
            exit(false)
        end else
            exit(true)
    end;
}





