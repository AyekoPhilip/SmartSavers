namespace DynamicsNav.SaccoDatabase;

using Microsoft.Sales.Customer;
using DynamicsNav.DynamicsNav;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 90009 "Rcv11 Post. Mgnt. A/c Closure "
{
    TableNo = "Membership closure";

    trigger OnRun()
    begin
        Post(Rec, false, false);
    end;

    var

        AccountLine: Record "Account Closure Line";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        Temp: Record "Banking User Template";
        Loan: Record Loans;
        Account: Record "Account Banking";
        RunBal: Decimal;
        Member: Record Member;
        TotalLoan: Decimal;
        LineNo: Integer;
        AcctType: Enum "Gen. Journal Account Type";
        TransCharges: Record "Transaction Charge";
        gensetup: Record "General Set-Up";
        ProdFact: Record "Product Factory";
        BufferedInt: Decimal;
        Linterest: Decimal;
        LPrincipal: Decimal;
        Amt: array[5] of Decimal;
        AccBanking: Record "Account Banking";
        JournalLine: Record "Gen. Journal Line";
        MemClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        NotifSource: Enum NotifSourceType;
        HyperText: Text[250];
        Varvariant: Variant;
        Charges: Decimal;
        AmtPost: Decimal;
        AccruedInterest: Decimal;
        ExciseDuty: Decimal;
        NoticeRec: Record "Member withdrawal Notice";
        TotalAmt: Decimal;
        AppMngt: Codeunit "Approval Mgmt.";
        BosaAcc: Record "Account Credit";
        CustRec: Record Customer;
        StartDate: Date;
        PostingDate: Date;
        EndDate: Date;
        IntDays: Integer;
        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
        RegisterMngt: Codeunit "Register Management";
        PostCheckMgt: Codeunit "Post. Checkoff Mngt.";
        DocPostMgt: Codeunit "Doc-PostMgt";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        FosaAc: Record "Account Banking";
        MonthlyContrib: Record "Member Monthly Contribution";
        Externpayment: Record "External Payment";
        Purchline: Record "Account Closure Line";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        FundMgt: Codeunit "Funds. Post Mngt.";
        RepayAcc: Record "Repayment Account";
        LnPostYesNoMgt: Codeunit "Loan Post Mngt. (Yes/No)";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        ErrorOnCreditDebitLines: Label 'Total liabilities Amount of %1 cannot be more than the account Balance Of %2';
        ErrorOnCreditLines: Label 'Total credit Amount of %1 cannot be more than the account Balance Of %2';
        ErrorOnExistLoanApp: Label 'Member has an exiting Loan attached to this account';
        ErrorNoAccountFound: Label 'Posting Account not Found';

    local procedure InitJournaline()
    begin
        gensetup.Get;
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        JnlPostMngt.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;

    procedure Post(RecRef: Record "Membership closure"; PostPrint: Boolean; JournalPreview: Boolean)
    begin
        InitJournaline();
        RecRef.fnTestfields();
        RecRef.CalcFields("Total Amount (Charge)", "Total Amount (Liabilities)", "Total Amount (Net)");
        if RecRef."Total Amount (Net)" < (RecRef."Total Amount (Charge)" + RecRef."Total Amount (Liabilities)") then
            Error(ErrorOnCreditDebitLines, (RecRef."Total Amount (Charge)" + RecRef."Total Amount (Liabilities)"), RecRef."Total Amount (Net)");

        if AppMngt.CheckBlockedDocsOnJnls(RecRef."No.", Database::"Membership closure") then begin
            InitializePost(RecRef, JournalPreview);
            case JournalPreview of
                true:
                    FundMgt.fnJournalPreviewMngt(Enum::CustomApprovalEntriesDocType::"Account Closure", RecRef."No.", Jtemplate, JBatch);
                false:
                    begin
                        JnlPostMngt.CompletePosting(Jtemplate, JBatch);
                        case RecRef."Pay Mode" of
                            RecRef."Pay Mode"::Cheque:
                                begin
                                    RecRef.TestField("Rcv Cheque No");
                                    LnPostYesNoMgt.InitDebitBankingAcc(RegisterMngt.GetOperationAcc(
                                        Enum::ProductAccountCategory::Savings, RecRef."Member No.", 0),
                                        0, RecRef."No.", Today, Dim1, Dim2, Jtemplate, JBatch, RecRef."Paying Account No.",
                                        1000, RecRef."Rcv Cheque No");
                                end;
                        end;
                        FundMgt.OnCompletePostMgt(Enum::CustomApprovalEntriesDocType::"Account Closure", RecRef."No.");
                    end;
            end;

            if PostPrint then begin
                RecRef.Reset;
                RecRef.SetFilter("No.", RecRef."No.");
                Report.Run(Report::"Membership Closure Report", true, true, RecRef);
                RecRef.Reset;
            end;
        end;
    end;

    local procedure InitializePost(RecRef: Record "Membership closure"; JournalPreview: Boolean)
    begin
        InitJournaline();

        RecRef.CalcFields("Total Amount (Net)", "Total Amount (Charge)");
        PostingDate := Today;

        Purchline.Reset;
        Purchline.SetRange("No.", RecRef."No.");
        if Purchline.FindSet() then begin
            repeat

                Account.Reset();
                Account.SetRange("Member No.", RecRef."Member No.");
                Account.SetRange("Account Category", Account."Account Category"::Savings);
                if Account.FindFirst() then begin
                    Account.CalcFields("Balance (LCY)");

                    case Purchline."Product Class" of
                        Purchline."Product Class"::Account:
                            begin

                                AccBanking.Reset();
                                if AccBanking.Get(Purchline."Account No.") then begin
                                    AccBanking.CalcFields("Balance (LCY)");
                                    if AccBanking."Balance (LCY)" > 0 then begin

                                        LineNo := LineNo + 100;
                                        InitDebitCreditEntry(AccBanking."No.", AcctType::Vendor,
                                        AccBanking."Balance (LCY)", RecRef."No.", PostingDate, Dim1, Dim2,
                                        Jtemplate, JBatch, AcctType::"G/L Account", '', LineNo, RecRef."Rcv Cheque No",
                                        Format(RecRef."Document Type") + ' ' + Purchline."Account No.");

                                        LineNo := LineNo + 100;
                                        InitDebitCreditEntry(Account."No.", AcctType::Vendor,
                                        AccBanking."Balance (LCY)" * -1, RecRef."No.", PostingDate, Dim1, Dim2,
                                        Jtemplate, JBatch, AcctType::"G/L Account", '', LineNo, RecRef."Rcv Cheque No",
                                        Format(RecRef."Document Type") + ' ' + Purchline."Account No.");
                                    end else begin

                                    end;
                                end else begin

                                    Accredit.Reset();
                                    Accredit.SetRange("No.", Purchline."Account No.");
                                    if Accredit.FindFirst() then begin
                                        Accredit.CalcFields("Balance (LCY)");
                                        if Accredit."Balance (LCY)" > 0 then begin

                                            LineNo := LineNo + 100;
                                            InitDebitCreditEntry(Accredit."No.", AcctType::Customer,
                                            Accredit."Balance (LCY)", RecRef."No.", PostingDate, Dim1, Dim2,
                                            Jtemplate, JBatch, AcctType::"G/L Account", '', LineNo, RecRef."Rcv Cheque No",
                                            Format(RecRef."Document Type") + ' ' + Purchline."Account No.");

                                            LineNo := LineNo + 100;
                                            InitDebitCreditEntry(Account."No.", AcctType::Vendor,
                                            Accredit."Balance (LCY)" * -1, RecRef."No.", PostingDate, Dim1, Dim2,
                                            Jtemplate, JBatch, AcctType::"G/L Account", '', LineNo, RecRef."Rcv Cheque No",
                                            Format(RecRef."Document Type") + ' ' + Purchline."Account No.");
                                        end else begin

                                        end;
                                    end else
                                        Error(ErrorNoAccountFound);
                                end;
                            end;
                        Purchline."Product Class"::Loan:
                            begin
                                Loan.Reset();
                                Loan.SetRange("No.", Purchline."Loan No.");
                                Loan.SetFilter("Outstanding Balance", '>0');
                                if Loan.FindFirst() then begin
                                    Loan.CalcFields("Outstanding Balance");

                                    RepayAcc.SetRange("Member No.", RecRef."Member No.");
                                    RepayAcc.SetRange("Account Category", RepayAcc."Account Category"::Repayment);
                                    if RepayAcc.FindFirst() then begin

                                        LineNo := LineNo + 100;
                                        InitDebitCreditEntry(RepayAcc."No.", AcctType::Vendor,
                                        Loan."Outstanding Balance" * -1, RecRef."No.", PostingDate, Dim1, Dim2,
                                        Jtemplate, JBatch, AcctType::"G/L Account", '', LineNo, RecRef."Rcv Cheque No",
                                        Format(RecRef."Document Type") + ' - ' + Purchline."Loan No.");

                                        LineNo := LineNo + 100;
                                        InitDebitCreditEntry(Account."No.", AcctType::Vendor,
                                        Loan."Outstanding Balance", RecRef."No.", PostingDate, Dim1, Dim2,
                                        Jtemplate, JBatch, AcctType::"G/L Account", '', LineNo, RecRef."Rcv Cheque No",
                                        Format(RecRef."Document Type") + ' - ' + Purchline."Loan No.");
                                    end;

                                    CreateLoanEntry(Loan."No.", RepayAcc."No.", RecRef."No.", PostingDate,
                                    Loan."Outstanding Balance", RecRef."Member No.", LineNo + 100);
                                end else
                                    Error(ErrorNoAccountFound);
                            end;
                    end;
                end;
            until Purchline.Next() = 0;
        end;

        if RecRef."Transaction Type" <> '' then begin

            TellMngt.fnPostAccCharges(RecRef."Transaction Type",
            RegisterMngt.GetOperationAcc(Enum::ProductAccountCategory::Savings, RecRef."Member No.", 0),
            RecRef."Total Amount (Net)", Dim1, Dim2, Jtemplate, JBatch, RecRef."No.", PostingDate);
        end;

        if RecRef."Early Exit Charges" > 0 then begin

            ProdFact.Get(Account."Product Type");
            TellMngt.fnPostAccCharges(ProdFact."Closure Fee",
        RegisterMngt.GetOperationAcc(Enum::ProductAccountCategory::Savings, RecRef."Member No.", 0),
        RecRef."Total Amount (Net)", Dim1, Dim2, Jtemplate, JBatch, RecRef."No.", PostingDate);

        end;
    end;

    local procedure CreateLoanEntry(LoanNo: Code[100]; AccountNo: Code[100]; DocumentNo: Code[100]; Postingdate: Date; AmtPost: Decimal; MemberNo: Code[100]; Linenumber: Integer)
    begin
        RunBal := 0;
        RunBal := AmtPost;

        RepayAcc.SetRange("Member No.", MemberNo);
        RepayAcc.SetRange("Account Category", RepayAcc."Account Category"::Repayment);
        if RepayAcc.FindFirst() then begin

            Loan.Reset();
            Loan.SetRange("No.", LoanNo);
            Loan.SetFilter("Outstanding Balance", '>0');
            if Loan.FindFirst() then begin
                Loan.CalcFields("Outstanding Balance", "Outstanding Interest",
                "Outstanding Principal", "Outstanding Insurance");
                AccruedInterest := 0;

                case gensetup."Interest Posting Method" of
                    gensetup."Interest Posting Method"::"Charge Daily":
                        begin
                            AccruedInterest := PeriodActMngt.fnIntEntriesonSpecificLoan(Loan, Today, Loan."No.", 1, IntDays, Today)
                        end else begin
                        AccruedInterest := 0;
                    end;
                end;

                if AccruedInterest > 0 then begin

                    if ProdFact.Get(Loan."Product Type") then
                        LineNo := LineNo + 10078;
                    JnlPostMngt.PostJournal(Jtemplate, JBatch, LineNo, AcctType::Customer,
                    DocumentNo, Format(Enum::"LoanTransactionType"::"Interest Due") + '-' + Loan."No.",
                    AccountLine."Accrued Interest", Loan."Loan Account", Today, AcctType::"G/L Account",
                    ProdFact."Interest Account (G/L)", Account."Member No.", Temp."Shortcut Dimension 1 Code",
                    Temp."Shortcut Dimension 2 Code", Enum::"LoanTransactionType"::"Interest Due", Loan."No.", '', '',
                    Enum::"Gen. Journal Document Type"::" ", '', Enum::"Gen. Journal Document Type"::" ");

                end;

                if (Loan."Outstanding Interest" + AccruedInterest) > 0 then begin
                    if RunBal > 0 then begin

                        LineNo := LineNo + 10766;
                        JnlPostMngt.PostJournal(Jtemplate, JBatch,
                        LineNo, AcctType::Customer,
                        DocumentNo, Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + Loan."No.",
                        (Loan."Outstanding Interest" + AccruedInterest) * -1,
                        Loan."Loan Account", Today,
                        AcctType::"G/L Account",
                        '', Account."Member No.",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code",
                        Enum::"LoanTransactionType"::"Interest Paid", Loan."No.", '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");

                        LineNo := LineNo + 10089;
                        PostCheckMgt.CreateBalancingRepayAcc(LineNo, Jtemplate, JBatch,
                        Dim1, Dim2, (Loan."Outstanding Interest" + AccruedInterest)
                        , Postingdate, DocumentNo, Loan."Account No.", RepayAcc."No.",
                        Enum::"Gen. Journal Account Type"::"G/L Account",
                        Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + Loan."No.", '');

                        RunBal := (RunBal - (Loan."Outstanding Interest" + AccruedInterest));
                    end;
                end;

                if Loan."Outstanding Insurance" > 0 then begin
                    if RunBal > 0 then begin

                        LineNo := LineNo + 10000;
                        JnlPostMngt.PostJournal(Jtemplate, JBatch,
                        LineNo, AcctType::Customer,
                        DocumentNo, Format(Enum::"LoanTransactionType"::"Insurance Paid") + '-' + Loan."No.",
                        Loan."Outstanding Insurance" * -1,
                        Loan."Loan Account", Today,
                        AcctType::"G/L Account",
                        '', Account."Member No.",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code",
                        Enum::"LoanTransactionType"::"Insurance Paid", Loan."No.", '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");

                        LineNo := LineNo + 100000;
                        PostCheckMgt.CreateBalancingRepayAcc(LineNo, Jtemplate, JBatch,
                        Dim1, Dim2, Loan."Outstanding Insurance", Postingdate, DocumentNo,
                        Loan."Account No.", RepayAcc."No.", Enum::"Gen. Journal Account Type"::"G/L Account",
                        Format(Enum::"LoanTransactionType"::"Insurance Paid") + '-' + Loan."No.", '');
                        RunBal := (RunBal - Loan."Outstanding Insurance");
                    end;
                end;

                if Loan."Outstanding Bill" > 0 then begin
                    if RunBal > 0 then begin

                        LineNo := LineNo + 10000;
                        JnlPostMngt.PostJournal(Jtemplate, JBatch,
                        LineNo, AcctType::Customer,
                        DocumentNo, Format(Enum::"LoanTransactionType"::"Penalty Paid") + '-' + Loan."No.",
                        Loan."Outstanding Bill" * -1,
                        Loan."Loan Account", Today,
                        AcctType::"G/L Account",
                        '', Account."Member No.",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code",
                        Enum::"LoanTransactionType"::"Penalty Paid", Loan."No.", '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");

                        LineNo := LineNo + 140;
                        PostCheckMgt.CreateBalancingRepayAcc(LineNo, Jtemplate, JBatch,
                        Dim1, Dim2, Loan."Outstanding Bill", Postingdate, DocumentNo,
                        Loan."Account No.", RepayAcc."No.", Enum::"Gen. Journal Account Type"::"G/L Account",
                        Format(Enum::"LoanTransactionType"::"Penalty Paid") + '-' + Loan."No.", '');

                        RunBal := (RunBal - Loan."Outstanding Bill");
                    end;
                end;

                if Loan."Outstanding Principal" > 0 then begin
                    if RunBal > 0 then begin

                        LineNo := LineNo + 139;
                        JnlPostMngt.PostJournal(Jtemplate, JBatch,
                        LineNo, AcctType::Customer,
                        DocumentNo, Format(Enum::"LoanTransactionType"::Repayment) + '-' + Loan."No.",
                        Loan."Outstanding Principal" * -1,
                        Loan."Loan Account", Today,
                        AcctType::"G/L Account",
                        '', Account."Member No.",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code",
                        Enum::"LoanTransactionType"::Repayment, Loan."No.", '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");

                        LineNo := LineNo + 129;
                        PostCheckMgt.CreateBalancingRepayAcc(LineNo, Jtemplate, JBatch,
                        Dim1, Dim2, Loan."Outstanding Principal", Postingdate, DocumentNo,
                        Loan."Account No.", RepayAcc."No.", Enum::"Gen. Journal Account Type"::"G/L Account",
                        Format(Enum::"LoanTransactionType"::Repayment) + '-' + Loan."No.", '');
                        RunBal := (RunBal - Loan."Outstanding Principal");
                    end;
                end;

            end;
        end
    end;

    local procedure InitDebitCreditEntry(AccNo: Code[100]; AccType: Enum "Gen. Journal Account Type"; AmtoPost: Decimal; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; BalAcType: Enum "Gen. Journal Account Type"; BalAccNo: Code[100]; LineNo: Integer; ExtDocNo: Code[100]; TextDescription: Text[100])
    begin

        LineNo := LineNo + 1000;
        JnlPostMngt.PostJournal(GnlTemplate, GnlJBatch, LineNo, AccType,
        DocumentNo, TextDescription, AmtoPost, AccNo, PDate, BalAcType, BalAccNo,
        ExtDocNo, DActivity, DBranch, Enum::"LoanTransactionType"::" ", '', '', '',
        Enum::"Gen. Journal Document Type"::" ", '',
        Enum::"Gen. Journal Document Type"::" ");
    end;
}
