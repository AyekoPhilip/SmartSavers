page 51018 "Mobile Registration Page"
{
    Caption = 'Mobile Registration Page';
    PageType = Card;
    SourceTable = "Dsc Mobile Application";
    DeleteAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Application No"; Rec."Application No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                    ToolTip = 'Specifies the value of the Application No field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Customer ID No"; Rec."Customer ID No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Customer ID No field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Mobile Mobile No"; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Mobile Mobile No field.';
                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Application Type field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Comments field.';
                }

                field("I agree information is true"; Rec."I agree information is true")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the I agree information is true field.';
                }

            }
            part(Control; "Mobile Application Line")
            {
                Caption = 'Line';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
                Editable = false;

            }
            group("Trail Information")
            {
                Editable = false;
                field(Changed; Rec.Changed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Changed field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Entered field.';
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entered By field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Entered field.';
                }
                field("Sent To Server"; Rec."Sent To Server")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sent To Server field.';
                }

            }

        }
        area(factboxes)
        {
           
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        area(Creation)
        {

        }
        area(Processing)
        {
            group(Approval)
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.PostApprovalOnDocument(1);
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
                        Rec.PostApprovalOnDocument(2);
                    end;
                }
                action(OpenApprovalRequest)
                {
                    Caption = 'Open Approval Re&quest';
                    Image = Category;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.PostApprovalOnDocument(3);
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
                        Rec.PostApprovalOnDocument(4);
                    end;
                }
            }

        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
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
                actionref(OpenApprovalRequest_Promoted; OpenApprovalRequest)
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
        }

    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        MembApplic.Reset;
        MembApplic.SetRange("Entered By", UserId);
        MembApplic.SetFilter("Approval Status", '%1|%2', MembApplic."Approval Status"::Open, MembApplic."Approval Status"::"Pending Approval");
        if MembApplic.Count > 5 then begin
            Error(ErrorOnTransactions);
        end;

    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then CurrPage.Editable := false;

    end;

    var
        MembApplic: Record "Dsc Mobile Application";
        ErrorOnTransactions: Label '';
}



