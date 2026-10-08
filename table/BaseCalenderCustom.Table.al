table 50109 "Base Calender Custom"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(50010; "Name"; Text[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Customized Changes Exist"; Boolean)
        {
            CalcFormula = exist("Customized Calendar Change" where("Base Calendar Code" = field(Code)));
            Caption = 'Customized Changes Exist';
            Editable = false;
            FieldClass = FlowField;
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
    }
}


