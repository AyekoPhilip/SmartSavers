page 51008 "Repayment Account"
{
    Caption = 'Repayment Account Card';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Repayment Account";
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
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    Importance = Promoted;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Employer Code"; Rec."Employer Code")
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
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
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

                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin


                    end;
                }

            }
            group("Trail Information")
            {
                Editable = false;
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
                Visible = false;
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
            part("Statistics FactBox"; "Credit Statistics FactBox")
            {
                Caption = 'Statistics FactBox';
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
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

                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Member No.");
                    if CustMembr.Find('-') then
                        Report.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
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
                    StandardStateRepayment: Report "Statement of Account-Repayment";
                    RepayAccount: Record "Repayment Account";
                begin
                    RepayAccount.SetFilter("No.", Rec."No.");
                    StandardStateRepayment.SetTableView(RepayAccount);
                    StandardStateRepayment.Run();
                end;
            }
            action("Loans Statement")
            {
                Image = ServiceItemWorksheet;
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

                actionref(Email_Promoted; Email)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

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
                Caption = 'Account', Comment = 'Generated from the PromotedActionCategories property index 3.';

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
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Request Approval', Comment = 'Generated from the PromotedActionCategories property index 5.';
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




