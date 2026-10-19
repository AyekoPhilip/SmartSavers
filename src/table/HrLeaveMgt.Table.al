namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.NoSeries;
using Microsoft.HumanResources.Employee;
using System.Security.User;
using Microsoft.Inventory.Location;
using Microsoft.Finance.Dimension;
table 50003 "Hr Leave Mgt."
{
    Caption = 'Leave Application';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[50])
        {
            Caption = 'No.';
        }
        field(2; "Name"; Text[150])
        {
            Caption = 'Name';
        }
        field(3; "Leave Type"; Code[20])
        {
            Caption = 'Leave Type';
            TableRelation = "Hr Leave Type";
        }
        field(4; "Days Applied"; Decimal)
        {
            Caption = 'Days Applied';
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
        }
        field(7; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
        }
        field(8; "Applicant Comment"; Text[150])
        {
            Caption = 'Applicant Comment';
        }
        field(9; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
        }
        field(10; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(11; "Selected"; Boolean)
        {
            Caption = 'Selected';
        }
        field(12; "Current Balance"; Decimal)
        {
            Caption = 'Current Balance';
        }
        field(13; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            TableRelation = "User Setup"."User ID";
        }
        field(14; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
        }
        field(15; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
        }
        field(16; "Reimbursed"; Boolean)
        {
            Caption = 'Reimbursed';
        }
        field(17; "Days Reimbursed"; Decimal)
        {
            Caption = 'Days Reimbursed';
        }
        field(18; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(19; "Total Taken"; Decimal)
        {
            Caption = 'Total Taken';
        }
        field(20; "Leave Allowance Entittlement"; Boolean)
        {
            Caption = 'Leave Allowance Entittlement';
        }
        field(21; "Leave Allowance Amount"; Decimal)
        {
            Caption = 'Leave Allowance Amount';
        }
        field(22; "Details of Examination"; Text[150])
        {
            Caption = 'Details of Examination';
        }
        field(23; "Date of Exam"; Date)
        {
            Caption = 'Date of Exam';
        }
        field(24; "Reliever"; Code[50])
        {
            Caption = 'Reliever';
            TableRelation = "HR Employees"."No." where(Status = filter(Active));
        
            trigger OnValidate()
            begin
                if ObjtEmp.Get(Reliever) then "Reliever Name" := ObjtEmp.Name;

            end;
        }
        field(25; "Reliever Name"; Text[150])
        {
            Caption = 'Reliever Name';
            Editable = false;
        }
        field(26; "Description"; Text[150])
        {
            Caption = 'Description';
        }
        field(27; "Supervisor Email"; Code[100])
        {
            Caption = 'Supervisor Email';
        }
        field(28; "Job Title"; Code[50])
        {
            Caption = 'Job Title';
        }
        field(29; "Applicant User ID"; Code[100])
        {
            Caption = 'Applicant User ID';
            TableRelation = "User Setup"."User ID";
        }
        field(30; "Applicant Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            Editable = false;
            TableRelation = "Hr Employees"."No." where(Status = filter(Active));
        
            trigger OnValidate()
            begin
                if ObjtEmp.Get("Applicant Staff No.") then begin
                    Name := ObjtEmp.Name
                end;
            end;
        }
        field(31; "Applicant Supervisor"; Code[100])
        {
            Caption = 'Applicant Supervisor';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(32; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(33; "Approved Days"; Integer)
        {
            Caption = 'Approved Days';
        }
        field(34; "Emergency"; Boolean)
        {
            Caption = 'Emergency';
        }
        field(35; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(36; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
        }
        field(37; "Alternative CellPhone No."; Code[20])
        {
            Caption = 'Alternative CellPhone No.';
            Editable = false;
        }
        field(38; "Supervisor No."; Code[100])
        {
            Caption = 'Supervisor No.';
            TableRelation = "Hr Employees"."No." where(Status = filter(Active));
        }
        field(39; "Allocation Days"; Decimal)
        {
            Caption = 'Allocation Days';
        }
        field(40; "Total Leave Days"; Decimal)
        {
            Caption = 'Total Leave Days';
        }
        field(41; "Total Leave Taken"; Decimal)
        {
            Caption = 'Total Leave Taken';
        }
        field(42; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(43; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
        field(44; "Date Created"; Date)
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
        field(45; "Time Created"; Time)
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
    
        field(46; "Request Leave Allowance"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
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
        if "No." = '' then begin
            HrSetupMgt.Get();
            HrSetupMgt.TestField("Leave Application Nos.");
            "No. Series" := HrSetupMgt."Leave Application Nos.";
            if NoSeriesMgt.AreRelated(HrSetupMgt."Leave Application Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;

        DocMgt.PassDocumentNo(UserId,
        "Responsibility Center", "Global Dimension 1 Code",
         "Global Dimension 2 Code", "Created By", "Date Created", "Time Created");
        getApplicantDetail();

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    local procedure TestNoSeries()
    var
        LeaveMgt: Record "Hr Leave Mgt.";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not LeaveMgt.Get(Rec."No.") then begin
                HrSetupMgt.Get();
                NoSeriesMgt.TestManual(HrSetupMgt."Leave Application Nos.");
                "No. Series" := '';
            end;
    end;

    procedure getApplicantDetail()
    begin
        Temp.Get(UserId);
        Temp.TestField("Employee No.");
        if ObjtEmp.Get(Temp."Employee No.") then begin
            Validate("Applicant Staff No.", ObjtEmp."No.");
            Gender := ObjtEmp.Gender;
            "Applicant Supervisor" := ObjtEmp."Supervisor Code";
            "Applicant User ID" := UserId;
            "Alternative CellPhone No." := ObjtEmp."Mobile Phone No.";
            "Job Title" := ObjtEmp."Job Title";
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var LeaveMgt: Record "Hr Leave Mgt."; xLeaveMgt: Record "Hr Leave Mgt."; var IsHandled: Boolean)
    begin
    end;

    var
        ObjtEmp: Record "HR Employees";
        HrSetupMgt: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DocMgt: Codeunit "Doc. Mngt";
        ExemptionsApprvl: Record "User Setup";
        HrLeaveMgt: Record "Hr Leave Mgt.";
        Temp: Record "User Setup";

}
