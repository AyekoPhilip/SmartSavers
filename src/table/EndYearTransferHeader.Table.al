table 50478 "End Year Transfer Header"
{
    DrillDownPageID = "FD Interest Calculation";
    LookupPageID = "FD Interest Calculation";
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
                
            end;
        }
        field(50010; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Document No."; Code[30])
        {
            Editable = true;
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Distributed Amount"; Decimal)
        {
            CalcFormula = Sum("End Year Interest Buffer"."Interest Amount" WHERE(No = FIELD("No.")));
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
        field(50015; "Cashier"; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Cashier';
            DataClassification = CustomerContent;
        }
        field(50016; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,,Approved,Rejected';
            OptionMembers = "Open","Pending Approval","","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50017; "Posted By"; Code[30])
        {
            Editable = false;
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50018; "Time Posted"; Time)
        {
            Editable = false;
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50019; "Description"; Text[30])
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
        field(50023; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "End Date" := CalcDate('<CY>', "Start Date");
                Validate("End Date");
            end;
        }
        field(50024; "End Date"; Date)
        {
            Editable = false;
            Caption = 'End Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Description := Format("End Date", 0, '<Month Text>') + ' ' + Format(Date2DMY("End Date", 3)) + ' ' + 'Interest Expense';
            end;
        }
    }

    keys
    {
        key("Key1"; "Start Date")
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
            NoSetup.Get();
            NoSetup.TestField(NoSetup."FOSA Interest Nos");
            
        end;

        Cashier := UserId;
        "Document No." := "No.";
        UserSetup.Get(UserId); //THEN
                               // BEGIN
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");

        "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Center" := UserSetup."Responsibility Centre";
        // END;
    end;

    trigger OnModify()
    begin
        if UserSetup.Get(UserId) then begin
            "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            "Responsibility Center" := UserSetup."Responsibility Centre";
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";
        NoSetup: Record "Banking No. Setup";
}




