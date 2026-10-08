tableextension 50019 "GLBudgetNameTableExt" extends "G/L Budget Name"
{
    fields
    {
        field(50009; "Total Budget Allocation"; Decimal)
        {
            Caption = 'Total Budget Allocation';
        }
        field(50010; "Budget Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = "Open","Pending Approval","Approved","Rejected";
            Caption = 'Budget Status';
        }
        field(50011; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(50012; "Budget Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Budgeting,ReAllocation';
            OptionMembers = " ","Budgeting","ReAllocation";
            Caption = 'Budget Option';
        }
        field(50013; "Plan Submission Cut-off"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Plan Submission Cut-off Date';
        }
    }
}


