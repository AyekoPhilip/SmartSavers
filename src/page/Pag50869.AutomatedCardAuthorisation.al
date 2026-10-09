page 50869 "Automated Card Authorisation"
{
    Caption = 'Automated Card Authorisation';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "Member Changes";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Changes Type"; Rec."Changes Type")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    Caption = 'Type';
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    trigger OnValidate()
                    begin
                        case Rec."Changes Type" of
                            rec."Changes Type"::" ",
                        rec."Changes Type"::Images,
                        rec."Changes Type"::"Kin Details",
                        Rec."Changes Type"::"Membership Details",
                        Rec."Changes Type"::"Account Signatories":
                                Error('The Option selected is not allowed');
                        end
                    end;
                }
                field("Application Reason"; Rec."Application Reason")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    trigger OnValidate()
                    var
                        CustMember: Record Member;
                        Account: Record "Account Banking";
                    begin
                        if Rec."Document Type" = Rec."Document Type"::"Card Link" then begin
                            if CustMember.Get(Rec."Member No.") then
                                Rec.Name := CustMember.Name;
                            Account.Reset();
                            Account.SetRange("Member No.", Rec."Member No.");
                            Account.SetRange("Account Category", Account."Account Category"::Savings);
                            if Account.FindFirst() then begin
                                Rec."Account No." := Account."No.";
                                if Rec."Application Reason" = Rec."Application Reason"::"Block Card" then begin
                                    Rec."ATM Card No." := Account."ATM No.";
                                    Rec."Expiry Date (Card)" := Account."Expiry Date (Card)";
                                end;
                            end;
                        end;

                    end;

                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

                field("Operation Type"; Rec."Operation Type")
                {
                    ToolTip = 'Specifies the value of the Operation Type field.';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("ATM Card No."; Rec."ATM Card No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("ATM Provision No."; Rec."ATM Provision No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    Editable = false;

                }
                field("Expiry Date (Card)"; Rec."Expiry Date (Card)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = true;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }

                field("Resons for Status Change"; Rec."Resons for Status Change")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }

            }
            group("Trail Information")
            {
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control21; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control33; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Action31)
            {
                action(Post)
                {
                    Image = MarketingSetup;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RegistrationProcess: Codeunit "Registry Mngt.";
                        AltChannelMngt: Codeunit "Alt. Channel (Mobile Mngt.)";
                        EndMessageTxt: Text[100];
                        RegmntAcc: Record "Account (Procedure)";
                        FosaAcc: Record "Account Banking";
                        ErrorMsg: Label 'No card No. attached to application found';
                        ErrorOnMissingAcTxt: Label 'No related Account attached to this application';
                    begin
                        case Rec."Application Reason" of
                            Rec."Application Reason"::"New Application",
                            Rec."Application Reason"::Renewal,
                            Rec."Application Reason"::Replacement:
                                begin
                                    Rec.TestField("Account No.");
                                    Rec.TestField("Account Type");
                                    Rec.TestField("Resons for Status Change");
                                    Rec.TestField("Application Reason");
                                    Rec.TestField("ATM Card No.");
                                    Rec.TestField("Expiry Date (Card)");
                                    Rec.TestField("Transaction Type");
                                    if Confirm('Are you want to link ATM to account(s)?', true) = false then exit;
                                    RegistrationProcess.PostCardLink(Rec);
                                end;
                            Rec."Application Reason"::"Block Card":
                                begin
                                    Rec.TestField("Account No.");
                                    Rec.TestField("Account Type");
                                    Rec.TestField("Resons for Status Change");
                                    Rec.TestField("Application Reason");
                                    Rec.TestField("ATM Card No.");

                                    if Confirm('Are you want to Block this ATM Card?', true) = false then exit;

                                    FosaAcc.Reset();
                                    FosaAcc.SetRange(status, FosaAcc.Status::Active);
                                    FosaAcc.SetRange(FosaAcc."ATM No.", Rec."ATM Card No.");
                                    FosaAcc.SetRange("Account Category", FosaAcc."Account Category"::Savings);
                                    if FosaAcc.FindFirst() then begin
                                        if Rec."Expiry Date (Card)" <> 0D then begin
                                            if FosaAcc."Expiry Date (Card)" <= Today then
                                                Error('Card Expiry Date cannot be less than or equals to Today');
                                        end;

                                        RegmntAcc.Reset();
                                        RegmntAcc.SetRange("No.", FosaAcc."No.");
                                        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
                                        if RegmntAcc.FindFirst() then begin
                                            EndMessageTxt := AltChannelMngt.CardBlockMngt(FosaAcc."ATM No.");
                                            if CopyStr(EndMessageTxt, 1, 2) = '00' then begin
                                                Rec."Approval Status" := Rec."Approval Status"::Posted;
                                                Rec."Posted By" := UserId;
                                                Rec."Date Posted" := CurrentDateTime;
                                                Rec.Modify(true);
                                                Message(EndMessageTxt);
                                            end else begin
                                                Message(EndMessageTxt);
                                            end;
                                        end else begin
                                            Error(ErrorOnMissingAcTxt);
                                        end;
                                    end else begin
                                        Error(ErrorMsg);
                                    end;
                                end;

                            Rec."Application Reason"::"Unblock Card":
                                begin
                                    Rec.TestField("Account No.");
                                    Rec.TestField("Account Type");
                                    Rec.TestField("Resons for Status Change");
                                    Rec.TestField("Application Reason");

                                    if Confirm('Are you want to unblock this ATM Card?', true) = false then exit;
                                    FosaAcc.Reset();
                                    FosaAcc.SetRange("No.", Rec."Account No.");
                                    FosaAcc.SetRange(status, FosaAcc.Status::Active);
                                    FosaAcc.SetRange("Account Category", FosaAcc."Account Category"::Savings);
                                    if FosaAcc.FindFirst() then begin
                                        if Rec."Expiry Date (Card)" <> 0D then begin
                                            if FosaAcc."Expiry Date (Card)" <= Today then
                                                Error('Card Expiry Date cannot be less than or equals to Today');
                                        end;

                                        RegmntAcc.Reset();
                                        RegmntAcc.SetRange("No.", FosaAcc."No.");
                                        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
                                        if RegmntAcc.FindFirst() then begin
                                            EndMessageTxt := AltChannelMngt.CardUnBlockMngt(FosaAcc."ATM No.");
                                            if CopyStr(EndMessageTxt, 1, 2) = '00' then begin
                                                Rec."Approval Status" := Rec."Approval Status"::Posted;
                                                Rec."Posted By" := UserId;
                                                Rec."Date Posted" := CurrentDateTime;
                                                Rec.Modify(true);
                                                Message(EndMessageTxt);
                                            end else begin
                                                Message(EndMessageTxt);
                                            end;
                                        end else begin
                                            Error(ErrorOnMissingAcTxt);
                                        end;
                                    end else begin
                                        Error(ErrorMsg);
                                    end;

                                end;
                        end;
                        CurrPage.Close();
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                        NextofKinError: Label 'You must specify next of Kin for this application.';
                    begin
                        case Rec."Changes Type" of
                            rec."Changes Type"::" ",
                        rec."Changes Type"::Images,
                        rec."Changes Type"::"Kin Details",
                        Rec."Changes Type"::"Membership Details",
                        Rec."Changes Type"::"Account Signatories":
                                Error('The Option selected is not allowed');
                        end;

                        case Rec."Application Reason" of
                            Rec."Application Reason"::"New Application",
                            Rec."Application Reason"::Renewal,
                            Rec."Application Reason"::Replacement:
                                begin
                                    Rec.TestField("Account No.");
                                    Rec.TestField("Account Type");
                                    Rec.TestField("Resons for Status Change");
                                    Rec.TestField("Application Reason");
                                    Rec.TestField("ATM Card No.");
                                    Rec.TestField("Transaction Type");
                                end;
                            Rec."Application Reason"::"Block Card":
                                begin
                                    Rec.TestField("Account No.");
                                    Rec.TestField("Account Type");
                                    Rec.TestField("Resons for Status Change");
                                    Rec.TestField("Application Reason");
                                    Rec.TestField("ATM Card No.");
                                end;
                            Rec."Application Reason"::"Unblock Card":
                                begin
                                    Rec.TestField("Account No.");
                                    Rec.TestField("Account Type");
                                    Rec.TestField("Resons for Status Change");
                                    Rec.TestField("Application Reason");
                                end;
                        end;
                        ApprovalsMgmt.OnSendChangesAppRequest(Rec)
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelChangesApprovalRequest(Rec, true, true)

                    end;
                }
                action(OpenApprovalRequest)
                {
                    Caption = 'Open Approval Re&quest';
                    Image = Category;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        ApprovalsMgmt.OnOpenChangesApprovalRequest(Rec, true, true)

                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approval;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147197);

                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Post_Promoted; Post)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref(OpenApprovalRequest_Promoted; OpenApprovalRequest)
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
        }

    }
    trigger OnAfterGetRecord()
    var
        NewStr: Code[30];
        Str: Code[30];

    begin

        NewStr := '';
        if Rec."Approval Status" = Rec."Approval Status"::Posted then begin
            if StrLen(Rec."ATM Card No.") > 4 then begin
                Str := (CopyStr(Rec."ATM Card No.", StrLen(Rec."ATM Card No.") - 3, 4));
                NewStr := 'xxxxxxxx' + Str;
            end;
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Rcpt: Record "Member Changes";
        ErrorOnTxtUnpApplic: Label 'There are still some unprocessed application. Please utilise them first';
        Temp: Record "User Setup";
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");
        Rcpt.Reset;
        Rcpt.SetRange("Created By", UserId);
        Rcpt.SetRange("Document Type", rec."Document Type"::"Card Link");
        Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
        if Rcpt.Count > 3 then begin
            Error(ErrorOnTxtUnpApplic);
        end;
        Rec."Document Type" := Rec."Document Type"::"Card Link";
        Rec."Operation Type" := Rec."Operation Type"::"Single Account";
        Rec."Account Type" := Rec."Account Type"::Banking;
        Rec."Product Type" := Rec."Product Type"::Savings;
        Rec."Changes Type" := Rec."Changes Type"::"Card Link";
    end;

    trigger OnOpenPage()
    begin
        IF Rec."Approval Status" <> Rec."Approval Status"::Open
        THEN
            CurrPage.EDITABLE := FALSE;
    end;

}




