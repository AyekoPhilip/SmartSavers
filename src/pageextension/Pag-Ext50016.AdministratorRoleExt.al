pageextension 50016 "AdministratorRoleExt" extends "Administrator Role Center"
{
    actions
    {
        addafter("Check on Ne&gative Inventory")
        {
            action(GeneralSetup)
            {
                RunObject = page "General Set-Up";
                Caption = 'General Setup';
                ApplicationArea = All;
            }
            action(CreditNoSeries)
            {
                RunObject = page "Credit Nos. Series";
                Caption = 'Credit No. Series';
                ApplicationArea = All;
            }
            action(AccountType)
            {
                RunObject = page "Account Type";
                Caption = 'Account Type';
                ApplicationArea = All;
            }
            action("Loan Product Type")
            {
                RunObject = page "Loan Product Type";
                Caption = 'Loan Product Type';
                ApplicationArea = All;
            }
            action(RelationshipTypes)
            {
                RunObject = page "Relationship Types";
                Caption = 'Relationship Types';
                ApplicationArea = All;
            }
            action(StatusChangePermission)
            {
                RunObject = page "Status Change Permssion";
                Caption = 'Status Change Permission';
                ApplicationArea = All;
            }
            action(ApprovalTemplate)
            {
                RunObject = page "Approval Templates";
                Caption = 'Approval Template';
                ApplicationArea = All;
            }
            action(ApprovalSetup)
            {
                RunObject = page "Approval Setup";
                Caption = 'Approval Setup';
                ApplicationArea = All;
            }
            action(NotificationTemplate)
            {
                RunObject = page NotificationTemplate;
                Caption = 'Notification Template';
                ApplicationArea = All;
            }
            action(FixedDepositType)
            {
                RunObject = page "Fixed Deposit Type List";
                Caption = 'Fixed Deposit Type';
                ApplicationArea = All;
            }
            action(TempDataPage)
            {
                //RunObject = page "Temp Data";
                Caption = 'Temp Data';
                ApplicationArea = All;
            }
            action(TempData)
            {
                RunObject = xmlport "Temp Data";
                Caption = 'Import Data';
                ApplicationArea = All;
            }
           
            action(ModAcc)
            {
                RunObject = report ModAcc;
                Caption = 'ModAcc Data';
                ApplicationArea = All;
            }


        }
    }
}




