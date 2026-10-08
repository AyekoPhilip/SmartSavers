table 50120 "Travelling Non Employees"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Request No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Request No.';
        }
        field(50010; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Line No';
        }
        field(50011; "Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(50012; "Source"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Source';
        }
        field(50013; "Destination"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination';
        }
        field(50014; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(50015; "Return Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Return Date';
        }
        field(50016; "Passport No"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Passport No';
        }
        field(50017; "Airline"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Airline';
        }
        field(50018; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(50019; "Itinerary"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Itinerary';
        }
        field(50020; "Travel Insurance"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Travel Insurance';
        }
        field(50021; "Ticket Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ',Economy,Business';
            OptionMembers = "","Economy","Business";
            Caption = 'Ticket Type';
        }
        field(50022; "Cost Centre"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Centre';
        }
        field(50023; "FSC Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FSC Code';
        }
        field(50024; "Fn Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fn Code';
        }
    }

    keys
    {
        key("Key1"; "Request No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


