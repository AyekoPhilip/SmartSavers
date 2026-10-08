pageextension 50018 "GeneralJournalPageExt" extends "General Journal"
{
    layout
    {
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("External Document No.")
        {
            Visible = true;
        }
        modify(Applied)
        {
            Visible = true;
        }
        modify("Applies-to Doc. No.")
        {
            Visible = true;
        }
        modify("Applies-to ID")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;

        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        addafter(Amount)
        {
            field("Loan No."; Rec."Loan No.")
            {
                ToolTip = 'Specifies the value of the Loan No. field.';
                ApplicationArea = All;
            }
            field("Transaction Type"; Rec."Transaction Type")
            {
                ToolTip = 'Specifies the value of the Transaction Type field.';
                ApplicationArea = All;
            }
        }
        addbefore("Account Type")
        {
            field("Account Dimension"; Rec."Account Dimension")
            {
                ToolTip = 'Specifies the value of the Dimension of account.';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    trigger OnOpenPage()
    begin
        
        if not DoctMngt.PostJournalMngt(UserId) then
            Error(MsgOnPermissionTxt);
        DoctMngt.fnCheckCurrentRespBatchName(UserId, Rec."Journal Batch Name", Rec."Journal Template Name");

    end;

    trigger OnAfterGetRecord()
    begin
        

    end;

    trigger OnClosePage()
    begin

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

    end;

    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnRespUserIDTxt: Label 'You do not have the following Permission on this page: Batch Attached to %1. Current Value is %2';
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
}


