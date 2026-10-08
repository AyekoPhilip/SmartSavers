page 50132 "Cash Management Role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
        }
    }

    actions
    {
        area(sections)
        {
            group(Setups)
            {
                action(CashSetup)
                {
                    Caption = 'Cash Management Setup';
                    Image = Setup;
                    RunObject = page "Cash Management Setups";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Cash Management Setup action';
                }
               
                action("Payment Types")
                {
                    Caption = 'Payments & Petty Cash Types';
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
                action("User Posting Template")
                {
                    RunObject = page "User Posting Template";
                    ApplicationArea = All;
                    ToolTip = 'Executes the User Posting Template action';
                }
                action("Banker Cheque Register")
                {
                    RunObject = page "Banks Cheque Register";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Banker Cheque Register action';
                }
                action("Cash Office User Template")
                {
                    RunObject = page "Cash Office User Template";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Cash Office User Template action';
                }
            }
            group("Self Service")
            {
                action("Change Password")
                {
                    Caption = 'Change My Password';
                    RunObject = report "Change Password";
                    ApplicationArea = All;
                    ToolTip = 'Change Password';
                }
               
            
                action("Budget Approval List")
                {
                   // RunObject = page "Budget Approval List";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Budget Approval List action';
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
            group(Lists)
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
                }
                action("Bank Acc. Reconciliation List")
                {
                    RunObject = page "Bank Acc. Reconciliation List";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Bank Acc. Reconciliation List action';
                }
                action("Posted Payment Reconciliations")
                {
                    RunObject = page "Posted Payment Reconciliations";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Posted Payment Reconciliations action';
                }
            }
            group(Archive)
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
            }
            group("Inter Bank Transfers")
            {
               
                action("Approved InterBank Transfer")
                {
                   // RunObject = page "Approved InterBank Transfer";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Approved InterBank Transfer action';
                }
            }
            group("Inter Bank Transfers Archive")
            {
              
            }
        }
        area(reporting)
        {
        }
    }
}


