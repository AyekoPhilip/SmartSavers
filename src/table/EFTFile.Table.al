table 50588 "EFT File"
{
    Caption = 'EFT File';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(50010; "EFT No."; Code[100])
        {
            Caption = 'EFT No.';
            DataClassification = CustomerContent;
        }
        field(50011; "EFT Options"; Enum "EFTPaymentOptions")
        {
            Caption = 'EFT Options';
            DataClassification = CustomerContent;
        }
        field(50012; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50013; "Time Entered"; Time)
        {
            Caption = 'Time Entered';
            DataClassification = CustomerContent;
        }
        field(50014; "Captured By"; Code[100])
        {
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50015; "File No."; Text[250])
        {
            Caption = 'File No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            DataClassification = CustomerContent;
        }
        field(50017; "No. of Files"; Integer)
        {
            Caption = 'No. of Files';
            DataClassification = CustomerContent;
        }
        field(50018; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50019; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(50020; "Account Name"; Text[250])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50021; "Bank Account No."; Code[100])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        }
        field(50022; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
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
    trigger OnInsert()
    begin
        "Captured By" := UserId;
        "Date Entered" := Today;
        "Time Entered" := Time;
    end;
}
