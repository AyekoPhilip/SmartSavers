table 50081 "Pr Salary Notch"
{
    Caption = 'Pr Salary Notch';
    DataClassification = OrganizationIdentifiableInformation;
    
    fields
    {
        field(50009; "Salary Grade"; Code[20])
        {
            Caption = 'Salary Grade';
        }
        field(50010; "Salary Notch"; Code[20])
        {
            Caption = 'Salary Notch';
        }
        field(50011; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(50012; "Salary Amount"; Decimal)
        {
            Caption = 'Salary Amount';
        }
        field(50013; "Hourly Rate"; Decimal)
        {
            Caption = 'Hourly Rate';
        }
        field(50014; "Annual Salary Amount"; Decimal)
        {
            Caption = 'Annual Salary Amount';
            DataClassification = OrganizationIdentifiableInformation;
        }
    }
    keys
    {
        key("PK"; "Salary Grade")
        {
            Clustered = true;
        }
    }
}
