table 50348 "Status Change Permissions"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "User ID"; Code[80])
        {
            Caption = 'User ID.';
            TableRelation = "User Setup"."User ID";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Temp.Get("User ID");

                Temp.TestField("Responsibility Centre");
                Temp.TestField("Global Dimension 1 Code");
                Temp.TestField("Global Dimension 2 Code");

                "Responsibility Centre" := Temp."Responsibility Centre";
                "Shortcut Dimension 1 Code" := Temp."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := Temp."Global Dimension 2 Code";
            end;
        }
        field(50010; "Function"; Enum "Change Status")
        {
            NotBlank = false;
            Caption = 'Function';
            DataClassification = CustomerContent;
        }
        field(50011; "User ID No."; Code[80])
        {
            Caption = 'User ID No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Function Extended"; Enum "Change Status")
        {
            NotBlank = false;
            Caption = 'Function Extended';
            DataClassification = CustomerContent;
        }
        field(50013; "View Payroll"; Boolean)
        {
            Caption = 'View Payroll';
            DataClassification = CustomerContent;
        }
        field(50014; "Edit Payroll"; Boolean)
        {
            Caption = 'Edit Payroll';
            DataClassification = CustomerContent;
        }
        field(50015; "View Setup"; Boolean)
        {
            Caption = 'View Setup';
            DataClassification = CustomerContent;
        }
        field(50016; "Edit Setup"; Boolean)
        {
            Caption = 'Edit Setup';
            DataClassification = CustomerContent;
        }
        field(50017; "View G/L Account"; Boolean)
        {
            Caption = 'View G/L Account';
            DataClassification = CustomerContent;
        }
        field(50018; "Edit  G/L Account"; Boolean)
        {
            Caption = 'Edit  G/L Account';
            DataClassification = CustomerContent;
        }
        field(50019; "Edit Member Changes"; Boolean)
        {
            Caption = 'Edit Member Changes';
            DataClassification = CustomerContent;
        }
        field(50020; "View Employee Record"; Boolean)
        {
            Caption = 'View Employee Record';
            DataClassification = CustomerContent;
        }
        field(50021; "Edit Employee Record"; Boolean)
        {
            Caption = 'Edit Employee Record';
            DataClassification = CustomerContent;
        }
        field(50022; "Block account"; Boolean)
        {
            Caption = 'Block account';
            DataClassification = CustomerContent;
        }
        field(50023; "Unblock Account"; Boolean)
        {
            Caption = 'Unblock Account';
            DataClassification = CustomerContent;
        }
        field(50024; "Cheque Writting"; Boolean)
        {
            Caption = 'Cheque Writting';
            DataClassification = CustomerContent;
        }
        field(50025; "Edit Data Sheet"; Boolean)
        {
            Caption = 'Edit Data Sheet';
            DataClassification = CustomerContent;
        }
        field(50026; "View Data Sheet"; Boolean)
        {
            Caption = 'View Data Sheet';
            DataClassification = CustomerContent;
        }
        field(50027; "Full Name"; Text[30])
        {
            Editable = false;
            Caption = 'Full Name';
            DataClassification = CustomerContent;
        }
        field(50028; "Email Address"; Code[20])
        {
            Editable = false;
            Caption = 'Email Address';
            DataClassification = CustomerContent;
        }
        field(50029; "Responsibility Centre"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50030; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(50031; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(50032; "Post Dividends"; Boolean)
        {
            Caption = 'Post Dividends';
            DataClassification = CustomerContent;
        }
        field(50033; "View Next of Kin"; Boolean)
        {
            Caption = 'View Next of Kin';
            DataClassification = CustomerContent;
        }
        field(50034; "Edit Next of Kin"; Boolean)
        {
            Caption = 'Edit Next of Kin';
            DataClassification = CustomerContent;
        }
        field(50035; "Upload Old Loans"; Boolean)
        {
            Caption = 'Upload Old Loans';
            DataClassification = CustomerContent;
        }
        field(50036; "Edit Vendor"; Boolean)
        {
            Caption = 'Edit Vendor';
            DataClassification = CustomerContent;
        }
        field(50037; "View Edit"; Boolean)
        {
            Caption = 'View Edit';
            DataClassification = CustomerContent;
        }
        field(50038; "Edit Customer"; Boolean)
        {
            Caption = 'Edit Customer';
            DataClassification = CustomerContent;
        }
        field(50039; "View Customer"; Boolean)
        {
            Caption = 'View Customer';
            DataClassification = CustomerContent;
        }
        field(50040; "Edit Journal"; Boolean)
        {
            Caption = 'Edit Journal';
            DataClassification = CustomerContent;
        }
        field(50041; "Update Rejoining Member"; Boolean)
        {
            Caption = 'Update Rejoining Member';
            DataClassification = CustomerContent;
        }
        field(50042; "Edit Monthly Remittance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "User ID")
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
        //RestrictAccess(USERID);
    end;

    trigger OnModify()
    begin
        //RestrictAccess(USERID);
    end;

    var
        Temp: Record "User Setup";


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




