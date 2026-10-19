namespace DynamicsNav.SaccoDatabase;

using Microsoft.Bank.Reconciliation;

codeunit 50018 "Post Manual Recon Mgt."
{
    Permissions = TableData Microsoft.Bank.Ledger."Bank Account Ledger Entry" = rimd,
                  TableData Microsoft.Bank.Check."Check Ledger Entry" = rimd,
                  TableData Microsoft.Bank.BankAccount."Bank Account" = rimd,
                  TableData Microsoft.Bank.Statement."Bank Account Statement" = rimd,
                  TableData Microsoft.Bank.Statement."Bank Account Statement Line" = rimd,
                  TableData "Posted Payment Recon. Hdr" = rimd;
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
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
                Window.Update(2, Lines);
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
                                CheckLedgEntry.TESTFIELD("Statement Status",CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                                CheckLedgEntry.Open := false;
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
            BankAcc.CalcFields(BankAcc."Balance at Date");
            BankAccStmt."Cash Book Balance" := BankAcc."Balance at Date";
        end;
        BankAccStmt.Insert();
        Rec.Delete();
        Window.Close();
    end;

    local procedure getbankAcc(var AcNo: Code[10]; var StatendingDate: Date): Decimal
    begin
        if BankAcc.Get(AcNo) then begin
            BankAcc.SetRange("Date Filter", 0D, StatendingDate);
            BankAcc.CalcFields(BankAcc."Balance at Date");
            exit(BankAcc."Balance at Date");
        end;
    end;

    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccReconLine2: Record "Bank Acc. Reconciliation Line";
        BankAcc: Record Microsoft.Bank.BankAccount."Bank Account";
        BankAccStmt: Record Microsoft.Bank.Statement."Bank Account Statement";
        BankAccStmtLine: Record Microsoft.Bank.Statement."Bank Account Statement Line";
        AppliedAmount: Decimal;
        TotalAmount: Decimal;
        Window: Dialog;
        TotalAppliedAmount: Decimal;
        TotalDiff: Decimal;
        BankAccLedgEntry: Record Microsoft.Bank.Ledger."Bank Account Ledger Entry";
        CheckLedgEntry: Record Microsoft.Bank.Check."Check Ledger Entry";
        Lines: Integer;
        UnreconciledLines: Record Microsoft.Bank.Statement."Bank Account Statement Line";
        TotalReconciled: Decimal;
        TotalDifference: Decimal;
        DifferenceExplained: Decimal;
        Compare: Decimal;
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
        Text000: Label 'Posting lines   #2######';
        Text002: Label 'There is nothing to post.';
        BankRecIncompleteTxt: Label 'Reconciliation is incomplete please go through it again';

}
