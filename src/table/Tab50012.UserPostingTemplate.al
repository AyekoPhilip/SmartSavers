table 50012 "User Posting Template"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "UserID"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'UserID';
        }
        field(50010; "Receipt Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const("Cash Receipts"));
            DataClassification = CustomerContent;
            Caption = 'Receipt Journal Template';
        }
        field(50011; "Receipt Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Receipt Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Receipt Journal Batch';
        }
        field(50012; "Payment Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            DataClassification = CustomerContent;
            Caption = 'Payment Journal Template';
        }
        field(50013; "Payment Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Payment Journal Batch';
        }
        field(50014; "Petty Cash Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Journal Template';
        }
        field(50015; "Petty Cash Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Petty Cash Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Journal Batch';
        }
        field(50016; "Bank Trans. Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(General));
            DataClassification = CustomerContent;
            Caption = 'Bank Trans. Journal Template';
        }
        field(50017; "Bank Trans. Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Bank Trans. Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Bank Trans. Journal Batch';
        }
        field(50018; "Item Journal Template"; Code[10])
        {
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Item Journal Template';
        }
        field(50019; "Item Journal Batch"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Item Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Item Journal Batch';
        }
        field(50020; "Payroll Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(General));
            DataClassification = CustomerContent;
            Caption = 'Payroll Journal Template';
        }
        field(50021; "Payroll Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payroll Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Payroll Journal Batch';
        }
        field(50022; "Job Journal Template"; Code[10])
        {
            TableRelation = "Job Journal Template".Name;
            DataClassification = CustomerContent;
            Caption = 'Job Journal Template';
        }
        field(50023; "Job Journal Batch"; Code[10])
        {
            TableRelation = "Job Journal Batch".Name where("Journal Template Name" = field("Job Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Job Journal Batch';
        }
    }

    keys
    {
        key("Key1"; "UserID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


