page 50808 "Savings Account List"
{
    CardPageID = "Savings Account Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = true;
    SourceTable = "Account Banking";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Old Account No."; Rec."Old Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Staff/Payroll No."; Rec."Staff/Payroll No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Old Member No."; Rec."Old Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("ID/Passport No."; Rec."ID/Passport No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Registration Date"; Rec."Registration Date")
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
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Balance (LCY)";Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    begin
                        Rec.OpenVendorLedgerEntries(false);
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Disbursement Account"; Rec."Loan Disbursement Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Can Guarantee Loan"; Rec."Can Guarantee Loan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
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
                    CustMembr.RESET;
                    CustMembr.SETRANGE("No.", Rec."Member No.");
                    IF CustMembr.FIND('-') THEN
                        REPORT.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
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
                    if SavingsAccounts.Find('-') then
                        REPORT.Run(Report::"Certificate of Deposit", true, false, SavingsAccounts);
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
                        REPORT.Run(Report::CreateAccLien, true, false, SavingsAccounts);
                end;
            }
            action("Make Changes")
            {
                Image = ManualExchangeRate;
                Enabled = false;
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
                        REPORT.Run(Report::"Certificate of Deposit", true, false, SavingsAccounts);
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
                    CustMembr.RESET;
                    CustMembr.SETRANGE("No.", Rec."Member No.");
                    IF CustMembr.FIND('-') THEN
                        REPORT.RUN(REPORT::"Standard Statement-Loans", TRUE, FALSE, CustMembr);
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
                    CustMembr.SETRANGE("No.", Rec."Member No.");
                    IF CustMembr.FIND('-') THEN
                        REPORT.RUN(REPORT::"Standard Statement-Loans", TRUE, FALSE, CustMembr);
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



    trigger OnAfterGetRecord()
    var
        RegMngt: Codeunit "Registry Mngt.";
    begin
        FileNo := RegMngt.getfileNo(Rec."Member No.")
    end;

    trigger OnOpenPage()
    begin

    end;

    var
        FileNo: Code[100];

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




