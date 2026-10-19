tableextension 50049 "CompanyInfoExt" extends "Company Information"
{
    fields
    {
        field(50009; "Company PIN No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Bank Account Name"; Text[50])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Bank Name 2"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Bank Branch No.2"; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Bank Account No.2"; Text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        }
        field(50014; "SWIFT Code2"; Code[20])
        {
            Caption = 'SWIFT Code';
            DataClassification = CustomerContent;
        }
        field(50015; "Bank Account Name2"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50016; "MPESA Paybill"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Bank Branch Name"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50018; "Bank Branch Name2"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Document Path"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50020; "E-Mail Signature"; Blob)
        {
            DataClassification = CustomerContent;
            Subtype = Memo;
        }
        field(50021; "Online Document Path"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    
        field(50022; "Home Page 2"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
}


