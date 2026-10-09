page 51105 "Recovery Mngt. Role Center"
{
    ApplicationArea = All;
    Caption = 'Collection Management', Comment = '{Dependency=Match,"ProfileDescription_COLLECTIONNGMANAGER"}';
    PageType = RoleCenter;

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
            action("Monthly Advice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Monthly Advice';
                Image = "Report";
                Visible = false;
                RunObject = Report "Member Advice Analysis";
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
                Caption = 'Loans Register';
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
                Caption = 'Insurance Report';
                Visible = false;
                Image = "Report";
                RunObject = Report "Insurance Report";
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
                Visible = false;
                RunObject = Report "EFT Bank Details";
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
            action(MembershipIndividual)
            {
                RunObject = Page "Membership Individual List";
                Caption = 'Member Register-Archived';
                RunPageView = where(Status = filter(Deceased | Withdrawn | Frozen | Closed));
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
                Caption = 'Fosa Account';
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
            action("Archived Account")
            {
                Caption = 'Archived Fosa Accounts';
                RunObject = Page "Accounts Banking-Archived";
                ApplicationArea = All;
            }
            action("Archived Credits")
            {
                Caption = 'Archived Bosa Accounts';
                RunObject = Page "Account Credit-Archived";
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
            }
            action("Posted Application")
            {
                ApplicationArea = All;
            }
            action("Posted Changes")
            {
                ApplicationArea = All;
            }
        }
        area(sections)
        {
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
            group("Loan Recovery")
            {
                action(LoanRecovery)
                {
                    RunObject = Page "Recovery List";
                    RunPageView = where("Application Source" = const(Manual), "Approval Status" = filter(Open));
                    ApplicationArea = All;
                    Caption = 'New Application';
                }
                action(ApplicationLoanRecovery)
                {
                    RunObject = Page "Recovery List";
                    RunPageView = where("Application Source" = const(Manual), "Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                    Caption = 'Pending Approval';
                }
                action(PendingLoanRecovery)
                {
                    RunObject = Page "Recovery List";
                    RunPageView = where("Application Source" = const(Manual), "Approval Status" = filter(Approved));
                    ApplicationArea = All;
                    Caption = 'Approved Application';
                }
                action("Loan Application List")
                {
                    RunObject = Page "Def. Loan List";
                    Caption = 'Defaulter List';
                    ApplicationArea = All;
                }
                action("Loan List Defaulter")
                {
                    RunObject = Page "Loan List";
                    Caption = 'Loan List';
                    RunPageView = where("Application Type" = filter(Defaulter));
                    ApplicationArea = All;
                }
            }
            group("Loan Restructure")
            {
                action("Open Restructure")
                {
                    RunObject = Page "Loan Restructure List";
                    Caption = 'New Application';
                    RunPageView = where("Approval Status" = filter(Open));
                    ApplicationArea = All;
                }
                action("Pending Restructure")
                {
                    RunObject = Page "Loan Restructure List";
                    Caption = 'Pending Application';
                    RunPageView = where("Approval Status" = filter("Pending Approval"));
                    ApplicationArea = All;
                }
                action("Approved Restructure")
                {
                    RunObject = Page "Loan Restructure List";
                    Caption = 'Approved Application';
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action("Loan List")
                {
                    RunObject = Page "Loan List";
                    Caption = 'Loan List';
                    RunPageView = where("Approval Status" = const(Approved),
                    "Mode of Disbursement" = filter("Full Disbursement"), "Application Type" = filter("Loan Restructure"));
                    ApplicationArea = All;
                }

                action("Deffered Restructure")
                {
                    RunObject = Page "Loan Restructure List";
                    Caption = 'Deffered Application';
                    RunPageView = where("Approval Status" = filter(Deffered));
                    ApplicationArea = All;
                }
                action("Rejected Restructure")
                {
                    RunObject = Page "Loan Restructure List";
                    Caption = 'Rejected Application';
                    RunPageView = where("Approval Status" = filter(Rejected));
                    ApplicationArea = All;
                }

            }
            group(Application)
            {
                Caption = 'Application';
                Image = Journals;
                Enabled = false;
                Visible = false;
                action("New Applications")
                {
                    Caption = 'New Applications';
                    RunObject = Page "Loan Application List";
                    RunPageView = where("Approval Status" = filter(Open));
                    Visible = false;
                    ApplicationArea = All;
                }
                action(PendingLoanApplications)
                {
                    Caption = 'Application-Pending';
                    RunObject = Page "Loan Application List";
                    Visible = false;
                    RunPageView = where("Approval Status" = filter("Pending Approval"));
                    ApplicationArea = All;
                }
                action("Approved Application")
                {
                    Caption = 'Approved Application';
                    Visible = false;
                    RunObject = Page "Loan Application List-Approved";
                    ApplicationArea = All;
                }
                action(DefferedApplication)
                {
                    Caption = 'Deffered Application';
                    Visible = false;
                    RunObject = Page "Loan Application List";
                    RunPageView = where("Approval Status" = const(Deffered));
                    ApplicationArea = All;
                }
                action(RejectedApplication)
                {
                    Caption = 'Rejected Application';
                    Visible = false;
                    RunObject = Page "Loan Application List";
                    RunPageView = where("Approval Status" = const(Rejected));
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

                action(Loans)
                {
                    RunObject = Page "Loan List";
                    Visible = false;
                    Caption = 'Full Disbursement';
                    RunPageView = where("Approval Status" = const(Approved), "Mode of Disbursement" = filter("Full Disbursement"));
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
                    Visible = false;
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
            group(AccountChanges)
            {
                Caption = 'Account Changes';
                Enabled = false;
                Visible = false;
                action("Record Changes")
                {
                    RunObject = page "Mc. Account Changes";
                    ApplicationArea = All;
                    Caption = 'Record Changes';
                    RunPageView = WHERE("Approval Status" = filter(Open | "Pending Approval"));
                }
                action("Record Changes-Approved")
                {
                    RunObject = page "Mc. Account Changes";
                    ApplicationArea = All;
                    Caption = 'Record Changes-Approved';
                    RunPageView = WHERE("Approval Status" = filter(Approved));
                }


            }
            group("Loan Batch")
            {
                Caption = 'Loan Batch';
                Enabled = false;
                Visible = false;
                action("Disbursement List")
                {
                    RunObject = Page "Disbursement List";
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
                Enabled = false;
                Caption = 'Periodic Activities';
                Visible = false;
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

                action("Remittance List")
                {
                    Caption = 'Remittance';
                    RunObject = Page "Remittance List";
                    RunPageView = where("Approval Status" = filter(Approved), Posted = const(false));
                    ApplicationArea = All;
                }
                action(ActivePartialLoans)
                {
                    Caption = 'Partial Loans';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0), "Mode of Disbursement" = filter("Partial Disbursement"));
                }
                action("EFT Transfers-Approved")
                {
                    RunObject = Page "EFT Transfer List";
                    ApplicationArea = All;
                    Caption = 'Approved EFT';
                    RunPageView = where("Approval Status" = filter(Approved));
                }
                action("EFT Transfers")
                {
                    RunObject = Page "EFT Transfer List";
                    ApplicationArea = All;
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                }
                action("EFT Transfers Untransferred")
                {
                    RunObject = Page "EFT Transfer List";
                    ApplicationArea = All;
                    Caption = 'Untransferred EFT';
                    RunPageView = where("Approval Status" = filter(Posted));
                }

                action("Defaulter Recovery")
                {
                    RunObject = Page "Recovery List";
                    RunPageView = where("Application Source" = const(Manual), "Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }
                action("AccountTransfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Transfer';
                    Image = NewSalesInvoice;
                    RunObject = Page "Account Transfer List";
                    RunPageMode = Create;
                }
                action("Guarantor Subsitution")
                {
                    RunObject = Page "Guarantor Subsitution List";
                    ApplicationArea = All;
                    Visible = false;
                    Caption = 'Record Substitution';
                    RunPageView = WHERE("Approval Status" = filter(Open | "Pending Approval"));
                }
                action(GuarantorSubsitutionApproved)
                {
                    RunObject = Page "Guarantor Subsitution List";
                    ApplicationArea = All;
                    Visible = false;
                    Caption = 'Record Substitution-Approved';
                    RunPageView = WHERE("Approval Status" = filter(Approved));
                }
                action(Dividends)
                {
                    RunObject = page "Dividend Simulation Header";
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Collateral)
            {
                Enabled = false;
                Visible = false;
                Caption = 'Collateral';
                action("New Account Applications")
                {
                    Caption = 'Registration';
                    RunObject = Page "Collateral Register-List";
                    RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                    ApplicationArea = All;
                }
                action("Collateral Register")
                {
                    Caption = 'Collateral Register';
                    RunObject = Page "Registered Collateral";
                    RunPageView = where("Approval Status" = filter(Approved));
                    ApplicationArea = All;
                }
                action(CollateralRegisterDeffered)
                {
                    Caption = 'Deffered Application';
                    RunObject = Page "Registered Collateral";
                    RunPageView = where("Approval Status" = filter(Deffered | Rejected));
                    ApplicationArea = All;
                }

                action("Guarantor Register")
                {
                    Caption = 'Guarantor Register';
                    RunObject = Page "Guarantors & Security";
                    ApplicationArea = All;
                }

            }
            group(Accounts)
            {
                Caption = 'Accounts';
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
            group("Account Changes")
            {
                Caption = 'Account Changes';
                Visible = false;
                action("Fields Change Setups")
                {
                    RunObject = Page "Fields Change Setups";
                    ApplicationArea = All;
                }
                action("New Application Change")
                {
                    Caption = 'New Application';
                    RunObject = Page "Member Change List";
                    ApplicationArea = All;
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
                Caption = 'Archive';
                action(PostedLoanApplication)
                {
                    Caption = 'Loan Application';
                    RunObject = Page "Loan Application Posted";
                    ApplicationArea = All;
                }
                action(Recovery)
                {
                    ApplicationArea = All;
                    RunObject = Page "Recovery List Posted";
                    RunPageView = where("Approval Status" = const(Posted), "Application Source" = const(Manual));
                    ToolTip = 'View Posted Applications';
                }
                action(PostedRestructure)
                {
                    RunObject = Page "Loan Restructure List";
                    Caption = 'Loan Restructure';
                    RunPageView = where("Approval Status" = filter(Posted));
                    ApplicationArea = All;
                }

                action(Substitution)
                {
                    ApplicationArea = CostAccounting;
                    RunObject = Page "Approval Requests";
                    ToolTip = 'View Posted applications.';
                }
                action(PostedRejectedApplications)
                {
                    Caption = 'Bills';
                    RunObject = Page "Interest Posted";
                    ApplicationArea = All;
                }
                action("Posted/Rejected Application")
                {
                    Caption = 'Remittance';
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
                    Visible = false;
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
                            Caption = 'Technical Evaluation';

                        }
                        group(FinanicalEvaluation)
                        {
                            Caption = 'Financial Evaluation';

                        }
                        group("PrequalificationOpeningSelf")
                        {
                            Caption = 'Prequalification Tender Opening';

                        }
                    }
                }
            }
        }
        area(creation)
        {
            action(Billing)
            {
                RunObject = Page "Interest Header List";
                ApplicationArea = All;
                Visible = false;
            }

            action(LoanApplications)
            {
                Caption = 'Loan Application';
                RunObject = Page "Loan Application List";
                Visible = false;
                RunPageView = where("Approval Status" = filter(Open));
                ApplicationArea = All;
            }
            action(LoanCalculator)
            {
                RunObject = Page "Loan Calculator List";
                ApplicationArea = All;
                Caption = 'Loan Calculator';
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
            action(NewRestructure)
            {
                RunObject = Page "Loan Restructure List";
                Caption = 'Loan Restructure';
                RunPageMode = Create;
                RunPageView = where("Approval Status" = filter(Open));
                ApplicationArea = All;
            }

            action("Guarantors Subsitution")
            {
                RunObject = Page "Guarantor Subsitution List";
                Visible = false;
                ApplicationArea = All;
            }
            action("Withdrawal Notices")
            {
                RunObject = Page "Member withdrawal Notice List";
                ApplicationArea = All;
                Visible = false;
            }
            action("Account Closure")
            {
                RunObject = Page "Membership Closure List";
                ApplicationArea = All;
                Visible = false;
            }
        }
        area(Processing)
        {
            action(NewApplications)
            {
                Caption = 'Loan Application';
                RunObject = Page "Loan Application List";
                RunPageView = where("Approval Status" = filter(Open));
                Visible = false;
                ApplicationArea = All;
            }
            action(PendingApplications)
            {
                Caption = 'Applications-Pending';
                RunObject = Page "Loan Application List";
                RunPageView = where("Approval Status" = filter("Pending Approval"));
                Visible = false;
                ApplicationArea = All;
            }
            action(ApprovedApplication)
            {
                Caption = 'Approved Application';
                RunObject = Page "Loan Application List-Approved";
                Visible = false;
                RunPageView = where("Approval Status" = filter(Approved));
                ApplicationArea = All;
            }
            action(LoansPendingApproval)
            {
                RunObject = Page "Loan List";
                Caption = 'Pending Approvals';
                Visible = false;
                RunPageView = where("Approval Status" = filter(<> Approved));
                ApplicationArea = All;
            }

            action(CRMApplicationList)
            {
                RunObject = Page "CRM Application List";
                Visible = false;
                RunPageView = WHERE("Application Type" = CONST("Loan Application"));
                ApplicationArea = All;
            }
            action(LoansList)
            {
                RunObject = Page "Loan List";
                Visible = false;
                Caption = 'Full Disbursement';
                RunPageView = where("Approval Status" = const(Approved), "Mode of Disbursement" = filter("Full Disbursement"));
                ApplicationArea = All;
            }
            action(LoansPartial)
            {
                RunObject = Page "Loan List";
                Visible = false;
                Caption = 'Partial Disbursement';
                RunPageView = where("Approval Status" = const(Approved), "Mode of Disbursement" = filter("Partial Disbursement"));
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
            action(LoanPerformances)
            {
                Caption = 'Loan Performance';
                RunObject = Page "Loan-Performance Indicator";
                ApplicationArea = All;

            }

            action("CRB Data Sheet")
            {
                Caption = 'CRB Data Sheet';
                Visible = false;
                RunObject = Page "CRB Data Sheet";
                ApplicationArea = All;

            }
            action("Accrued Interest")
            {
                Caption = 'Accrued Interest';
                Visible = false;
                RunObject = Page "Interest Lines LookUp";
                ApplicationArea = All;

            }
            action(InterestHeaderList)
            {
                Caption = 'Billing';

                RunObject = Page "Interest Header List";
                ApplicationArea = All;
                Visible = false;
            }
            action(RemittanceList)
            {
                Caption = 'Remittance';
                Visible = false;
                RunObject = Page "Remittance List";
                ApplicationArea = All;
            }
            action(DefaulterRecovery)
            {
                RunObject = Page "Recovery List";
                Caption = 'Defaulter Recovery';
                RunPageView = where("Application Source" = const(Manual));
                ApplicationArea = All;
            }
            action(GuarantorSubsitution)
            {
                RunObject = Page "Guarantor Subsitution List";
                ApplicationArea = All;
                Visible = false;
                Caption = 'Record Substitution';
                RunPageView = WHERE("Approval Status" = filter(Open | "Pending Approval"));
            }
            action(WithdrawalNotice)
            {
                RunObject = Page "Member withdrawal Notice List";
                ApplicationArea = All;
                Caption = 'Notice';
                Visible = false;
            }
            action(MembershipClosure)
            {
                RunObject = Page "Membership Closure List";
                Caption = 'Account Closure';
                ApplicationArea = All;
                Visible = false;
            }
            action(CheckoffAdvice)
            {
                RunObject = Page "Checkoff Advise Sheet";
                Caption = 'Checkoff Advise';
                Visible = false;
                ApplicationArea = All;
            }
            action(DividendsPosting)
            {
                RunObject = page "Dividend Simulation Header";
                Caption = 'Dividends';
                Visible = false;
                ApplicationArea = All;

            }
            action(InterestPosting)
            {
                RunObject = page "Account Interest List";
                Caption = 'Account Interest';
                Visible = false;
                ApplicationArea = All;

            }
            action(EndYearInterestPosting)
            {
                RunObject = page "Posted End Year Interest List";
                Caption = 'End Year Interest';
                ApplicationArea = All;
                Visible = false;
            }
            action("Collateral Registration")
            {
                Caption = 'Collateral Registration';
                Visible = false;
                RunObject = Page "Collateral Register-List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }
            action("Collateral Collection")
            {
                Caption = 'Collateral Collection';
                RunObject = Page "Collateral Collection";
                Visible = false;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }
            action(ApprovedCollateralCollection)
            {
                Caption = 'Collection-Approved';
                Visible = false;
                RunObject = Page "Collateral Collection";
                RunPageView = where("Approval Status" = filter(Approved));
                ApplicationArea = All;
            }

            action(CollateralRegister)
            {
                Caption = 'Collateral Register';
                Visible = false;
                RunObject = Page "Registered Collateral";
                ApplicationArea = All;
            }
            action(GuarantorRegister)
            {
                Caption = 'Guarantor Register';
                Visible = false;
                RunObject = Page "Guarantors & Security";
                ApplicationArea = All;
            }

            action(GuarantorSharesRecovery)
            {
                RunObject = Page "Loans Recovery Mngt.";
                ApplicationArea = All;
                Caption = 'Defaulted Recoveries';
            }

        }
    }
}
