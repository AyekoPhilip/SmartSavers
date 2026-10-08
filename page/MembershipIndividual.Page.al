page 50791 "Membership Individual"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Member;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = true;
                field(Name; Rec.Name)
                {
                    Visible = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    ShowCaption = false;
                    StyleExpr = true;
                }

                field("Old Member No."; Rec."Old Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    ShowCaption = true;
                    StyleExpr = true;
                }
                field("First Name"; Rec."First Name")
                {
                    Style = StandardAccent;
                    Importance = Additional;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Second Name"; Rec."Second Name")
                {
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Importance = Additional;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Importance = Additional;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Other Name"; Rec."Other Name")
                {
                    Style = StandardAccent;
                    Importance = Additional;
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Visible = false;

                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    Caption = 'Date Of birth';
                    Editable = true;
                    Visible = true;
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
                field("Identification Type"; Rec."Identification Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    Caption = 'ID No.';
                    Editable = true;
                    Visible = GroupAccout;
                    ApplicationArea = All;
                }
                field("PIN No."; Rec."PIN No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Caption = 'PIN No.';
                    StyleExpr = true;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Member Category"; Rec."Member Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Station/Department"; Rec."Station/Department")
                {
                    ApplicationArea = All;
                    Caption = 'Station';
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Group Account No."; Rec."Group Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
                field(Gender; Rec.Gender)
                {
                    Visible = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    Editable = true;
                    Visible = GroupAccout;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        Rec.TestField("Employer Code");
                    end;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    Editable = false;
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
                field(LoanArrear; LoanArrear)
                {
                    Editable = false;
                    Caption = 'Loan Arrears';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Idemnity; Rec.Idemnity)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }

            }
            group("Address & Contact")
            {
                field("Post Code"; Rec."Post Code")
                {
                    Caption = 'Postal Code';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Current Address"; Rec."Current Address")
                {
                    Caption = 'Current Postal Address';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Home Address"; Rec."Home Address")
                {
                    Caption = 'Permanent Postal Address';
                    ApplicationArea = All;
                }

                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field("Country/Region"; Rec."Country/Region")
                {
                    ApplicationArea = All;
                    Caption = 'Country of Residence';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    Caption = 'County/District';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    Caption = 'Residence/Estate';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Office Telephone No."; Rec."Office Telephone No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("MPESA Mobile No"; Rec."MPESA Mobile No")
                {
                    Caption = 'Other Phone No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("E-mail (Personal)"; Rec."E-mail (Personal)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Secondary E-Mail';

                }
            }
            group("Other Information")
            {
                field("Recruited by Type"; Rec."Recruited by Type")
                {
                    ApplicationArea = All;

                }
                field("Recruited By"; Rec."Recruited By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Recruited By Name"; Rec."Recruited By Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Segment"; Rec."Member Segment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Membership Type"; Rec."Membership Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }

                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pay Point"; Rec."Pay Point")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    Caption = 'Payroll Agency Code';

                }
                field("Pay Point Name"; Rec."Pay Point Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    Caption = 'Pay Point Agency';

                }
                field("Principal Member No."; Rec."Principal Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
            }
            group("Bank Details")
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Trail Information")
            {

                field("Responsibility Center"; Rec."Responsibility Center")
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
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Last Statement Date"; Rec."Last Statement Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    TableRelation = "User Setup"."User ID";
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("File No."; Rec."File No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File No. field.';
                    Editable = false;
                }
                field("Telex No."; Rec."Telex No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File No. field.';
                    Editable = false;
                }

            }
        }
        area(factboxes)
        {
            part(Comments; "Comment Facbox")
            {
                Caption = 'Comments';
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
           
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
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
            action(DividendSlip)
            {
                Image = Database;
                Caption = 'Dividend Slip';
                ApplicationArea = All;
                trigger OnAction()
                var
                   DivProcMgt: Codeunit "Dividend Process";
                    Divprogression: Record "Dividend Progression";
                    DivProgressionslip: Report "Dividend Slip";
                    Dividendsetup: Record "Dividend SetUp";
                    InterestOptions: Enum "Rcv12 Dividend Interest Option";
                begin

                    Dividendsetup.Get();
                    Dividendsetup.TestField("Start Date");
                    Dividendsetup.TestField("End Date");
                    InterestOptions := InterestOptions::"Monthly Accrual";
                    DivProcMgt.fngetIndividualCustDiv(Rec."No.", 1, Dividendsetup."Start Date",
                    Dividendsetup."End Date", InterestOptions);

                end;
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
            action(ChannelsStatement)
            {
                Caption = 'Statement- Channels';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange(CustMembr."No.", Rec."No.");
                    IF CustMembr.Find('-') then
                        Report.Run(Report::"Standard Statement-Alt Channel", true, false, CustMembr);
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
                actionref(ChannelsStatement_Promoted; ChannelsStatement)
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
                actionref(DividendSlip_Promoted; DividendSlip)
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
                Caption = 'Notices', Comment = 'Generated from the PromotedActionCategories property index 7.';

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
                Caption = 'Attachments', Comment = 'Generated from the PromotedActionCategories property index 9.';

                actionref(UploadAttachments_Promoted; UploadAttachments)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        HrDates: Codeunit "Date Conversion";
    begin

        lblIDVisible := true;
        lblDOBVisible := true;
        lblRegNoVisible := false;
        lblRegDateVisible := false;
        lblGenderVisible := true;
        txtGenderVisible := true;
        lblMaritalVisible := true;
        txtMaritalVisible := true;

        if RecoveryCategoryReviewRequired() then begin
            lblIDVisible := false;
            lblDOBVisible := false;
            lblRegNoVisible := true;
            lblRegDateVisible := true;
            lblGenderVisible := false;
            txtGenderVisible := false;
            lblMaritalVisible := false;
            txtMaritalVisible := false;
        end;

        if Rec."Global Dimension 1 Code" <> 'MICRO' then begin
            GroupDetailsVisible := false;
            txtMaritalVisible := false;
        end else begin
            GroupDetailsVisible := true;
        end;

        if Rec."Date of Birth" <> 0D then
            MembAge := HrDates.DetermineAge(Rec."Date of Birth", Today) else
            MembAge := '';

        LoanArrear := 0;

        LoanT.Reset();
        LoanT.SetRange("Account No.", Rec."No.");
        LoanT.SetFilter("Outstanding Balance", '>0');
        if LoanT.FindSet() then begin
            LoanT.CalcSums("Amount In Arrears");
            LoanArrear := LoanT."Amount In Arrears";
        end;

    end;

    trigger OnInit()
    begin

        txtMaritalVisible := true;
        lblMaritalVisible := true;
        txtGenderVisible := true;
        lblGenderVisible := true;
        lblRegDateVisible := true;
        lblRegNoVisible := true;
        lblDOBVisible := true;
        lblIDVisible := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Global Dimension 1 Code" <> 'MICRO' then begin
            GroupDetailsVisible := false;
            txtMaritalVisible := false;
        end else begin
            GroupDetailsVisible := true;
        end;
    end;

    trigger OnOpenPage()
    begin
        RecoveryCategoryReviewRequired();
        LoanArrear := 0;

        if Rec.Hide = true then begin
            if UserSetup.Get(UserId) then begin
                if UserSetup."Show Hidden" = false then
                    Error('You do not have permissions to view this account information.');
            end;
        end;
        GroupControls;
        if Rec."Global Dimension 1 Code" <> 'MICRO' then begin
            GroupDetailsVisible := false;
            txtMaritalVisible := false;
        end else begin
            GroupDetailsVisible := true;
        end;
    end;

    var

        lblIDVisible: Boolean;

        lblDOBVisible: Boolean;

        lblRegNoVisible: Boolean;

        lblRegDateVisible: Boolean;

        lblGenderVisible: Boolean;

        txtGenderVisible: Boolean;

        lblMaritalVisible: Boolean;

        txtMaritalVisible: Boolean;
        ErrorOnTxtUnpApplic: Label 'There is still open/pending application %1 that is still in the process.';
        GroupAccout: Boolean;
        GroupDetails: Boolean;
        GroupDetailsVisible: Boolean;
        CustMembr: Record Member;
        UserSetup: Record "User Setup";
        AccountSignatories: Record "Account Signatories";
        AccountAssociations: Record "Account Association";
        EntryNo: Integer;
        MembAge: Text[150];
        Response: Integer;
        LoanArrear: Decimal;
        LoanT: Record "Loans Categorization";


    local procedure GroupControls()
    begin
        if Rec."Group Type" <> Rec."Group Type"::" " then begin
            GroupAccout := false;
            GroupDetails := true;
        end else begin
            GroupAccout := true;
            GroupDetails := false;
        end;
    end;

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
    // User-requested recovery block: donor ProductDimension has no confirmed mapping
    // to SmartSaver Member/Staff Members/Board Members/Delegates categories.
    local procedure RecoveryCategoryReviewRequired(): Boolean
    begin
        Error('This membership page is temporarily blocked during SmartSaver recovery. Its account-category logic must be reviewed before use.');
    end;
}




