table 50157 "Customized Calendar Entry II"
{
    Caption = 'Customized Calendar Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Source Type"; Enum "Calendar Source Type")
        {
            Caption = 'Source Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "Additional Source Code"; Code[20])
        {
            Caption = 'Additional Source Code';
            DataClassification = CustomerContent;
        }
        field(50012; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            Editable = false;
            TableRelation = "Base Calender Custom";
            DataClassification = CustomerContent;
        }
        field(50013; "Date"; Date)
        {
            Caption = 'Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50014; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UpdateExceptionEntry();
            end;
        }
        field(50015; "Nonworking"; Boolean)
        {
            Caption = 'Nonworking';
            Editable = true;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UpdateExceptionEntry();
            end;
        }
    }

    keys
    {
        key("Key1"; "Source Type", "Source Code", "Additional Source Code", "Base Calendar Code", "Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Customer: Record Customer;
        Location: Record Location;
        ServMgtsetup: Record "Service Mgt. Setup";
        ShippingAgentService: Record "Shipping Agent Services";
        Vendor: Record Vendor;

    procedure GetCaption(): Text[250]
    begin
        case "Source Type" of
            "Source Type"::Company:
                exit(CompanyName);
            "Source Type"::Customer:
                if Customer.Get("Source Code") then
                    exit("Source Code" + ' ' + Customer.Name);
            "Source Type"::Vendor:
                if Vendor.Get("Source Code") then
                    exit("Source Code" + ' ' + Vendor.Name);
            "Source Type"::Location:
                if Location.Get("Source Code") then
                    exit("Source Code" + ' ' + Location.Name);
            "Source Type"::"Shipping Agent":
                if ShippingAgentService.Get("Source Code", "Additional Source Code") then
                    exit("Source Code" + ' ' + "Additional Source Code" + ' ' + ShippingAgentService.Description);
            "Source Type"::Service:
                if ServMgtsetup.Get() then
                    exit("Source Code" + ' ' + ServMgtsetup.TableCaption);
        end;
    end;

    local procedure UpdateExceptionEntry()
    var
        CalendarException: Record "Customized Calendar Change";
    begin
        CalendarException.SetRange("Source Type", "Source Type");
        CalendarException.SetRange("Source Code", "Source Code");
        CalendarException.SetRange("Base Calendar Code", "Base Calendar Code");
        CalendarException.SetRange(Date, Date);
        CalendarException.DeleteAll();
        CalendarException.Init();
        CalendarException."Source Type" := "Source Type";
        CalendarException."Source Code" := "Source Code";
        CalendarException."Base Calendar Code" := "Base Calendar Code";
        CalendarException.Validate(Date, Date);
        CalendarException.Nonworking := Nonworking;
        CalendarException.Description := Description;
        CalendarException.Insert();
    end;
}


