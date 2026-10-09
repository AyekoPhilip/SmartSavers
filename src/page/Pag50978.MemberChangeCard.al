page 50978 "Member Change Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Member Changes";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = GeneralEditable;
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Changes Type"; Rec."Changes Type")
                {
                    Caption = 'Change Type';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        if Rec."Changes Type" = Rec."Changes Type"::Images then begin
                            if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                                ActionPaneEnabled := true else
                                ActionPaneEnabled := false
                        end
                    end;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.Name := UpperCase(Rec.Name);
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field("Second Name"; Rec."Second Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field("Other Name"; Rec."Other Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Product Type"; Rec."Product Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Recruited By Type"; Rec."Recruited By Type")
                {
                    ApplicationArea = All;
                }
                field("PIN No."; Rec."PIN No.")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Recruited By"; Rec."Recruited By")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }

            }
            group("Reason For Changes")
            {
                field("Resons for Status Change"; Rec."Resons for Status Change")
                {
                    ApplicationArea = All;
                }
            }
            group(Individual)
            {
                Caption = 'Individual';
                Visible = IndivAcc;
                Editable = IndividualEditable;

                field("Employer Code"; Rec."Employer Code")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetStyle
                    end;

                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Identification Type"; Rec."Identification Type")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Passport Expiry Date"; Rec."Passport Expiry Date")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field("Group Account No."; Rec."Group Account No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Employment/Occupation Detail"; Rec."Employment/Occupation Detail")
                {
                    Caption = 'Occupation Details';
                    ApplicationArea = All;
                }
                field("Employers Postal Address"; Rec."Employers Postal Address")
                {
                    ApplicationArea = All;
                }
                field("Member Segment"; Rec."Member Segment")
                {
                    ApplicationArea = All;
                }
                field("Membership Type"; Rec."Membership Type")
                {
                    ApplicationArea = All;
                }
                field("Member Category"; Rec."Member Category")
                {
                    ApplicationArea = All;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = All;
                }
                field("Electrol Zone"; Rec."Electrol Zone")
                {
                    ApplicationArea = All;
                }
                field(Salutation; Rec.Salutation)
                {
                    ApplicationArea = All;
                }
                field("Member Station"; Rec."Member Station")
                {
                    ApplicationArea = All;
                }
                field("Pay Point"; Rec."Pay Point")
                {
                    ApplicationArea = All;
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = All;
                }
                field("Station/Department"; Rec."Station/Department")
                {
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = All;
                }
                field("Terms of Employment"; Rec."Terms of Employment")
                {
                    ApplicationArea = All;

                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;

                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                Editable = CommuniEditable;
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Office Telephone No."; Rec."Office Telephone No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Idemnity; Rec.Idemnity)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Current Address"; Rec."Current Address")
                {
                    ApplicationArea = All;
                }
                field("Home Address"; Rec."Home Address")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("E-mail (Personal)"; Rec."E-mail (Personal)")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                }



            }
            group("Group Details")
            {
                Caption = 'Group Details';
                Visible = GroupAc;
                field("Relates to Business/Group"; Rec."Relates to Business/Group")
                {
                    ApplicationArea = All;
                }
                field("Type of Business"; Rec."Type of Business")
                {
                    ApplicationArea = All;
                }
                field("Other Business Type"; Rec."Other Business Type")
                {
                    ApplicationArea = All;
                }
                field("Ownership Type"; Rec."Ownership Type")
                {
                    ApplicationArea = All;
                }
                field("Other Account Type"; Rec."Other Account Type")
                {
                    ApplicationArea = All;
                }
                field("Nature of Business"; Rec."Nature of Business")
                {
                    ApplicationArea = All;
                }
                field("Company Registration No."; Rec."Company Registration No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Date of Business Reg."; Rec."Date of Business Reg.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field("Business/Group Location"; Rec."Business/Group Location")
                {
                    ApplicationArea = All;
                }
                field("Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    ApplicationArea = All;
                }
                field("Group Type"; Rec."Group Type")
                {
                    ApplicationArea = All;
                }
                field("Single Party/Multiple"; Rec."Single Party/Multiple")
                {
                    ApplicationArea = All;
                }
                field("Current Residence"; Rec."Current Residence")
                {
                    ApplicationArea = All;
                }
            }
            group("Bank Details")
            {
                Caption = 'Bank Details';
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Trail)
            {
                Caption = 'Trail Information';
                Editable = false;
                field("Value Change"; Rec."Value Change")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetStyle
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "Changes Picture")
            {
                Caption = 'Picture';
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            part(Signature; "Changes Signature")
            {
                Caption = 'Signature';
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
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
                action(Signatories)
                {
                    Caption = 'Account Signatory';
                    Image = ShowWarning;
                    RunObject = Page "Signatory Application";
                    RunPageLink = "Account No." = FIELD("No.");
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Next of KIN")
                {
                    Caption = 'Kin Details';
                    Image = Relatives;
                    Visible = true;
                    ApplicationArea = All;
                    RunObject = page "Next of KIN Application";
                    RunPageLink = "Application No." = field("No."), "Account No" = field("Member No.");
                    trigger OnAction()
                    begin

                    end;
                }
                action("Bank Accounts")
                {
                    Image = BankAccount;
                    RunObject = Page "Bank List-Changes";
                    RunPageLink = "Application No." = field("No.");
                    ApplicationArea = All;
                }

                action("Monthly Contributions")
                {
                    Image = ReleaseDoc;
                    RunObject = Page "Ac. Changes -Contribution";
                    RunPageLink = "Entry No." = field("No."), "Account No." = field("Member No.");
                    ApplicationArea = All;
                }
                action("Post Changes")
                {
                    Image = MarketingSetup;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RegistrationProcess: Codeunit "Credit. Jnl.-Post Batch";
                        GeneralSetUp: Record "General Set-Up";
                        CustomerRecord: Record Member;
                    begin

                        GeneralSetUp.Get();
                        case GeneralSetUp."Post Application As" of
                            GeneralSetUp."Post Application As"::"Post as User":
                                begin
                                    if Confirm(OnConfirmMsg, true) = false then exit;
                                    VarVariant := Rec;
                                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                                    Rec.IndividualEntriesFromCustMember();
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
                        VarVariant := Rec;
                        RegMngt.fnActionPaneItems(
                        VarVariant, 0)
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
                        VarVariant := Rec;
                        RegMngt.fnActionPaneItems(VarVariant, 1)
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
                        VarVariant := Rec;
                        RegMngt.fnActionPaneItems(
                        VarVariant, 2)
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50413);
                    end;
                }
                action(MarkAsPosted)
                {
                    Caption = 'Mark as Posted';
                    Image = Category;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec."Posted By" := UserId;
                        Rec."Date Posted" := CurrentDateTime;
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Modify(true)
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
                    RunPageLink = "Primary Key Field 1 Value" = field("No."), "User ID" = field("Created By");
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

                actionref("Bank Accounts_Promoted"; "Bank Accounts")
                {
                }
                actionref("Monthly Contributions_Promoted"; "Monthly Contributions")
                {
                }
                actionref("Log Entries_Promoted"; "Log Entries")
                {
                }
                actionref(Signatories_Promoted; Signatories)
                {
                }
                actionref("Next of KIN_Promoted"; "Next of KIN")
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
                actionref(MarkAsPosted_Promoted; MarkAsPosted)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Group Account" then begin
            GroupAc := true;
            IndivAcc := false
        end else begin
            GroupAc := false;
            IndivAcc := true
        end;
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
        Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
        if Rcpt.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnTxtUnpApplic);
        end;
        Rec."Document Type" := Rec."Document Type"::"Member Change"
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
        OnConfirmMsg: Label 'Are you want to post this application?';
        CommuniEditable: Boolean;

    procedure SetStyle(): Text
    begin
        StyleTxt := 'StrongAccent'
    end;
}




