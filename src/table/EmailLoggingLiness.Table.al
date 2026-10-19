table 50243 "Email Logging Liness"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'No';
        }
        field(50010; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No';
        }
        field(50011; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50012; "Sent"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sent';
        }
        field(50013; "Error Message"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Error Message';
        }
        field(50014; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ',Payroll Shedules';
            OptionMembers = "","Payroll Shedules";
            Caption = 'Type';
        }
        field(50015; "Period"; Date)
        {
            DataClassification = CustomerContent;
            TableRelation = "Accounting Period";
            Caption = 'Period';
        }
        field(50016; "Client Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Client Code';
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


