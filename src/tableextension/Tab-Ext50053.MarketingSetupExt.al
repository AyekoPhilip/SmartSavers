tableextension 50053 "MarketingSetupExt" extends "Marketing Setup"
{
    fields
    {
        field(50009; "Enquiries Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Enquiries Nos.';
        }
        field(50010; "Interact"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Interact';
        }
    }
}


