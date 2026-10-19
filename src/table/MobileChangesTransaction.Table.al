table 50537 "Mobile Changes Transaction"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Code[20])
        {
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Initiated By"; Code[50])
        {
            Caption = 'Initiated By';
            DataClassification = CustomerContent;
        }
        field(50012; "MPESA Receipt No"; Code[20])
        {
            Caption = 'MPESA Receipt No';
            DataClassification = CustomerContent;
        }
        field(50013; "Account No"; Code[30])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50014; "New Account No"; Code[30])
        {
            Caption = 'New Account No';
            DataClassification = CustomerContent;
        }
        field(50015; "Comments"; Text[100])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
        field(50016; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            DataClassification = CustomerContent;
        }
        field(50017; "Date Approved"; Date)
        {
            Caption = 'Date Approved';
            DataClassification = CustomerContent;
        }
        field(50018; "Time Approved"; Time)
        {
            Caption = 'Time Approved';
            DataClassification = CustomerContent;
        }
        field(50019; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50020; "Changed"; Boolean)
        {
            Caption = 'Changed';
            DataClassification = CustomerContent;
        }
        field(50021; "Status"; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = "Open","Pending","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50022; "Sent For Approval By"; Code[50])
        {
            Caption = 'Sent For Approval By';
            DataClassification = CustomerContent;
        }
        field(50023; "Date Sent For Approval"; Date)
        {
            Caption = 'Date Sent For Approval';
            DataClassification = CustomerContent;
        }
        field(50024; "Time Sent For Approval"; Time)
        {
            Caption = 'Time Sent For Approval';
            DataClassification = CustomerContent;
        }
        field(50025; "Reasons for rejection"; Text[200])
        {
            Caption = 'Reasons for rejection';
            DataClassification = CustomerContent;
        }
        field(50026; "BOSA Account No"; Code[20])
        {
            TableRelation = Member."No.";
            Caption = 'BOSA Account No';
            DataClassification = CustomerContent;
        }
        field(50027; "Transaction Type"; Option)
        {
            OptionMembers = "Deposit Contribution","Share Capital","Loan Repayment","Benevolent Funds";
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50028; "Destination Type"; Option)
        {
            OptionCaption = 'Savings,Loans,Invalid Transaction';
            OptionMembers = "Savings","Loans","Invalid Transaction";
            Caption = 'Destination Type';
            DataClassification = CustomerContent;
        }
        field(50029; "Loan Product Type"; Text[100])
        {
            Caption = 'Loan Product Type';
            DataClassification = CustomerContent;
        }
        field(50030; "App Status"; Option)
        {
            OptionCaption = 'Pending,First Approval,Changed,Rejected';
            OptionMembers = "Pending","First Approval","Changed","Rejected";
            Caption = 'App Status';
            DataClassification = CustomerContent;
        }
        field(50031; "Responsibility Centre"; Code[20])
        {
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50032; "Valid Transaction"; Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = "Yes","No";
            Caption = 'Valid Transaction';
            DataClassification = CustomerContent;
        }
        field(50033; "Reversed"; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = CustomerContent;
        }
        field(50034; "Date Reversed"; Date)
        {
            Caption = 'Date Reversed';
            DataClassification = CustomerContent;
        }
        field(50035; "Reversed By"; Code[50])
        {
            Caption = 'Reversed By';
            DataClassification = CustomerContent;
        }
        field(50036; "Staff No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Staff No.';
        }
        field(50037; "Name"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(50038; "ID No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ID No.';
        }
    }

    keys
    {
        key("Key1"; "No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




