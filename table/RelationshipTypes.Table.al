table 50354 "Relationship Types"
{
    DrillDownPageID = "Relationship Types";
    LookupPageID = "Relationship Types";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Description"; Text[50])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Min. Age"; Integer)
        {
            Caption = 'Min. Age';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Max. Age" <> 0 then
                    if "Min. Age" > "Max. Age" then
                        Error('The minimum age must be less than %1', "Max. Age");
            end;
        }
        field(50011; "Max. Age"; Integer)
        {
            Caption = 'Max. Age';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Min. Age" <> 0 then
                    if "Max. Age" < "Min. Age" then
                        Error('The maximum age must be greater than %1', "Min. Age");
            end;
        }
        field(50012; "Max. Allowed"; Integer)
        {
            Caption = 'Max. Allowed';
            DataClassification = CustomerContent;
        }
        field(50013; "Principal Child"; Boolean)
        {
            Caption = 'Principal Child';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Description")
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

    trigger OnInsert()
    begin
        //RestrictAccess(USERID)
    end;

    trigger OnModify()
    begin
        //RestrictAccess(USERID)
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




