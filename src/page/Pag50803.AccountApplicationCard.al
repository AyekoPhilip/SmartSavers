page 50803 "Account Application Card"
{
    DeleteAllowed = false;
    PageType = Card;
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
                field("Document Type"; Rec."Document Type")
                {
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Doc Type. field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = MemberNoEditable;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Member No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Product Type"; Rec."Product Type")
                {

                    ShowMandatory = true;
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
                field("Kin Account No."; Rec."Kin Account No.")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;
                    Visible=false;
                    Caption = 'Kin Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the next of Kin Name. field.';
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
                field("Monthly Contribution"; Rec."Monthly Contribution")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Visible = false;
                    StyleExpr = true;

                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = true;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Visible = false;
                    Importance = Additional;

                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
            }
            group("Fixed Deposit Details")
            {

                Visible = FixedDeposit;
                Caption = 'Fixed Deposit Details';
                field("Registration Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Fixed Deposit Type"; Rec."Fixed Deposit Type")
                {
                    Caption = 'Fixed Deposit Type';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Fixed Deposit Type field.';
                }
                field("FD Duration"; Rec."FD Duration")
                {
                    Caption = 'FD Duration';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    Editable = false;
                    ToolTip = 'Specifies the value of the FD Duration field.';
                }
                field("FD Maturity Date"; Rec."FD Maturity Date")
                {
                    Editable = false;
                    Visible = true;
                    Caption = 'FD Maturity Date';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the FD Maturity Date field.';
                }
                field("Savings Account No."; Rec."Savings Account No.")
                {
                    Visible = true;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Caption = 'Savings Account No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Savings Account No. field.';
                }
                field("Fixed Deposit Amount"; Rec."Fixed Deposit Amount")
                {
                    Caption = 'Fixed Deposit Amount';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Fixed Deposit Amount field.';
                }
                field("FD Maturity Instructions"; Rec."FD Maturity Instructions")
                {
                    Caption = 'FD Maturity Instructions';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the FD Maturity Instructions field.';
                }
                field("Negotiated Interest Rate"; Rec."Negotiated Interest Rate")
                {
                    Caption = 'Negotiated Interest Rate';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Negotiated Interest Rate field.';
                }
                field("Fixed Deposit Cert. No."; Rec."Fixed Deposit Cert. No.")
                {
                    Caption = 'Fixed Deposit Cert. No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Fixed Deposit Cert. No. field.';
                }
            }
            group("Junior Account Details")
            {
                Visible = JuniorAccount;
                Caption = 'Junior Account Details';
                field("Parent Account No."; Rec."Parent Account No.")
                {
                    Editable = false;
                    Visible = true;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    Caption = 'Parent Account No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parent Account No. field.';
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
            group("Group Account Details")
            {
                Visible = SigningInstructionEdit;
                field("ID No."; Rec."ID No.")
                {

                    Caption = 'Registration No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Current Address"; Rec."Current Address")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Country/Region"; Rec."Country/Region")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }

                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

            }
            group("Signing Instructions")
            {
                Visible = SigningInstructionEdit;
                field(Mandates; Rec."Signing Mandates")
                {
                    MultiLine = true;
                    ShowCaption = false;
                    Caption = 'Signing Mandates';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
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
        area(FactBoxes)
        {
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = field("Member No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = field("Member No.");
                ApplicationArea = All;
            }
            systempart(Control10; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control9; MyNotes)
            {
                ApplicationArea = All;
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
                    Caption = 'Create Account';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Post Application action.';
                    trigger OnAction()
                    var
                        ProdFct: Record "Product Factory";
                        GeneralSetUp: Record "General Set-Up";
                    begin
                        GeneralSetUp.Get();
                        case GeneralSetUp."Post Application As" of
                            GeneralSetUp."Post Application As"::"Post as User":
                                begin
                                    ProdFct.Get(Rec."Product Type");
                                    if Rec."Account Source" = Rec."Account Source"::" " then
                                        Rec."Account Source" := ProdFct."Account Dimension";
                                    Rec.Modify(true);
                                    VarVariant := Rec;
                                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                                    RegMngt.fnActionPaneItems(VarVariant, 4)
                                end;
                        end;

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
                        if ProductType.Get(Rec."Product Type") then
                            if ProductType."Account Category" = ProductType."Account Category"::Junior then begin
                                CustBankAcc.Reset();
                                CustBankAcc.SetRange("Customer No.", Rec."No.");
                                if not CustBankAcc.Find('-') then begin
                                    Error('Applicant Bank Account Details not found');
                                end;
                                CustBankAcc.Reset();
                                CustBankAcc.SetRange("Customer No.", Rec."No.");
                                if CustBankAcc.FindSet() then begin
                                    repeat
                                        CustBankAcc.TestField("Bank Account No.");
                                        CustBankAcc.TestField(Code);
                                        CustBankAcc.TestField("Bank Branch No.");
                                    until CustBankAcc.Next() = 0;
                                end;

                            end;
                        VarVariant := Rec;
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
                action("Bank Accounts")
                {
                    Image = BankAccount;
                    RunObject = Page "Cust.Bank List";
                    RunPageLink = "Customer No." = field("No."), "Application Source" = field("Bank Account Source");
                    ApplicationArea = All;
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

                actionref("Bank Accounts_Promoted"; "Bank Accounts")
                {
                }
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
        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    CurrPage.Editable := true;
                end else begin
                CurrPage.Editable := false;
            end;
        end;

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
        Rec."Bank Account Source" := Rec."Bank Account Source"::Account;
        Rec."Document Type" := Rec."Document Type"::"New Account";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Bank Account Source" := Rec."Bank Account Source"::Account;
        Rec."Document Type" := Rec."Document Type"::"New Account";
    end;

    trigger OnOpenPage()
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    CurrPage.Editable := true;
                end else begin
                CurrPage.Editable := false;
            end;
        end;
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
            case Rec."Approval Status" of
                Rec."Approval Status"::Open:
                    begin
                        CurrPage.Editable := true;
                    end else begin
                    CurrPage.Editable := false;
                end;
            end;
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
        CustBankAcc: Record "Cust. Bank Account";
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
                    //Rec.Name := '';
                    //Rec."Date of Birth" := 0D;
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




