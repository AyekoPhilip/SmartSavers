tableextension 50052 "GenLedgerSetupExt" extends "General Ledger Setup"
{
    fields
    {
        field(50009; "Current Budget"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
            DataClassification = CustomerContent;
        }
        field(50010; "Current Budget Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50011; "Current Budget End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Use Dimensions For Budget"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50013; "Budget Approval Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50014; "Proposed Budget Approval Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}


