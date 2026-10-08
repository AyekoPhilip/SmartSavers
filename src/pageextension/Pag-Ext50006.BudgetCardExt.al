pageextension 50006 "BudgetCardExt" extends Budget
{
    layout
    {

    }
    actions
    {
        addafter(ReportGroup)
        {
            group("Approvals")
            {
                action(SendApproval)
                {
                    Caption = 'Send Proposed Budget For Approval';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Send Proposed Budget For Approval action';

                    /* trigger OnAction()
                    begin
                        if Confirm(SendApprovalTxt, false) then begin
                            //if GLBudgetName.get(budget)

                        end;
                    end; */
                }
            }
        }
    }

}











