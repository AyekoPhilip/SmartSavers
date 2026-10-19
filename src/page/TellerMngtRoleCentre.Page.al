page 50710 "Teller Mngt. Role Centre"
{
    Caption = 'Teller Mngt. Role Centre', Comment = 'Use same translation as ''Profile Description'' (if applicable)';
    PageType = RoleCenter;
    ApplicationArea = All;
    layout
    {
        area(rolecenter)
        {
            part(Control76; "Headline RC Accountant")
            {
                ApplicationArea = All;
                Visible = false;
            }
           
            part(Control16; "O365 Activities")
            {
                AccessByPermission = TableData "Activities Cue" = I;
                ApplicationArea = Basic, Suite;
                Visible = false;

            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
                Visible = false;

            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Cashier Report")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Cashier Report';
                Image = "Report";
                RunObject = Report "Cashier Report-New";
                ToolTip = 'View the quantity not yet shipped for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company''s expected sales volume.';
            }
            action(AccountClosure)
            {
                RunObject = Report "Account Closure Report";
                ApplicationArea = All;
                Caption = 'Account Closure';
            }
            action(EFTPayments)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EFT Payments';
                Image = "Report";
                RunObject = Report "EFT Bank Details";
            }
            action("Daily Cash Report")
            {
                RunObject = Report "Daily Cash (Teller) Report";
                ApplicationArea = All;
                Caption = 'Daily Cash Report';
            }
            action("Receipt  Summary")
            {
                RunObject = Report "Receipts Summary";
                ApplicationArea = All;
                Caption = 'Receipt  Summary';
            }
        }
        area(embedding)
        {
            action("Membership Individual")
            {
                RunObject = Page "Membership Individual List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                ApplicationArea = All;
            }
            action("Membership Group")
            {
                RunObject = Page "Member Group List";
                ApplicationArea = All;
            }
            action("Accounts Banking")
            {
                RunObject = Page "Savings Account List";
                Caption = 'Fosa Accounts';
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                RunObject = Page "Account Credit List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                Caption = 'Bosa Accounts';
                ApplicationArea = All;
            }
            action("Loans Status")
            {
                Caption = 'Loan Status';
                RunObject = Page "Loan Application Status";
                Visible = false;
                ApplicationArea = All;
            }

            action("Active Loans")
            {
                Caption = 'Loans';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(<> 0));
            }
            action("File No.")
            {
                RunObject = page "File Allocation No.";
                Visible = false;
                Caption = 'Allocated File No.';
            }
            action("CRM Application List")
            {
                RunObject = Page "CRM Application List";
                RunPageView = WHERE("Application Type" = CONST(Membership));
                Visible = false;
                ApplicationArea = All;
            }
            action(RequesttoApprove)
            {
                ApplicationArea = All;
                Caption = 'Request to Approve';
                RunObject = Page "Request to Approve";
                ToolTip = 'View Requests to approve.';
            }
            action("Approval Requests")
            {
                ApplicationArea = All;
                RunObject = Page "Approval Requests";
                ToolTip = 'View the approval requests.';
            }
        }
        area(sections)
        {
            group(Action257)
            {
                Caption = 'Teller Transaction';
                action(Action67)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Teller Transaction';
                    Image = CustomerContact;
                    Visible = false;
                    RunObject = Page "Teller Transaction List";
                    ToolTip = 'View or edit detailed information about the contact persons at your business partners that you use to communicate business activities with or that you target marketing activities towards.';
                }
                action(Action66)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Teller Transactions Logs';
                    Visible = false;
                    RunObject = Page "Teller Transactions Logs";
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
            }
            group("Account Transfer")
            {
                Caption = 'Account Transfer';
                Image = FiledPosted;
                ToolTip = 'View the posting history for sales, shipments, and inventory.';
                action(Action32)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Transfer';
                    Image = PostedOrder;
                    RunObject = Page "Account Transfer List";
                    ToolTip = 'Open the list of new/pending approval Account Transfer';
                }

                action(Action33)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Transfer-Approved';
                    Image = PostedOrder;
                    RunObject = Page "Account Transfer-Approved";
                    ToolTip = 'Open the list of approved Account Transfer.';
                }

                action(Action34)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Transfer-Posted';
                    Image = PostedOrder;
                    RunObject = Page "Account Transfer-Posted";
                    ToolTip = 'Open the list of posted Account Transfer';
                }

            }
            group("Electronic Transfer")
            {
                Caption = 'EFT Transfer';
                Image = AdministrationSalesPurchases;
                action(Action663)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'EFT Transfer';
                    RunObject = Page "EFT Receipt List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action(Action664)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'EFT Transfer-Approved';
                    RunObject = Page "EFT Receipt List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action("EFT Transfers Untransferred")
                {
                    RunObject = Page "EFT Receipt List";
                    ApplicationArea = All;
                    Caption = 'Untransferred EFT';
                    RunPageView = where("Approval Status" = filter(Posted));
                }
            }
            group(Receipt)
            {
                action(CustomerReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Receipt';
                    RunObject = Page "Receipts List";
                    ToolTip = 'Executes the Bank Accounts action';
                }
            }
            group("Account Closure")
            {
                action(Action674)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'EFT Transfer';
                    RunObject = Page "EFT Receipt List";
                    RunPageView = where("Approval Status" = filter(Transferred));
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action(WithdrawalNotice)
                {
                    RunObject = Page "Member withdrawal Notice List";
                    Caption = 'Withdrawal Notice';
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action(MembershipClosure)
                {
                    RunObject = Page "Membership Closure List";
                    Caption = 'Membership Closure';
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action(WithdrawalNoticeApproved)
                {
                    RunObject = Page "Member withdrawal Notice List";
                    Caption = 'Withdrawal Notice-Approved';
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action(MembershipClosureApproved)
                {
                    RunObject = Page "Membership Closure List";
                    Caption = 'Account Closure-Approved';
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }

            }
            group("Archive Accounts")
            {
                action(MembershipIndividual)
                {
                    RunObject = Page "Membership Individual List";
                    Caption = 'Member Register';
                    RunPageView = where(Status = filter(Deceased | Withdrawn | Frozen | Closed));
                    ApplicationArea = All;
                }
                action("Archived Account")
                {
                    Caption = 'Fosa Accounts';
                    RunObject = Page "Accounts Banking-Archived";
                    ApplicationArea = All;
                }
                action("Archived Credits")
                {
                    Caption = 'Bosa Accounts';
                    RunObject = Page "Account Credit-Archived";
                    ApplicationArea = All;
                }
                action("Closed Accounts")
                {
                    Caption = 'Closed Accounts';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(0));
                }

            }
            group(Archive)
            {
                Caption = 'Archive Documents';
                action(AccountTransferPosted)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Transfer';
                    Image = PostedOrder;
                    RunObject = Page "Account Transfer List";
                    RunPageView = where(Posted = filter(true));
                }
              
                action("EFT Transfers Posted")
                {
                    RunObject = Page "EFT Receipt List";
                    ApplicationArea = All;
                    Caption = 'Transferred EFT';
                    RunPageView = where("Approval Status" = filter(Transferred));
                }
                action(NoticePosted)
                {
                    RunObject = Page "Member withdrawal Notice List";
                    Caption = 'Withdrawal Notice';
                    RunPageView = where("Approval Status" = filter(Posted), Paid = filter(true));
                    ApplicationArea = All;
                }
                action(ClosurePosted)
                {
                    RunObject = Page "Membership Closure List";
                    Caption = 'Membership Closure';
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action(ClosureTransferred)
                {
                    RunObject = Page "Membership Closure List";
                    Caption = 'Transferred EFT Closure';
                    RunPageView = where("Approval Status" = filter(Transferred));
                    ApplicationArea = All;
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                action("Request to Approve")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Request to Approve';
                    RunObject = Page "Request to Approve";
                    ToolTip = 'Requests for Approvals';
                }
            }
            group("Self Service")
            {
                Caption = 'Self Service';
                action("Change Password")
                {
                    Caption = 'Change My Password';
                    RunObject = report "Change Password";
                    ApplicationArea = All;
                    ToolTip = 'Change Password';
                }
                 action("Payroll Requests ")
                    {
                        Image = Reuse;
                        RunObject = page "Payroll Requests-Self Service";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Payroll Requests action';
                        Caption = 'Payroll Request';
                    }
            }

#if not CLEAN18
#endif
        }
        area(creation)
        {
            action("Teller Transaction")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Teller Transaction';
                Image = NewSalesQuote;
                Visible = false;
                RunObject = Page "Teller Transaction List";
                RunPageMode = Create;
                ToolTip = 'Create a new sales quote to offer items or services to a customer.';
            }
            action("AccountTransfer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Account Transfer';
                Image = NewSalesInvoice;
                RunObject = Page "Account Transfer List";
                RunPageMode = Create;
            }
            action(Receipts)
            {
                ApplicationArea = All;
                Caption = 'Receipt';
                RunObject = Page "Receipts List";
                ToolTip = 'Executes the Receipts action';
            }
            action("EFT(Funds)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EFT Transfer';
                Image = Document;
                RunObject = Page "EFT Receipt List";
                RunPageMode = Create;
                ToolTip = 'Create a new sales order for items or services.';
            }
            action(CreateWithdrawalNotice)
            {
                RunObject = Page "Member withdrawal Notice List";
                Caption = 'Withdrawal Notice';
                RunPageMode = Create;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }
            action(CreateMembershipClosure)
            {
                RunObject = Page "Membership Closure List";
                Caption = 'Membership Closure';
                RunPageMode = Create;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }
        }
        area(processing)
        {


        }
    }
}





