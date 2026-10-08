page 50694 "Account Activation"
{
    Caption = 'Account Activation';
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
                    ValuesAllowed = 5, 6, 7, 11;
                    trigger OnValidate()

                    begin
                        case Rec."Changes Type" of
                            Rec."Changes Type"::" ",
                        rec."Changes Type"::Images,
                        rec."Changes Type"::"Kin Details",
                        Rec."Changes Type"::"Membership Details",
                        Rec."Changes Type"::"Account Signatories":
                                Error('The Option selected is not allowed');
                        end
                    end;
                }

                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        CustMember: Record Member;
                    begin
                        if CustMember.Get(Rec."Member No.") then
                            Rec.Name := CustMember.Name;
                    end;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }

                field("Operation Type"; Rec."Operation Type")
                {
                    ToolTip = 'Specifies the value of the Operation Type field.';
                    Enabled = Rec."Changes Type" <> Rec."Changes Type"::"Deceased Account";
                    ApplicationArea = All;

                }
                
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Enabled = Rec."Operation Type"=Rec."Operation Type"::"Single Account";
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    Enabled = Rec."Changes Type" <> Rec."Changes Type"::"Deceased Account";
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type. field.';
                    Enabled = Rec."Changes Type" <> Rec."Changes Type"::"Deceased Account";
                    ApplicationArea = All;
                }
                field("Resons for Status Change"; Rec."Resons for Status Change")
                {
                    ApplicationArea = All;

                }
            }
            group("Trail Information")
            {
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Action31)
            {

                action("Post Changes")
                {
                    Image = MarketingSetup;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RegistrationProcess: Codeunit "Registry Mngt.";
                        GeneralSetUp: Record "General Set-Up";
                    begin

                        GeneralSetUp.Get();
                        case GeneralSetUp."Post Application As" of
                            GeneralSetUp."Post Application As"::"Post as User":
                                begin
                                    if Confirm('Are you want to Activate account(s)?', true) = false then exit;
                                    RegistrationProcess.fnAccountActivateDeactivate(Rec);
                                    CurrPage.Close();
                                end;
                        end;
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
                        Rec.TestField("Resons for Status Change");
                        if Rec."Operation Type" = Rec."Operation Type"::"Single Account" then begin
                            Rec.TestField("Account No.");
                            Rec.TestField("Account Type");
                        end else begin
                            Rec.TestField("Member No.")
                        end;
                        ApprovalsMgmt.OnSendChangesAppRequest(Rec);
                        CurrPage.Close();

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
                        ApprovalsMgmt.OnCancelChangesApprovalRequest(Rec, true, true);
                        CurrPage.Close();

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
                        ApprovalsMgmt.OnOpenChangesApprovalRequest(Rec, true, true);
                        CurrPage.Close();

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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50413);

                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Post Changes_Promoted"; "Post Changes")
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
        Rcpt.SetRange("Document Type", rec."Document Type"::"Account Activation");
        Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
        if Rcpt.Count > temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnTxtUnpApplic);
        end;
        Rec."Document Type" := Rec."Document Type"::"Account Activation";
        Rec."Operation Type" := Rec."Operation Type"::"Single Account";
        Rec."Account Type" := Rec."Account Type"::Banking;

    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

}



