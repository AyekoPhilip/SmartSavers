table 50506 "Online Transactions"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Document No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*IF "Document No." <> xRec."Document No." THEN BEGIN
                  SalesSetup.GET;
                  NoSeriesMgt.TestManual(SalesSetup."Customer Nos.");
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(50010; "Transaction Date"; DateTime)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No."; Code[50])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Description"; Text[220])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50015; "Transaction Type"; Option)
        {
            OptionCaption = ',Online Transfer,Utility Payments,Mpesa Transfer,Loan Repayment,Dividends Allocation';
            OptionMembers = "","Online Transfer","Utility Payments","Mpesa Transfer","Loan Repayment","Dividends Allocation";
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50016; "Transaction Time"; Date)
        {
            Caption = 'Transaction Time';
            DataClassification = CustomerContent;
        }
        field(50017; "Document Date"; DateTime)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(50018; "Date Posted"; DateTime)
        {
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
        field(50019; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50020; "Account Status"; Text[30])
        {
            Caption = 'Account Status';
            DataClassification = CustomerContent;
        }
        field(50021; "Messages"; Text[200])
        {
            Caption = 'Messages';
            DataClassification = CustomerContent;
        }
        field(50022; "Needs Change"; Boolean)
        {
            Caption = 'Needs Change';
            DataClassification = CustomerContent;
        }
        field(50023; "Change Transaction No"; Code[20])
        {
            Caption = 'Change Transaction No';
            DataClassification = CustomerContent;
        }
        field(50024; "Old Account No"; Code[50])
        {
            Caption = 'Old Account No';
            DataClassification = CustomerContent;
        }
        field(50025; "Changed"; Boolean)
        {
            Caption = 'Changed';
            DataClassification = CustomerContent;
        }
        field(50026; "Date Changed"; Date)
        {
            Caption = 'Date Changed';
            DataClassification = CustomerContent;
        }
        field(50027; "Time Changed"; Time)
        {
            Caption = 'Time Changed';
            DataClassification = CustomerContent;
        }
        field(50028; "Changed By"; Code[30])
        {
            Caption = 'Changed By';
            DataClassification = CustomerContent;
        }
        field(50029; "Approved By"; Code[30])
        {
            Caption = 'Approved By';
            DataClassification = CustomerContent;
        }
        field(50030; "Key Word"; Text[30])
        {
            Caption = 'Key Word';
            DataClassification = CustomerContent;
        }
        field(50031; "CorporateNo"; Text[30])
        {
            Caption = 'CorporateNo';
            DataClassification = CustomerContent;
        }
        field(50032; "Telephone No"; Text[30])
        {
            Caption = 'Telephone No';
            DataClassification = CustomerContent;
        }
        field(50033; "Mpesa Names"; Text[30])
        {
            Caption = 'Mpesa Names';
            DataClassification = CustomerContent;
        }
        field(50034; "Utility Type"; Text[200])
        {
            Caption = 'Utility Type';
            DataClassification = CustomerContent;
        }
        field(50035; "Account To"; Text[200])
        {
            Caption = 'Account To';
            DataClassification = CustomerContent;
        }
        field(50036; "No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50037; "Member No"; Text[30])
        {
            Caption = 'Member No';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*IF "Document No." = '' THEN BEGIN
          SalesSetup.GET;
          SalesSetup.TESTFIELD("Customer Nos.");
          NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.",xRec."No. Series",0D,"Document No.","No. Series");
        END;*/

    end;
}




