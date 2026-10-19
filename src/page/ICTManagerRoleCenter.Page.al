page 50705 "ICT Manager Role Center"
{
    Caption = 'ICT Manager';
    PageType = RoleCenter;
    ApplicationArea = All;
    layout
    {
        area(rolecenter)
        {

            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
            }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        area(reporting)
        {
            action("ModF")
            {
                ApplicationArea = All;
                Caption = 'Mod. Mgt Validation';
                Image = Import;
                RunObject = report "Mod. Mgt Validation";
            }

            //Account Credit Update

            action("Account Credit Update")
            {
                ApplicationArea = All;
                Caption = 'Account Credit Update';
                Image = Import;
                RunObject = report "Account Credit Update";
            }
            action("Loan Mistmatch")
            {
                ApplicationArea = All;
                Caption = 'Loan Mismatch';
                Image = Import;
                RunObject = report "Loan Mistmatch";
            }

            action("Buffer Page")
            {
                ApplicationArea = All;
                Caption = 'Buffer Page';
                Image = Import;
                RunObject = page "Temp Data Card";
            }
            action("Export Account Credit")
            {
                ApplicationArea = All;
                Caption = 'Export Account Credit';
                Image = Import;
                RunObject = xmlport Importaccountcredit;
            }
            action("Export Account Banking")
            {
                ApplicationArea = All;
                Caption = 'Export Account Banking';
                Image = Import;
                RunObject = xmlport ImportBanking;
            }


             action("Mpesa Transactions")
            {
                ApplicationArea = All;
                Caption = ' Mpesa Transactions';
                Image = Import;
                RunObject = Page "Mpesa Transactions";
            }
             action("Keyword Setup")
            {
                ApplicationArea = All;
                Caption = 'Key Word Setup';
                Image = Import;
                RunObject = Page "Key Word Setup";
            }

            action("CreateAc")
            {
                ApplicationArea = All;
                Image = Report;
                Caption = 'Create Account- All';
                RunObject = report "Create Temp. A/c";
            }

            action("CreateAcSingle")
            {
                ApplicationArea = All;
                Image = Report;
                Caption = 'Create Account- Single';
                RunObject = report "Create Member Acc.";
            }
            action("Temp Data")
            {
                ApplicationArea = All;
                Caption = 'Import Data';
                Image = Import;
                RunObject = xmlport "Temp Data";
            }
            action("Temp Data Page")
            {
                ApplicationArea = All;
                Caption = 'Buffer Data';
                Image = Import;
                RunObject = page "Temp Data Card";
            }

            action(SendMemberEmail)
            {
                RunObject = Report "Send Member Statement";
                ApplicationArea = All;
                Image = "Report";
                Caption = 'Email Member Statement';
            }
            action(SendDivslipEmail)
            {
                RunObject = Report "Email Dividend Slip";
                ApplicationArea = All;
                Image = "Report";
                Caption = 'Email Dividend Slip';
            }

            action(Deletedata)
            {
                RunObject = Report "Data Deletion";
                ApplicationArea = All;
                Image = "Report";
                Visible = true;
                Caption = 'Data Deletion';
            }
            action(EntryDeletedata)
            {
                RunObject = Report "Entry Data Deletions";
                ApplicationArea = All;
                Image = "Report";
                Visible = True;
                Caption = 'Data Deletion With Entry Number';
            }
            action(ModifyTransactions)
            {
                RunObject = Report "Moves Transactions";
                ApplicationArea = All;
                Image = "Report";
                Visible = true;
                Caption = 'Moves Transactions';
            }
            action(ProcessFixedDeposit)
            {
                RunObject = Report "Process Fixed Deposit";
                ApplicationArea = All;
                Image = "Report";
                Caption = 'Process Fixed Deposit';
            }
            action("Process STO")
            {
                RunObject = Report "Post Standing Order";
                ApplicationArea = All;
                Image = "Report";
                Visible = false;
                Caption = 'Post Standing Order';

            }
            action("Check Clearance")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Check Clearance';
                Image = "Report";
                Visible = false;
                RunObject = Report "Process Cheque Clearance";
                ToolTip = 'Cheque Clearance';
            }
            action("Safe Custody Renewal")
            {
                ApplicationArea = Basic, Suite;
                Image = "Report";
                Visible = false;
                RunObject = Report "Process Safe Custody Renewal";
                ToolTip = 'Cheque Clearance';
            }
            action("Deposit Multiplier")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deposit Multiplier';
                Image = "Report";
                Visible = false;
                RunObject = Report "Existing Deposit Multiplier";

            }
            action(GenerateDormantAccount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dormant Account-Fosa';
                Image = "Report";
                RunObject = Report "Generate Dormant Account";
                ToolTip = 'Generate Dormant Account';
            }
            action(GenerateDormantCredAccount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dormant Account-Bosa';
                Image = "Report";
                RunObject = Report "Gen. Dormant Ac- Credit";
                ToolTip = 'Generate Dormant Account-Credit';
            }

            action(CreateMemberAccount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Member Account';
                Image = "Report";
                RunObject = Report "Create Member Acc.";
                ToolTip = 'Create Member Missing Account';
            }
        }
        area(embedding)
        {
            ToolTip = 'Set up users and cross-product values, such as number series and post codes.';
            action("Job Queue Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Queue Entries';
                RunObject = Page "Job Queue Entries";
                ToolTip = 'View or edit the tasks that are set up to run business processes automatically at user-defined intervals.';
            }
            action("User Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'User Setup';
                Image = UserSetup;
                RunObject = Page "User Setup List";
                ToolTip = 'Set up users and define their permissions.';
            }
            action("Posted Approval Requests")
            {
                ApplicationArea = Basic, Suite;
                Image = UserSetup;
                RunObject = Page "Posted App. Entry";
                ToolTip = 'Set up users and define their permissions.';
            }
            action("Approval Requests")
            {
                ApplicationArea = Basic, Suite;
                Image = UserSetup;
                Caption = 'Approval Requests';
                RunObject = Page "Approval Requests";
                ToolTip = 'Set up users and define their permissions.';
            }
            action("Cases - Dynamics 365 Customer Service")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cases - Dynamics 365 Customer Service';
                RunObject = Page "CRM Case List";
                ToolTip = 'View a list of Microsoft Dynamics 365 Customer Service cases.';
                Visible = false;
            }
            action("No. Series")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'No. Series';
                RunObject = Page "No. Series";
                ToolTip = 'Set up the number series from which a new number is automatically assigned to new cards and documents, such as item cards and sales invoices.';
            }
            action("Approval User Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Approval User Setup';
                RunObject = Page "Approval User Setup";
                ToolTip = 'View or edit information about workflow users who are involved in approval processes, such as approval amount limits for specific types of requests and substitute approvers to whom approval requests are delegated when the original approver is absent.';
            }
            action(Profiles)
            {
                ApplicationArea = All;
                Caption = 'Profiles(Roles)';
                RunObject = page "Profile List";
            }
            action("User Settings")
            {
                ApplicationArea = All;
                Caption = 'User Settings';
                RunObject = page "User Settings List";
            }

            action("Permission Sets")
            {
                ApplicationArea = All;
                Caption = 'Permission Sets';
                RunObject = page "Permission Sets";
            }
            action("Workflow User Groups")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Workflow User Groups';
                Image = Users;
                RunObject = Page "Workflow User Groups";
                ToolTip = 'View or edit the list of users that take part in workflows and which workflow user groups they belong to.';
            }
            action(Action57)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Workflows';
                Image = ApprovalSetup;
                RunObject = Page Workflows;
                ToolTip = 'Set up or enable workflows that connect business-process tasks performed by different users. System tasks, such as automatic posting, can be included as steps in workflows, preceded or followed by user tasks. Requesting and granting approval to create new records are typical workflow steps.';
            }

            action("Base Calendar List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Base Calendar List';
                RunObject = Page "Base Calendar List";
                ToolTip = 'View the list of calendars that exist for your company and your business partners to define the agreed working days.';
            }
            action("Post Codes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Codes';
                RunObject = Page "Post Codes";
                ToolTip = 'Set up the post codes of cities where your business partners are located.';
            }
            action(ICTSetup)
            {
                Caption = 'ICT Setup';
                ApplicationArea = All;
                RunObject = Page "ICT Setup";
            }
            action("Reason Codes")
            {
                ApplicationArea = Suite;
                Caption = 'Reason Codes';
                Visible = false;
                RunObject = Page "Reason Codes";
                ToolTip = 'View or set up codes that specify reasons why entries were created, such as Return, to specify why a purchase credit memo was posted.';
            }
            action("Extended Text")
            {
                ApplicationArea = All;
                Caption = 'Extended Text';
                Visible = false;
                RunObject = Page "Extended Text List";
                ToolTip = 'View or edit additional text for the descriptions of items. Extended text can be inserted under the Description field on document lines for the item.';
            }
            action("Password History")
            {
                ApplicationArea = All;
                Caption = 'Password History Log';
                Visible = true;
                RunObject = Page "Password History Log";
                ToolTip = 'View  Password History';
            }
        }
        area(sections)
        {
            group(DataTemplatesList)
            {
                Caption = 'Posting Accounts';

                action(BankingListMngt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Operational Account';
                    RunObject = page "Account List Bnk. Mngt.";
                    ToolTip = 'Specify Banking Posting Account.';
                }
                action(AlternateChannel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Channel Accounts';
                    RunObject = page "Alt. Channels";
                    ToolTip = 'Specify Banking Posting Account.';

                }
                action(CustomerListCredMngt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Credit Account';
                    RunObject = page "Customer List Cred. Mngt.";
                    ToolTip = 'Specify Credit Posting Accounts.';

                }
                action("Posted Credit Entry")
                {
                    ApplicationArea = Basic, Suite;

                    Visible = false;
                    RunObject = Page "Posted Credit Entry";
                    ToolTip = 'View or edit template that are being used for data migration.';
                }
                action(CustomelistLoanMngt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Loan Account';
                    RunObject = page "Customer List Loan Mngt.";
                    ToolTip = 'Specify Loan Account Posting.';
                }
            }
            group(Loans)
            {
                action(ActiveLoans)
                {
                    Caption = 'Active Loans';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(<> 0));
                }
                action(ClosedLoans)
                {
                    Caption = 'Closed Account';
                    RunObject = Page "Loans List Posted";
                    ApplicationArea = All;
                    RunPageView = where("Outstanding Balance" = filter(0));
                }
                action(ClosedAccounts)
                {
                    Caption = 'Archived Accounts';
                    RunObject = Page "Loans-Closed Account";
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
                action(loanaccount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Loan Account';
                    RunObject = page "Loan Account";
                    ToolTip = 'Specify Credit Posting Accounts.';

                }

            }
            group("Member Accounts")
            {
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
                    Caption = 'Operational Account';
                    RunObject = Page "Savings Account List";
                    ApplicationArea = All;
                }
                action("Account Credit")
                {
                    Caption = 'Credit Account';
                    RunObject = Page "Account Credit List";
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
                action("Loan Accounts")
                {
                    Caption = 'Loan Account';
                    RunObject = Page "Loan Account";
                    ApplicationArea = All;
                }
                action("Repayment Account")
                {
                    Caption = 'Repayment Account';
                    RunObject = Page "Repayment Account List";
                    ApplicationArea = All;
                }
            }
            group("Job Queue")
            {
                Caption = 'Job Queue';
                Image = ExecuteBatch;
                ToolTip = 'Specify how reports, batch jobs, and codeunits are run.';
                action(JobQueue_JobQueueEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Queue Entries';
                    RunObject = Page "Job Queue Entries";
                    ToolTip = 'View or edit the tasks that are set up to run business processes automatically at user-defined intervals.';
                }
                action("Job Queue Category List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Queue Category List';
                    RunObject = Page "Job Queue Category List";
                    ToolTip = 'View or edit the task categories that are set up to run business processes automatically at user-defined intervals.';
                }
                action("Job Queue Log Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Queue Log Entries';
                    RunObject = Page "Job Queue Log Entries";
                    ToolTip = 'View information for job queue entries that have run or have not run due to errors including job queue entries that have the status On Hold.';
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                ToolTip = 'Set up workflow and approval users, and create workflows that govern how the users interact in processes.';
                action(Workflows)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Workflows';
                    Image = ApprovalSetup;
                    RunObject = Page Workflows;
                    ToolTip = 'Set up or enable workflows that connect business-process tasks performed by different users. System tasks, such as automatic posting, can be included as steps in workflows, preceded or followed by user tasks. Requesting and granting approval to create new records are typical workflow steps.';
                }
                action("Workflow Templates")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Workflow Templates';
                    Image = Setup;
                    RunObject = Page "Workflow Templates";
                    ToolTip = 'View the list of workflow templates that exist in the standard version of Business Central for supported scenarios. The codes for workflow templates that are added by Microsoft are prefixed with MS-. You cannot modify a workflow template, but you use it to create a workflow.';
                }
                action(ApprovalUserSetup)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approval User Setup';
                    RunObject = Page "Approval User Setup";
                    ToolTip = 'View or edit information about workflow users who are involved in approval processes, such as approval amount limits for specific types of requests and substitute approvers to whom approval requests are delegated when the original approver is absent.';
                }
                action(WorkflowUserGroups)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Workflow User Groups';
                    Image = Users;
                    RunObject = Page "Workflow User Groups";
                    ToolTip = 'View or edit the list of users that take part in workflows and which workflow user groups they belong to.';
                }
                action(OfficeUserGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Office Group';
                    RunObject = Page "Office User Group";
                }
            }
            group(WorkflowTemplate)
            {
                Caption = 'Workflow Template';
                Image = Intrastat;
                Visible = true;
                ToolTip = 'Set up Intrastat reporting values, such as tariff numbers.';

                action("Approval Setup")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Approval Setup';
                    RunObject = Page "Approval Setup";
                    ToolTip = 'View or edit the list of tariff numbers for item that your company buys and sells in the EU. The numbers are used to report Intrastat. The tax and customs authorities publish tariff numbers, which are eight-digit item codes, for a large number of products.';
                }
                action("Approval Template")
                {
                    ApplicationArea = All;
                    Caption = 'Approval Template';
                    RunObject = Page "Approval Templates";
                    ToolTip = 'View or edit the list of tariff numbers for item that your company buys and sells in the EU. The numbers are used to report Intrastat. The tax and customs authorities publish tariff numbers, which are eight-digit item codes, for a large number of products.';
                }
                action("Office Group")
                {
                    ApplicationArea = All;
                    Caption = 'Office Group';
                    RunObject = Page "Office User Group";
                }

                action("Approval Request Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Approval Request Entries';
                    RunObject = Page "Request to Approve";
                    ToolTip = 'View or edit the list of tariff numbers for item large number of products.';
                }
                action("Posted Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Approval Entries';
                    RunObject = Page "Posted Approval Entry";
                    ToolTip = 'View or edit the list of tariff numbers for item large number of products.';
                }
            }
            group("Finance Management")
            {
                Caption = 'Finance Management';

                group("Group")
                {
                    Caption = 'General Ledger';

                    action("Chart of Accounts")
                    {
                        ApplicationArea = All;
                        Caption = 'Chart of Accounts';
                        RunObject = page "Chart of Accounts";
                        ToolTip = 'Executes the Chart of Accounts action';
                    }
                    group("G/L Budgets")
                    {
                        Caption = 'Budgets';

                        action("Budgets")
                        {
                            ApplicationArea = Suite;
                            Caption = 'G/L Budgets';
                            RunObject = page "G/L Budget Names";
                            ToolTip = 'Executes the G/L Budgets action';
                        }
                    }
                    action("Account Schedules")
                    {
                        ApplicationArea = All;
                        Caption = 'Account Schedules';
                        RunObject = page "Account Schedule Names";
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
                        }
                        action("VAT Returns")
                        {
                            ApplicationArea = All;
                            Caption = 'VAT Returns';
                            RunObject = page "VAT Report List";
                            ToolTip = 'Executes the VAT Returns action';
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
                            }
                            action("VAT Register")
                            {
                                ApplicationArea = All;
                                Caption = 'VAT Register';
                                RunObject = report "VAT Register";
                                ToolTip = 'Executes the VAT Register action';
                            }
                            action("VAT Registration No. Check")
                            {
                                ApplicationArea = All;
                                Caption = 'Batch VAT Registration No. Check';
                                RunObject = report "VAT Registration No. Check";
                                ToolTip = 'Executes the Batch VAT Registration No. Check action';
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
                            }
                            action("VAT- VIES Declaration Disk")
                            {
                                ApplicationArea = All;
                                Caption = 'VAT- VIES Declaration Disk...';
                                RunObject = report "VAT- VIES Declaration Disk";
                                ToolTip = 'Executes the VAT- VIES Declaration Disk... action';
                            }
                            action("Day Book VAT Entry")
                            {
                                ApplicationArea = All;
                                Caption = 'Day Book VAT Entry';
                                RunObject = report "Day Book VAT Entry";
                                ToolTip = 'Executes the Day Book VAT Entry action';
                            }
                            action("Day Book Cust. Ledger Entry")
                            {
                                ApplicationArea = All;
                                Caption = 'Day Book Cust. Ledger Entry';
                                RunObject = report "Day Book Cust. Ledger Entry";
                                ToolTip = 'Executes the Day Book Cust. Ledger Entry action';
                            }
                            action("Day Book Vendor Ledger Entry")
                            {
                                ApplicationArea = All;
                                Caption = 'Day Book Vendor Ledger Entry';
                                RunObject = report "Day Book Vendor Ledger Entry";
                                ToolTip = 'Executes the Day Book Vendor Ledger Entry action';
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
                        }
                        action("Inbox Transactions")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'Intercompany Inbox Transactions';
                            RunObject = page "IC Inbox Transactions";
                            ToolTip = 'Executes the Intercompany Inbox Transactions action';
                        }
                        action("Outbox Transactions")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'Intercompany Outbox Transactions';
                            RunObject = page "IC Outbox Transactions";
                            ToolTip = 'Executes the Intercompany Outbox Transactions action';
                        }
                        action("Handled Inbox Transactions")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'Handled Intercompany Inbox Transactions';
                            RunObject = page "Handled IC Inbox Transactions";
                            ToolTip = 'Executes the Handled Intercompany Inbox Transactions action';
                        }
                        action("Handled Outbox Transactions")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'Handled Intercompany Outbox Transactions';
                            RunObject = page "Handled IC Outbox Transactions";
                            ToolTip = 'Executes the Handled Intercompany Outbox Transactions action';
                        }
                        action("Intercompany Transactions")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'IC Transaction';
                            RunObject = report "IC Transactions";
                            ToolTip = 'Executes the IC Transaction action';
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
                        }
                        action("Export Consolidation")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Export Consolidation...';
                            RunObject = report "Export Consolidation";
                            ToolTip = 'Executes the Export Consolidation... action';
                        }
                        action("G/L Consolidation Eliminations")
                        {
                            ApplicationArea = Suite;
                            Caption = 'G/L Consolidation Eliminations';
                            RunObject = report "G/L Consolidation Eliminations";
                            ToolTip = 'Executes the G/L Consolidation Eliminations action';
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
                        action("General Journals2")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'Intercompany General Journal';
                            RunObject = page "IC General Journal";
                            ToolTip = 'Executes the Intercompany General Journal action';
                        }
                    }
                    group("Group6")
                    {
                        Caption = 'Register/Entries';

                        action("G/L Registers")
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
                        action("General Ledger Entries")
                        {
                            ApplicationArea = All;
                            Caption = 'General Ledger Entries';
                            RunObject = page "General Ledger Entries";
                            ToolTip = 'Executes the General Ledger Entries action';
                        }
                        action("G/L Budget Entries")
                        {
                            ApplicationArea = Suite;
                            Caption = 'G/L Budget Entries';
                            RunObject = page "G/L Budget Entries";
                            ToolTip = 'Executes the G/L Budget Entries action';
                        }
                        action("VAT Entries")
                        {
                            ApplicationArea = All;
                            Caption = 'VAT Entries';
                            RunObject = page "VAT Entries";
                            ToolTip = 'Executes the VAT Entries action';
                        }
                        action("Analysis View Entries")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Analysis View Entries';
                            RunObject = page "Analysis View Entries";
                            ToolTip = 'Executes the Analysis View Entries action';
                        }
                        action("Analysis View Budget Entries")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Analysis View Budget Entries';
                            RunObject = page "Analysis View Budget Entries";
                            ToolTip = 'Executes the Analysis View Budget Entries action';
                        }
                        action("Item Budget Entries")
                        {
                            ApplicationArea = ItemBudget;
                            Caption = 'Item Budget Entries';
                            RunObject = page "Item Budget Entries";
                            ToolTip = 'Executes the Item Budget Entries action';
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
                        Caption = 'Setup';

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

                    action("Bank Accounts")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Accounts';
                        RunObject = page "Bank Account List";
                        ToolTip = 'Executes the Bank Accounts action';
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
                            RunObject = page "Bank Acc. Reconciliation List";
                            ToolTip = 'Executes the Bank Account Reconciliations action';
                        }
                        action("Posted Payment Reconciliations")
                        {
                            ApplicationArea = All;
                            Caption = 'Posted Payment Reconciliations';
                            RunObject = page "Posted Payment Reconciliations";
                            ToolTip = 'Executes the Posted Payment Reconciliations action';
                        }
                        action("Payment Reconciliation Journals")
                        {
                            ApplicationArea = All;
                            Caption = 'Payment Reconciliation Journals';
                            RunObject = page "Pmt. Reconciliation Journals";
                            ToolTip = 'Executes the Payment Reconciliation Journals action';
                        }
                    }
                    group("Group16")
                    {
                        Caption = 'Journals';

                        action("Cash Receipt Journal")
                        {
                            ApplicationArea = All;
                            Caption = 'Cash Receipt Journals';
                            RunObject = page "Cash Receipt Journal";
                            ToolTip = 'Executes the Cash Receipt Journals action';
                        }
                        action("Payment Journals")
                        {
                            ApplicationArea = All;
                            Caption = 'Payment Journals';
                            RunObject = page "Payment Journal";
                            ToolTip = 'Executes the Payment Journals action';
                        }
                        action("Payment Reconciliation Journals1")
                        {
                            ApplicationArea = All;
                            Caption = 'Payment Reconciliation Journals';
                            RunObject = page "Pmt. Reconciliation Journals";
                            ToolTip = 'Executes the Payment Reconciliation Journals action';
                        }
                    }
                    group("Group17")
                    {
                        Caption = 'Ledger Entries';

                        action("Bank Account Ledger Entries")
                        {
                            ApplicationArea = All;
                            Caption = 'Bank Account Ledger Entries';
                            RunObject = page "Bank Account Ledger Entries";
                            ToolTip = 'Executes the Bank Account Ledger Entries action';
                        }
                        action("Check Ledger Entries")
                        {
                            ApplicationArea = All;
                            Caption = 'Check Ledger Entries';
                            RunObject = page "Check Ledger Entries";
                            ToolTip = 'Executes the Check Ledger Entries action';
                        }
                        action("Cash Flow Ledger Entries1")
                        {
                            ApplicationArea = All;
                            Caption = 'Cash Flow Ledger Entries';
                            RunObject = page "Cash Flow Forecast Entries";
                            ToolTip = 'Executes the Cash Flow Ledger Entries action';
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
                        action("Report Selection - Cash Flow1")
                        {
                            ApplicationArea = All;
                            Caption = 'Cash Flow Report Selections';
                            RunObject = page "Report Selection - Cash Flow";
                            ToolTip = 'Executes the Cash Flow Report Selections action';
                        }
                        action("Report Selection - Bank Acc.")
                        {
                            Caption = 'Report Selections Bank Account';
                            RunObject = page "Report Selection - Bank Acc.";
                            ApplicationArea = All;
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
                group("Group20")
                {
                    Caption = 'Cost Accounting';

                    action("Chart of Cost Centers")
                    {
                        ApplicationArea = CostAccounting;
                        Caption = 'Chart of Cost Centers';
                        RunObject = page "Chart of Cost Centers";
                        ToolTip = 'Executes the Chart of Cost Centers action';
                    }
                    action("Chart of Cost Objects")
                    {
                        ApplicationArea = CostAccounting;
                        Caption = 'Chart of Cost Objects';
                        RunObject = page "Chart of Cost Objects";
                        ToolTip = 'Executes the Chart of Cost Objects action';
                    }
                    action("Chart of Cost Types")
                    {
                        ApplicationArea = CostAccounting;
                        Caption = 'Chart of Cost Types';
                        RunObject = page "Chart of Cost Types";
                        ToolTip = 'Executes the Chart of Cost Types action';
                    }
                    action("Allocations")
                    {
                        ApplicationArea = CostAccounting;
                        Caption = 'Cost Allocations';
                        RunObject = page "Cost Allocation Sources";
                        ToolTip = 'Executes the Cost Allocations action';
                    }
                    action("Cost Budgets")
                    {
                        ApplicationArea = CostAccounting;
                        Caption = 'Cost Budgets';
                        RunObject = page "Cost Budget Names";
                        ToolTip = 'Executes the Cost Budgets action';
                    }
                    action("Cost Journal")
                    {
                        ApplicationArea = CostAccounting;
                        Caption = 'Cost Journals';
                        RunObject = page "Cost Journal";
                        ToolTip = 'Executes the Cost Journals action';
                    }
                    group("Group21")
                    {
                        Caption = 'Registers';

                        action("Registers")
                        {
                            ApplicationArea = CostAccounting;
                            Caption = 'Cost Registers';
                            RunObject = page "Cost Registers";
                            ToolTip = 'Executes the Cost Registers action';
                        }
                        action("Cost Budget Registers")
                        {
                            ApplicationArea = CostAccounting;
                            Caption = 'Cost Budget Registers';
                            RunObject = page "Cost Budget Registers";
                            ToolTip = 'Executes the Cost Budget Registers action';
                        }
                    }
                    group("Group22")
                    {
                        Caption = 'Reports';

                        group("Group23")
                        {
                            Caption = 'Setup Information';

                            action("Allocations1")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Allocations';
                                RunObject = report "Cost Allocations";
                                ToolTip = 'Executes the Cost Allocations action';
                            }
                        }
                        group("Group24")
                        {
                            Caption = 'Entries';

                            action("Cost Journal1")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Acctg. Journal';
                                RunObject = report "Cost Acctg. Journal";
                                ToolTip = 'Executes the Cost Acctg. Journal action';
                            }
                            action("Account Details")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Types Details';
                                RunObject = report "Cost Types Details";
                                ToolTip = 'Executes the Cost Types Details action';
                            }
                        }
                        group("Group25")
                        {
                            Caption = 'Cost & Revenue';

                            action("P/L Statement")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Acctg. Statement';
                                RunObject = report "Cost Acctg. Statement";
                                ToolTip = 'Executes the Cost Acctg. Statement action';
                            }
                            action("P/L Statement per Period")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Acctg. Stmt. per Period';
                                RunObject = report "Cost Acctg. Stmt. per Period";
                                ToolTip = 'Executes the Cost Acctg. Stmt. per Period action';
                            }
                            action("Analysis")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Acctg. Analysis';
                                RunObject = report "Cost Acctg. Analysis";
                                ToolTip = 'Executes the Cost Acctg. Analysis action';
                            }
                        }
                        group("Group26")
                        {
                            Caption = 'Cost Budget';

                            action("P/L Statement with Budget")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Acctg. Statement/Budget';
                                RunObject = report "Cost Acctg. Statement/Budget";
                                ToolTip = 'Executes the Cost Acctg. Statement/Budget action';
                            }
                            action("Cost Center")
                            {
                                ApplicationArea = CostAccounting;
                                Caption = 'Cost Acctg. Balance/Budget';
                                RunObject = report "Cost Acctg. Balance/Budget";
                                ToolTip = 'Executes the Cost Acctg. Balance/Budget action';
                            }
                        }
                    }
                    group("Group27")
                    {
                        Caption = 'Setup';

                        action("Cost Accounting Setup")
                        {
                            ApplicationArea = CostAccounting;
                            Caption = 'Cost Accounting Setup';
                            RunObject = page "Cost Accounting Setup";
                            ToolTip = 'Executes the Cost Accounting Setup action';
                        }
                        action("Cost Journal Templates")
                        {
                            Caption = 'Cost Journal Templates';
                            RunObject = page "Cost Journal Templates";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Cost Journal Templates action';
                        }
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
                        }
                        action("Combined Return Receipts")
                        {
                            ApplicationArea = SalesReturnOrder, PurchReturnOrder;
                            Caption = 'Combine Return Receipts...';
                            RunObject = report "Combine Return Receipts";
                            ToolTip = 'Executes the Combine Return Receipts... action';
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
                        }
                        action("Issued Reminders")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Issued Reminders';
                            RunObject = page "Issued Reminder List";
                            ToolTip = 'Executes the Issued Reminders action';
                        }
                        action("Finance Charge Memos")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Finance Charge Memos';
                            RunObject = page "Finance Charge Memo List";
                            ToolTip = 'Executes the Finance Charge Memos action';
                        }
                        action("Issued Finance Charge Memos")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Issued Finance Charge Memos';
                            RunObject = page "Issued Fin. Charge Memo List";
                            ToolTip = 'Executes the Issued Finance Charge Memos action';
                        }
                    }
                    group("Group31")
                    {
                        Caption = 'Journals';

                        action("Journals")
                        {
                            ApplicationArea = All;
                            Caption = 'Sales Journals';
                            RunObject = page "Sales Journal";
                            ToolTip = 'Executes the Sales Journals action';
                        }
                        action("Cash Receipt Journal1")
                        {
                            ApplicationArea = All;
                            Caption = 'Cash Receipt Journals';
                            RunObject = page "Cash Receipt Journal";
                            ToolTip = 'Executes the Cash Receipt Journals action';
                        }
                    }
                    group("Group32")
                    {
                        Caption = 'Posted Documents';

                        action("Posted Invoices")
                        {
                            ApplicationArea = All;
                            Caption = 'Posted Sales Invoices';
                            RunObject = page "Posted Sales Invoices";
                            ToolTip = 'Executes the Posted Sales Invoices action';
                        }
                        action("Posted Sales Shipments")
                        {
                            ApplicationArea = All;
                            Caption = 'Posted Sales Shipments';
                            RunObject = page "Posted Sales Shipments";
                            ToolTip = 'Executes the Posted Sales Shipments action';
                        }
                        action("Posted Credit Memos")
                        {
                            ApplicationArea = All;
                            Caption = 'Posted Sales Credit Memos';
                            RunObject = page "Posted Sales Credit Memos";
                            ToolTip = 'Executes the Posted Sales Credit Memos action';
                        }
                        action("Posted Return Receipts")
                        {
                            ApplicationArea = SalesReturnOrder;
                            Caption = 'Posted Return Receipts';
                            RunObject = page "Posted Return Receipts";
                            ToolTip = 'Executes the Posted Return Receipts action';
                        }
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
                        }
                        action("Detailed Cust. Ledg. Entries")
                        {
                            ApplicationArea = All;
                            Caption = 'Detailed Customer Ledger Entries';
                            RunObject = page "Detailed Cust. Ledg. Entries";
                            ToolTip = 'Executes the Detailed Customer Ledger Entries action';
                        }
                    }
                    group(CustomerSetup)
                    {
                        Caption = 'Customer Setup';

                        action(CustomerTemplate)
                        {
                            Caption = 'Customer Templates';
                            ApplicationArea = All;
                            RunObject = page "Customer Templ. List";
                            ToolTip = 'Executes the Customer Templates action';
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
                        }
                        action("Customer/Item Sales")
                        {
                            ApplicationArea = All;
                            Caption = 'Customer/Item Sales';
                            RunObject = report "Customer/Item Sales";
                            ToolTip = 'Executes the Customer/Item Sales action';
                        }
                        action("Salesperson - Sales Statistics")
                        {
                            ApplicationArea = All;
                            Caption = 'Salesperson Sales Statistics';
                            RunObject = report "Salesperson - Sales Statistics";
                            ToolTip = 'Executes the Salesperson Sales Statistics action';
                        }
                        action("Salesperson - Commission")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Salesperson Commission';
                            RunObject = report "Salesperson - Commission";
                            ToolTip = 'Executes the Salesperson Commission action';
                        }
                        action("Customer - Sales List")
                        {
                            ApplicationArea = All;
                            Caption = 'Customer - Sales List';
                            RunObject = report "Customer - Sales List";
                            ToolTip = 'Executes the Customer - Sales List action';
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
                            Caption = 'Report Selections Reminder/Fin. Charge';
                            RunObject = page "Report Selection - Reminder";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Report Selections Reminder/Fin. Charge action';
                        }
                        action("Reminder Terms")
                        {
                            ApplicationArea = All;
                            Caption = 'Reminder Terms';
                            RunObject = page "Reminder Terms";
                            ToolTip = 'Executes the Reminder Terms action';
                        }
                        action("Finance Charge Terms")
                        {
                            ApplicationArea = All;
                            Caption = 'Finance Charge Terms';
                            RunObject = page "Finance Charge Terms";
                            ToolTip = 'Executes the Finance Charge Terms action';
                        }
                    }
                }
                group("Group36")
                {
                    Caption = 'Payables';

                    action("Vendors")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendors';
                        RunObject = page "Vendor List";
                        ToolTip = 'Executes the Vendors action';
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
                    }
                    group("Group37")
                    {
                        Caption = 'Journals';

                        action("Purchase Journals")
                        {
                            ApplicationArea = All;
                            Caption = 'Purchase Journals';
                            RunObject = page "Purchase Journal";
                            ToolTip = 'Executes the Purchase Journals action';
                        }
                        action("Payment Journals1")
                        {
                            ApplicationArea = All;
                            Caption = 'Payment Journals';
                            RunObject = page "Payment Journal";
                            ToolTip = 'Executes the Payment Journals action';
                        }
                    }
                    group("Group38")
                    {
                        Caption = 'Posted Documents';

                        action("Posted Credit Memos1")
                        {
                            ApplicationArea = All;
                            Caption = 'Posted Purchase Credit Memos';
                            RunObject = page "Posted Purchase Credit Memos";
                            ToolTip = 'Executes the Posted Purchase Credit Memos action';
                        }
                        action("Posted Purchase Invoices")
                        {
                            ApplicationArea = All;
                            Caption = 'Posted Purchase Invoices';
                            RunObject = page "Posted Purchase Invoices";
                            ToolTip = 'Executes the Posted Purchase Invoices action';
                        }
                        action("Posted Purchase Receipts")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Posted Purchase Receipts';
                            RunObject = page "Posted Purchase Receipts";
                            ToolTip = 'Executes the Posted Purchase Receipts action';
                        }
                        action("Posted Return Shipments")
                        {
                            ApplicationArea = PurchReturnOrder;
                            Caption = 'Posted Purchase Return Shipments';
                            RunObject = page "Posted Return Shipments";
                            ToolTip = 'Executes the Posted Purchase Return Shipments action';
                        }
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
                        }
                        action("Employee Ledger Entries")
                        {
                            ApplicationArea = BasicHR;
                            Caption = 'Employee Ledger Entries';
                            RunObject = page "Employee Ledger Entries";
                            ToolTip = 'Executes the Employee Ledger Entries action';
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

                    action("Fixed Assets")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Fixed Assets';
                        RunObject = page "Fixed Asset List";
                        ToolTip = 'Executes the Fixed Assets action';
                    }
                    action("Insurance")
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
                            }
                            action("Register2")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'Insurance Register';
                                RunObject = report "Insurance Register";
                                ToolTip = 'Executes the Insurance Register action';
                            }
                            action("Analysis2")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'Insurance Analysis';
                                RunObject = report "Insurance - Analysis";
                                ToolTip = 'Executes the Insurance Analysis action';
                            }
                            action("Coverage Details")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'Insurance Coverage Details';
                                RunObject = report "Insurance - Coverage Details";
                                ToolTip = 'Executes the Insurance Coverage Details action';
                            }
                            action("List2")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'Insurance List';
                                RunObject = report "Insurance - List";
                                ToolTip = 'Executes the Insurance List action';
                            }
                            action("Tot. Value Insured")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'FA Total Value Insured';
                                RunObject = report "Insurance - Tot. Value Insured";
                                ToolTip = 'Executes the FA Total Value Insured action';
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
                            }
                            action("Analysis3")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'Maintenance Analysis';
                                RunObject = report "Maintenance - Analysis";
                                ToolTip = 'Executes the Maintenance Analysis action';
                            }
                            action("Details1")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'Maintenance Details';
                                RunObject = report "Maintenance - Details";
                                ToolTip = 'Executes the Maintenance Details action';
                            }
                            action("Next Service")
                            {
                                ApplicationArea = FixedAssets;
                                Caption = 'Maintenance Next Service';
                                RunObject = report "Maintenance - Next Service";
                                ToolTip = 'Executes the Maintenance Next Service action';
                            }
                        }
                    }
                    group("Group48")
                    {
                        Caption = 'Registers/Entries';

                        action("FA Registers")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Registers';
                            RunObject = page "FA Registers";
                            ToolTip = 'Executes the FA Registers action';
                        }
                        action("Insurance Registers")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Insurance Registers';
                            RunObject = page "Insurance Registers";
                            ToolTip = 'Executes the Insurance Registers action';
                        }
                        action("FA Ledger Entries")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Ledger Entries';
                            RunObject = page "FA Ledger Entries";
                            ToolTip = 'Executes the FA Ledger Entries action';
                        }
                        action("Maintenance Ledger Entries")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Maintenance Ledger Entries';
                            RunObject = page "Maintenance Ledger Entries";
                            ToolTip = 'Executes the Maintenance Ledger Entries action';
                        }
                        action("Ins. Coverage Ledger Entries")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Insurance Coverage Ledger Entries';
                            RunObject = page "Ins. Coverage Ledger Entries";
                            ToolTip = 'Executes the Insurance Coverage Ledger Entries action';
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
                        }
                        action("Maintenance")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Maintenance';
                            RunObject = page "Maintenance";
                            ToolTip = 'Executes the Maintenance action';
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
                        }
                    }
                }
                group("Group50")
                {
                    Caption = 'Inventory';

                    action("Inventory Periods")
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Periods';
                        RunObject = page "Inventory Periods";
                        ToolTip = 'Executes the Inventory Periods action';
                    }
                    action("Phys. Invt. Counting Periods")
                    {
                        ApplicationArea = Warehouse, Basic, Suite;
                        Caption = 'Physical Invtory Counting Periods';
                        RunObject = page "Phys. Invt. Counting Periods";
                        ToolTip = 'Executes the Physical Invtory Counting Periods action';
                    }
                    action("Application Worksheet")
                    {
                        ApplicationArea = All;
                        Caption = 'Application Worksheet';
                        RunObject = page "Application Worksheet";
                        ToolTip = 'Executes the Application Worksheet action';
                    }
                    group("Group51")
                    {
                        Caption = 'Costing';

                        action("Adjust Item Costs/Prices")
                        {
                            ApplicationArea = All;
                            Caption = 'Adjust Item Costs/Prices';
                            RunObject = report "Adjust Item Costs/Prices";
                            ToolTip = 'Executes the Adjust Item Costs/Prices action';
                        }
                        action("Adjust Cost - Item Entries")
                        {
                            ApplicationArea = All;
                            Caption = 'Adjust Cost - Item Entries...';
                            RunObject = report "Adjust Cost - Item Entries";
                            ToolTip = 'Executes the Adjust Cost - Item Entries... action';
                        }
                        action("Update Unit Cost...")
                        {
                            ApplicationArea = Manufacturing;
                            Caption = 'Update Unit Costs...';
                            RunObject = report "Update Unit Cost";
                            ToolTip = 'Executes the Update Unit Costs... action';
                        }
                        action("Post Inventory Cost to G/L")
                        {
                            ApplicationArea = All;
                            Caption = 'Post Inventory Cost to G/L';
                            RunObject = report "Post Inventory Cost to G/L";
                            ToolTip = 'Executes the Post Inventory Cost to G/L action';
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
                        Caption = 'Incoming Documents Setup';
                        RunObject = page "Incoming Documents Setup";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Incoming Documents Setup action';
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
                    }
                    action(NoSeries)
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
                        }
                        action("Transaction Types")
                        {
                            ApplicationArea = All;
                            Caption = 'Transaction Types';
                            RunObject = page "Transaction Types";
                            ToolTip = 'Executes the Transaction Types action';
                        }
                        action("Transaction Specifications1")
                        {
                            ApplicationArea = All;
                            Caption = 'Transaction Specifications';
                            RunObject = page "Transaction Specifications";
                            ToolTip = 'Executes the Transaction Specifications action';
                        }
                        action("Transport Methods1")
                        {
                            ApplicationArea = All;
                            Caption = 'Transport Methods';
                            RunObject = page "Transport Methods";
                            ToolTip = 'Executes the Transport Methods action';
                        }
                        action("Entry/Exit Points1")
                        {
                            ApplicationArea = All;
                            Caption = 'Entry/Exit Points';
                            RunObject = page "Entry/Exit Points";
                            ToolTip = 'Executes the Entry/Exit Points action';
                        }
                        action("Areas1")
                        {
                            ApplicationArea = All;
                            Caption = 'Areas';
                            RunObject = page "Areas";
                            ToolTip = 'Executes the Areas action';
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
                        }
                        action("Partner Code")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'Intercompany Partners';
                            RunObject = page "IC Partner List";
                            ToolTip = 'Executes the Intercompany Partners action';
                        }
                        action("Chart of Accounts2")
                        {
                            ApplicationArea = Intercompany;
                            Caption = 'Intercompany Chart of Accounts';
                            RunObject = page "IC Chart of Accounts";
                            ToolTip = 'Executes the Intercompany Chart of Accounts action';
                        }
                        action("Dimension")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Intercompany Dimensions';
                            RunObject = page "IC Dimensions";
                            ToolTip = 'Executes the Intercompany Dimensions action';
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
                        }
                        action("Analyses by Dimensions1")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Analysis by Dimensions';
                            RunObject = page "Analysis View List";
                            ToolTip = 'Executes the Analysis by Dimensions action';
                        }
                        action("Dimension Combinations")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Dimension Combinations';
                            RunObject = page "Dimension Combinations";
                            ToolTip = 'Executes the Dimension Combinations action';
                        }
                        action("Default Dimension Priorities")
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Default Dimension Priorities';
                            RunObject = page "Default Dimension Priorities";
                            ToolTip = 'Executes the Default Dimension Priorities action';
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
                        }
                        action(ReasonCodes)
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
                    group(Banks)
                    {
                        Caption = 'Banks';

                        action("Bank List")
                        {
                            ApplicationArea = All;
                            Caption = 'Banks List';
                            RunObject = page "Banks List";
                            Image = Warehouse;
                            ToolTip = 'Executes the Banks List action';
                        }
                    }
                }
                group("Fin Activities")
                {
                    Caption = 'Financial Activities';

                    group("Finance Transaction List")
                    {

                        action(Receipts)
                        {
                            RunObject = page Receipts;
                            ApplicationArea = All;
                            ToolTip = 'Executes the Receipts action';
                        }
                        action("Petty Cash List")
                        {
                            RunObject = page "Petty Cash List";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Petty Cash List action';
                        }

                        action("Interbank Transfers")
                        {
                            RunObject = page "InterBank Transfer List";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Interbank Transfers action';
                        }
                    }
                    group("Finance Activities")
                    {
                        action("Chart of Accounts ")
                        {
                            RunObject = page "Chart of Accounts";
                            ApplicationArea = All;
                            ToolTip = 'Executes the Chart of Accounts  action';
                        }
                        action("G/L Budgets ")
                        {
                            RunObject = page "G/L Budget Names";
                            ApplicationArea = All;
                            ToolTip = 'Executes the G/L Budgets  action';
                        }
                    }
                }
            }
            group("Funds Management")
            {
                action(CashSetup)
                {
                    Caption = 'Cash Management Setup';
                    Image = Setup;
                    RunObject = page "Cash Management Setups";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Cash Management Setup action';
                }
                action("Imprest Types")
                {
                    RunObject = page "Imprest Type";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Imprest Types action';
                }
                action("Payment Types")
                {
                    RunObject = page "Payment Types";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Payments & Petty Cash Types action';
                }
                action("Receipt Types")
                {
                    RunObject = page "Receipt Types";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Receipt Types action';
                }
                action("Advance Types")
                {
                    RunObject = page "Advance Types";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Advance Types action';
                }
                action("Claim Types")
                {
                    RunObject = page "Claim Types";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Claim Types action';
                }

                action("Cash Office Template")
                {
                    RunObject = page "Cash Office User Template";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Cash Office User Template action';
                }
            }
            group(HR)
            {
                Caption = 'Human Resources Management';

                group("Setup Management")
                {
                    action("Leave Type")
                    {
                        RunObject = page "Hr Leave Type";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Employee List - Active action';
                    }

                    action("HR Setup")
                    {
                        RunObject = page "HR Setup";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Absence Registration action';
                    }
                    action("Leave Calender")
                    {
                        RunObject = page "Hr Calender List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Absence Registration action';
                    }
                    action("Leave Period")
                    {
                        RunObject = page "Hr Leave Period";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Absence Registration action';
                    }
                }
                group("Company Information ")
                {
                    action("Base Calender List")
                    {
                        RunObject = page "Base Calendar List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Base Calender List action';
                    }

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
            group(Procurement)
            {
                Caption = 'Procurement Management';

                group(Plannings)
                {
                    Caption = 'Planning';

                    action(Budgeting)
                    {
                        Image = CostBudget;
                        RunObject = page "G/L Budget Names";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Budgeting action';
                    }

                }

                group("Order Processings")
                {
                    Caption = 'Order processing';

                    action(Contacts)
                    {
                        RunObject = page "Contact List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Contacts action';
                    }

                    action("Purchase quote ")
                    {
                        RunObject = page "Purchase Quotes";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Purchase quote  action';
                    }
                    action("Purchase Orders")
                    {
                        Image = "Order";
                        RunObject = page "Purchase Order List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Purchase Orders action';
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

                group("Inventory and Costing")
                {
                    action(Items)
                    {
                        RunObject = page "Item List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Items action';
                    }
                    action("Nonstock Items")
                    {
                        RunObject = page "Catalog Item List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Nonstock Items action';
                    }
                    action("Stockkeeping Units")
                    {
                        RunObject = page "Stockkeeping Unit List";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Stockkeeping Units action';
                    }
                }
                group("Inventory  Setup")
                {
                    action("Units of Measure")
                    {
                        RunObject = page "Units of Measure";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Units of Measure action';
                    }
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';

                action("Request To Approve")
                {
                    RunObject = page "Requests to Approve";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Request To Approve action';
                }
            }
            group(NotificationTemplates)
            {
                Caption = 'Intrastat';
                Image = Intrastat;
                Visible = true;
                ToolTip = 'Set up Intrastat reporting values, such as tariff numbers.';

                action("Sms Notification")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Sms Notification';
                    RunObject = Page "SMS Notification";
                    ToolTip = 'View information countries/regions for Intrastat reporting.';
                }
                action("Bank Code Structure")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Sms Notification';
                    RunObject = Page "Bank Code Structure";
                    ToolTip = 'View information on List of Banks.';
                }
                action("Banks List")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Sms Notification';
                    RunObject = Page "Banks List";
                    ToolTip = 'View information on List of Banks.';
                }
                action("Bank Branch List")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Sms Notification';
                    RunObject = Page "Bank Branches List";
                    ToolTip = 'View information on List of Bank Branches.';
                }
                action("Posted Approval Entries")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Sms Notification';
                    RunObject = Page "Posted Approval Entry-Credit";
                    ToolTip = 'View information on Posted Approval entries';
                }
                action("Transaction Specifications")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Receipt Types';
                    RunObject = Page "Receipt Types";
                    ToolTip = 'View additional information on Receipt Types.';
                }
                action("Transport Methods")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Transport Methods';
                    RunObject = Page "Transport Methods";
                    ToolTip = 'View information regions, for Intrastat reporting.';
                }
                action("Entry/Exit Points")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Entry/Exit Points';
                    RunObject = Page "Entry/Exit Points";
                    ToolTip = 'View or edit codes for the location to which items from abroad are shipped or from which you ship items abroad. The information is used when reporting to Intrastat.';
                }
                action(Areas)
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Areas';
                    RunObject = Page Areas;
                    ToolTip = 'View or edit information about the areas that you have set up for your configuration. The information includes a count of how many tables fall within each category.';
                }
            }
            group("VAT Registration Numbers")
            {
                Caption = 'VAT Registration Numbers';
                Image = Bank;
                Visible = false;
                ToolTip = 'Set up and maintain VAT registration number formats.';
                action("VAT Registration No. Formats")
                {
                    ApplicationArea = VAT;
                    Caption = 'VAT Registration No. Formats';
                    Visible = false;
                    RunObject = Page "VAT Registration No. Formats";
                    ToolTip = 'View the formats for VAT registration number in different countries/regions.';
                }
            }
            group("Analysis View")
            {
                Caption = 'Analysis View';
                Image = AnalysisView;
                Visible = false;
                ToolTip = 'Set up views for analysis of sales, purchases, and inventory.';
                action("Sales Analysis View List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Analysis View List';
                    RunObject = Page "Analysis View List Sales";
                    ToolTip = 'View the list of views that you use to analyze the dynamics of your sales volumes. You can also use the report to analyze your customer''s performance.';
                }
                action("Purchase Analysis View List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Analysis View List';
                    RunObject = Page "Analysis View List Purchase";
                    ToolTip = 'View the list of views that you use to analyze the dynamics of your purchase volumes. You can also use the report to analyze your vendors'' performance and purchase prices.';
                }
                action("Inventory Analysis View List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory Analysis View List';
                    RunObject = Page "Analysis View List Inventory";
                    ToolTip = 'View or edit your predefined views of items at a specified location per their combination of dimensions.';
                }
            }
            group("Data Privacy")
            {
                Caption = 'Data Privacy';
                Image = HumanResources;
                Visible = false;
                ToolTip = 'Manage data privacy classifications, and respond to requests from data subjects.';
                action("Page Data Classifications")
                {
                    ApplicationArea = All;
                    Caption = 'Data Classifications';
                    RunObject = Page "Data Classification Worksheet";
                    ToolTip = 'View your current data classifications';
                }
                action("Page Data Subjects")
                {
                    ApplicationArea = All;
                    Caption = 'Data Subjects';
                    RunObject = Page "Data Subject";
                    ToolTip = 'View your potential data subjects';
                }
                action("Page Change Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Change Log Entries';
                    RunObject = Page "Change Log Entries";
                    ToolTip = 'View the log with all the changes in your system';
                }
            }
        }

        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Com&pany Information")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Com&pany Information';
                Image = CompanyInformation;
                RunObject = Page "Company Information";
                ToolTip = 'Specify basic information about your company, which designates a complete set of accounting information and financial statements for a business entity. You enter information such as name, addresses, and shipping information. The information in the Company Information window is printed on documents, such as sales invoices.';
            }
            action(UserSetup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'User Setup';
                Image = Migration;
                RunObject = Page "User Setup List";
                ToolTip = 'Show the data migration overview.';
            }
            action("Import Image Files")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Image Files';
                Image = Migration;
                RunObject = Page "Import Image Data";
                ToolTip = 'Show the data migration overview.';
            }
            action("General Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'General Setup';
                Image = Migration;
                RunObject = Page "General Set-Up";
                ToolTip = 'Show the data migration overview.';
            }
            action("Interest Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Interest Period';
                Image = Migration;
                RunObject = Page "Interest Period";
                ToolTip = 'Shows Interest Periods.';
            }
            action("Credit No. Series")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Credit No. Series';
                Image = ChangeTo;
                RunObject = page "Credit Nos. Series";
                ToolTip = 'Specify where to store attachments.';
            }
            action("Banking No. Series")
            {
                ApplicationArea = Warehouse;
                Caption = 'Banking No. Series';
                Image = NewWarehouse;
                RunObject = page "Banking No. Setup";
                ToolTip = 'No. Series Setup';
            }
            action("Funds Mngt. No. Series")
            {
                ApplicationArea = Warehouse;
                Caption = 'Funds No. Series';
                Image = NewWarehouse;
                RunObject = page "Cash Management Setups";
                ToolTip = 'No. Series Setup';
            }
            action("Account Types")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Account Type';
                Image = LogSetup;
                RunObject = Page "Account Type";
                ToolTip = 'Define which contract changes are logged.';
            }
            action("Loan Product Types")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Product Type';
                Image = LogSetup;
                RunObject = page "Loan Product Type";
                ToolTip = 'Define which contract changes are logged.';
            }
            action("User Temaplate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'User Template';
                Image = LogSetup;
                RunObject = page "Banking User Template";
                ToolTip = 'Define which contract changes are logged.';
            }
            action("Funds Mngt.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Office Template';
                Image = LogSetup;
                RunObject = page "Cash Office User Template";
                ToolTip = 'Define which contract changes are logged.';

            }
            action("Relationship Type")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Relationship Type';
                Image = LogSetup;
                RunObject = page "Relationship Types";
                ToolTip = 'Define which contract changes are logged.';
            }
            action("Mobile Membership")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Membership Bracket';
                Image = LogSetup;
                RunObject = page "Continous Membership";
                ToolTip = 'Define Continous Membership Bracket';
            }
            action("Member Category")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Member Category';
                Image = LogSetup;
                RunObject = page "Member Category";
                ToolTip = 'Define which contract changes are logged.';
            }
            action("Member Segment")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Member Segment';
                Image = LogSetup;
                RunObject = page "Segment/County/Dividend/Signat";
                ToolTip = 'Define which contract changes are logged.';

            }
            action("EDMS Class Setup")
            {
                ApplicationArea = All;
                Caption = 'EDMS Class Setup';
                Image = LogSetup;
                RunObject = page "EDMS Class Setup";
            }
            action("Risk Assessment Setup")
            {
                ApplicationArea = All;
                Caption = 'Risk Assessment';
                Image = LogSetup;
                RunObject = page "Risk Assessment Template";
            }
            action(CustomerBankAccounts)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Bank Account';
                Image = LogSetup;
                Visible = false;
                RunObject = page "Customer Bank Ac. List";
                ToolTip = 'Define which contract customer are logged.';
            }
            action(CustomerBankList)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Codes';
                Image = LogSetup;
                RunObject = page "Banks List";
                ToolTip = 'Definecustomer bank list.';
            }
            action(SettlementFee)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Settlement Fee';
                Image = LogSetup;
                RunObject = page "Temp. Files";
                ToolTip = 'Define customer bank list.';
            }
            action(BBFEntitlement)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'BBF Entitlement';
                Image = LogSetup;
                RunObject = page "BBF Entitlement Setup";
                ToolTip = 'Define Customer BBF Entitlement list.';
            }

            action(Employers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employer';
                Image = LogSetup;
                RunObject = page "Customer List";
                ToolTip = 'Define which contract changes are logged.';

            }
            action("Credit Reference")
            {
                ApplicationArea = Basic, Suite;
                Image = LogSetup;
                RunObject = page "Credit Reference";
                ToolTip = 'Define which High Risk customer.';

            }
            action(Statuschangepermission)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Permission';
                Image = LogSetup;
                RunObject = page "Status Change Permssion";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(ProctectedAccounts)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Proctected Account';
                Image = LogSetup;
                RunObject = page "Proctected Accounts";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(RecordRestriction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Record Restriction';
                Image = LogSetup;
                RunObject = page "Record Restriction Mngt.";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(LoanSecurities)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Security Setup';
                Image = LogSetup;
                RunObject = page "Loan Securities Set-Up";
                ToolTip = 'Define which contract changes are logged.';
            }

            action("Property Type")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Property Type';
                Image = LogSetup;
                RunObject = page "Property Type";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(LoanPurpose)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Loan Purpose';
                Image = LogSetup;
                RunObject = page "Loan Purpose";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(Sasrasectoral)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sasra Sectors';
                Image = LogSetup;
                RunObject = page "Sasra Sectors";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(Sasrasubsectoral)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sasra Sub Sectors';
                Image = LogSetup;
                RunObject = page "Sasra Subsector";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(FixedDepositType)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fixed Deposit Type';
                Image = LogSetup;
                RunObject = page "Fixed Deposit Type List";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(TransactionTypes)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transaction Type';
                Image = LogSetup;
                RunObject = page "Transaction Types List";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(TransactionCharges)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transaction Charges';
                Image = LogSetup;
                RunObject = page "Transaction Charges Log";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(ChargesMatrix)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Charges Matrix';
                Image = LogSetup;
                RunObject = page "Charge Matrix";
                ToolTip = 'Define which contract charges are logged.';
            }
            action("Rcv04 Graduation Scale")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Graduation Scale';
                Image = LogSetup;
                RunObject = page "Rcv04 Graduation Scale";
                ToolTip = 'Define which contract charges are logged.';
            }
            action(BanksBranches)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank list & Branches';
                Image = LogSetup;
                RunObject = page "Bank Code Structure";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(Denominations)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Denominations';
                Image = LogSetup;
                RunObject = page "Denomination Setup";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(TieredCharges)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Tiered Charges';
                Image = LogSetup;
                RunObject = page "Tiered Charges List";
                ToolTip = 'Define which contract changes are logged.';
            }
            action(ChequeType)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cheque Type';
                Image = LogSetup;
                RunObject = page "Cheque Type";
                ToolTip = 'Define which contract changes are logged.';
            }

            action(ReceiptType)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Receipt Type';
                Image = LogSetup;
                RunObject = page "Receipt Types";
                ToolTip = 'Define which contract changes are logged.';
            }
            action("Dividend Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dividend Setup';
                Image = LogSetup;
                RunObject = page "Dividend Setup";
                ToolTip = 'Define which contract changes are logged.';
            }
            action("Appraisal Salary Setup")
            {
                ApplicationArea = All;
                Caption = 'Salary Setup';
                Image = LogSetup;
                RunObject = page "Appraisal Salary Set-up";
                ToolTip = 'Define Salary Details.';
            }

            action("Approvals Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Approval Setup';
                Image = LogSetup;
                RunObject = page "Approval Setup";
                ToolTip = 'Define Salary Details.';
            }

            action("Approvals Template")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Approval Template';
                Image = LogSetup;
                RunObject = page "Approval Templates";
                ToolTip = 'Define Approval Details.';
            }
            action("Shares Banding")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Shares Banding';
                Image = LogSetup;
                RunObject = page "Shares Banding";
                ToolTip = 'Define Shares Banding.';
            }
            action("Qualifying Amount Banding")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Advance Banding';
                Image = LogSetup;
                RunObject = page "Qualifying Amount";
                ToolTip = 'Define Mobile loan Qualifying Amount.';
            }
            action("Channel Notifications")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'SMS Notification';
                Image = LogSetup;
                RunObject = page "SMS Notification";
                ToolTip = 'SMS Notification';
            }
            separator(Action47)
            {
            }
            action("Service Trou&bleshooting")
            {
                ApplicationArea = Service;
                Caption = 'Service Trou&bleshooting';
                Image = Troubleshoot;
                Visible = false;
                RunObject = Page Troubleshooting;
                ToolTip = 'View or edit information about technical problems with a service item.';
            }
        }
    }




}





