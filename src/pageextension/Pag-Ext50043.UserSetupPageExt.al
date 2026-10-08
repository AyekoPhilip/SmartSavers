pageextension 50043 "UserSetupPageExt" extends "User Setup"
{
    Editable = true;
    layout
    {
        addlast(Control1)
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
            }
            field("Responsibility Centre"; Rec."Responsibility Centre")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;

            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
            }
            field("Post Journals"; Rec."Post Journals")
            {
                ApplicationArea = All;
            }

            field("Allow Posting From [Time]"; Rec."Allow Posting From [Time]")
            {
                ApplicationArea = All;
            }
            field("Allow FA Posting To"; Rec."Allow FA Posting To")
            {
                ApplicationArea = All;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;

            }
            field("Employee No."; Rec."Employee No.")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("User Signature")
            {
                Image = ElectronicDoc;
                RunObject = page "User Signatures";
                RunPageLink = "User ID" = field("User ID");
                ApplicationArea = All;
                ToolTip = 'Executes the User Signature action';
            }
        }
        addfirst(Category_Process)
        {
            actionref("User Signature_Promoted"; "User Signature")
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            CurrPage.Editable := true else
            CurrPage.Editable := false;   
          // if not DoctMngt.RecordRestrictMngt(UserId, Database::"User Setup", FunctionStrng::Administrator) then
          // Error(MsgOnPermissionTxt);  
    end;

    trigger OnModifyRecord(): Boolean
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Approved,
            Rec."Approval Status"::Deffered,
            Rec."Approval Status"::"Pending Approval":
                begin
                    Error('Approval status must be open, the current status is %1', Rec."Approval Status");
                end;
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin

        case Rec."Approval Status" of
            Rec."Approval Status"::Approved,
            Rec."Approval Status"::Deffered,
            Rec."Approval Status"::"Pending Approval":
                begin
                    Error('Approval status must be open, the current status is %1', Rec."Approval Status");
                end;
        end;

    end;

    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
}


