table 50001 "Cash Management Setups"
{
    Caption = 'Cash Management Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Primary Key"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(50010; "Payment Voucher Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Payment Voucher Template';
        }
        field(50011; "Imprest Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Imprest Journal Template';
        }
        field(50012; "Imprest Surrender Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Imprest Surrender Template';
        }
        field(50013; "Petty Cash Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Journal Template';
        }
        field(50014; "Receipt Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Receipt Template';
        }
        field(50015; "Post VAT"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Post VAT';
        }
        field(50016; "Rounding Type"; Option)
        {
            OptionCaption = 'Up,Nearest,Down';
            OptionMembers = "Up","Nearest","Down";
            DataClassification = CustomerContent;
            Caption = 'Rounding Type';
        }
        field(50017; "Rounding Precision"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rounding Precision';
        }
        field(50018; "Imprest Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Imprest Limit';
        }
        field(50019; "Imprest Due Date"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Imprest Due Date';
        }
        field(50020; "PV Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'PV Nos';
        }
        field(50021; "Petty Cash Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Nos';
        }
        field(50022; "Imprest Nos"; Code[50])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Imprest Nos';
        }
        field(50023; "Current Budget"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
            DataClassification = CustomerContent;
            Caption = 'Current Budget';
        }
        field(50024; "Current Budget Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Budget Start Date';
        }
        field(50025; "Current Budget End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Budget End Date';
        }
        field(50026; "Imprest Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
            Caption = 'Imprest Posting Group';
        }
        field(50027; "General Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
            DataClassification = CustomerContent;
            Caption = 'General Bus. Posting Group';
        }
        field(50028; "VAT Bus. Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
            DataClassification = CustomerContent;
            Caption = 'VAT Bus. Posting Group';
        }
        field(50029; "Check for Committment"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Check for Committment';
        }
        field(50030; "Imprest Surrender Nos"; Code[50])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Imprest Surrender Nos';
        }
        field(50031; "Bank Transfer Nos"; Code[50])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Bank Transfer Nos';
        }
        field(50032; "Receipt Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Receipt Nos';
        }
        field(50033; "Petty Cash Surrender Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Surrender Template';
        }
        field(50034; "Petty Cash Surrender Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Surrender Nos';
        }
        field(50035; "Donor Workflows Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Donor Workflows Nos';
        }
        field(50036; "Attachment Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Attachment Nos';
        }
        field(50037; "Approvals Delegation Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Approvals Delegation Nos.';
        }
        field(50038; "Petty Cash Max"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Max';
        }
        field(50039; "Staff Claim Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Staff Claim Nos';
        }
        field(50040; "Staff Claim Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Staff Claim Template';
        }
        field(50041; "Bank Transfer Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Bank Transfer Template';
        }
        field(50042; "Max Imprests Unsurrendered"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Imprests Unsurrendered';
        }
        field(50043; "Max Open Documents"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Open Documents';
        }
        field(50044; "EFT Path"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'EFT Path';
        }
        field(50045; "Loan Journal Template"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Loan Journal Template';
        }
        field(50046; "Loan Batch Template"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch";
            Caption = 'Loan Batch Template';
        }
        field(50047; "Append Sign To Documents"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Append Sign To Documents';
        }
        field(50048; "Laundry Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Laundry Nos';
        }
        field(50049; "Laundry Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Laundry Template';
        }
        field(50050; "Laundry Payable Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Laundry Payable Account';
        }
        field(50051; "Laundry Bank Account"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
            Caption = 'Laundry Bank Account';
        }
        field(50052; "Laundry Inspection Notes"; Blob)
        {
            DataClassification = CustomerContent;
            SubType = Memo;
            Caption = 'Laundry Inspection Notes';
        }
        field(50053; "Laundry Payment Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Laundry Payment Nos';
        }
        field(50054; "Laundry Invoice Path"; Text[70])
        {
            DataClassification = CustomerContent;
            Caption = 'Laundry Invoice Path';
        }
        field(50055; "Profile Delegation Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Profile Delegation Nos';
        }
        field(50056; "Library Charge Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Library Charge Template';
        }
        field(50057; "Library Charge Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Library Charge Template"));
            Caption = 'Library Charge Batch';
        }
        field(50058; "Library Charge Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Library Charge Account';
        }
        field(50059; "Proposed Budget Approval Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Proposed Budget Approval Nos';
        }
        field(50060; "Budget Approval Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Budget Approval Nos';
        }
        field(50061; "Bank Reconciliation Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Bank Reconciliation Nos';
        }
        field(50062; "Approtionment Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Approtionment Account';
        }
        field(50063; "Apportion Template"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Apportion Template';
        }
        field(50064; "Apportion Batch"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name;
            Caption = 'Apportion Batch';
        }
        field(50065; "Apportionment Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Apportionment Nos';
        }
        field(50066; "Input Tax Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Input Tax Nos';
        }
        field(50067; "Service Charge Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Service Charge Nos';
        }
        field(50068; "Service Charge Surrender Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Service Charge Surrender Nos';
        }
        field(50069; "Service Charge Claim Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Service Charge Claim Nos';
        }
        field(50070; "FA Disposal Nos"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'FA Disposal Nos';
        }
        field(50071; "Finance Email"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Finance Email';
        }
        field(50072; "Cheque Reject Period"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
           field(50073; "Benevolent Claim Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Benevolent Claim Nos';
        }
        field(50074; "Interbank Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'Interbank Transfer Nos';
        }
    }

    keys
    {
        key("Key1"; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


