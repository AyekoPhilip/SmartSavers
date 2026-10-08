tableextension 50020 "BankAccReconTableExt" extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(50009; "Approval Status"; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = "Open","Pending Approval","Approved","Rejected";
            DataClassification = CustomerContent;
        }
        field(50010; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }
}


