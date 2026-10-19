page 50661 "General Activities Role Center"
{
    Caption = 'General Activities Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Control76; "Headline RC Accountant")
            {
                ApplicationArea = All;
                Caption = 'Headline RC Accountant';
            }
           
        }
    }

    actions
    {
        area(Processing)
        {

        }
        area(sections)
        {
            group("Self service")
            {
                Caption = 'Self service';
                action("Change Password")
                {
                    Caption = 'Change My Password';
                    RunObject = report "Change Password";
                    ApplicationArea = All;
                    ToolTip = 'Change Password';
                }
               
               
               

                action(CustomerStatement)
                {
                    Caption = 'My Customer Statement';
                    RunObject = report "Customer Statement";
                    ApplicationArea = All;
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
        area(reporting)
        {

        }
    }
}



