page 50792 "Member Group List"
{
    CardPageID = "Member Group";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Member;
    SourceTableView = WHERE("Group Account" = CONST(true));
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
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                }
                field("Date of Business Reg."; Rec."Date of Business Reg.")
                {
                    Caption = 'Date of Business Registration';
                    ApplicationArea = All;
                }
                field("Company Registration No."; Rec."Company Registration No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
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
            action("Member Statistics")
            {
                Image = StatisticsGroup;
                RunObject = Page "Member Statistics";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Group Members")
            {
                Image = Group;
                RunObject = Page "Membership Individual List";
                RunPageLink = "Group Account No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Accounts Banking")
            {
                Image = Capacity;
                RunObject = Page "Savings Account List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                Image = ChangeBatch;
                RunObject = Page "Account Credit List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Repayment Account")
            {
                Image = CashFlowSetup;
                RunObject = Page "Savings Account List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
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
            action("Member File")
            {
                Image = Documents;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DMS: Record EDMS;
                begin
                    // DMS.RESET;
                    // DMS.SETRANGE(DMS.Key, DMS.Key::"Member File");
                    // IF DMS.FIND('-') THEN BEGIN
                    // HYPERLINK(DMS."url path"+"No.");
                    // END;
                end;
            }
            action("E-Mail Statement")
            {
                Caption = 'E-Mail Statement';
                Image = Email;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    // CustMembr := Rec;
                    // CurrPage.SETSELECTIONFILTER(CustMembr);
                    // CustMembr.EmailRecords(TRUE);
                    //
                    // CustMembr.RESET;
                    // CustMembr.SETFILTER("No.","No.");
                    // IF CustMembr.FIND('-') THEN BEGIN
                    // REPORT.RUN(52140719,TRUE,TRUE,CustMembr);
                    // END;
                end;
            }
            action("Make Changes")
            {
                Image = ManualExchangeRate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ErrorOnTxtUnpApplic: Label 'There is still open/pending application %1 that is still in the process.';
                    FieldsRef: Record "Field";
                begin
                    // Rcpt.RESET;
                    //  Rcpt.SETRANGE("Member No.","No.");
                    // Rcpt.SETFILTER("Approval Status",'%1|%2',Rcpt."Approval Status"::Open,Rcpt."Approval Status"::"Pending Approval");
                    //  IF Rcpt.COUNT >=1 THEN
                    //    BEGIN
                    //  ERROR(ErrorOnTxtUnpApplic,Rcpt."No.");
                    //      END;
                    // RegistryMngt.fnCustomerEntries(Rec)

                    FieldsRef.SetRange(TableNo, 52140542);
                    if FieldsRef.Find('-') then begin
                        PAGE.Run(PAGE::"Changes Setup (Field) List",
                         FieldsRef, FieldsRef.TableNo);
                    end
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
            action(Loans)
            {
                Image = SetupColumns;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // //REPORT.RUN(52140587,TRUE,FALSE,CustMembr);
                    // REPORT.RUN(REPORT::"Member Loans Statement",TRUE,FALSE,CustMembr);
                end;
            }
            action("Loans Detailed")
            {
                Image = ServiceOrderSetup;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // REPORT.RUN(REPORT::"Credit Loan Statement",TRUE,FALSE,CustMembr);
                end;
            }
            action(Statement)
            {
                Caption = 'Detailed Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // REPORT.RUN(52140529,TRUE,FALSE,CustMembr);
                end;
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
            }
            group(Category_Report)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(Repayment_Promoted; Repayment)
                {
                }
                actionref(Loans_Promoted; Loans)
                {
                }
                actionref("Loans Detailed_Promoted"; "Loans Detailed")
                {
                }
                actionref(Statement_Promoted; Statement)
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
            }
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Member Statistics_Promoted"; "Member Statistics")
                {
                }
                actionref("Group Members_Promoted"; "Group Members")
                {
                }
                actionref("Accounts Banking_Promoted"; "Accounts Banking")
                {
                }
                actionref("Accounts Credit_Promoted"; "Accounts Credit")
                {
                }
                actionref("Repayment Account_Promoted"; "Repayment Account")
                {
                }
                actionref("Account Signatory_Promoted"; "Account Signatory")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref("Member File_Promoted"; "Member File")
                {
                }
                actionref("E-Mail Statement_Promoted"; "E-Mail Statement")
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
            }
            group(Category_Category9)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }
    }
}




