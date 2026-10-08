page 50790 "Membership Individual List"
{
    CardPageID = "Membership Individual";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Member;
    //SourceTableView = where("Group Account" = const(false), "Customer Type" = filter(Individual));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control13)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
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
                    Visible = false;
                }
                field(Name; Rec.Name)
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

                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Current Address"; Rec."Current Address")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Category"; Rec."Member Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Segment"; Rec."Member Segment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Terms of Employment"; Rec."Terms of Employment")

                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
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
                field(Agency; EmployerName)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Employer';
                    ApplicationArea = All;

                }

                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Customer Type"; Rec."Customer Type")
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
                field(MembAge; MembAge)
                {
                    Caption = 'Age';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Notification Option"; Rec."Notification Option")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("Member History"; "Credit A/c Statistics Factbox")
            {
                SubPageLink = "Member No." = field("No.");
                Caption = 'Customer Statistics';
                Visible = false;
                ApplicationArea = All;
            }
            part(Control7; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("No."),
                                             "Account Category" = const("Shares Deposit");
                Visible = true;
                ApplicationArea = All;
            }
            part(Control9; "Credit Statistics FactBox")
            {
                Caption = 'Shares Statistics FactBox';
                SubPageLink = "Member No." = field("No."),
                                             "Account Category" = const("Shares Capital");
                Visible = true;
                ApplicationArea = All;
            }
            part("Banking History"; "Account Statistics FactBox")
            {
                Caption = 'Banking Statistics';
                SubPageLink = "Member No." = field("No.");
                SubPageView = where("Account Category" = filter("Specialty Savings" | "Money Market"));
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Account Signatory")
            {
                Image = Relatives;
                RunObject = Page "Signatories List";
                RunPageLink = "Account No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Defaulter Information")
            {
                Image = Relatives;
                RunObject = Page "Loans Recovery Mngt.";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Member Statistics")
            {
                Image = StatisticsGroup;
                RunObject = Page "Member Statistics";
                RunPageLink = "No." = field("No.");
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec.Hide = true then begin
                        if UserSetup.Get(UserId) then begin
                            if UserSetup."Show Hidden" = false then
                                Error('You do not have permissions to view this account information.');
                        end;
                    end;
                end;
            }
            action("Accounts Banking")
            {
                Image = Capacity;
                Caption = 'Operational Accounts';
                RunObject = Page "Savings Account List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                Image = ChangeBatch;
                Caption = 'Bosa Account';
                RunObject = Page "Account Credit List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }

            action("Kin Account")
            {
                Image = ItemGroup;
                RunObject = Page "Membership Individual List";
                RunPageLink = "No." = FIELD("Principal Member No.");
                ApplicationArea = All;
            }

            action("Repayment Account")
            {
                Image = CashFlowSetup;
                RunObject = Page "Savings Account List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }

            action("Next Of Kin")
            {
                Image = CashFlowSetup;
                RunObject = Page "Next of KIN";
                RunPageLink = "Account No" = FIELD("No.");
                ApplicationArea = All;
            }
            action("Monthly Contribution")
            {
                Image = Category;
                RunObject = Page "Member Contribution";
                RunPageLink = "Account No." = FIELD("No.");
                ApplicationArea = All;
            }

            action("Comment Line")
            {
                Caption = 'Comment Line';
                Image = Comment;
                ApplicationArea = All;
                RunObject = page "Comment Sheet Line";
                RunPageLink = "No." = field("No.");
                trigger OnAction()
                var
                    CustomerMemb: Record Member;
                begin

                end;
            }
            action("Witness Contact")
            {
                Image = ContactReference;
                Visible = false;
                RunObject = Page "Registered Witness page";
                RunPageLink = Code = field("Application No.");
                ApplicationArea = All;
                trigger OnAction()
                begin

                end;
            }
            action("Create Contact")
            {
                Image = ContactPerson;
                RunObject = Page "Contact Card";
                RunPageLink = "Application No." = field("No."), "ID No." = field("ID No.");
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.TestField("ID No.");
                end;
            }
        }
        area(processing)
        {
            action("Dividend Instructions")
            {
                Image = InsertAccount;
                RunObject = Page "Dividend Instructions - Member";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Dividend Deduction")
            {
                Image = Database;
                RunObject = Page "Dividend Posting Buffer";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Bank Accounts")
            {
                Image = BankAccount;
                RunObject = Page "Cust. Bank Account (Member)";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action(DividendRegister)
            {
                Image = Database;
                Caption = 'Dividend Register';
                ApplicationArea = All;
                trigger OnAction()
                var
                    DivProg: Record "Dividend Progression";
                begin

                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."No.");
                    if CustMembr.FindFirst() then begin
                        Report.Run(Report::"Dividend Register", true, false, CustMembr);
                    end;
                end;
            }

            action(Dividendprogression)
            {
                Image = Database;
                Caption = 'Dividend progression';
                ApplicationArea = All;
                trigger OnAction()
                var
                    DivProg: Record "Dividend Progression";
                begin

                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."No.");
                    if CustMembr.FindFirst() then begin
                        Report.Run(Report::"Dividend Register", true, false, CustMembr);
                    end;
                end;
            }
            // Dividend Progression

            action("Dividend Progression")
            {
                Image = Database;
                RunObject = Page "Dividend Progression";

                RunPageLink = "Member No" = FIELD("No.");
                ApplicationArea = All;
            }
            action(DividendStatement)
            {
                Image = Database;
                ApplicationArea = All;
                Caption = 'Dividend Statement';
                trigger OnAction()
                var
                    DivProg: Record "Dividend Progression";
                begin
                    DivProg.Reset();
                    DivProg.SetRange("Member No", Rec."No.");
                    if DivProg.FindFirst() then begin
                        Report.Run(Report::"Dividend Statement", true, false, DivProg);
                    end;
                end;
            }
            action("Member File")
            {
                Image = Documents;
                ApplicationArea = All;
                trigger OnAction()
                var
                    DMS: Record EDMS;
                    gensetup: Record "General Set-Up";
                begin
                    gensetup.Get();
                    Hyperlink(gensetup."DMS Url");
                end;
            }
            action("Allocation Details")
            {
                Caption = 'File No.';
                Image = NumberSetup;
                ApplicationArea = All;
                RunObject = page "File Allocation No.";
                RunPageLink = "ID No." = field("ID No.");

            }
            action("Generate Mobile Score")
            {
                Caption = 'Mobile Loan Score';
                Image = NegativeLines;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RegMnt: Codeunit "Register Management";
                    DscApp: Record "DSC Appraisal Scoring";

                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."No.");
                    if CustMembr.FindFirst() then begin
                        Report.Run(Report::"Mob.Appraisal score", true, false, CustMembr);
                    end
                end;
            }
            action("View Mobile Score")
            {
                Image = NegativeLines;
                Visible = false;
                ApplicationArea = All;
                RunObject = report "Mob.Appraisal score";
                trigger OnAction()
                var
                    RegMnt: Codeunit "Register Management";
                    DscApp: Record "DSC Appraisal Scoring";
                begin

                end;
            }
            action("Generate Dividend Score")
            {
                Caption = 'Dividend Discount Score';
                Image = NegativeLines;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RegMnt: Codeunit "Register Management";
                    DscApp: Record Member;
                begin

                    DscApp.Reset();
                    DscApp.SetRange("No.", Rec."No.");
                    if DscApp.FindFirst() then
                        Report.Run(Report::"Dividend Loan Appraisal Score", true, false, DscApp);
                end;
            }
            action("Make Changes")
            {
                Image = ManualExchangeRate;
                ApplicationArea = All;

                trigger OnAction()
                var

                    FieldsRef: Record "Field";
                    Rcpt: Record "Member Changes";
                    RegistryMngt: Codeunit "Registry Mngt.";
                begin
                    Rcpt.Reset();
                    Rcpt.SetRange("Member No.", Rec."No.");
                    Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
                    IF Rcpt.Count > 5 then begin
                        ERROR(ErrorOnTxtUnpApplic, Rcpt."No.");
                    END;
                    Response := ConfirmPost();
                    RegistryMngt.fnCustomerEntries(Rec, Response);

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
                    TempEmailItem.AddSourceDocument(Database::Member, Rec.SystemId);
                    TempEmailitem."Send to" := Rec."E-Mail";
                    TempEmailItem.Send(false, EmailScenario::Default);
                end;
            }
            action(UploadAttachments)
            {
                ApplicationArea = All;
                Caption = 'Upload Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachment: Codeunit "Document Attachment Custom";
                    FileName: Text;
                begin
                    FileName := DocumentAttachment.UploadMemberDocument(Rec.RecordId, Enum::"EDMS Document Type"::"Member Personal File");
                end;
            }
        }
        area(reporting)
        {
            action(Repayment)
            {
                Image = AbsenceCategory;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // REPORT.RUN(52140703,TRUE,FALSE,CustMembr);
                end;
            }

            action("Loan Statement")
            {
                Image = ServiceOrderSetup;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."No.");
                    if CustMembr.Find('-') then
                        Report.Run(Report::"Standard Statement-Loans", true, false, CustMembr);
                end;
            }
            action(Statement)
            {
                Caption = 'Detailed Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange(CustMembr."No.", Rec."No.");
                    IF CustMembr.Find('-') then
                        REPORT.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
                end;
            }
            action("Loans Guaranteed")
            {
                Caption = 'Guarateed Loan Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", Rec."No.");
                    IF CustMembr.FIND('-') then
                        REPORT.RUN(Report::"Member Loan Guaranteed", true, false, CustMembr);
                end;
            }
            action("Loan Guarantors")
            {
                Caption = 'Guarantor Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PLoan: Record Loans;
                begin
                    PLoan.Reset();
                    PLoan.SetRange("Account No.", Rec."No.");
                    if PLoan.Find('-') then
                        Report.Run(Report::"Member Loan Guarantors", true, false, PLoan);
                end;
            }
            group("Demand Letters-Asset")
            {
                Image = HRSetup;
                Enabled = false;

                action(Notice1)
                {
                    Caption = 'Notice 1';
                    Image = CustomerGroup;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PLoan: Record Loans;
                    begin
                        CustMembr.RESET;
                        CustMembr.SETRANGE(CustMembr."No.", Rec."No.");
                        IF CustMembr.FIND('-') then
                            Report.Run(Report::"Defaulter Notice-1", true, false, CustMembr);
                    end;
                }
                action(Notice2)
                {
                    Caption = 'Notice 2';
                    Image = CustomerGroup;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PLoan: Record Loans;
                    begin
                        CustMembr.RESET;
                        CustMembr.SETRANGE(CustMembr."No.", Rec."No.");
                        IF CustMembr.FIND('-') then
                            Report.Run(Report::"Defaulter Notice-2", true, false, CustMembr);
                    end;
                }
                action(Notice3)
                {
                    Caption = 'Loans Within Deposits';
                    Image = CustomerGroup;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PLoan: Record "Loans Categorization";
                    begin
                        PLoan.RESET;
                        PLoan.SETRANGE("Account No.", Rec."No.");
                        IF PLoan.FIND('-') then
                            Report.Run(Report::"Defaulter Notice-3", true, false, PLoan);
                    end;
                }

            }
            group("Defaulter Notices")
            {
                Image = History;
                Enabled = false;
                action(DefaulterNotice1)
                {
                    Caption = 'Defaulter Notice 1';
                    Image = NonStockItemSetup;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PLoan: Record Loans;
                    begin
                        CustMembr.RESET;
                        CustMembr.SETRANGE(CustMembr."No.", Rec."No.");
                        IF CustMembr.FIND('-') then
                            Report.Run(Report::"Demand Letter-1", true, false, CustMembr);
                    end;
                }
                action(DefaulterNotice2)
                {
                    Caption = 'Defaulter Notice 2';
                    Image = NonStockItemSetup;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PLoan: Record Loans;
                    begin
                        CustMembr.RESET;
                        CustMembr.SETRANGE(CustMembr."No.", Rec."No.");
                        IF CustMembr.FIND('-') then
                            Report.Run(Report::"Demand Letter 2", true, false, CustMembr);
                    end;
                }
                action(DefaulterNotice3)
                {
                    Caption = 'Defaulter Notice 3';
                    Image = NonStockItemSetup;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PLoan: Record Loans;
                    begin
                        CustMembr.Reset();
                        CustMembr.SetRange(CustMembr."No.", Rec."No.");
                        IF CustMembr.FindFirst() then
                            Report.Run(Report::"Demand Letter-Final", true, false, CustMembr);
                    end;
                }

            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Make Changes_Promoted"; "Make Changes")
                {
                }
                actionref(Email_Promoted; Email)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Comment Line_Promoted"; "Comment Line")
                {
                }
                actionref(Repayment_Promoted; Repayment)
                {
                }
                actionref("Loan Statement_Promoted"; "Loan Statement")
                {
                }
                actionref(Statement_Promoted; Statement)
                {
                }
                actionref("Loans Guaranteed_Promoted"; "Loans Guaranteed")
                {
                }
                actionref("Loan Guarantors_Promoted"; "Loan Guarantors")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Dividend Instructions_Promoted"; "Dividend Instructions")
                {
                }
                actionref("Dividend Deduction_Promoted"; "Dividend Deduction")
                {
                }
                actionref(DividendRegister_Promoted; DividendRegister)
                {
                }
                actionref(Dividendprogression_Promoted; Dividendprogression)
                {
                }
                actionref(DividendStatement_Promoted; DividendStatement)
                {
                }
                actionref("Account Signatory_Promoted"; "Account Signatory")
                {
                }
                actionref("Defaulter Information_Promoted"; "Defaulter Information")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Bank Accounts_Promoted"; "Bank Accounts")
                {
                }
                actionref("Dividend Progression_Promoted"; "Dividend Progression")
                {
                }
                actionref("Member Statistics_Promoted"; "Member Statistics")
                {
                }
                actionref("Accounts Banking_Promoted"; "Accounts Banking")
                {
                }
                actionref("Accounts Credit_Promoted"; "Accounts Credit")
                {
                }
                actionref("Kin Account_Promoted"; "Kin Account")
                {
                }
                actionref("Repayment Account_Promoted"; "Repayment Account")
                {
                }
                actionref("Next Of Kin_Promoted"; "Next Of Kin")
                {
                }
                actionref("Monthly Contribution_Promoted"; "Monthly Contribution")
                {
                }
                actionref("Witness Contact_Promoted"; "Witness Contact")
                {
                }
                actionref("Create Contact_Promoted"; "Create Contact")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref("Allocation Details_Promoted"; "Allocation Details")
                {
                }
                actionref("Generate Mobile Score_Promoted"; "Generate Mobile Score")
                {
                }
                actionref("View Mobile Score_Promoted"; "View Mobile Score")
                {
                }
                actionref("Generate Dividend Score_Promoted"; "Generate Dividend Score")
                {
                }
                actionref("Member File_Promoted"; "Member File")
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Dividends', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref(Notice1_Promoted; Notice1)
                {
                }
                actionref(Notice2_Promoted; Notice2)
                {
                }
                actionref(Notice3_Promoted; Notice3)
                {
                }
                actionref(DefaulterNotice1_Promoted; DefaulterNotice1)
                {
                }
                actionref(DefaulterNotice2_Promoted; DefaulterNotice2)
                {
                }
                actionref(DefaulterNotice3_Promoted; DefaulterNotice3)
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                actionref(UploadAttachments_Promoted; UploadAttachments)
                {
                }
            }
        }
    }



    trigger OnOpenPage()
    var
        Filterstring: Text[250];
        FilterRespCentre: Code[10];
    begin


    end;

    trigger OnAfterGetRecord()
    var
        HrDates: Codeunit "Date Conversion";
    begin
        if Rec."Date of Birth" <> 0D then
            MembAge := HrDates.DetermineAge(Rec."Date of Birth", Today) else
            MembAge := '';

        CustEmployer.Reset();
        CustEmployer.SetRange("No.", Rec."Employer Code");
        if CustEmployer.FindFirst() then begin
            EmployerName := CustEmployer.Name;
        end else begin
            EmployerName := '';
        end;

    end;

    var
        MembAge: Text[150];
        DocMngt: Codeunit "Doc. Mngt";
        CustEmployer: Record Customer;
        Varvariant: Variant;
        EmployerName: Text[150];
        Usersetup: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
        CustMembr: Record Member;

        AccountSignatories: Record "Account Signatories";
        AccountAssociations: Record "Account Association";
        EntryNo: Integer;
        Response: Integer;
        LoanArrear: Decimal;
        LoanT: Record "Loans Categorization";
        ErrorOnTxtUnpApplic: Label 'There is still open/pending application %1 that is still in the process.';

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Member Details,&Image Details,&Kin Details';
        ShipInvoiceQstMngt: Label 'Please select option on the type of change you want to initiate';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 3 then
            DefaultOption := 3;
        if DefaultOption <= 0 then
            DefaultOption := 1;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, ShipInvoiceQstMngt);
        PassInt := Selection;
        if Selection = 0 then
            exit;
        exit(PassInt);
    end;
}




