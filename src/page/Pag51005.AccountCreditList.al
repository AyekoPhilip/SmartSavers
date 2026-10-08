page 51005 "Account Credit List"
{
    CardPageID = "Account Card Credit";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = true;
    SourceTable = "Account Credit";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable=false;
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
                field("Staff/Payroll No."; Rec."Staff/Payroll No.")
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
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    begin
                        Rec.OpenCustomerLedgerEntries(false);
                    end;
                }
                field(Status; Rec.Status)
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
            part(Control7; "Credit Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
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
            part(Control6; "Dimensions FactBox")
            {
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
            part(Control5; "Service Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
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
                Visible = false;
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
            action("Member Page")
            {
                Image = Customer;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Member No.");
                    if CustMembr.FindFirst() then
                        Page.Run(Page::"Membership Individual", CustMembr, CustMembr."No.");
                end;
            }

        }
        area(processing)
        {
            group(Reports)
            {
                Caption = 'Reports';
            }
            action(Statement)
            {
                Image = Customer;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SavingsAccounts: Record "Account Banking";
                begin

                    CustMembr.RESET;
                    CustMembr.SETRANGE("No.", Rec."Member No.");
                    if CustMembr.Find('-') then
                        REPORT.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
                end;
            }
            action(Signatories)
            {
                Image = Signature;
                RunObject = Page "Signatories List";
                RunPageLink = "Account No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            action("Member Monthly Contribution")
            {
                Image = CustomerGroup;
                Caption = 'Monthly Contribution';
                ApplicationArea = All;
                RunObject = page "Member Contribution";
                RunPageLink = "Account No." = field("Member No.");
            }
            action("Authorized Kin")
            {
                Image = CustomerGroup;
                ApplicationArea = All;
                RunObject = page "Account kin List";
                RunPageLink = "Account No." = field("Member No.");
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
                    if CustMembr.Get(Rec."Member No.") then
                        TempEmailItem.AddSourceDocument(Database::"Account Banking", Rec.SystemId);
                    TempEmailitem."Send to" := CustMembr."E-Mail";
                    TempEmailItem.Send(false, EmailScenario::Default);
                end;
            }
            action("Account Statement")
            {
                Image = ServiceItemWorksheet;
                ApplicationArea = All;
                trigger OnAction()
                var
                    AccBank: Record "Account Credit";
                begin

                    AccBank.SetRange("No.", Rec."No.");
                    if AccBank.FindFirst() then
                        Report.Run(Report::"Standard Statement Credit", true, false, AccBank);
                end;

            }
            action("Loans Statement")
            {
                Image = ServiceItemWorksheet;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CustMembr.RESET;
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

                actionref(Email_Promoted; Email)
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
                actionref(Statement_Promoted; Statement)
                {
                }
                actionref("Member Page_Promoted"; "Member Page")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Member Monthly Contribution_Promoted"; "Member Monthly Contribution")
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

    end;

    trigger OnAfterGetRecord()
    begin

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
        ContactEditable: Boolean;
        SocialListeningSetupVisible: Boolean;
        ShowWorkflowStatus: Boolean;
        IsFixedDeposit: Boolean;
        SavingsAccounts: Record "Account Banking";
        CustMembr: Record Member;

    local procedure SetControlApprearance()
    begin
       
    end;

    local procedure ContactOnAfterValidate()
    begin
        SetControlApprearance;
    end;

    local procedure SetSocialListeningFactboxVisibility()
    begin

    end;




}




