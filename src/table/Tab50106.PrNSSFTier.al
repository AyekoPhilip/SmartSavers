table 50106 "Pr NSSF Tier"
{
    Caption = 'Pr NSSF Tier';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Tier"; Integer)
        {
            Caption = 'Tier';
            DataClassification = CustomerContent;
        }
        field(50010; "Earnings"; Decimal)
        {
            Caption = 'Earnings';
            DataClassification = CustomerContent;
        }
        field(50011; "Pensionable Earnings"; Decimal)
        {
            Caption = 'Pensionable Earnings';
            DataClassification = CustomerContent;
        }
        field(50012; "Tier 1 Employee Deduction"; Decimal)
        {
            Caption = 'Tier 1 Employee Deduction';
            DataClassification = CustomerContent;
        }
        field(50013; "Tier 1 Employer Deduction"; Decimal)
        {
            Caption = 'Tier 1 Employer Deduction';
            DataClassification = CustomerContent;
        }
        field(50014; "Tier 2 Earnings"; Decimal)
        {
            Caption = 'Tier 2 Earnings';
            DataClassification = CustomerContent;
        }
        field(50015; "Tier 2 Employee Deduction"; Decimal)
        {
            Caption = 'Tier 2 Employee Deduction';
            DataClassification = CustomerContent;
        }
        field(50016; "Tier 2 Employer Deduction"; Decimal)
        {
            Caption = 'Tier 2 Employer Deduction';
            DataClassification = CustomerContent;
        }
        field(50017; "Upper Limit"; Decimal)
        {
            Caption = 'Upper Limit';
            DataClassification = CustomerContent;
        }
        field(50018; "Lower Limit"; Decimal)
        {
            Caption = 'Lower Limit';
            DataClassification = CustomerContent;
        }
        field(50019; "Tier 1 Earnings"; Decimal)
        {
            Caption = 'Tier 2 Earnings';
            DataClassification = CustomerContent;
        }

        field(50020; "NSSF Percentage"; Decimal)
        {
            Caption = 'NSSF Percentage';
            DataClassification = CustomerContent;
        }



    }
    keys
    {
        key("PK"; "Tier")
        {
            Clustered = true;
        }
    }
}
