table 50070 "Tender Amount"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Tender No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tender No.';
        }
        field(50010; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Scope Type"; Option)
        {
            Caption = 'Scope Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Scope Item,Main Heading,Main Heading End,Sub-Heading,Sub-Heading End';
            OptionMembers = "Scope Parameter","Objective Heading","Objective Heading End","Sub-Heading","Sub-Heading End";
        }
        field(50012; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50013; "Indentation"; Integer)
        {
            Caption = 'Indentation';
            DataClassification = CustomerContent;
        }
        field(50014; "Indent"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Indent';
        }
        field(50015; "Amount"; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
    }

    keys
    {
        key("PK"; "Tender No.", "Line No.")
        {
            Clustered = true;
        }
    }
}


