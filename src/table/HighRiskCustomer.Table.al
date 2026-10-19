table 50585 "High Risk Customer"
{
    Caption = 'High Risk Customer';
    DataClassification = CustomerContent;
    LookupPageId="Credit Reference";
    DrillDownPageId="Credit Reference";

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Phone No."; Code[20])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50014; "Position"; Text[150])
        {
            Caption = 'Position';
            DataClassification = CustomerContent;
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
