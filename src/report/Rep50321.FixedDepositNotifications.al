report 50321 "Fixed Deposit Notifications"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/FixedDepositNotifications.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Account Banking"; "Account Banking")
        {
            dataitem("Fixed Deposit Notification Lis"; "Fixed Deposit Notification Lis")
            {

                trigger OnAfterGetRecord()
                begin
                    SendNotification("Account Banking");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    local procedure SendNotification(SavingsAccounts: Record "Account Banking")
    var
        FixedDepositNotificationLis: Record "Fixed Deposit Notification Lis";
        UserSetup: Record "User Setup";
    begin
        FixedDepositNotificationLis.SetRange(FixedDepositNotificationLis."Fixed Deposit Type", SavingsAccounts."Fixed Deposit Type");
        if FixedDepositNotificationLis.FindSet then
            repeat
                if FixedDepositNotificationLis."User Type" = FixedDepositNotificationLis."User Type"::Member then begin
                    SendNotificationByUser(SavingsAccounts."Employer Code")
                end
                else
                    if FixedDepositNotificationLis."User Type" = FixedDepositNotificationLis."User Type"::User then begin
                        if UserSetup.Get(FixedDepositNotificationLis."User Id") then
                            SendNotificationByUser(UserSetup."E-Mail");
                    end;
            until FixedDepositNotificationLis.Next = 0;
    end;

    local procedure SendNotificationByUser(Email: Text)
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get;
        /*    Clear(SMTPMail);
           SMTPMail.CreateMessage('Fixed Deposit Maturity Notification',
           CompanyInformation."E-Mail",
           Email,
           'Fixed Deposit Maturity Notification',
           'Fixed deposit ' + Format(SavingsAccounts."No.") + 'worth ' + Format(SavingsAccounts."Balance (LCY)") + 'belonging to ' + SavingsAccounts.Name + 'is going to mature on ' + Format(SavingsAccounts."FD Maturity Date"),
           true);
           SMTPMail.Send; */
    end;
}




