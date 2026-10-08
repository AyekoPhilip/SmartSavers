table 50427 "Cheque Issue Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Chq Receipt No"; Code[20])
        {
            Caption = 'Chq Receipt No';
            DataClassification = CustomerContent;
        }
        field(50010; "Cheque Serial No"; Code[20])
        {
            Caption = 'Cheque Serial No';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No."; Code[20])
        {
            TableRelation = "Account Banking";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Date _Refference No."; Code[20])
        {
            Caption = 'Date _Refference No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            DataClassification = CustomerContent;
        }
        field(50014; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50015; "Currency"; Code[10])
        {
            Caption = 'Currency';
            DataClassification = CustomerContent;
        }
        field(50016; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50017; "Date-1"; Date)
        {
            Caption = 'Date-1';
            DataClassification = CustomerContent;
        }
        field(50018; "Date-2"; Date)
        {
            Caption = 'Date-2';
            DataClassification = CustomerContent;
        }
        field(50019; "Coop  Routing No."; Code[10])
        {
            Caption = 'Coop  Routing No.';
            DataClassification = CustomerContent;
        }
        field(50020; "Fillers"; Code[10])
        {
            Caption = 'Fillers';
            DataClassification = CustomerContent;
        }
        field(50021; "Transaction Refference"; Code[10])
        {
            Caption = 'Transaction Refference';
            DataClassification = CustomerContent;
        }
        field(50022; "Account Name"; Text[150])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50023; "Un pay Code"; Code[10])
        {
            TableRelation = "Cheque Return Code"."Return Code";
            Caption = 'Un pay Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if RetCode.Get("Un pay Code") then begin
                    Interpretation := RetCode."Code Interpretation";
                    "Un Pay Charge Amount" := RetCode.Charges;
                    "Unpay Date" := Today;
                end else
                    Interpretation := '';
            end;
        }
        field(50024; "Interpretation"; Text[150])
        {
            Caption = 'Interpretation';
            DataClassification = CustomerContent;
        }
        field(50025; "Family Account No."; Code[20])
        {
            Caption = 'Family Account No.';
            DataClassification = CustomerContent;
        }
        field(50026; "Un Pay Charge Amount"; Decimal)
        {
            Caption = 'Un Pay Charge Amount';
            DataClassification = CustomerContent;
        }
        field(50027; "Unpay Date"; Date)
        {
            Caption = 'Unpay Date';
            DataClassification = CustomerContent;
        }
        field(50028; "Status"; Option)
        {
            OptionCaption = 'Pending,Approved,Cancelled,stopped';
            OptionMembers = "Pending","Approved","Cancelled","stopped";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50029; "CHAccount No"; Code[20])
        {
            Caption = 'CHAccount No';
            DataClassification = CustomerContent;
        }
        field(50030; "Presenting Bank"; Code[20])
        {
            Caption = 'Presenting Bank';
            DataClassification = CustomerContent;
        }
        field(50031; "Voucher Type"; Code[20])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Chq Receipt No", "Cheque Serial No", "CHAccount No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        RetCode: Record "Cheque Return Code";
}




