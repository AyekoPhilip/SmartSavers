table 50406 "Appraisal Salary Set-up"
{
    DrillDownPageID = "Appraisal Salary Set-up";
    LookupPageID = "Appraisal Salary Set-up";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            NotBlank = true;
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Type"; Enum "AppraisalSalaryDetailsOptions")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Auto Computed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //RestrictAccess(USERID);
    end;

    trigger OnModify()
    begin
        //RestrictAccess(USERID)
    end;

    trigger OnRename()
    begin
        //RestrictAccess(USERID);
    end;


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Setup", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




