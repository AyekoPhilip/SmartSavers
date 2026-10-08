page 50133 "Finance Role Center"
{
    PageType = RoleCenter;
    Caption = 'Finance Role Center';
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

            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;

            }
            group(Control1900724808)
            {
                ShowCaption = false;
                Caption = 'Control1900724808';

                part(Control1907662708; "Purchase Agent Activities")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Agent Activities';
                }
                part(Control1902476008; "My Vendors")
                {
                    ApplicationArea = All;
                    Caption = 'My Vendors';
                }
            }
        }




    }

    actions
    {
        area(reporting)
        {
            action("Form 4A")
            {
                ApplicationArea = Suite;
                Caption = 'Form 4A';
                Image = "Report";
                RunObject = Report "Regulatory Form 4A";
                ToolTip = 'View Account Balances.';
            }

            action("Generate Loan Repayment Schedule")
            {
                ApplicationArea = Suite;
                Caption = 'Loan Repayment Schedule';
                Image = "Report";
                RunObject = Report "Generate Loan Repayment Schedu";
                ToolTip = 'Generate Loan Repay Schedule';
            }
             action("Zerolise Excess Loan Repayment")
            {
                ApplicationArea = Suite;
                Caption = 'Zerolise Excess Loan Repayment';
                Image = "Report";
                RunObject = report "Post Excess Interest";
                ToolTip = 'Zerolise Excess Loan Repayment';
            }

            action("Board Expenses Report")
            {
                ApplicationArea = Suite;
                Caption = 'Board Expenses Report';
                Image = "Report";
                RunObject = Report "Board Allowances";
                ToolTip = 'Board Expenses Report';
            }
            action("Bosa Register")
            {
                ApplicationArea = Suite;
                Caption = 'Bosa Register Report';
                Image = "Report";
                RunObject = Report "Credit Account Register";
                ToolTip = 'Credit Account Register';
            }

            action("Operation Register")
            {
                ApplicationArea = Suite;
                Caption = 'Account Register Report';
                Image = "Report";
                RunObject = Report "Banking Ac Register";
                ToolTip = 'Account Register Report';
            }
            action(CredAccountBalance)
            {
                ApplicationArea = Suite;
                Caption = 'Bosa Accounts';
                Image = "Report";
                RunObject = Report "Account Balance-Credit";
                ToolTip = 'View Account Balances.';

            }
            action(Top10BosaBalance)
            {
                ApplicationArea = Suite;
                Caption = 'Top 10 Bosa-Balance';
                Image = "Report";
                Visible = false;
                RunObject = Report "Bosa- Top 10 List";
                ToolTip = 'View Top 10 Bosa-Balance';
            }

            action(Top10FosaBalance)
            {
                ApplicationArea = Suite;
                Caption = 'Top 10 Fosa-Balance';
                Image = "Report";
                Visible = false;
                RunObject = Report "Fosa - Top 10 List";
                ToolTip = 'View Top 10 Fosa-Balance';
            }
            action(UpdateBankLedgerReferencing)
            {
                ApplicationArea = Suite;
                Caption = 'Update Bank Ledger Referencing';
                Image = "Report";
                Visible = false;
                RunObject = Report "Update Bank Ledger Referencin";
                ToolTip = 'Update Bank Ledger Referencing';
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
                Visible = false;
            }
            action("Fixed Deposit History")
            {
                RunObject = Report "Fixed Deposit History";
                ApplicationArea = All;
                Visible = false;
            }
            action(STO)
            {
                RunObject = Report "Standing Order";
                ApplicationArea = All;
                Caption = 'STO Register';
                Visible = false;

            }

            action(AccountClosure)
            {
                RunObject = Report "Account Closure Normal";
                ApplicationArea = All;
                Caption = 'Membership Closure';
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

            action("Loan Repayment Schedule")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Repayment Schedule';
                Image = "Report";
                RunObject = Report "Repayment Schedule-Loans";

            }
            action("Loans Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Performance Register';
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
                Caption = 'Provision Summary';
                Image = "Report";
                RunObject = Report "Loan Provision Summary";
            }
            action(LoansRecovery)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Defaulted Loans';
                Image = "Report";
                RunObject = Report "Defaulted Loans Recovery";
            }

            action(LoansRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loans Register';
                Image = "Report";
                RunObject = Report "Loans Register";
            }
            action(Membershareloanlisting)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Share/Loan Listing';
                Image = "Report";
                RunObject = Report "Member Share Loan Listing";
            }
            action(LoansTopupRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loans Topup';
                Image = "Report";
                RunObject = Report "Loans Topup";
            }


            action(LoanMinutes)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Minutes';
                Image = "Report";
                RunObject = Report "Loan Minutes";
                Visible = false;
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
                Visible = false;
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
                Caption = 'Membership Application';
                Image = "Report";
                RunObject = Report "Member Application Register";
                ToolTip = 'View, print, Membership application details.';
            }
            action("Account Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fosa Accounts';
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
                Visible = false;
                ApplicationArea = All;
            }
            action("Teller Transaction Report")
            {
                RunObject = Report "Teller Transactions-Totals";
                Caption = 'Teller Transactions-Totals';
                ApplicationArea = All;
                Visible = false;
            }
            action(DividendRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dividend Register';
                Image = "Report";
                RunObject = Report "Dividend Register";
            }
            action(DividendProgressionReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dividend Progression';
                Image = "Report";
                RunObject = Report "Dividend Progression";
            }
            action(BoardAllowances)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Board Allowance';
                Image = "Report";
                RunObject = Report "Board Allowances";
            }
            action(CashierReceipt)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Member Receipt';
                Image = "Report";
                RunObject = Report "Cashier Report-Member";
            }
            action(CashierReceipts)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cashier Receipt';
                Image = "Report";
                RunObject = Report "Cashier Receipts";
            }
            action(LoanVariance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Variance';
                Image = "Report";
                RunObject = Report "Loans- Variance";
            }
            action(InsuranceCertificate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Insurance Report';
                Image = "Report";
                RunObject = Report "Insurance Report";
            }
            action(PaymentVoucherListing)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Voucher';
                Image = "Report";
                RunObject = Report "Payment Voucher-Listing";
            }
            action(MobilePayments)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mobile Payments';
                Image = "Report";
                RunObject = Report "Mobile Payments";
            }
            action(ShareCapitalListing)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sasra Share Listing';
                Image = "Report";
                RunObject = Report "Share Capital Listing";
            }
            action(DepositListing)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sasra Deposit Listing';
                Image = "Report";
                RunObject = Report "Deposit Listing";
            }
            action(AccountBankingListing)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sasra Withdrawable Deposits';
                Image = "Report";
                RunObject = Report "Account Banking Listing";
            }
                action(LoansListing)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sasra Loans Listing';
                    Image = "Report";
                    RunObject = Report "Loans Listing";
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

            action("Accounts Banking")
            {
                RunObject = Page "Savings Account List";
                Caption = 'Savings Account';
                //RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                RunObject = Page "Account Credit List";
                //RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                Caption = 'Bosa Account';
                ApplicationArea = All;
            }
            action("Accounts Credit-Deposits")
            {
                RunObject = Page "Account Credit List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"), "Account Category" = filter("Shares Deposit"));
                Caption = 'Deposits Account';
                ApplicationArea = All;
            }
            action("Account Banking-IESA")
            {
                RunObject = Page "Savings Account List";
                Caption = 'Iesa Account';
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"), "Account Category" = filter("Money Market"));
                ApplicationArea = All;
            }
            action("Account Banking- Holiday")
            {
                RunObject = Page "Savings Account List";
                Caption = 'Holiday Account';
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"), "Account Category" = filter("Specialty Savings"));
                ApplicationArea = All;
            }
            action("Loan Account")
            {
                RunObject = Page "Loan Account";
                ApplicationArea = All;
            }
            action("Prepayment Account")
            {
                Caption = 'Account Prepayment';
                RunObject = Page "Repayment Account List";
                ApplicationArea = All;
                Visible = true;
            }
            action(Loans)
            {
                RunObject = Page "Loan List";
                ApplicationArea = All;
            }
            action("Active Loans")
            {
                Caption = 'Active Loans';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(<> 0));
            }
            action("Mobile Loans")
            {
                Caption = 'Mobile Loan Status';
                Visible = false;
                // RunObject = Page "dbc Mobile Loan";
                ApplicationArea = All;

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
            action("Approval Request Entries")
            {
                RunObject = page "Approval Request Entries";
                ApplicationArea = All;
                ToolTip = 'Executes the Approval Request Entries action';
            }
            action("Approval Entries")
            {
                ApplicationArea = All;
                Caption = 'Approval Entries';
                ToolTip = 'Executes the Approval Entries action';
            }
        }
        area(Creation)
        {

            action(PettyCash)
            {
                ApplicationArea = All;
                Caption = 'Petty Cash';
                RunObject = page "Petty Cash List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ToolTip = 'Executes the Fixed Assets action';
            }
            action(PaymentVoucher)
            {
                ApplicationArea = All;
                Caption = 'Payment Voucher';
                RunObject = page "Payment Voucher List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ToolTip = 'Executes the Customers action';
            }
            action("Board Allowances Expenses")
            {
                RunObject = Page "Board Allowances";
                RunPageView = where(Paid = filter(false));
                ApplicationArea = All;
            }
            action(Imprest)
            {
                ApplicationArea = All;
                Caption = 'Impresst';
                RunObject = page "Imprest List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ToolTip = 'Executes the Bank Accounts action';
            }
            action(ImprestSurrender)
            {
                ApplicationArea = All;
                Caption = 'Imprest Surrender';
                RunObject = page "Imprest List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ToolTip = 'Executes the Bank Accounts action';
            }
            action(RemittanceListPage)
            {
                Caption = 'Remittance';
                Visible = false;
                RunObject = Page "Remittance List";
                ApplicationArea = All;
            }
            action(Billing)
            {
                RunObject = Page "Interest Header List";
                RunPageView = where("Application Type" = const("Loan Interest"), "Approval Status" = filter(Open | "Pending Approval"));
                Caption = 'Billing';
                ApplicationArea = All;
                Visible = false;
            }
            action(InterestPosting)
            {
                RunObject = page "Account Interest List";
                Caption = 'Account Interest';
                ApplicationArea = All;
                Visible = false;
            }
            action(BBFRecovery)
            {
                RunObject = Page "BBF List";
                RunPageView = where("Application Type" = const("Benevolent Recovery"));
                Caption = 'BBF Recovery';
                ApplicationArea = All;
                Visible = false;
            }
            action("Standing Order")
            {
                RunObject = Page "Standing Order List";
                Visible = false;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }


        }
        area(Processing)
        {
            action(ApprovedWithdrawalNotice)
            {
                RunObject = Page "Member withdrawal Notice List";
                Caption = 'Withdrawal Notice';
                RunPageView = where("Approval Status" = filter(Approved));
                ApplicationArea = All;
            }
            action(ApprovedMembershipClosure)
            {
                RunObject = Page "Membership Closure List";
                Caption = 'Account Closure';
                RunPageView = where("Approval Status" = filter(Approved));
                ApplicationArea = All;
            }

            action("Standing Orders-Approved")
            {
                RunObject = Page "Standing Order List";
                ApplicationArea = All;
                Caption = 'Standing Order';
                Visible = false;
                RunPageView = where("Approval Status" = filter(Approved));
            }
            action(LoansList)
            {
                RunObject = Page "Loan List";
                Caption = 'Loan';
                Visible = false;
                ApplicationArea = All;
            }
            action(ActiveLoans)
            {
                Caption = 'Active Loans';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(<> 0));
            }
            action(MobileLoans)
            {
                Caption = 'Mobile Loans';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Product Type" = filter('MSACCOLN'), "Outstanding Balance" = filter(<> 0));
            }
            action(ClosedAccounts)
            {
                Caption = 'Closed Accounts';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(0));
            }
            action(LoanPerformances)
            {
                Caption = 'Loan Performance';
                RunObject = Page "Loan-Performance Indicator";
                ApplicationArea = All;
            }
            action(MemberAll)
            {
                Caption = 'Member Accounts';
                RunObject = Page "Member Account (All)";
                ApplicationArea = All;
            }
        }
        area(sections)
        {
            group("Group")
            {
                Caption = 'General Ledger';

                action("Chart of Accounts12")
                {
                    ApplicationArea = All;
                    Caption = 'Chart of Accounts';
                    RunObject = page "Chart of Accounts";
                    ToolTip = 'Executes the Chart of Accounts action';
                }
                action("Budgets")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Budgets';
                    RunObject = page "G/L Budget Names";
                    ToolTip = 'Executes the G/L Budgets action';
                }
                action("Account Schedules")
                {
                    ApplicationArea = All;
                    Caption = 'Account Schedules';
                    RunObject = page "Account Schedule Names";
                    ToolTip = 'Executes the Account Schedules action';
                }
                action("FinancialReporting")
                {
                    ApplicationArea = All;
                    Caption = 'Financial Reporting';
                    RunObject = page "Financial Reports";
                    ToolTip = 'Executes the Account Schedules action';
                }
                action("Analyses by Dimensions")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Analysis by Dimensions';
                    RunObject = page "Analysis View List";
                    ToolTip = 'Executes the Analysis by Dimensions action';
                }
                group("Group1")
                {
                    Caption = 'VAT';

                    action("VAT Statements")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Statements';
                        RunObject = page "VAT Statement";
                        ToolTip = 'Executes the VAT Statements action';
                        Visible = false;
                    }
                    action("VAT Returns")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Returns';
                        RunObject = page "VAT Report List";
                        ToolTip = 'Executes the VAT Returns action';
                        Visible = false;
                    }
                    group("Group2")
                    {
                        Caption = 'Reports';

                        action("VAT Exceptions")
                        {
                            ApplicationArea = All;
                            Caption = 'VAT Exceptions';
                            RunObject = report "VAT Exceptions";
                            ToolTip = 'Executes the VAT Exceptions action';
                            Visible = false;
                        }
                        action("VAT Register")
                        {
                            ApplicationArea = All;
                            Caption = 'VAT Register';
                            RunObject = report "VAT Register";
                            ToolTip = 'Executes the VAT Register action';
                            Visible = false;
                        }
                        action("VAT Registration No. Check")
                        {
                            ApplicationArea = All;
                            Caption = 'Batch VAT Registration No. Check';
                            RunObject = report "VAT Registration No. Check";
                            ToolTip = 'Executes the Batch VAT Registration No. Check action';
                            Visible = false;
                        }
                        action("VAT Statement")
                        {
                            ApplicationArea = All;
                            Caption = 'VAT Statement';
                            RunObject = report "VAT Statement";
                            ToolTip = 'Executes the VAT Statement action';
                        }
                        action("VAT- VIES Declaration Tax Auth")
                        {
                            ApplicationArea = All;
                            Caption = 'VAT- VIES Declaration Tax Auth';
                            RunObject = report "VAT- VIES Declaration Tax Auth";
                            ToolTip = 'Executes the VAT- VIES Declaration Tax Auth action';
                            Visible = false;
                        }
                        action("VAT- VIES Declaration Disk")
                        {
                            ApplicationArea = All;
                            Caption = 'VAT- VIES Declaration Disk...';
                            RunObject = report "VAT- VIES Declaration Disk";
                            ToolTip = 'Executes the VAT- VIES Declaration Disk... action';
                            Visible = false;
                        }
                        action("Day Book VAT Entry")
                        {
                            ApplicationArea = All;
                            Caption = 'Day Book VAT Entry';
                            RunObject = report "Day Book VAT Entry";
                            ToolTip = 'Executes the Day Book VAT Entry action';
                            Visible = false;
                        }
                        action("Day Book Cust. Ledger Entry")
                        {
                            ApplicationArea = All;
                            Caption = 'Day Book Cust. Ledger Entry';
                            RunObject = report "Day Book Cust. Ledger Entry";
                            ToolTip = 'Executes the Day Book Cust. Ledger Entry action';
                            Visible = false;
                        }
                        action("Day Book Vendor Ledger Entry")
                        {
                            ApplicationArea = All;
                            Caption = 'Day Book Vendor Ledger Entry';
                            RunObject = report "Day Book Vendor Ledger Entry";
                            ToolTip = 'Executes the Day Book Vendor Ledger Entry action';
                            Visible = false;
                        }

                    }
                }
                group("Group3")
                {
                    Caption = 'Intercompany';

                    action("General Journals")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Intercompany General Journal';
                        RunObject = page "IC General Journal";
                        ToolTip = 'Executes the Intercompany General Journal action';
                        Visible = false;
                    }
                    action("Inbox Transactions")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Intercompany Inbox Transactions';
                        RunObject = page "IC Inbox Transactions";
                        ToolTip = 'Executes the Intercompany Inbox Transactions action';
                        Visible = false;
                    }
                    action("Outbox Transactions")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Intercompany Outbox Transactions';
                        RunObject = page "IC Outbox Transactions";
                        ToolTip = 'Executes the Intercompany Outbox Transactions action';
                        Visible = false;
                    }
                    action("Handled Inbox Transactions")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Handled Intercompany Inbox Transactions';
                        RunObject = page "Handled IC Inbox Transactions";
                        ToolTip = 'Executes the Handled Intercompany Inbox Transactions action';
                        Visible = false;
                    }
                    action("Handled Outbox Transactions")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Handled Intercompany Outbox Transactions';
                        RunObject = page "Handled IC Outbox Transactions";
                        ToolTip = 'Executes the Handled Intercompany Outbox Transactions action';
                        Visible = false;
                    }
                    action("Intercompany Transactions")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'IC Transaction';
                        RunObject = report "IC Transactions";
                        ToolTip = 'Executes the IC Transaction action';
                        Visible = false;
                    }
                }
                group("Group4")
                {
                    Caption = 'Consolidation';

                    action("Business Units")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Business Units';
                        RunObject = page "Business Unit List";
                        ToolTip = 'Executes the Business Units action';
                        Visible = false;
                    }
                    action("Export Consolidation")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Export Consolidation...';
                        RunObject = report "Export Consolidation";
                        ToolTip = 'Executes the Export Consolidation... action';
                        Visible = false;
                    }
                    action("G/L Consolidation Eliminations")
                    {
                        ApplicationArea = Suite;
                        Caption = 'G/L Consolidation Eliminations';
                        RunObject = report "G/L Consolidation Eliminations";
                        ToolTip = 'Executes the G/L Consolidation Eliminations action';
                        Visible = false;
                    }
                }
                group("Group5")
                {
                    Caption = 'Journals';

                    action("General Journals1")
                    {
                        ApplicationArea = All;
                        Caption = 'General Journals';
                        RunObject = page "General Journal";
                        ToolTip = 'Executes the General Journals action';
                    }
                    action("Recurring Journals")
                    {
                        ApplicationArea = Suite, FixedAssets;
                        Caption = 'Recurring General Journals';
                        RunObject = page "Recurring General Journal";
                        ToolTip = 'Executes the Recurring General Journals action';
                    }
                    action("Imports Journals")
                    {
                        ApplicationArea = Suite, FixedAssets;
                        Caption = 'Import Loans Journal';
                        RunObject = Page "Config.Package";
                        RunPageView = where(Code = filter('LOANJOURN'));
                        ToolTip = 'Executes Importing Loan General Journals action';
                    }

                    action("General Journals2")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Intercompany General Journal';
                        RunObject = page "IC General Journal";
                        Visible = false;
                        ToolTip = 'Executes the Intercompany General Journal action';
                    }
                    action("GL Register/User Reviews")
                    {
                        ApplicationArea = All;
                        Caption = 'GL Register/User Reviews';
                        RunObject = report "GL History vs Approvals";
                        ToolTip = 'Executes the GL Register/User Reviews action';
                    }
                }
                group("Group6")
                {
                    Caption = 'Register/Entries';

                    action("G/L Registers12")
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Registers';
                        RunObject = page "G/L Registers";
                        ToolTip = 'Executes the G/L Registers action';
                    }
                    action("Navigate")
                    {
                        ApplicationArea = Basic, Suite, FixedAssets, CostAccounting;
                        Caption = 'Navigate';
                        RunObject = page "Navigate";
                        ToolTip = 'Executes the Navigate action';
                    }
                    action("General Ledger Entries12")
                    {
                        ApplicationArea = All;
                        Caption = 'General Ledger Entries';
                        RunObject = page "General Ledger Entries";
                        ToolTip = 'Executes the General Ledger Entries action';
                    }
                    action("G/L Budget Entries12")
                    {
                        ApplicationArea = Suite;
                        Caption = 'G/L Budget Entries';
                        RunObject = page "G/L Budget Entries";
                        ToolTip = 'Executes the G/L Budget Entries action';
                    }
                    action("VAT Entries12")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Entries';
                        RunObject = page "VAT Entries";
                        ToolTip = 'Executes the VAT Entries action';
                        Visible = false;
                    }
                    action("Analysis View Entries12")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Analysis View Entries';
                        RunObject = page "Analysis View Entries";
                        ToolTip = 'Executes the Analysis View Entries action';
                    }
                    action("Analysis View Budget Entries12")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Analysis View Budget Entries';
                        RunObject = page "Analysis View Budget Entries";
                        ToolTip = 'Executes the Analysis View Budget Entries action';
                    }
                    action("Item Budget Entries12")
                    {
                        ApplicationArea = ItemBudget;
                        Caption = 'Item Budget Entries';
                        RunObject = page "Item Budget Entries";
                        ToolTip = 'Executes the Item Budget Entries action';
                    }

                    action("User Reviews")
                    {
                        ApplicationArea = All;
                        Caption = 'GL Register/User Reviews';
                        RunObject = report "GL History vs Approvals";
                        ToolTip = 'Executes the GL Register/User Reviews action';
                    }
                }
                group("Group7")
                {
                    Caption = 'Reports';

                    group("Group8")
                    {
                        Caption = 'Entries';

                        action("G/L Register")
                        {
                            ApplicationArea = All;
                            Caption = 'G/L Register';
                            RunObject = report "G/L Register";
                            ToolTip = 'Executes the G/L Register action';
                        }
                        action("Detail Trial Balance")
                        {
                            ApplicationArea = All;
                            Caption = 'Detail Trial Balance';
                            RunObject = report "Detail Trial Balance";
                            ToolTip = 'Executes the Detail Trial Balance action';
                        }
                        action("Dimensions - Detail")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Dimensions - Detail';
                            RunObject = report "Dimensions - Detail";
                            ToolTip = 'Executes the Dimensions - Detail action';
                        }
                        action("Dimensions - Total")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Dimensions - Total';
                            RunObject = report "Dimensions - Total";
                            ToolTip = 'Executes the Dimensions - Total action';
                        }
                        action("Check Value Posting")
                        {
                            ApplicationArea = All;
                            Caption = 'Dimension Check Value Posting';
                            RunObject = report "Check Value Posting";
                            ToolTip = 'Executes the Dimension Check Value Posting action';
                        }
                    }
                    group("Group9")
                    {
                        Caption = 'Financial Statement';

                        action("Account Schedule")
                        {
                            ApplicationArea = All;
                            Caption = 'Account Schedule';
                            RunObject = report "Account Schedule";
                            ToolTip = 'Executes the Account Schedule action';
                        }
                        action("Trial Balance")
                        {
                            ApplicationArea = All;
                            Caption = 'Trial Balance';
                            RunObject = report "Trial Balance";
                            ToolTip = 'Executes the Trial Balance action';
                        }
                        action("Trial Balance/Budget")
                        {
                            ApplicationArea = All;
                            Caption = 'Trial Balance/Budget';
                            RunObject = report "Trial Balance/Budget";
                            ToolTip = 'Executes the Trial Balance/Budget action';
                        }
                        action("Trial Balance/Previous Year")
                        {
                            ApplicationArea = All;
                            Caption = 'Trial Balance/Previous Year';
                            RunObject = report "Trial Balance/Previous Year";
                            ToolTip = 'Executes the Trial Balance/Previous Year action';
                        }
                        action("Closing Trial Balance")
                        {
                            ApplicationArea = All;
                            Caption = 'Closing Trial Balance';
                            RunObject = report "Closing Trial Balance";
                            ToolTip = 'Executes the Closing Trial Balance action';
                        }
                        action("Consolidated Trial Balance")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Consolidated Trial Balance';
                            RunObject = report "Consolidated Trial Balance";
                            ToolTip = 'Executes the Consolidated Trial Balance action';
                        }
                        action("Consolidated Trial Balance (4)")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Consolidated Trial Balance (4)';
                            RunObject = report "Consolidated Trial Balance (4)";
                            ToolTip = 'Executes the Consolidated Trial Balance (4) action';
                        }
                        action("Budget")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Budget';
                            RunObject = report "Budget";
                            ToolTip = 'Executes the Budget action';
                        }
                        action("Trial Balance by Period")
                        {
                            ApplicationArea = All;
                            Caption = 'Trial Balance by Period';
                            RunObject = report "Trial Balance by Period";
                            ToolTip = 'Executes the Trial Balance by Period action';
                        }
                        action("Fiscal Year Balance")
                        {
                            ApplicationArea = All;
                            Caption = 'Fiscal Year Balance';
                            RunObject = report "Fiscal Year Balance";
                            ToolTip = 'Executes the Fiscal Year Balance action';
                        }
                        action("Balance Comp. - Prev. Year")
                        {
                            ApplicationArea = All;
                            Caption = 'Balance Comp. - Prev. Year';
                            RunObject = report "Balance Comp. - Prev. Year";
                            ToolTip = 'Executes the Balance Comp. - Prev. Year action';
                        }
                        action("Balance Sheet")
                        {
                            ApplicationArea = All;
                            Caption = 'Balance Sheet';
                            RunObject = codeunit "Run Acc. Sched. Balance Sheet";
                            AccessByPermission = tabledata "G/L Account" = R;
                            ToolTip = 'Executes the Balance Sheet action';
                        }
                        action("Income Statement")
                        {
                            ApplicationArea = All;
                            Caption = 'Income Statement';
                            RunObject = codeunit "Run Acc. Sched. Income Stmt.";
                            AccessByPermission = tabledata "G/L Account" = R;
                            ToolTip = 'Executes the Income Statement action';
                        }
                        action("Statement of Cashflows")
                        {
                            ApplicationArea = All;
                            Caption = 'Cash Flow Statement';
                            RunObject = codeunit "Run Acc. Sched. CashFlow Stmt.";
                            AccessByPermission = tabledata "G/L Account" = R;
                            ToolTip = 'Executes the Cash Flow Statement action';
                        }
                        action("Statement of Retained Earnings")
                        {
                            ApplicationArea = All;
                            Caption = 'Retained Earnings Statement';
                            RunObject = codeunit "Run Acc. Sched. Retained Earn.";
                            AccessByPermission = tabledata "G/L Account" = R;
                            ToolTip = 'Executes the Retained Earnings Statement action';
                        }
                    }
                    group("Group10")
                    {
                        Caption = 'Miscellaneous';

                        action("Foreign Currency Balance")
                        {
                            ApplicationArea = All;
                            Caption = 'Foreign Currency Balance';
                            RunObject = report "Foreign Currency Balance";
                            ToolTip = 'Executes the Foreign Currency Balance action';
                        }


                        action("Reconcile Cust. and Vend. Accs")
                        {
                            ApplicationArea = All;
                            Caption = 'Reconcile Cust. and Vend. Accs';
                            RunObject = report "Reconcile Cust. and Vend. Accs";
                            ToolTip = 'Executes the Reconcile Cust. and Vend. Accs action';
                        }
                        action("G/L Deferral Summary")
                        {
                            ApplicationArea = All;
                            Caption = 'G/L Deferral Summary';
                            RunObject = report "Deferral Summary - G/L";
                            ToolTip = 'Executes the G/L Deferral Summary action';
                            Visible = false;
                        }
                    }
                    group("Group11")
                    {
                        Caption = 'Setup List';

                        action("Chart of Accounts1")
                        {
                            ApplicationArea = All;
                            Caption = 'Chart of Accounts';
                            RunObject = report "Chart of Accounts";
                            ToolTip = 'Executes the Chart of Accounts action';
                        }
                        action("Change Log Setup List")
                        {
                            ApplicationArea = All;
                            Caption = 'Change Log Setup List';
                            RunObject = report "Change Log Setup List";
                            ToolTip = 'Executes the Change Log Setup List action';
                        }
                    }
                }
                group("Group12")
                {
                    Caption = 'Setups';

                    action("General Ledger Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'General Ledger Setup';
                        RunObject = page "General Ledger Setup";
                        ToolTip = 'Executes the General Ledger Setup action';
                    }
                    action("Deferral Template List")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Deferral Templates';
                        RunObject = page "Deferral Template List";
                        ToolTip = 'Executes the Deferral Templates action';
                        Visible = false;
                    }
                    action("Journal Templates")
                    {
                        ApplicationArea = All;
                        Caption = 'General Journal Templates';
                        RunObject = page "General Journal Templates";
                        ToolTip = 'Executes the General Journal Templates action';
                    }
                    action("G/L Account Categories")
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Account Categories';
                        RunObject = page "G/L Account Categories";
                        AccessByPermission = tabledata "G/L Account Category" = R;
                        ToolTip = 'Executes the G/L Account Categories action';
                    }

                    action("VAT Report Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Report Setup';
                        RunObject = page "VAT Report Setup";
                        ToolTip = 'Executes the VAT Report Setup action';
                    }
                }
            }
            group("Group13")
            {
                Caption = 'Cash Management';

                action("Bank Accounts12")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Accounts';
                    RunObject = page "Bank Account List";
                    ToolTip = 'Executes the Bank Accounts action';
                }


                action("Run Object CU")
                {
                    ApplicationArea = All;
                    Caption = 'Run Object CU';
                    RunObject = codeunit "Alt. Channel (Mobile Mngt.)";
                    ToolTip = 'Executes the Bank Accounts action';
                    Visible = false;
                }
                action("Receivables-Payables")
                {
                    ApplicationArea = Suite;
                    Caption = 'Receivables-Payables';
                    RunObject = page "Receivables-Payables";
                    ToolTip = 'Executes the Receivables-Payables action';
                }
                action("Payment Registration")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Registration';
                    RunObject = page "Payment Registration";
                    ToolTip = 'Executes the Payment Registration action';
                    Visible = false;

                }
                group("Group14")
                {
                    Caption = 'Cash Flow';

                    action("Cash Flow Forecasts")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Forecasts';
                        RunObject = page "Cash Flow Forecast List";
                        ToolTip = 'Executes the Cash Flow Forecasts action';
                    }
                    action("Chart of Cash Flow Accounts")
                    {
                        ApplicationArea = All;
                        Caption = 'Chart of Cash Flow Accounts';
                        RunObject = page "Chart of Cash Flow Accounts";
                        ToolTip = 'Executes the Chart of Cash Flow Accounts action';
                    }
                    action("Cash Flow Manual Revenues")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Manual Revenues';
                        RunObject = page "Cash Flow Manual Revenues";
                        ToolTip = 'Executes the Cash Flow Manual Revenues action';
                    }
                    action("Cash Flow Ledger Entries")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Manual Expenses';
                        RunObject = page "Cash Flow Manual Expenses";
                        ToolTip = 'Executes the Cash Flow Manual Expenses action';
                    }
                    action("Cash Flow Worksheet")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Worksheet';
                        RunObject = page "Cash Flow Worksheet";
                        ToolTip = 'Executes the Cash Flow Worksheet action';
                    }
                }
                group("Group15")
                {
                    Caption = 'Reconciliation';

                    action("Bank Account Reconciliations")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account Reconciliations';
                        RunObject = page "Bank Acc. Reconc List";
                        ToolTip = 'Executes the Bank Account Reconciliations action';
                    }
                    action("Posted Payment Reconciliations12")
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Payment Reconciliations';
                        RunObject = page "Posted Payment Reconciliations";
                        ToolTip = 'Executes the Posted Payment Reconciliations action';
                        Visible = false;
                    }
                    action("Payment Reconciliation Journals12")
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Reconciliation Journals';
                        RunObject = page "Pmt. Reconciliation Journals";
                        ToolTip = 'Executes the Payment Reconciliation Journals action';
                        Visible = false;
                    }
                }

                group("Group17")
                {
                    Caption = 'Ledger Entries';

                    action("Bank Account Ledger Entries12")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account Ledger Entries';
                        RunObject = page "Bank Account Ledger Entries";
                        ToolTip = 'Executes the Bank Account Ledger Entries action';
                    }
                    action("Check Ledger Entries12")
                    {
                        ApplicationArea = All;
                        Caption = 'Check Ledger Entries';
                        RunObject = page "Check Ledger Entries";
                        ToolTip = 'Executes the Check Ledger Entries action';
                        Visible = false;
                    }
                    action("Cash Flow Ledger Entries1")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Ledger Entries';
                        RunObject = page "Cash Flow Forecast Entries";
                        ToolTip = 'Executes the Cash Flow Ledger Entries action';
                        Visible = false;
                    }
                }
                group("Group18")
                {
                    Caption = 'Reports';

                    action("Register")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account Register';
                        RunObject = report "Bank Account Register";
                        ToolTip = 'Executes the Bank Account Register action';
                    }
                    action("Check Details")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account - Check Details';
                        RunObject = report "Bank Account - Check Details";
                        ToolTip = 'Executes the Bank Account - Check Details action';
                        Visible = false;
                    }
                    action("Labels")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account - Labels';
                        RunObject = report "Bank Account - Labels";
                        ToolTip = 'Executes the Bank Account - Labels action';
                    }
                    action("List")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account - List';
                        RunObject = report "Bank Account - List";
                        ToolTip = 'Executes the Bank Account - List action';
                    }
                    action("Detail Trial Bal.")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Acc. - Detail Trial Bal.';
                        RunObject = report "Bank Acc. - Detail Trial Bal.";
                        ToolTip = 'Executes the Bank Acc. - Detail Trial Bal. action';
                    }
                    action("Receivables-Payables1")
                    {
                        ApplicationArea = All;
                        Caption = 'Receivables-Payables';
                        RunObject = report "Receivables-Payables";
                        ToolTip = 'Executes the Receivables-Payables action';
                    }
                    action("Cash Flow Date List")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Date List';
                        RunObject = report "Cash Flow Date List";
                        ToolTip = 'Executes the Cash Flow Date List action';
                        Visible = false;
                    }
                    action("Dimensions - Detail1")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Cash Flow Dimensions - Detail';
                        RunObject = report "Cash Flow Dimensions - Detail";
                        ToolTip = 'Executes the Cash Flow Dimensions - Detail action';
                    }

                }
                group("Group19")
                {
                    Caption = 'Setup';

                    action("Payment Application Rules")
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Application Rules';
                        RunObject = page "Payment Application Rules";
                        ToolTip = 'Executes the Payment Application Rules action';
                    }
                    action("Cash Flow Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Setup';
                        RunObject = page "Cash Flow Setup";
                        ToolTip = 'Executes the Cash Flow Setup action';
                    }
                    action("Report Selection - Cash Flow")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Flow Report Selections';
                        RunObject = page "Report Selection - Cash Flow";
                        ToolTip = 'Executes the Cash Flow Report Selections action';
                        //Visible=false;
                    }
                    action("Report Selection - Bank Acc.")
                    {
                        ApplicationArea = All;
                        Caption = 'Report Selections Bank Account';
                        RunObject = page "Report Selection - Bank Acc.";
                        ToolTip = 'Executes the Report Selections Bank Account action';
                    }
                    action("Payment Terms")
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Terms';
                        RunObject = page "Payment Terms";
                        ToolTip = 'Executes the Payment Terms action';
                    }
                    action("Payment Methods")
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Methods';
                        RunObject = page "Payment Methods";
                        ToolTip = 'Executes the Payment Methods action';
                    }
                    action("Currencies")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Currencies';
                        RunObject = page "Currencies";
                        ToolTip = 'Executes the Currencies action';
                    }
                }
            }
            group("Funds Management")

            {
                group("Pending Document")
                {
                    action(FundReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Receipt';
                        RunObject = Page "Receipts List";
                        RunPageView = where(Posted = filter(false));
                        ToolTip = 'Executes the Bank Accounts action';
                    }

                    action(FundPettyCash)
                    {
                        ApplicationArea = All;
                        Caption = 'Petty Cash';
                        RunObject = page "Petty Cash List";
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ToolTip = 'Executes the Fixed Assets action';
                    }
                    action(FundPaymentVoucher)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Voucher';
                        RunObject = page "Payment Voucher List";
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ToolTip = 'Executes the Customers action';
                    }
                    action(FundImprest)
                    {
                        ApplicationArea = All;
                        Caption = 'Impresst';
                        RunObject = page "Imprest List";
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ToolTip = 'Executes the Bank Accounts action';
                    }
                    action(FundImprestSurrender)
                    {
                        ApplicationArea = All;
                        Caption = 'Imprest Surrender';
                        RunObject = page "Imprest List";
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ToolTip = 'Executes the Bank Accounts action';
                    }
                }

                group("Approved Document")
                {
                    action(ApprovedReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Receipt';
                        Visible = false;
                        RunObject = Page "Receipts List";
                        RunPageView = where(Posted = filter(true));
                        ToolTip = 'Executes the Bank Accounts action';
                    }
                    action("Posted Board Allowances Expenses")
                    {
                        RunObject = Page "Board Allowances";
                        RunPageView = where(Paid = filter(True));
                        ApplicationArea = All;
                    }
                    action(ApprovedPettyCash)
                    {
                        ApplicationArea = All;
                        Caption = 'Petty Cash';
                        RunObject = page "Petty Cash List";
                        RunPageView = where("Approval Status" = filter(Approved));
                        ToolTip = 'Executes the Fixed Assets action';
                    }
                    action(ApprovedPaymentVoucher)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Voucher';
                        RunObject = page "Payment Voucher List";
                        RunPageView = where("Approval Status" = filter(Approved));
                        ToolTip = 'Executes the Customers action';
                    }
                    action(ApprovedImprest)
                    {
                        ApplicationArea = All;
                        Caption = 'Impresst';
                        RunObject = page "Imprest List";
                        RunPageView = where("Approval Status" = filter(Approved));
                        ToolTip = 'Executes the Bank Accounts action';
                    }
                    action(ApprovedImprestSurrender)
                    {
                        ApplicationArea = All;
                        Caption = 'Imprest Surrender';
                        RunObject = page "Imprest List";
                        RunPageView = where("Approval Status" = filter(Approved));
                        ToolTip = 'Executes the Bank Accounts action';
                    }

                }

            }
            group("Dividend Management")
            {
                action(DividendLine)
                {
                    RunObject = Page "Dividend List";
                    RunPageView = where(Status = filter(Open | "Pending Approval"));
                    Caption = 'Dividend';
                    ApplicationArea = All;
                }
                action(DividendLineApproved)
                {
                    RunObject = Page "Dividend List";
                    RunPageView = where(Status = filter(Approved));
                    Caption = 'Dividend Approved';
                    ApplicationArea = All;
                }
                action(DividendLinePosted)
                {
                    RunObject = Page "Dividend List";
                    RunPageView = where(Status = filter(Posted));
                    Caption = 'Dividend Posted';
                    ApplicationArea = All;
                }
                action(Dividendsetup)
                {
                    RunObject = Page "Dividend Setup";
                    Caption = 'Dividend Setup';
                    ApplicationArea = All;
                }
            }
            group("Group28")
            {
                Caption = 'Receivables';

                action("Customers")
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    RunObject = page "Customer List";
                    ToolTip = 'Executes the Customers action';
                }
                action("Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoices';
                    RunObject = page "Sales Invoice List";
                    ToolTip = 'Executes the Sales Invoices action';
                }
                action("Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Credit Memos';
                    RunObject = page "Sales Credit Memos";
                    ToolTip = 'Executes the Sales Credit Memos action';
                }
                action("Direct Debit Collections")
                {
                    ApplicationArea = Suite;
                    Caption = 'Direct Debit Collections';
                    RunObject = page "Direct Debit Collections";
                    ToolTip = 'Executes the Direct Debit Collections action';
                }
                action("Create Recurring Sales Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Create Recurring Sales Invoices';
                    RunObject = report "Create Recurring Sales Inv.";
                    ToolTip = 'Executes the Create Recurring Sales Invoices action';
                }
                action("Register Customer Payments")
                {
                    ApplicationArea = All;
                    Caption = 'Register Customer Payments';
                    RunObject = page "Payment Registration";
                    ToolTip = 'Executes the Register Customer Payments action';
                }
                group("Group29")
                {
                    Caption = 'Combine';

                    action("Combined Shipments")
                    {
                        ApplicationArea = All;
                        Caption = 'Combine Shipments...';
                        RunObject = report "Combine Shipments";
                        ToolTip = 'Executes the Combine Shipments... action';
                        Visible = false;
                    }
                    action("Combined Return Receipts")
                    {
                        ApplicationArea = SalesReturnOrder, PurchReturnOrder;
                        Caption = 'Combine Return Receipts...';
                        RunObject = report "Combine Return Receipts";
                        ToolTip = 'Executes the Combine Return Receipts... action';
                        Visible = false;
                    }
                }
                group("Group30")
                {
                    Caption = 'Collection';

                    action("Reminders")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Reminders';
                        RunObject = page "Reminder List";
                        ToolTip = 'Executes the Reminders action';
                        Visible = false;
                    }
                    action("Issued Reminders")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Issued Reminders';
                        RunObject = page "Issued Reminder List";
                        ToolTip = 'Executes the Issued Reminders action';
                        Visible = false;
                    }
                    action("Finance Charge Memos")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Finance Charge Memos';
                        RunObject = page "Finance Charge Memo List";
                        ToolTip = 'Executes the Finance Charge Memos action';
                        Visible = false;
                    }
                    action("Issued Finance Charge Memos")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Issued Finance Charge Memos';
                        RunObject = page "Issued Fin. Charge Memo List";
                        ToolTip = 'Executes the Issued Finance Charge Memos action';
                        Visible = false;
                    }
                }
                group("Group31")
                {
                    Caption = 'Journals';
                }
                group("Group33")
                {
                    Caption = 'Registers/Entries';

                    action("G/L Registers1")
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Registers';
                        RunObject = page "G/L Registers";
                        ToolTip = 'Executes the G/L Registers action';
                    }
                    action("Customer Ledger Entries")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Ledger Entries';
                        RunObject = page "Customer Ledger Entries";
                        ToolTip = 'Executes the Customer Ledger Entries action';
                    }
                    action("Reminder/Fin. Charge Entries")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Reminder/Fin. Charge Entries';
                        RunObject = page "Reminder/Fin. Charge Entries";
                        ToolTip = 'Executes the Reminder/Fin. Charge Entries action';
                        Visible = false;
                    }
                    action("Detailed Cust. Ledg. Entries")
                    {
                        ApplicationArea = All;
                        Caption = 'Detailed Customer Ledger Entries';
                        RunObject = page "Detailed Cust. Ledg. Entries";
                        ToolTip = 'Executes the Detailed Customer Ledger Entries action';
                    }
                }
                group("Group34")
                {
                    Caption = 'Reports';

                    action("Customer Detailed Aging")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Detailed Aging';
                        RunObject = report "Customer Detailed Aging";
                        ToolTip = 'Executes the Customer Detailed Aging action';
                    }
                    action("Customer Statement")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Statement';
                        RunObject = codeunit "Customer Layout - Statement";
                        ToolTip = 'Executes the Customer Statement action';
                    }
                    action("Customer Register")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Register';
                        RunObject = report "Customer Register";
                        ToolTip = 'Executes the Customer Register action';
                    }
                    action("Customer - Balance to Date")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer - Balance to Date';
                        RunObject = report "Customer - Balance to Date";
                        ToolTip = 'Executes the Customer - Balance to Date action';
                    }
                    action("Customer - Detail Trial Bal.")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer - Detail Trial Bal.';
                        RunObject = report "Customer - Detail Trial Bal.";
                        ToolTip = 'Executes the Customer - Detail Trial Bal. action';
                    }
                    action("Customer - List")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer - List';
                        RunObject = report "Customer - List";
                        ToolTip = 'Executes the Customer - List action';
                    }
                    action("Customer - Summary Aging")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer - Summary Aging';
                        RunObject = report "Customer - Summary Aging";
                        ToolTip = 'Executes the Customer - Summary Aging action';
                    }
                    action("Customer - Summary Aging Simp.")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Summary Aging Simp.';
                        RunObject = report "Customer - Summary Aging Simp.";
                        ToolTip = 'Executes the Customer - Summary Aging Simp. action';
                    }
                    action("Customer - Order Summary")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer - Order Summary';
                        RunObject = report "Customer - Order Summary";
                        ToolTip = 'Executes the Customer - Order Summary action';
                    }
                    action("Customer - Order Detail")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer - Order Detail';
                        RunObject = report "Customer - Order Detail";
                        ToolTip = 'Executes the Customer - Order Detail action';
                    }
                    action("Customer - Labels")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer Labels';
                        RunObject = report "Customer - Labels";
                        ToolTip = 'Executes the Customer Labels action';
                    }
                    action("Customer - Top 10 List")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Top 10 List';
                        RunObject = report "Customer - Top 10 List";
                        ToolTip = 'Executes the Customer Top 10 List action';
                    }
                    action("Sales Statistics")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Statistics';
                        RunObject = report "Sales Statistics";
                        ToolTip = 'Executes the Sales Statistics action';
                        Visible = false;
                    }
                    action("Customer/Item Sales")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer/Item Sales';
                        RunObject = report "Customer/Item Sales";
                        ToolTip = 'Executes the Customer/Item Sales action';
                        Visible = false;
                    }
                    action("Salesperson - Sales Statistics")
                    {
                        ApplicationArea = All;
                        Caption = 'Salesperson Sales Statistics';
                        RunObject = report "Salesperson - Sales Statistics";
                        ToolTip = 'Executes the Salesperson Sales Statistics action';
                        Visible = false;
                    }
                    action("Salesperson - Commission")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Salesperson Commission';
                        RunObject = report "Salesperson - Commission";
                        ToolTip = 'Executes the Salesperson Commission action';
                        Visible = false;
                    }
                    action("Customer - Sales List")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer - Sales List';
                        RunObject = report "Customer - Sales List";
                        ToolTip = 'Executes the Customer - Sales List action';
                        Visible = false;
                    }
                    action("Aged Accounts Receivable")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged Accounts Receivable';
                        RunObject = report "Aged Accounts Receivable";
                        ToolTip = 'Executes the Aged Accounts Receivable action';
                    }
                    action("Customer - Trial Balance")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Trial Balance';
                        RunObject = report "Customer - Trial Balance";
                        ToolTip = 'Executes the Customer Trial Balance action';
                    }
                    action("EC Sales List")
                    {
                        ApplicationArea = All;
                        Caption = 'EC Sales List';
                        RunObject = report "EC Sales List";
                        ToolTip = 'Executes the EC Sales List action';
                        Visible = false;
                    }
                }
                group("Group35")
                {
                    Caption = 'Setup';

                    action("Sales & Receivables Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales & Receivables Setup';
                        RunObject = page "Sales & Receivables Setup";
                        ToolTip = 'Executes the Sales & Receivables Setup action';
                    }
                    action("Payment Registration Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Registration Setup';
                        RunObject = page "Payment Registration Setup";
                        ToolTip = 'Executes the Payment Registration Setup action';
                    }
                    action("Report Selection Reminder and")
                    {
                        ApplicationArea = All;
                        Caption = 'Report Selections Reminder/Fin. Charge';
                        RunObject = page "Report Selection - Reminder";
                        ToolTip = 'Executes the Report Selections Reminder/Fin. Charge action';
                        Visible = false;
                    }
                    action("Reminder Terms")
                    {
                        ApplicationArea = All;
                        Caption = 'Reminder Terms';
                        RunObject = page "Reminder Terms";
                        ToolTip = 'Executes the Reminder Terms action';
                        Visible = false;
                    }
                    action("Finance Charge Terms")
                    {
                        ApplicationArea = All;
                        Caption = 'Finance Charge Terms';
                        RunObject = page "Finance Charge Terms";
                        ToolTip = 'Executes the Finance Charge Terms action';
                        Visible = false;
                    }
                }
            }
            group("Group36")
            {
                Caption = 'Payables';

                action("Vendors13")
                {
                    ApplicationArea = All;
                    Caption = 'Share Holders';
                    RunObject = page "Vendor List";
                    RunPageLink = "Vendor Type" = filter("Share holder");
                    ToolTip = 'Executes the Share Holders action';
                }
                action("Invoices1")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Invoices';
                    RunObject = page "Purchase Invoices";
                    ToolTip = 'Executes the Purchase Invoices action';
                }
                action("Credit Memos1")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Credit Memos';
                    RunObject = page "Purchase Credit Memos";
                    ToolTip = 'Executes the Purchase Credit Memos action';
                }
                action("Incoming Documents")
                {
                    ApplicationArea = All;
                    Caption = 'Incoming Documents';
                    RunObject = page "Incoming Documents";
                    ToolTip = 'Executes the Incoming Documents action';
                    Visible = false;
                }


                group("Group37")
                {
                    Caption = 'Journals';
                }
                group("Group39")
                {
                    Caption = 'Registers/Entries';

                    action("G/L Registers2")
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Registers';
                        RunObject = page "G/L Registers";
                        ToolTip = 'Executes the G/L Registers action';
                    }
                    action("Vendor Ledger Entries")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Ledger Entries';
                        RunObject = page "Vendor Ledger Entries";
                        ToolTip = 'Executes the Vendor Ledger Entries action';
                    }
                    action("Detailed Cust. Ledg. Entries1")
                    {
                        ApplicationArea = All;
                        Caption = 'Detailed Vendor Ledger Entries';
                        RunObject = page "Detailed Vendor Ledg. Entries";
                        ToolTip = 'Executes the Detailed Vendor Ledger Entries action';
                    }
                    action("Credit Transfer Registers")
                    {
                        ApplicationArea = All;
                        Caption = 'Credit Transfer Registers';
                        RunObject = page "Credit Transfer Registers";
                        ToolTip = 'Executes the Credit Transfer Registers action';
                        Visible = false;
                    }
                    action("Employee Ledger Entries")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Employee Ledger Entries';
                        RunObject = page "Employee Ledger Entries";
                        ToolTip = 'Executes the Employee Ledger Entries action';
                        Visible = false;
                    }
                }
                group("Group40")
                {
                    Caption = 'Reports';

                    action("Aged Accounts Payable")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged Accounts Payable';
                        RunObject = report "Aged Accounts Payable";
                        ToolTip = 'Executes the Aged Accounts Payable action';
                    }
                    action("Payments on Hold")
                    {
                        ApplicationArea = All;
                        Caption = 'Payments on Hold';
                        RunObject = report "Payments on Hold";
                        ToolTip = 'Executes the Payments on Hold action';
                    }
                    action("Purchase Statistics")
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Statistics';
                        RunObject = report "Purchase Statistics";
                        ToolTip = 'Executes the Purchase Statistics action';
                    }
                    action("Vendor Item Catalog")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Item Catalog';
                        RunObject = report "Vendor Item Catalog";
                        ToolTip = 'Executes the Vendor Item Catalog action';
                    }
                    action("Vendor Register")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Register';
                        RunObject = report "Vendor Register";
                        ToolTip = 'Executes the Vendor Register action';
                    }
                    action("Vendor - Balance to Date")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - Balance to Date';
                        RunObject = report "Vendor - Balance to Date";
                        ToolTip = 'Executes the Vendor - Balance to Date action';
                    }
                    action("Vendor - Detail Trial Balance")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - Detail Trial Balance';
                        RunObject = report "Vendor - Detail Trial Balance";
                        ToolTip = 'Executes the Vendor - Detail Trial Balance action';
                    }
                    action("Vendor - Labels")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Vendor - Labels';
                        RunObject = report "Vendor - Labels";
                        ToolTip = 'Executes the Vendor - Labels action';
                    }
                    action("Vendor - List")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - List';
                        RunObject = report "Vendor - List";
                        ToolTip = 'Executes the Vendor - List action';
                    }
                    action("Vendor - Order Detail")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - Order Detail';
                        RunObject = report "Vendor - Order Detail";
                        ToolTip = 'Executes the Vendor - Order Detail action';
                    }
                    action("Vendor - Order Summary")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - Order Summary';
                        RunObject = report "Vendor - Order Summary";
                        ToolTip = 'Executes the Vendor - Order Summary action';
                    }
                    action("Vendor - Purchase List")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - Purchase List';
                        RunObject = report "Vendor - Purchase List";
                        ToolTip = 'Executes the Vendor - Purchase List action';
                    }
                    action("Vendor - Summary Aging")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - Summary Aging';
                        RunObject = report "Vendor - Summary Aging";
                        ToolTip = 'Executes the Vendor - Summary Aging action';
                    }
                    action("Vendor - Top 10 List")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Vendor - Top 10 List';
                        RunObject = report "Vendor - Top 10 List";
                        ToolTip = 'Executes the Vendor - Top 10 List action';
                    }
                    action("Vendor - Trial Balance")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor - Trial Balance';
                        RunObject = report "Vendor - Trial Balance";
                        ToolTip = 'Executes the Vendor - Trial Balance action';
                    }
                    action("Vendor/Item Purchases")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor/Item Purchases';
                        RunObject = report "Vendor/Item Purchases";
                        ToolTip = 'Executes the Vendor/Item Purchases action';
                    }
                }
                group("Group41")
                {
                    Caption = 'Setup';

                    action("Purchases & Payables Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Purchases & Payables Setup';
                        RunObject = page "Purchases & Payables Setup";
                        ToolTip = 'Executes the Purchases & Payables Setup action';
                    }
                }
            }
            group("Group42")
            {
                Caption = 'Fixed Assets';

                action("Fixed Assets12")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets';
                    RunObject = page "Fixed Asset List";
                    ToolTip = 'Executes the Fixed Assets action';
                }
                action("Insurance12")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance';
                    RunObject = page "Insurance List";
                    ToolTip = 'Executes the Insurance action';
                }
                action("Calculate Depreciation...")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Calculate Depreciation...';
                    RunObject = report "Calculate Depreciation";
                    ToolTip = 'Executes the Calculate Depreciation... action';
                }
                action("Fixed Assets...")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Index Fixed Assets...';
                    RunObject = report "Index Fixed Assets";
                    ToolTip = 'Executes the Index Fixed Assets... action';
                }
                action("Insurance...")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Index Insurance...';
                    RunObject = report "Index Insurance";
                    ToolTip = 'Executes the Index Insurance... action';
                }
                group("Group43")
                {
                    Caption = 'Journals';

                    action("G/L Journals")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA G/L Journals';
                        RunObject = page "Fixed Asset G/L Journal";
                        ToolTip = 'Executes the FA G/L Journals action';
                    }
                    action("FA Journals")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Journals';
                        RunObject = page "Fixed Asset Journal";
                        ToolTip = 'Executes the FA Journals action';
                    }
                    action("FA Reclass. Journal")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Reclassification Journals';
                        RunObject = page "FA Reclass. Journal";
                        ToolTip = 'Executes the FA Reclassification Journals action';
                    }
                    action("Insurance Journals")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insurance Journals';
                        RunObject = page "Insurance Journal";
                        ToolTip = 'Executes the Insurance Journals action';
                    }
                    action("Recurring Journals1")
                    {
                        ApplicationArea = Suite, FixedAssets;
                        Caption = 'Recurring General Journals';
                        RunObject = page "Recurring General Journal";
                        ToolTip = 'Executes the Recurring General Journals action';
                    }
                    action("Recurring Fixed Asset Journals")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Recurring Fixed Asset Journals';
                        RunObject = page "Recurring Fixed Asset Journal";
                        ToolTip = 'Executes the Recurring Fixed Asset Journals action';
                    }
                }
                group("Group44")
                {
                    Caption = 'Reports';

                    group("Group45")
                    {
                        Caption = 'Fixed Assets';

                        action("Posting Group - Net Change")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Posting Group - Net Change';
                            RunObject = report "FA Posting Group - Net Change";
                            ToolTip = 'Executes the FA Posting Group - Net Change action';
                        }
                        action("Register1")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Register';
                            RunObject = report "Fixed Asset Register";
                            ToolTip = 'Executes the FA Register action';
                        }
                        action("Acquisition List")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Acquisition List';
                            RunObject = report "Fixed Asset - Acquisition List";
                            ToolTip = 'Executes the FA Acquisition List action';
                        }
                        action("Analysis1")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Analysis';
                            RunObject = report "Fixed Asset - Analysis";
                            ToolTip = 'Executes the FA Analysis action';
                        }
                        action("Book Value 01")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Book Value 01';
                            RunObject = report "Fixed Asset - Book Value 01";
                            ToolTip = 'Executes the FA Book Value 01 action';
                        }
                        action("Book Value 02")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Book Value 02';
                            RunObject = report "Fixed Asset - Book Value 02";
                            ToolTip = 'Executes the FA Book Value 02 action';
                        }
                        action("Details")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Details';
                            RunObject = report "Fixed Asset - Details";
                            ToolTip = 'Executes the FA Details action';
                        }
                        action("G/L Analysis")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA G/L Analysis';
                            RunObject = report "Fixed Asset - G/L Analysis";
                            ToolTip = 'Executes the FA G/L Analysis action';
                        }
                        action("List1")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA List';
                            RunObject = report "Fixed Asset - List";
                            ToolTip = 'Executes the FA List action';
                        }
                        action("Projected Value")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Projected Value';
                            RunObject = report "Fixed Asset - Projected Value";
                            ToolTip = 'Executes the FA Projected Value action';
                        }
                    }
                    group("Group46")
                    {
                        Caption = 'Insurance';

                        action("Uninsured FAs")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Uninsured FAs';
                            RunObject = report "Insurance - Uninsured FAs";
                            ToolTip = 'Executes the Uninsured FAs action';
                            Visible = false;
                        }
                        action("Register2")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Insurance Register';
                            RunObject = report "Insurance Register";
                            ToolTip = 'Executes the Insurance Register action';
                            Visible = false;
                        }
                        action("Analysis2")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Insurance Analysis';
                            RunObject = report "Insurance - Analysis";
                            ToolTip = 'Executes the Insurance Analysis action';
                            Visible = false;
                        }
                        action("Coverage Details")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Insurance Coverage Details';
                            RunObject = report "Insurance - Coverage Details";
                            ToolTip = 'Executes the Insurance Coverage Details action';
                            Visible = false;
                        }
                        action("List2")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Insurance List';
                            RunObject = report "Insurance - List";
                            ToolTip = 'Executes the Insurance List action';
                            Visible = false;
                        }
                        action("Tot. Value Insured")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Total Value Insured';
                            RunObject = report "Insurance - Tot. Value Insured";
                            ToolTip = 'Executes the FA Total Value Insured action';
                            Visible = false;
                        }
                    }
                    group("Group47")
                    {
                        Caption = 'Maintenance';

                        action("Register3")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Maintenance Register';
                            RunObject = report "Maintenance Register";
                            ToolTip = 'Executes the Maintenance Register action';
                            Visible = false;
                        }
                        action("Analysis3")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Maintenance Analysis';
                            RunObject = report "Maintenance - Analysis";
                            ToolTip = 'Executes the Maintenance Analysis action';
                            Visible = false;
                        }
                        action("Details1")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Maintenance Details';
                            RunObject = report "Maintenance - Details";
                            ToolTip = 'Executes the Maintenance Details action';
                            Visible = false;
                        }
                        action("Next Service")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Maintenance Next Service';
                            RunObject = report "Maintenance - Next Service";
                            ToolTip = 'Executes the Maintenance Next Service action';
                            Visible = false;
                        }
                    }
                }
                group("Group48")
                {
                    Caption = 'Registers/Entries';

                    action("FA Registers12")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Registers';
                        RunObject = page "FA Registers";
                        ToolTip = 'Executes the FA Registers action';
                    }
                    action("Insurance Registers12")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insurance Registers';
                        RunObject = page "Insurance Registers";
                        ToolTip = 'Executes the Insurance Registers action';
                        Visible = false;
                    }
                    action("FA Ledger Entries12")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Ledger Entries';
                        RunObject = page "FA Ledger Entries";
                        ToolTip = 'Executes the FA Ledger Entries action';
                    }
                    action("Maintenance Ledger Entries12")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Maintenance Ledger Entries';
                        RunObject = page "Maintenance Ledger Entries";
                        ToolTip = 'Executes the Maintenance Ledger Entries action';
                        Visible = false;
                    }
                    action("Ins. Coverage Ledger Entries12")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insurance Coverage Ledger Entries';
                        RunObject = page "Ins. Coverage Ledger Entries";
                        ToolTip = 'Executes the Insurance Coverage Ledger Entries action';
                        Visible = false;
                    }
                }
                group("Group49")
                {
                    Caption = 'Setup';

                    action("FA Setup")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Setup';
                        RunObject = page "Fixed Asset Setup";
                        ToolTip = 'Executes the FA Setup action';
                    }
                    action("FA Classes")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Classes';
                        RunObject = page "FA Classes";
                        ToolTip = 'Executes the FA Classes action';
                    }
                    action("FA Subclasses")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Subclasses';
                        RunObject = page "FA Subclasses";
                        ToolTip = 'Executes the FA Subclasses action';
                    }
                    action("FA Locations")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Locations';
                        RunObject = page "FA Locations";
                        ToolTip = 'Executes the FA Locations action';
                    }
                    action("Insurance Types")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insurance Types';
                        RunObject = page "Insurance Types";
                        ToolTip = 'Executes the Insurance Types action';
                        Visible = false;
                    }
                    action("Maintenance")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Maintenance';
                        RunObject = page "Maintenance";
                        ToolTip = 'Executes the Maintenance action';
                        Visible = false;
                    }
                    action("Depreciation Books")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Books';
                        RunObject = page "Depreciation Book List";
                        ToolTip = 'Executes the Depreciation Books action';
                    }
                    action("Depreciation Tables")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Tables';
                        RunObject = page "Depreciation Table List";
                        ToolTip = 'Executes the Depreciation Tables action';
                    }
                    action("FA Journal Templates")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Journal Templates';
                        RunObject = page "FA Journal Templates";
                        ToolTip = 'Executes the FA Journal Templates action';
                    }
                    action("FA Reclass. Journal Templates")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Reclassification Journal Template';
                        RunObject = page "FA Reclass. Journal Templates";
                        ToolTip = 'Executes the FA Reclassification Journal Template action';
                    }
                    action("Insurance Journal Templates")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insurance Journal Templates';
                        RunObject = page "Insurance Journal Templates";
                        ToolTip = 'Executes the Insurance Journal Templates action';
                        Visible = false;
                    }
                }
            }

            group("Group50")
            {
                Caption = 'Inventory';
                Visible = false;

                action("Inventory Periods12")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Periods';
                    RunObject = page "Inventory Periods";
                    ToolTip = 'Executes the Inventory Periods action';
                    Visible = false;
                }
                action("Phys. Invt. Counting Periods")
                {
                    ApplicationArea = Warehouse, Basic, Suite;
                    Caption = 'Physical Invtory Counting Periods';
                    RunObject = page "Phys. Invt. Counting Periods";
                    ToolTip = 'Executes the Physical Invtory Counting Periods action';
                    Visible = false;
                }
                action("Application Worksheet")
                {
                    ApplicationArea = All;
                    Caption = 'Application Worksheet';
                    RunObject = page "Application Worksheet";
                    ToolTip = 'Executes the Application Worksheet action';
                    Visible = false;
                }
                group("Group51")
                {
                    Caption = 'Costing';
                    Visible = false;

                    action("Adjust Item Costs/Prices")
                    {
                        ApplicationArea = All;
                        Caption = 'Adjust Item Costs/Prices';
                        RunObject = report "Adjust Item Costs/Prices";
                        ToolTip = 'Executes the Adjust Item Costs/Prices action';
                        Visible = false;
                    }
                    action("Adjust Cost - Item Entries")
                    {
                        ApplicationArea = All;
                        Caption = 'Adjust Cost - Item Entries...';
                        RunObject = report "Adjust Cost - Item Entries";
                        ToolTip = 'Executes the Adjust Cost - Item Entries... action';
                        Visible = false;
                    }
                    action("Update Unit Cost...")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Update Unit Costs...';
                        RunObject = report "Update Unit Cost";
                        ToolTip = 'Executes the Update Unit Costs... action';
                        Visible = false;
                    }
                    action("Post Inventory Cost to G/L")
                    {
                        ApplicationArea = All;
                        Caption = 'Post Inventory Cost to G/L';
                        RunObject = report "Post Inventory Cost to G/L";
                        ToolTip = 'Executes the Post Inventory Cost to G/L action';
                        Visible = false;
                    }
                }
                group("Group52")
                {
                    Caption = 'Journals';

                    action("Item Journal")
                    {
                        ApplicationArea = All;
                        Caption = 'Item Journals';
                        RunObject = page "Item Journal";
                        ToolTip = 'Executes the Item Journals action';
                    }
                    action("Item Reclass. Journals")
                    {
                        ApplicationArea = All;
                        Caption = 'Item Reclassification Journals';
                        RunObject = page "Item Reclass. Journal";
                        ToolTip = 'Executes the Item Reclassification Journals action';
                    }
                    action("Phys. Inventory Journals")
                    {
                        ApplicationArea = All;
                        Caption = 'Physical Inventory Journals';
                        RunObject = page "Phys. Inventory Journal";
                        ToolTip = 'Executes the Physical Inventory Journals action';
                    }
                    action("Revaluation Journals")
                    {
                        ApplicationArea = All;
                        Caption = 'Revaluation Journals';
                        RunObject = page "Revaluation Journal";
                        ToolTip = 'Executes the Revaluation Journals action';
                    }
                }
                group("Group53")
                {
                    Caption = 'Reports';

                    action("Inventory Valuation")
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Valuation';
                        RunObject = report "Inventory Valuation";
                        ToolTip = 'Executes the Inventory Valuation action';
                    }
                    action("Inventory Valuation - WIP")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Production Order - WIP';
                        RunObject = report "Inventory Valuation - WIP";
                        ToolTip = 'Executes the Production Order - WIP action';
                        Visible = false;
                    }
                    action("Inventory - List")
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory - List';
                        RunObject = report "Inventory - List";
                        ToolTip = 'Executes the Inventory - List action';
                    }
                    action("Invt. Valuation - Cost Spec.")
                    {
                        ApplicationArea = All;
                        Caption = 'Invt. Valuation - Cost Spec.';
                        RunObject = report "Invt. Valuation - Cost Spec.";
                        ToolTip = 'Executes the Invt. Valuation - Cost Spec. action';
                    }
                    action("Item Age Composition - Value")
                    {
                        ApplicationArea = All;
                        Caption = 'Item Age Composition - Value';
                        RunObject = report "Item Age Composition - Value";
                        ToolTip = 'Executes the Item Age Composition - Value action';
                    }
                    action("Item Register - Value")
                    {
                        ApplicationArea = All;
                        Caption = 'Item Register - Value';
                        RunObject = report "Item Register - Value";
                        ToolTip = 'Executes the Item Register - Value action';
                    }
                    action("Physical Inventory List")
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Physical Inventory List';
                        RunObject = report "Phys. Inventory List";
                        ToolTip = 'Executes the Physical Inventory List action';
                    }
                    action("Status")
                    {
                        ApplicationArea = All;
                        Caption = 'Status';
                        RunObject = report "Status";
                        ToolTip = 'Executes the Status action';
                    }
                    action("Cost Shares Breakdown")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Cost Shares Breakdown';
                        RunObject = report "Cost Shares Breakdown";
                        ToolTip = 'Executes the Cost Shares Breakdown action';
                    }
                    action("Item Register - Quantity")
                    {
                        ApplicationArea = All;
                        Caption = 'Item Register - Quantity';
                        RunObject = report "Item Register - Quantity";
                        ToolTip = 'Executes the Item Register - Quantity action';
                    }
                    action("Item Dimensions - Detail")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Item Dimensions - Detail';
                        RunObject = report "Item Dimensions - Detail";
                        ToolTip = 'Executes the Item Dimensions - Detail action';
                    }
                    action("Item Dimensions - Total")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Item Dimensions - Total';
                        RunObject = report "Item Dimensions - Total";
                        ToolTip = 'Executes the Item Dimensions - Total action';
                    }
                    action("Inventory - G/L Reconciliation")
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory - G/L Reconciliation';
                        RunObject = page "Inventory - G/L Reconciliation";
                        ToolTip = 'Executes the Inventory - G/L Reconciliation action';
                    }
                }
                group("Group54")
                {
                    Caption = 'Setup';

                    action("Inventory Posting Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Posting Setup';
                        RunObject = page "Inventory Posting Setup";
                        ToolTip = 'Executes the Inventory Posting Setup action';
                    }
                    action("Inventory Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Setup';
                        RunObject = page "Inventory Setup";
                        ToolTip = 'Executes the Inventory Setup action';
                    }
                    action("Item Charges")
                    {
                        ApplicationArea = ItemCharges;
                        Caption = 'Item Charges';
                        RunObject = page "Item Charges";
                        ToolTip = 'Executes the Item Charges action';
                    }
                    action("Item Categories")
                    {
                        ApplicationArea = All;
                        Caption = 'Item Categories';
                        RunObject = page "Item Categories";
                        ToolTip = 'Executes the Item Categories action';
                    }
                    action("Rounding Methods")
                    {
                        ApplicationArea = All;
                        Caption = 'Rounding Methods';
                        RunObject = page "Rounding Methods";
                        AccessByPermission = tabledata Resource = R;
                        ToolTip = 'Executes the Rounding Methods action';
                    }
                    action("Analysis Types")
                    {
                        ApplicationArea = SalesAnalysis, PurchaseAnalysis, InventoryAnalysis;
                        Caption = 'Analysis Types';
                        RunObject = page "Analysis Types";
                        ToolTip = 'Executes the Analysis Types action';
                    }
                    action("Inventory Analysis Report")
                    {
                        ApplicationArea = InventoryAnalysis;
                        Caption = 'Inventory Analysis Reports';
                        RunObject = page "Analysis Report Inventory";
                        ToolTip = 'Executes the Inventory Analysis Reports action';
                    }
                    action("Analysis View Card")
                    {
                        ApplicationArea = InventoryAnalysis, Dimensions;
                        Caption = 'Inventory Analysis by Dimensions';
                        RunObject = page "Analysis View List Inventory";
                        ToolTip = 'Executes the Inventory Analysis by Dimensions action';
                    }
                    action("Analysis Column Templates")
                    {
                        ApplicationArea = InventoryAnalysis;
                        Caption = 'Invt. Analysis Column Templates';
                        RunObject = report "Run Invt. Analysis Col. Temp.";
                        ToolTip = 'Executes the Invt. Analysis Column Templates action';
                    }
                    action("Analysis Line Templates")
                    {
                        ApplicationArea = InventoryAnalysis;
                        Caption = 'Invt. Analysis Line Templates';
                        RunObject = report "Run Invt. Analysis Line Temp.";
                        ToolTip = 'Executes the Invt. Analysis Line Templates action';
                    }
                }
            }
            group("Finance Periodic Activities")
            {
                Caption = 'Periodic Activities';
                Visible = true;
                group("Agency Remittance")
                {
                    Caption = 'Checkoff';
                    Visible = true;
                    action(RemittanceList)
                    {
                        Caption = 'Remittance';
                        RunObject = Page "Remittance List";
                        ApplicationArea = All;
                    }
                }
                group("Account Transfer")
                {
                    Caption = 'Account Transfer';
                    ToolTip = 'View the posting history for sales, shipments, and inventory.';
                    action(Action32)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Account Transfer';
                        Image = PostedOrder;
                        RunObject = Page "Account Transfer List";
                        ToolTip = 'Open the list of posted sales invoices.';
                    }


                }
                group("Electronic Funds Transfer")
                {
                    Caption = 'EFT Funds Transfer';
                    action(Action663)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'EFT Transfer';
                        RunObject = Page "EFT Receipt List";
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                    }

                }
                group("Accounts Closure")
                {
                    action("Withdrawal Notice")
                    {
                        RunObject = Page "Member withdrawal Notice List";
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ApplicationArea = All;
                    }
                    action("Membership Closure")
                    {
                        RunObject = Page "Membership Closure List";
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ApplicationArea = All;
                    }
                }
                group("Loan Billing")
                {
                    Caption = 'Billing';
                    Visible = true;

                    action(BillingCreate)
                    {
                        RunObject = Page "Interest Header List";
                        RunPageView = where("Application Type" = filter("Loan Interest" | Insurance), "Approval Status" = filter(Open));
                        Caption = 'Billing';
                        ApplicationArea = All;
                        Visible = true;
                    }
                }

                group("Interest on Savings")
                {
                    Caption = 'Interest on Savings';
                    Visible = false;
                    action(PostedRejectedApplications)
                    {
                        Caption = 'Bills Posted';
                        RunObject = Page "Interest Posted";
                        ApplicationArea = All;
                        Visible = false;
                    }
                    action(EndYearInterestPosting)
                    {
                        RunObject = page "Posted End Year Interest List";
                        Caption = 'End Year Interest';
                        ApplicationArea = All;
                        Visible = true;
                    }
                }
                group("Approved Application")
                {
                    action(Action33)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Account Transfer';
                        Image = PostedOrder;
                        RunObject = Page "Account Transfer-Approved";
                        ToolTip = 'Open the list of posted sales invoices.';
                    }
                    action(Action664)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'EFT Transfer';
                        RunObject = Page "EFT Receipt List";
                        RunPageView = where("Approval Status" = filter(Approved));
                        ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                    }
                    action("AppWithdrawalNotice")
                    {
                        RunObject = Page "Member withdrawal Notice List";
                        Caption = 'Notice';
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ApplicationArea = All;
                    }
                    action("AppMembershipClosure")
                    {
                        RunObject = Page "Membership Closure List";
                        Caption = 'Account Closure';
                        RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                        ApplicationArea = All;
                    }
                }

                group(BBF)
                {
                    Caption = 'Benevolent Fund Recovery';
                    Visible = false;

                    action("Line Entries")
                    {

                        RunObject = Page "Line Entries";
                        Caption = 'Entries Lines';
                        ApplicationArea = All;
                        Visible = true;
                    }
                }
            }
            group(PayrollActivities)
            {
                Caption = 'Payroll Management';
                group("Employee Management")
                {

                    Caption = 'Employee Management';
                    action("Employee List - Active")
                    {
                        RunObject = page "Employee List-Filtered";
                        ApplicationArea = All;
                        RunPageView = where(Status = filter(Active));
                        ToolTip = 'Executes the Employee List - Active action';
                        Caption = 'Employee List - Active';
                    }
                    action("Employee List - Inactive")
                    {
                        RunObject = page "Employee List-Filtered";
                        ApplicationArea = All;
                        RunPageView = where(Status = filter(Inactive));
                        ToolTip = 'Executes the Employee List - Inactive action';
                        Caption = 'Employee List - Inactive';
                    }
                    action("Employee List")
                    {
                        Caption = 'Employee List';
                        RunObject = Page "Hr Employee List";
                        ApplicationArea = All;
                    }

                }
                group("Payroll Processing")
                {
                    action("Salary List")
                    {
                        Caption = 'Salary List';
                        RunObject = Page "Pr Salary List";
                        RunPageView = where(Status = filter(Active));
                        ApplicationArea = All;
                    }
                }
                group("Payroll Setups")
                {
                    action(HrSetup)
                    {
                        RunObject = Page "HR Setup";
                        Caption = 'HR Setup';
                        ApplicationArea = All;
                    }
                    action("Vital Setup")
                    {
                        Caption = 'Rates & Ceiling';
                        RunObject = Page "Rates & Ceiling List";
                        ApplicationArea = All;
                    }
                    action("Transaction Code")
                    {
                        Caption = 'Transaction Codes';
                        RunObject = page "Transaction Code List";
                        ApplicationArea = All;
                    }

                    action("PAYE Setup")
                    {
                        Caption = 'PAYE';
                        RunObject = Page "PAYE Setup";
                        ApplicationArea = All;
                    }
                    action("NHIF Setup")
                    {
                        Caption = 'NHIF';
                        RunObject = Page "NHIF Setup";
                        ApplicationArea = All;
                    }
                    action("NSSF Setup")
                    {
                        Caption = 'NSSF';
                        RunObject = Page "NSSF Setup";
                        ApplicationArea = All;

                    }
                    action(SalaryGrade)
                    {
                        RunObject = Page "Salary Grades";
                        Caption = 'Salary Grade';
                        ApplicationArea = All;
                    }
                    action(PayrollPostingGroup)
                    {
                        RunObject = Page "Payroll Posting Group";
                        Caption = 'Posting Group';
                        ApplicationArea = All;
                    }
                    action(HRLookup)
                    {
                        RunObject = Page "HR Lookup Value";
                        Caption = 'Lookup Values';
                        ApplicationArea = All;
                    }
                    action(HRJobs)
                    {
                        RunObject = Page "HR Job ID";
                        Caption = 'Jobs';
                        ApplicationArea = All;
                    }

                }
                group(Action121)
                {
                    Caption = 'Periodic Activities';
                    action("Payroll Period")
                    {
                        RunObject = Page "Payroll Period";
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Transfer Journal")
                    {
                        Caption = 'Payroll Journal';
                        RunObject = report "Pr Transfer To Journal";
                        ApplicationArea = All;
                    }
                    action("Leave Journal")
                    {
                        Caption = 'Leave Journal';
                        RunObject = page "Hr Leave Journal Line";
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(PayrollArchive)
                {
                    Caption = 'Archive';
                    action("Period Transactions")
                    {
                        RunObject = Page "Pr Period Transactions";
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Posted Payroll Request")
                {
                    Caption = 'Payroll Request';
                    RunObject = page "Payroll Requests";
                    RunPageView = where(Status = filter(Posted));
                    ApplicationArea = All;
                    ToolTip = 'Payroll Request';
                }

                    action("Period Transactions- Consd")
                    {
                        RunObject = Page "Pr Period Transaction - Consd.";
                        Caption = 'Consolidated Transactions';
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Employer Deduction")
                    {
                        RunObject = Page "Pr Employer Deductions";
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Payroll P9")
                    {
                        RunObject = Page "Pr P9 Information";
                        ApplicationArea = All;
                        Visible = true;
                    }
                }
                group("Payroll Report")
                {
                    action("PayrollP9")
                    {
                        Caption = 'Payroll P9';
                        RunObject = report "Payroll P9";
                        ApplicationArea = All;
                        Visible = true;
                    }


                    action("Payroll Summary")
                    {
                        RunObject = report "Pr Payroll Summary";
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Detailed Payroll Summary")
                    {
                        RunObject = report "Pr Detld. Payroll Summary";
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Payroll Allowance")
                    {
                        RunObject = report PrAllowanceDeduct;
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Sacco deduction")
                    {
                        RunObject = report "Payroll Loan Deductions";
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Payroll Deduction")
                    {
                        RunObject = report "Payroll Deduction";
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action("Statutory Deductions")
                    {
                        RunObject = report "Pr Statutory Deduction";
                        ApplicationArea = All;
                        Visible = true;
                    }

                }
            }
            group(Archive)
            {
                group(MemberAccounts)
                {
                    Caption = 'Accounts';
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
                }
                group(Documents)
                {
                    action(PostedReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Receipt';
                        RunObject = Page "Receipts List";
                        RunPageView = where(Posted = filter(true));
                        ToolTip = 'Executes the Bank Accounts action';
                    }

                    action(PostedPettyCash)
                    {
                        ApplicationArea = All;
                        Caption = 'Petty Cash';
                        RunObject = page "Petty Cash List";
                        RunPageView = where("Approval Status" = filter(Posted | Rejected));
                        ToolTip = 'Executes the Fixed Assets action';
                    }
                    action(PostedPaymentVoucher)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Voucher';
                        RunObject = page "Payment Voucher List";
                        RunPageView = where("Approval Status" = filter(Posted | Rejected));
                        ToolTip = 'Executes the Customers action';
                    }
                    action(PostedImprest)
                    {
                        ApplicationArea = All;
                        Caption = 'Impresst';
                        RunObject = page "Imprest List";
                        RunPageView = where("Approval Status" = filter(Posted | Rejected));
                        ToolTip = 'Executes the Bank Accounts action';
                    }
                    action(PostedImprestSurrender)
                    {
                        ApplicationArea = All;
                        Caption = 'Imprest Surrender';
                        RunObject = page "Imprest List";
                        RunPageView = where("Approval Status" = filter(Posted | Rejected));
                        ToolTip = 'Executes the Bank Accounts action';
                    }

                    action("PostedRemmittances")
                    {
                        Caption = 'Remmittances';
                        RunObject = Page "Posted Remittances";
                        ApplicationArea = All;
                        Visible = true;

                    }
                    action(BillingPosted)
                    {
                        RunObject = Page "Interest Header List";
                        RunPageView = where("Application Type" = const("Loan Interest"), "Approval Status" = filter(Posted));
                        Caption = 'Billing';
                        ApplicationArea = All;
                        Visible = true;
                    }
                    action(Action34)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Account Transfer';
                        Image = PostedOrder;
                        RunObject = Page "Account Transfer-Posted";
                        ToolTip = 'Open the list of posted sales invoices.';
                    }
                    action("EFT Transfers Untransferred")
                    {
                        RunObject = Page "EFT Receipt List";
                        ApplicationArea = All;
                        Caption = 'EFT Transfer';
                        RunPageView = where("Approval Status" = filter(Posted));
                    }
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

                action("Payroll Request")
                {
                    Caption = 'Payroll Request';
                    RunObject = page "Payroll Requests";
                    RunPageView = where(Status = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                    ToolTip = 'Payroll Request';
                }
                action("Leave Application")
                {
                    Caption = 'Leave Application';
                    ApplicationArea = All;
                    RunObject = page "Hr Leave Application List";

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
                    Visible = false;

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
                            Visible = false;


                        }
                        group("Technical EvaluationSelf")
                        {
                            Caption = 'Technical Evaluation';
                            Visible = false;
                        }
                        group(FinanicalEvaluation)
                        {
                            Caption = 'Financial Evaluation';
                            Visible = false;
                        }
                        group("PrequalificationOpeningSelf")
                        {
                            Caption = 'Prequalification Tender Opening';
                        }
                    }
                }
            }
            group("Group55")
            {
                Caption = 'Setup';

                action("General Posting Setup")
                {
                    ApplicationArea = All;
                    Caption = 'General Posting Setup';
                    RunObject = page "General Posting Setup";
                    ToolTip = 'Executes the General Posting Setup action';
                }
                action("Incoming Documents Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Incoming Documents Setup';
                    RunObject = page "Incoming Documents Setup";
                    ToolTip = 'Executes the Incoming Documents Setup action';
                    Visible = false;
                }
                action("Accounting Periods")
                {
                    ApplicationArea = All;
                    Caption = 'Accounting Periods';
                    RunObject = page "Accounting Periods";
                    ToolTip = 'Executes the Accounting Periods action';
                }
                action("Standard Text Codes")
                {
                    ApplicationArea = All;
                    Caption = 'Standard Text Codes';
                    RunObject = page "Standard Text Codes";
                    ToolTip = 'Executes the Standard Text Codes action';
                    Visible = false;
                }
                action("No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'No. Series';
                    RunObject = page "No. Series";
                    ToolTip = 'Executes the No. Series action';
                }
                group("Group56")
                {
                    Caption = 'VAT';

                    action("Posting Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Posting Setup';
                        RunObject = page "VAT Posting Setup";
                        ToolTip = 'Executes the VAT Posting Setup action';
                    }
                    action("VAT Clauses")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Clauses';
                        RunObject = page "VAT Clauses";
                        ToolTip = 'Executes the VAT Clauses action';
                    }
                    action("VAT Change Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Rate Change Setup';
                        RunObject = page "VAT Rate Change Setup";
                        ToolTip = 'Executes the VAT Rate Change Setup action';
                    }
                    action("VAT Statement Templates")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Statement Templates';
                        RunObject = page "VAT Statement Templates";
                        ToolTip = 'Executes the VAT Statement Templates action';
                    }
                    action("VAT Reports Configuration")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Reports Configuration';
                        RunObject = page "VAT Reports Configuration";
                        ToolTip = 'Executes the VAT Reports Configuration action';
                    }
                }
                group("Group57")
                {
                    Caption = 'Intrastat';

                    action("Tariff Numbers")
                    {
                        ApplicationArea = All;
                        Caption = 'Tariff Numbers';
                        RunObject = page "Tariff Numbers";
                        ToolTip = 'Executes the Tariff Numbers action';
                        Visible = false;
                    }
                    action("Transaction Types")
                    {
                        ApplicationArea = All;
                        Caption = 'Transaction Types';
                        RunObject = page "Transaction Types";
                        ToolTip = 'Executes the Transaction Types action';
                        Visible = false;
                    }
                    action("Transaction Specifications")
                    {
                        ApplicationArea = All;
                        Caption = 'Transaction Specifications';
                        RunObject = page "Transaction Specifications";
                        ToolTip = 'Executes the Transaction Specifications action';
                        Visible = false;
                    }
                    action("Transport Methods")
                    {
                        ApplicationArea = All;
                        Caption = 'Transport Methods';
                        RunObject = page "Transport Methods";
                        ToolTip = 'Executes the Transport Methods action';
                        Visible = false;
                    }
                    action("Entry/Exit Points")
                    {
                        ApplicationArea = All;
                        Caption = 'Entry/Exit Points';
                        RunObject = page "Entry/Exit Points";
                        ToolTip = 'Executes the Entry/Exit Points action';
                        Visible = false;
                    }
                    action("Areas")
                    {
                        ApplicationArea = All;
                        Caption = 'Areas';
                        RunObject = page "Areas";
                        ToolTip = 'Executes the Areas action';
                        Visible = false;
                    }

                }
                group("Group58")
                {
                    Caption = 'Intercompany';

                    action("Intercompany Setup")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Intercompany Setup';
                        RunObject = page "Intercompany Setup";
                        ToolTip = 'Executes the Intercompany Setup action';
                        Visible = false;
                    }
                    action("Partner Code")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Intercompany Partners';
                        RunObject = page "IC Partner List";
                        ToolTip = 'Executes the Intercompany Partners action';
                        Visible = false;
                    }
                    action("Chart of Accounts2")
                    {
                        ApplicationArea = Intercompany;
                        Caption = 'Intercompany Chart of Accounts';
                        RunObject = page "IC Chart of Accounts";
                        ToolTip = 'Executes the Intercompany Chart of Accounts action';
                        Visible = false;
                    }
                    action("Dimensions")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Intercompany Dimensions';
                        RunObject = page "IC Dimensions";
                        ToolTip = 'Executes the Intercompany Dimensions action';
                        Visible = false;
                    }
                }
                group("Group59")
                {
                    Caption = 'Dimensions';

                    action("Dimensions1")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions';
                        RunObject = page "Dimensions";
                        ToolTip = 'Executes the Dimensions action';
                        Visible = false;
                    }
                    action("Analyses by Dimensions1")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Analysis by Dimensions';
                        RunObject = page "Analysis View List";
                        ToolTip = 'Executes the Analysis by Dimensions action';
                        Visible = false;
                    }
                    action("Dimension Combinations")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Dimension Combinations';
                        RunObject = page "Dimension Combinations";
                        ToolTip = 'Executes the Dimension Combinations action';
                        Visible = false;
                    }
                    action("Default Dimension Priorities")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Default Dimension Priorities';
                        RunObject = page "Default Dimension Priorities";
                        ToolTip = 'Executes the Default Dimension Priorities action';
                        Visible = false;
                    }
                }
                group("Group60")
                {
                    Caption = 'Trail Codes';

                    action("Source Codes")
                    {
                        ApplicationArea = All;
                        Caption = 'Source Codes';
                        RunObject = page "Source Codes";
                        ToolTip = 'Executes the Source Codes action';
                        //Visible=false;
                    }
                    action("Reason Codes")
                    {
                        ApplicationArea = All;
                        Caption = 'Reason Codes';
                        RunObject = page "Reason Codes";
                        ToolTip = 'Executes the Reason Codes action';
                    }
                    action("Source Code Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Source Code Setup';
                        RunObject = page "Source Code Setup";
                        ToolTip = 'Executes the Source Code Setup action';
                    }
                }
                group("Group61")
                {
                    Caption = 'Posting Groups';

                    action("General Business")
                    {
                        ApplicationArea = All;
                        Caption = 'Gen. Business Posting Groups';
                        RunObject = page "Gen. Business Posting Groups";
                        ToolTip = 'Executes the Gen. Business Posting Groups action';
                    }
                    action("Gen. Product Posting Groups")
                    {
                        ApplicationArea = All;
                        Caption = 'General Product Posting Groups';
                        RunObject = page "Gen. Product Posting Groups";
                        ToolTip = 'Executes the General Product Posting Groups action';
                    }
                    action("Customer Posting Groups")
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Posting Groups';
                        RunObject = page "Customer Posting Groups";
                        ToolTip = 'Executes the Customer Posting Groups action';
                    }
                    action("Vendor Posting Groups")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Posting Groups';
                        RunObject = page "Vendor Posting Groups";
                        ToolTip = 'Executes the Vendor Posting Groups action';
                    }
                    action("Bank Account")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account Posting Groups';
                        RunObject = page "Bank Account Posting Groups";
                        ToolTip = 'Executes the Bank Account Posting Groups action';
                    }
                    action("Inventory Posting Groups")
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Posting Groups';
                        RunObject = page "Inventory Posting Groups";
                        ToolTip = 'Executes the Inventory Posting Groups action';
                    }
                    action("FA Posting Groups")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Posting Groups';
                        RunObject = page "FA Posting Groups";
                        ToolTip = 'Executes the FA Posting Groups action';
                    }
                    action("Business Posting Groups")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Business Posting Groups';
                        RunObject = page "VAT Business Posting Groups";
                        ToolTip = 'Executes the VAT Business Posting Groups action';
                    }
                    action("Product Posting Groups")
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Product Posting Groups';
                        RunObject = page "VAT Product Posting Groups";
                        ToolTip = 'Executes the VAT Product Posting Groups action';
                    }
                }
                group("General Ledger History")
                {
                    action("G/L Registers")
                    {
                        RunObject = page "G/L Registers";
                        ApplicationArea = All;
                        ToolTip = 'Executes the G/L Registers action';
                    }
                    action("General Ledger Entries")
                    {
                        RunObject = page "General Ledger Entries";
                        ApplicationArea = All;
                        ToolTip = 'Executes the General Ledger Entries action';
                    }
                    action("G/L Budget Entries")
                    {
                        RunObject = page "G/L Budget Entries";
                        ApplicationArea = All;
                        ToolTip = 'Executes the G/L Budget Entries action';
                    }
                    action("VAT Entries")
                    {
                        RunObject = page "VAT Entries";
                        ApplicationArea = All;
                        ToolTip = 'Executes the VAT Entries action';
                    }
                    action("Analysis View Entries")
                    {
                        RunObject = page "Analysis View Entries";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Analysis View Entries action';
                    }
                    action("Analysis View Budget Entries")
                    {
                        RunObject = page "Analysis View Budget Entries";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Analysis View Budget Entries action';
                    }
                    action("Item Budget Entries")
                    {
                        RunObject = page "Item Budget Entries";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Item Budget Entries action';
                    }
                }
                group("Cash Management Lists")
                {
                    action("Bank Accounts")
                    {
                        RunObject = page "Bank Account List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Bank Accounts action';
                    }
                    action("Payment Reconciliation Journals")
                    {
                        RunObject = page "Pmt. Reconciliation Journals";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Payment Reconciliation Journals action';
                        Visible = false;
                    }
                    action("Bank Acc. Reconciliation List")
                    {
                        RunObject = page "Bank Acc. Reconc List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Bank Acc. Reconciliation List action';
                    }
                    action("Posted Payment Reconciliations")
                    {
                        RunObject = page "Posted Payment Reconciliations";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Posted Payment Reconciliations action';
                    }
                    group(Receipting1)
                    {
                        Caption = 'Agency Receipting';
                        Visible = true;
                        action(Receipt1)
                        {
                            Caption = 'Agency Receipts';
                            RunObject = Page "Receipts List";
                            ApplicationArea = All;


                        }

                    }
                    group(Receipting2)
                    {
                        Caption = 'Customer Receipting';
                        Visible = true;
                        action(Receipt2)
                        {
                            RunObject = Page "Receipts List";
                            ApplicationArea = All;


                        }
                    }
                    group("Document Archive List")
                    {
                        action("Bank Account Ledger Entries")
                        {
                            RunObject = page "Bank Account Ledger Entries";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Bank Account Ledger Entries action';
                        }
                        action("Check Ledger Entries")
                        {
                            RunObject = page "Check Ledger Entries";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Check Ledger Entries action';
                        }
                        action("FA Registers")
                        {
                            RunObject = page "FA Registers";
                            ApplicationArea = All;
                            ToolTip = 'Executes the FA Registers action';
                        }
                        action("Insurance Registers")
                        {
                            RunObject = page "Insurance Registers";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Insurance Registers action';
                        }
                        action("FA Ledger Entries")
                        {
                            RunObject = page "FA Ledger Entries";
                            ApplicationArea = All;
                            ToolTip = 'Executes the FA Ledger Entries action';
                        }
                        action("Maintenance Ledger Entries")
                        {
                            RunObject = page "Maintenance Ledger Entries";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Maintenance Ledger Entries action';
                        }
                        action("Ins. Coverage Ledger Entries")
                        {
                            RunObject = page "Ins. Coverage Ledger Entries";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Ins. Coverage Ledger Entries action';
                        }
                    }
                    group("Acc. Payable")
                    {
                        action(Vendors)
                        {
                            Caption = 'Vendors';
                            Image = Vendor;
                            RunObject = page "Vendor List";
                            RunPageLink = "Vendor Type" = filter(<> "Share holder");
                            ApplicationArea = All;
                            ToolTip = 'Executes the Vendors action';
                        }
                        action(GeneralJournals)
                        {
                            ApplicationArea = Advanced;
                            Caption = 'General Journals';
                            Image = Journal;
                            RunObject = page "General Journal Batches";
                            RunPageView = where("Template Type" = const(General),
                                        Recurring = const(false));
                            ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.';
                        }
                        action("Purchase Invoices")
                        {
                            RunObject = page "Purchase Invoices";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Purchase Invoices action';
                        }
                        action("Purchase Credit Memos")
                        {
                            RunObject = page "Purchase Credit Memos";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Purchase Credit Memos action';
                        }
                    }
                    group("Acc. Payables Archive")
                    {
                        action("Posted Purchase Invoices")
                        {
                            RunObject = page "Posted Purchase Invoices";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Posted Purchase Invoices action';
                        }
                        action("Posted Purchase Credit Memos")
                        {
                            RunObject = page "Posted Purchase Credit Memos";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Posted Purchase Credit Memos action';
                        }
                    }
                    group("Acc. Receivables List")
                    {
                        Caption = 'Approvals';

                        action("Sales Invoices")
                        {
                            RunObject = page "Sales Invoice List";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Sales Invoices action';
                        }
                        action("Approval Delegation")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Executes the Approval Delegation action';
                        }
                        action("Approved Payment Vouchers ")
                        {
                            //RunObject = page "Approved Payment Vouchers1";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Approved Payment Vouchers  action';
                        }

                        action("Bank Accounts.")
                        {
                            RunObject = page "Bank Account List";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Bank Accounts. action';
                        }
                        action("Payment reconciliation Journals.")
                        {
                            RunObject = page "Pmt. Reconciliation Journals";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Payment reconciliation Journals. action';
                        }
                        action("Bank Acc. Reconciliation List.")
                        {
                            RunObject = page "Bank Acc. Reconciliation List";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Bank Acc. Reconciliation List. action';
                        }
                    }
                    group("Fixed Assets List")
                    {
                        action("Fixed Assets")
                        {
                            RunObject = page "Fixed Asset List";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Fixed Assets action';
                        }
                        action(Insurance)
                        {
                            RunObject = page "Insurance List";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Insurance action';
                            Visible = false;
                        }
                    }
                    group(Inventory)
                    {
                        action("Items")
                        {
                            RunObject = page "Item List";
                            ApplicationArea = All;
                        }
                        action("Inventory Periods")
                        {
                            RunObject = page "Inventory Periods";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Inventory Periods action';
                        }
                        action("Chart of Accounts.")
                        {
                            RunObject = page "Chart of Accounts";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Chart of Accounts. action';
                        }
                        action("Phys. Invent. Counting Periods")
                        {
                            RunObject = page "Phys. Invt. Counting Periods";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Phys. Invent. Counting Periods action';
                        }
                    }
                }
            }
        }
    }
}


