table 50429 "Cheques Register"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Cheque No."; Code[10])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Status"; Option)
        {
            OptionCaption = 'Pending,Approved,Cancelled,stopped,Dishonoured';
            OptionMembers = "Pending","Approved","Cancelled","stopped","Dishonoured";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50012; "Approval Date"; Date)
        {
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Application No."; Code[10])
        {
            Caption = 'Application No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Cancelled/Stopped By"; Code[50])
        {
            Caption = 'Cancelled/Stopped By';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Cheque No.", "Account No.", "Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




