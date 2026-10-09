table 50587 "Member Advice Analysis"
{
    Caption = 'Member Advice Analysis';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Member Advise Analysis";
    LookupPageId = "Member Advise Analysis";

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Name"; Text[250])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Staff/Payroll No."; Code[20])
        {
            Caption = 'Staff/Payroll No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Registration Fee"; Decimal)
        {
            Caption = 'Registration Fee';
            DataClassification = CustomerContent;
        }
        field(50014; "Shares Capital"; Decimal)
        {
            Caption = 'Shares Capital';
            DataClassification = CustomerContent;
        }
        field(50015; "Shares Deposit"; Decimal)
        {
            Caption = 'Shares Deposit';
            DataClassification = CustomerContent;
        }
        field(50016; "School Fee savings"; Decimal)
        {
            Caption = 'School Fee savings';
            DataClassification = CustomerContent;
        }
        field(50017; "Total Loans"; Decimal)
        {
            Caption = 'Total Loans';
            DataClassification = CustomerContent;
        }
        field(50018; "Identity Type"; Enum "AdviseType")
        {
            Caption = 'Identity Type';
            DataClassification = CustomerContent;
        }
        field(50019; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(50020; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50021; "Employer Code"; Code[20])
        {
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50022; "Member Category"; Code[20])
        {
            Caption = 'Member Category';
            DataClassification = CustomerContent;
        }
        field(50023; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50024; "Total Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
    procedure CopyFromCustomerMember(CustRecord: Record Member)
    begin
        "No.":=CustRecord."No.";
        Name := CustRecord.Name;
        "Staff/Payroll No." := CustRecord."Payroll/Staff No.";
        "ID No." := CustRecord."ID No.";
        Status := CustRecord.Status;
    end;
}
