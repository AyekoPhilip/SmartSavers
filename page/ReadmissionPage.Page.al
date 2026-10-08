page 50742 "Readmission Page"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Member Application";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;

                field("CRM Application No."; Rec."CRM Application No.")
                {
                    Editable = CRMApplicEdit;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Editable = NameEdit;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Second Name"; Rec."Second Name")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Other Name"; Rec."Other Name")
                {
                    ToolTip = 'Specifies the value of the Other Name field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    Editable = DOBEdit;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Identification Type"; Rec."Identification Type")
                {
                    Editable = IdentificationTypeEdit;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    Editable = IDNoEdit;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    Editable = PassportEdit;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."ID No." = '' then
                            Rec."ID No." := Rec."Passport No.";
                        Rec.Validate("ID No.")
                    end;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Member Category"; Rec."Member Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Principal Member"; Rec."Principal Member")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;


                }
                field("Member Segment"; Rec."Member Segment")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Station/Department"; Rec."Station/Department")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Duty Station';
                }
                field("Group Account No."; Rec."Group Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    Editable = MobileNoEdit;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("P.I.N Number"; Rec."PIN No.")
                {
                    Caption = 'PIN No.';
                    Editable = PINNumberEdit;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field(Gender; Rec.Gender)
                {
                    Visible = true;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Monthly Contribution"; Rec."Monthly Contribution")
                {
                    Visible = false;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Marital Status"; Rec."Marital Status")
                {
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field("Recruited by Type"; Rec."Recruited by Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Recruited By"; Rec."Recruited By")
                {
                    Caption = 'Recruited By';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    trigger OnValidate()
                    var
                    begin
                        case Rec."Recruited by Type" of
                            Rec."Recruited by Type"::Marketer:
                                begin
                                    if SalespersonAc.Get(Rec."Recruited By") then
                                        SalespersonText := SalespersonAc.Name;
                                end;
                            Rec."Recruited by Type"::Members:
                                begin
                                    if MembAc.Get(Rec."Recruited By") then
                                        SalespersonText := MembAc.Name;
                                end;
                            Rec."Recruited by Type"::Others:
                                begin
                                    SalespersonText := ''
                                end;
                        end
                    end;
                }
                field(SalespersonText; SalespersonText)
                {

                    Caption = 'Salesperson';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field(Indemnity; Rec.Indemnity)
                {
                    ToolTip = 'Specifies the value of the Indeminty field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Communication)
            {
                field("Phone No."; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Other Phone"; Rec."Other Phone")
                {
                    Caption = 'Other Phone No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Current Address"; Rec."Current Address")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Current Postal Address';
                }
                field("Post Code"; Rec."Post Code")
                {
                    Caption = 'Post Code';
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field("Home Address"; Rec."Home Address")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Permanent Postal Address';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Secondary E-Mail"; Rec."Secondary E-Mail")
                {
                    ToolTip = 'Specifies the value of the Secondary E-Mail field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(City; Rec.City)
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Country/Region"; Rec."Country/Region")
                {
                    Caption = 'Country of Residence';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    Caption = 'Residence/Estate';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(County; Rec.County)
                {
                    Caption = 'County/District';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Other Information")
            {
                field("Pay Point"; Rec."Pay Point")
                {
                    Caption = 'Pay Point';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Editable = EmployerCodeEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Agency Code';
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Designation; Rec.Designation)
                {
                    Caption = 'Occupation';
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Payroll No."; Rec."Payroll No.")
                {
                    Caption = 'Payroll/Staff No';
                    Editable = StaffNoEdit;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Terms of Employment"; Rec."Terms of Employment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            group(Relative)
            {
                Caption = 'Trail Information';
                Editable = false;
                field("Application Source"; Rec."Application Source")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    TableRelation = "User Setup"."User ID";
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
           
            part(Control16; "Application Picture")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            part(Control80; "Application Signature")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {

        area(creation)
        {

            action("Kin Details")
            {
                Image = Relatives;
                RunObject = Page "Next of KIN Application";
                RunPageLink = "Account No" = FIELD("No.");
                ApplicationArea = All;
            }
            action("Monthly Contributions")
            {
                Image = ReleaseDoc;
                RunObject = Page "Member Contribution Applic.";
                RunPageLink = "Account No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Bank Accounts")
            {
                Image = BankAccount;
                RunObject = Page "Cust.Bank List";
                RunPageLink = "Customer No." = field("No.");
                ApplicationArea = All;
            }
            action("Risk Assessment")
            {
                Image = RegisteredDocs;
                RunObject = Page "Risk Assessment Matrix";
                RunPageLink = "Account No." = field("No.");
                ApplicationArea = All;
            }
            action("Witness Contact")
            {
                Image = CoupledUsers;
                RunObject = Page Witnesses;
                RunPageLink = Code = FIELD("No.");
                ApplicationArea = All;

            }
            action("Create Contact")
            {
                Image = ContactPerson;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ContactDetail: Record Contact;
                    ContactRef: Record Contact;
                begin
                    Rec.TestField("ID No.");
                    Rec.TestField(Name);
                    Rec.TestField("E-Mail");
                    Rec.TestField("Mobile Phone No");
                    Rec.TestField(Picture);

                    ContactDetail.Reset();
                    ContactDetail.SetRange("Application No.", Rec."No.");
                    ContactDetail.SetRange("ID No.", Rec."ID No.");
                    if ContactDetail.FindFirst() then begin
                        Page.Run(Page::"Contact Card", ContactDetail, ContactDetail."Application No.");
                    end else begin

                        ContactRef.Init();
                        ContactRef."No." := '';
                        ContactRef.Name := Rec.Name;
                        ContactRef."ID No." := Rec."ID No.";
                        ContactRef."Application No." := Rec."No.";
                        ContactRef."E-Mail" := Rec."E-Mail";
                        ContactRef."E-Mail 2" := Rec."Secondary E-Mail";
                        ContactRef.Type := ContactRef.Type::Person;
                        ContactRef.Image := Rec.Picture;
                        ContactRef.Insert(true);

                        Commit();

                        ContactDetail.Reset();
                        ContactDetail.SetRange("Application No.", Rec."No.");
                        ContactDetail.SetRange("ID No.", Rec."ID No.");
                        if ContactDetail.FindFirst() then begin
                            Page.Run(Page::"Contact Card", ContactDetail, ContactDetail."Application No.");
                        end
                    end;

                end;

            }
            action("Alterantive Addresses")
            {
                Caption = 'Alternative Addresses';
                Image = Addresses;
                ApplicationArea = All;
                RunObject = page "Contact Alt. Address List";
                RunPageLink = Code = field("No.");
            }
        }
        area(processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = true;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        NextofKinError: Label 'You must specify next of Kin for this application.';
                    begin
                        Rec.TestField("Account No.");
                        Rec.TestField("Phone No.");
                        Rec.TestField("ID No.");
                        Rec.TestField("Mobile Phone No");

                        VarVariant := Rec;
                        RegisterMngt.fnActionPaneItems(VarVariant, 0);
                        CurrPage.Close();
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if Approvalmgt.CancelAccOpeninApprovalRequest(Rec, true, true) then;
                    end;
                }
                action(OpenApprovalRequest)
                {
                    Caption = 'Open Approval Re&quest';
                    Image = Category;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if Approvalmgt.OpenAccOpeninApprovalRequest(Rec, true, true) then;
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50352);
                    end;
                }
                action("Member File")
                {
                    Caption = 'Member File';
                    Image = ElectronicDoc;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        DMS: Record EDMS;
                    begin
                        DMS.Reset;
                        DMS.SetRange(DMS.Key, DMS.Key::"member App");
                        if DMS.Find('-') then begin
                            HyperLink(DMS."url path" + Rec."No.");
                        end;
                    end;
                }
                action(PostApplication)
                {
                    Image = PostedCreditMemo;
                    Caption = 'Post';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: Record Member;
                        GeneralSetUp: Record "General Set-Up";
                    begin
                        GeneralSetUp.Get();
                        Case GeneralSetUp."Post Application As" of
                            GeneralSetUp."Post Application As"::"Post as User":
                                begin
                                    Rec.TestField("Account No.");
                                    if RecRef.Get(Rec."Account No.") then begin
                                        if Confirm(OnMessageConfirm, true) = false then exit;
                                        Rec.CopyIndividualEntriesFromCustMember(RecRef);
                                    end;
                                end;
                        end;
                    end;
                }
                action(Attachment)
                {

                    Image = FiledOverview;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }

            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(PostApplication_Promoted; PostApplication)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Kin Details_Promoted"; "Kin Details")
                {
                }
                actionref("Monthly Contributions_Promoted"; "Monthly Contributions")
                {
                }
                actionref("Bank Accounts_Promoted"; "Bank Accounts")
                {
                }
                actionref("Risk Assessment_Promoted"; "Risk Assessment")
                {
                }
                actionref("Witness Contact_Promoted"; "Witness Contact")
                {
                }
                actionref("Create Contact_Promoted"; "Create Contact")
                {
                }
                actionref("Alterantive Addresses_Promoted"; "Alterantive Addresses")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Member File_Promoted"; "Member File")
                {
                }
                actionref(Attachment_Promoted; Attachment)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Loan History', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';

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

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec."Customer Type" := Rec."Customer Type"::Individual;
        Rec."Application Type" := Rec."Application Type"::Readmission;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");
        MembApplic.Reset;
        MembApplic.SetRange("Created By", UserId);
        MembApplic.SetFilter("Approval Status", '%1|%2', MembApplic."Approval Status"::Open, MembApplic."Approval Status"::"Pending Approval");
        if MembApplic.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnTransactions);
        end;
        Rec."Customer Type" := Rec."Customer Type"::Individual;
        Rec."Application Type" := Rec."Application Type"::Readmission;
    end;

    var
        GenSetup: Record "General Set-Up";
        FirstNameEdits: Boolean;
        IdentificationTypeEdit: Boolean;
        SecondNameEdit: Boolean;
        NameEdit: Boolean;
        LastNameEdit: Boolean;
        PassportEdit: Boolean;
        CRMApplicEdit: Boolean;
        EmployerCodeEdit: Boolean;
        DOBEdit: Boolean;
        IDNoEdit: Boolean;
        StaffNoEdit: Boolean;
        PINNumberEdit: Boolean;
        GenderEdit: Boolean;
        EmailEdit: Boolean;
        MobileNoEdit: Boolean;
        SalespersonAc: Record "Salesperson/Purchaser";
        MembAc: Record Member;
        SalespersonText: Text[150];
        VarVariant: Variant;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        MembApplic: Record "Member Application";
        Temp: Record "User Setup";
        OnMessageConfirm: Label 'Are you sure you want to Post this application?';
        ErrorOnTransactions: Label 'There are still some pending document(s) on your account. Please list & select the pending document to use';
        Approvalmgt: Codeunit "Approval Mgmt.";
        RegisterMngt: Codeunit "Register Management";

    procedure SetControlAppearance()
    begin

        GenSetup.Get();
        GenSetup.TestField("Application Source (Member)");
        case GenSetup."Application Source (Member)" of
            GenSetup."Application Source (Member)"::CBS:
                begin
                    CRMApplicEdit := false;
                    NameEdit := true;
                    FirstNameEdits := true;
                    SecondNameEdit := true;
                    LastNameEdit := true;
                    DOBEdit := true;
                    IDNoEdit := true;
                    PassportEdit := true;
                    PINNumberEdit := true;
                    IdentificationTypeEdit := true;
                    EmployerCodeEdit := true;
                    MobileNoEdit := true;
                    StaffNoEdit := true;
                    GenderEdit := true;
                end;
            GenSetup."Application Source (Member)"::CRM:
                begin
                    CRMApplicEdit := true;
                    NameEdit := false;
                    FirstNameEdits := false;
                    SecondNameEdit := false;
                    LastNameEdit := false;
                    PassportEdit := false;
                    IDNoEdit := false;
                    DOBEdit := false;
                    PINNumberEdit := false;
                    IdentificationTypeEdit := false;
                    EmployerCodeEdit := false;
                    MobileNoEdit := false;
                    StaffNoEdit := false;
                    GenderEdit := false;
                end;
        end;
    end;

}



