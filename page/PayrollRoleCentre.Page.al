page 50107 "Payroll Role Centre"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(Allowance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Allowance';
                Image = "Report";
                RunObject = Report "Member Application Register";
                ToolTip = 'View, print, Membership application details.';
            }
            action(Deductions)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deductions';
                Image = "Report";
                RunObject = Report "Banking Ac Register";
                ToolTip = 'View, Account Details Register.';
            }
            action(NSSF)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'NSSF';
                Image = "Report";
                RunObject = Report "Credit Account Register";
                ToolTip = 'View, Account Details Register.';
            }
            action(NHIF)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'NHIF';
                Image = "Report";
                RunObject = Report "Member Register";
                ToolTip = 'Member details register.';
            }


            action(PAYESchedule)
            {
                ApplicationArea = Suite;
                Caption = 'PAYE Schedule';
                Image = "Report";
                RunObject = Report "Account Balance-Credit";
                ToolTip = 'View Account Balances.';
            }
            action(GrossPay)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Gross Pay';
                Image = "Report";
                RunObject = Report "Member Loans Register";

            }
            action("Payroll Summary")
            {
                ApplicationArea = Basic, Suite;
                Image = "Report";
                RunObject = Report "Account Closure Report";

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

        }
        area(embedding)
        {
            action("Membership Individual")
            {
                RunObject = Page "Membership Individual List";
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
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                RunObject = Page "Account Credit List";
                Caption = 'Bosa Account';
                ApplicationArea = All;
            }

            action("Active Loans")
            {
                Caption = 'Active Loans';
                RunObject = Page "Loans List Posted";
                ApplicationArea = All;
                RunPageView = where("Outstanding Balance" = filter(<> 0));
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
            group(EmployeeManagemnt)
            {
                Caption = 'Employee Management';
                Image = Journals;
                action("Employee List")
                {
                    Caption = 'Employee List';
                    RunObject = Page "Hr Employee List";
                    ApplicationArea = All;
                }
            }
            group(Action40)
            {
                Caption = 'Payroll Processing';
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
            
                action("Pr Period Transactions")
                {
                    Caption = 'Pr Period Transactions';
                    RunObject = page "Pr Period Transactions";
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
                    Caption = 'Generate Payroll Journal';
                    RunObject = report "Pr Transfer To Journal";
                    ApplicationArea = All;

                }
            }

            group(Archive)
            {

            }
        }
        area(creation)
        {
            action("Employee Application")
            {
                RunObject = Page "Hr Employee List";
                ApplicationArea = All;
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action(TransactionCode)
            {
                RunObject = Page "Transaction Code List";
                ApplicationArea = All;
                Caption = 'Transaction Code';
            }
            action("Hr Jobs")
            {
                Caption = 'Job Application';
                //RunObject = Page 
                ///ApplicationArea = All;
                ///RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action(LookupValues)
            {
                Caption = 'Lookup Values';
                RunObject = Page "HR Lookup Value";
                ApplicationArea = All;
            }

            action(HrJobReuirement)
            {
                ApplicationArea = All;
                Caption = 'Job Requirement';
                //RunObject = page 
                //RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
            }
            action(HrJobResponsibility)
            {
                Caption = 'Job Responsibility';
                RunObject = page "Job Responsibilities";
                ApplicationArea = All;
            }
            action(LeaveApplication)
            {
                Caption = 'Leave Application';
                RunObject = Page "Member withdrawal Notice List";
                RunPageView = where("Approval Status" = filter(Open | "Pending Approval"));
                ApplicationArea = All;
            }
            action(PrSalaryGrade)
            {
                Caption = 'Salary Grade';
                RunObject = Page "Salary Grades";
                ApplicationArea = All;
            }

        }
    }

}