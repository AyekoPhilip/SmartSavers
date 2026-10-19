table 50550 "Approval Setup"
{
    Caption = 'Approval Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(50010; "Due Date Formula"; DateFormula)
        {
            Caption = 'Due Date Formula';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                IF COPYSTR(FORMAT("Due Date Formula"), 1, 1) = '-' THEN
                    ERROR(STRSUBSTNO(Text001, FIELDCAPTION("Due Date Formula")));
            end;
        }
        field(50011; "Approval Administrator"; Code[50])
        {
            Caption = 'Approval Administrator';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(50012; "Request Rejection Comment"; Boolean)
        {
            Caption = 'Request Rejection Comment';
            DataClassification = CustomerContent;
        }
        field(50013; "Approvals"; Boolean)
        {
            Caption = 'Approvals';
            DataClassification = CustomerContent;
        }
        field(50014; "Cancellations"; Boolean)
        {
            Caption = 'Cancellations';
            DataClassification = CustomerContent;
        }
        field(50015; "Rejections"; Boolean)
        {
            Caption = 'Rejections';
            DataClassification = CustomerContent;
        }
        field(50016; "Delegations"; Boolean)
        {
            Caption = 'Delegations';
            DataClassification = CustomerContent;
        }
        field(50017; "Last Run Time"; Time)
        {
            Caption = 'Last Run Time';
            DataClassification = CustomerContent;
        }
        field(50018; "Last Run Date"; Date)
        {
            Caption = 'Last Run Date';
            DataClassification = CustomerContent;
        }
        field(50019; "Overdue Template"; Blob)
        {
            Caption = 'Overdue Template';
            DataClassification = CustomerContent;
            Subtype = UserDefined;
        }
        field(50020; "Approval Template"; Blob)
        {
            Caption = 'Approval Template';
            DataClassification = CustomerContent;
            Subtype = UserDefined;
        }
        field(50021; "Responsibility Center Required"; Boolean)
        {
            Caption = 'Responsibility Center Required';
            DataClassification = CustomerContent;
        }
        field(50022; "Set As Product"; Boolean)
        {
            Caption = 'Set As Product';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        Text001: Label 'You cannot have negative values in %1.';
}



