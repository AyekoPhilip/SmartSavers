table 50599 "QC. Grad. Qualification"
{
    Caption = 'QC. Grad. Qualification';
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "Name"; Text[150])
        {
            Caption = 'Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50012; "Phone No."; Code[20])
        {
            Caption = 'Phone No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50013; "Qualifying Amount"; Decimal)
        {
            Caption = 'Qualifying Amount';
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Last Qualifying Amount" := xRec."Qualifying Amount";
            end;
        }
        field(50014; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50015; "Old Account No."; Code[100])
        {
            Caption = 'Old Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50016; "Product Type"; Code[10])
        {
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "Product Factory" where("Product Class" = const(Loan), Status = filter(Active));
        }
        field(50017; "Loan Status"; Enum "MemberStatus")
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(50018; "Mobile Status"; Enum "MemberStatus")
        {
            Caption = 'Mobile Loan';
            DataClassification = CustomerContent;
        }
        field(50019; "Last Qualifying Amount"; Decimal)
        {
            Caption = 'Last Qualifying Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50020; "Qualifying Direction"; Enum "QCQualificationDirection")
        {
            Caption = 'Qualifying Direction';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50021; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(50022; "Loan No."; Code[100])
        {
            Caption = 'Loan No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50023; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50024; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50025; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            Editable = false;
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Entry No.", "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Date Posted" := Today;
        "Time Posted" := Time;
        "Posted By" := UserId;
    end;

    procedure CopyFromCustDetail(CustMember: Record Member)
    begin
        "No." := CustMember."No.";
        Name := CustMember.Name;
        "Phone No." := CustMember."Mobile Phone No";
        Status := CustMember.Status;
        "Old Account No." := CustMember."Old Member No.";
        "Loan Status" := CustMember."Loan Status";
        "Mobile Status" := CustMember."Mobile Status";
    end;
}
