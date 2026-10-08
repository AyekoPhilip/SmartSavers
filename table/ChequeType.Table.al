table 50416 "Cheque Type"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Clearing Days"; DateFormula)
        {
            Caption = 'Clearing Days';
            DataClassification = CustomerContent;
        }
        field(50012; "Clearing Charge Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header";
            Caption = 'Clearing Charge Code';
            DataClassification = CustomerContent;
        }
        field(50013; "Type"; Option)
        {
            OptionCaption = 'Local,Inhouse,Upcountry';
            OptionMembers = "Local","Inhouse","Upcountry";
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50014; "Clearing Charges GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Clearing Charges GL Account';
            DataClassification = CustomerContent;
        }
        field(50015; "Clearing  Days"; Integer)
        {
            Caption = 'Clearing  Days';
            DataClassification = CustomerContent;
        }
        field(50016; "Cheque Limit"; Decimal)
        {
            Caption = 'Cheque Limit';
            DataClassification = CustomerContent;
        }
        field(50017; "Cheque Period"; DateFormula)
        {
            Caption = 'Uncashed Cheque Period';
            DataClassification = CustomerContent;
        }
        field(50018; "Cheque Time"; Time)
        {
            Caption = 'Cheque Post Time';
            DataClassification = CustomerContent;
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




