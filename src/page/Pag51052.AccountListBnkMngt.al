page 51052 "Account List Bnk. Mngt."
{
    ApplicationArea = All;
    Caption = 'Account List Bnk. Mngt.';
    PageType = List;
    SourceTable = Vendor;
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false; 
    SourceTableView = where("Account Type" = filter(Banking));
    layout
    {
        area(content)
        {

            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the ID No. field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account Category field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
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

                    CustMembr.Reset();
                    CustMembr.SetRange(CustMembr."No.", Rec."Member No.");
                    if CustMembr.FindFirst() then
                        Report.Run(Report::"Standard Statement Banking", true, false, CustMembr);
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
                actionref("Loans Statement-Detailed_Promoted"; "Loans Statement-Detailed")
                {
                }
                actionref("Detailed Statement_Promoted"; "Detailed Statement")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 3.';
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



