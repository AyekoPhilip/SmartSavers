table 50343 "Account Kins"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Account No."; Code[100])
        {
            Editable = false;
            TableRelation = "Account Banking"."No.";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Signature"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50013; "Picture"; Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(50014; "Relationship"; Text[50])
        {
            TableRelation = "Relationship Types";
            Caption = 'Relationship';
            DataClassification = CustomerContent;
        }
        field(50015; "Replaced"; Boolean)
        {
            Editable = false;
            Caption = 'Substituted';
            DataClassification = CustomerContent;
        }
        field(50016; "Member No."; Code[100])
        {
            Editable = false;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Account No.", "ID No.", "Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    procedure CopyFromAccountKinDetail(Application: Record "Account Kins-Applications")
    begin
        "ID No." := Application."ID No.";
        Signature := Application.Signature;
        Picture := Application.Picture;
        Relationship := Application.Relationship;
    end;
}




