table 50080 "Pr Salary Grade"
{
    Caption = 'Pr Salary Grade';
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(50009; "Salary Grade"; Code[20])
        {
            Caption = 'Salary Grade';
        }
        field(50010; "Salary Amount"; Decimal)
        {
            Caption = 'Salary Amount';
        }
        field(50011; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(50012; "Pays NHIF"; Boolean)
        {
            Caption = 'Pays NHIF';
        }
        field(50013; "Pays NSSF"; Boolean)
        {
            Caption = 'Pays NSSF';
        }
        field(50014; "Minimum Amount"; Decimal)
        {
            Caption = 'Minimum Amount';
        }
        field(50015; "Maximum Amount"; Decimal)
        {
            Caption = 'Maximum Amount';
            DataClassification = OrganizationIdentifiableInformation;
        
            trigger OnValidate()
            begin
                if "Maximum Amount" < "Minimum Amount" then
                    Error('Maximum amount cannot be less than the minimum amount')
            end;
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
