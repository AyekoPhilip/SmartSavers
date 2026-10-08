page 51041 "Banking Template"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Banking User Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Account ID"; Rec."Account ID")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;

                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Max. Deposit Limit"; Rec."Max. Deposit Limit")
                {
                    ApplicationArea = All;
                }
                field("Max. Withdrawal Limit"; Rec."Max. Withdrawal Limit")
                {
                    ApplicationArea = All;
                }
                field("Max. Cashier Withholding"; Rec."Max. Cashier Withholding")
                {
                    ApplicationArea = All;
                }
                field("Min. Balance"; Rec."Min. Balance")
                {
                    ApplicationArea = All;
                }
                field("Reorder Level"; Rec."Reorder Level")
                {
                    ApplicationArea = All;
                }
                field("Default  Bank"; Rec."Default  Bank")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bankers Cheque Account"; Rec."Bankers Cheque Account")
                {
                    ApplicationArea = All;
                }
                field("Excess Account"; Rec."Excess Account")
                {
                    ApplicationArea = All;
                }
                field("Shortage Account"; Rec."Shortage Account")
                {
                    ApplicationArea = All;
                }
                field("Cheque Clearance Account"; Rec."Cheque Clearance Account")
                {
                    ApplicationArea = All;
                }
                field("Supervisor Mobile No."; Rec."Supervisor Mobile No.")
                {
                    ApplicationArea = All;
                }
                field("Supervisor E-Mail"; Rec."Supervisor E-Mail")
                {
                    ApplicationArea = All;
                }
                field("No of Open Transactions"; Rec."No of Open Transactions")
                {
                    ApplicationArea = All;
                }
                field("MPESA Disbursement A/c"; Rec."MPESA Disbursement A/c")
                {
                    ApplicationArea = All;
                }
                field("Cheque Disbursement A/c"; Rec."Cheque Disbursement A/c")
                {
                    ApplicationArea = All;
                }
            }
            group("Banking Templates")
            {
                Caption = 'Banking Templates';
                field("Cashier Journal Template"; Rec."Cashier Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Cashier Journal Batch"; Rec."Cashier Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Treasury Journal Template"; Rec."Treasury Journal Template")
                {
                    ApplicationArea = All;

                }
                field("Treasury Journal Batch"; Rec."Treasury Journal Batch")
                {
                    ApplicationArea = All;

                }
                field("Salary Journal Template"; Rec."Salary Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Salary Journal Batch"; Rec."Salary Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Over Draft Template"; Rec."Over Draft Template")
                {
                    ApplicationArea = All;
                }
                field("Over Draft Batch"; Rec."Over Draft Batch")
                {
                    ApplicationArea = All;
                }
                field("Transfer Journal Template"; Rec."Transfer Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Transfer Journal Batch"; Rec."Transfer Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("ATM Charges Journal Template"; Rec."ATM Charges Journal Template")
                {
                    ApplicationArea = All;
                }
                field("ATM Charges Journal Batch"; Rec."ATM Charges Journal Batch")
                {
                    ApplicationArea = All;
                }

                field("Pr Salary Journal Template"; Rec."Pr Salary Journal Template")
                {
                    ApplicationArea = All;

                }
                field("Pr Salary Journal Batch"; Rec."Pr Salary Journal Batch")
                {
                    ApplicationArea = All;

                }
            }
            group("Credit Templates")
            {
                Caption = 'Credit Templates';
                field("Periodic Journal Template"; Rec."Periodic Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Periodic Journal Batch"; Rec."Periodic Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Loans Template"; Rec."Loans Template")
                {
                    ApplicationArea = All;
                }
                field("Loans Batch"; Rec."Loans Batch")
                {
                    ApplicationArea = All;
                }
                field("Check Off Template"; Rec."Check Off Template")
                {
                    ApplicationArea = All;
                }
                field("Check Off Batch"; Rec."Check Off Batch")
                {
                    ApplicationArea = All;
                }
                field("Bills Template"; Rec."Bills Template")
                {
                    ApplicationArea = All;
                }
                field("Bills Batch"; Rec."Bills Batch")
                {
                    ApplicationArea = All;
                }
                field("Interest Account Template"; Rec."Interest Account Template")
                {
                    ApplicationArea = All;
                }
                field("Interest Account Batch"; Rec."Interest Account Batch")
                {
                    ApplicationArea = All;
                }
                field("Cheque Discounting Template"; Rec."Cheque Discounting Template")
                {
                    ApplicationArea = All;
                }
                field("Cheque Discounting Batch"; Rec."Cheque Discounting Batch")
                {
                    ApplicationArea = All;
                }
                field("Delegates Pay.Journal Template"; Rec."Delegates Pay.Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Delegates Pay. Journal Batch"; Rec."Delegates Pay. Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Accrual. Fee.Journal Template"; Rec."Accrual. Fee.Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Accrual. Fee. Journal Batch"; Rec."Accrual. Fee. Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("STO Journal Template"; Rec."STO Journal Template")
                {
                    ApplicationArea = All;
                }
                field("STO Journal Batch"; Rec."STO Journal Batch")
                {
                    ApplicationArea = All;
                }

                
            }
            group("Alternate Channel")
            {
                field("Default Bank C2B"; Rec."Default Bank C2B")
                {
                    ApplicationArea = All;

                }
                field("Default Bank C2C"; Rec."Default Bank C2C")
                {
                    ApplicationArea = All;

                }
                field("Alt. Journal Template"; Rec."Alt. Journal Template")
                {
                    ApplicationArea = All;

                }
                field("Alt. Journal Batch"; Rec."Alt. Journal Batch")
                {
                    ApplicationArea = All;

                }
                field("Post As"; Rec."Post As")
                {
                    ApplicationArea = All;

                }
                field("Mobile Corporate A/c"; Rec."Mobile Corporate A/c")
                {
                    ApplicationArea = All;

                }
                field("Mobile Transaction In. A/c"; Rec."Mobile Transaction In. A/c")
                {
                    ApplicationArea = All;

                }
                field("Vendor Comms. %"; Rec."Vendor Comms. %")
                {
                    ApplicationArea = All;

                }
                field("Vendor Comms. A/c"; Rec."Vendor Comms. A/c")
                {
                    ApplicationArea = All;

                }
                field("ATM Clearing Account Comms. %"; Rec."ATM Clearing Account Comms. %")
                {
                    ApplicationArea = All;
                }
                field("ATM Fee. %"; Rec."ATM Fee. %")
                {
                    ApplicationArea = All;

                }
                field("Coop Clearing Bank"; Rec."Coop Clearing Bank")
                {
                    ApplicationArea = All;

                }
                
                 field("Default Bank Account (EFT)";Rec."Default Bank Account (EFT)")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control54; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control53; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
    trigger OnModifyRecord(): Boolean
    begin

        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
    end;

    trigger OnAfterGetRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

    end;

    var
        StatusPermission: Record "Status Change Permissions";
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
}




