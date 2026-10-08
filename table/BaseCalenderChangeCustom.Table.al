table 50108 "Base Calender Change Custom"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            DataClassification = CustomerContent;
            Editable = true;
            TableRelation = "Base Calender Custom";
        }
        field(50010; "Recurring System"; Option)
        {
            Caption = 'Recurring System';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Annual Recurring,Weekly Recurring';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";
        
            trigger OnValidate()
            begin
                if "Recurring System" <> xRec."Recurring System" then
                    case "Recurring System" of
                        "Recurring System"::"Annual Recurring":
                            Day := Day::" ";
                        "Recurring System"::"Weekly Recurring":
                            Date := 0D;
                    end;
            end;
        }
        field(50011; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ("Recurring System" = "Recurring System"::" ") or
                   ("Recurring System" = "Recurring System"::"Annual Recurring")
                then
                    TestField(Date)
                else
                    TestField(Date, 0D);
                UpdateDayName();
            end;
        }
        field(50012; "Day"; Option)
        {
            Caption = 'Day';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday";
        
            trigger OnValidate()
            begin
                if "Recurring System" = "Recurring System"::"Weekly Recurring" then
                    TestField(Day);
                UpdateDayName();
            end;
        }
        field(50013; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50014; "Nonworking"; Boolean)
        {
            Caption = 'Nonworking';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key("Key1"; "Base Calendar Code", "Recurring System", "Date", "Day")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure CheckEntryLine()
    begin
        case "Recurring System" of
            "Recurring System"::" ":
                begin
                    TestField(Date);
                    TestField(Day);
                end;
            "Recurring System"::"Annual Recurring":
                begin
                    TestField(Date);
                    TestField(Day, Day::" ");
                end;

            "Recurring System"::"Weekly Recurring":
                begin
                    TestField(Date, 0D);
                    TestField(Day);
                end;
        end;
    end;

    procedure UpdateDayName()
    var
        DateTable: Record Date;
    begin
        if (Date > 0D) and
           ("Recurring System" = "Recurring System"::"Annual Recurring") then
            Day := Day::" "
        else begin
            DateTable.SetRange("Period Type", DateTable."Period Type"::Date);
            DateTable.SetRange("Period Start", Date);
            if DateTable.Find('-') then
                Day := DateTable."Period No.";
        end;
        if (Date = 0D) and (Day = Day::" ") then begin
            Day := xRec.Day;
            Date := xRec.Date;
        end;
        if "Recurring System" = "Recurring System"::"Annual Recurring" then
            TestField(Day, Day::" ");
    end;
}



