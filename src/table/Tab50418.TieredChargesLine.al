table 50418 "Tiered Charges Line"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52140600;
    LookupPageID = 52140600; */

    fields
    {
        field(50009; "Code"; Code[20])
        {
            NotBlank = true;
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Lower Limit"; Decimal)
        {
            Caption = 'Lower Limit';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Lower Limit" < 0 then
                    Error('Lower Limit cannot be less than Zero');

                if "Upper Limit" <> 0 then begin
                    if "Lower Limit" > "Upper Limit" then
                        Error('Lower limit cannot be greater than the upper limit');
                end;
            end;
        }
        field(50011; "Upper Limit"; Decimal)
        {
            Caption = 'Upper Limit';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Upper Limit" < 0 then
                    Error('Upper Limit cannot be less than Zero');
                if "Lower Limit" <> 0 then begin
                    if "Upper Limit" < "Lower Limit" then
                        Error('Upper limit cannot be less than the lower limit amount');
                end;
            end;
        }
        field(50012; "Charge Amount"; Decimal)
        {
            Caption = 'Charge Amount';
            DataClassification = CustomerContent;
        }
        field(50013; "Use Percentage"; Boolean)
        {
            Caption = 'Use Percentage';
            DataClassification = CustomerContent;
        }
        field(50014; "Percentage"; Decimal)
        {
            Caption = 'Percentage';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code", "Lower Limit")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




