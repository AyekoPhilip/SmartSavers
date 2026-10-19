page 50794 "Next of KIN"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Next of KIN";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No"; Rec."Account No")
                {
                    Caption = 'Member No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No field.';
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ValidateEdit;
                    end;
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = All;
                }
                field(Beneficiary; Rec.Beneficiary)
                {
                    ApplicationArea = All;
                }
                field("Kin Type"; Rec."Kin Type")
                {

                }
                field(Guardian; Rec.Guardian)
                {

                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = All;
                }
                field(Fax; Rec.Fax)
                {
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                }
                field(Allocation; Rec.Allocation)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("BBF Entitlement Code"; Rec."BBF Entitlement Code")
                {
                    ApplicationArea = All;
                }
                field("BBF Entitlement"; Rec."BBF Entitlement")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        ValidateEdit;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ValidateEdit;
    end;

    trigger OnOpenPage()
    begin
        ValidateAccess;
    end;


    procedure ValidateAccess()
    begin
        /*IF NOT(USERID='ERP\PORTAL')THEN BEGIN
        StatusPermission.RESET;
        StatusPermission.SETRANGE("User ID",USERID);
        StatusPermission.SETRANGE("View Next of Kin",TRUE);
        IF NOT StatusPermission.FIND('-') THEN BEGIN
         ERROR(ErrorOnRestrictViewTxt);
          END;
          END;
          */

    end;


    procedure ValidateEdit()
    begin
        /*IF NOT(USERID='ERP\PORTAL')THEN BEGIN
        StatusPermission.RESET;
        StatusPermission.SETRANGE("User ID",USERID);
        StatusPermission.SETRANGE("Edit Next of Kin",TRUE);
        IF NOT StatusPermission.FIND('-') THEN BEGIN
         ERROR(ErrorOnRestrictViewTxt);
          END;
        END;
        */

    end;
}




