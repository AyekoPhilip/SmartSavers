table 50428 "Cheque Receipt"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52140617;
    LookupPageID = 52140617; */

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
               
            end;
        }
        field(50010; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Refference Document"; Code[20])
        {
            Caption = 'Refference Document';
            DataClassification = CustomerContent;
        }
        field(50012; "Transaction Time"; Time)
        {
            Caption = 'Transaction Time';
            DataClassification = CustomerContent;
        }
        field(50013; "Created By"; Code[60])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50014; "Posted By"; Code[60])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50015; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50016; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50017; "Unpaid By"; Code[60])
        {
            Editable = false;
            Caption = 'Unpaid By';
            DataClassification = CustomerContent;
        }
        field(50018; "Unpaid"; Boolean)
        {
            Editable = false;
            Caption = 'Unpaid';
            DataClassification = CustomerContent;
        }
        field(50019; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Bank Cheques"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50020; "Clearing Bank"; Code[20])
        {
            TableRelation = "Bank Account";
            Caption = 'Clearing Bank';
            DataClassification = CustomerContent;
        }
        field(50021; "Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = "Open","Pending","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin


        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Cheque Receipts Nos");
            
        end;

        "Transaction Time" := Time;
        "Transaction Date" := Today;
    end;

    var
        NoSeriesmgt: Codeunit "No. Series";
        SalesSetup: Record "Banking No. Setup";
}




