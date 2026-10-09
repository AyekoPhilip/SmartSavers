namespace DynamicsNav.SaccoDatabase;

using Microsoft.Finance.GeneralLedger.Posting;
using DynamicsNav.SaccoDatabase.HrManagementMgt;
using DynamicsNav.DynamicsNav;
using Microsoft.Finance.GeneralLedger.Ledger;
using System.Security.User;
using Microsoft.Finance.GeneralLedger.Reversal;
codeunit 50008 "Purch.-Post. (Yes/No)"
{

    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        CurrencyFactor: Decimal;
        NextEntryNo: Integer;
        NextTransactionNo: Integer;
        GLSourceCode: Code[10];
        ResponseTxt: Integer;
        GeneralSetUp: Record "General Set-Up";
        DcPostMgt: Codeunit "Doc-PostMgt";
        CredJnlMgt: Codeunit "Credit. Jnl.-Post Batch";
        PostPckgt: Codeunit "Rcv11 Post. Mgnt. A/c Closure ";
        TempGLEntryBuf: Record "G/L Entry" temporary;
        ProgressWindow: Dialog;
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        OncompleterecordretrievalTxt: Label 'Process Complete successfully on  %1';
        OnconfirmRecordretrieval: Label 'This process will restore a previously archived loan account. Do you want to contiune?';
        StatusChange: Record "Status Change Permissions";
        DoctMngt: Codeunit "Doc. Mngt";
        Temp: Record "User Setup";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';

    [EventSubscriber(ObjectType::Table, Database::"Loan Application", 'OnBeforeDocPostMgtLoanRegistration', '', false, false)]
    procedure OnAfterDocPostMgtLoanRegistration(var LoanLine: Record "Loan Application"; CallingFieldNo: Integer)
    begin
        LoanLine.CheckMinRequirementApprovals();
        LoanLine.TestField("Approval Status", LoanLine."Approval Status"::Approved);
        GeneralSetUp.Get();
        GeneralSetUp.TestField("Post Loan As");
        if Confirm(OnConfirmDialogTxt, true) = false then
            exit;
        case GeneralSetUp."Post Loan As" of
            GeneralSetUp."Post Loan As"::"Create as User":
                begin
                    DcPostMgt.LoanRegistration(LoanLine, 1)
                end;
        end
    end;

    [EventSubscriber(ObjectType::Table, Database::"Checkoff Header", 'OnBeforePerformPostOnCheckoffHeader', '', false, false)]

    local procedure OnAfterPerformPostOnCheckoffHeaderYesNo(var RecRef: Record "Checkoff Header"; CallingFieldNo: Integer)
    begin
        if Confirm(OnConfirmDialogTxt, true) = false then
            exit;
        Codeunit.Run(Codeunit::"Post. Checkoff Mngt.", RecRef)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Interest Header", 'OnBeforeReverseEntriesOnPostInt', '', false, false)]
    local procedure OnAfterReverseEntriesOnPostInt(var RecRef: Record "Interest Header"; CallingFieldNo: Integer)
    begin
        CredJnlMgt.CreateReverseLine(RecRef."No.", Enum::BatchPaymentType::Interest, '', '',
        RecRef."Shortcut Dimension 1 Code", RecRef."Shortcut Dimension 2 Code", Enum::BCObjectTypes::System);
    end;

    [EventSubscriber(ObjectType::Table, Database::Loans, 'OnBeforeValidatePerformPostOnLoansPostMgt', '', false, false)]
    local procedure OnAfterValidatePerformPostOnLoansPostMgt(var RecRef: Record Loans; CallingFieldNo: Integer)
    begin

        case RecRef."Application Type" of
            RecRef."Application Type"::Normal,
            RecRef."Application Type"::"Loan Restructure":
                begin
                    ResponseTxt := 0;
                    ResponseTxt := ConfirmPost(Enum::CustomApprovalEntriesDocType::Loans);
                    case ResponseTxt of
                        2:
                            RecRef."Check Line" := true;
                        else
                            RecRef."Check Line" := false;
                    end;
                    RecRef.Modify(true);
                    if ResponseTxt > 0 then begin
                        Codeunit.Run(Codeunit::"Loan Post Mngt. (Yes/No)", RecRef);
                    end else
                        exit;
                end;
            RecRef."Application Type"::Mobile:
                Error('Case condition %1 not implemented.', RecRef."Application Type"::Mobile);
            RecRef."Application Type"::Defaulter:
                Error('Case condition %1 not implemented.', RecRef."Application Type"::Defaulter);
            RecRef."Application Type"::"Loan Calculator":
                Error('Case condition %1 not implemented.', RecRef."Application Type"::"Loan Calculator");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Checkoff Header", 'OnBeforeReverseEntriesOnPostHeader', '', false, false)]

    local procedure OnBeforeReverseEntriesOnPostHeaderYesNo(var RecRef: Record "Checkoff Header"; CallingFieldNo: Integer)
    begin
        CredJnlMgt.CreateReverseLine(RecRef."No.", Enum::BatchPaymentType::" ", '', '', RecRef."Shortcut Dimension 1 Code",
        RecRef."Shortcut Dimension 2 Code", Enum::BCObjectTypes::Execution);
    end;

    [EventSubscriber(ObjectType::Table, Database::Loans, 'OnBeforePrintDocument', '', false, false)]
    procedure OnBeforePrintDocument(var RecRef: Record Loans; xRecRef: Record Loans; var IsHandled: Boolean)
    var
        DocMngt: Codeunit "Doc. Mngt";
        LoanApplic: Record "Loan Application";
        AppraisalParameter: Record "Loan Appraisal Parameter";
        ApprslParameter: Record "Loan Appraisal Parameter";
        Prdfact: Record "Product Factory";
    begin
        if RecRef."Application No." <> '' then begin

            AppraisalParameter.Reset;
            AppraisalParameter.SetRange("No.", RecRef."Application No.");
            if AppraisalParameter.Find('-') then begin
                AppraisalParameter."Loan No." := RecRef."No.";
                AppraisalParameter.Modify(true);
                Commit();

                ApprslParameter.Reset;
                ApprslParameter.SetRange("Loan No.", RecRef."No.");
                if ApprslParameter.Find('-') then begin
                    ApprslParameter."Loan No." := RecRef."No.";

                    if Prdfact.Get(ApprslParameter."Product Type") then begin
                        case Prdfact."Product Dimension" of
                            Prdfact."Product Dimension"::Account:
                                begin
                                    Report.Run(Report::"Loan Appraisal Parameter-IESA", true, true, ApprslParameter);
                                end;
                            Prdfact."Product Dimension"::Credit,
                            Prdfact."Product Dimension"::"Micro Credit":
                                begin
                                    Report.Run(Report::"Loan Appraisal Parameters", true, true, ApprslParameter);
                                end;
                        end;
                    end;
                end;
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Loans-Closed Account", 'OnRetrieveRecord', '', false, false)]
    procedure OnAfterRetrieveRecord(var RecRef: Record "Loans-Closed Account"; xRecRef: Record "Loans-Closed Account"; IsHandled: Boolean)
    var
        Ploans: Record Loans;
        NewLoan: Record Loans;
        NewclosedAcc: Record "Loans-Closed Account";
    begin
        if Confirm(OnconfirmRecordretrieval, true) = false then
            exit;

        Ploans.Init();
        Ploans.TransferFields(RecRef);
        Ploans.Insert(true);

        NewLoan.Reset();
        NewLoan.SetRange("No.", Ploans."No.");
        if NewLoan.FindFirst() then begin
            NewclosedAcc.Reset();
            NewclosedAcc.SetRange("No.", NewLoan."No.");
            if NewclosedAcc.FindFirst() then begin
                NewclosedAcc.Delete();
                Message(OncompleterecordretrievalTxt, NewLoan."No.");
            end
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Hr Employees", 'OnBeforeOnValidate', '', false, false)]
    local procedure OnBeforeOnValidate(var Rec: Record "Hr Employees"; var xRec: Record "Hr Employees"; IsHandled: Boolean)
    var
        objPeriod: Record "Pr Payroll Period";
        SelectedPeriod: Date;
        HrEmployee: Record "HR Employees";
        ResponseTxt: Integer;
        PayrollPostMgt: Codeunit "Payroll Post Mngt.";
        SalCard: Record "Pr Salary Card";
        PrsalCard: Record "Pr Salary Card";
        PayrollDialog: Label 'Processing Salary for Employee No. #1#######';
        OnCompleteDialogTxt: Label 'Payroll processing completed successfully.';

    begin

        ResponseTxt := 0;
        ResponseTxt := ConfirmPost(Enum::CustomApprovalEntriesDocType::"Hr Employee");
        case ResponseTxt of
            0:
                Error('Invalid Selection');
            1:
                Codeunit.Run(Codeunit::"Payroll Post Mngt.", Rec);
            2:
                begin

                    objPeriod.Reset();
                    objPeriod.SetRange(Closed, false);
                    if objPeriod.FindFirst() then
                        SelectedPeriod := objPeriod."Date Opened";

                    HrEmployee.Reset();
                    HrEmployee.SetRange(Status, HrEmployee.Status::Active);
                    HrEmployee.SetRange("Approval Status", HrEmployee."Approval Status"::Approved);
                    if HrEmployee.FindSet() then begin
                        ProgressWindow.Open(PayrollDialog);
                        repeat
                            HrEmployee.TestField("Date of Join");
                            Sleep(100);

                            SalCard.Reset();
                            SalCard.SetRange("Suspend Pay", false);
                            SalCard.SetRange("Employee Code", HrEmployee."No.");
                            if SalCard.FindFirst() then begin
                                PayrollPostMgt.fnProcesspayroll(HrEmployee."No.", HrEmployee."Date Of Join",
                                SalCard."Basic Pay", SalCard."Pays PAYE", SalCard."Pays NSSF", SalCard."Pays NHIF", SelectedPeriod, SelectedPeriod, '', '',
                                HrEmployee."Date Of Leaving", true, HrEmployee."Department Code", '', HrEmployee."Global Dimension 1 Code", HrEmployee."Global Dimension 2 Code", false);
                            end;
                            ProgressWindow.Update(1, HrEmployee."No." + '::' + HrEmployee.Name);
                        until HrEmployee.Next() = 0
                    end;
                    ProgressWindow.Close();

                    Commit();
                    PrsalCard.Reset();
                    PrsalCard.SetRange("Employee Code", Rec."No.");
                    PrsalCard.SetRange("Period Filter", SelectedPeriod);
                    if PrsalCard.FindFirst() then begin
                        Report.Run(Report::"Pr Individual Payslip", true, false, PrsalCard);
                    end;
                end
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Membership closure", 'OnBeforeOnValidateAccPost', '', false, false)]
    procedure OnBeforeOnValidateAccPost(var Rec: Record "Membership closure"; var xRec: Record "Membership closure"; IsHandled: Boolean; PrintPost: Boolean)
    begin
        Rec.CheckMinRequirement(1);
        ResponseTxt := 0;
        ResponseTxt := ConfirmPost(Enum::CustomApprovalEntriesDocType::Loans);
        case ResponseTxt of
            0:
                Error('Invalid Selection');
            1:
                Codeunit.Run(Codeunit::"Rcv11 Post. Mgnt. A/c Closure ", Rec);
            2:
                begin
                    PostPckgt.Post(Rec, PrintPost, IsHandled);
                end
        end
    end;

    local procedure ConfirmPost(DocType: Enum CustomApprovalEntriesDocType): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Generate Batch,&Post Application';
        ShipInvoiceQstPayroll: Label '&Process Current,&Process Payroll';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 2 then
            DefaultOption := 2;
        if DefaultOption <= 0 then
            DefaultOption := 0;

        case DocType of
            DocType::Loans:
                Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to Post');
            DocType::"Hr Employee":
                Selection := StrMenu(ShipInvoiceQstPayroll, DefaultOption, 'Please select option to Post');
        end;

        PassInt := Selection;

        if Selection = 0 then
            exit;
        exit(PassInt);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnBeforeReverseEntries', '', false, false)]
    procedure CheckUserForReversalEntry()
    begin
        Temp.Get(UserId);
        if not Temp."Post Reversals" then Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Reversal Entry", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;


}
