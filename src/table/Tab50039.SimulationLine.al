table 50039 "Simulation Line"
{
    Caption = 'Simulation Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = ToBeClassified;
        
            trigger OnValidate()
            begin
              if   CustRecord.Get("Member No.") then begin
                "staff payroll":= CustRecord."Payroll/Staff No.";
                end;
            end;
        }
        field(50012; "Processing Date"; Date)
        {
            Caption = 'Processing Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Dividend Calc. Method"; Enum "DividendMethod")
        {
            Caption = 'Dividend Calc. Method';
            DataClassification = CustomerContent;
        }
        field(50014; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Product Name"; Text[150])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50016; "Qualifying Shares"; Decimal)
        {
            Caption = 'Qualifying Shares';
            DataClassification = CustomerContent;
        }
        field(50017; "Shares"; Decimal)
        {
            Caption = 'Shares';
            DataClassification = CustomerContent;
        }
        field(50018; "Gross Dividends"; Decimal)
        {
            Caption = 'Gross Dividends';
            DataClassification = CustomerContent;
        }
        field(50019; "Witholding Tax"; Decimal)
        {
            Caption = 'Witholding Tax';
            DataClassification = CustomerContent;
        }
        field(50020; "Net Dividends"; Decimal)
        {
            Caption = 'Net Dividends';
            DataClassification = CustomerContent;
        }
        field(50021; "Posted"; Boolean)
        {
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(50022; "Account Name"; Text[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50023; "Fosa Account No."; Code[100])
        {
            Caption = 'Fosa No.';
            DataClassification = CustomerContent;
        }
        field(50024; "Shares Capital A/c"; Code[100])
        {
            Caption = 'Shares Capital A/c';
            DataClassification = CustomerContent;
        }
        field(50025; "Shares Deducted"; Decimal)
        {
            Caption = 'Shares Deductable';
            DataClassification = CustomerContent;
        }
        field(50026; "Fosa Account Blocked"; Enum "Vendor Blocked")
        {
            Caption = 'Fosa Account Blocked';
            DataClassification = CustomerContent;
        }
        field(50027; "Shares Capital Blocked"; Enum "Customer Blocked")
        {
            Caption = 'Shares Capital Blocked';
            DataClassification = CustomerContent;
        }
        field(50028; "Shares Banding"; Decimal)
        {
            Caption = 'Shares Banding';
            DataClassification = CustomerContent;
        }
        field(50029; "Blocked"; Enum "Customer Blocked")
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
         field(50030; "PIN No."; Code[20])
        {
            Caption = 'PIN No.';
            Editable = false;
            DataClassification = CustomerContent;
        }

         field(99000; "staff payroll"; Code[20])
        {
            Caption = 'Staff payroll';
            Editable=false;
            DataClassification = CustomerContent;
        }
        
    
        field(50031; "Dividend Advance Balance"; Decimal)
        {
            Caption = 'Dividend Advace Balance';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50032; "Loan Arrears Balance"; Decimal)
        {
            Caption = 'Loan Arrears Balance';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50033; "Share Capitalisation"; Decimal)
        {
            Caption = 'Share Capitalisation';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "No.", "Account No.")
        {
            Clustered = true;
        }
    }
    var
    CustRecord: Record Member;
}