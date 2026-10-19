tableextension 50054 "FixedAssetExt" extends "Fixed Asset"
{
    fields
    {
        field(50009; "Colour"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Colour';
        }
        field(50010; "Type of Body"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Type of Body';
        }
        field(50011; "Chassis No."; Code[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Chassis No.';
        }
        field(50012; "Rating"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Rating';
        }
        field(50013; "Seating/carrying capacity"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Seating/carrying capacity';
        }
        field(50014; "Registration No"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Registration No';
        }
        field(50015; "Disposed"; Boolean)
        {
            CalcFormula = exist("FA Depreciation Book" where("FA No." = field("No."),
                                                              "Disposal Date" = filter(<> 0D)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Disposed';
        }
        field(50016; "Marked For Disposal"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Marked For Disposal';
        }
        field(50017; "Date of purchase"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of purchase';
        }
        field(50038; "Body"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Body';
        }
        field(50039; "Car Tracking Company"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Car Tracking Company';
        }
        field(50040; "Tracking Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Tracking Date';
        }
        field(50041; "Tracking Renewal Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Tracking Renewal Date';
        }
        field(50042; "Car Rating"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Car Rating';
        }
        field(50043; "YOM"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'YOM';
        }
        field(50044; "Duty"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Duty';
        }
        field(50018; "Policy No"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Policy No';
        }
        field(50019; "Insurer"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Insurer';
        }
        field(50020; "Insurance Company"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Insurance Company';
        }
        field(50021; "Premium Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Premium Amount';
        }
        field(50022; "Amount of Purchase"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount of Purchase';
        }
        field(50023; "Valuation Firm"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Valuation Firm';
        }
        field(50024; "Last Valued Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Last Valued Date';
        }
        field(50025; "Date of Commencement"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Date of Commencement';
        }
        field(50026; "Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Expiry Date';
        }
        field(50027; "Fixed Asset Type"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            OptionCaption = ' ,Fleet,House';
            OptionMembers = " ","Fleet","House";
            Caption = 'Fixed Asset Type';
        }
        field(50028; "Current Odometer Reading"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Current Odometer Reading';
        }
        field(50029; "On Trip"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'On Trip';
        }
        field(50030; "In Use"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'In Use';
        }
        field(50031; "Tank Capacity"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Tank Capacity';
        }
        field(50032; "Average Km/L"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Average Km/L';
        }
        field(50033; "Logbook No"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Logbook No';
        }
        field(50034; "Maintainence Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Available","Under Maintenence","Written Off";
            Caption = 'Maintainence Status';
        }
        field(50035; "Make"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Make';
        }
        field(50036; "Model"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'fleet';
            Caption = 'Model';
        }
        field(50037; "Vehicle Type"; Option)
        {
            OptionMembers = "Company Vehicle","Personal Vehicle","Taxi";
            OptionCaption = 'Company Vehicle, Personal Vehicle,Taxi';
            DataClassification = CustomerContent;
            Caption = 'Vehicle Type';
        }
        field(50045; "Valuer"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Property';
            Caption = 'Valuer';
        }
        field(50046; "Asset Tagging"; Code[100])
        {
            DataClassification = CustomerContent;
            Description = 'Property';
            Caption = 'Asset Tagging';
        }
        field(50047; "Barcode"; Media)
        {
            DataClassification = CustomerContent;
            Description = 'Barcode';
        }
        field(50048; "G/L Budget Line"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Budget Line';
        }

    }
}


