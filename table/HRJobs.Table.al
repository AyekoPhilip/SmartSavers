using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Location;
table 50062 "HR Jobs"
{
    Caption = 'Jobs';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Job ID"; Code[10])
        {
            Caption = 'Job ID';
        }
        field(50010; "Job Description"; Text[100])
        {
            Caption = 'Job Description';
        }
        field(50011; "No. Of Posts"; Integer)
        {
            Caption = 'No. Of Posts';
        
            trigger OnValidate()
            begin

                if "No. of Posts" <> xRec."No. of Posts" then
                    "Vacant Positions" := ("No. of Posts" - "Occupied Position");

                if "No. of Posts" <= 0 then
                    Error('No of posts cannot be less than 1');
            end;
        }
        field(50012; "Position Reporting To"; Code[50])
        {
            Caption = 'Position Reporting To';
            TableRelation = "HR Jobs"."Job ID" where(Status = filter(Approved));
        
            trigger OnValidate()
            begin

            end;
        }
        field(50013; "Occupied Position"; Integer)
        {
            Caption = 'Occupied Position';
        }
        field(50014; "Vacant Positions"; Decimal)
        {
            Caption = 'Vacant Positions';
        
            trigger OnValidate()
            begin
                "Vacant Positions" := "No. of Posts" - "Occupied Position";
            end;
        }
        field(50015; "Score Code"; Code[10])
        {
            Caption = 'Score Code';
        }
        field(50016; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code")
            end;
        }
        field(50017; "Global Dimension 2 Code"; Code[10])
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
        field(50018; "Total Score"; Decimal)
        {
            Caption = 'Total Score';
        }
        field(50019; "Main Objective"; Text[100])
        {
            Caption = 'Main Objective';
        }
        field(50020; "Key Position"; Boolean)
        {
            Caption = 'Key Position';
        }
        field(50021; "Category"; Code[10])
        {
            Caption = 'Category';
        }
        field(50022; "Grade"; Code[10])
        {
            Caption = 'Grade';
            TableRelation = "Pr Salary Grade";
        }
        field(50023; "Employee Requisition"; Integer)
        {
            Caption = 'Employee Requisition';
        }
        field(50024; "User ID"; Code[100])
        {
            Caption = 'User ID';
        }
        field(50025; "Supervisor/Manager"; Code[50])
        {
            Caption = 'Supervisor/Manager';
            TableRelation = "HR Jobs"."Job ID" where(Status = filter(Approved));
        }
        field(50026; "Status"; Enum "ApprovalStatus")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(50027; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(50028; "No. of Requirements"; Integer)
        {
            Caption = 'No. of Requirements';
        }
        field(50029; "No. of Responsibilities"; Integer)
        {
            Caption = 'No. of Responsibilities';
        }
        field(50030; "Is Supervisor"; Boolean)
        {
            Caption = 'Is Supervisor';
        }
        field(50031; "G/L Account"; Code[10])
        {
            Caption = 'G/L Account';
        }
        field(50032; "Responsibility Centre"; Code[10])
        {
            Caption = 'Responsibility Centre';
            TableRelation = "Responsibility Center";
        }
    }
    keys
    {
        key("PK"; "Job ID")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Date Created" := Today;
    end;

    trigger OnRename()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

        TestField(Status, Status::Open);
        HRJobRequirements.Reset();
        HRJobRequirements.SetRange("Job ID", "Job ID");
        HRJobRequirements.DeleteAll();

        HRJobResponsiblities.Reset();
        HRJobResponsiblities.SetRange("Job ID", "Job ID");
        HRJobResponsiblities.DeleteAll();

    end;

    var
        DimMgt: Codeunit DimensionManagement;
        HRJobRequirements: Record "HR Job Requirements";
        HRJobResponsiblities: Record "HR Job Responsibility";

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"HR Jobs", "Job ID", FieldNumber, ShortcutDimCode);
        Modify;
    end;
}
