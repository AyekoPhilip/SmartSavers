table 50273 "Approval Stages"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Workflow User Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Workflow User Group";
            Caption = 'Workflow User Group Code';
        }
        field(50010; "Approval Stage"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Stage';
        }
        field(50011; "Approval Stage Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Stage Name';
        }
        field(50012; "Minimum Approvers"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Approvers';
        }
    }

    keys
    {
        key("Key1"; "Workflow User Group Code", "Approval Stage")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}


