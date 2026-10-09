page 51019 "Registry Manager Role Center"
{
    Caption = 'Accounting Manager', Comment = '{Dependency=Match,"ProfileDescription_ACCOUNTINGMANAGER"}';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control99; "Finance Performance")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part(Control1902304208; "Registry Manager Activities")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Application Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Application Register';
                Image = "Report";
                RunObject = Report "Member Application Register";
                ToolTip = 'View, print, Membership application details.';
            }
            action("Account Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fosa Register';
                Image = "Report";
                RunObject = Report "Banking Ac Register";
                ToolTip = 'View, Account Details Register.';
            }
            action("Credit Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bosa Register';
                Image = "Report";
                RunObject = Report "Credit Account Register";
                ToolTip = 'View, Account Details Register.';
            }
            action("Membership Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Membership Register';
                Image = "Report";
                RunObject = Report "Member Register";
                ToolTip = 'Member details register.';
            }
            action("Account Balance")
            {
                ApplicationArea = Suite;
                Caption = 'Operation Account List';
                Image = "Report";
                RunObject = Report "Account Balances";
                ToolTip = 'View Account Balances.';
            }
            action(CredAccountBalance)
            {
                ApplicationArea = Suite;
                Caption = 'Bosa Account List';
                Image = "Report";
                RunObject = Report "Account Balance-Credit";
                ToolTip = 'View Account Balances.';
            }
            action("Loans Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loans Register';
                Image = "Report";
                RunObject = Report "Member Loans Register";

            }
            action("Account Closure")
            {
                ApplicationArea = Basic, Suite;
                Image = "Report";
                RunObject = Report "Account Closure Report";

            }
            action("Fixed Deposit Accounts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fixed Deposit';
                Image = "Report";
                RunObject = Report "Fixed Deposit Accounts";
                ToolTip = 'View account balance.';
            }
            action("Next of Kin Details")
            {
                RunObject = Report "Next of Kin Details";
                ApplicationArea = All;
            }
            action("Member Listing")
            {
                RunObject = Report "Member Listing";
                ApplicationArea = All;
            }
            action("Fixed Deposit Account")
            {
                RunObject = Report "Fixed Deposit Accounts";
                ApplicationArea = All;
            }
            action("Fixed Deposit History")
            {
                RunObject = Report "Fixed Deposit History";
                ApplicationArea = All;
            }
            action(STO)
            {
                RunObject = Report "Standing Order";
                ApplicationArea = All;
                Caption = 'STO Register';

            }
            action(STOLines)
            {
                RunObject = Report "Standing Order Line-Detailed";
                ApplicationArea = All;
                Caption = 'Detailed STO Register';

            }
            action("Member Changes")
            {
                RunObject = Report "Account Activation";
                ApplicationArea = All;
                Caption = 'Account Changes';

            }
            action(AccountClosure)
            {
                RunObject = Report "Account Closure Report";
                ApplicationArea = All;
                Caption = 'Account Closure';
            }
            action(AccountDeceased)
            {
                RunObject = Report "Member-Deceased Report";
                ApplicationArea = All;
                Caption = 'Deceased Members';
            }
            action(AccountBalance)
            {
                RunObject = Report "Member Account Balances";
                ApplicationArea = All;
                Caption = 'Member Status';
            }
            action(AccountWithdrawals)
            {
                RunObject = Report "Member Withdrawal Report";
                ApplicationArea = All;
                Caption = 'Withdrawal Report';
            }

        }
        area(embedding)
        {

            action("Membership Individual")
            {
                RunObject = Page "Membership Individual List";
                Caption = 'Member Register';
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
                Caption = 'Operation Account';
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                RunObject = Page "Account Credit List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                Caption = 'Bosa Account';
                ApplicationArea = All;
            }
            action("Loans Status")
            {
                Caption = 'Loan Status';
                RunObject = Page "Loan Application Status";
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
                Caption = 'Allocated File No.';
            }
            action("CRM Application List")
            {
                RunObject = Page "CRM Application List";
                RunPageView = WHERE("Application Type" = CONST(Membership));
                ApplicationArea = All;
            }
            action("Request to Approve")
            {
                ApplicationArea = All;
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
            group(Application)
            {
                Caption = 'Application';
                Image = Journals;
                action("New Applications")
                {
                    Caption = 'Member Applications';
                    RunObject = Page "Individual Application List";
                    ApplicationArea = All;
                }

                action("Member Readmission")
                {
                    Caption = 'Readmission';
                    RunObject = Page "Readmission List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"),
                    "Group Account" = CONST(false),
                    "Customer Type" = CONST(Individual),
                    "Application Type" = const(Readmission));
                }


                action("New Application")
                {
                    Caption = 'Group Application';
                    RunObject = Page "Application Group List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }


            }
            group(Action40)
            {
                Caption = 'Account Application';
                action("New Account Applications")
                {
                    Caption = 'New Application';
                    RunObject = Page "Account Application List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"), "Application Type" = const("Account Application"));

                    ApplicationArea = All;
                }
                action("Account Changes")
                {

                    RunObject = Page "Account Change List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }

            }
            group("Approved Documents")
            {
                action(AccountApplication)
                {
                    RunObject = Page "Account Application List";
                    Caption = 'Account Application';
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Approved));
                }
                action(AccountChanges)
                {
                    Caption = 'Account Changes';
                    RunObject = Page "Account Change List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Approved Application Change")
                {
                    Caption = 'Member Changes';
                    RunObject = Page "Member Change List";
                    ApplicationArea = All;
                    RunPageView = where("approval status" = filter(Approved));
                }
                action("Approved Activation List")
                {
                    Caption = 'Account Activation';
                    RunObject = page "Approved Activation List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }

                action("Approved Applications")
                {
                    Caption = 'Group Application';
                    RunObject = Page "Application Group List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Approved Application")
                {
                    Caption = 'Member Application';
                    RunObject = Page "Individual Applic. Approved";
                    ApplicationArea = All;
                }
                action("ApprovedMemberReadmission")
                {
                    Caption = 'Member Readmission';
                    RunObject = Page "Readmission List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Approved),
                    "Group Account" = CONST(false),
                    "Customer Type" = CONST(Individual),
                    "Application Type" = const(Readmission));
                }

            }

            group(Action121)
            {
                Caption = 'Periodic Activities';
                action("Fields Change Setups")
                {
                    RunObject = Page "Fields Change Setups";
                    ApplicationArea = All;
                    Visible = false;
                }
                action("New Application Change")
                {
                    Caption = 'Member Changes';
                    RunObject = Page "Member Change List";
                    ApplicationArea = All;
                    RunPageView = where("approval status" = filter(Open | "Pending Approval"));
                }

                action("Account Activation")
                {
                    Caption = 'Account Activation';
                    RunObject = page "Account Activation List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("Loan Calculator")
                {
                    RunObject = Page "Loan Calculator List";
                    ApplicationArea = All;
                }
                action("Standing Order Lines")
                {
                    RunObject = Page "Standing Order Line";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Standing Order Register")
                {
                    RunObject = Page "Standing Order Register List";
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            group("Alternate Channels")
            {

                Caption = 'Alternate Channels';
                Visible = false;
                action(MobAccounts)
                {
                    Caption = 'Accounts';
                    RunObject = Page "Alt. Channel Account";
                    ApplicationArea = All;
                }

                action(CardApplication)
                {
                    Caption = 'Card Link';
                    RunObject = Page "Automated Card Linking List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                }
            }

            group(Archive)
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
                    Caption = 'Operation Accounts';
                    RunObject = Page "Savings Account List";
                    RunPageView = where(Status = filter(Deceased | Withdrawn | Frozen | Closed));
                    ApplicationArea = All;
                }
                action("Archived Credits")
                {
                    Caption = 'Bosa Accounts';
                    RunObject = Page "Account Credit List";
                    RunPageView = where(Status = filter(Deceased | Withdrawn | Frozen | Closed));
                    ApplicationArea = All;
                }
                action("Closed Accounts")
                {
                    Caption = 'Closed Loan Account';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(0));
                }
                action("Posted/Rejected Application")
                {
                    Caption = 'Posted Application';
                    RunObject = Page "Applications Created";
                    ApplicationArea = All;
                }
                action("Posted Member Changes")
                {
                    Caption = 'Posted Changes';
                    RunObject = Page "Member Change List";
                    ApplicationArea = All;
                    RunPageView = where("approval status" = filter(Posted | Rejected));
                }
                action("Posted Member Readmission")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Readmission';
                    RunObject = page "Readmission List";
                    RunPageView = where("Approval Status" = filter(Posted | Rejected));
                }
                action("Posted Account Activation")
                {
                    Caption = 'Posted Activation';
                    RunObject = page "Account Activation List";
                    ApplicationArea = All;
                    RunPageView = where("approval status" = filter(Posted | Rejected));
                }
                action(AccountApplicationPosted)
                {
                    Caption = 'Posted Account Application';
                    RunObject = Page "Account Application List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Posted | Rejected));
                }
                action("Posted/Rejected Applications")
                {
                    Caption = 'Posted Group Applications';
                    RunObject = Page "Application Group List";
                    RunPageView = where("Approval Status" = filter(Posted | Rejected));
                    ApplicationArea = All;
                }
                action(PostedSTO)
                {
                    Caption = 'Stopped STO';
                    RunObject = Page "Standing Order List";
                    Visible = false;
                    ApplicationArea = All;
                    RunPageView = where("Approval status" = const(Stopped));
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
                action("Leave Application")
                {
                    Caption = 'Leave Application';
                    ApplicationArea = All;
                    RunObject = page "Hr Leave Application List";

                }



            }
        }
        area(creation)
        {
            action("Individual Application")
            {
                RunObject = Page "Individual Application List";
                ApplicationArea = All;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action("Group Application")
            {
                RunObject = Page "Application Group List";
                ApplicationArea = All;
            }
            action("Account Application")
            {
                RunObject = Page "Account Application List";
                ApplicationArea = All;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action(NewApplicationChange)
            {
                Caption = 'Member Changes';
                RunObject = Page "Member Change List";
                ApplicationArea = All;
                RunPageView = where("approval status" = filter(Open | "Pending Approval"));
            }

            action(MemberReadmission)
            {
                ApplicationArea = All;
                Caption = 'Member Readmission';
                RunObject = page "Readmission List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action(AccountActivation)
            {
                Caption = 'Account Activation';
                RunObject = page "Account Activation List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }

        }
    }
}




