page 50782 "Next of KIN Application"
{
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PageType = List;
    CardPageId = "Next of Kin Page";
    SourceTable = "Next of KIN Application";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ValuesAllowed = 0, 2;
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Relationship; Rec.Relationship)
                {
                    Editable = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Beneficiary; Rec.Beneficiary)
                {
                    Caption = 'Beneficiary';
                    ApplicationArea = All;
                }
                field(Allocation; Rec.Allocation)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Application No.";Rec."Application No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable=false;

                }
                field("Account No";Rec."Account No")
                {
                    ShowMandatory = true;
                    Editable=false;
                    ApplicationArea = All;

                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        PageControl;
    end;

    trigger OnOpenPage()
    begin
        PageControl;
    end;


    procedure PageControl()
    var
        MemberAppl: Record "Member Application";
    begin
        if MemberAppl.Get(Rec."Account No") then begin
            case MemberAppl."Approval Status" of
                MemberAppl."Approval Status"::"Pending Approval",
                 MemberAppl."Approval Status"::Approved,
                 MemberAppl."Approval Status"::Rejected,
                 MemberAppl."Approval Status"::Posted:
                    begin
                        CurrPage.Editable := false;
                    end;

                MemberAppl."Approval Status"::Open:
                    begin
                        CurrPage.Editable := true;
                    end;
            end;
        end;
    end;

    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("View Next of Kin", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




