codeunit 50045 "SMS Notification"
{

    trigger OnRun()
    begin
    end;

    var
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
        RepaymentSchedule: Report "Repayment Schedule Application";
        Text00012: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear Member,<b></b></p><p style="font-family:Verdana,Arial;font-size:9pt">Please find attached your loan repayment as advised.<br> Enjoy!<br> Thank you. <br> Kind Regards, <br></p><p style="font-family:Verdana,Arial;font-size:9pt">This is system generated Email. Do not reply.</p>';
        TextSubject: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear Member,<b></b></p><p style="font-family:Verdana,Arial;font-size:9pt">Your Account has been flagged as Dormant. Kindly make transaction to avoid account being Permanently closed.<br> Enjoy!<br> Thank you. <br> Kind Regards, <br></p><p style="font-family:Verdana,Arial;font-size:9pt">This is system generated Email. Do not reply.</p>';

    procedure CreateSmsNotif(Source: Enum NotifSourceType; Telephone: Text[200]; Textsms: Text[250]; Reference: Text[100]; AccNo: Text[30]; Chargeable: Boolean)
    var
        EntryNo: Integer;
    begin
        EntryNo := EntryNo + 1;
        Sms.Reset;
        if Sms.FindLast then begin
            Sms.Init;
            Sms.Source := Source;
            Sms."Entry No" := InitNextEntryNo();
            Sms."Telephone No" := Replacestring(Telephone, '-', '');
            Sms."Date Entered" := Today;
            Sms."Time Entered" := Time;
            Sms."Entered By" := UserId;
            Sms."SMS Message" := CopyStr(Textsms, 1, 250);
            Sms."Sent To Server" := Sms."Sent To Server"::No;
            Sms."Document No" := Reference;
            Sms."Account No" := AccNo;
            Sms.IsChargeable := Chargeable;
            Sms.Posted := false;
            if Sms."Telephone No" <> '' then
            Sms.Insert(true);
        end;
    end;

    procedure Replacestring(string: Text[200]; findwhat: Text[30]; replacewith: Text[200]) Newstring: Text[200]
    begin
        while StrPos(string, findwhat) > 0 do
            string := DelStr(string, StrPos(string, findwhat)) + replacewith + CopyStr(string, StrPos(string, findwhat) + StrLen(findwhat));
        Newstring := string;
    end;

    local procedure InitNextEntryNo() NextEntryNo: Integer
    var
        GLEntry: Record "SMS Notification";
        LastEntryNo: Integer;
        LastTransactionNo: Integer;
    begin
        GLEntry.LockTable();
        if GLEntry.FindLast() then begin
            NextEntryNo := GLEntry."Entry No" + 1;
        end else begin
            NextEntryNo := 1
        end;

    end;

    procedure SendPayslipMail(StaffNo: Code[20]; PaymentPeriod: Date; Mail: Text)
    var
        RepFormat: ReportFormat;
        //Payslip: Report "New Payslipx";
        Base64Conv: Codeunit "Base64 Convert";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        AttachInstr: InStream;
        HtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear<b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Kindly find attached your Payslip for the Month of <b>%2</b>.</p><p style="font-family:Verdana,Arial;font-size:9pt">Thank you</p><p style="font-family:Verdana,Arial;font-size:9pt"><br><br>Kind regards<br><br><Strong>%3</Strong>';
        Receipient: List of [Text];
        AttachOutstr: OutStream;
        Base64Txt: Text;
        FileName: Text;
        EmailBody: Text;
        PayPeriodText: Text;
        Subject: Text;
        TimeNow: Text;
        HRSetup: Record "Human Resources Setup";
        //CompanyInfo: Record "Company Activities";
        Employee: Record Employee;
    begin


        CompanyInfo.Get();
        CompanyInfo.TestField(Name);

        PayPeriodText := Format(PaymentPeriod, 0, '<Month Text> <Year4>');

        Receipient.Add(Employee."E-Mail");
        Subject := 'Payslip for  Period - ' + PayPeriodText;
        // FileName := HRSetup."Payslips Path" + PayPeriodText + '-' + Employee."No." + '.pdf';

        // EmailBody := StrSubstNo(HtmlBody, Employee."First Name", PayPeriodText, HRSetup."General Payslip Message");
        EmailMessage.Create(Receipient, Subject, EmailBody, true);

        Employee.Reset();
        Employee.SetRange("No.", StaffNo);
        if Employee.FindFirst() then begin
            /*  Clear(Payslip);
             Payslip.SetTableView(Employee);
             TempBlob.CreateOutStream(AttachOutstr);
             if Payslip.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                 TempBlob.CreateInStream(AttachInstr);
                 Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                 EmailMessage.AddAttachment(FileName, 'application/pdf', Base64Txt);
             end; */
        end;

        Email.Send(EmailMessage);
    end;

    procedure SendEmailOnEFTPayment(RecHeader: Code[50])
    var

        HtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear<b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Kindly find attached your Receipt for Payment on <b>%2</b>.</p><p style="font-family:Verdana,Arial;font-size:9pt">Thank you</p><p style="font-family:Verdana,Arial;font-size:9pt"><br><br>Kind regards<br><br><Strong>%3</Strong>';
        EmailBody: Text;
        Subject: Text;
        TimeNow: Text;
        PayPeriodText: Text;
        Member: Record Member;
        Receipt: Record "Receipts Header";
        ReceiptHeader: Record "Receipts Header";

    begin
        gensetup.Get();
        gensetup.TestField("Email Attachment Path");

        CompanyInfo.Get();
        CompanyInfo.TestField(Name);

        if Receipt.Get(RecHeader) then begin
            if Member.Get(Receipt."Member No.") then begin
                Member.TestField("E-Mail");

                PayPeriodText := Format(Today);

                Receipient.Add(Member."E-Mail");
                Subject := 'ACCOUNT BOOST AND EFT APPROVAL';
                FileName := gensetup."Email Attachment Path" + RecHeader + '-' + Member."No." + '.pdf';
                EmailBody := StrSubstNo(HtmlBody, Member.Name, PayPeriodText, 'This email is computer generated. Do not reply.');
                EmailMessage.Create(Receipient, Subject, EmailBody, true);

                ReceiptHeader.Reset();
                ReceiptHeader.SetRange("No.", Receipt."No.");
                ReceiptHeader.SetRange("Member No.", Member."No.");
                if ReceiptHeader.FindFirst() then begin
                    Clear(OfficalReceipt);
                    OfficalReceipt.SetTableView(ReceiptHeader);
                    TempBlob.CreateOutStream(AttachOutstr);
                    if OfficalReceipt.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                        TempBlob.CreateInStream(AttachInstr);
                        Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                        EmailMessage.AddAttachment(FileName, 'application/pdf', Base64Txt);
                    end;
                end;
                Email.Send(EmailMessage);
            end;
        end;
    end;

    procedure SendEmailOnReceiptPayment(RecHeader: Code[50])
    var

        HtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear<b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Kindly find attached your Receipt for Payment on <b>%2</b>.</p><p style="font-family:Verdana,Arial;font-size:9pt">Thank you</p><p style="font-family:Verdana,Arial;font-size:9pt"><br><br>Kind regards<br><br><Strong>%3</Strong>';
        EmailBody: Text;
        Subject: Text;
        TimeNow: Text;
        PayPeriodText: Text;
        Member: Record Member;
        Receipt: Record "Receipts Header";
        ReceiptHeader: Record "Receipts Header";

    begin
        gensetup.Get();
        gensetup.TestField("Email Attachment Path");

        CompanyInfo.Get();
        CompanyInfo.TestField(Name);

        ReceiptHeader.Reset();
        if Receipt.Get(RecHeader) then begin
            if Member.Get(Receipt."Member No.") then begin
                Member.TestField("E-Mail");

                PayPeriodText := Format(Today);
                Receipient.Add(Member."E-Mail");
                Subject := 'OFFICIAL RECEIPT-' + ReceiptHeader."No.";
                FileName := ReceiptHeader."No." + '.pdf';
                EmailBody := StrSubstNo(HtmlBody, Member.Name, PayPeriodText, 'This email is computer generated. Do not reply.');
                EmailMessage.Create(Receipient, Subject, EmailBody, true);

                ReceiptHeader.Reset();
                ReceiptHeader.SetRange("No.", Receipt."No.");
                ReceiptHeader.SetRange("Member No.", Member."No.");
                if ReceiptHeader.FindFirst() then begin

                    Clear(OfficalReceipt);
                    OfficalReceipt.SetTableView(ReceiptHeader);
                    TempBlob.CreateOutStream(AttachOutstr);
                    if OfficalReceipt.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                        TempBlob.CreateInStream(AttachInstr);
                        Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                        EmailMessage.AddAttachment(FileName, 'Receipt/pdf', Base64Txt);
                    end;
                end;
                Email.Send(EmailMessage);
            end;
        end;
    end;


    procedure SendPaymentCertificate(RecHeader: Code[50])
    var

        HtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear<b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Please find attached payment certificate, indicating amount deducted from your deposits in respect to %2 defaulted loan. <b>%2</b>.</p><p style="font-family:Verdana,Arial;font-size:9pt">Kindly arrange to collect the original from our offices.</p><p style="font-family:Verdana,Arial;font-size:9pt"><br><br>Kind regards<br><br><Strong>%3</Strong>';
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
        PaymentCert: Report "Guarantor Payment Certificate";
        Agreement: Record "Guarantor & Security Posted";
        Recipientt, RecipientCC, RecipientBCC : List of [Text];
    begin
        gensetup.Get();
        gensetup.TestField("Email Attachment Path");

        CompanyInfo.Get();
        CompanyInfo.TestField(Name);

        if Recov.Get(RecHeader) then begin
            if Member.Get(Recov."Account No.") then begin
                Member.TestField("E-Mail");

                PayPeriodText := Format(Today);
                Subject := 'PAYMENT CERTIFICATE';

                RecovHeader.Reset();
                RecovHeader.SetRange("No.", Recov."No.");
                RecovHeader.SetRange("Application Type", RecovHeader."Application Type"::"Recover from guarantors");
                if RecovHeader.FindFirst() then begin

                    RecovLine.Reset();
                    RecovLine.SetRange(No, Recov."No.");
                    RecovLine.SetRange("Default Account No.", Recov."Account No.");
                    if RecovLine.FindSet() then begin
                        repeat
                            if Accredit.Get(RecovLine."Account No.") then begin
                                MemberCust.Reset();
                                MemberCust.SetRange("No.", Accredit."Member No.");
                                if MemberCust.FindFirst() then begin
                                    MemberCust.TestField("E-Mail");

                                    Agreement.Reset();
                                    Agreement.SetRange("Loan No.", RecovHeader."Loan No.");
                                    Agreement.SetRange("Account No.", RecovLine."Account No.");
                                    if Agreement.Find('-') then begin

                                        Clear(Recipientt);
                                        Clear(RecipientCC);
                                        Clear(RecipientCC);
                                        Recipientt.Add('');
                                        RecipientCC.Add('');

                                        FileName := Agreement."Loan No." + '-' + RecovLine."Account No." + '.pdf';
                                        EmailBody := StrSubstNo(HtmlBody, Agreement.Name, Member.Name, 'This email is computer generated. Do not reply.');
                                        EmailMessage.Create(Recipientt, Subject, EmailBody, true, RecipientCC, RecipientBCC);

                                        Clear(PaymentCert);
                                        PaymentCert.SetTableView(Agreement);
                                        TempBlob.CreateOutStream(AttachOutstr);
                                        if PaymentCert.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                                            TempBlob.CreateInStream(AttachInstr);
                                            Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                                            EmailMessage.AddAttachment(FileName, 'Defaulter/pdf', Base64Txt);
                                        end;
                                        Email.Send(EmailMessage);
                                    end;
                                end;
                            end;
                        until RecovLine.Next() = 0;
                    end;

                end;

            end;
        end;
    end;

    procedure SendNoticeFinal(RecHeader: Code[50])
    var

        HtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear<b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Please find attached Demand Notice with respect to %1 defaulted loan. <b></b>.</p><p style="font-family:Verdana,Arial;font-size:9pt"><br><br>Kind regards<br><br><Strong>%3</Strong>';
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
    begin
        gensetup.Get();
        gensetup.TestField("Email Attachment Path");

        CompanyInfo.Get();
        CompanyInfo.TestField(Name);

        RecovHeader.Reset();
        RecovHeader.SetRange("No.", RecHeader);
        RecovHeader.SetRange("Application Type", RecovHeader."Application Type"::"Recovery from Shares");
        if RecovHeader.FindFirst() then begin

            Member.Reset();
            Member.SetRange("No.", RecovHeader."Account No.");
            if Member.FindFirst() then begin
                Member.TestField("E-Mail");

                Agreement.Reset();
                Agreement.SetRange("Loan No.", RecovHeader."Loan No.");
                if Agreement.Find('-') then begin
                    repeat
                        if Accredit.Get(Agreement."Account No.") then begin
                            MemberCust.Reset();
                            MemberCust.SetRange("No.", Accredit."Member No.");
                            if MemberCust.FindFirst() then begin
                                MemberCust.TestField("E-Mail");
                                RecipientCC.Add(MemberCust."E-Mail");
                            end;
                        end;
                    until Agreement.Next() = 0;
                end;

                Recipientt.Add(Member."E-Mail");
                PayPeriodText := Format(Today);
                Subject := 'DEMAND NOTICE';

                FileName := Member."No." + '-' + RecovHeader."Loan No." + '.pdf';
                EmailBody := StrSubstNo(HtmlBody, Member.Name, PayPeriodText, 'This email is computer generated. Do not reply.');
                EmailMessage.Create(Recipientt, Subject, EmailBody, true, RecipientCC, RecipientBCC);

                Clear(DemandNotice);
                DemandNotice.SetTableView(RecovHeader);
                TempBlob.CreateOutStream(AttachOutstr);
                if DemandNotice.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                    TempBlob.CreateInStream(AttachInstr);
                    Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                    EmailMessage.AddAttachment(FileName, 'application/pdf', Base64Txt);
                end;
                Email.Send(EmailMessage);
            end;
        end;
    end;

    procedure getCompanyInfo()
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField(Name)
    end;

    procedure SendEmailNotification(var Variant: Variant; ActionItem: Integer; DocNo: Code[100])
    var
        CompanyInfo: Record "Company Information";
        Employee: Record Employee;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        BirthDate: Integer;
        BirthMonth: Integer;
        TodayDate: Integer;
        TodayMonth: Integer;
        EmailTxt: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Registration fee is: ksh 1,000 </p><p style="font-family:Verdana,Arial;font-size:10pt"> Minimum Sacco share capital is ksh 10,000 on the first year of joining before you can patronize any product. <p style="font-family:Verdana,Arial;font-size:10pt">You are now eligible to start making your monthly of a minimum of KES 2,000.</p>';
        HtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear, %1,</p><p style="font-family:Verdana,Arial;font-size:9pt">Your assigned membership number is %2 </p><p style="font-family:Verdana,Arial;font-size:10pt">Registration fee is: ksh 1,000 </p><p style="font-family:Verdana,Arial;font-size:10pt"> Minimum Sacco share capital is ksh 10,000 on the first year of joining before you can patronize any product. <p style="font-family:Verdana,Arial;font-size:10pt">You are now eligible to start making your monthly of a minimum of KES 2,000. <br>Thank you. <br> Kind Regards, <br> %3</p>';

        LoanapplicHtmlBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear, %1,</p><p style="font-family:Verdana,Arial;font-size:9pt">Your %2 application of KES %3 repayable in %4 has been approved.</p><p style="font-family:Verdana,Arial;font-size:10pt">Loan Amount: KES %5 </p><p style="font-family:Verdana,Arial;font-size:10pt"> Interest Rate %6. <p style="font-family:Verdana,Arial;font-size:10pt">Monthly Payment %7. <br>Thank you. <br> Kind Regards, <br> %8</p>';

        HtmlBodyDormancy: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear<b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Dear Member your membership application has been approved.<br> Enjoy!<br> Thank you. <br> Kind Regards, <br> %2';
        Receipient: List of [Text];
        EmailBody: Text;
        LoanPostedEmailBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt"><b>Dear Member,</b><b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Your loan of KES %1 repayable in %2 at %3 P.A has been issued.</br><br> Plaese find attached loa repayment schedule. </br><br> Kind Regards,';
        HtmlIdemnityBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear<b> %1,</b></p><p style="font-family:Verdana,Arial;font-size:9pt">Greetings from SACCO.</p><br>We have received and processed an Indemnity in your account, authorizing us to process any transaction that you may authorize via digital means.</br><br> Kindly get back to us incase you did not provide the same.</br> <br> Kind Regards, </br><br> %1</br>';
        Subject: Text;
        TimeNow: Text;
        RecRef: RecordRef;
        PFact: Record "Product Factory";
        MemberApp: Record "Member Application";
        AccountApp: Record "Account Application";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        ProductCharges: Record "Loan Product Charges";
        KinDetails: Record "Next of KIN Application";
        DefaultAccApp: Record "Default Accounts Application";
        OnConfirmDialogMembTxt: Label 'Are you sure you want to create this member account?';
        MemberChanges: Record "Member Changes";
        SignatoryApp: Record "Signatory Application";
        Application: Record "Member Application";
        AccountFosa: Record "Account Banking";
        AccountBosa: Record "Account Credit";
        AccFosa: Record "Account Banking";
        AccBosa: Record "Account Credit";
        Custmember: Record Member;
        LoanApplic: Record "Loan Application";
        RecLoanApplic: Record "Loan Application";
        LoanSec: Record "Loan Guarantors and Security";
        Aggreement: Record "Loan Guarantors and Security";
        RecLoan: Record Loans;
        Loan: Record Loans;
        RepaySchedule: Report "Repayment Schedule-Loans";
        RecovHeader: Record "Recovery Header";
        PLoanCat: Record "Loans Categorization";
        DefaulterNotice: Report "Defaulter Notice-3";
        LoansCategory: Record "Loans Categorization";
        LoansCat: Record "Loans Categorization";
        CustMemb: Record Member;
        Acclosure: Record "Membership closure";
        HtmlLinks: Label '<p style="font-family:Verdana,Arial;font-size:9pt">Click here %1 for the New Members Guide.<br>Click here %2 for our Bank Details<br>Click here %3 for the Mobile Banking application form.<br>Click here %4 for the Junior Account application form.<br></p>';
        HyperText: array[7] of Text[250];
        Acchange: Record "Member Changes";
        BlobText: Text;
        SheduleOfRepayment: Report "Repayment Schedule Application";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Member Application":
                begin

                    RecRef.SetTable(MemberApp);
                    CompanyInfo.Get();

                    Case ActionItem of
                        0:
                            begin

                                Application.Reset();
                                Application.SetRange("No.", MemberApp."No.");
                                if Application.FindFirst() then begin
                                    Receipient.Add(Application."E-Mail");
                                    Subject := 'MEMBERSHIP APPLICATION';
                                    EmailBody := StrSubstNo(HtmlBody, Application.Name, DocNo, CompanyInfo.Name);
                                    EmailMessage.Create(Receipient, Subject, EmailBody, true);
                                    Email.Send(EmailMessage);
                                end;
                            end;
                        1:
                            begin
                                Application.Reset();
                                Application.SetRange("No.", MemberApp."No.");
                                if Application.Find('-') then begin
                                    Receipient.Add(Application."E-Mail");
                                    Subject := 'INDEMINITY ACKNOWLEDGEMENT';
                                    EmailBody := StrSubstNo(HtmlIdemnityBody, Application.Name, CompanyInfo.Name);
                                    EmailMessage.Create(Application."E-Mail", Subject, EmailBody);
                                    Email.Send(EmailMessage);
                                end;
                            end;
                    end;
                    Variant := MemberApp
                end;
            Database::"Account Banking":
                begin
                    RecRef.SetTable(AccountFosa);
                    AccFosa.Reset();
                    AccFosa.SetRange("No.", AccountFosa."No.");
                    if AccFosa.FindFirst() then begin
                        if Custmemb.Get(AccFosa."Member No.") then
                            Receipient.Add(Custmemb."E-Mail");
                        Subject := 'ACCOUNT DORMANCY';
                        EmailBody := StrSubstNo('Dear ' + CustMemb."First Name" + ' your Fosa account is Dormant. Kindly contact us via info@unsacco.org or +2540207622700 for reactivation.', AccFosa.Name, CompanyInfo.Name);
                        EmailMessage.Create(CustMemb."E-Mail", Subject, EmailBody);
                        Email.Send(EmailMessage);
                    end;
                    Variant := AccountFosa
                end;

            Database::"Account Credit":
                begin
                    RecRef.SetTable(AccountBosa);
                    AccBosa.Reset();
                    AccBosa.SetRange("No.", AccountBosa."No.");
                    if AccBosa.FindFirst() then begin
                        if Custmember.Get(AccBosa."Member No.") then
                            Receipient.Add(Custmember."E-Mail");
                        Subject := 'ACCOUNT DORMANCY';
                        EmailBody := StrSubstNo('Dear ' + Custmember."First Name" + ' your Deposits Account is Dormant. Kindly contact us via info@unsacco.org or +2540207629900 for reactivation.', AccBosa.Name, CompanyInfo.Name);
                        EmailMessage.Create(Custmember."E-Mail", Subject, EmailBody);
                        Email.Send(EmailMessage);
                    end;
                    Variant := AccountBosa
                end;

            Database::"Membership closure":
                begin
                    RecRef.SetTable(Acclosure);
                    HyperText[1] := 'https://www.ubora.org/index.php/downloads?download=196:membership-application-form';
                    Hyperlink(HyperText[1]);
                    if Custmember.Get(Acclosure."Member No.") then begin
                        Receipient.Add(Custmember."E-Mail");
                        Subject := 'ACCOUNT WITHDRAWAL';
                        EmailBody := StrSubstNo('Dear ' + Custmember."First Name" + ', your membership withdrawal has been processed. Consider rejoining through ' + HyperText[1], Custmember.Name, CompanyInfo.Name);
                        EmailMessage.Create(Custmember."E-Mail", Subject, EmailBody);
                        Email.Send(EmailMessage);
                    end;
                    Variant := Acclosure
                end;

            Database::"Member Changes":
                begin
                    RecRef.SetTable(Acchange);
                    gensetup.Get();
                    BlobText := format(gensetup."Acivation Message");
                    HyperText[1] := 'https://www.ubora.org/index.php/downloads?download=196:membership-application-form';
                    Hyperlink(HyperText[1]);
                    if Custmember.Get(Acchange."Member No.") then begin
                        Receipient.Add(Custmember."E-Mail");
                        Subject := 'ACCOUNT ACTIVATION';
                        EmailBody := StrSubstNo('Dear ' + Custmember."First Name" + ', Welcome back to Sacco.Your member number is. ' + Acchange."Member No." + '.' + BlobText + HyperText[1], Custmember.Name, CompanyInfo.Name);
                        EmailMessage.Create(Custmember."E-Mail", Subject, EmailBody);
                        Email.Send(EmailMessage);
                    end;

                    Variant := Acchange
                end;

            Database::"Loan Application":
                begin

                    RecRef.SetTable(RecLoanApplic);
                    CompanyInfo.Get();

                    LoanApplic.Reset();
                    LoanApplic.SetRange("No.", RecLoanApplic."No.");
                    if LoanApplic.FindFirst() then begin

                        if Custmember.Get(LoanApplic."Account No.") then begin
                            if Custmember."E-Mail" <> '' then begin
                                Receipient.Add(Custmember."E-Mail");
                                Subject := 'LOAN APPLICATION';

                                FileName := gensetup."Email Attachment Path" + LoanApplic."No." + '-' + LoanApplic."Account No." + '.pdf';
                                EmailBody := StrSubstNo(LoanapplicHtmlBody, LoanApplic."Account Name", LoanApplic."Product Description",
                                Format(LoanApplic."Approved Amount"), Format(LoanApplic.Installments), Format(LoanApplic."Approved Amount"),
                                Format(LoanApplic."Interest Rate"), Format(LoanApplic.Repayment), CompanyInfo.Name);
                                EmailMessage.Create(Receipient, Subject, EmailBody, true);
                                Email.Send(EmailMessage);

                                /* Clear(SheduleOfRepayment);
                                SheduleOfRepayment.SetTableView(LoanApplic);
                                TempBlob.CreateOutStream(AttachOutstr);
                                if  SheduleOfRepayment.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                                    TempBlob.CreateInStream(AttachInstr);
                                    Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                                    EmailMessage.AddAttachment(FileName, 'application/pdf', Base64Txt);
                                    Email.Send(EmailMessage);
                                end; */
                            end;
                        end
                    end;

                    Variant := RecLoanApplic
                end;

            Database::Loans:
                begin
                    RecRef.SetTable(RecLoan);

                    Loan.Reset();
                    Loan.SetRange("No.", RecLoan."No.");
                    if Loan.FindFirst() then begin
                        if Custmember.Get(Loan."Account No.") then
                            Receipient.Add(Custmember."E-Mail");
                        Subject := 'Loan Disbursement';
                        FileName := gensetup."Email Attachment Path" + Loan."No." + '-' + Loan."Account No." + '.pdf';
                        EmailBody := StrSubstNo(LoanPostedEmailBody, Loan."Account Name", Format(Loan."Approved Amount"), Format(Loan.Installments), Format(Loan."Interest Rate"));
                        EmailMessage.Create(Receipient, Subject, EmailBody, true);
                        Email.Send(EmailMessage);
                    end;
                    Variant := RecLoan
                end;

            Database::"Loan Guarantors and Security":
                begin
                    RecRef.SetTable(LoanSec);
                    Aggreement.Reset();
                    Aggreement.SetRange("No.", LoanSec."No.");
                    if Aggreement.FindFirst() then begin
                        if Custmember.Get(LoanSec."Member No.") then
                            Receipient.Add(Custmember."E-Mail");
                        Subject := 'Guarantor Notification';
                        if LoanApplic.Get(Aggreement."No.") then
                            EmailBody := StrSubstNo('Dear Member, you have guaranteed ' + LoanApplic."Account Name" + ' .Kindly Call ************ if in dispute.', AccBosa.Name, CompanyInfo.Name);
                        EmailMessage.Create(Custmember."E-Mail", Subject, EmailBody);
                        Email.Send(EmailMessage);
                    end;
                    Variant := LoanSec
                end;
            Database::"Loans Categorization":
                begin
                    RecRef.SetTable(LoansCategory);
                    if Custmember.Get(LoansCategory."Account No.") then
                        if Custmember."E-Mail" <> '' then begin
                            Receipient.Add(Custmember."E-Mail");
                            Subject := 'Defaulter Notification';
                            EmailBody := StrSubstNo('Dear Member, your ' + LoansCategory."Product Description" +
                             ' loan is in arrears of Kshs.' + Format(LoansCategory."Amount In Arrears") +
                             '. Pay your loan by today to avoid Penalty and negative listing on CRB.', AccBosa.Name, CompanyInfo.Name);
                            EmailMessage.Create(Custmember."E-Mail", Subject, EmailBody);
                            Email.Send(EmailMessage);
                        end;
                    Variant := LoansCategory
                end;
            Database::"Recovery Header":
                begin
                    RecRef.SetTable(RecovHeader);
                    PLoanCat.Reset();
                    PLoanCat.SetRange("No.", RecovHeader."Loan No.");
                    if PLoanCat.FindFirst() then begin

                        if Custmember.Get(RecovHeader."Account No.") then
                            CreateSmsNotif(NotifSource::"Loan defaulted", Custmember."Mobile Phone No",
                               'Defaulter Notice alert. Kindly check your email for more Details.', RecovHeader."No.",
                                  Custmember."No.", false);

                        Receipient.Add(Custmember."E-Mail");
                        Subject := 'Defaulter Notice';
                        FileName := gensetup."Email Attachment Path" + PLoanCat."No." + '-' + PLoanCat."Account No." + '.pdf';
                        EmailBody := StrSubstNo('Dear Member ', PLoanCat."Account Name", 'The above subject refers.');
                        EmailMessage.Create(Receipient, Subject, EmailBody, true);

                        Clear(DefaulterNotice);
                        DefaulterNotice.SetTableView(PLoanCat);
                        TempBlob.CreateOutStream(AttachOutstr);
                        if DefaulterNotice.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                            TempBlob.CreateInStream(AttachInstr);
                            Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                            EmailMessage.AddAttachment(FileName, 'DefaulterNotice/pdf', Base64Txt);
                            Email.Send(EmailMessage);
                        end;
                    end;

                    Variant := RecovHeader;
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end

    end;


}




