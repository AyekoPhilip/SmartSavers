table 50424 "Salary Header"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52140610;
    LookupPageID = 52140610; */

    fields
    {
        field(50009; "No"; Code[20])
        {
            Editable = false;
            Caption = 'No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50010; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50011; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50012; "Posted By"; Code[50])
        {
            Editable = false;
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50013; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50014; "Entered By"; Text[50])
        {
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50015; "Remarks"; Text[150])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50016; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50017; "Time Entered"; Time)
        {
            Caption = 'Time Entered';
            DataClassification = CustomerContent;
        }
        field(50018; "Posting date"; Date)
        {
            Editable = false;
            Caption = 'Posting date';
            DataClassification = CustomerContent;
        }
        field(50019; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50020; "Account No"; Code[30])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if "Account Type" = "Account Type"::Customer then begin
                    cust.Reset;
                    cust.SetRange(cust."No.", "Account No");
                    if cust.Find('-') then begin
                        "Account Name" := cust.Name;
                    end;
                end;

                if "Account Type" = "Account Type"::"G/L Account" then begin
                    "GL Account".Reset;
                    "GL Account".SetRange("GL Account"."No.", "Account No");
                    if "GL Account".Find('-') then begin
                        "Account Name" := "GL Account".Name;
                    end;
                end;

                if "Account Type" = "Account Type"::"Bank Account" then begin
                    BANKACC.Reset;
                    BANKACC.SetRange(BANKACC."No.", "Account No");
                    if BANKACC.Find('-') then begin
                        "Account Name" := BANKACC.Name;

                    end;
                end;
            end;
        }
        field(50021; "Document No"; Code[20])
        {
            Caption = 'Document No';
            DataClassification = CustomerContent;
        }
        field(50022; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50023; "Scheduled Amount"; Decimal)
        {
            CalcFormula = Sum("Salary Lines".Amount WHERE("Salary Header No." = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Scheduled Amount';
        }
        field(50024; "Total Count"; Integer)
        {
            CalcFormula = Count("Salary Lines" WHERE("Salary Header No." = FIELD(No)));
            FieldClass = FlowField;
            Caption = 'Total Count';
        }
        field(50025; "Account Name"; Text[50])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50026; "Employer Code"; Code[30])
        {
            TableRelation = Customer."No.";
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50027; "Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = "Open","Pending","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50028; "Income Type"; Option)
        {
            OptionCaption = 'Salary,Dividend,Dependant,Pension,Milk,Tea,Coffee';
            OptionMembers = "Salary","Dividend","Dependant","Pension","Milk","Tea","Coffee";
            Caption = 'Income Type';
            DataClassification = CustomerContent;
        }
        field(50029; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Salary Processing"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Document No" := No;
            end;
        }
        field(50030; "Validated"; Boolean)
        {
            Caption = 'Validated';
            DataClassification = CustomerContent;
        }
        field(50031; "Mutiple Salaries Checked"; Boolean)
        {
            Caption = 'Mutiple Salaries Checked';
            DataClassification = CustomerContent;
        }
        field(50032; "Last Loan Issue Date"; Date)
        {
            Caption = 'Last Loan Issue Date';
            DataClassification = CustomerContent;
        }
        field(50033; "Donnot Recover"; Boolean)
        {
            Caption = 'Donnot Recover';
            DataClassification = CustomerContent;
        }
        field(50034; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(50035; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            Enabled = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(50036; "Responsibility Centre"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Salary Nos.");
            
        end;

        "Entered By" := UpperCase(UserId);
        "Date Entered" := Today;
        "Time Entered" := Time;
        "Posting date" := Today;

        if Temp.Get(UserId) then
            Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        Temp.TestField("Responsibility Centre");

        "Shortcut Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Responsibility Centre" := Temp."Responsibility Centre";
    end;

    var
        NoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        "GL Account": Record "G/L Account";
        BANKACC: Record "Bank Account";
        cust: Record Customer;
        Temp: Record "User Setup";
}




