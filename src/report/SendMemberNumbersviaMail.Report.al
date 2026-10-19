report 50354 "Send Member Numbers via Mail"
{
    ApplicationArea = All;
    Caption = 'Send Member Numbers via Mail';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.", Status, "Member Category";
            DataItemTableView = where("E-Mail" = filter(<> ''), "Member No. Notified" = const(false));

            trigger OnAfterGetRecord()
            begin
                if not MailManagement.CheckValidEmailAddress(Member."E-Mail") then begin

                    Percentage := (Round(Counter / TotalCount * 10000, 1));
                    Counter := Counter + 1;
                    Window.Update(1, Percentage);
                    Window.Update(2, (Format(Member."No.") + '-' + Member.Name));

                    Clear(Recipient);
                    FOSAAcc := '';
                    ShareCapAcc := '';
                    DepositAcc := '';

                    AccountCredit.Reset();
                    AccountCredit.SetRange("Member No.", Member."No.");
                    AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Capital");
                    if AccountCredit.FindFirst() then
                        ShareCapAcc := AccountCredit."No.";

                    AccountCredit.Reset();
                    AccountCredit.SetRange("Member No.", Member."No.");
                    AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
                    if AccountCredit.FindFirst() then
                        DepositAcc := AccountCredit."No.";

                    AccountBanking.Reset();
                    AccountBanking.SetRange("Member No.", Member."No.");
                    AccountBanking.SetRange("Account Category", AccountBanking."Account Category"::Savings);
                    if AccountBanking.FindFirst() then
                        FOSAAcc := AccountBanking."No.";

                    Subject := 'CHANGE OF UN SACCO MEMBER NUMBERS';
                    Recipient.Add(Member."E-Mail");
                    EmailBody := StrSubstNo(NewBody, Member.Name, Member."No.", FOSAAcc, ShareCapAcc, DepositAcc);
                    EmailMessage.Create(Recipient, Subject, EmailBody, true);
                    if Email.Send(EmailMessage) then begin
                        Member."Member No. Notified" := true;
                        Member.Modify();
                        Commit();
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                Message('Members notified successfully');
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Sending E-mails: @1@@@@@@@@@@@@@@@' + 'Member:#2###############');
                TotalCount := Count;
            end;
        }
    }
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        MailManagement: Codeunit "Mail Management";
        Subject, EmailBody : Text;
        NewBody: Label '<p style="font-family:Garamond,Serif,Arial;font-size:12pt">Dear<b> %1,</b></p><p style="font-family:Garamond,Serif,Arial;font-size:12pt">As earlier communicated, we have now implemented a new banking system which comes with new member numbers. <br> Your new Member Number is <b>%2</b>, which appears as follows on your SACCO accounts: <ul style="font-family:Garamond,Serif,Arial;font-size:12pt"><li>Share Capital Account: <b>%4</b></li><li>Deposit Account: <b>%5</b></li><li>FOSA Account: <b>%3</b></li></ul></p><p style="font-family:Garamond,Serif,Arial;font-size:12pt">We encourage you to take note of your member number and use it on all your SACCO transactions.</p><p style="font-family:Garamond,Serif,Arial;font-size:12pt">Find more information on access to UN DT SACCO services here: <a href="https://bit.ly/3kKUowQ">https://bit.ly/3kKUowQ</a></p><p style="font-family:Garamond,Serif,Arial;font-size:12pt">Kind Regards,</p>';
        Recipient: List of [Text];
        CompanyInfo: Record "Company Information";
        FOSAAcc, ShareCapAcc, DepositAcc : Code[50];
        AccountCredit: Record "Account Credit";
        AccountBanking: Record "Account Banking";
        Counter: Integer;
        Percentage: Integer;
        TotalCount: Integer;
        Window: Dialog;
}



