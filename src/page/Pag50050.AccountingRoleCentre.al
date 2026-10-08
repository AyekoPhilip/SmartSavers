page 50050 "Accounting Role Centre"
{
    Caption = 'Accounting Role Centre', Comment = 'Use same translation as ''Profile Description'' (if applicable)';
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
            action("Account Balance")
            {
                ApplicationArea = Suite;
                Caption = 'Account Balance-Fosa';
                Image = "Report";
                RunObject = Report "Account Balances";
                ToolTip = 'View Account Balances.';
            }
            action(CredAccountBalance)
            {
                ApplicationArea = Suite;
                Caption = 'Account Balance-Bosa';
                Image = "Report";
                RunObject = Report "Account Balance-Credit";
                ToolTip = 'View Account Balances.';
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

            action("Loans Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Member Loans Register';
                Image = "Report";
                RunObject = Report "Member Loans Register";

            }
            action("Membership Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Membership Register';
                Image = "Report";


            }
            action("Sectorial Lending")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sectorial Lending';
                Image = "Report";
                RunObject = Report "Sectorial Lending";
            }
            action("Insider Lending")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Insider Lending';
                Image = "Report";
                RunObject = Report "Insider Lending";
            }
            action("Deposits Returns")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deposit Returns';
                Image = "Report";
                RunObject = Report "Deposit Returns";
            }
            action("Defaulter Ageing")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Defaulter Ageing';
                Image = "Report";
                RunObject = Report "Loan Defaulter Aging";
            }
            action("Provision Summary")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Provision Summary';
                Image = "Report";
                RunObject = Report "Loan Provision Summary";
            }

            action(LoansRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loans Register';
                Image = "Report";
                RunObject = Report "Loans Register";
            }
            action(BridgedLoansRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bridged Loans Register';
                Image = "Report";
                RunObject = Report "Bridged Loans";
            }
            action(LoansTopupRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loans Topup Register';
                Image = "Report";
                RunObject = Report "Loans Topup";
            }


            action("Cashier Report")
            {
                RunObject = Report "Cashier Report-New";
                ApplicationArea = All;
                Caption = 'Teller Report';
            }
            action("Cheque Report")
            {
                RunObject = Report "Teller Cheque Report";
                ApplicationArea = All;
                Caption = 'Cheques Report';
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
            action("EFT Transfer Lines")
            {
                RunObject = Report "EFT Transfers Report";
                ApplicationArea = All;
                Caption = 'EFT Transfer';
            }
            action("Internal Account Transfer")
            {
                RunObject = Report "Account Funds Transfer";
                ApplicationArea = All;
                Caption = 'Account Transfer';

            }
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
                Caption = 'Fosa Account Register';
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

            action("Check Report")
            {
                RunObject = Report "Bankers Cheques";
                Caption = 'Bankers/Cheque Deposits';
                ApplicationArea = All;
            }
            action("Teller Transaction Report")
            {
                RunObject = Report "Teller Transactions-Totals";
                Caption = 'Teller Transactions-Totals';
                ApplicationArea = All;
            }
        }
        area(embedding)
        {
            action(RequesttoApprove)
            {
                Caption = 'Request to Approve';
                ApplicationArea = CostAccounting;
                RunObject = Page "Request to Approve";
                ToolTip = 'View the chart of cost types with a structure and functionality that resembles the general ledger chart of accounts. You can transfer the general ledger income statement accounts or create your own chart of cost types.';
            }
            action(ApprovalRequests)
            {
                Caption = 'Approval Request';
                ApplicationArea = CostAccounting;
                RunObject = Page "Approval Requests";
                ToolTip = 'View the chart of cost types with a structure and functionality that resembles the general ledger chart of accounts. You can transfer the general ledger income statement accounts or create your own chart of cost types.';
            }
        }
        area(Creation)
        {
            action(CustomerReceipt)
            {
                ApplicationArea = All;
                Caption = 'Customer Receipting';
                Visible = false;
                RunObject = Page "Receipts List";
                ToolTip = 'Executes the Bank Accounts action';
            }

            action(AgencyReceipts)
            {
                ApplicationArea = All;
                Caption = 'Agency Receipting';
                Visible = false;
                RunObject = Page "Agencies Receipting";
                ToolTip = 'Executes the Bank Accounts action';
            }

            action(RemittanceListPage)
            {
                Caption = 'Remittance';
                RunObject = Page "Remittance List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }
            action(Billing)
            {
                RunObject = Page "Interest Header List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                Caption = 'Loans Billing';
                ApplicationArea = All;
                Visible = true;
            }
        }
        area(sections)
        {

            group("Group")
            {
                Caption = 'Periodic Activities';
                action("Member Advise")
                {
                    Caption = 'Stop Order Sheet';
                    RunObject = Page "Member Advise Analysis";
                    ApplicationArea = All;
                }
                action("StopOrder Advise")
                {
                    Caption = 'Stop Order Advise';
                    RunObject = Page "Stop Order List";
                    ApplicationArea = All;
                }

            }


            group(Accounts)
            {
                Caption = 'Accounts';
                action("Membership Individuals")
                {
                    Caption = 'Member Register';
                    RunObject = Page "Membership Individual List";
                    ApplicationArea = All;
                }
                action("Membership Groups")
                {
                    Caption = 'Group Register';
                    RunObject = Page "Member Group List";
                    ApplicationArea = All;
                }
                action("Account Banking")
                {
                    Caption = 'Banking Accounts';
                    RunObject = Page "Savings Account List";
                    ApplicationArea = All;
                }
                action("Account Credit")
                {
                    Caption = 'Credit Accounts';
                    RunObject = Page "Account Credit List";
                    ApplicationArea = All;
                }
                action(Loans)
                {
                    RunObject = Page "Loan List";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Active Loans")
                {
                    Caption = 'Active Loans';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0));
                }
                action("ApprovedMLoans")
                {
                    Caption = 'Approved Mobile Loans';
                    Visible = false;
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Application Type" = const(Mobile));
                }
                action("Active MLoans")
                {
                    Caption = 'Active Mobile Loans';
                    Visible = false;
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0), "Application Type" = const(Mobile));
                }
                action("Closed Accounts")
                {
                    Caption = 'Closed Accounts';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(0));
                }
            }
            group(ApprovedDocument)
            {
                Caption = 'Approved Documents';
                action(ApprovedRemmittances)
                {
                    Caption = 'Remmittance';
                    RunObject = Page "Posted Remittances";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;

                }
                action(ApprovedBilling)
                {
                    RunObject = Page "Interest Header List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    Caption = 'Loans Billing';
                    ApplicationArea = All;
                    Visible = true;

                }
            }
            group("Requests to Approve")
            {
                Caption = 'Requests to Approve';
                action("Request to Approve")
                {
                    ApplicationArea = CostAccounting;
                    RunObject = Page "Request to Approve";
                    ToolTip = 'View the chart of cost types with a structure and functionality that resembles the general ledger chart of accounts. You can transfer the general ledger income statement accounts or create your own chart of cost types.';
                }
                action("Approval Requests")
                {
                    ApplicationArea = CostAccounting;
                    RunObject = Page "Approval Requests";
                    ToolTip = 'View the chart of cost types with a structure and functionality that resembles the general ledger chart of accounts. You can transfer the general ledger income statement accounts or create your own chart of cost types.';
                }
                action("Posted Approval Entries")
                {
                    ApplicationArea = CostAccounting;
                    RunObject = Page "Posted Approval Entry";
                    ToolTip = 'Posted Approval Requests.';
                }
            }

            group(Archive)
            {

                action("PostedRemmittances")
                {
                    Caption = 'Posted Remmittances';
                    RunObject = Page "Posted Remittances";
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;

                }
                action(PostedBilling)
                {
                    RunObject = Page "Interest Header List";
                    RunPageView = where("Approval Status" = filter(Posted));
                    Caption = 'Loans Billing';
                    ApplicationArea = All;
                    Visible = true;
                }
            }
            group("Self service")
            {
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
                group(Incident)
                {
                    Caption = 'Incidents Management';
                }
                action(CustomerStatement)
                {
                    Caption = 'My Customer Statement';
                    RunObject = report "Customer Statement";
                    ApplicationArea = All;
                    ToolTip = 'Executes the My Customer Statement action';
                    Visible = false;
                }
            }
        }
    }

}



