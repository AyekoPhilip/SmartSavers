table 50420 "Coinage"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52140604;
    LookupPageID = 52140604; */

    fields
    {
        field(50009; "No"; Code[20])
        {
            TableRelation = "Treasury Cashier Transaction".No;
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Denominations;
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Type"; Option)
        {
            OptionMembers = "Note","Coin";
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Value"; Decimal)
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(50014; "Quantity"; Integer)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if Quantity <> 0 then
                    "Total Amount" := Quantity * Value
                else
                    "Total Amount" := 0;
            end;
        }
        field(50015; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




