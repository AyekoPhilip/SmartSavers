page 51098 "Loan Restructure"
{
    DeleteAllowed = false;
    PageType = Card;
    InsertAllowed = true;
    RefreshOnActivate = true;
    SourceTable = "Loan Application";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                Caption = 'General';
                field("CRM Application No."; Rec."CRM Application No.")
                {
                    Caption = 'CRM Application No.';
                    Importance = Additional;
                    Visible = false;
                    Editable = ApplicationEditables;
                    ApplicationArea = All;
                }
                field("Group Code"; Rec."Group Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = ApplicationEditable;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        CustMember: Record Member;
                    begin
                        MemberAge := Rec.getCustomerAge();
                    end;
                }
                field(Age; MemberAge)
                {
                    Style = StandardAccent;
                    Caption = 'Age';
                    StyleExpr = true;
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field("Shares Deposit"; Rec."Shares Deposit")
                {
                    Style = StandardAccent;
                    Caption = 'Ordinary Savings';
                    StyleExpr = TRUE;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Savings Balance(LCY)"; Rec."Savings Balance(LCY)")
                {
                    Style = StandardAccent;
                    Visible = false;
                    Caption = 'School Fee Savings';
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }

                field("Qualifying Dividend Amount"; Rec."Qualifying Dividend Amount")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;


                }
                field("Total Balance"; Rec."Total Balance")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Shares Banding"; Rec."Shares Banding")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;

                }
                field("Sacco Deductions"; Rec."Sacco Deductions")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    Importance = Additional;

                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Calculation Method"; Rec."Interest Calculation Method")
                {
                    Caption = 'Repayment Method';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Terms of Employment"; Rec."Terms of Employment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Importance = Additional;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    Caption = 'Amount Applied';
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    Caption = 'Approved Amount';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Adjust Approved Amount"; Rec."Adjust Approved Amount")
                {
                    Editable = true;
                    Visible = false;
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Amount to Disburse"; Rec."Amount to Disburse")
                {
                    Caption = 'Net Amount';
                    Editable = false;
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Amount to Post"; Rec."Amount to Post")
                {
                    Caption = 'Amount to Disburse';
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
                field("Total Disbured"; Rec."Total Disbured")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    Caption = 'Recommended Amount';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        if Rec.Repayment < xRec.Repayment then
                            Error(ErrorMessageOnRepayAmountTxt);
                    end;
                }
                field("Interest Repayment"; Rec."Interest Repayment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }


                field("Loan Rejection Reason"; Rec."Loan Rejection Reason")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Self Guarantee"; Rec."Self Guarantee")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field(Idemnity; Rec.Idemnity)
                {
                    Editable = false;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

            }
            group("Savings & Purchases")
            {
                field(Sectors; Rec.Sectors)
                {

                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Sub Sectors"; Rec."Sub Sectors")
                {

                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Purpose of Loan"; Rec."Purpose of Loan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Other Purpose"; Rec."Other Purpose")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    ValuesAllowed = 1, 2, 4;
                    StyleExpr = true;
                }
                field("Deposit Purchase Account"; Rec."Deposit Purchase Account")
                {
                    ApplicationArea = All;
                    Caption = 'Account Purchase';
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deposit Purchase"; Rec."Deposit Purchase")
                {
                    Caption = 'Purchase Amount';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            group("Payment Information")
            {
                Caption = 'Batch & Payment Information';
                Editable = false;
                field("Post Application As"; Rec."Post Application As")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    Editable = false;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Loan Payment Destination"; Rec."Loan Payment Destination")
                {
                    Visible = false;

                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    Editable = true;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                }
                field("Payment Destination"; Rec."Payment Destination")
                {
                    Editable = true;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field(CustBankName; CustBankName)
                {
                    ShowCaption = false;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ApplicationArea = All;

                }
                field("EFT Options"; Rec."EFT Options")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ApplicationArea = All;

                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Swift Code"; Rec."Swift Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    Caption = 'EFT Swift Code';
                    ApplicationArea = All;

                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }
                field("Disbursement Destination"; Rec."Disbursement Destination")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;

                    StyleExpr = TRUE;
                }
                field("Disbursement Account No."; Rec."Disbursement Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;

                    StyleExpr = TRUE;
                }
                field("Loan Account"; Rec."Loan Account")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total TopUp"; Rec."Total TopUp")
                {
                    ApplicationArea = All;
                    Caption = 'Total Restructed';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Total TopUp"; Rec."Outstanding Total TopUp")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Balance';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charges & Commissions"; Rec."Charges & Commissions")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Trail Information")
            {

                Caption = 'Trail Information';
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    Editable = false;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }

                field(Minute; Rec.Minute)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    visible = true;
                    ApplicationArea = All;
                }

                field("Billing Type"; Rec."Billing Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    visible = false;
                    ApplicationArea = All;
                }
                field("Charge Interest on Posting"; Rec."Charge Interest on Posting")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    Visible = false;
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Mode"; Rec."Repayment Mode")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Appraisal Parameter Type"; Rec."Appraisal Parameter Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Captured By"; Rec."Captured By")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
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
            part(Control7; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Account No."),
                                             "Account Category" = const("Shares Deposit");
                Visible = true;
                ApplicationArea = All;
            }
            part("Banking History"; "Account Statistics FactBox")
            {
                Caption = 'Banking Statistics';
                SubPageLink = "Member No." = field("Account No.");
                SubPageView = where("Account Category" = const("Specialty Savings"));
                ApplicationArea = All;
            }
            part(Comment; "Loan Comment Line")
            {
                Visible = false;
                SubPageLink = "No." = field("Account No.");
                Caption = 'Comment Line';
            }
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }

        }
    }



    actions
    {
        area(navigation)
        {
            action("Loan Payment Schedule")
            {
                Caption = 'Payment Schedule';
                Image = CalculateCost;
                RunObject = Page "Loan Payment Schedule";
                Visible = false;
                ApplicationArea = All;
            }
            action(Collateral)
            {
                Image = SocialSecurity;
                Visible = false;
                RunObject = Page "Collateral Registers";
                RunPageLink = "Account No." = field("Account No.");
                ApplicationArea = All;
            }
            action("Repayment  Schedule")
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    PeriodItems.ApplicationDocPane(
                    VarVariant, ActItems::RepaymentSchedule)
                end;
            }
            action("Loan Appraisal Report")
            {
                Caption = 'Loan Appraisal';
                Image = ReservationLedger;
                ApplicationArea = All;
                trigger OnAction()
                var
                    MultDep: Record "Deposit Multiplier";
                    Loan: Record Loans;
                    FactP: Record "Product Factory";
                    MultDeposit: Record "Deposit Multiplier";
                begin

                    VarVariant := Rec;
                    PeriodItems.ApplicationDocPane(
                    VarVariant, ActItems::"Loan Appraisal")
                end;
            }

            action(Statement)
            {
                Caption = 'Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Account No.");
                    IF CustMembr.Find('-') then
                        Report.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
                end;
            }
            action("Loan History")
            {
                Image = History;
                RunObject = Page "Loans List Posted";
                Visible = true;
                RunPageLink = "Account No." = field("Account No.");
                ApplicationArea = All;
            }
            action("Member Page")
            {
                Image = Customer;
                Caption = 'Member';
                RunObject = Page "Membership Individual";
                Visible = true;
                RunPageLink = "No." = field("Account No.");
                ApplicationArea = All;
            }
            action("Member Dividend")
            {
                Caption = 'Dividend Statement';
                Image = ReservationLedger;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DivProg: Record "Dividend Progression";
                begin
                    DivProg.Reset();
                    DivProg.SetRange("Member No", Rec."Account No.");
                    if DivProg.FindFirst() then begin
                        Report.Run(Report::"Dividend Statement", true, false, DivProg);
                    end;
                end;
            }
            action("Comment Line")
            {
                Caption = 'Comment Line';
                Image = Comment;
                Visible = false;
                ApplicationArea = All;
                RunObject = page "Comment Sheet Line";
                RunPageLink = "No." = field("Account No.");
                trigger OnAction()
                var
                    CustomerMemb: Record Member;
                begin

                end;
            }
            action("Monthly Contribution")
            {
                Image = Category;
                RunObject = Page "Credit. Mgt Contribution";
                RunPageLink = "Account No." = field("Account No.");
                ApplicationArea = All;
            }
            action("Create Account")
            {
                Image = PrepaymentCreditMemo;
                ApplicationArea = All;
                Enabled = Rec."Approval Status"=Rec."Approval Status"::Approved;
                trigger OnAction()
                begin
                    VarVariant := Rec;
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    case Rec."Application Type" of
                        Rec."Application Type"::"Loan Restructure":
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Post Application")
                        else
                            Error(ErrorOnInvalidApplicType, Rec."Application Type"::"Loan Restructure");
                    end;

                end;
            }
            action("Agreement Form")
            {
                Image = Receipt;
                ApplicationArea = All;
                Enabled = true;
                trigger OnAction()
                var
                    LnApplic: Record "Loan Application";
                    AggreemtForm: Report "Loan Agreement Form";
                begin
                    LnApplic.Reset();
                    LnApplic.SetRange("No.", Rec."No.");
                    if LnApplic.FindFirst() then
                        Report.Run(Report::"Loan Agreement Form", true, false, LnApplic);
                end;
            }
        }
        area(processing)
        {
            group(Action3)
            {
                Caption = 'Approvals';
                Image = HRSetup;
                group("Approval Requests")
                {
                    Caption = 'Approval Requests';
                    Image = HRSetup;
                    action(SendApprovalRequest)
                    {
                        Caption = 'Send A&pproval Request';
                        Enabled = NOT OpenApprovalEntriesExist;
                        Image = SendApprovalRequest;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            LoanApp: Record Loans;
                            ProdFac: Record "Product Factory";
                            LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                            TotGuarant: Decimal;
                        begin

                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Send Approval Request");
                            CurrPage.Close();
                        end;
                    }
                    action(CancelApprovalRequest)
                    {
                        Caption = 'Cancel Approval Re&quest';
                        Image = CancelApprovalRequest;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Cancel Approval Request");
                            CurrPage.Close();
                        end;
                    }
                    action(DefferApprovalRequest)
                    {
                        Caption = 'Deffer Approval Re&quest';
                        Image = DefaultFault;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            VarVariant := Rec;
                            ApprovalsMgmt.OnDefferLoanApplicationApprovalRequest(Rec, true, true);
                            CurrPage.Close();
                        end;
                    }
                    action("Open Document")
                    {
                        Image = Category;
                        Caption = 'Open Approval Request';
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Open Request");
                            CurrPage.Close();
                        end;
                    }
                    action("Reject Application")
                    {
                        Image = Reject;
                        Caption = 'Reject Approval Request';
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprvlsMngt: Codeunit "Approval Mgmt.";
                            ApprovalEntries: Record "Approval Entries";
                        begin
                            ApprvlsMngt.RejectApprovalApplication(Rec."No.");
                            CurrPage.Close();
                        end;
                    }
                    action(Approvals)
                    {
                        Caption = 'Approvals';
                        Image = Approval;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprovalEntries: Page "Approval Entries";
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50554);
                        end;
                    }
                }
            }
            group("Associated Items")
            {
                Caption = 'Associated Items';
                Image = ProductDesign;
                group(Items)
                {
                    Caption = 'Items';
                    Image = ExecuteBatch;

                    action("Loan [File]")
                    {
                        Image = Category;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            FileName: Text;
                            NVInStream: InStream;
                            TempFile: File;
                            NewStream: InStream;
                            ToFileName: Variant;
                        begin

                        end;
                    }
                    action("External Payments")
                    {
                        Image = StepInto;
                        Enabled = false;
                        Caption = 'External Payment';
                        Visible = true;
                        RunObject = page "External Commitments";
                        RunPageLink = "Application No." = field("No.");
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Mandatory Requirements")
                    {
                        Image = RegisteredDocs;

                        RunObject = Page "Loan Required Documents";
                        ApplicationArea = All;
                    }
                }
            }
            group(Process)
            {
                Caption = 'Process';
                group("Process Item")
                {
                    Caption = 'Process Item';
                    Image = RegisteredDocs;
                    action("Loan Top Up")
                    {
                        Caption = 'Loan Restructure';
                        Image = AllocatedCapacity;
                        Enabled = true;
                        RunObject = Page "Topup-Restructure";
                        RunPageLink = "No." = field("No."), "Account No." = field("Account No.");
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
                        end;
                    }
                    action("Guarantors & Security")
                    {
                        Caption = 'Security';
                        Image = HRSetup;
                        Enabled = false;
                        RunObject = Page "Loan Guarantors and Security";
                        RunPageLink = "No." = FIELD("No."), "Member No. (Loanee)" = field("Account No.");
                        ApplicationArea = All;
                    }
                    action("External Commitments")
                    {
                        Image = StepInto;
                        Visible = false;
                        Enabled = false;
                        RunObject = page "Other Commitments Clearance";
                        RunPageLink = "Application No." = field("No.");
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Salary Details")
                    {
                        Image = StepOver;
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(
                            VarVariant, ActItems::"Salary Details")
                        end;
                    }
                    action("Salary Statistics")
                    {
                        Image = StepOut;
                        Enabled = false;
                        Visible = true;
                        ApplicationArea = All;
                        RunObject = page "Appraisal Salary Statistics";
                        RunPageLink = "No." = field("No.");
                        trigger OnAction()

                        begin

                        end;
                    }
                    action(Charges)
                    {
                        Image = Payment;
                        RunObject = Page "Charge Details";
                        RunPageLink = "No." = field("No.");
                        ApplicationArea = All;
                    }
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Loan Top Up_Promoted"; "Loan Top Up")
                {
                }
                actionref("Guarantors & Security_Promoted"; "Guarantors & Security")
                {
                }
                actionref("External Commitments_Promoted"; "External Commitments")
                {
                }
                actionref("Salary Details_Promoted"; "Salary Details")
                {
                }
                actionref(Charges_Promoted; Charges)
                {
                }
                actionref("Loan Payment Schedule_Promoted"; "Loan Payment Schedule")
                {
                }
                actionref(Collateral_Promoted; Collateral)
                {
                }
                actionref("Create Account_Promoted"; "Create Account")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Repayment  Schedule_Promoted"; "Repayment  Schedule")
                {
                }
                actionref("Loan Appraisal Report_Promoted"; "Loan Appraisal Report")
                {
                }
                actionref(Statement_Promoted; Statement)
                {
                }
                actionref("Member Dividend_Promoted"; "Member Dividend")
                {
                }
                actionref("Comment Line_Promoted"; "Comment Line")
                {
                }
                actionref("Monthly Contribution_Promoted"; "Monthly Contribution")
                {
                }
                actionref("Loan History_Promoted"; "Loan History")
                {
                }
                actionref("Member Page_Promoted"; "Member Page")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Loan File', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Associated Accounts', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref("External Payments_Promoted"; "External Payments")
                {
                }
                actionref("Salary Statistics_Promoted"; "Salary Statistics")
                {
                }
                actionref("Agreement Form_Promoted"; "Agreement Form")
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref(DefferApprovalRequest_Promoted; DefferApprovalRequest)
                {
                }
                actionref("Open Document_Promoted"; "Open Document")
                {
                }
                actionref("Reject Application_Promoted"; "Reject Application")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        MemberAge := 0;

        if ObjEmp.Get(Rec."Employer Code") then
            ObjName := UpperCase(ObjEmp.Name);
        Rec."Disbursement Destination" := Rec."Disbursement Destination"::"Banking Account";
        Rec."Application Type" := Rec."Application Type"::"Loan Restructure";
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            Rec.Validate("Disbursement Date", Today);
        MemberAge := Rec.getCustomerAge();

        CustBankName := '';

        case Rec."Loan Payment Destination" of
            Rec."Loan Payment Destination"::"Bank Account":
                begin
                    CustBank.Reset();
                    CustBank.SetRange(Code, Rec."Payment Destination Code");
                    if CustBank.FindFirst() then
                        CustBankName := CustBank.Name
                end;
            Rec."Loan Payment Destination"::Supplier:
                begin
                    if Vend.Get(Rec."Payment Destination Code") then
                        CustBankName := Vend.Name

                end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");

        LoanAc.Reset;
        LoanAc.SetRange("Captured By", UserId);
        LoanAc.SetRange("Approval Status", LoanAc."Approval Status"::Open);
        if LoanAc.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnMaxNoTransactions);
        end;

        Rec."Disbursement Destination" := Rec."Disbursement Destination"::"Banking Account";
        Rec."Application Type" := Rec."Application Type"::"Loan Restructure";
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            Rec.Validate("Disbursement Date", Today);
    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
        UpdateControls
    end;


    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        Vend: Record Vendor;
        ObjEmp: Record Customer;
        ObjName: Text[200];
        ActItems: Enum ActionPanesItems;
        Temp: Record "User Setup";
        CustBank: Record "Cust. Bank Account";
        CustBankName: Text[250];
        LoanAc: Record "Loan Application";
        ErrorOnInvalidApplicType: Label 'Application Type must be %1';
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';
        PeriodItems: Codeunit "Credit Mgmt.";
        ActionPanesItem: Option Agreement,"Loan BuyOff","Salary Details",RepaymentSchedule,Statement,"Loan Appraisal","Loan History","Post Application",File,"Send Approval Request","Cancel Approval Request","Open Request",Approvals;
        ErrorMessageOnRepayAmountTxt: Label 'Repayment Amount cannot be less than minimum repayment of %1';
        ApplicationEditable: Boolean;
        GeneralSetUp: Record "General Set-Up";
        ApplicationEditables: Boolean;
        MemberAge: Integer;
        HrDate: Codeunit "Date Conversion";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure UpdateControls()
    begin
        GeneralSetUp.Get;
        GeneralSetUp.TestField("Application Source (Loan)");
        case GeneralSetUp."Application Source (Loan)" of
            GeneralSetUp."Application Source (Loan)"::CRM:
                begin
                    ApplicationEditables := true;
                    ApplicationEditable := false;

                end;
            GeneralSetUp."Application Source (Loan)"::CBS:
                begin
                    ApplicationEditables := false;
                    ApplicationEditable := true;
                end;
        end
    end;
}
