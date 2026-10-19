namespace SaccoDatabase.SaccoDatabase;

using Microsoft.Bank.Reconciliation;
using Microsoft.Bank.Ledger;
using System.Security.User;
using Microsoft.Bank.Check;
using Microsoft.Bank.BankAccount;
using Microsoft.Bank.Statement;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Sales.Receivables;
using DynamicsNav.SaccoDatabase;
using Microsoft.Finance.Currency;
using Microsoft.Purchases.Payables;
using System.Reflection;

codeunit 50015 "Bank Acc. Recon.  Post Mgt"
{
    Permissions = TableData "Bank Account Ledger Entry" = RIMD,
                  TableData "Check Ledger Entry" = RIMD,
                  TableData "Bank Account" = RIMD,
                  TableData "Bank Account Statement" = RIMD,
                  TableData "Bank Account Statement Line" = RIMD,
                  TableData "Posted Payment Recon. Hdr" = RIMD;
    TableNo = "Bank Acc. Reconciliation";
    trigger OnRun()
    begin

        UserSetup.Get(UserId);
        if not UserSetup."Post Bank Reconcilliation" then Error(MsgOnPermissionTxt);
        CheckBankRecIsComplete(Rec);
        case Rec."Reconciliation Option" of
            Rec."Reconciliation Option"::Automated:
                begin
                    Window.Open('#1#################################\\' + Text000);
                    Window.Update(1, StrSubstNo('%1 %2', Rec."Bank Account No.", Rec."Statement No."));
                    InitPost(Rec);
                    Post(Rec);
                    FinalizePost(Rec);
                    Window.Close();
                    Commit();
                end else begin
                Codeunit.Run(Codeunit::"Post Manual Recon Mgt.", Rec)
            end;
        end;
    end;

    local procedure InitPost(BankAccRecon: Record "Bank Acc. Reconciliation")
    begin
        case BankAccRecon."Statement Type" of
            BankAccRecon."Statement Type"::"Bank Reconciliation":
                begin
                    BankAccRecon.TestField("Statement Date");
                end;
            BankAccRecon."Statement Type"::"Payment Application":
                begin
                    SourceCodeSetup.Get();
                    SourceCode := SourceCodeSetup."Payment Reconciliation Journal"
                end;
        end;
    end;

    local procedure CheckLinesMatchEndingBalance(BankAccRecon: Record "Bank Acc. Reconciliation"; var Difference: Decimal)
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccLedger: Record "Bank Account Ledger Entry";
    begin
        BankAccReconLine.LinesExist(BankAccRecon);
        BankAccReconLine.CalcSums("Statement Amount", Difference);
        Difference := BankAccReconLine.Difference
    end;

    local procedure CheckBankRecIsComplete(Rec: Record "Bank Acc. Reconciliation")
    var
        BankAccountBalanceasperCashBook: Decimal;
        BankAccountLedgerEntry2: Record "Bank Account Ledger Entry";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation";
        BankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line";
        Bank: Record "Bank Account";
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
        DifferencesBW: Decimal;
        DifferencesInBankTotal: Decimal;
        BankRecPresented: Record "Bank Acc. Reconciliation Line";
        TotalDifference: Decimal;
        BankRecUnPresented: Record "Bank Acc. Reconciliation Line";
        TotalUnPresented: Decimal;
        BankStatementLine: Record "Bank Acc. Reconciliation Line";
        RecCashBkBal: Decimal;
        BankStatBalance: Decimal;
    begin
        IF BankAcc.GET(Rec."Bank Account No.") THEN BEGIN
            BankAcc.SETRANGE(BankAcc."Date Filter", 0D, Rec."Statement Date");
            BankAcc.CALCFIELDS(BankAcc."Balance at Date");
            CashBkBal := BankAcc."Balance at Date";
        END;

        BankRecUnPresented.RESET;
        BankRecUnPresented.SETRANGE(BankRecUnPresented."Bank Account No.", Rec."Bank Account No.");
        BankRecUnPresented.SETRANGE(BankRecUnPresented."Statement No.", Rec."Statement No.");
        BankRecUnPresented.SETRANGE(BankRecUnPresented.Reconciled, false);
        IF BankRecUnPresented.FIND('-') THEN BEGIN
            REPEAT
                TotalUnPresented := TotalUnPresented + BankRecUnPresented."Statement Amount";
            UNTIL BankRecUnPresented.NEXT = 0;
        END;
        /*  IF (TotalUnPresented) <> (CashBkBal - Rec."Statement Ending Balance") THEN
             ERROR(BankRecIncompleteTxt)
         ELSE  */
        IF BankAccReconciliationLine."Reconciliation Option" = BankAccReconciliationLine."Reconciliation Option"::Manual THEN BEGIN
            BankAccountBalanceasperCashBook := 0;
            UnpresentedChequesTotal := 0;
            UncreditedBanking := 0;

            BankRecPresented.RESET;
            BankRecPresented.SETRANGE(BankRecPresented."Bank Account No.", Rec."Bank Account No.");
            BankRecPresented.SETRANGE(BankRecPresented."Statement No.", Rec."Statement No.");
            IF BankRecPresented.FIND('-') THEN
                REPEAT
                    TotalDifference := TotalDifference + BankRecPresented.Difference;
                UNTIL BankRecPresented.NEXT = 0;

            Bank.RESET;
            Bank.SETRANGE(Bank."No.", Rec."Bank Account No.");
            IF Bank.FIND('-') THEN BEGIN
                Bank.SETRANGE(Bank."Date Filter", 0D, Rec."Statement Date");
                Bank.CALCFIELDS(Bank."Net Change");
                BankAccountBalanceasperCashBook := Bank."Net Change";

                BankStatementLine.RESET;
                BankStatementLine.SETRANGE(BankStatementLine."Bank Account No.", Bank."No.");
                BankStatementLine.SETRANGE(BankStatementLine."Statement No.", Rec."Statement No.");
                IF BankStatementLine.FIND('-') THEN
                    REPEAT
                        RecCashBkBal += BankStatementLine."Applied Amount";
                    UNTIL BankStatementLine.NEXT = 0;

                BankAccountLedgerEntry2.RESET;
                BankAccountLedgerEntry2.SETRANGE("Bank Account No.", Bank."No.");
                BankAccountLedgerEntry2.SETRANGE(Open, TRUE);
                BankAccountLedgerEntry2.SETRANGE(Reversed, FALSE);
                BankAccountLedgerEntry2.SETFILTER("Posting Date", '<=%1', Rec."Statement Date");
                BankAccountLedgerEntry2.SETFILTER(BankAccountLedgerEntry2.Amount, '<>%1', 0);
                IF BankAccountLedgerEntry2.FIND('-') THEN
                    REPEAT
                        IF BankAccountLedgerEntry2.Amount < 0 THEN
                            UnpresentedChequesTotal := UnpresentedChequesTotal + BankAccountLedgerEntry2.Amount
                        ELSE IF BankAccountLedgerEntry2.Amount > 0 THEN
                            UncreditedBanking := UncreditedBanking + BankAccountLedgerEntry2.Amount;
                    UNTIL BankAccountLedgerEntry2.NEXT = 0;

                UnpresentedChequesTotal := UnpresentedChequesTotal * -1;

                BankStatBalance := Rec."Statement Ending Balance";

                DifferencesBW := 0;
                DifferencesInBankTotal := 0;
                BankAccReconciliationLine2.RESET;
                BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Bank Account No.", Rec."Bank Account No.");
                BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Statement No.", Rec."Statement No.");
                BankAccReconciliationLine2.SETFILTER(Difference, '<>%1', 0);
                IF BankAccReconciliationLine2.FINDSET THEN BEGIN
                    BankAccReconciliationLine2.CALCSUMS(Difference);
                    DifferencesInBankTotal := BankAccReconciliationLine2.Difference;
                END;
                IF ((BankAccountBalanceasperCashBook + UnpresentedChequesTotal - UncreditedBanking) + TotalDifference - DifferencesBW = Rec."Statement Ending Balance") THEN
                    ERROR('Reconciliation is incomplete please go through it again');
            END;
        END

    end;

    local procedure Post(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        AppliedAmount: Decimal;

    begin
        BankAccReconLine.FilterBankRecLines(BankAccRecon);
        BankAccReconLine.SetFilter("Statement Amount", '<>%1', 0);
        BankAcc.Get(BankAccRecon."Bank Account No.");

        BankAccReconLine.SetRange(Reconciled, true);

        TotalAmount := 0;
        TotalAppliedAmount := 0;
        TotalDiff := 0;
        Lines := 0;
        if BankAccReconLine.IsEmpty then
            ERROR(Text002);
        BankAccLedgEntry.LockTable();
        CheckLedgEntry.LockTable();
        if BankAccReconLine.FindSet() then
            repeat
                Lines := Lines + 1;
                Window.Update(2, Lines);
                AppliedAmount := 0;

                case BankAccRecon."Statement Type" of
                    BankAccRecon."Statement Type"::"Bank Reconciliation":
                        // case BankAccReconLine.Type of
                        //BankAccReconLine.Type::"Bank Account Ledger Entry":
                        CloseBankAccLedgEntry(BankAccReconLine, AppliedAmount);
                    //BankAccReconLine.Type::"Check Ledger Entry":
                    //  CloseCheckLedgEntry(BankAccReconLine, AppliedAmount);
                    //BankAccReconLine.Type::Difference:
                    //   TotalDiff += BankAccReconLine."Statement Amount";
                    // end;
                    BankAccRecon."Statement Type"::"Payment Application":
                        PostPaymentApplications(BankAccReconLine, AppliedAmount);
                end;

                TotalAmount += BankAccReconLine."Statement Amount";
                TotalAppliedAmount += AppliedAmount;
            until BankAccReconLine.NEXT = 0;

        case BankAccRecon."Statement Type" of
            BankAccRecon."Statement Type"::"Bank Reconciliation":
                begin
                    UpdateBank(BankAccRecon, TotalAmount);
                    TransferToBankStmt(BankAccRecon);
                end;
            BankAccRecon."Statement Type"::"Payment Application":
                TransferToPostPmtAppln(BankAccRecon);
        end;
    end;

    local procedure FinalizePost(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        AppliedPmtEntry: Record "Applied Payment Entry";
    begin

        if BankAccReconLine.LinesExist(BankAccRecon) then
            repeat
                AppliedPmtEntry.FilterAppliedPmtEntry(BankAccReconLine);
                AppliedPmtEntry.DeleteAll();
                BankAccReconLine.Delete();
            until BankAccReconLine.Next() = 0;
        BankAccRecon.Delete();
    end;

    local procedure CloseBankAccLedgEntry(BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var AppliedAmount: Decimal)

    begin
        BankAccLedgEntry.RESET;
        BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", Open);
        BankAccLedgEntry.SETRANGE("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry.SETRANGE(Open, true);
        BankAccLedgEntry.SETRANGE(
          "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
        BankAccLedgEntry.SETRANGE("Statement No.", BankAccReconLine."Statement No.");
        BankAccLedgEntry.SETRANGE("Statement Line No.", BankAccReconLine."Statement Line No.");
        BankAcc.GET(BankAccReconLine."Bank Account No.");

        IF BankAccLedgEntry.FIND('-') THEN
            REPEAT
                AppliedAmount += BankAccLedgEntry."Remaining Amount";
                BankAccLedgEntry."Remaining Amount" := 0;
                BankAccLedgEntry.Open := false;
                BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Closed;
                BankAccLedgEntry.MODIFY;

                CheckLedgEntry.RESET;
                CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
                CheckLedgEntry.SETRANGE(
                  "Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                CheckLedgEntry.SETRANGE(Open, true);
                if CheckLedgEntry.Find('-') then
                    repeat
                        CheckLedgEntry.TestField(Open, true);
                        CheckLedgEntry.TestField(
                          "Statement Status",
                          CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                        CheckLedgEntry.TestField("Statement No.", '');
                        CheckLedgEntry.TestField("Statement Line No.", 0);
                        CheckLedgEntry.Open := false;
                        CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Closed;
                        CheckLedgEntry.Modify(true);
                    until CheckLedgEntry.Next() = 0;
            until BankAccLedgEntry.NEXT = 0;
    end;

    local procedure CloseCheckLedgEntry(BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var AppliedAmount: Decimal)
    var
        CheckLedgEntry2: Record "Check Ledger Entry";
    begin
        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account No.", Open);
        CheckLedgEntry.SETRANGE("Bank Account No.", BankAccReconLine."Bank Account No.");
        CheckLedgEntry.SETRANGE(Open, TRUE);
        CheckLedgEntry.SETRANGE(
          "Statement Status", CheckLedgEntry."Statement Status"::"Check Entry Applied");
        CheckLedgEntry.SETRANGE("Statement No.", BankAccReconLine."Statement No.");
        CheckLedgEntry.SETRANGE("Statement Line No.", BankAccReconLine."Statement Line No.");
        IF CheckLedgEntry.FIND('-') THEN
            REPEAT
                AppliedAmount -= CheckLedgEntry.Amount;
                CheckLedgEntry.Open := FALSE;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Closed;
                CheckLedgEntry.MODIFY;

                BankAccLedgEntry.GET(CheckLedgEntry."Bank Account Ledger Entry No.");
                BankAccLedgEntry.TESTFIELD(Open, TRUE);
                BankAccLedgEntry.TESTFIELD(
                  "Statement Status", BankAccLedgEntry."Statement Status"::"Check Entry Applied");
                BankAccLedgEntry.TESTFIELD("Statement No.", '');
                BankAccLedgEntry.TESTFIELD("Statement Line No.", 0);
                BankAccLedgEntry."Remaining Amount" :=
                  BankAccLedgEntry."Remaining Amount" + CheckLedgEntry.Amount;
                IF BankAccLedgEntry."Remaining Amount" = 0 THEN BEGIN
                    BankAccLedgEntry.Open := FALSE;
                    BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Closed;
                    BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
                    BankAccLedgEntry."Statement Line No." := CheckLedgEntry."Statement Line No.";
                END ELSE BEGIN
                    CheckLedgEntry2.RESET;
                    CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                    CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                    CheckLedgEntry2.SETRANGE(Open, TRUE);
                    CheckLedgEntry2.SETRANGE("Check Type", CheckLedgEntry2."Check Type"::"Partial Check");
                    CheckLedgEntry2.SETRANGE(
                      "Statement Status", CheckLedgEntry2."Statement Status"::"Check Entry Applied");
                    IF NOT CheckLedgEntry2.FINDFIRST THEN
                        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Open;
                END;
                BankAccLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
    end;

    local procedure PostPaymentApplications(BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var AppliedAmount: Decimal)
    var
        AppliedPmtEntry: Record "Applied Payment Entry";
    begin
        BankAccReconLine.TestField("Account No.");
        BankAcc.GET(BankAccReconLine."Bank Account No.");

        GenJnlLine.Init();
        GenJnlLine."Posting Date" := BankAccReconLine."Transaction Date";
        GenJnlLine.Description := BankAccReconLine.Description;
        GenJnlLine."Shortcut Dimension 1 Code" := BankAccReconLine."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := BankAccReconLine."Shortcut Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := BankAccReconLine."Dimension Set ID";
        GenJnlLine."Account Type" := BankAccReconLine."Account Type";
        GenJnlLine."Account No." := BankAccReconLine."Account No.";
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
            if BankAccReconLine."Statement Amount" > 0 then
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
            else
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund
        end else begin
            if BankAccReconLine."Statement Amount" > 0 then
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund
            else
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
        end;
        GenJnlLine."Document No." := BankAccReconLine."Statement No.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := BankAcc."No.";
        GenJnlLine.Amount := -BankAccReconLine."Statement Amount";
        GenJnlLine.Validate("Currency Code", BankAcc."Currency Code");
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Allow Zero-Amount Posting" := true;
        GenJnlLine."Applies-to ID" := BankAccReconLine."Statement No.";

        if AppliedPmtEntry.AppliedPmtEntryLinesExist(BankAccReconLine) then
            repeat
                AppliedAmount += AppliedPmtEntry."Applied Amount" - AppliedPmtEntry."Applied Pmt. Discount";
                AppliedPmtEntry.TestField("Account Type", BankAccReconLine."Account Type");
                AppliedPmtEntry.TestField("Account No.", BankAccReconLine."Account No.");
                if AppliedPmtEntry."Applies-to Entry No." <> 0 then
                    case AppliedPmtEntry."Account Type" of
                        AppliedPmtEntry."Account Type"::Customer:
                            ApplyCustLedgEntry(
                              AppliedPmtEntry, GenJnlLine."Applies-to ID", GenJnlLine."Posting Date", 0D, 0D, AppliedPmtEntry."Applied Pmt. Discount");
                        AppliedPmtEntry."Account Type"::Vendor:
                            ApplyVendLedgEntry(
                              AppliedPmtEntry, GenJnlLine."Applies-to ID", GenJnlLine."Posting Date", 0D, 0D, AppliedPmtEntry."Applied Pmt. Discount");
                    end;
            until AppliedPmtEntry.Next() = 0;

        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;

    local procedure UpdateBank(BankAccRecon: Record "Bank Acc. Reconciliation"; TotalAmount: Decimal)
    begin
        BankAcc.LockTable();
        BankAcc.GET(BankAccRecon."Bank Account No.");
        BankAcc.TESTFIELD(Blocked, false);
        BankAcc."Last Statement No." := BankAccRecon."Statement No.";
        BankAcc."Last Statement No." := BankAccRecon."Statement No.";
        BankAcc."Balance Last Statement" := BankAccRecon."Statement Ending Balance";//"Balance Last Statement" + Amt;//**Changes
        BankAcc.Modify(true)
    end;

    local procedure TransferToBankStmt(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccStmt: Record "Bank Account Statement";
        BankAccStmtLine: Record "Bank Account Statement Line";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        LineNo: Integer;
    begin

        BankAccStmtLine.RESET;
        BankAccStmtLine.SETRANGE("Bank Account No.", BankAccRecon."Bank Account No.");
        BankAccStmtLine.SETRANGE("Statement No.", BankAccRecon."Statement No.");
        IF BankAccStmtLine.FindLast() THEN
            LineNo := BankAccStmtLine."Statement Line No.";

        BankAccLedgEntry.RESET;
        BankAccLedgEntry.SETRANGE("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry.SETRANGE(Open, FALSE);
        BankAccLedgEntry.SETRANGE(Reversed, FALSE);
        BankAccLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Closed);
        BankAccLedgEntry.SETRANGE("Statement No.", BankAccRecon."Statement No.");
        BankAccLedgEntry.SETFILTER("Posting Date", '<=%1', BankAccRecon."Statement Date");
        IF BankAccLedgEntry.FIND('-') THEN
            REPEAT
                LineNo += 1000;
                BankAccStmtLine.Init();
                BankAccStmtLine."Bank Account No." := BankAccRecon."Bank Account No.";
                BankAccStmtLine."Statement No." := BankAccRecon."Statement No.";
                BankAccStmtLine."Statement Line No." := LineNo;
                BankAccStmtLine."Document No." := BankAccLedgEntry."Document No.";
                BankAccStmtLine."Transaction Date" := BankAccLedgEntry."Posting Date";
                BankAccStmtLine.Description := BankAccLedgEntry.Description;
                BankAccStmtLine."Statement Amount" := BankAccLedgEntry.Amount;
                BankAccStmtLine.Difference := BankAccLedgEntry.Amount;
                BankAccStmtLine."Applied Amount" := 0;
                BankAccStmtLine.Type := BankAccStmtLine.Type::"Bank Account Ledger Entry";
                BankAccStmtLine."Applied Entries" := 0;
                BankAccStmtLine.Reconciled := true;
                BankAccStmtLine.Insert(true)
            UNTIL BankAccLedgEntry.NEXT = 0;

        BankAccLedgEntry.RESET;
        BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", Open);
        BankAccLedgEntry.SETRANGE("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry.SETRANGE(Open, false);
        BankAccLedgEntry.SETRANGE(Reversed, false);
        BankAccLedgEntry.SETFILTER("Posting Date", '<=%1', BankAccRecon."Statement Date");
        if BankAccLedgEntry.FIND('-') then
            repeat
                LineNo += 1000;
                BankAccStmtLine.INIT;
                BankAccStmtLine."Bank Account No." := BankAccRecon."Bank Account No.";
                BankAccStmtLine."Statement No." := BankAccRecon."Statement No.";
                BankAccStmtLine."Statement Line No." := LineNo;
                BankAccStmtLine."Document No." := BankAccLedgEntry."Document No.";
                BankAccStmtLine."Transaction Date" := BankAccLedgEntry."Posting Date";
                BankAccStmtLine.Description := BankAccLedgEntry.Description;
                BankAccStmtLine."Statement Amount" := BankAccLedgEntry.Amount;
                BankAccStmtLine.Difference := BankAccLedgEntry.Amount;
                BankAccStmtLine."Applied Amount" := 0;
                BankAccStmtLine.Type := BankAccStmtLine.Type::"Bank Account Ledger Entry";
                BankAccStmtLine."Applied Entries" := 0;
                BankAccStmtLine.Reconciled := false;
                BankAccStmtLine.Insert(true);
            until BankAccLedgEntry.Next() = 0;
        BankAccStmt.TransferFields(BankAccRecon);

        if BankAcc.GET(BankAccRecon."Bank Account No.") then begin
            BankAcc.SETRANGE("Date Filter", 0D, BankAccRecon."Statement Date");
            BankAcc.CALCFIELDS(BankAcc."Balance at Date");
            BankAccStmt."Cash Book Balance" := BankAcc."Balance at Date";
        end;
        BankAccStmt.Insert(true)
    end;

    local procedure TransferToPostPmtAppln(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        PostedPmtReconHdr: Record "Posted Payment Recon. Hdr";
        PostedPmtReconLine: Record "Posted Payment Recon. Line";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        TypeHelper: Codeunit "Type Helper";
        FieldLength: Integer;
    begin
        if BankAccReconLine.LinesExist(BankAccRecon) then
            repeat
                PostedPmtReconLine.TransferFields(BankAccReconLine);
                FieldLength := TypeHelper.GetFieldLength(Database::"Posted Payment Recon. Line",
                    PostedPmtReconLine.FieldNo("Applied Document No."));
                PostedPmtReconLine."Applied Document No." := COPYSTR(BankAccReconLine.GetAppliedToDocumentNo, 1, FieldLength);
                FieldLength := TypeHelper.GetFieldLength(Database::"Posted Payment Recon. Line",
                    PostedPmtReconLine.FieldNo("Applied Entry No."));
                PostedPmtReconLine."Applied Entry No." := COPYSTR(BankAccReconLine.GetAppliedToEntryNo, 1, FieldLength);
                PostedPmtReconLine.Insert(true);
            until BankAccReconLine.Next() = 0;

        PostedPmtReconHdr.TransferFields(BankAccRecon);
        PostedPmtReconHdr.Insert(true);
    end;

    procedure ApplyCustLedgEntry(AppliedPmtEntry: Record "Applied Payment Entry"; AppliesToID: Code[50]; PostingDate: Date; PmtDiscDueDate: Date; PmtDiscToleranceDate: Date; RemPmtDiscPossible: Decimal)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CustLedgEntry.GET(AppliedPmtEntry."Applies-to Entry No.");
        CustLedgEntry.TESTFIELD(Open);
        BankAcc.GET(AppliedPmtEntry."Bank Account No.");
        if CustLedgEntry."Applies-to ID" = '' then begin
            CustLedgEntry."Pmt. Discount Date" := PmtDiscDueDate;
            CustLedgEntry."Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;

            CustLedgEntry."Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
            if BankAcc.IsInLocalCurrency then
                CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                  CurrExchRate.ExchangeAmount(CustLedgEntry."Remaining Pmt. Disc. Possible", '', CustLedgEntry."Currency Code", PostingDate);
        end else begin
            CustLedgEntry."Applies-to ID" := AppliesToID;

            CustLedgEntry."Amount to Apply" := AppliedPmtEntry."Applied Amount";
            if BankAcc.IsInLocalCurrency then
                CustLedgEntry."Amount to Apply" :=
                  CurrExchRate.ExchangeAmount(CustLedgEntry."Amount to Apply", '', CustLedgEntry."Currency Code", PostingDate);
        end;
        Codeunit.Run(Codeunit::"Cust. Entry-Edit", CustLedgEntry);
    end;

    procedure ApplyVendLedgEntry(AppliedPmtEntry: Record "Applied Payment Entry"; AppliesToID: Code[50]; PostingDate: Date; PmtDiscDueDate: Date; PmtDiscToleranceDate: Date; RemPmtDiscPossible: Decimal)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
    begin

        VendLedgEntry.Get(AppliedPmtEntry."Applies-to Entry No.");
        VendLedgEntry.TestField(Open);
        BankAcc.GET(AppliedPmtEntry."Bank Account No.");
        if VendLedgEntry."Applies-to ID" = '' then begin
            VendLedgEntry."Pmt. Discount Date" := PmtDiscDueDate;
            VendLedgEntry."Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;
            VendLedgEntry."Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
            if BankAcc.IsInLocalCurrency then
                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                  CurrExchRate.ExchangeAmount(VendLedgEntry."Remaining Pmt. Disc. Possible", '', VendLedgEntry."Currency Code", PostingDate);
        end else begin

            VendLedgEntry."Applies-to ID" := AppliesToID;
            VendLedgEntry."Amount to Apply" := AppliedPmtEntry."Applied Amount";
            if BankAcc.IsInLocalCurrency then
                VendLedgEntry."Amount to Apply" :=
                  CurrExchRate.ExchangeAmount(VendLedgEntry."Amount to Apply", '', VendLedgEntry."Currency Code", PostingDate);
        end;
        Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
    end;

    local procedure PostManualReconciliation(Rec: Record "Bank Acc. Reconciliation")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccReconLine2: Record "Bank Acc. Reconciliation Line";
        BankAcc: Record "Bank Account";
        BankAccStmt: Record "Bank Account Statement";
        BankAccStmtLine: Record "Bank Account Statement Line";
        AppliedAmount: Decimal;
        TotalAmount: Decimal;
        TotalAppliedAmount: Decimal;
        TotalDiff: Decimal;
        Lines: Integer;
        UnreconciledLines: Record "Bank Account Statement Line";
        TotalReconciled: Decimal;
        TotalDifference: Decimal;
        DifferenceExplained: Decimal;
        Compare: Decimal;
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
    begin

        Rec.TestField("Statement Date");
        Window.Open('#1#################################\\' + Text000);

        BankAccReconLine2.Reset();
        BankAccReconLine2.SetRange("Bank Account No.", Rec."Bank Account No.");
        BankAccReconLine2.SetRange("Statement No.", Rec."Statement No.");
        BankAccReconLine2.SetRange(BankAccReconLine2.Reconciled, false);
        if BankAccReconLine2.Find('-') then
            repeat

                if (BankAccReconLine2."Statement Amount" < 0) and (BankAccReconLine2."Document No." <> '') then
                    UnpresentedChequesTotal := UnpresentedChequesTotal + BankAccReconLine2."Statement Amount"
                else if (BankAccReconLine2."Statement Amount" > 0) and (BankAccReconLine2."Document No." <> '') then
                    UncreditedBanking := UncreditedBanking + BankAccReconLine2."Statement Amount";
                TotalReconciled := TotalReconciled + BankAccReconLine2."Applied Amount";
                TotalDifference := TotalDifference + BankAccReconLine2.Difference;
            until BankAccReconLine2.Next() = 0;

        DifferenceExplained := getbankAcc(Rec."Bank Account No.", Rec."Statement Date");

        Compare := (DifferenceExplained + (UnpresentedChequesTotal * -1) - UncreditedBanking + TotalDifference);
        if Compare <> Rec."Statement Ending Balance" then Error(BankRecIncompleteTxt);

        BankAccReconLine.Reset();
        BankAccReconLine.SetRange("Bank Account No.", Rec."Bank Account No.");
        BankAccReconLine.SetRange("Statement No.", Rec."Statement No.");
        BankAccReconLine.SetRange(Reconciled, false);
        IF BankAccReconLine.Find('-') then
            repeat
                BankAccReconLine.Unapply();
                UnreconciledLines.TransferFields(BankAccReconLine);
                UnreconciledLines.Insert(true);
                BankAccReconLine.Delete();
            Until BankAccReconLine.Next() = 0;

        TotalAmount := 0;
        TotalAppliedAmount := 0;
        TotalDiff := 0;
        Lines := 0;
        BankAccReconLine.RESET;
        BankAccReconLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
        BankAccReconLine.SETRANGE("Statement No.", Rec."Statement No.");
        IF BankAccReconLine.FIND('-') THEN BEGIN
            BankAccLedgEntry.LOCKTABLE;
            CheckLedgEntry.LOCKTABLE;
            REPEAT
                Lines := Lines + 1;
                Window.UPDATE(2, Lines);
                AppliedAmount := 0;

                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", Open);
                BankAccLedgEntry.SETRANGE("Bank Account No.", BankAccReconLine."Bank Account No.");
                BankAccLedgEntry.SETRANGE(Open, TRUE);
                BankAccLedgEntry.SETRANGE(
                  "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                BankAccLedgEntry.SETRANGE("Statement No.", BankAccReconLine."Statement No.");
                BankAccLedgEntry.SETRANGE("Statement Line No.", BankAccReconLine."Statement Line No.");
                IF BankAccLedgEntry.FIND('-') THEN
                    REPEAT
                        AppliedAmount := AppliedAmount + BankAccLedgEntry."Remaining Amount";
                        BankAccLedgEntry."Remaining Amount" := 0;
                        BankAccLedgEntry.Open := FALSE;
                        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Closed;
                        BankAccLedgEntry.MODIFY;

                        CheckLedgEntry.RESET;
                        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
                        CheckLedgEntry.SETRANGE(
                          "Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                        CheckLedgEntry.SETRANGE(Open, TRUE);
                        IF CheckLedgEntry.FIND('-') THEN
                            REPEAT
                                CheckLedgEntry.TESTFIELD(Open, TRUE);
                                CheckLedgEntry.TESTFIELD(
                                  "Statement Status",
                                  CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                                CheckLedgEntry.TESTFIELD("Statement No.", '');
                                CheckLedgEntry.TESTFIELD("Statement Line No.", 0);
                                CheckLedgEntry.Open := FALSE;
                                CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Closed;
                                CheckLedgEntry.MODIFY;
                            UNTIL CheckLedgEntry.NEXT = 0;
                    UNTIL BankAccLedgEntry.NEXT = 0;

                TotalDiff := TotalDiff + BankAccReconLine."Statement Amount";

                TotalAmount := TotalAmount + BankAccReconLine."Statement Amount";
                TotalAppliedAmount := TotalAppliedAmount + AppliedAmount;
            UNTIL BankAccReconLine.NEXT = 0;
        END ELSE
            ERROR(Text002);

        BankAcc.LOCKTABLE;
        BankAcc.GET(Rec."Bank Account No.");
        BankAcc.TESTFIELD(Blocked, FALSE);
        BankAcc."Last Statement No." := Rec."Statement No.";
        BankAcc."Balance Last Statement" := Rec."Statement Ending Balance";
        BankAcc.MODIFY;

        BankAccReconLine.RESET;
        BankAccReconLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
        BankAccReconLine.SETRANGE("Statement No.", Rec."Statement No.");
        if BankAccReconLine.FIND('-') then
            repeat
                BankAccStmtLine.TransferFields(BankAccReconLine);
                BankAccStmtLine.Insert(true);
            until BankAccReconLine.Next() = 0;
        BankAccReconLine.DeleteAll();

        BankAccStmt.Init();
        BankAccStmt."Statement No." := Rec."Statement No.";
        BankAccStmt."Bank Account No." := Rec."Bank Account No.";
        BankAccStmt."Bank Account Name" := Rec."Bank Account Name";
        BankAccStmt."Balance Last Statement" := Rec."Balance Last Statement";
        BankAccStmt."Statement Ending Balance" := Rec."Statement Ending Balance";
        if BankAcc.Get(Rec."Bank Account No.") then begin
            BankAcc.SetRange("Date Filter", 0D, Rec."Statement Date");
            BankAcc.CalcFields("Balance at Date");
            BankAccStmt."Cash Book Balance" := BankAcc."Balance at Date";
        end;
        BankAccStmt.Insert();
        Rec.Delete();
    end;

    local procedure getbankAcc(var AcNo: Code[10]; var StatendingDate: Date): Decimal
    begin
        if BankAcc.Get(AcNo) then begin
            BankAcc.SetRange("Date Filter", 0D, StatendingDate);
            BankAcc.CalcFields(BankAcc."Balance at Date");
            exit(BankAcc."Balance at Date");
        end;
    end;

    procedure RemoveReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; Test: Boolean)
    var
        AppliedStatementEntry: Record "Bank Acc. Reconciliation Line";
    begin

        BankAccLedgEntry.TESTFIELD(Open, TRUE);
        IF Test THEN BEGIN
            BankAccLedgEntry.TESTFIELD(
              "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
            BankAccLedgEntry.TESTFIELD("Statement No.", BankAccReconLine."Statement No.");
            BankAccLedgEntry.TESTFIELD("Statement Line No.", BankAccReconLine."Statement Line No.");
        END;
        BankAccLedgEntry.TESTFIELD("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Open;
        BankAccLedgEntry."Statement No." := '';
        BankAccLedgEntry."Statement Line No." := 0;
        BankAccLedgEntry.MODIFY;

        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SETRANGE(Open, TRUE);
        IF CheckLedgEntry.FIND('-') THEN
            REPEAT
                IF Test THEN BEGIN
                    CheckLedgEntry.TESTFIELD(
                      "Statement Status", CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                    CheckLedgEntry.TESTFIELD("Statement No.", '');
                    CheckLedgEntry.TESTFIELD("Statement Line No.", 0);
                END;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Open;
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
    end;

    var
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SourceCode: Code[10];
        TotalAmount: Decimal;
        TotalAppliedAmount: Decimal;
        TotalDiff: Decimal;
        Lines: Integer;
        Window: Dialog;
        Difference: Decimal;
        UserSetup: Record "User Setup";
        CashBkBal: Decimal;
        Text000: Label 'Posting lines   #2######';
        Text001: Label '%1 is not equal to Total Balance.';
        Text002: Label 'There is nothing to post.';
        Text003: Label ' The application is not correct. The total amount applied is %1; it should be %2.';
        Text004: Label ' The total difference is %1. It must be %2.';
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
        BankRecIncompleteTxt: Label 'Reconciliation is incomplete please go through it again';

}
