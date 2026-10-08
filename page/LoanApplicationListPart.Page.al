namespace SaccoDatabase.SaccoDatabase;

page 50065 "Loan Application ListPart"
{
    ApplicationArea = All;
    Caption = 'Loan Application List';
    PageType = ListPart;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
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
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Loan Card")
            {
                Caption = 'Loan Page';
                Image = SocialSecurity;
                trigger OnAction()
                begin
                    LoanApplic.SetRange("No.", Rec."No.");
                    if LoanApplic.FindFirst() then
                        Page.Run(Page::"Loan Application Card", LoanApplic, LoanApplic."No.");
                end;
            }
            action(SendApprovalRequest)
            {
                Caption = 'Send A&pproval Request';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                Image = SendApprovalRequest;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanApp: Record Loans;
                    ProdFac: Record "Product Factory";
                    LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                    TotGuarant: Decimal;
                    ApprovalsMgmt: Codeunit "Approval Mgmt.";
                begin
                    ApprovalsMgmt.OnSendLoanApplicationApprovalRequest(Rec, 0);
                    CurrPage.Close();
                end;
            }
            action(CancelApprovalRequest)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approval Mgmt.";
                begin
                    ApprovalsMgmt.OnCancelLoanApplicationApprovalRequest(Rec, true, true);
                    CurrPage.Close();
                end;
            }
            action("Reject Application")
            {
                Image = Reject;
                Caption = 'Reject Approval Request';
                Visible = true;
                Enabled=false;
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
        }
    }
    var
        LoanApplic: Record "Loan Application";
}
