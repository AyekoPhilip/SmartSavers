table 50308 "Associated Account"
{
    Caption = 'Associated Account';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "Product Type"; Code[100])
        {
            Caption = 'Product Type';
            DataClassification = ToBeClassified;
        }
        field(50012; "Entry No."; Integer)
        {
            Caption = 'Enttry No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
}



