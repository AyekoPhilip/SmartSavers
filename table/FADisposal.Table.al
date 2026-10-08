table 50048 "FA Disposal"
{
    Caption = 'FA Disposal';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50010; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50011; "Date-Time Created"; DateTime)
        {
            Caption = 'Date-Time Created';
            DataClassification = CustomerContent;
        }
        field(50012; "No. Series"; Code[50])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50013; "Status"; Enum "Approval Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50014; "Comments"; Text[250])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
        field(50015; "Staff No."; Code[50])
        {
            Caption = 'Staff No.';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        
            trigger OnValidate()
            begin
                if Emp.Get("Staff No.") then
                    "Staff Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
            end;
        }
        field(50016; "Staff Name"; Text[100])
        {
            Caption = 'Staff Name';
            DataClassification = CustomerContent;
        }
        field(50017; "Fullfilled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Fullfilled';
        }
    }

    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Comments)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            CashMgt.Get();
            CashMgt.TestField("FA Disposal Nos");

        end;

        if UserSetup.Get(UserId) then begin
            UserSetup.TestField("Employee No.");
            "Staff No." := UserSetup."Employee No.";
            if Emp.Get("Staff No.") then
                "Staff Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
        end else
            Error('Please set up user in User Setup');

        "Date-Time Created" := CurrentDateTime;
        "Created By" := UserId;
    end;

    var
        CashMgt: Record "Cash Management Setups";
        Emp: Record Employee;
        UserSetup: Record "User Setup";
        NoSeriesMgt: Codeunit "No. Series";
}


