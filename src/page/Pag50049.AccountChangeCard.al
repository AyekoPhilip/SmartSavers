page 50049 "Account Change-Card"
{
    Caption = 'Account Change-Card';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "Account Application";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("CRM Application No."; Rec."CRM Application No.")
                {
                    Editable = CRMAppEditable;
                    Caption = 'CRM Application No.';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the CRM Application No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = false;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = false;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Member No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }

                field(Name; Rec.Name)
                {
                    Editable = true;
                    Caption = 'Name';
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Product Type"; Rec."Product Type")
                {

                    ShowMandatory = true;
                    Editable = false;
                    Caption = 'Product Type';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Product Type field.';
                    trigger OnValidate()
                    var
                        Prod: Record "Product Factory";
                    begin
                        SetControlAppearance;
                        if ProductType.Get(Rec."Product Type") then
                            if ProductType."Source Account" = ProductType."Source Account"::Member then
                                SigningInstructionEdit := false else
                                SigningInstructionEdit := true;
                    end;
                }
                field("Product Name"; Rec."Product Name")
                {
                    Caption = 'Product Name';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Product Name field.';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    Editable = true;
                    Caption = 'Date of Birth | Registration';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                }
                field("Birth Certificate No."; Rec."Birth Certificate No.")
                {
                    Caption = 'Birth Certificate No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Birth Certificate No. field.';
                }

            }
            part(Control1; "Bank Account-Accounts")
            {
                Caption = 'Lines';
                Visible = Rec."Account Type" = Rec."Account Type"::Junior;
                SubPageLink = "Application No." = field("No."), "Member No." = field("Member No.");
                ApplicationArea = All;

            }
            group("Trail Information")
            {
                Editable = false;
                field("Application Date"; Rec."Application Date")
                {
                    Editable = false;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ShowMandatory = true;
                    Caption = 'Global Dimension 1 Code';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Global Dimension 2 Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Responsibility Center';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Approval Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Post)
            {
                Caption = 'Post';
                action("Post Application")
                {
                    Image = PostedTimeSheet;
                    ApplicationArea = All;
                    ToolTip = 'Executes the Post Application action.';
                    trigger OnAction()
                    var
                        ProdFct: Record "Product Factory";
                    begin
                        ProdFct.Get(Rec."Product Type");
                        VarVariant := Rec;
                        Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                        Rec.PostAccountChange(Rec."Account No.");
                    end;
                }
            }
            group(Action3)
            {
                Caption = 'Approvals';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = true;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        JuniorError: Label 'You must specify either %1 %2 for %3';
                        IDJunior: Code[20];
                        ProductApplicationDocuments: Record "Product Documents";
                        ApplicationDocuments: Record "Application Documents";
                    begin
                        VarVariant := Rec;
                        if Rec."Account Type" = Rec."Account Type"::Junior then
                        RegMngt.fnActionPaneItems(VarVariant, 0);
                        CurrPage.Close();
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        RegMngt.fnActionPaneItems(VarVariant, 1)
                    end;
                }
                action("Open Approval Request")
                {
                    Image = Category;
                    Caption = 'Open Approval Request';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Open Approval Request action.';

                    trigger OnAction()
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
                    ToolTip = 'Executes the Approvals action.';
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalMgmt: Codeunit "Approval Mgmt.";

                    begin
                        approvalMgmt.OpenApprovalEntriesPage(Rec."No.", 52147149);
                    end;
                }
                action("Account Kin")
                {
                    Caption = 'Account Kin';
                    Image = Approval;
                    ApplicationArea = All;
                    RunObject = page "Account Kin App.";
                    RunPageLink = "Account No." = field("No.");
                    ToolTip = 'Account Kin action.';
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                    end;
                }
                action("Account Signatory")
                {
                    Caption = 'Account Signatory';
                    Image = Approval;
                    ApplicationArea = All;
                    RunObject = page "Signatory Application";
                    RunPageLink = "Account No." = field("No.");
                    ToolTip = 'Account Kin action.';
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approvals Mgmt.";
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

                actionref("Post Application_Promoted"; "Post Application")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Statemnet', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Attachment', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Account', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref("Account Kin_Promoted"; "Account Kin")
                {
                }
                actionref("Account Signatory_Promoted"; "Account Signatory")
                {
                }
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
                actionref("Open Approval Request_Promoted"; "Open Approval Request")
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
        if ProductType.Get(Rec."Product Type") then begin
            if ProductType."Source Account" = ProductType."Source Account"::Member then
                SigningInstructionEdit := false else
                SigningInstructionEdit := true;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");
        Applic.Reset;
        Applic.SetRange("Created By", UserId);
        Applic.SetFilter("Approval Status", '%1|%2', Applic."Approval Status"::Open, Applic."Approval Status"::"Pending Approval");
        if Applic.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnTransactions);
        end;
        Rec."Application Type" := Rec."Application Type"::"Account Changes";
    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            CurrPage.Editable := true else
            CurrPage.Editable := false;
        MemberNoEditable := true;
    end;

    trigger OnAfterGetRecord()
    begin

        if ProductType.Get(Rec."Product Type") then begin
            if ProductType."Source Account" = ProductType."Source Account"::Member then
                SigningInstructionEdit := false else
                SigningInstructionEdit := true;
        end;

        begin
            if Rec."Approval Status" = Rec."Approval Status"::Open then
                CurrPage.Editable := true else
                CurrPage.Editable := false;
            MemberNoEditable := true;
        end;

    end;

    var
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        FixedDeposit: Boolean;
        JuniorAccount: Boolean;
        ProductType: Record "Product Factory";
        MemberNoEdit: Boolean;
        RegMngt: Codeunit "Register Management";
        CRMAppEditable: Boolean;
        NameEditable: Boolean;
        AccountTypeEditable: Boolean;
        DateOfBirthEditable: Boolean;
        MemberNoEditable: Boolean;
        SigningInstructionEdit: Boolean;
        Applic: Record "Account Application";
        Temp: Record "User Setup";

        ErrorOnTransactions: Label 'There are still some pending document(s) on your account. Please list & select the pending document to use.';
        GenSetup: Record "General Set-Up";

    procedure SetControlAppearance()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            CurrPage.Editable := true
        else
            CurrPage.Editable := false;
        if Rec."Product Type" = '' then
            MemberNoEdit := true
        else begin
            if ProductType.Get(Rec."Product Type") then begin
                if ProductType."Account Category" = ProductType."Account Category"::"Certificates of Deposit" then begin
                    FixedDeposit := true;
                    MemberNoEdit := true;
                    MemberNoEditable := true;
                end else
                    FixedDeposit := false;
                MemberNoEdit := true;
                MemberNoEditable := true;
                if ProductType."Account Category" = ProductType."Account Category"::Junior then begin
                    JuniorAccount := true;
                    MemberNoEdit := true;
                    MemberNoEditable := true;
                    Rec.TestField("Member No.");
                    Rec."Parent Account No." := Rec."Member No.";
                end else
                    JuniorAccount := false;
                if (ProductType."Account Category") in
                    [ProductType."Account Category"::" ",
                    ProductType."Account Category"::"Shares Deposit",
                    ProductType."Account Category"::Repayment,
                    ProductType."Account Category"::"Shares Capital"] then
                    MemberNoEdit := true;
                MemberNoEditable := true;
            end;
        end;

        GenSetup.Get();
        GenSetup.TestField("Application Source (Account)");
        case GenSetup."Application Source (Account)" of
            GenSetup."Application Source (Account)"::CBS:
                begin
                    CRMAppEditable := false;
                    if ProductType.Get(Rec."Product Type") then
                        if ProductType."Source Account" = ProductType."Source Account"::Member then begin
                            MemberNoEditable := true;
                            MemberNoEdit := true;
                            AccountTypeEditable := true;
                        end else begin
                            MemberNoEditable := false;
                            MemberNoEdit := false;
                            AccountTypeEditable := true;
                            NameEditable := false;
                            DateOfBirthEditable := false;
                        end;
                end;
            GenSetup."Application Source (Account)"::CRM:
                begin
                    ProductType.Get(Rec."Product Type");
                    CRMAppEditable := true;
                    if ProductType.Get(Rec."Product Type") then
                        if ProductType."Source Account" = ProductType."Source Account"::Member then begin
                            MemberNoEditable := true;
                            AccountTypeEditable := true;
                            MemberNoEdit := true;
                        end else begin
                            MemberNoEditable := false;
                            AccountTypeEditable := false;
                            NameEditable := false;
                            DateOfBirthEditable := false
                        end;
                end
        end
    end;

    local procedure SetBankAccVisible(): Boolean
    begin
        if ProductType.Get(Rec."Product Type") then
            if ProductType."Account Category" = ProductType."Account Category"::Junior then begin
                exit(true)
            end;
        exit(false)
    end;

    procedure Token(var Text: Text; Separator: Text) Token: Text[250]
    var
        Pos: Integer;
    begin
        Pos := StrPos(Text, Separator);
        if Pos > 0 then begin
            Token := CopyStr(Text, 1, Pos - 1);
            if Pos + 1 <= StrLen(Text) then
                Text := CopyStr(Text, Pos + 1)
            else
                Text := '';
        end else begin
            Token := Text;
            Text := '';
        end;
    end;
}



