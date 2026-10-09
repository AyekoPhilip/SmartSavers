table 50342 "Account Kins-Applications"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Account No."; Code[100])
        {
            Editable = false;
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
        field(50015; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50016; "ID Specimen"; Media)
        {
            Caption = 'ID/Passport Specimen';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Account No.", "Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Deactivate.Reset;
        Deactivate.SetRange(Deactivate."ID No.", "ID No.");
        if Deactivate.Find('-') then
            Deactivate.Replaced := true;
        Deactivate.Modify;
    end;

    var
        Deactivate: Record "Account Kins";
}




