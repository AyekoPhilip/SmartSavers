table 50238 "Payroll Requests"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Payroll Request Lookup";
    LookupPageId = "Payroll Request Lookup";

    fields
    {
        field(50009; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(50010; "Applies"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'All,Group,Specific';
            OptionMembers = "All","Group","Specific";
            Caption = 'Applies';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50011; "Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employment Contract";
            Caption = 'Group';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50012; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Hr Employees";
            Caption = 'Employee No.';
        
            trigger OnValidate()
            begin
                EmpCopy.Get("Employee No.");
                "Employee Name" := EmpCopy.Name

            end;
        }
        field(50013; "Employee Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Name';
        }
        field(50014; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Earning,Deduction';
            OptionMembers = " ","Earning","Deduction";
            Caption = 'Type';
        }
        field(50015; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if (Type = const(Earning)) "Pr Transaction Code".Code where("Transaction Type" = filter(Income), "Ignored on Gross Pay" = filter(true), "Special Transactions" = filter("Overtime Allowance" | "Leave Allowance" | "Acting Allowance"))
            else
            if (Type = const(Deduction)) "Pr Transaction Code".Code where("Transaction Type" = filter(Deduction));
            Caption = 'Transaction Code';
        
            trigger OnValidate()
            var
                DailyRate: Decimal;
                HourlySal: Decimal;
            begin

                PrVitalsetup.Get();

                if PrTranscode.Get(Code) then begin
                    "Code Descripton" := PrTranscode.Name;

                    case PrTranscode."Transaction Type" of
                        PrTranscode."Transaction Type"::Income:
                            begin

                                PrSalary.Get("Employee No.");
                                PrSalary.TestField("Basic Pay");

                                Overtime := true;
                                PrVitalsetup.TestField("Earliest Start Time (Weekend)");
                                PrVitalsetup.TestField("Earliest Start Time (Weekday)");
                                PrVitalsetup.TestField("Earliest End Time (Weekend)");
                                PrVitalsetup.TestField("Earliest End Time (Weekday)");
                                PrVitalsetup.TestField("Max. hours (Weekdays)");
                                PrVitalsetup.TestField("Max. Hours (Weekend)");
                                PrVitalsetup.TestField("Daily Salary Rate");
                                PrVitalsetup.TestField("Overtime Rate (WeekDay)");
                                PrVitalsetup.TestField("Overtime Rate (Weekend)");

                                DailyRate := Round((PrSalary."Basic Pay" / PrVitalsetup."Daily Salary Rate"));
                                HourlySal := Round((DailyRate / 8));

                                case System.Date2DWY(Today, 1) of
                                    1,
                                    2, 3, 4, 5, 6:
                                        begin
                                            if "Is Holiday" then begin
                                                "Earliest Start Time" := PrVitalsetup."Earliest Start Time (Weekday)";
                                                "Earliest End Time" := PrVitalsetup."Earliest End Time (Weekday)";
                                                if (Time < PrVitalsetup."Earliest Start Time (Weekday)") or (Time > PrVitalsetup."Earliest End Time (Weekday)") then Error(ErrorOnStartEndTime);
                                                Amount := Round(("Working Day Hours" * HourlySal) * PrVitalsetup."Overtime Rate (Weekend)");
                                            end else begin
                                                "Earliest Start Time" := PrVitalsetup."Earliest Start Time (Weekday)";
                                                "Earliest End Time" := PrVitalsetup."Earliest End Time (Weekday)";
                                                if (Time < PrVitalsetup."Earliest Start Time (Weekday)") or (Time > PrVitalsetup."Earliest End Time (Weekday)") then Error(ErrorOnStartEndTime);
                                                Amount := Round(("Working Day Hours" * HourlySal) * PrVitalsetup."Overtime Rate (WeekDay)");

                                            end;
                                        end;
                                    7:
                                        begin
                                            if (Time < PrVitalsetup."Earliest Start Time (Weekend)") or (Time > PrVitalsetup."Earliest End Time (Weekend)") then Error(ErrorOnStartEndTime);
                                            Amount := Round(("Working Day Hours" * HourlySal) * PrVitalsetup."Overtime Rate (Weekend)");
                                        end;
                                end;
                            end;
                    end;
                end;
            end;
        }
        field(50016; "Calculation Method"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Flat amount,% of Basic pay,% of Gross pay,% of Insurance Amount,% of Taxable income,% of Basic after tax,Based on Hourly Rate,Based on Daily Rate,Formula';
            OptionMembers = "Flat amount","% of Basic pay","% of Gross pay","% of Insurance Amount","% of Taxable income","% of Basic after tax","Based on Hourly Rate","Based on Daily Rate","Formula";
            Caption = 'Calculation Method';
        }
        field(50017; "Flat Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Flat Amount';
        }
        field(50018; "Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
        }
        field(50019; "Formula"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Formula';
        }
        field(50020; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
        }
        field(50021; "Units"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Units';
        }
        field(50022; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        
            trigger OnValidate()
            begin
                TestField(Type, Type::Deduction);
            end;
        }
        field(50023; "Payroll Period"; Date)
        {
            DataClassification = CustomerContent;
            TableRelation = "Pr Payroll Period" where(Closed = const(false));
            Caption = 'Payroll Period';
        }
        field(50024; "Locum"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Locum';
        }
        field(50025; "Principal Employee Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
            Caption = 'Principal Employee Code';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50026; "Principal Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Principal Employee Name';
        }
        field(50027; "Principal Employee Basic"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Principal Employee Basic';
        }
        field(50028; "Hours"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Hours';
        
            trigger OnValidate()
            begin
                Amount := ("Principal Employee Basic" * Hours / 30);
                Validate(Amount);
            end;
        }
        field(50029; "Working Day Hours"; Decimal)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Validate(Code);
            end;
        }
        field(50030; "Gratuity"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Gratuity';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50031; "Months Worked"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Months Worked';
        }
        field(50032; "Code Descripton"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Code Descripton';
            Editable = false;
        }
        field(50033; "Special Condition"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Suspend","Re-Instatement";
            Caption = 'Special Condition';
        }
        field(50034; "Remarks"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
        field(50035; "Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Payroll Status';
        }
        field(50036; "Overtime"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Overtime';
        }
        field(50037; "Non-Working Day Hours"; Decimal)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50038; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(50039; "Leave Allowance"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Allowance';
        }
        field(50040; "Leave Application Document"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Application Document';
        }
        field(50041; "Total Leave Days Taken"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Leave Days Taken';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50042; "Date of Activity"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Activity';
            Editable = false;
        }
        field(50043; "Responsibility Center"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsibility Centre';
        }
        field(50044; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Status';
        }
        field(50045; "Is Holiday"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Holiday';
        
            trigger OnValidate()
            begin
                case "Is Holiday" of
                    true:
                        "Working Day Hours" := 0 else
                                                     "Non-Working Day Hours" := 0;

                end;
            end;
        }
        field(50046; "Earliest Start Time"; Time)
        {

        }
        field(50047; "Earliest End Time"; Time)
        {
            Caption = 'Earliest End Time';
        
            trigger OnValidate()
            begin
                if "Earliest End Time" > Time then Error('Earliest end time cannot be greater than time');
            end;
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
    var
        EmployeeNotExistErr: Label 'Employee with %1 ID has not been setup. Kindly contact HR';
    begin
        if "No." = '' then begin
            HRSetup.Get();
            HRSetup.TestField("Advice No.");
            "No. Series" := HRSetup."Advice No.";
            if NoSeriesMgt.AreRelated(HRSetup."Advice No.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;

        Temp.Get(UserId);
        Temp.TestField("Employee No.");
        if Employee.Get(Temp."Employee No.") then begin

            "Payroll Period" := PayrollMgt.fnGetOpenPeriod();
            "Created By" := UserId;
            "Date of Activity" := Today;
            "Responsibility Center" := Temp."Responsibility Centre";
            Validate("Employee No.", Employee."No.");
        end else
            Error(EmployeeNotExistErr)

    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "EFT Transfer Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                HRSetup.Get();
                NoSeriesMgt.TestManual(HRSetup."Advice No.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Payroll Requests"; xRecRef: Record "Payroll Requests"; var IsHandled: Boolean)
    begin
    end;

    var

        Emp: Record "Hr Employees";
        Employee: Record "Hr Employees";
        Temp: Record "User Setup";
        EmpCopy: Record "Hr Employees";
        LeaveTypes: Record "Leave Type";
        HRSetup: Record "Credit Nos. Series";
        PrVitalsetup: Record "Pr Vital Setup Info";
        PrTranscode: Record "Pr Transaction Code";
        PrSalary: Record "Pr Salary Card";
        PayrollMgt: Codeunit "Payroll Post Mngt.";
        NoSeriesMgt: Codeunit "No. Series";
        ErrorOnStartEndTime: Label 'Time must be within earliest start time and Earliest end time';
}


