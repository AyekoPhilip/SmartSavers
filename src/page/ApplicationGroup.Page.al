page 50781 "Application Group"
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
                field(Name; Rec.Name)
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.Name := UpperCase(Rec.Name)
                    end;
                }
                field("Member Category"; Rec."Member Category")
                {
                    Caption = 'Category';
                    ApplicationArea = All;
                }
                field("Ownership Type"; Rec."Ownership Type")
                {
                    Editable = BusinessOwnershipTypeEdit;
                    ApplicationArea = All;
                }
                field("Single Party/Multiple/Business"; Rec."Single Party/Multiple/Business")
                {
                    Editable = MemberType;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AccoutTypeControl;
                    end;
                }
                field("P.I.N Number"; Rec."PIN No.")
                {
                    Caption = 'PIN No.';
                    Editable = PINNumberEdit;
                    ApplicationArea = All;
                }
            }
            group(Multiple)
            {
                Caption = 'Group Details';
                field("Nature of Group"; Rec."Nature of Business")
                {
                    Editable = NatureofGroupEdit;
                    ApplicationArea = All;
                }
                field("Group Registration No."; Rec."Company Registration No.")
                {
                    Caption = 'Group Registration No.';
                    Editable = GroupRegistrationNoEdit;
                    ApplicationArea = All;
                }
                field("Date of Group Registration"; Rec."Date of Business Reg.")
                {
                    Editable = GroupRegistrationDateEdit;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec."Date of Birth" := Rec."Date of Business Reg.";
                    end;
                }
                field("Group Loaction"; Rec."Business/Group Location")
                {
                    Editable = GroupLocationEdit;
                    ApplicationArea = All;
                }
                field("Group Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    Editable = GroupPlotBuildingStreetEdit;
                    ApplicationArea = All;
                }
                field("Type of Business"; Rec."Type of Business")
                {
                    Editable = GroupTypeEdit;
                    ApplicationArea = All;
                }
                field("Other Business Type"; Rec."Other Business Type")
                {
                    Editable = OtherBusinessTypeEdit;
                    ApplicationArea = All;
                }
                field("Nature of Business"; Rec."Nature of Business")
                {
                    Caption = 'Nature of Business';
                    Editable = NatureofGroupEdit;
                    ApplicationArea = All;
                }
                field("Business Registration No."; Rec."Company Registration No.")
                {
                    Editable = GroupRegistrationNoEdit;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec."ID No." := Rec."Company Registration No."
                    end;
                }
                field("Date of Business Reg."; Rec."Date of Business Reg.")
                {
                    Caption = 'Date of Business Reg.';
                    Editable = GroupRegistrationDateEdit;
                    ApplicationArea = All;
                }
                field("Business Location"; Rec."Business/Group Location")
                {
                    Editable = GroupLocationEdit;
                    ApplicationArea = All;
                }
                field("Business Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    Editable = GroupPlotBuildingStreetEdit;
                    ApplicationArea = All;
                }
            }
            group("Communication Details")
            {
                field("Current Address"; Rec."Current Address")
                {
                    Caption = 'Current Address';
                    Editable = AddressEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }

                field("Country/Region"; Rec."Country/Region")
                {

                }
                field(Nationality; Rec.Nationality)
                {
                    Caption = 'Nationality';
                    Editable = NationalityEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Office Telephone No."; Rec."Phone No.")
                {
                    Caption = 'Office Telephone No.';
                    Editable = PhoneEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    Editable = MobileNoEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Editable = EmailEdit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }

            }
            group("Bank Details")
            {
                Visible = false;
                field("Bank Code"; Rec."Bank Code")
                {
                    Caption = 'Bank Name';
                    Editable = BankEdit;
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Caption = 'Branch Name';
                    Editable = BranchEdit;
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Editable = BankAccountNoEdit;
                    ApplicationArea = All;
                }
            }
            group("Trail Information")
            {
                Caption = 'Trail Information';
                Editable = false;
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AccoutTypeControl;
                    end;
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
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            
            systempart(Control8; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; MyNotes)
            {
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
                        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                        Rec.TestField("Customer Type");
                        VarVariant := Rec;
                        RegisterMngt.fnActionPaneItems(VarVariant, 0)
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::"Pending Approval");
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
                        Rec.TestField("Approval Status", Rec."Approval Status"::"Pending Approval");
                        if Approvalmgt.OpenAccOpeninApprovalRequest(Rec, true, true) then;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Enabled = true;
                    Image = Approval;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147136);
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
                action(Signatory)
                {
                    Image = Skills;
                    RunObject = Page "Signatory Application";
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
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Signatory_Promoted; Signatory)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Default Savings Product_Promoted"; "Default Savings Product")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref("Member File_Promoted"; "Member File")
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 6.';

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
            group(Category_Category8)
            {
                Caption = 'Attachment', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref(Attachment_Promoted; Attachment)
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        AccoutTypeControl;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Group Account" := true;
        Rec."Customer Type" := Rec."Customer Type"::Groups
    end;

    trigger OnOpenPage()
    begin
        AccoutTypeControl;
    end;

    var
        ApplicationDateEdit: Boolean;
        MemberType: Boolean;
        FirstNameEdit: Boolean;
        AddressEdit: Boolean;
        EmployerEdit: Boolean;
        GlobalDim1Edit: Boolean;
        GlobalDim2Edit: Boolean;
        SalesEdit: Boolean;
        PINNumberEdit: Boolean;
        SegmentEdit: Boolean;
        MemberCategoryEdit: Boolean;
        GroupTypeEdit: Boolean;
        NatureofGroupEdit: Boolean;
        GroupRegistrationNoEdit: Boolean;
        GroupRegistrationDateEdit: Boolean;
        GroupLocationEdit: Boolean;
        GroupPlotBuildingStreetEdit: Boolean;
        BusinessOwnershipTypeEdit: Boolean;
        OtherBusinessTypeEdit: Boolean;
        RelationshipManager: Boolean;
        EmailEdit: Boolean;
        ElectrolZoneEdit: Boolean;
        AreaServiceCenterEdit: Boolean;
        RespCenterEdit: Boolean;
        PhoneEdit: Boolean;
        MobileNoEdit: Boolean;
        PostCodeEdit: Boolean;
        CityEdit: Boolean;
        NationalityEdit: Boolean;
        CountyEdit: Boolean;
        BankEdit: Boolean;
        BranchEdit: Boolean;
        BankAccountNoEdit: Boolean;
        VarVariant: Variant;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        RegisterMngt: Codeunit "Register Management";
        Approvalmgt: Codeunit "Approval Mgmt.";


    procedure AccoutTypeControl()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            CurrPage.Editable := true else
            CurrPage.Editable := false;

        StatusControl;
    end;


    procedure StatusControl()
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    ApplicationDateEdit := true;
                    MemberType := true;
                    FirstNameEdit := true;
                    PINNumberEdit := true;
                    SegmentEdit := true;
                    RespCenterEdit := true;
                    EmployerEdit := true;
                    GlobalDim1Edit := true;
                    GlobalDim2Edit := true;
                    SalesEdit := true;
                    MemberCategoryEdit := true;

                    GroupTypeEdit := true;
                    NatureofGroupEdit := true;
                    GroupRegistrationNoEdit := true;
                    GroupRegistrationDateEdit := true;
                    GroupLocationEdit := true;
                    GroupPlotBuildingStreetEdit := true;
                    BusinessOwnershipTypeEdit := true;
                    OtherBusinessTypeEdit := true;

                    PhoneEdit := true;
                    MobileNoEdit := true;
                    EmailEdit := true;
                    AddressEdit := true;
                    PostCodeEdit := true;
                    CityEdit := false;
                    NationalityEdit := true;
                    CountyEdit := true;
                    RelationshipManager := true;
                    ElectrolZoneEdit := true;
                    AreaServiceCenterEdit := true;
                    EmployerEdit := true;
                    GlobalDim1Edit := true;
                    GlobalDim2Edit := true;
                    SalesEdit := true;

                    BankEdit := true;
                    BranchEdit := true;
                    BankAccountNoEdit := true;
                end;

            Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Approved, Rec."Approval Status"::Rejected, Rec."Approval Status"::Posted:
                begin
                    ApplicationDateEdit := false;
                    MemberType := false;
                    FirstNameEdit := false;
                    PINNumberEdit := false;
                    SegmentEdit := false;
                    RespCenterEdit := false;
                    EmployerEdit := false;
                    GlobalDim1Edit := false;
                    GlobalDim2Edit := false;
                    SalesEdit := false;
                    MemberCategoryEdit := false;

                    GroupTypeEdit := false;
                    NatureofGroupEdit := false;
                    GroupRegistrationNoEdit := false;
                    GroupRegistrationDateEdit := false;
                    GroupLocationEdit := false;
                    GroupPlotBuildingStreetEdit := false;
                    BusinessOwnershipTypeEdit := false;
                    OtherBusinessTypeEdit := false;

                    PhoneEdit := false;
                    MobileNoEdit := false;
                    EmailEdit := false;
                    AddressEdit := false;
                    PostCodeEdit := false;
                    CityEdit := false;
                    NationalityEdit := false;
                    CountyEdit := false;
                    RelationshipManager := false;
                    ElectrolZoneEdit := false;
                    AreaServiceCenterEdit := false;

                    EmployerEdit := false;
                    GlobalDim1Edit := false;
                    GlobalDim2Edit := false;
                    SalesEdit := false;

                    BankEdit := false;
                    BranchEdit := false;
                    BankAccountNoEdit := false;
                end;

        end;
    end;


    procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




