table 50366 "Fixed Deposit Type"
{
    DrillDownPageID = "Fixed Deposit Type List";
    LookupPageID = "Fixed Deposit Type List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[10])
        {
            NotBlank = true;
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Duration"; DateFormula)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
        }
        field(50011; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "No. of Months"; Integer)
        {
            Caption = 'No. of Months';
            DataClassification = CustomerContent;
        }
        field(50013; "Interest Method"; Option)
        {
            OptionCaption = ' ,Compound,Simple';
            OptionMembers = " ","Compound","Simple";
            Caption = 'Interest Method';
            DataClassification = CustomerContent;
        }
        field(50014; "Call Deposit"; Boolean)
        {
            Caption = 'Call Deposit';
            DataClassification = CustomerContent;
        }
        field(50015; "Notification"; Option)
        {
            Description = 'Blank,Email,Notification,SMS';
            OptionCaption = ' ,Email,Notification,SMS';
            OptionMembers = " ","Email","Notification","SMS";
            Caption = 'Notification';
            DataClassification = CustomerContent;
        }
        field(50016; "Notification Period"; Integer)
        {
            Caption = 'Notification Period(Days)';
            Description = 'How many days before maturing';
            DataClassification = CustomerContent;
        }
        field(50017; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
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
        RestrictAccess(UserId);
    end;

    trigger OnInsert()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnModify()
    begin
        RestrictAccess(UserId)
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




