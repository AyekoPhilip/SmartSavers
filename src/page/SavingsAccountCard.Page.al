page 50809 "Savings Account Card"
{
    Caption = 'Account Card';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Account Banking";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ShowCaption = false;
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    Importance = Promoted;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    ShowCaption = false;

                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }

                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("ID/Passport No."; Rec."ID/Passport No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Birth Certificate No."; Rec."Birth Certificate No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Status; Rec.Status)
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }

                field("ATM No."; NewStr)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Expiry Date (Card)"; Rec."Expiry Date (Card)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }

            }
            group("Signing Mandates")
            {
                Visible = SignInstructEditable;

                field("Signing Instructions"; Rec."Signing Mandates")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }

            }
            group("Fixed Deposit")
            {
                Caption = 'Fixed Deposit';
                Visible = IsFixedDeposit;
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Fixed Deposit Type"; Rec."Fixed Deposit Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("FD Duration"; Rec."FD Duration")
                {
                    Caption = 'FD Duration';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Fixed Deposit Status"; Rec."Fixed Deposit Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("FD Maturity Date"; Rec."FD Maturity Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("FD Date Renewed"; Rec."FD Date Renewed")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Neg. Interest Rate"; Rec."Neg. Interest Rate")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("FD Maturity Instructions"; Rec."FD Maturity Instructions")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(NoOfPeriod; NoOfPeriod)
                {
                    ApplicationArea = All;
                    Caption = 'No. Of Days';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Savings Account No."; Rec."Savings Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Fixed Deposit Amount"; Rec."Fixed Deposit Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
            group("Trail Information")
            {
                Editable = false;
                field("Last No. Series"; Rec."Last No. Series")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Created By"; Rec."Created By")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
            }
        }
        area(factboxes)
        {
            part(Control12; "CRM Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = CRMIsCoupledToRecord;
                ApplicationArea = All;
            }
            part(Control9; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
                ApplicationArea = All;
            }
            part(Control8; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
                ApplicationArea = All;
            }
            part(Control7; "Account Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
                ApplicationArea = All;
            }

            part(Control6; "Member Picture")
            {
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            part(Control5; "Member Signature")
            {
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            part(Control4; "Service Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
                ApplicationArea = All;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
                ApplicationArea = All;
            }
            systempart(Control2; Links)
            {
                Visible = true;
                ApplicationArea = All;
            }
            systempart(Control1; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            group(Reports)
            {
                Caption = 'Reports';
            }
            action("Detailed Statement")
            {
                Image = Customer;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SavingsAccounts: Record "Account Banking";
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Member No.");
                    if CustMembr.FindFirst() then
                        Report.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
                end;
            }
            action("Charge Bank Letter")
            {
                Image = Customer;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SavingsAccounts: Record "Account Banking";
                begin
                    if Rec."Account Category" = Rec."Account Category"::Savings then begin
                        SavingsAccounts.Reset();
                        SavingsAccounts.SetRange("No.", Rec."No.");
                        if SavingsAccounts.FindFirst() then begin
                            Report.Run(Report::"Official Bank Letters", true, false, SavingsAccounts);
                        end;
                    end else begin
                        Error('This action is not available for this product type');
                    end;
                end;
            }
            action("Process Fixed")
            {
                Enabled = IsFixedDeposit;
                Image = "Report";
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."No.", Rec."No.");
                    if SavingsAccounts.FindFirst() then
                        Report.Run(Report::"Certificate of Deposit", true, false, SavingsAccounts);
                end;
            }
            action("Fixed Deposit History")
            {
                Enabled = IsFixedDeposit;
                Image = Splitlines;
                ApplicationArea = All;
                RunObject = page "Fixed Deposit History";
                RunPageLink = "Account No." = field("No.");
            }

            action("Process Lien")
            {
                Enabled = true;
                Image = Category;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange("No.", Rec."No.");
                    if SavingsAccounts.Find('-') then
                        Report.Run(Report::CreateAccLien, true, false, SavingsAccounts);
                end;
            }
            action("Make Changes")
            {
                Image = ManualExchangeRate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ErrorOnTxtUnpApplic: Label 'There is still open/pending application %1 that is still in the process.';
                    FieldsRef: Record "Field";
                    Rcpt: Record "Account Application";
                    RegistryMngt: Codeunit "Registry Mngt.";
                begin
                    Rcpt.Reset();
                    Rcpt.SetRange("Member No.", Rec."Member No.");
                    Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
                    if Rcpt.count > 3 then begin
                        Error(ErrorOnTxtUnpApplic, Rcpt."No.");
                    end;
                    Rec.TestField("Account Category", Rec."Account Category"::Junior);
                    Response := ConfirmPost();
                    RegistryMngt.fnAccountEntries(Rec, Response);
                end;
            }
            action("Bank Accounts")
            {
                Image = BankAccount;
                RunObject = Page "Cust. Bank Account (Member)";
                RunPageLink = "Member No." = field("No.");
                ApplicationArea = All;
            }
            action(Signatories)
            {
                Image = Signature;
                RunObject = Page "Signatories List";
                RunPageLink = "Account No." = field("No.");
                ApplicationArea = All;
            }
            action("Authorized Kin")
            {
                Image = CustomerGroup;
                ApplicationArea = All;
                RunObject = page "Account kin List";
                RunPageLink = "Account No." = field("No.");
                trigger OnAction()
                begin

                end;
            }
            action("Fixed Deposit Certificate")
            {
                Enabled = IsFixedDeposit;
                Image = FixedAssets;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."No.", Rec."No.");
                    if SavingsAccounts.Find('-') then
                        Report.Run(Report::"Certificate of Deposit", true, false, SavingsAccounts);
                end;
            }

            action(Email)
            {
                ApplicationArea = All;
                Caption = 'Send Email';
                Image = Email;
                ToolTip = 'Send an email to the contact person for this account.';
                trigger OnAction()
                var
                    TempEmailItem: Record "Email Item" temporary;
                    EmailScenario: Enum "Email Scenario";
                begin
                    Rec.TestField("E-Mail");
                    TempEmailItem.AddSourceDocument(Database::"Account Banking", Rec.SystemId);
                    TempEmailitem."Send to" := Rec."E-Mail";
                    TempEmailItem.Send(false, EmailScenario::Default);
                end;
            }
            action("Account Statement")
            {
                Image = ServiceItemWorksheet;
                ApplicationArea = All;
                trigger OnAction()
                var
                    AccBank: Record "Account Banking";
                    custmgt: Record Member;
                begin

                    AccBank.SetRange("No.", Rec."No.");
                    if AccBank.FindFirst() then
                        Report.Run(Report::"Standard Statement Banking", true, false, AccBank);
                end;
            }

            action("Loans Statement")
            {
                Image = ServiceItemWorksheet;
                Enabled = false;
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Member No.");
                    if CustMembr.FindFirst() then
                        Report.Run(Report::"Standard Statement-Loans", true, false, CustMembr);
                end;
            }
            action("Loans Statement-Detailed")
            {
                Image = ServiceItemWorksheet;
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Member No.");
                    if CustMembr.FindFirst() then
                        Report.Run(Report::"Standard Statement-Loans", true, false, CustMembr);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Process Lien_Promoted"; "Process Lien")
                {
                }
                actionref("Make Changes_Promoted"; "Make Changes")
                {
                }
                actionref(Email_Promoted; Email)
                {
                }
                actionref("Fixed Deposit Certificate_Promoted"; "Fixed Deposit Certificate")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Account Statement_Promoted"; "Account Statement")
                {
                }
                actionref("Loans Statement_Promoted"; "Loans Statement")
                {
                }
                actionref("Loans Statement-Detailed_Promoted"; "Loans Statement-Detailed")
                {
                }
                actionref("Detailed Statement_Promoted"; "Detailed Statement")
                {
                }
                actionref("Charge Bank Letter_Promoted"; "Charge Bank Letter")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Process Fixed_Promoted"; "Process Fixed")
                {
                }
                actionref("Fixed Deposit History_Promoted"; "Fixed Deposit History")
                {
                }
                actionref("Bank Accounts_Promoted"; "Bank Accounts")
                {
                }
                actionref("Authorized Kin_Promoted"; "Authorized Kin")
                {
                }
                actionref(Signatories_Promoted; Signatories)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Request Approval', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlApprearance;
        Rec.Name := UpperCase(Rec.Name)
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
        NewStr := '';
        if StrLen(Rec."ATM No.") > 4 then begin
            Str := (CopyStr(Rec."ATM No.", StrLen(Rec."ATM No.") - 3, 4));
            NewStr := 'xxxxxxxx' + Str;
        end;
        if Rec."Account Category" = Rec."Account Category"::"Certificates of Deposit" then begin
            if Rec."FD Maturity Date" <> 0D then
                NoOfPeriod := Rec."FD Maturity Date" - Rec."Registration Date"
        end else begin
            NoOfPeriod := 0;
        end;
    end;

    Procedure SetStyle(): Text
    begin
        exit('Unfavorable');
        exit('');
    end;

    trigger OnInit()
    begin
        ContactEditable := true;
        MapPointVisible := true;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        if not MapMgt.TestSetup then
            MapPointVisible := false;

    end;

    var

        MapPointVisible: Boolean;
        Str: Code[30];

        ContactEditable: Boolean;

        SocialListeningSetupVisible: Boolean;

        SocialListeningVisible: Boolean;
        CRMIsCoupledToRecord: Boolean;
        SignInstructEditable: Boolean;
        ShowWorkflowStatus: Boolean;
        Response: Integer;
        IsFixedDeposit: Boolean;
        SavingsAccounts: Record "Account Banking";
        NewStr: Code[30];
        CustMembr: Record Member;
        NoOfPeriod: Integer;
        FactP: Record "Product Factory";
        StyleTxt: Text[100];

    local procedure SetControlApprearance()
    begin
        if FactP.Get(Rec."Product Type") then begin
            if FactP."Account Category" = FactP."Account Category"::"Certificates of Deposit" then
                IsFixedDeposit := true
            else
                IsFixedDeposit := false;
            if FactP."Source Account" = FactP."Source Account"::Member then
                SignInstructEditable := false else
                SignInstructEditable := true
        end;
    end;

    local procedure ContactOnAfterValidate()
    begin
        SetControlApprearance;
    end;

    local procedure SetSocialListeningFactboxVisibility()
    begin
        /////SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    end;

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Account Details,&Image,&Bank Details';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 3 then
            DefaultOption := 3;
        if DefaultOption <= 0 then
            DefaultOption := 1;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option on the type of change you want to initiate');
        PassInt := Selection;
        if Selection = 0 then
            exit;
        exit(PassInt);
    end;
}




