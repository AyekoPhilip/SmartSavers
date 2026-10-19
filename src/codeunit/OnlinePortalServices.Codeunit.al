codeunit 90002 "Online Portal Services"
{
    Permissions = tabledata "Approval Entry" = rimd;

    trigger OnRun()
    var
        P9txt: Text;
    begin

    end;

    var
        ApprovalEntry: Record "Approval Entry";
        LeaveApplication: Record "Hr Leave Mgt.";
        CashManagementSetup: Record "Cash Management Setups";
        Employee: Record Employee;
        ErrorMsg: Text;
        AltChannelPortalMgt: Codeunit "Alt. Channel Portal Mngt.";

    procedure GetEmpIDFromUserID(UserCode: Code[100]): Code[50]
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserCode) then
            exit(UserSetup."Employee No.")
        else
            exit('');
    end;

    procedure GetFileExtension(FileName: Text)
    var
        FileMgt: Codeunit "File Management";
    begin
        FileMgt.GetExtension(FileName);
    end;

    procedure GetUserIDFromEmpID(EmpID: Code[100]): Code[50]
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        UserSetup.SetRange("Employee No.", EmpID);
        if UserSetup.FindFirst() then
            exit(UserSetup."User ID");
    end;

    procedure LeaveExists(EmpNo: Code[50]) Msg: Text
    var
        LeaveApp: Record "Hr Leave Mgt.";
    begin
        //This function just checks for unutilized open leave docs
        LeaveApp.Reset();
        LeaveApp.SetRange(LeaveApp."Approval Status", LeaveApp."Approval Status"::Open);
        LeaveApp.SetRange(LeaveApp."Applicant Staff No.", EmpNo);
        if LeaveApp.Find('-') then begin
            if LeaveApp.Count > 0 then begin
                Msg := 'There are still some untilized Leave Application Documents [ ' + LeaveApp."Applicant Staff No." + ' ]. Please utilise them first';
            end;
        end;
        exit(Msg);
    end;

    procedure PrintLeave(AppCode: Code[50]; Path: Text): Text
    var
        filename: Text;
    begin
        LeaveApplication.Get(AppCode);

        filename := Path + 'Leave_' + AppCode + '-' + LeaveApplication."Applicant Staff No." + '.pdf';

        LeaveApplication.Reset();
        LeaveApplication.SetFilter(LeaveApplication."No.", AppCode);
        if LeaveApplication.Find('-') then begin
            //LeaveReport.SetTableView(LeaveApplication);
            //LeaveReport.SaveAsPdf(filename);
        end;
        exit('Leave_' + AppCode + '-' + LeaveApplication."Applicant Staff No." + '.pdf');
    end;

    /* procedure PrintP9(EmployeeNo: Code[50]; Path: Text; Year: Integer; var P9Base64Txt: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        P9Instream: InStream;
        P9Outstream: OutStream;
        DateText: Text;
        filename: Text;
        NewDateText: Text;
        NewTimeText: Text;
        TimeText: Text;
        StartDate, EndDate : Date;
    begin
        filename := Path + 'P9_' + EmployeeNo + '.pdf';

        StartDate := DMY2Date(1, 1, Year);
        EndDate := DMY2Date(31, 12, Year);

        Employee.Reset();
        Employee.SetRange("No.", EmployeeNo);
        //Employee.SetFilter(StartDate,EndDate);
        if Employee.Find('-') then begin
            P9.GetDefaults(StartDate, EndDate);

            P9.SetTableView(Employee);
            TempBlob.CreateOutStream(P9Outstream);
            if P9.SaveAs('', ReportFormat::Pdf, P9Outstream) then begin
                TempBlob.CreateInStream(P9Instream);
                P9Base64Txt := Base64Convert.ToBase64(P9Instream);
            end;
        end;
    end; */

    procedure RejectRequest(DocumentNo: Code[20]; ApproverID: Code[30])
    var
        AppMgt: Codeunit "Approvals Mgmt.";
    begin
        SetApprovalFilters(DocumentNo, ApproverID);
        AppMgt.RejectApprovalRequests(ApprovalEntry);
    end;

  /*   procedure SendLeaveApproval(DocNo: Code[50])
    var
        HRMgt: Codeunit "HR Management";
    begin
        LeaveApplication.Get(DocNo);

        HRMgt.CheckIfLeaveRelieversExist(LeaveApplication);
        if ApprovalMgt.CheckLeaveRequestWorkflowEnabled(LeaveApplication) then
            ApprovalMgt.OnSendLeaveRequestApproval(LeaveApplication);
        UpdateApprovalEntries(DocNo, LeaveApplication."User ID");
    end; */

   /*  procedure SendLoanApproval(DocNo: Code[50])
    begin
        LoanApplication.Get(DocNo);
        if ApprovalMgt.CheckLoanApplicationWorkflowEnabled(LoanApplication) then
            ApprovalMgt.OnSendLoanApplicationRequestforApproval(LoanApplication);
        UpdateApprovalEntries(DocNo, LoanApplication."User ID");
    end; */
    procedure UpdateApprovalEntries(DocNo: Code[100]; SenderID: Code[100])
    var
        ApprovalEntryRec: Record "Approval Entry";
    begin
        
        ApprovalEntryRec.Reset();
        ApprovalEntryRec.SetRange("Document No.", DocNo);
        ApprovalEntryRec.SetFilter(Status, '%1|%2', ApprovalEntryRec.Status::Created, ApprovalEntryRec.Status::Open);
        if ApprovalEntryRec.Find('-') then begin
            repeat
                ApprovalEntryRec."Sender ID" := SenderID;
                ApprovalEntryRec.Modify();
            until ApprovalEntryRec.Next() = 0;
        end;
    end;
    local procedure SetApprovalFilters(DocumentNo: Code[20]; ApproverID: Code[30])
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange("Approver ID", ApproverID);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
    end;

    
    /* procedure GetLeaveBalance(EmpNo: Code[50]; LeaveType: Code[50]) LeaveBalance: array[10] of Decimal
    var
        Employee: Record Employee;
        HRManagement: Codeunit "HR Management";
        LeavePeriod: Code[50];
        LeaveEarnedToDate: Decimal;
    begin
        LeavePeriod := HRManagement.GetCurrentLeavePeriodCode();

        Employee.Get(EmpNo);
        Employee.SetRange("Leave Period Filter", LeavePeriod);
        Employee.SetRange("Leave Type Filter", LeaveType);
        Employee.CalcFields("Leave Balance", "Leave Recall Days", "Days Absent", "Leave Balance Brought Forward", "Leave Days Taken", "Leave Entitlement");

        LeaveEarnedToDate := HRManagement.GetLeaveDaysEarnedToDate(Employee, LeaveType);

        LeaveBalance[1] := Employee."Leave Balance";
        LeaveBalance[2] := Employee."Leave Balance Brought Forward";
        LeaveBalance[3] := Employee."Days Absent";
        LeaveBalance[4] := Employee."Leave Recall Days";
        LeaveBalance[5] := Employee."Leave Entitlement";
        LeaveBalance[6] := Employee."Leave Days Taken";
        LeaveBalance[7] := LeaveEarnedToDate;
    end;
 */
    procedure GetEmployeePicture(EmpNo: Code[50]) ImageBase64: Text
    var
        Employee: Record Employee;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        PicInstream: InStream;
        PicOutStream: OutStream;
    begin
        Employee.Get(EmpNo);
        if Employee.Image.HasValue then begin
            TempBlob.CreateInStream(PicInstream);
            TempBlob.CreateOutStream(PicOutStream);
            Employee.Image.ExportStream(PicOutStream);
            CopyStream(PicOutStream, PicInstream);
            ImageBase64 := Base64Convert.ToBase64(PicInstream);
            exit(ImageBase64);
        end;
    end;

    procedure EmployeePhoto(StaffNo: Code[20]; VAR PictureText: text)
    var
        Employee: record Employee;
        Media: Record "Tenant Media";
        Base64: Codeunit "Base64 Convert";
        InStream: InStream;
    begin
        Employee.GET(StaffNo);
        if Media.Get(Employee.Image.MediaId) then begin
            Media.calcfields(Content);
            Media.Content.CreateInStream(InStream, TextEncoding::Windows);
            PictureText := Base64.ToBase64(InStream);
        end;
    end;

    procedure PrintFullMemberStatement(MemberNo: Code[20]; FromDate: Date; ToDate: Date; Path: Text; var Base64Txt: Text): Boolean
    var
        Member: Record Member;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        StatementOutstream: OutStream;
        filename: Text;
        StatementOfAccount: Report "Standard Statement-All Account";
    begin
        filename := Path + 'Statement_' + '-' + MemberNo + '.pdf';
        Member.Reset();
        Member.SetRange("No.", MemberNo);
        if Member.FindFirst() then begin
            StatementOfAccount.SetTableView(Member);
            StatementOfAccount.GetDefaults(FromDate, ToDate);
            TempBlob.CreateOutStream(StatementOutstream);
            if StatementOfAccount.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                TempBlob.CreateInStream(StatementInstream);
                Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
            end;
        end;
    end;


    procedure LoansQuaranteed(MemberNo: Code[20]; Path: Text; var Base64Txt: Text): Boolean

    var

        Member: Record Member;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        ReportInstream: InStream;
        ReportOutstream: OutStream;
        filename: Text;
        LoansQuaranteed: Report "Member Loan Guaranteed";

    begin
        filename := Path + 'LoansQuaranteed_' + '-' + MemberNo + '.pdf';
        Member.Reset();
        Member.SetRange("No.", MemberNo);
        if Member.FindFirst() then begin
            LoansQuaranteed.SetTableView(Member);
            TempBlob.CreateOutStream(ReportOutstream);
            if LoansQuaranteed.SaveAs('', ReportFormat::Pdf, ReportOutstream) then begin
                TempBlob.CreateInStream(ReportInstream);
                Base64Txt := Base64Convert.ToBase64(ReportInstream, true);
            end;
        end;

    end;

    procedure LoansQuarantors(MemberNo: Code[20]; Path: Text; var Base64Txt: Text): Boolean

    var

        Member: Record Member;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        ReportInstream: InStream;
        ReportOutstream: OutStream;
        filename: Text;
        Loans: Record Loans;
        LoansQuarantors: Report "Member Loan Guarantors";

    begin
        filename := Path + 'LoansQuarantors_' + '-' + MemberNo + '.pdf';
        Loans.Reset();
        Loans.SetRange("Account No.", MemberNo);
        if Loans.Find('-') then begin
            LoansQuarantors.SetTableView(Loans);
            TempBlob.CreateOutStream(ReportOutstream);
            if LoansQuarantors.SaveAs('', ReportFormat::Pdf, ReportOutstream) then begin
                TempBlob.CreateInStream(ReportInstream);
                Base64Txt := Base64Convert.ToBase64(ReportInstream, true);
            end;
        end;

    end;

    procedure PrintLoanStatement(MemberNo: Code[20]; FromDate: Date; ToDate: Date; Path: Text; var Base64Txt: Text): Boolean
    var
        Member: Record Member;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        StatementOutstream: OutStream;
        filename: Text;
        StatementOfAccount: Report "Statement-Loans";
    begin
        filename := Path + 'Statement_' + '-' + MemberNo + '.pdf';
        Member.Reset();
        Member.SetRange("No.", MemberNo);
        if Member.FindFirst() then begin
            StatementOfAccount.SetTableView(Member);
            //StatementOfAccount.GetDefaults(FromDate, ToDate);
            TempBlob.CreateOutStream(StatementOutstream);
            if StatementOfAccount.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                TempBlob.CreateInStream(StatementInstream);
                Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
            end;
        end;
    end;

    procedure getCustDividendSlip(MemberNo: Code[20]; Path: Text; var Base64Txt: Text): Boolean
    var
        Member: Record "Dividend Progression";
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        StatementOutstream: OutStream;
        filename: Text;
        DividendSlip: Report "Dividend Slip";
        Dividendsetup: Record "Dividend SetUp";
        InterestOptions: Enum "Rcv12 Dividend Interest Option";
        DivProcMgt: Codeunit "Dividend Process";
    begin

        Dividendsetup.Get();
        Dividendsetup.TestField("Start Date");
        Dividendsetup.TestField("End Date");
        InterestOptions := InterestOptions::"Daily Basis";

       // DivProcMgt.fngetIndividualCustDiv(MemberNo, 0, Dividendsetup."Start Date", Dividendsetup."End Date", InterestOptions);

        filename := Path + 'DividendSlip_' + '-' + MemberNo + '.pdf';
        Member.Reset();
        Member.SetRange("Member No", MemberNo);
        Member.SetRange("Header No.", 'ALTC/' + Format(Dividendsetup."Start Date"));
        if Member.Find('-') then begin

            Commit();

            DividendSlip.SetTableView(Member);
            TempBlob.CreateOutStream(StatementOutstream);
            if DividendSlip.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                TempBlob.CreateInStream(StatementInstream);
                Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
            end;
        end;
    end;

    procedure WebLoanApplication(ApplicNo: code[100]; MemberNo: Code[100]; ProductType: Code[20]; AmountApplied: Decimal) Response: Text[150]
    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        PFactory: Record "Product Factory";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        RegMngt: Codeunit "Register Management";
        AccountTypes: Record "Product Factory";
        Post: Codeunit "Mngt. Post Alt. Channels";
        TransCharges: Record "Transaction Charge";
        TransTypes: Record "Transaction Types";
        TellerTransType: Enum TellerTypes;
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        RegmntAcc: Record "Account (Procedure)";
        LnPortal: Record "Loan Application-Portal";
    begin
        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Capital");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");

                if AccountTypes.Get(AccCredit."Product Type") then begin
                    if AccCredit."Balance (LCY)" < AccountTypes."Minimum Balance" then
                        Response := '99|Member has not attained Minimum share capital of KES 50,000';
                    exit(Response)
                end;
            end;

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");
                if AccCredit."Balance (LCY)" > 0 then begin

                    LnPortal.Init();
                    LnPortal."No." := '';
                    LnPortal.Validate("Application No.", ApplicNo);
                    LnPortal.Validate("Account No.", MemberNo);
                    LnPortal.Validate("Product Type", ProductType);
                    LnPortal.Validate("Requested Amount", AmountApplied);
                    LnPortal.Source := LnPortal.Source::Credit;
                    LnPortal."Application Source" := LnPortal."Application Source"::Web;
                    LnPortal."Application Type" := LnPortal."Application Type"::Normal;
                    LnPortal.Insert(true);

                    LnPortal.Reset();
                    LnPortal.SetRange("Application No.", ApplicNo);
                    if LnPortal.FindFirst() then begin
                        Response := '00|Success|' + LnPortal."Application No.";
                        exit(Response)
                    end;

                end else begin
                    Response := '99|Member does not have shares';
                    exit(Response)
                end;
            end else begin
                Response := '99|Account not Found';
                exit(Response)

            end;

        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;

    procedure getguarantorInfo(ApplicNo: Code[100]; MemberNo: Code[100]) Response: Text[150]
    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        PFactory: Record "Product Factory";
        AccountTypes: Record "Product Factory";
        LnPortal: Record "Loan Application-Portal";
        Agreement: Record "Loan Agreement-Portal";
    begin

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");
                if AccCredit."Balance (LCY)" > 0 then begin

                    LnPortal.Reset();
                    LnPortal.SetRange("Application No.", ApplicNo);
                    if LnPortal.FindFirst() then begin
                        Agreement.Init();
                        Agreement."No." := LnPortal."No.";
                        Agreement."Loan No." := LnPortal."Application No.";
                        Agreement.Validate("Account No.", AccCredit."No.");
                        Agreement.Insert(true);
                        Agreement.Reset();
                        Agreement.SetRange("Loan No.", LnPortal."Application No.");
                        if Agreement.FindFirst() then begin
                            Response := '00|Success|' + Agreement."Loan No.";
                            exit(Response)

                        end;
                    end;
                end;
            end else begin
                Response := '99|Member does not have shares';
                exit(Response)
            end;

        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;

}

