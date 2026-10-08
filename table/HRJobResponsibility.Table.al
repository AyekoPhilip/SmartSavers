using Microsoft.Inventory.Location;
table 50061 "HR Job Responsibility"
{
    Caption = 'Job Responsibility';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Job ID"; Code[10])
        {
            Caption = 'Job ID';
        }
        field(50010; "Responsibility Description"; Text[100])
        {
            Caption = 'Responsibility Description';
        }
        field(50011; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
        }
        field(50012; "Responsibility Centre"; Code[10])
        {
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center";
        }
    }
    keys
    {
        key("PK"; "Job ID")
        {
            Clustered = true;
        }
    }
}
