page 50061 "Ac Changes Card"
{
    Caption = 'Ac Changes Card';
    PageType = Card;
    SourceTable = "Mc Acc. Changes";
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Changes Type"; Rec."Changes Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Changes Type field.';
                    ValuesAllowed = 5, 12, 16;
                    trigger OnValidate()
                    begin

                        case Rec."Changes Type" of
                            Rec."Changes Type"::"Account Signatories",
                            Rec."Changes Type"::"Block Account",
                            Rec."Changes Type"::"Card Link",
                            Rec."Changes Type"::Contribution,
                            Rec."Changes Type"::"Deceased Account",
                            Rec."Changes Type"::Images,
                            Rec."Changes Type"::"Kin Details",
                            Rec."Changes Type"::Readmission:
                                begin
                                    Error('Option not allowed');
                                end;
                        end;
                    end;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Resons for Status Change"; Rec."Resons for Status Change")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Resons for Status Change field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                

            }
            group("Trail Information")
            {
                Editable = false;
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Application Date field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
        }
        area(factboxes)
        {

            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control14; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control15; Links)
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

                action("Post Changes")
                {
                    Image = MarketingSetup;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RegistrationProcess: Codeunit "Credit. Jnl.-Post Batch";
                    begin
                        VarVariant := Rec;
                        Rec.TestField("Changes Type");
                        Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                        Rec.TestField("Document Type", Rec."Document Type"::"Member Change");
                        Rec.TestField("Account Dimension", Rec."Account Dimension"::Banking);
                        Rec.postCustomerDetails();
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
                        ApprovalsMgmt.OnSendRecordChangesAppRequest(Rec);
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
                        ApprovalsMgmt.OnCancelRecordChangesApprovalRequest(Rec, true, true)
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
                        ApprovalsMgmt.OnOpenRecordChangesApprovalRequest(Rec, true, true)
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approval;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        VarVariant := Rec;
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147390);
                    end;
                }
            }
            group("Change Log Entries")
            {
                action("Log Entries")
                {
                    Caption = 'Log Entries';
                    Image = Approval;
                    ApplicationArea = All;
                    RunObject = page "Logged Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    trigger OnAction()
                    var

                    begin

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

                actionref("Log Entries_Promoted"; "Log Entries")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Log Entries', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 8.';

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
        Rcpt.SetRange("Document Type", Rcpt."Document Type"::"Member Change");
        Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
        if Rcpt.Count > 3 then begin
            Error(ErrorOnTxtUnpApplic);
        end;
        Rec."Document Type" := Rec."Document Type"::"Member Change";
        Rec."Account Dimension" := Rec."Account Dimension"::Banking;
        Rec."Account Type" := Rec."Account Type"::Savings;
        Rec.Source := Rec.Source::Navision;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::"Member Change";
        Rec."Account Dimension" := Rec."Account Dimension"::Banking;
        Rec."Account Type" := Rec."Account Type"::Savings;
        Rec.Source := Rec.Source::Navision;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
          then
            CurrPage.Editable := false;
        case Rec."Changes Type" of
            Rec."Changes Type"::Images,
            Rec."Changes Type"::"Kin Details",
            Rec."Changes Type"::"Block Account",
            Rec."Changes Type"::"Account Activation",
            Rec."Changes Type"::"Account Deactivation",
            Rec."Changes Type"::"Account Signatories":
                begin
                    GeneralEditable := false;
                    IndividualEditable := false;
                    CommuniEditable := false;
                end;
            Rec."Changes Type"::"Membership Details":
                begin
                    GeneralEditable := true;
                    IndividualEditable := true;
                    CommuniEditable := true;
                end;
        end;
    end;

    var
        RegMngt: Codeunit "Register Management";
        ActionPaneEnabled: Boolean;
        StyleTxt: Text;
        GroupAc: Boolean;
        IndivAcc: Boolean;
        VarVariant: Variant;
        GeneralEditable: Boolean;
        IndividualEditable: Boolean;
        CommuniEditable: Boolean;


}



