table 50063 "HR Job Training Needs"
{
    Caption = 'Job Training Needs';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(50010; "Job ID"; Code[10])
        {
            Caption = 'Job ID';
        }
        field(50011; "Description"; Text[50])
        {
            Caption = 'Description';
        }
        field(50012; "Training Group"; Code[10])
        {
            Caption = 'Training Group';
        }
        field(50013; "No. of Participants"; Integer)
        {
            Caption = 'No. of Participants';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Code", "Job ID")
        {
            Clustered = true;
        }
    }
}
