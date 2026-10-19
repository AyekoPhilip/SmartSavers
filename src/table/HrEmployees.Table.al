namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using Microsoft.Foundation.Address;
using Microsoft.Inventory.Location;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.Dimension;
using System.Security.User;
using Microsoft.HumanResources.Setup;
using Microsoft.HumanResources.Employee;
table 50056 "Hr Employees"
{
    Caption = 'Employee';
    DrillDownPageId = "Hr Employee Lookup";
    LookupPageId = "Hr Employee Lookup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(2; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                NameBreakdownTxt;
            end;
        }
        field(3; "First Name"; Text[100])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Middle Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(4; "Middle Name"; Text[100])
        {
            Caption = 'Middle Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Middle Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(5; "Last Name"; Text[100])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Middle Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(6; "Initials"; Text[100])
        {
            Caption = 'Initials';
            DataClassification = CustomerContent;
        }
        field(7; "Postal Address"; Code[10])
        {
            Caption = 'Postal Address';
            DataClassification = CustomerContent;
        }
        field(8; "City"; Text[10])
        {
            Caption = 'City';
        }
        field(9; "Post Code"; Code[10])
        {
            Caption = 'Post Code';
            TableRelation = if ("Country Code" = filter('')) "Post Code" else
            if ("Country Code" = filter(<> '')) "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", "Country Code", Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; "Phone No."; Code[20])
        {
            Caption = 'Phone No.';
        }
        field(11; "Mobile Phone No."; Code[20])
        {
            Caption = 'Mobile Phone No.';
        }
        field(12; "E-Mail"; Code[100])
        {
            Caption = 'E-Mail';
        }
        field(13; "Picture"; MediaSet)
        {
            Caption = 'Picture';
        }
        field(14; "ID No."; Code[20])
        {
            Caption = 'ID No.';
        }
        field(15; "UIF No."; Code[10])
        {
            Caption = 'UIF No.';
        }
        field(16; "Union Code"; Code[10])
        {
            Caption = 'Union Code';
        }
        field(17; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
        }
        field(18; "Country Code"; Text[10])
        {
            Caption = 'Country of Resident';
            TableRelation = "Country/Region";
        }
        field(19; "Statistics Group Code"; Code[10])
        {
            Caption = 'Statistics Group Code';
        }
        field(20; "Status"; Enum "Employee Status")
        {
            Caption = 'Status';
        
            trigger OnValidate()
            var
                PrPayrollPeriod: Record "Pr Payroll Period";
                PrEmployerDeduc: Record "Pr Employer Deduction";
                PrPeriodTrans: Record "Pr Period Transaction";
            begin
                TestField("ID No.");
                TestField("Date Of Birth");
                TestField("First Name");
                TestField("Last Name");
            end;
        }
        field(21; "Department Code"; Code[10])
        {
            Caption = 'Department Code';
            TableRelation = "Responsibility Center";
        }
        field(22; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(23; "Company E-Mail"; Code[100])
        {
            Caption = 'Company E-Mail';
        }
        field(24; "No. Series"; Code[50])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(25; "Title"; Code[10])
        {
            Caption = 'Title';
        }
        field(26; "Full/Part Time"; Option)
        {
            Caption = 'Full/Part Time';
            OptionMembers = " ","Full Time","Part Time","Contract";
        }
        field(27; "Contract Type"; Code[10])
        {
            Caption = 'Contract Type';
            TableRelation = "HR Lookup Values".Code where(Type = filter("Contract Type"));
        }
        field(28; "Contract End Date"; Date)
        {
            Caption = 'Contract End Date';
        }
        field(29; "Notice Period"; Code[10])
        {
            Caption = 'Notice Period';
        }
        field(30; "Contracted Hours"; Decimal)
        {
            Caption = 'Contracted Hours';
        }
        field(31; "Pay Period"; Option)
        {
            Caption = 'Pay Period';
            OptionMembers = "Weekly","2 Weekly","4 Weekly","Monthly";
        }
        field(32; "Pay Per Period"; Decimal)
        {
            Caption = 'Pay Per Period';
        }
        field(33; "Cost Code"; Code[10])
        {
            Caption = 'Cost Centre Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2), "Dimension Value Type" = filter(Standard));
        }
        field(34; "Marital Status"; Enum "MaritalStatus")
        {
            Caption = 'Marital Status';
        }
        field(35; "Disabled"; Option)
        {
            Caption = 'Disabled';
            OptionMembers = "No","Yes";
        }
        field(36; "Health Assessment"; Boolean)
        {
            Caption = 'Health Assessment';
        }
        field(37; "Health Assessment Date"; Date)
        {
            Caption = 'Health Assessment Date';
        }
        field(38; "Date Of Birth"; Date)
        {
            Caption = 'Date Of Birth';
        }
        field(39; "Length of Service"; Text[100])
        {
            Caption = 'Length of Service';
        }
        field(40; "End of Probation Date"; Date)
        {
            Caption = 'End of Probation Date';
        }
        field(41; "Pension Scheme Join"; Date)
        {
            Caption = 'Pension Scheme Join';
        }

        field(43; "Medical Scheme Join"; Date)
        {
            Caption = 'Medical Scheme Join';
        }
        field(44; "Time Pension Scheme"; Text[100])
        {
            Caption = 'Time Pension Scheme';
        }
        field(46; "Allow Overtime"; Option)
        {
            Caption = 'Allow Overtime';
            OptionMembers = "Yes","No";
        }
        field(47; "Medical Scheme No."; Code[100])
        {
            Caption = 'Medical Scheme No.';
        }
        field(48; "No. of Dependants"; Integer)
        {
            Caption = 'No. of Dependants';
        }
        field(49; "Job ID"; Code[10])
        {
            Caption = 'Job ID';
            TableRelation = "HR Jobs"."Job ID";
        }
        field(50; "User ID"; Code[100])
        {
            Caption = 'User ID';
            TableRelation = "User Setup"."User ID";
        }
        field(51; "Passport No."; Code[20])
        {
            Caption = 'Passport No.';
        }
        field(52; "Pension Join"; Date)
        {
            Caption = 'Pension Join';
        }
        field(53; "Date of Leaving"; Date)
        {
            Caption = 'Date of Leaving';
        }
        field(54; "PIN No."; Code[20])
        {
            Caption = 'PIN No.';
        }
        field(55; "NSSF No."; Code[20])
        {
            Caption = 'NSSF No.';
        }
        field(56; "NHIF No."; Code[20])
        {
            Caption = 'NHIF No.';
        }
        field(57; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            TableRelation = "Cause of Inactivity".Code;
        }
        field(58; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            TableRelation = "Grounds for Termination".Code;
        }
        field(59; "Period Filter"; Date)
        {
            Caption = 'Period Filter';
        }
        field(60; "HELB No."; Code[10])
        {
            Caption = 'HELB No.';
        }
        field(61; "Cooperative No."; Code[10])
        {
            Caption = 'Cooperative No.';
        }
        field(62; "Job Title"; Code[10])
        {
            Caption = 'Job Title';
        }
        field(63; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            TableRelation = "Pr Employee Posting Group";
        }
        field(64; "Exit Interview Date"; Date)
        {
            Caption = 'Exit Interview Date';
        }
        field(65; "Resignation Date"; Date)
        {
            Caption = 'Resignation Date';
        }
        field(66; "Suspension Date"; Date)
        {
            Caption = 'Suspension Date';
        }
        field(67; "Demised Date"; Date)
        {
            Caption = 'Demised Date';
        }
        field(68; "Retirement Date"; Date)
        {
            Caption = 'Retirement Date';
        }
        field(69; "Retrenchment Date"; Date)
        {
            Caption = 'Retrenchment Date';
        }
        field(70; "Salary Grade"; Code[10])
        {
            Caption = 'Salary Grade';
            TableRelation = "Pr Salary Grade";
        }

        field(72; "Payroll Code"; Code[10])
        {
            Caption = 'Payroll Code';
        }
        field(73; "Payment Mode"; Enum "PaymentMode")
        {
            Caption = 'Payment Mode';
        }
        field(74; "Hourly Date"; Decimal)
        {
            Caption = 'Hourly Date';
        }
        field(75; "Daily Rate"; Decimal)
        {
            Caption = 'Daily Rate';
        }
        field(76; "Social Security No."; Code[10])
        {
            Caption = 'Social Security No.';
        }
        field(77; "Salary Notch/Step"; Code[10])
        {
            Caption = 'Salary Notch/Step';
            DataClassification = CustomerContent;
        }
        field(78; "Payroll Type"; Option)
        {
            Caption = 'Payroll Type';
            DataClassification = CustomerContent;
            OptionMembers = "General","Consultants","Seconded Staff";
        }
        field(79; "Employee Classification"; Code[10])
        {
            Caption = 'Employee Classification';
            DataClassification = CustomerContent;
        }
        field(80; "Total Leave Taken"; Decimal)
        {
            Caption = 'Total Leave Taken';
            FieldClass = FlowField;
            CalcFormula = Sum("Hr Leave Ledger Entry"."No. of days" WHERE("Staff No." = field("No."), "Posting Date" = FIELD("Date Filter"), "Leave Entry Type" = CONST(Negative), Closed = CONST(false)));
        }
        field(81; "Total (Leave Days)"; Decimal)
        {
            Caption = 'Total (Leave Days)';
            FieldClass = FlowField;
            CalcFormula = Sum("Hr Leave Ledger Entry"."No. of days" WHERE("Staff No." = field("No."), "Posting Date" = FIELD("Date Filter"), Closed = CONST(false)));
        }
        field(82; "Cash Leave Earned"; Decimal)
        {
            Caption = 'Cash Leave Earned';
            DataClassification = CustomerContent;
        }
        field(83; "Reimbursed Leave Days"; Decimal)
        {
            Caption = 'Reimbursed Leave Days';
            DataClassification = CustomerContent;
        }
        field(84; "Cash Per Leave Day"; Decimal)
        {
            Caption = 'Cash Per Leave Day';
            DataClassification = CustomerContent;
        }
        field(85; "Allocated Leave Days"; Decimal)
        {
            Caption = 'Allocated Leave Days';
            DataClassification = CustomerContent;
        }
        field(86; "End of Contract Date"; Date)
        {
            Caption = 'End of Contract Date';
            DataClassification = CustomerContent;
        }
        field(87; "Leave Period Filter"; Code[10])
        {
            Caption = 'Leave Period Filter';
            DataClassification = CustomerContent;
        }
        field(88; "Annual Leave Account"; Decimal)
        {
            Caption = 'Annual Leave Account';
            DataClassification = CustomerContent;
        }
        field(89; "Compassionate Leave A/c"; Decimal)
        {
            Caption = 'Compassionate Leave A/c';
            DataClassification = CustomerContent;
        }
        field(90; "Maternity Leave A/c"; Decimal)
        {
            Caption = 'Maternity Leave A/c';
            DataClassification = CustomerContent;
        }
        field(91; "Paternity Leave A/c"; Decimal)
        {
            Caption = 'Paternity Leave A/c';
            DataClassification = CustomerContent;
        }
        field(92; "Sick Leave A/c"; Decimal)
        {
            Caption = 'Sick Leave A/c';
            DataClassification = CustomerContent;
        }
        field(93; "Study Leave A/c"; Decimal)
        {
            Caption = 'Study Leave A/c';
            DataClassification = CustomerContent;
        }
        field(94; "Appraisal Method"; Option)
        {
            Caption = 'Appraisal Method';
            DataClassification = CustomerContent;
            OptionMembers = " ","Normal Appraisal","360 Appraisal";
        }
        field(95; "Leave Type"; Code[10])
        {
            Caption = 'Leave Type';
            DataClassification = CustomerContent;
        }
        field(96; "Employee Type"; Option)
        {
            Caption = 'Employee Type';
            DataClassification = CustomerContent;
            OptionMembers = "","Primary","Secondary","Board";
        }
        field(97; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(98; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(99; "Responsibility Centre"; Code[10])
        {
            Caption = 'Responsibility Centre';
            TableRelation = "Responsibility Center";
            DataClassification = CustomerContent;
        }
        field(100; "Date of Join"; Date)
        {
            Caption = 'Date of Join';
            DataClassification = CustomerContent;
        }
        field(101; "Date of Leaving Company"; Date)
        {
            Caption = 'Date of Leaving Company';
            DataClassification = CustomerContent;
        }
        field(102; "Termination Grounds"; Option)
        {
            Caption = 'Termination Grounds';
            DataClassification = CustomerContent;
            OptionMembers = " ","Resignation","Non-Renewal Of Contract","Dismissal","Retirement","Death","Other";
        }
        field(103; "Grade"; Code[10])
        {
            Caption = 'Grade';
            DataClassification = CustomerContent;
            TableRelation = "HR Lookup Values".Closed where(Type = filter(Grade));
        }
        field(104; "Leave Balance"; Decimal)
        {
            Caption = 'Leave Balance';
            FieldClass = FlowField;
            CalcFormula = Sum("Hr Leave Ledger Entry"."No. of days" WHERE("Staff No." = field("No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(105; "Leave Status"; Option)
        {
            Caption = 'Leave Status';
            DataClassification = CustomerContent;
            OptionMembers = "","On Leave","Resumed";
        }
        field(106; "Pension Scheme Join Date"; Date)
        {
            Caption = 'Pension Scheme Join Date';
            DataClassification = CustomerContent;
        }
        field(107; "Medical Scheme Join Date"; Date)
        {
            Caption = 'Medical Scheme Join Date';
            DataClassification = CustomerContent;
        }
        field(108; "Leave TYpe Filter"; Date)
        {
            Caption = 'Leave TYpe Filter';
            DataClassification = CustomerContent;
        }
        field(109; "Accrued Leave Days"; Decimal)
        {
            Caption = 'Accrued Leave Days';
            DataClassification = CustomerContent;
        }
        field(110; "Supervisor Code"; Code[10])
        {
            Caption = 'Supervisor Code';
            TableRelation = "User Setup"."User ID";
            DataClassification = CustomerContent;
        }
        field(111; "Probation Duration"; DateFormula)
        {
            Caption = 'Probation Duration';
            DataClassification = CustomerContent;
        }
        field(112; "Employee Group"; Option)
        {
            Caption = 'Employee Group';
            OptionMembers = "Unionisable","Management";
            DataClassification = CustomerContent;
        }
        field(113; "Nationality"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(114; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(115; "Captured By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(116; "Date Captured"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(117; "Current Month Filter"; Date)
        {
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Pr Payroll Period"."Date Opened";
        }
        field(118; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            TableRelation = Member;
        
            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin


            end;
        }

    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        MembNoSeries.Get();
        if "No." = '' then begin
            
            MembNoSeries.TestField("Employee Nos.");
            "No. Series" := MembNoSeries."Employee Nos.";
            if NoSeriesMgt.AreRelated(MembNoSeries."Employee Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;
    end;

    trigger OnDelete()
    begin


    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin


    end;

    var
        MembNoSeries: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        PostCode: Record "Post Code";
        ApprovlsMgt: Codeunit "Approval Mgmt.";

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"HR Employees", "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    local procedure PassDocumentNo()
    var
        ExemptionsApprvl: Record "User Setup";
        PFact: Record "Product Factory";
        ObjectEmp: Record Employee;
    begin

        ExemptionsApprvl.Get(UserId);
        ExemptionsApprvl.TestField("Responsibility Centre");
        ExemptionsApprvl.TestField("Global Dimension 1 Code");
        ExemptionsApprvl.TestField("Global Dimension 2 Code");

        "Responsibility Centre" := ExemptionsApprvl."Responsibility Centre";
        "Global Dimension 1 Code" := ExemptionsApprvl."Global Dimension 1 Code";
        "Global Dimension 2 Code" := ExemptionsApprvl."Global Dimension 2 Code";
        "Captured By" := UserId;
        "Date Captured" := Today;
    end;

    local procedure NameBreakdownTxt()
    var
        NamePart: array[30] of Text[100];
        TempName: Text[250];
        FirstName250: Text[250];
        i: Integer;
        NoOfParts: Integer;
    begin

        TempName := Name;
        while StrPos(TempName, ' ') > 0 do begin
            if StrPos(TempName, ' ') > 1 then begin
                i := i + 1;
                NamePart[i] := CopyStr(TempName, 1, StrPos(TempName, ' ') - 1);
            end;
            TempName := CopyStr(TempName, StrPos(TempName, ' ') + 1);
        end;
        i := i + 1;
        NamePart[i] := CopyStr(TempName, 1, MaxStrLen(NamePart[i]));
        NoOfParts := i;

        "First Name" := '';
        "Middle Name" := '';
        "Last Name" := '';
        for i := 1 to NoOfParts do
            if (i = NoOfParts) and (NoOfParts > 1) then
                "Last Name" := CopyStr(NamePart[i], 1, MaxStrLen("Last Name"))
            else
                if (i = NoOfParts - 1) and (NoOfParts > 2) then
                    "Middle Name" := CopyStr(NamePart[i], 1, MaxStrLen("Middle Name"))
                else begin
                    FirstName250 := DelChr("First Name" + ' ' + NamePart[i], '<', ' ');
                    "First Name" := CopyStr(FirstName250, 1, MaxStrLen("First Name"));
                end;

    end;

    procedure fnCheckMinReqment()
    begin
        TestField(Name);
        TestField("ID No.");
        TestField("Date of Join");
        TestField("Date Of Birth");
        TestField("User ID");
        TestField("Department Code");
        TestField("Posting Group");
        TestField("PIN No.");
        TestField("NSSF No.");
        TestField("NHIF No.");
        TestField("Supervisor Code");

    end;

    procedure fnApprovalRequest(AcItem: Enum ActionPanesItems)
    begin
        case AcItem of
            AcItem::"Send Approval Request":
                begin
                    fnCheckMinReqment();
                    ApprovlsMgt.OnSendHrEmployeeAppRequest(Rec);
                end;
            AcItem::"Cancel Approval Request":
                ApprovlsMgt.OnCancelHrEmployeeApprovalRequest(Rec, true, true);
            AcItem::"Open Request":
                ApprovlsMgt.OnOpenHrEmployeeApprovalRequest(Rec, true, true);
            AcItem::Approvals:
                ApprovlsMgt.OpenApprovalEntriesPage(Rec."No.", Database::"HR Employees");
            AcItem::Delegate:
                ApprovlsMgt.findDelegatedApprovalEntry(Rec."No.");
        end;

    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeOnValidate(var Rec: Record "Hr Employees"; var xRec: Record "Hr Employees"; IsHandled: Boolean)
    begin

    end;

    procedure CopyFromHrEmployee(RecRef: Record Employee)
    var
        emplPostgroup: Record "Pr Employee Posting Group";
    begin
        emplPostgroup.Get('PAYROLL');

        RecRef.TestField("Birth Date");
        RecRef.TestField("Date Of Join");
        "No." := RecRef."No.";
        Validate(Name, RecRef."First Name" + ' ' + RecRef."Middle Name" + ' ' + RecRef."Last Name");
        "Date Of Birth" := RecRef."Birth Date";
        "Date of Join" := RecRef."Date Of Join";
        "E-Mail" := RecRef."E-Mail";
        "Company E-Mail" := RecRef."Company E-Mail";
        "Job ID" := RecRef."Job Title";
        "Job Title" := RecRef."Job Position";
        "Phone No." := RecRef."Phone No.";
        "Mobile Phone No." := RecRef."Mobile Phone No.";
        Status := RecRef.Status;
        "NHIF No." := RecRef."NHIF No";
        "PIN No." := RecRef."PIN Number";
        "Social Security No." := RecRef."Social Security No.";
        "Contract Type" := RecRef."Emplymt. Contract Code";
        "Country Code" := RecRef."Country/Region Code";
        Nationality := RecRef."Country/Region Code";
        "Department Code" := RecRef."Responsibility Center";
        "Responsibility Centre" := RecRef."Responsibility Center";
        "Member No." := RecRef."BOSA Member No.";
        "Salary Grade" := RecRef."Salary Scale";
        "Salary Notch/Step" := RecRef."Present Pointer";
        "Posting Group" := emplPostgroup.Code;
        "Global Dimension 1 Code" := RecRef."Global Dimension 1 Code";
        "Global Dimension 2 Code" := RecRef."Global Dimension 2 Code";

    end;
}
