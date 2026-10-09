table 50572 "QC Qualifying Amount"
{
    Caption = 'QC Qualifying Amount';
    DataClassification = CustomerContent;
    LookupPageId="QC Qualifying Amount";
    DrillDownPageId="QC Qualifying Amount";
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
            TableRelation = "Product Factory" where("Product Class"=const(Loan),Status=filter(Active));
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
        field(50020; "Has Exiting Loan"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
          field(13; "Qualifying Direction"; Enum QCQualificationDirection)
        {
            Caption = 'Qualifying Direction';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "No.", "Product Type")
        {
            Clustered = true;
        }
    }

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



