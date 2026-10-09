page 51047 "Credit Mngt. Role Center"
{
    Caption = 'Credit Management', Comment = '{Dependency=Match,"ProfileDescription_ACCOUNTINGMANAGER"}';
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
                part(Control1902304208; "Credit Mngt. Activities")
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
            action("Member Advice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Monthly Advice';
                Image = "Report";
                RunObject = Report "Member Advice Analysis";
            }
            action("Monthly Advice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loans Advice';
                Image = "Report";
                RunObject = Report "Monthly Advise-Loans";
            }
            action("Checkoff Monthly Advice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Checkoff Advice';
                Image = "Report";
                RunObject = Report "Checkoff Advise-Detailed";
            }
            action("Bank Trail Bal.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Acc. Trail Bal.';
                Image = "Report";
                RunObject = Report "Bank Account Report";
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
                Caption = 'Loans Register List';
                Image = "Report";
                RunObject = Report "Loan Register List";
            }
            action("Loan Posted Amount")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Amount';
                Image = "Report";
                RunObject = Report "Loans Register Mngt";
            }
            action("Loan Approved Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Approved Amount';
                Image = "Report";
                RunObject = Report "Loan Approved Amount Variance";

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
            action("Share Loan Listing")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Share Loan Listing';
                Image = "Report";
                RunObject = Report "Share Loan Listing";
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
                RunObject = Report "Loan Sasra ";
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
                Caption = 'Defaulted Loan List';
                Image = "Report";
                RunObject = Report "Defaulted Loan List";
            }
            action(CollateralRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Collateral Register Attached';
                Image = "Report";
                Visible = false;
                RunObject = Report "Collateral Register";
            }
            action(CollateralRegisterReportNoLoan)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Collateral Register';
                Image = "Report";
                RunObject = Report "Collateral Register-No Loan";
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
            action(DividendRegisterReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dividend Register';
                Image = "Report";
                Visible = false;
                RunObject = Report "Dividend Register";
            }
            action(DividendProgressionReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dividend Progression';
                Image = "Report";
                Visible = false;
                RunObject = Report "Dividend Progression";
            }
            action(PaymentCertificate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Certificate';
                Image = "Report";
                Visible = false;
                RunObject = Report "Payment Certificate";
            }
            action(InsuranceCertificate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Insurance Report';
                Image = "Report";
                RunObject = Report "Insurance Report";
            }
             action(DepositInsurance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deposit Insurance Report';
                Image = "Report";
                RunObject = Report "Deposit Insurance Report";
            }
            action(DemandLetter)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Demand Letter';
                Image = "Report";
                Visible = false;
                RunObject = Report "Demand Letter 3";
            }
            action(EFTPayments)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EFT Payments';
                Image = "Report";
                RunObject = Report "EFT Bank Details";
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
            action(PaymentVoucherListing)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Voucher';
                Image = "Report";
                RunObject = Report "Payment Voucher-Listing";
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

            action("LoanRepaymentSchedule")
            {
                RunObject = Page "Loan Repayment Schedule";
                ApplicationArea = All;
            }

            // Loan Repayment Schedule
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
                // RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"));
                Caption = 'Bosa Account';
                ApplicationArea = All;
            }
            action("Accounts Credit-Deposits")
            {
                RunObject = Page "Account Credit List";
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"),"Account Category"=filter("Shares Deposit"));
                Caption = 'Deposits Account';
                ApplicationArea = All;
            }
            action("Account Banking-IESA")
            {
                RunObject = Page "Savings Account List";
                Caption = 'Iesa Account';
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"),"Account Category"=filter("Money Market"));
                ApplicationArea = All;
            }
            action("Account Banking- Holiday")
            {
                RunObject = Page "Savings Account List";
                Caption = 'Holiday Account';
                RunPageView = where(Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application"),"Account Category"=filter("Specialty Savings"));
                ApplicationArea = All;
            }

            action("Loan Account")
            {
                RunObject = Page "Loan Account";
                ApplicationArea = All;
            }
            action("Prepayment Account")
            {
                Caption = 'Prepayment';
                RunObject = Page "Repayment Account List";
                ApplicationArea = All;
            }
            action(ActiveLoans)
            {
                Caption = 'Active Loans';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(<> 0));
            }
            action(ClosedAccounts)
            {
                Caption = 'Closed Accounts';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(0));
            }
            action(ClosedLoans)
            {
                Caption = 'Archived Accounts';
                RunObject = Page "Loans-Closed Account";
                ApplicationArea = All;

            }

            action("Request to Approve")
            {
                ApplicationArea = CostAccounting;
                RunObject = Page "Request to Approve";
                ToolTip = 'View Request to Approve.';
            }
            action("Approval Requests")
            {
                ApplicationArea = CostAccounting;
                RunObject = Page "Approval Requests";
                ToolTip = 'View approval requests.';
            }
            action("Posted Approval Entries")
            {
                ApplicationArea = CostAccounting;
                RunObject = Page "Posted Approval Entry";
                ToolTip = 'Posted Approval Requests.';
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
                    Caption = 'New Applications';
                    RunObject = Page "Loan Application List";
                    RunPageView = where("Approval Status" = filter(Open));
                    ApplicationArea = All;
                }
                action(PendingLoanApplications)
                {
                    Caption = 'Application-Pending';
                    RunObject = Page "Loan Application List";
                    RunPageView = where("Approval Status" = filter("Pending Approval"));
                    ApplicationArea = All;
                }
                action("Approved Application")
                {
                    Caption = 'Approved Application';
                    RunObject = Page "Loan Application List-Approved";
                    ApplicationArea = All;
                }
                action(DefferedApplication)
                {
                    Caption = 'Deffered Application';
                    RunObject = Page "Loan Application List";
                    RunPageView = where("Approval Status" = const(Deffered));
                    ApplicationArea = All;
                }
                action(Portal)
                {
                    Caption = 'Loan Application-Portal';
                    RunObject = Page "Loan List-Portal";
                    ApplicationArea = All;

                }

                action("CRM Application List")
                {
                    RunObject = Page "CRM Application List";
                    RunPageView = WHERE("Application Type" = CONST("Loan Application"));
                    ApplicationArea = All;
                }
            }
            group(Action16)
            {
                Caption = 'Loans';
                action(LoansListApp)
                {
                    RunObject = Page "Loan List";
                    Caption = 'Loans- Open';
                    RunPageView = where("Approval Status" = const(Open), "Loan Status" = filter(<> "Partial Payment"));
                    ApplicationArea = All;
                }
                action(LoansListPend)
                {
                    RunObject = Page "Loan List";
                    Caption = 'Loans- Pending';
                    RunPageView = where("Approval Status" = const("Pending Approval"), "Loan Status" = filter(<> "Partial Payment"));
                    ApplicationArea = All;
                }
                action(Loans)
                {
                    RunObject = Page "Loan List";
                    Caption = 'Disbursement List';
                    RunPageView = where("Approval Status" = const(Approved), "Mode of Disbursement" = filter("Full Disbursement"), "Application Type" = filter(Normal));
                    ApplicationArea = All;
                }
                action("Active Loans")
                {
                    Caption = 'Active Accounts';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0));
                }
                action("Partial Disbursed Loans")
                {
                    Caption = 'Partial Disbursed Accounts';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0), "Mode of Disbursement" = filter("Partial Disbursement"));
                }
                action("Closed Accounts")
                {
                    Caption = 'Closed Accounts';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(0));
                }
                action(LoanPerformance)
                {
                    Caption = 'Loan Performance';
                    RunObject = Page "Loan-Performance Indicator";
                    ApplicationArea = All;

                }

                action(CRBDataSheet)
                {
                    Caption = 'CRB Data Sheet';
                    RunObject = Page "CRB Data Sheet";
                    ApplicationArea = All;

                }
                action(AccruedInterest)
                {
                    Caption = 'Accrued Interest';
                    RunObject = Page "Interest Lines LookUp";
                    ApplicationArea = All;
                    Visible = false;

                }
            }
            group(ApprovedDocuments)
            {
                Caption = 'Approved Document';
            }
            group("Loan Batch")
            {
                Caption = 'Refunds';
                Visible = false;
                action("Disbursement List")
                {
                    RunObject = Page "Disbursement List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Posted Disbursement")
                {
                    RunObject = Page "Posted Disbursement List";
                    ApplicationArea = All;
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("Member Advise")
                {
                    Caption = 'Stop Order Sheet';
                    Visible = false;
                    RunObject = Page "Member Advise Analysis";
                    ApplicationArea = All;
                }
                action("StopOrder Advise")
                {
                    Caption = 'Stop Order Advise';
                    Visible = false;
                    RunObject = Page "Stop Order List";
                    ApplicationArea = All;
                }
                action(InterestHeaderList)
                {
                    Caption = 'Billing';
                    RunObject = Page "Interest Header List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("Defaulter Recovery")
                {
                    RunObject = Page "Recovery List";
                    RunPageView = where("Application Source" = const(Manual), "Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("Loan Restructure")
                {
                    RunObject = Page "Loan Restructure List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("Guarantor Subsitution")
                {
                    RunObject = Page "Guarantor Subsitution List";
                    ApplicationArea = All;
                    Caption = 'Record Substitution';
                    RunPageView = WHERE("Approval Status" = filter(Open | "Pending Approval"));
                }

                action("Accrued Interest")
                {
                    Caption = 'Accrued Interest';
                    RunObject = Page "Interest Lines LookUp";
                    Visible = false;
                    ApplicationArea = All;
                }
                action(RemittanceList)
                {
                    Caption = 'Remittance';
                    RunObject = Page "Remittance List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action(DefaulterRecovery)
                {
                    RunObject = Page "Recovery List";
                    Caption = 'Defaulter Recovery';
                    RunPageView = where("Application Source" = const(Manual), "Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action(DefaulterList)
                {
                    RunObject = Page "Loan Application List";
                    Caption = 'Application List';
                    RunPageView = where("Application Type" = filter(Defaulter), "Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action(DefaulterLoanList)
                {
                    RunObject = Page "Loan List";
                    Caption = 'Loan List';
                    RunPageView = where("Application Type" = filter(Defaulter), "Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action(DefaulterLoanListPosted)
                {
                    RunObject = Page "Loan List";
                    Caption = 'Active Defaulter Loan';
                    RunPageView = where("Application Type" = filter(Defaulter), "Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action(WithdrawalNotice)
                {
                    RunObject = Page "Member withdrawal Notice List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    Caption = 'Notice';
                }
                action(MembershipClosure)
                {
                    RunObject = Page "Membership Closure List";
                    Caption = 'Membership Closure';
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }

                action("Record Changes")
                {
                    RunObject = page "Mc. Account Changes";
                    ApplicationArea = All;
                    Caption = 'Record Changes';
                    RunPageView = WHERE("Approval Status" = filter(Open | "Pending Approval"));
                }

                action(Dividends)
                {
                    RunObject = page "Dividend Simulation Header";
                    ApplicationArea = All;
                }
                action(GuarantorRegister)
                {
                    Caption = 'Guarantor Register';
                    RunObject = Page "Guarantors & Security";
                    ApplicationArea = All;
                }

                action(GuarantorSharesRecovery)
                {
                    RunObject = Page "Loans Recovery Mngt.";
                    ApplicationArea = All;
                    Caption = 'Defaulted Recoveries';
                }
                action("Refund")
                {
                    RunObject = Page "Disbursement List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
            }

            group("Approved Documents")
            {
                Caption = 'Approved Document';

                action(AppInterestHeaderList)
                {
                    Caption = 'Billing';
                    RunObject = Page "Interest Header List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Approved Defaulter Recovery")
                {
                    Caption = 'Defaulter Recovery';
                    RunObject = Page "Recovery List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Approved Loan Restructure")
                {
                    Caption = 'Loan Restructure';
                    RunObject = Page "Loan Restructure List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Approved Guarantor Subsitution")
                {
                    RunObject = Page "Guarantor Subsitution List";
                    ApplicationArea = All;
                    Caption = 'Record Substitution';
                    RunPageView = where("Approval Status" = filter(Approved));
                }

                action(ApprovedRemittanceList)
                {
                    Caption = 'Remittance';
                    RunObject = Page "Remittance List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action(AprovedDefaulterRecovery)
                {
                    RunObject = Page "Recovery List";
                    Caption = 'Defaulter Recovery';
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action(ApprovedWithdrawalNotice)
                {
                    RunObject = Page "Member withdrawal Notice List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Approved));
                    Caption = 'Withdrawal Notices';
                }
                action(ApprovedMembershipClosure)
                {
                    RunObject = Page "Membership Closure List";
                    Caption = 'Membership Closure';
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }

                action("Approved Record Changes")
                {
                    RunObject = page "Mc. Account Changes";
                    ApplicationArea = All;
                    Caption = 'Record Changes';
                    RunPageView = where("Approval Status" = filter(Approved));
                }
                action("Approved Refund")
                {
                    Caption = 'Refunds';
                    RunObject = Page "Disbursement List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Approved Collateral Registration")
                {
                    Caption = 'Collateral Registration';
                    RunObject = Page "Collateral Register-List";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Approved Collateral Collection")
                {
                    Caption = 'Collateral Collection';
                    RunObject = Page "Collateral Collection";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
            }
            group(Collateral)
            {
                Caption = 'Collateral';

                action("Collateral Registration")
                {
                    Caption = 'Collateral Registration';
                    RunObject = Page "Collateral Register-List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("Collateral Collection")
                {
                    Caption = 'Collateral Collection';
                    RunObject = Page "Collateral Collection";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action(CollateralRegister)
                {
                    Caption = 'Collateral Register';
                    RunObject = Page "Registered Collateral";
                    ApplicationArea = All;
                }

            }
            group(Accounts)
            {
                Caption = 'Accounts';
                Visible = false;
                action("Membership Individuals")
                {
                    Caption = 'Individual';
                    RunObject = Page "Membership Individual List";
                    ApplicationArea = All;
                }
                action("Membership Groups")
                {
                    Caption = 'Group';
                    RunObject = Page "Member Group List";
                    ApplicationArea = All;
                }
                action("Account Banking")
                {
                    Caption = 'Banking';
                    RunObject = Page "Savings Account List";
                    ApplicationArea = All;
                }
                action("Account Credit")
                {
                    Caption = 'Credit';
                    RunObject = Page "Account Credit List";
                    ApplicationArea = All;
                }
                action("Loan Accounts")
                {
                    Caption = 'Loan Account';
                    RunObject = Page "Loan Account";
                    ApplicationArea = All;
                }
                action("Repayment Account")
                {
                    Caption = 'Prepayment';
                    RunObject = Page "Repayment Account List";
                    ApplicationArea = All;
                }
            }
            group(Archive)
            {
                Caption = 'Archive';
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
                action(PostedLoanApplication)
                {
                    Caption = 'Loan Application';
                    RunObject = Page "Loan Application Posted";
                    ApplicationArea = All;
                }
                action(RejectedApplication)
                {
                    Caption = 'Rejected Application';
                    RunObject = Page "Loan Application List";
                    RunPageView = where("Approval Status" = const(Rejected));
                    ApplicationArea = All;
                }

                action(ActivePartialLoans)
                {
                    Caption = 'Partial Loans';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0), "Mode of Disbursement" = filter("Partial Disbursement"));
                }
                action(PostedRemittanceList)
                {
                    Caption = 'Remittance';
                    RunObject = Page "Remittance List";
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action(PostedMembershipClosure)
                {
                    RunObject = Page "Membership Closure List";
                    Caption = 'Membership Closure';
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action("Refund-Posted")
                {
                    RunObject = Page "Disbursement List";
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action(Recovery)
                {
                    ApplicationArea = All;
                    RunObject = Page "Recovery List Posted";
                    RunPageView = where("Approval Status" = const(Posted), "Application Source" = const(Manual));
                    ToolTip = 'View Posted Applications';
                }
                action(Substitution)
                {
                    ApplicationArea = CostAccounting;
                    RunObject = Page "Approval Requests";
                    ToolTip = 'View Posted applications.';
                }
                action(CollateralRegisterDeffered)
                {
                    Caption = 'Deffered Application';
                    RunObject = Page "Registered Collateral";
                    RunPageView = where("Approval Status" = filter(Deffered | Rejected));
                    ApplicationArea = All;
                }
                action(PostedRejectedApplications)
                {
                    Caption = 'Bills';
                    RunObject = Page "Interest Posted";
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action("Posted/Rejected Application")
                {
                    Caption = 'Remittance';
                    Visible = false;
                    RunObject = Page "Remittance List";
                    RunPageView = where(Posted = const(true));
                    ApplicationArea = All;
                }
                action(PartialPosted)
                {
                    RunObject = Page "Partial Disbursement-Posted";
                    ApplicationArea = All;
                    Caption = 'Partial Disbursement';
                }

                action(GuarantorSubsitutionPosted)
                {
                    RunObject = Page "Guarantor Subsitution List";
                    ApplicationArea = All;
                    Caption = 'Substitution';
                    RunPageView = WHERE("Approval Status" = filter(Posted));
                }
                action(LoanChargesPosted)
                {
                    RunObject = Page "Loan Posted Charges";
                    ApplicationArea = All;
                    Caption = 'Loan Charges';

                }
                action(LoansTopupPosted)
                {
                    RunObject = Page "Loans Top Up Posted";
                    ApplicationArea = All;
                    Caption = 'Loans Topup';

                }
                action(Repaymentschedules)
                {
                    RunObject = Page "Loan Repayment Schedule";
                    ApplicationArea = All;
                    Caption = 'Repayment Schedules';

                }
                action("EFT Transfers-Posted")
                {
                    RunObject = Page "EFT Transfer List";
                    ApplicationArea = All;
                    Caption = 'EFT Transfer';
                    RunPageView = where("Approval Status" = filter(Transferred));
                }
                action(EFTFile)
                {
                    RunObject = Page "EFt File";
                    ApplicationArea = All;
                    Caption = 'EFT Files';
                }
                action("Posted/Rejected Applications")
                {
                    Caption = 'Interest Acrued';
                    RunObject = Page "Interest Posted";
                    ApplicationArea = All;
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
                        group("PreliminarySelf")
                        {
                            Caption = 'Preliminary Evaluation';

                        }
                        group("Technical EvaluationSelf")
                        {
                            Caption = 'Technical Evaluation';

                        }
                        group(FinanicalEvaluation)
                        {
                            Caption = 'Financial Evaluation';
                        }

                    }
                }
            }
        }
        area(creation)
        {

            action(LoanApplications)
            {
                Caption = 'Loan Application';
                RunObject = Page "Loan Application List";
                RunPageMode = Create;
                RunPageView = where("Approval Status" = filter(Open));
                ApplicationArea = All;
            }
            action(Remittance)
            {
                RunObject = Page "Remittance List";
                ApplicationArea = All;
                Visible = false;
                RunPageMode = Create;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"), Posted = const(false));
            }
            action("Defaulters Recovery")
            {
                RunObject = Page "Recovery List";
                RunPageMode = Create;
                RunPageView = where("Application Source" = const(Manual));
                ApplicationArea = All;
            }
            action(LoanRestructure)
            {
                RunObject = Page "Loan Restructure List";
                Caption = 'Loan Restructure';
                RunPageMode = Create;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }
        }
        area(Processing)
        {
            action(LoanCalculator)
            {
                RunObject = Page "Loan Calculator List";
                ApplicationArea = All;
                Caption = 'Loan Calculator';
            }
            action(LoansList)
            {
                RunObject = Page "Loan List";
                Caption = 'Disbursement List';
                RunPageView = where("Approval Status" = const(Approved), "Loan Status" = filter(<> "Partial Payment"));
                ApplicationArea = All;
            }
            action(LoansPartial)
            {
                RunObject = Page "Partial Schedule-Loans";
                Caption = 'Partial Schedule';
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval" | Approved));
                ApplicationArea = All;
            }

            action(PartialPaymentLoans)
            {
                RunObject = Page "Loan List-Partial";
                Caption = 'Partial Loans';
                ApplicationArea = All;
            }

            action(LoanPerformances)
            {
                Caption = 'Loan Performance';
                RunObject = Page "Loan-Performance Indicator";
                ApplicationArea = All;
            }
            action("CRB Data Sheet")
            {
                Caption = 'CRB Data Sheet';
                RunObject = Page "CRB Data Sheet";
                ApplicationArea = All;
            }
        }
    }
    var
}




