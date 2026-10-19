table 50146 "Transport Trips"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Request No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Request No';
        }
        field(50010; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(50011; "Vehicle No"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Fixed Asset"."No." where("Fixed Asset Type" = filter(Fleet),
                                                       "On Trip" = const(false),
                                                       "Under Maintenance" = const(false),
                                                       "Vehicle Type" = field("Vehicle Type"));
            Caption = 'Vehicle No';
        
            trigger OnValidate()
            begin

                FA.Reset();
                FA.SetRange("No.", "Vehicle No");
                if FA.Find('-') then begin
                    FA.TestField("Seating/carrying capacity");
                    FA.TestField("Current Odometer Reading");
                    "Vehicle Description" := FA.Description;
                    "Vehicle Capacity" := FA."Seating/carrying capacity";
                    "Previous KM" := FA."Current Odometer Reading";
                end;

                /*Trip.Reset();[ers]
                Trip.SetRange("Vehicle No",Trip."Vehicle No");
                if Trip.FindLast() then
                  begin
                    "Previous KM":=Trip."End of Journey KM";
                  end;*/

            end;
        }
        field(50012; "Vehicle Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vehicle Description';
        }
        field(50013; "Vehicle Capacity"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Vehicle Capacity';
        }
        field(50014; "Driver"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
            Caption = 'Driver';
        
            trigger OnValidate()
            begin

                Employee.Reset();
                Employee.SetRange("No.", Driver);
                if Employee.Find('-') then begin
                    Employee.TestField("E-Mail");
                    "Drivers Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                end;
            end;
        }
        field(50015; "Drivers Name"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Drivers Name';
        }
        field(50016; "Previous KM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Previous KM';
        
            trigger OnValidate()
            begin
                "KM Driven" := "End of Journey KM" - "Previous KM";
            end;
        }
        field(50017; "Time Out"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Out';
        }
        field(50018; "Time In"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time In';
        
            trigger OnValidate()
            begin

                if "Time Out" > "Time In" then
                    Error('Time-In cannot be before the Time-Out');
            end;
        }
        field(50019; "End of Journey KM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'End of Journey KM';
        
            trigger OnValidate()
            begin
                "KM Driven" := "End of Journey KM" - "Previous KM";
                if FA.Get("Vehicle No") then;
                //"Litres of Fuel":=("KM Driven"/FA."Average Km/L");
            end;
        }
        field(50020; "KM Driven"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'KM Driven';
        }
        field(50021; "Litres of Oil"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Litres of Oil';
        }
        field(50022; "Litres of Fuel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Litres of Fuel';
        }
        field(50023; "Order/Invoice/Cash/Voucher No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order/Invoice/Cash/Voucher No.';
        }
        field(50024; "Vehicle Type"; Option)
        {
            OptionMembers = "Company Vehicle","Personal Vehicle","Taxi";
            OptionCaption = 'Company Vehicle, Personal Vehicle,Taxi';
            DataClassification = CustomerContent;
            Caption = 'Vehicle Type';
        }
    }

    keys
    {
        key("Key1"; "Request No", "Vehicle No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;
        FA: Record "Fixed Asset";
}


