codeunit 50050 "Approvals Mgt Notification"
{
    Permissions = TableData "Overdue Approval Entry" = i;

    trigger OnRun()
    begin
    end;

    var
        AppSetup: Record "Approval Setup";

        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text[1024];
        InStreamTemplate: InStream;
        InSReadChar: Text[1];
        CharNo: Text[4];
        I: Integer;
        Text001: Label 'Sales %1';
        Text002: Label 'Purchase %1';
        Text003: Label 'requires your approval.';
        Text005: Label 'Customer';
        Text007: Label 'Microsoft Dynamics NAV: %1 Mail';
        Text012: Label 'Overdue Approvals';
        Text013: Label 'Microsoft Dynamics NAV Document Approval System';
        Text014: Label 'has been cancelled.';
        Text016: Label 'has been rejected.';
        Text018: Label 'Vendor';
        Text020: Label 'has been delegated.';
        Text022: Label 'Overdue approval';
        Text030: Label 'Not yet overdue';
        Text040: Label 'You must import an Approval Template in Approval Setup.';
        Text041: Label 'You must import an Overdue Approval Template in Approval Setup.';
        FromUser: Text[100];
        Text042: Label 'Available Credit Limit (LCY)';
        Text043: Label 'Request Amount (LCY)';
        MailCreated: Boolean;
        Sms: Record "SMS Notification";
        gensetup: Record "General Set-Up";
        CompanyInfo: Record "Company Information";
        RepFormat: ReportFormat;
        OfficalReceipt: Report "Official Receipt";
        Base64Conv: Codeunit "Base64 Convert";
        Email: Codeunit Email;
        NotifSource: Enum NotifSourceType;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        Receipient: List of [Text];
        AttachOutstr: OutStream;
        Base64Txt: Text;
        FileName: Text;
        AttachInstr: InStream;

    procedure SendOverdueApprovalsMail(Reciever: Text[100]; var AppEntriesNotDue: Record "Approval Entries"; var AppEntriesDue: Record "Approval Entries")
    var
        AppSetUp: Record "Approval Setup";
        UserSetup: Record "User Setup";
        QtyAppEntries: Integer;
        QytAppEntDue: Integer;
    begin
        SetOverdueTemplate;
        AppSetUp.Get;
        AppSetUp.TestField("Approval Administrator");
        UserSetup.Get(AppSetUp."Approval Administrator");
        UserSetup.TestField("E-Mail");
        SenderAddress := UserSetup."E-Mail";
        Recipient := Reciever;
        Subject := StrSubstNo(Text007, Text012);
        Body := Text013;

        QtyAppEntries := AppEntriesNotDue.Count;
        QytAppEntDue := AppEntriesDue.Count;

        //SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, true);

        Body := '';

        while InStreamTemplate.EOS() = false do begin
            InStreamTemplate.ReadText(InSReadChar, 1);
            if InSReadChar = '%' then begin
                //SMTP.AppendBody(Body);
                Body := InSReadChar;
                if InStreamTemplate.ReadText(InSReadChar, 1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
                    Body := Body + '1';
                    CharNo := InSReadChar;
                    while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                        if InStreamTemplate.ReadText(InSReadChar, 1) <> 0 then;
                        if (InSReadChar >= '0') and (InSReadChar <= '9') then
                            CharNo := CharNo + InSReadChar;
                    end;
                end else
                    Body := Body + InSReadChar;
                case CharNo of
                    '1':
                        Body := '';
                    '2':
                        Body := '';
                end;
                //SMTP.AppendBody(Body);
                Body := InSReadChar;
            end else begin
                Body := Body + InSReadChar;
                I := I + 1;
                if I = 500 then begin
                    //SMTP.AppendBody(Body);
                    Body := '';
                    I := 0;
                end;
            end;
        end;
        //SMTP.AppendBody(Body);

        // Find Approval entries overdue and append to template
        if QytAppEntDue > 0 then begin
            Body := StrSubstNo('<p class="MsoNormal"><font face="Arial size 2"><b>%1</b></font></p>', Text022);
            //SMTP.AppendBody(Body);
            if AppEntriesDue.Find('-') then begin
                repeat
                    BuildOverdueLine(AppEntriesDue);
                    InsertOverdueLogEntries(AppEntriesDue);
                until AppEntriesDue.Next = 0;
            end;
        end;

        // Find Approval entries not overdue and append to template
        if QtyAppEntries > 0 then begin
            Body := StrSubstNo('<p class="MsoNormal"><font face="Arial size 2"><b>%1</b></font></p>', Text030);
            //SMTP.AppendBody(Body);
            if AppEntriesNotDue.Find('-') then begin
                repeat
                    BuildDueLine(AppEntriesNotDue);
                until AppEntriesNotDue.Next = 0;
            end;
        end;
        //SMTP.Send;
    end;


    procedure GetEmailAddress(AppEntry: Record "Approval Entries")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(AppEntry."Sender ID");
        UserSetup.TestField("E-Mail");
        SenderAddress := UserSetup."E-Mail";
        UserSetup.Get(AppEntry."Approver ID");
        UserSetup.TestField("E-Mail");
        Recipient := UserSetup."E-Mail";
        UserSetup.Get(UserId);
        UserSetup.TestField("E-Mail");
        FromUser := UserSetup."E-Mail";
    end;


    procedure CheckEntriesDue(DueDate: Date)
    var
        UserSetup: Record "User Setup";
        AppEnt: Record "Approval Entries" temporary;
        AppEntDue: Record "Approval Entries" temporary;
        AppEntries: Record "Approval Entries";
        ApprovalMgt: Codeunit "Approvals Mgt Notification";
        OverdueFound: Boolean;
    begin
        if UserSetup.Find('-') then begin
            UserSetup.TestField("E-Mail");
            repeat
                OverdueFound := false;
                AppEnt.DeleteAll;
                AppEntDue.DeleteAll;
                AppEntries.SetCurrentKey("Approver ID", Status);
                AppEntries.SetRange("Approver ID", UserSetup."User ID");
                AppEntries.SetRange(Status, AppEntries.Status::Open);
                if AppEntries.Find('-') then begin
                    repeat
                        if AppEntries."Due Date" <= DueDate then begin
                            AppEntDue := AppEntries;
                            AppEntDue.Insert;
                            OverdueFound := true;
                        end else begin
                            AppEnt := AppEntries;
                            AppEnt.Insert;
                        end;
                    until AppEntries.Next = 0;
                    if OverdueFound then
                        ApprovalMgt.SendOverdueApprovalsMail(UserSetup."E-Mail", AppEnt, AppEntDue);
                end;
            until UserSetup.Next = 0;
        end;
    end;


    procedure FillSalesTemplate(var Body: Text[254]; TextNo: Text[30]; Header: Record "Sales Header"; AppEntry: Record "Approval Entries"; CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin
        case TextNo of
            '1':
                Body := StrSubstNo(Text001, Header."Document Type");
            '2':
                Body := StrSubstNo(Body, Header."No.");
            '3':
                case CalledFrom of
                    CalledFrom::Approve:
                        Body := StrSubstNo(Body, Text003);
                    CalledFrom::Cancel:
                        Body := StrSubstNo(Body, Text014);
                    CalledFrom::Reject:
                        Body := StrSubstNo(Body, Text016);
                    CalledFrom::Delegate:
                        Body := StrSubstNo(Body, Text020);
                end;
            '4':
                case CalledFrom of
                    CalledFrom::Approve:
                        Body := '';
                    CalledFrom::Cancel:
                        Body := '';
                    CalledFrom::Reject:
                        Body := '';
                    CalledFrom::Delegate:
                        Body := '';
                end;
            '5':
                Body := '';
            '6':
                Body := '';
            '7':
                Body := StrSubstNo(Body, AppEntry.FieldCaption(Amount));
            '8':
                Body := StrSubstNo(Body, AppEntry."Currency Code");
            '9':
                Body := StrSubstNo(Body, AppEntry.Amount);
            '10':
                Body := StrSubstNo(Body, AppEntry.FieldCaption("Amount (LCY)"));
            '11':
                Body := StrSubstNo(Body, AppEntry."Amount (LCY)");
            '12':
                Body := StrSubstNo(Body, Text005);
            '13':
                Body := StrSubstNo(Body, Header."Bill-to Customer No.");
            '14':
                Body := StrSubstNo(Body, Header."Bill-to Name");
            '15':
                Body := StrSubstNo(Body, AppEntry.FieldCaption("Due Date"));
            '16':
                Body := StrSubstNo(Body, AppEntry."Due Date");
            '17':
                Body := Text042;
            '18':
                Body := StrSubstNo(Body, AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure FillPurchaseTemplate(var Body: Text[254]; TextNo: Text[30]; Header: Record "Purchase Header"; AppEntry: Record "Approval Entries"; CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin
        case TextNo of
            '1':
                Body := StrSubstNo(Text002, Header."Document Type");
            '2':
                Body := StrSubstNo(Body, Header."No.");
            '3':
                case CalledFrom of
                    CalledFrom::Approve:
                        Body := StrSubstNo(Body, Text003);
                    CalledFrom::Cancel:
                        Body := StrSubstNo(Body, Text014);
                    CalledFrom::Reject:
                        Body := StrSubstNo(Body, Text016);
                    CalledFrom::Delegate:
                        Body := StrSubstNo(Body, Text020);
                end;
            '4':
                case CalledFrom of
                    CalledFrom::Approve:
                        Body := '';
                    CalledFrom::Cancel:
                        Body := '';
                    CalledFrom::Reject:
                        Body := '';
                    CalledFrom::Delegate:
                        Body := '';
                end;
            '5':
                Body := '';
            '6':
                Body := '';
            '7':
                Body := StrSubstNo(Body, AppEntry.FieldCaption(Amount));
            '8':
                Body := StrSubstNo(Body, AppEntry."Currency Code");
            '9':
                Body := StrSubstNo(Body, AppEntry.Amount);
            '10':
                Body := StrSubstNo(Body, AppEntry.FieldCaption("Amount (LCY)"));
            '11':
                Body := StrSubstNo(Body, AppEntry."Amount (LCY)");
            '12':
                Body := StrSubstNo(Body, Text018);
            '13':
                Body := StrSubstNo(Body, Header."Pay-to Vendor No.");
            '14':
                Body := StrSubstNo(Body, Header."Pay-to Name");
            '15':
                Body := StrSubstNo(Body, AppEntry.FieldCaption("Due Date"));
            '16':
                Body := StrSubstNo(Body, AppEntry."Due Date");
            '17':
                begin
                    if AppEntry."Limit Type" = AppEntry."Limit Type"::"Request Limits" then
                        Body := Text043
                    else
                        Body := ' ';
                end;
            '18':
                begin
                    if AppEntry."Limit Type" = AppEntry."Limit Type"::"Request Limits" then
                        Body := StrSubstNo(Body, AppEntry."Amount (LCY)")
                    else
                        Body := ' ';
                end;
        end;
    end;


    procedure SetTemplate(AppEntry: Record "Approval Entries")
    begin
        AppSetup.Get;
        AppSetup.CalcFields("Approval Template");
        if not AppSetup."Approval Template".HasValue then
            Error(Text040);
        AppSetup."Approval Template".CreateInStream(InStreamTemplate);
        SenderName := CompanyName;
        Clear(SenderAddress);
        Clear(Recipient);
        GetEmailAddress(AppEntry);
    end;


    procedure SetOverdueTemplate()
    begin
        AppSetup.Get;
        AppSetup.CalcFields("Overdue Template");
        if not AppSetup."Overdue Template".HasValue then
            Error(Text041);
        AppSetup."Overdue Template".CreateInStream(InStreamTemplate);
        SenderName := CompanyName;
    end;


    procedure BuildOverdueLine(AppEntry: Record "Approval Entries")
    var
        DueLine: Text[500];
        TextType: Text[30];
    begin
        case AppEntry."Table ID" of
            36:
                TextType := 'Sales';
            38:
                TextType := 'Purchase';
        end;
        DueLine := '<p class="MsoNormal"><span style="font-family:Arial size 2">' +
          Format(TextType, 10) + Format(AppEntry."Document Type", 15) +
          Format(AppEntry."Document No.", 20) + Format(AppEntry."Due Date", 10) + '</span></p>';
        //SMTP.AppendBody(DueLine);
    end;


    procedure BuildDueLine(AppEntry: Record "Approval Entries")
    var
        TextType: Text[500];
        DueLine: Text[254];
    begin
        case AppEntry."Table ID" of
            36:
                TextType := 'Sales';
            38:
                TextType := 'Purchase';
        end;
        DueLine := '<p class="MsoNormal"><span style="font-family:Arial size 2">' +
          Format(TextType, 10) + Format(AppEntry."Document Type", 15) +
          Format(AppEntry."Document No.", 20) + Format(AppEntry."Due Date", 10) + '</span></p>';
        //SMTP.AppendBody(DueLine);
    end;


    procedure BuildCommentLine(Comments: Record "Approval Comment Line")
    var
        CommentLine: Text[500];
    begin
        CommentLine := '<p class="MsoNormal"><span style="font-family:Arial size 2">' +
          Comments.Comment + '</span></p>';
        //SMTP.AppendBody(CommentLine);
    end;


    procedure InsertOverdueLogEntries(AppEntry: Record "Approval Entries")
    begin
        /*LogEntries."Approver ID" := AppEntry."Approver ID";
        IF WindowsLogin.GET(AppEntry."Approver ID") THEN BEGIN
          WindowsLogin.CALCFIELDS(ID,Name);
          LogEntries."Sent to Name" := WindowsLogin.Name;
        END ELSE IF DatabaseLogin.GET(AppEntry."Approver ID") THEN
          LogEntries."Sent to Name" := DatabaseLogin.Name;
        
        LogEntries."Table ID" := AppEntry."Table ID";
        LogEntries."Document Type" := AppEntry."Document Type";
        LogEntries."Document No." := AppEntry."Document No.";
        LogEntries."Sent to ID" := AppEntry."Approver ID";
        LogEntries."Sent Date" := TODAY;
        LogEntries."Sent Time" := TIME;
        LogEntries."E-Mail" := Recipient;
        LogEntries."Sequence No." := AppEntry."Sequence No.";
        LogEntries."Due Date" := AppEntry."Due Date";
        LogEntries."Approval Code" := AppEntry."Approval Code";
        LogEntries.INSERT;
         */

    end;


    procedure LaunchCheck(RunDate: Date)
    var
        ApprovalMannagement: Codeunit "Approvals Mgt Notification";
    begin
        ApprovalMannagement.CheckEntriesDue(RunDate);
    end;


    procedure SendMail()
    begin
        //SMTP.Send;
        MailCreated := false;
    end;

    procedure SendApprovalMailNotification(ApprovalEntry: Record "Approval Entries")
    var

        HtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt"><b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">You have a pending document for your approval. <b></b>.</p><p style="font-family:Verdana,Arial;font-size:9pt"><br>Document No. %2</br><br>Document Type  %3</br>Kind regards<br><br><Strong>%4</Strong>';
        EmailBody: Text;
        Subject: Text;
        TimeNow: Text;
        PayPeriodText: Text;
        Member: Record Member;
        Recov: Record "Recovery Header";
        RecovHeader: Record "Recovery Header";
        RecovLine: Record "Loan Disbursement Lines";
        Accredit: Record "Account Credit";
        MemberCust: Record Member;
        DemandNotice: Report "Demand Letter 3";
        Agreement: Record "Guarantor & Security Posted";
        Recipientt, RecipientCC, RecipientBCC : List of [Text];
        Temp: Record "User Setup";
    begin

        CompanyInfo.Get();
        CompanyInfo.TestField(Name);

        Temp.Get(ApprovalEntry."Approver ID");
        Temp.TestField("E-Mail");
        RecipientCC.Add(CompanyInfo."E-Mail");
        Recipientt.Add(Temp."E-Mail");
        PayPeriodText := Format(Today);
        Subject := 'Approval Notification' + '( ' + Format(ApprovalEntry."Document Type") + ' )';
        EmailBody := StrSubstNo(HtmlBody, Temp."User ID", ApprovalEntry."Document No.", Format(ApprovalEntry."Document Type"),
        ApprovalEntry."Sender ID", 'This email is computer generated. Do not reply.');
        EmailMessage.Create(Recipientt, Subject, EmailBody, true, RecipientCC, RecipientBCC);
        Email.Send(EmailMessage);

    end;

}




