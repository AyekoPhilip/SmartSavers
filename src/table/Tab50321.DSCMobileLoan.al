table 50321 "DSC Mobile Loan"
{
    Caption = 'DSC Mobile Loan';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(50012; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(50013; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = ToBeClassified;
        }
        field(50014; "Status"; Enum "MobileLoanStatus")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50015; "Remarks"; Text[150])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(50016; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = ToBeClassified;
        }
        field(50017; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        
            trigger OnValidate()

            begin



            end;
        }
        field(50018; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            DataClassification = ToBeClassified;
        }
        field(50019; "Phone No."; Code[20])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
        }
        field(50020; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            DataClassification = ToBeClassified;
        }
        field(50021; "API Code"; Code[50])
        {
            Caption = 'API Code';
            DataClassification = ToBeClassified;
        }
        field(50022; "Receipt No."; Code[50])
        {
            Caption = 'Receipt No.';
            DataClassification = ToBeClassified;
        }
        field(50023; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = ToBeClassified;
        }
        field(50024; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = ToBeClassified;
        }
        field(50025; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            DataClassification = ToBeClassified;
        }
        field(50026; "Captured By"; Code[100])
        {
            Caption = 'Captured By';
            DataClassification = ToBeClassified;
        }
        field(50027; "Date/Time Captured"; DateTime)
        {
            Caption = 'Date/Time Captured';
            DataClassification = ToBeClassified;
        }
        field(50028; "Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(91000; "Rcv Application Source"; Enum "Rcv13 Docs Application Source")
        {
            Caption = 'Application Source';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Entry No.")
        {
            Clustered = true;
        }
    }
}



