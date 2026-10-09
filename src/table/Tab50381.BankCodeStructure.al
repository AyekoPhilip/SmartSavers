table 50381 "Bank Code Structure"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Bank Code Structure";
    LookupPageId = "Bank Code Structure";

    fields
    {
        field(50009; "Bank Code"; Code[20])
        {
            NotBlank = true;
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Bank Name"; Text[150])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Branch Code"; Code[10])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50012; "Branch"; Text[150])
        {
            Caption = 'Branch Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key("Key1"; "Bank Code", "Branch Code")
        {
            Clustered = true;
        }
        key("key2"; "Entry No.")
        {

        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Bank Code", "Bank Name", "Branch Code", Branch)
        {
        }
    }
}




