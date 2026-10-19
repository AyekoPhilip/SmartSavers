page 50904 "Recovery Header"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Recovery Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    Editable = false;
                    StyleExpr = true;
                    trigger OnValidate()
                    begin
                        if Rec."Posting Date" < Today then
                            Error('Posting cannot be less than today');
                    end;
                }
                field("Post As"; Rec."Post As")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    Editable = false;

                }

                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ValuesAllowed = 1, 2;
                    StyleExpr = true;
                    Editable = true;
                }
                field(" Shares Recovery Options"; Rec."Shares Recovery Options")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = Rec."Application Type" = Rec."Application Type"::"Recovery from Shares";
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Guarantor Recovery Options"; Rec."Guarantor Recovery Options")
                {
                    ApplicationArea = All;
                    Editable = Rec."Application Type" = Rec."Application Type"::"Recover from guarantors";
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Account to Debit"; Rec."Account to Debit")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = Rec."Application Type" = Rec."Application Type"::"Fosa Recovery";
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Acrued Interest Options"; Rec."Acrued Interest Options")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Available Balance"; Rec."Available Balance")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Recovery Type"; Rec."Recovery Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Recovery Type" = Rec."Recovery Type"::"Specific Loan";
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            part(Control29; "Disbursement Lines")
            {
                SubPageLink = No = field("No."),
                "Default Account No." = field("Account No.");
                Visible = Rec."Application Type" = Rec."Application Type"::"Recovery from Shares";
                ApplicationArea = All;
            }
            part(Control30; "Recovery Line")
            {
                SubPageLink = No = field("No.");
                Visible = Rec."Application Type" = Rec."Application Type"::"Recover from guarantors";
                ApplicationArea = All;
            }
            part(Control25; "Loan Application ListPart")
            {
                Caption = 'Loan List';
                SubPageLink = "Recovery Header No." = field("No.");
                SubPageView = where("Application Type" = filter(Defaulter), "Approval Status" = filter(<> Rejected));
                Visible = Rec."Guarantor Recovery Options" = Rec."Guarantor Recovery Options"::"Create Loan";
                ApplicationArea = All;
            }
            group(Computation)
            {
                field("Shares Deposits"; Rec."Shares Deposits")
                {
                    Editable = false;
                    Caption = 'Deposits';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Outstanding Insurance"; Rec."Outstanding Insurance")
                {
                    Editable = false;
                    Style = StandardAccent;
                    Caption = 'Insurance Balance';
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    Editable = false;
                    Style = StandardAccent;
                    Caption = 'Interest Balance';
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Outstanding Bill"; Rec."Outstanding Bill")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Caption = 'Bill Balance';
                    StyleExpr = true;
                }
                field("Outstanding Principal"; Rec."Outstanding Principal")
                {
                    ApplicationArea = All;
                    Caption = 'Principal Balance';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    Editable = false;
                    Style = StandardAccent;
                    Caption = 'Total Balance';
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Total Loans Bal."; Rec."Total Loans Bal.")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Total Deposit Recovered';
                    ApplicationArea = All;

                }
                field("Total Amount LCY"; Rec."Total Amount LCY")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shares Deductable"; Rec."Shares Deductable")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Deposits Deductable';
                    ApplicationArea = All;

                }
                field("No of Active Loans"; Rec."No of Active Loans")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

            }
            group("Trail Information")
            {
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

            }

        }
        area(factboxes)
        {
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
        area(processing)
        {
            action(Guarantors)
            {
                Caption = 'View Guarantors';
                Image = Group;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    CredMgt.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
                end;
            }
            action(Post)
            {
                Image = TraceOppositeLine;
                Enabled = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                begin

                    ResponseTxt := 0;
                    ResponseTxt := ConfirmPost();
                    case ResponseTxt of
                        1:
                            begin
                                Rec."Post Journal" := true
                            end;
                        2:
                            begin
                                Rec."Post Journal" := false;
                            end else begin
                            exit
                        end;
                    end;
                    Rec.Modify(true);
                    Codeunit.Run(Codeunit::"Purch. Recov.-Post (Yes/No)", Rec)
                end;
            }
            action("Send Email")
            {
                Image = Email;
                ApplicationArea = All;

                trigger OnAction()
                var
                    MngtNotif: Codeunit "SMS Notification";
                begin
                    case Rec."Application Type" of
                        Rec."Application Type"::"Recover from guarantors":
                            MngtNotif.SendPaymentCertificate(Rec."No.");
                        Rec."Application Type"::"Recovery from Shares":
                            MngtNotif.SendNoticeFinal(Rec."No.");
                    end;

                end;
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = true;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";

                    begin
                        Rec.fnCheckMinRequirement();
                        VarVariant := Rec;
                        ApprovalsMgmt.OnSendRecoveryHeaderApprovalRequest(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        CredMgt.ApplicationDocPane(VarVariant, ActItems::Statement)
                    end;
                }
                action(OpenApprovalRequest)
                {
                    Caption = 'Open Approval Re&quest';
                    Enabled = true;
                    Image = Category;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        VarVariant := Rec;
                        ApprovalsMgmt.OnOpenRecoveryHeaderApprovalRequest(Rec, true, true)
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                    Image = Delegate;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.findDelegatedApprovalEntry(Rec."No.");
                    end;
                }
                action("Reject Approval Request")
                {
                    Image = Reject;
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
                    RunObject = Page "Approval Requests";
                    RunPageLink = "Document No." = field("No.");
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                    end;
                }
                action("Member Statement")
                {
                    Image = SpecialOrder;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        CredMgt.ApplicationDocPane(VarVariant, ActItems::"Salary Details")
                    end;
                }
                action("Loan File")
                {
                    Image = FiledOverview;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        CredMgt.ApplicationDocPane(VarVariant, ActItems::"Loan History")
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Post_Promoted; Post)
                {
                }
                actionref("Send Email_Promoted"; "Send Email")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(Guarantors_Promoted; Guarantors)
                {
                }
                actionref("Member Statement_Promoted"; "Member Statement")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref(OpenApprovalRequest_Promoted; OpenApprovalRequest)
                {
                }
                actionref("Reject Approval Request_Promoted"; "Reject Approval Request")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Loan File', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Loan File_Promoted"; "Loan File")
                {
                }
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
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(Delegate_Promoted; Delegate)
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
        if (Rec."Approval Status" = Rec."Approval Status"::"Pending Approval") or (Rec."Approval Status" = Rec."Approval Status"::Approved) then
            CurrPage.Editable := false;
        SetControlAppearance;

    end;

    trigger OnOpenPage()
    begin
        if (Rec.Posted = false) and (rec."Approval Status" = rec."Approval Status"::Open) then
            CurrPage.Editable := true else
            CurrPage.Editable := false;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");

        MembApplic.Reset;
        MembApplic.SetRange("Entered By", UserId);
        MembApplic.SetFilter("Approval Status", '%1|%2', MembApplic."Approval Status"::Open, MembApplic."Approval Status"::"Pending Approval");
        if MembApplic.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnTransactions);
        end;

        Rec."Acrued Interest Options" := Rec."Acrued Interest Options"::"Ignore Acrued Interest";
        Rec."Post As" := Rec."Post As"::"Post as User";
        Rec."Application Source" := Rec."Application Source"::Manual;

    end;

    var
        CredMgt: Codeunit "Credit Mgmt.";
        MembApplic: Record "Recovery Header";
        ErrorOnTransactions: Label 'There are still some pending document(s) on your account. Please list & select the pending document to use';
        Temp: Record "User Setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        ActItems: Enum ActionPanesItems;
        ResponseTxt: Integer;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Post,&Post Preview';
        DefaultOption: Integer;
        PassInt: Integer;
    begin

        if DefaultOption > 2 then
            DefaultOption := 2;
        if DefaultOption <= 0 then
            DefaultOption := 0;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to Post');
        PassInt := Selection;

        if Selection = 0 then
            exit;
        exit(PassInt);
    end;
}




