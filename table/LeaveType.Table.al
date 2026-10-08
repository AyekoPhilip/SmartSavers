table 50093 "Leave Type"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Code';
        }
        field(50010; "Description"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Days';
        }
        field(50012; "Accrue Days"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrue Days';
        }
        field(50013; "Unlimited Days"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unlimited Days';
        }
        field(50014; "Gender"; Enum "CustGender")
        {
            DataClassification = CustomerContent;
            Caption = 'Gender';
        }
        field(50015; "Balance"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Ignore,Carry Forward,Convert to Cash';
            OptionMembers = "Ignore","Carry Forward","Convert to Cash";
            Caption = 'Balance';
        }
        field(50016; "Inclusive of Holidays"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Inclusive of Holidays';
        }
        field(50017; "Inclusive of Saturday"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Inclusive of Saturday';
        }
        field(50018; "Inclusive of Sunday"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Inclusive of Sunday';
        }
        field(50019; "Off/Holidays Days Leave"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Off/Holidays Days Leave';
        }
        field(50020; "Max Carry Forward Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Carry Forward Days';
        
            trigger OnValidate()
            begin
                if Balance <> Balance::"Carry Forward" then
                    "Max Carry Forward Days" := 0;
            end;
        }
        field(50021; "Conversion Rate Per Day"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Conversion Rate Per Day';
        }
        field(50022; "Annual Leave"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Annual Leave';
        }
        field(50023; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Active,Inactive';
            OptionMembers = "Active","Inactive";
            Caption = 'Status';
        }
    
        field(50024; "Inclusive of Non Working Days"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Inclusive of Non Working Days';
        }
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {
        }
    }
}


