page 51049 "Banking Mngt. Role Center"
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
            action(STO)
            {
                RunObject = Report "Standing Order";
                ApplicationArea = All;
                Caption = 'STO Register';

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
            action(MobileRegSummary)
            {
                RunObject = Report "Mobile Registration";
                ApplicationArea = All;
                Caption = 'Mobile Registration';
            }
            action(MobileRegLoanSummary)
            {
                RunObject = Report "Mobile Loan Status";
                ApplicationArea = All;
                Caption = 'Mobile Loans Summary';
            }
            action(ATMTransactionSummary)
            {
                RunObject = Report "ATM Transactions";
                ApplicationArea = All;
                Caption = 'Alternate Channels';
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
                Caption = 'Operation Account Register';
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
            action("Safe Custody Register")
            {
                RunObject = Report "Safe Custody Register";
                ApplicationArea = All;
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

            action("Membership Individuals")
            {
                Caption = 'Member Regsiter';
                RunObject = Page "Membership Individual List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                ApplicationArea = All;
            }
            action(MembershipIndividual)
            {
                RunObject = Page "Membership Individual List";
                Caption = 'Member Register-Archived';
                RunPageView = where(Status = filter(Deceased | Withdrawn | Frozen | Closed));
                ApplicationArea = All;
            }
            action("Membership Groups")
            {
                Caption = 'Group Register';
                RunObject = Page "Member Group List";
                ApplicationArea = All;
            }
            action("Account Credit")
            {
                Caption = 'Bosa Accounts';
                RunObject = Page "Account Credit List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                ApplicationArea = All;
            }
            action("Account Banking")
            {
                Caption = 'Operation Accounts';
                RunObject = Page "Savings Account List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
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

            action("Active Loans")
            {
                Caption = 'Active Loans';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(<> 0));
            }
            action("Active MLoans")
            {
                Caption = 'Mobile Loans';
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
            action("Placed Lien")
            {
                ApplicationArea = All;
                RunObject = page "Placed Lien";
            }
            action("Teller Tills")
            {
                ApplicationArea = All;
                Caption = 'Teller Till';
                RunObject = page "Teller Tills";
                RunPageView = where("Bank Type" = const(Cash));
            }
            action("Treasury List")
            {
                ApplicationArea = All;
                Caption = 'Treasury';
                RunObject = page "Teller Tills";
                RunPageView = where("Bank Type" = const(Treasury));
            }
            action("Banker Cheque")
            {
                ApplicationArea = All;
                Caption = 'Bankers Cheque';
                RunObject = page "Bankers Cheque Register List";
            }
            action("Request to Approve")
            {
                ApplicationArea = CostAccounting;
                RunObject = Page "Request to Approve";

            }
            action("Approval Requests")
            {
                ApplicationArea = CostAccounting;
                RunObject = Page "Approval Requests";

            }
            action("Approval Comments")
            {
                ApplicationArea = CostAccounting;
                RunObject = Page "Approval Comment Line";
                Caption = 'Approval Comments';

            }

        }
        area(sections)
        {
            group(Application)
            {
                Caption = 'Application';
                Image = Journals;
                action("Teller Transactions")
                {
                    Caption = 'Teller Transactions';
                    RunObject = Page "Teller Transaction List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval" | Approved));
                    ApplicationArea = All;
                }
                action(DefferedTellerTransactions)
                {
                    Caption = 'Deffered Teller Transactions';
                    RunObject = Page "Teller Transaction List";
                    RunPageView = where("Approval Status" = filter(Deffered));
                    ApplicationArea = All;
                }
                action("Treasury Cashier List")
                {
                    Caption = 'Treasury List';
                    RunObject = Page "Treasury Cashier List";
                    RunPageView = where(Status = filter(Open | Pending));
                    ApplicationArea = All;
                }
                action("Account Transfer List")
                {
                    RunObject = Page "Account Transfer List";
                    ApplicationArea = All;
                    RunPageView = where(Status = filter(Open | "Pending Approval"));
                }
                action("Salary Lists")
                {
                    Caption = 'Salary List';
                    RunObject = Page "Salary List";
                    ApplicationArea = All;
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                Visible = true;
                action("Cheque Receipts")
                {
                    RunObject = Page "Cheque Receipts List";
                    ApplicationArea = All;
                }
                action("Cheque Register")
                {
                    RunObject = Page "Cheque Register List";
                    ApplicationArea = All;
                }
                action("Bankers Application")
                {
                    RunObject = Page "Bankers Application List";
                    ApplicationArea = All;
                }
                action("Bankers Cheque Register")
                {
                    RunObject = Page "Bankers Cheque Register List";
                    ApplicationArea = All;
                }
                action("Standing Order")
                {
                    RunObject = Page "Standing Order List";
                    ApplicationArea = All;
                }

                action("Standing Order Register")
                {
                    RunObject = Page "Standing Order Register List";
                    ApplicationArea = All;
                }

                action("EFT Transfer")
                {
                    RunObject = Page "EFT Transfer List";
                    ApplicationArea = All;
                }
                action("Banking Account Transfer")
                {
                    Caption = 'Account Transfer';
                    RunObject = Page "Account Transfer List";
                    ApplicationArea = All;
                }
                action("Safe Custody")
                {
                    Caption = 'Safe Custody';
                    RunObject = Page "Safe Custody List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("SC Collection")
                {
                    Caption = 'Safe Custody-Collection';
                    RunObject = Page "Collateral Collection";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }

            }
            group(ApprovedApplication)
            {
                Caption = 'Approved Application';

                action("Treasury Cashier-Approved")
                {
                    RunObject = Page "Treasury Cashier List";
                    Caption = 'Treasury Transaction';
                    ApplicationArea = All;
                    RunPageView = where(Status = filter(Approved), Posted = const(false));
                }
                action("Account Transfer-Approved")
                {
                    RunObject = Page "Account Transfer List";
                    ApplicationArea = All;
                    Caption = 'Account Transfer';
                    RunPageView = where(Status = filter(Approved));
                }
                action(AccountTransferApproved)
                {
                    RunObject = Page "Account Transfer List";
                    ApplicationArea = All;
                    RunPageView = where(Status = filter(Approved));
                }
                action("Cheque Receipt-Approved")
                {
                    RunObject = Page "Cheque Receipts List";
                    Caption = 'Cheque Receipts';
                    ApplicationArea = All;
                    RunPageView = where(Status = filter(Approved));
                }
                action("Bankers Application-Approved")
                {
                    RunObject = Page "Bankers Application List";
                    ApplicationArea = All;
                    Caption = 'Bankers Cheque';
                    RunPageView = where("Approval Status" = filter(Approved));
                }
                action("Standing Orders-Approved")
                {
                    RunObject = Page "Standing Order List";
                    ApplicationArea = All;
                    Caption = 'Standing Order';
                    RunPageView = where("Approval Status" = filter(Approved));
                }
                action("EFT Transfers-Approved")
                {
                    RunObject = Page "EFT Transfer List";
                    ApplicationArea = All;
                    Caption = 'EFT Transfer';
                    RunPageView = where("Approval Status" = filter(Approved));
                }


                action("Account Transfer Approved")
                {
                    Caption = 'Account Transfer';
                    RunObject = Page "Account Transfer-Approved";
                    ApplicationArea = All;
                }
                action("Standing Order Approved")
                {
                    RunObject = Page "Standing Order-Approved List";
                    Caption = 'Standing Order';
                    ApplicationArea = All;
                }
                action("Approved Application")
                {
                    Caption = 'Mobile Registration';
                    RunObject = Page "Mobile Registration List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Approved));
                }
                action("Safe Custody Approved ")
                {
                    Caption = 'Safe Custody';
                    RunObject = Page "Safe Custody List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("SC Collection-Approved")
                {
                    Caption = 'Safe Custody-Collection';
                    RunObject = Page "Collateral Collection";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action(CardApplicationApproved)
                {
                    Caption = 'ATM Card Linking';
                    RunObject = Page "Automated Card Linking List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Approved));
                }

            }
            group("Alternate Channels")
            {

                Caption = 'Alternate Channels';
                action("Mobile Registration")
                {
                    RunObject = Page "Mobile Registration List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                }

                action(MobAccounts)
                {
                    Caption = 'Accounts';
                    RunObject = Page "Alt. Channel Account";
                    ApplicationArea = All;
                }

                action(ChannelTransactions)
                {
                    Caption = 'Channel Transactions';
                    RunObject = Page "Alt. Channels";
                    ApplicationArea = All;
                }
                action(AlternateCallback)
                {
                    Caption = 'Channel Callback Entries';
                    RunObject = Page "Alt.Channel Callback Entry";
                    ApplicationArea = All;
                }
                action(PostCallBack)
                {
                    Caption = 'Generate Unposted Entries';
                    RunObject = page "Temp. Alt. Channels";
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
            group("Mobile Loans")
            {
                action(ActiveMobileLoans)
                {
                    Caption = 'Active Loans';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0), "Product Type" = filter('MSACCOLN'));
                }
                action(ClosedAccounts)
                {
                    Caption = 'Closed Accounts';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(0), "Product Type" = filter('MSACCOLN'));
                }
                action(QCLoanMngt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mobile Loans';
                    RunObject = page "Dsc Mobile Loans-App";
                    ToolTip = 'Specify Loan Account Posting.';
                }
                action(MobTransactions)
                {
                    Caption = 'Mobile Transactions';
                    RunObject = Page "Dsc Mob. Loan Transaction";
                    ApplicationArea = All;
                }
                action("QC Qualification")
                {
                    Caption = 'QC Qualification';
                    RunObject = Page "QC Qualifying Amount";
                    ApplicationArea = All;
                }
                action("Transaction Types")
                {
                    Caption = 'Transaction Types';
                    RunObject = Page "Transaction Type-Mobile";
                    RunPageView = where(Posted = const(false));
                    ApplicationArea = All;
                }
                action("AccountChangeList")
                {
                    Caption = 'Account Changes';
                    RunObject = Page "Ac Changes List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("DefaulterRecovery")
                {
                    Caption = 'QC Recovery List';
                    RunObject = Page "QC Recovery List";
                    RunPageView = where("Application Source" = filter(Automated));
                    ApplicationArea = All;
                }

                action("Transaction Types Posted")
                {
                    Caption = 'Transaction Types-Posted';
                    RunObject = Page "Transaction Type-Mobile";
                    RunPageView = where(Posted = const(false));
                    ApplicationArea = All;
                }

                action("Interest Due Entries")
                {
                    Caption = 'Interest Entries';
                    RunObject = Page "Interest Due Entry";
                    ApplicationArea = All;
                }
                action("Penalty Due Entries")
                {
                    Caption = 'Penalty Entries';
                    RunObject = Page "Penalty Entres";
                    ApplicationArea = All;
                }
                group("Automated Reports")
                {


                    action("Check Clearance")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Check Clearance';
                        Image = "Report";
                        RunObject = Report "Process Cheque Clearance";
                        ToolTip = 'Cheque Clearance';
                    }
                    action("Safe Custody Renewal")
                    {
                        ApplicationArea = Basic, Suite;
                        Image = "Report";
                        RunObject = Report "Process Safe Custody Renewal";
                        ToolTip = 'Cheque Clearance';
                    }
                    action(GenerateDormantAccount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Generate Dormant Account';
                        Image = "Report";
                        RunObject = Report "Generate Dormant Account";
                        ToolTip = 'Generate Dormant Account';
                    }
                    action(GenerateDormantCredAccount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Generate Dormant Account-Credit';
                        Image = "Report";
                        RunObject = Report "Gen. Dormant Ac- Credit";
                        ToolTip = 'Generate Dormant Account-Credit';
                    }
                    action(PostMobileLoanInterest)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post QC Rollover';
                        Image = "Report";
                        RunObject = Report "Post QC Rollover";
                        ToolTip = 'Generate Loan Interest Due';
                    }
                    action(QCReoveries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post QC Recoveries(Fosa)';
                        Image = "Report";
                        RunObject = Report "Alt. Channel Jnl. Post";
                        ToolTip = 'QC Recoveries';
                    }
                    action(QCPostMobileLoanDefaultRecov)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'QC Generate Defaulters';
                        Image = "Report";
                        RunObject = Report "QC Default Recovery";
                        ToolTip = 'QC Defaulter Recovery';
                    }
                }
            }
            group(Archive)
            {
                action(PostedTellerTransaction)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Teller Transactions';
                    Image = Quote;
                    Visible = true;
                    RunObject = Page "Teller Transactions-Posted";
                    ToolTip = 'Posted Teller Transactions';
                }

                action(EFT)
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'EFT Transfer';
                    RunObject = page "EFt List-Posted";
                }
                action(AccountTransfers)
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Account Transfer';
                    RunObject = page "Account Transfer-Posted";
                }
                action(AccountTransferPosted)
                {
                    RunObject = Page "Account Transfer List";
                    ApplicationArea = All;
                    RunPageView = where(Posted = filter(true));
                }
                action("PostedApplication")
                {
                    Caption = 'Account Application';
                    RunObject = Page "Applications Created";
                    ApplicationArea = All;
                }
                action("AccountChangeListPosted")
                {
                    Caption = 'Account Changes';
                    RunObject = Page "Ac Changes List";
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action(PostedSTO)
                {
                    Caption = 'Stopped STO';
                    RunObject = Page "Standing Order List";
                    ApplicationArea = All;
                    RunPageView = where("Approval status" = const(Stopped));

                }
                action("PostedTreasuryCashierList")
                {
                    Caption = 'Treasury Transaction';
                    RunObject = Page "Treasury Cashier List";
                    RunPageView = where(Posted = const(true));
                    ApplicationArea = All;
                }
                action("Registered Application")
                {
                    Caption = 'Registered Application';
                    RunObject = Page "Mobile Registration List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Posted));
                }
                action(CardApplicationApprovedPosted)
                {
                    Caption = 'Card Link-Posted';
                    RunObject = Page "Automated Card Linking List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Posted));
                }
                action("Safe Custody Posted")
                {
                    Caption = 'Safe Custody';
                    RunObject = Page "Safe Custody List";
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action("SC Collection Posted")
                {
                    Caption = 'Safe Custody-Collection';
                    RunObject = Page "Collateral Collection";
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action(Recovery)
                {
                    ApplicationArea = CostAccounting;
                    RunObject = Page "Recovery List Posted";
                    RunPageView = where("Approval Status" = const(Posted), "Application Source" = const(Automated));
                    ToolTip = 'View Posted Applications';
                }
                action(GuarantorSharesRecovery)
                {
                    RunObject = Page "Loans Recovery Mngt.";
                    ApplicationArea = All;
                    Caption = 'Defaulter Recovery Loans';
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
                group("Procurement Tasks")
                {
                    Caption = 'Tender Evaluation';

                    group("Tenders ")
                    {
                        Caption = 'Tender Management';
                        group("OpeningSelf")
                        {
                            Caption = 'Tender Opening';

                        }
                        group("PreliminarySelf")
                        {
                            Caption = 'Preliminary Evaluation';

                        }
                        group("Technical EvaluationSelf")
                        {

                        }
                        group(FinanicalEvaluation)
                        {

                        }
                        group("PrequalificationOpeningSelf")
                        {

                        }
                    }
                }
            }
        }

        area(creation)
        {
            action("Cashier Transactions")
            {
                RunObject = Page "Teller Transaction List";
                ApplicationArea = All;
                Caption = 'Teller Transaction';
            }
            action("Treasury Cashier")
            {
                RunObject = Page "Treasury Cashier List";
                Caption = 'Treasury Transaction';
                ApplicationArea = All;
                RunPageView = where(Status = filter(Open | Pending));
            }
            action("Account Transfer")
            {
                RunObject = Page "Account Transfer List";
                ApplicationArea = All;
                RunPageView = where(Status = filter(Open | "Pending Approval"));
            }
            action("Cheque Receipt")
            {
                RunObject = Page "Cheque Receipts List";
                ApplicationArea = All;
                RunPageView = where(Status = filter(Open | Pending));
            }
            action("Bankers Application List")
            {
                RunObject = Page "Bankers Application List";
                ApplicationArea = All;
                Caption = 'Bankers Cheque';
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action("Standing Orders")
            {
                RunObject = Page "Standing Order List";
                ApplicationArea = All;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action("EFT Transfers")
            {
                RunObject = Page "EFT Transfer List";
                ApplicationArea = All;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }

        }
    }
    var
        DocMngt: Codeunit "Doc-PostMgt";

}




