page 50797 "Dividend Simulation Header"
{
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = "Dividend Simulation Header";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    ValuesAllowed = 1, 2;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = true;
                    StyleExpr = true;
                }
                field("Operation Type"; Rec."Operation Type")
                {
                    ApplicationArea = All;
                    Editable = true;
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posting Type"; Rec."Posting Type")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Posting Options"; Rec."Posting Options")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Ignore Withholding Tax"; Rec."Ignore Withholding Tax")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Post Capitalization"; Rec."Post Capitalization")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deduct QC Recovery"; Rec."Deduct QC Recovery")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deduct Dividend Loan"; Rec."Deduct Dividend Loan")
                {
                    ApplicationArea = All;
                    Caption = 'Deduct Dividend Discount';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deduct Non-Performing Loans"; Rec."Deduct Non-Performing Loans")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field(Deposits; Rec.Deposits)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Weighted Amount"; Rec."Weighted Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Payout"; Rec."Total Payout")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            part(Control2; "Simulation Line")
            {
                Caption = 'Posting Lines';
                Editable = true;
                Visible = Rec."Document Type" = Rec."Document Type"::"Prorate Monthly";
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            part(Control1; "Div. Simulation Lines")
            {
                Caption = 'Progression Lines';
                Editable = True;

                SubPageLink = "Header No." = field("No.");
                ApplicationArea = All;
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
        area(Reporting)
        {
            group("S&imulation")
            {
                Caption = 'S&imulation';
                Image = "Order";
                action(Dividends)
                {
                    Caption = 'Simulate Dividends';
                    Image = Calculate;
                    ShortCutKey = 'F7';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        DividendPeriod: Integer;
                        DividendAccount: Code[20];
                        SimHeader: Record "Dividend Simulation Header";
                        ErrDivPeriod: Label 'Dividend Period cannot be Zero';
                        ErrDivAccount: Label 'A Dividend Account is Expected';
                        MsgComplete: Label 'Simulation Complete Enter the Total Amount available to calculate the Dividend Rate ';
                    begin
                        Rec.TestField("Start Date");
                        Rec.TestField("End Date");
                        Rec.TestField("Operation Type");
                        Rec.TestField("Document Type");

                        if Rec."Document Type" = Rec."Document Type"::"Prorate Daily" then begin
                            SimHeader.SetFilter("No.", Rec."No.");
                            IntOnDeposit.SetTableView(SimHeader);
                            IntOnDeposit.Run();
                        end else begin
                            case Rec."Operation Type" of
                                rec."Operation Type"::"All Products":
                                    begin
                                        SimHeader.Reset();
                                        SimHeader.SetRange("No.", Rec."No.");
                                        if SimHeader.FindFirst() then
                                            DividendProgression.Reset();
                                        DividendProgression.SetRange("Product Type", rec."Product Type");
                                        if DividendProgression.Find('-') then begin
                                            DividendProgression.DeleteAll();
                                        end;
                                        Report.Run(Report::"Gen. Dividend-All Products", true, false, SimHeader);
                                    end;
                                Rec."Operation Type"::"Individual Product":
                                    begin

                                        case Rec."Account Dimension" of
                                            Rec."Account Dimension"::Banking:
                                                begin
                                                    SimHeader.Reset();
                                                    SimHeader.SetRange("No.", Rec."No.");
                                                    if SimHeader.FindFirst() then
                                                        Report.Run(Report::"Gen. A/c Interest Mngt", true, false, SimHeader);
                                                end;

                                            Rec."Account Dimension"::Credit,
                                            Rec."Account Dimension"::"Micro Credit":
                                                begin
                                                    SimHeader.Reset();
                                                    SimHeader.SetRange("No.", Rec."No.");
                                                    if SimHeader.FindFirst() then
                                                        Report.Run(Report::"Gen. Dividend Mngt", true, false, SimHeader);
                                                end;
                                        end;
                                    end;
                            end;
                        end
                    end;
                }

                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ApplicationArea = All;
                }
                action("Calculate Overall Dividends")
                {
                    Caption = 'Member Dividends';
                    Image = Allocate;
                    ApplicationArea = All;
                }
                action("Assembly Orders")
                {
                    Caption = 'Consolidate Lines';
                    Image = AssemblyOrder;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        DivHeader: Record "Dividend Simulation Header";

                    begin
                        DivHeader.Reset();
                        DivHeader.SetRange("No.", Rec."No.");
                        if DivHeader.FindFirst() then begin
                            Report.Run(Report::"Consolidate Div. Line", true, false, DivHeader);
                        end;
                    end;
                }
                action("Clear Posting Lines")
                {
                    Caption = 'Clear Posting Lines';
                    Image = ClearLog;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        DivMngt: Codeunit "Banking Procedure Mngt.";
                        DividendLine: Record "Simulation Line";
                    begin
                        if Confirm('Are you sure want to clear this application?', true) = false then exit;
                        DividendLine.Reset();
                        DividendLine.SetRange("No.", Rec."No.");
                        DividendLine.DeleteAll();

                        DividendProgression.Reset();
                        DividendProgression.SetRange("Product Type", rec."Product Type");
                        if DividendProgression.Find('-') then begin
                            DividendProgression.DeleteAll();
                        end;
                    end;
                }
                action("Mark as Posted")
                {
                    Caption = 'Mark as Posted';
                    Image = ViewPostedOrder;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        DividendSimHeader: Record "Dividend Progression";
                    begin
                        if Confirm('Are you sure want to mark this docuement as Posted?', true) = false then exit;

                        DividendSimHeader.Reset();
                        DividendSimHeader.SetRange("Header No.", Rec."No.");
                        DividendSimHeader.ModifyAll(Posted, true);
                        Commit();

                        DividendLine.Reset();
                        DividendLine.SetRange("No.", Rec."No.");
                        DividendLine.ModifyAll(Posted, true);
                    end;
                }


                action("Unblock Account")
                {

                    Image = ElectronicDoc;
                    //Promoted = true;
                    //PromotedCategory = Category5;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        DividendLine.Reset();
                        DividendLine.SetRange("No.", Rec."No.");
                        if DividendLine.FindSet() then begin
                            repeat
                                case DividendLine."Fosa Account Blocked" of
                                    DividendLine."Fosa Account Blocked"::All,
                                DividendLine."Fosa Account Blocked"::Payment:
                                        begin
                                            if Vendor.Get(DividendLine."Fosa Account No.") then begin
                                                Vendor.Blocked := Vendor.Blocked::" ";
                                                Vendor.Modify(true)
                                            end;
                                        end;
                                end;
                                case DividendLine."Shares Capital Blocked" of
                                    DividendLine."Shares Capital Blocked"::All,
                                    DividendLine."Shares Capital Blocked"::Invoice,
                                    DividendLine."Shares Capital Blocked"::Ship:
                                        begin
                                            if CustRecord.Get(DividendLine."Shares Capital A/c") then begin
                                                CustRecord.Blocked := CustRecord.Blocked::" ";
                                                CustRecord.Modify(true)
                                            end;
                                        end;
                                end;

                                case DividendLine.Blocked of

                                    DividendLine.Blocked::All,
                                    DividendLine.Blocked::Invoice,
                                    DividendLine.Blocked::Ship:
                                        begin
                                            if CustRecord.Get(DividendLine."Account No.") then begin
                                                CustRecord.Blocked := CustRecord.Blocked::" ";
                                                CustRecord.Modify(true)
                                            end;

                                        end;
                                end;

                            until DividendLine.Next() = 0;
                        end;
                    end;
                }
                action("Block Account")
                {
                    Image = ElectronicVATExemption;
                    //Promoted = true;
                    //PromotedCategory = Category5;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        DividendLine.Reset();
                        DividendLine.SetRange("No.", Rec."No.");
                        if DividendLine.FindSet() then begin
                            repeat
                                case DividendLine."Fosa Account Blocked" of
                                    DividendLine."Fosa Account Blocked"::All,
                                DividendLine."Fosa Account Blocked"::Payment:
                                        begin
                                            if Vendor.Get(DividendLine."Fosa Account No.") then begin
                                                Vendor.Blocked := DividendLine."Fosa Account Blocked";
                                                Vendor.Modify(true)
                                            end;
                                        end;
                                end;
                                case DividendLine."Shares Capital Blocked" of
                                    DividendLine."Shares Capital Blocked"::All,
                                    DividendLine."Shares Capital Blocked"::Invoice,
                                    DividendLine."Shares Capital Blocked"::Ship:
                                        begin
                                            if CustRecord.Get(DividendLine."Shares Capital A/c") then begin
                                                CustRecord.Blocked := DividendLine."Shares Capital Blocked";
                                                CustRecord.Modify(true)
                                            end;
                                        end;
                                end;

                                case DividendLine.Blocked of

                                    DividendLine.Blocked::All,
                                    DividendLine.Blocked::Invoice,
                                    DividendLine.Blocked::Ship:
                                        begin
                                            if CustRecord.Get(DividendLine."Account No.") then begin
                                                CustRecord.Blocked := DividendLine.Blocked;
                                                CustRecord.Modify(true)
                                            end;

                                        end;
                                end;

                            until DividendLine.Next() = 0;
                        end;

                    end;
                }
            }

        }
        area(Processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = PostedCreditMemo;
                action("Remove From Job Queue")
                {
                    Caption = 'Post';
                    Image = PostedCreditMemo;
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        DivMngt: Codeunit "Banking Procedure Mngt.";
                    begin

                        Rec.TestField("Posting Date");
                        if Confirm('Are you sure want Post this application?', true) = false then exit;
                        case Rec."Posting Options" of
                            Rec."Posting Options"::"Generate Batch":
                                DivMngt.InitPost(Rec, 0);
                            Rec."Posting Options"::"Post Application":
                                DivMngt.InitPost(Rec, 1);
                            Rec."Posting Options"::" ":
                                Error('No option selected');
                        end;
                    end;
                }
                action("Post Preview")
                {
                    Caption = 'Post Preview';
                    Image = ViewPostedOrder;
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnAction()
                    var
                        DivMngt: Codeunit "Banking Procedure Mngt.";
                        DivHeader: Record "Dividend Simulation Header";
                    begin
                        if Confirm('Are you sure want Post this application?', true) = false then exit;
                        DivMngt.InitPost(Rec, 0);
                    end;
                }
            }
        }
        area(Navigation)
        {
            group(Approval)
            {
                Caption = 'Approval Request';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    //Promoted = true;
                    //PromotedCategory = Category9;
                    //PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        LoanApp: Record Loans;
                        ProdFac: Record "Product Factory";
                        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                        TotGuarant: Decimal;
                    begin

                        //VarVariant := Rec;
                        //PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Send Approval Request");
                        CurrPage.Close();
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    //Promoted = true;
                    //PromotedCategory = Category9;
                    //PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //VarVariant := Rec;
                        // PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Cancel Approval Request");
                        CurrPage.Close();
                    end;
                }
                action(DefferApprovalRequest)
                {
                    Caption = 'Deffer Approval Re&quest';
                    Image = DefaultFault;
                    Visible = false;
                    // Promoted = true;
                    //PromotedCategory = Category9;
                    //PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        //VarVariant := Rec;
                        // ApprovalsMgmt.OnDefferLoanApplicationApprovalRequest(Rec, true, true);
                        CurrPage.Close();
                    end;
                }
                action("Open Document")
                {
                    Image = Category;
                    //Promoted = true;
                    Caption = 'Open Approval Request';
                    //PromotedCategory = Category9;
                    //PromotedIsBig = true;
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        //VarVariant := Rec;
                        //PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Open Request");
                        CurrPage.Close();
                    end;
                }
                action("A&pprovals")
                {
                    Caption = 'A&pproval';
                    Image = Approvals;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin

                        ApprovalEntries.Run;
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Approval Comments";
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;
                }
            }

        }
        area(Promoted)
        {
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
            }
            group(Category_Category9)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin



    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    var
        JobQueueVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        IntOnDeposit: Report "Generate Int. On Deposit";
        SimHeader: Record "Dividend Simulation Header";
        DividendLine: Record "Simulation Line";
        Vendor: Record Vendor;
        CustRecord: Record Customer;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CustMember: Record Member;
        DividendProgression: Record "Dividend Progression";



    procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

}




