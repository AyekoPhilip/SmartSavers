page 50986 "Customer List Loan Mngt."
{
    ApplicationArea = All;
    Caption = 'Customer List Loan Mngt.';
    PageType = List;
    SourceTable = customer;
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    SourceTableView = where("Account Dimension" = const(Loan));
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
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No. field';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the customer''s name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                }

                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account Category field';
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account Category field';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the different account types of customers';
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
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the ID No. field';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Product Type field';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
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
                    AccBank: Record Customer;
                    StandardStatement: Report "Standard Statement";
                begin
                    AccBank.SetFilter("No.", Rec."No.");
                    StandardStatement.SetTableView(AccBank);
                    StandardStatement.Run();
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
                    AccBank: Record Customer;
                    StandardStatement: Report "Standard Statement";
                begin
                    AccBank.SetFilter("No.", Rec."No.");
                    StandardStatement.SetTableView(AccBank);
                    StandardStatement.Run();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Email_Promoted; Email)
                {
                }
            }
            group(Category_Report)
            {
                actionref("Account Statement_Promoted"; "Account Statement")
                {
                }
                actionref("Detailed Statement_Promoted"; "Detailed Statement")
                {
                }
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



