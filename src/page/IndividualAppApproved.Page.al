page 51004 "Individual App. Approved"
{
    Caption = 'Individual Application';
    PageType = Card;
    SourceTable = "Member Application";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ApplicationArea=All;
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
                field(Name; Rec.Name)
                {
                    Editable = NameEdit;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Second Name"; Rec."Second Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Other Name"; Rec."Other Name")
                {
                    ToolTip = 'Specifies the value of the Other Name field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    Editable = DOBEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
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
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
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
                    Caption = 'Passport Expiry Date';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Category"; Rec."Member Category")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Segment"; Rec."Member Segment")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Principal Member"; Rec."Principal Member")
                {
                    ApplicationArea = All;
                    Editable = Rec.Type = Rec.Type::"Next of KIN";
                    ShowMandatory = Rec.Type = Rec.Type::"Next of KIN";
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Station/Department"; Rec."Station/Department")
                {
                    ApplicationArea = All;
                    Caption = 'Duty Station';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Group Account No."; Rec."Group Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(City; Rec.City)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Country/Region"; Rec."Country/Region")
                {
                    Caption = 'Country of Residence';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("P.I.N Number"; Rec."PIN No.")
                {
                    Caption = 'PIN';
                    Editable = PINNumberEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Gender; Rec.Gender)
                {
                    Visible = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Monthly Contribution"; Rec."Monthly Contribution")
                {
                    Visible = false;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Marital Status"; Rec."Marital Status")
                {
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }


            }
            group(Communication)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    Editable = MobileNoEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Other Phone"; Rec."Other Phone")
                {
                    Caption = 'Other Phone No.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Current Address"; Rec."Current Address")
                {
                    ApplicationArea = All;
                    Caption = 'Current Postal Address';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Post Code"; Rec."Post Code")
                {
                    Caption = 'Post Code';
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Home Address"; Rec."Home Address")
                {
                    ApplicationArea = All;
                    Caption = 'Permanent Postal Address';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Editable = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Secondary E-Mail"; Rec."Secondary E-Mail")
                {
                    ToolTip = 'Specifies the value of the Secondary E-Mail field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                    ApplicationArea = All;
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
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Mode of Payment"; Rec."Mode of Payment")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Editable = EmployerCodeEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pay Point"; Rec."Pay Point")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Caption = 'Payroll Agency';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Pay Point Name"; Rec."Pay Point Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Designation; Rec.Designation)
                {
                    Caption = 'Occupation';
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll No."; Rec."Payroll No.")
                {
                    Caption = 'Payroll/Staff No';
                    Editable = StaffNoEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Terms of Employment"; Rec."Terms of Employment")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Contract Expiry Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = Rec."Terms of Employment" = Rec."Terms of Employment"::Contract;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            group("Business Details")
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                Visible = Rec.Type = Rec.Type::"Next of KIN";
                field("Nature of Business"; Rec."Nature of Business")
                {
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Ownership Type"; Rec."Ownership Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Nature of Group"; Rec."Nature of Business")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Group Registration No."; Rec."Company Registration No.")
                {
                    Caption = 'Group Registration No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Date of Group Registration"; Rec."Date of Business Reg.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("Group Loaction"; Rec."Business/Group Location")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Group Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Type of Business"; Rec."Type of Business")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Other Business Type"; Rec."Other Business Type")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Business Registration No."; Rec."Company Registration No.")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("Date of Business Reg."; Rec."Date of Business Reg.")
                {
                    Caption = 'Date of Business Reg.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Business Location"; Rec."Business/Group Location")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Business Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
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
            action("Default Savings Product")
            {
                Image = Allocate;
                RunObject = Page "Savings Account Registration";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
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
            action("Create Account")
            {
                Image = PostedMemo;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    VarVariant := Rec;
                    RegisterMngt.fnActionPaneItems(VarVariant, 4)
                end;
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
                        //ContactRef.Image := Rec.Picture;
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
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                        NextofKinError: Label 'You must specify next of Kin for this application.';
                    begin
                        Rec.CheckMinimumRegistrationEntry();
                        Approvalmgt.SendAccOpeningRequest(Rec);
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
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                    Image = Delegate;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.findDelegatedApprovalEntry(Rec."No.");
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", Database::"Member Application");
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

                actionref("Create Account_Promoted"; "Create Account")
                {
                }
                actionref(Attachment_Promoted; Attachment)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Default Savings Product_Promoted"; "Default Savings Product")
                {
                }
                actionref("Kin Details_Promoted"; "Kin Details")
                {
                }
                actionref("Monthly Contributions_Promoted"; "Monthly Contributions")
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
                actionref(Delegate_Promoted; Delegate)
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


    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;

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
        Rec."Identification Type" := Rec."Identification Type"::"National ID";
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
                    NameEdit := true;
                    FirstNameEdits := true;
                    SecondNameEdit := true;
                    LastNameEdit := true;
                    PassportEdit := true;
                    IDNoEdit := true;
                    DOBEdit := true;
                    PINNumberEdit := true;
                    IdentificationTypeEdit := true;
                    EmployerCodeEdit := true;
                    MobileNoEdit := true;
                    StaffNoEdit := true;
                    GenderEdit := true;
                end;
        end;
    end;

}




