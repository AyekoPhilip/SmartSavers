namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
table 50004 "Hr Leave Type"
{
    Caption = 'Leave Type';
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Description"; Text[150])
        {
            Caption = 'Description';
        }
        field(3; "Days"; Decimal)
        {
            Caption = 'Days';
        }
        field(4; "Accrue Days"; Boolean)
        {
            Caption = 'Accrue Days';
        }
        field(5; "Unlimited Days"; Boolean)
        {
            Caption = 'Unlimited Days';
        }
        field(6; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
        }
        field(7; "Balance"; Option)
        {
            Caption = 'Balance';
            OptionMembers = "Ignore","Carry Forward","Convert to Cash";
        }
        field(8; "Inclusive of Holidays"; Boolean)
        {
            Caption = 'Inclusive of Holidays';
        }
        field(9; "Inclusive of Saturday"; Boolean)
        {
            Caption = 'Inclusive of Saturday';
        }
        field(10; "Inclusive of Sunday"; Boolean)
        {
            Caption = 'Inclusive of Sunday';
        }
        field(11; "Off/Holidays Days Leave"; Boolean)
        {
            Caption = 'Off/Holidays Days Leave';
        }
        field(12; "Max Carry Forward Days"; Decimal)
        {
            Caption = 'Max Carry Forward Days';
        }
        field(13; "Inclusive of Non Working Days"; Boolean)
        {
            Caption = 'Inclusive of Non Working Days';
        }
        field(14; "Carry Forward Allowed"; Boolean)
        {
            Caption = 'Carry Forward Allowed';
        }
        field(15; "Fixed Days"; Boolean)
        {
            Caption = 'Fixed Days';
        }
        field(16; "Minimum Months"; DateFormula)
        {
            Caption = 'Minimum Months';
        }
        field(17; "Is Annual Leave"; Boolean)
        {
            Caption = 'Is Annual Leave';
        }
        field(18; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
        }
    }
    keys
    {
        key("PK"; "Code")
        {
            Clustered = true;
        }
    }
}
