table 50242 "Email Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'No';
        }
        field(50010; "Description"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(50012; "Created By"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(50013; "Last Modified By"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Modified By';
        }
        field(50014; "Total Items"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Items';
        }
        field(50015; "Total Sent"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Sent';
        }
        field(50016; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Pending,Complete';
            OptionMembers = "Pending","Complete";
            Caption = 'Status';
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
}


