namespace SaccoDB.SaccoDB;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Posting;

report 90026 "Post Excess Interest"
{
    ApplicationArea = All;
    Caption = 'Post Excess Interest';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Loans; Loans)
        {
            column(AccountNo; "Account No.")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApprovalDate; "Approval Date")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(No; "No.")
            {
            }
            trigger OnPreDataItem()
            begin
                GENJNLLINE.SetRange("Journal Template Name", 'General');
                GENJNLLINE.SetRange("Journal Batch Name", 'DEFAULT');
                LINENUM := 0;
                GENJNLLINE.DELETEALL;
            end;

            trigger OnAfterGetRecord()
            BEGIN
                CalcFields("Outstanding Balance", "Outstanding Interest");
                acccredit.Reset();
                acccredit.SetRange(acccredit."Member No.", Loans."Account No.");
                acccredit.SetRange("Product Type", 'DP-00103');
                IF acccredit.FINDSET THEN BEGIN
                    acccredit.CalcFields("Balance (LCY)");
                    AccountBalance := 0;
                    AccountBalance := acccredit."Balance (LCY)";

                    // Post Excess Interest

                    IF (Loans."Outstanding Interest" > 0) AND (Loans."Outstanding Interest" <= 1300) THEN BEGIN
                        IF AccountBalance > 0 THEN BEGIN

                            GENJNLLINE.INIT;
                            LINENUM := LINENUM + 10000;
                            GENJNLLINE."Line No." := LINENUM;
                            GENJNLLINE."Journal Template Name" := 'General';
                            GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                            GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                            GENJNLLINE."Account No." := loans."Loan Account";
                            GENJNLLINE.Description := 'Interest from Loan ' + Loans."No.";
                            IF AccountBalance >= Loans."Outstanding Interest" THEN
                                GENJNLLINE.Amount := -Loans."Outstanding Interest"
                            ELSE
                                GENJNLLINE.Amount := -AccountBalance;
                            GENJNLLINE.Validate(Amount);
                            GENJNLLINE."Posting Date" := TODAY;
                            GENJNLLINE."Document No." := Loans."No.";
                            GENJNLLINE."Transaction Type" := GENJNLLINE."Transaction Type"::"Interest Paid";
                            GENJNLLINE."Loan No." := Loans."No.";
                            IF GENJNLLINE.Amount <> 0 THEN
                                GENJNLLINE.Insert(true);
                            GENJNLLINE.INIT;

                            LINENUM := LINENUM + 10000;
                            GENJNLLINE."Line No." := LINENUM;
                            GENJNLLINE."Journal Template Name" := 'General';
                            GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                            GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                            GENJNLLINE."Account No." := acccredit."No.";
                            GENJNLLINE.Description := 'Interest from Loan ' + Loans."No.";
                            IF AccountBalance >= Loans."Outstanding Interest" THEN
                                GENJNLLINE.Amount := Loans."Outstanding Interest"
                            ELSE
                                GENJNLLINE.Amount := AccountBalance;
                            GENJNLLINE.Validate(Amount);
                            GENJNLLINE."Posting Date" := TODAY;
                            GENJNLLINE."Document No." := Loans."No.";
                            IF GENJNLLINE.Amount <> 0 then
                                GENJNLLINE.Insert(true);
                            AccountBalance := AccountBalance - GENJNLLINE.Amount;
                        END;
                    END;

                    IF (Loans."Outstanding Balance" > 0) AND (Loans."Outstanding Balance" <= 1300) THEN BEGIN
                        IF AccountBalance > 0 THEN BEGIN

                            GENJNLLINE.INIT;
                            LINENUM := LINENUM + 10000;
                            GENJNLLINE."Line No." := LINENUM;
                            GENJNLLINE."Journal Template Name" := 'General';
                            GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                            GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                            GENJNLLINE."Account No." := loans."Loan Account";
                            GENJNLLINE.Description := 'balance from Loan ' + Loans."No.";
                            IF AccountBalance >= Loans."Outstanding Balance" THEN
                                GENJNLLINE.Amount := -Loans."Outstanding Balance"
                            ELSE
                                GENJNLLINE.Amount := -AccountBalance;
                            GENJNLLINE.Validate(Amount);
                            GENJNLLINE."Posting Date" := TODAY;
                            GENJNLLINE."Document No." := Loans."No.";
                            GENJNLLINE."Transaction Type" := GENJNLLINE."Transaction Type"::Repayment;
                            GENJNLLINE."Loan No." := Loans."No.";
                            IF GENJNLLINE.Amount <> 0 THEN
                                GENJNLLINE.Insert(true);
                            GENJNLLINE.INIT;

                            LINENUM := LINENUM + 10000;
                            GENJNLLINE."Line No." := LINENUM;
                            GENJNLLINE."Journal Template Name" := 'General';
                            GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                            GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                            GENJNLLINE."Account No." := acccredit."No.";
                            GENJNLLINE.Description := 'balance from Loan ' + Loans."No.";
                            IF AccountBalance >= Loans."Outstanding Balance" THEN
                                GENJNLLINE.Amount := Loans."Outstanding Balance"
                            ELSE
                                GENJNLLINE.Amount := AccountBalance;
                            GENJNLLINE.Validate(Amount);
                            GENJNLLINE."Posting Date" := TODAY;
                            GENJNLLINE."Document No." := Loans."No.";
                            IF GENJNLLINE.Amount <> 0 THEN
                                GENJNLLINE.Insert(true);

                        END;
                    END;

                    // NEGATIVE BALANCE
                    IF (Loans."Outstanding Interest" < 0) THEN BEGIN
                        GENJNLLINE.INIT;
                        LINENUM := LINENUM + 10000;
                        GENJNLLINE."Line No." := LINENUM;
                        GENJNLLINE."Journal Template Name" := 'General';
                        GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                        GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                        GENJNLLINE."Account No." := loans."Loan Account";
                        GENJNLLINE.Description := 'Interest from Loan ' + Loans."No.";
                        GENJNLLINE.Amount := Loans."Outstanding Interest";
                        GENJNLLINE.Validate(Amount);
                        GENJNLLINE."Posting Date" := TODAY;
                        GENJNLLINE."Document No." := Loans."No.";
                        GENJNLLINE."Transaction Type" := GENJNLLINE."Transaction Type"::"Interest Paid";
                        GENJNLLINE."Loan No." := Loans."No.";
                        if GENJNLLINE.Amount <> 0 then
                            GENJNLLINE.Insert(true);
                        GENJNLLINE.INIT;

                        LINENUM := LINENUM + 10000;
                        GENJNLLINE."Line No." := LINENUM;
                        GENJNLLINE."Journal Template Name" := 'General';
                        GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                        GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                        GENJNLLINE."Account No." := acccredit."No.";
                        GENJNLLINE.Description := 'Interest from Loan ' + Loans."No.";
                        GENJNLLINE.Amount := -Loans."Outstanding Interest";
                        GENJNLLINE.Validate(Amount);
                        GENJNLLINE."Posting Date" := TODAY;
                        GENJNLLINE."Document No." := Loans."No.";
                        if GENJNLLINE.Amount <> 0 then
                            GENJNLLINE.Insert(true);
                        AccountBalance := AccountBalance - GENJNLLINE.Amount;




                    END;
                    IF (Loans."Outstanding Balance" < 0) THEN BEGIN

                        GENJNLLINE.INIT;
                        LINENUM := LINENUM + 10000;
                        GENJNLLINE."Line No." := LINENUM;
                        GENJNLLINE."Journal Template Name" := 'General';
                        GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                        GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                        GENJNLLINE."Account No." := loans."Loan Account";
                        GENJNLLINE.Description := 'Loan Balance from Loan ' + Loans."No.";
                        GENJNLLINE.Amount := Loans."Outstanding Balance";
                        GENJNLLINE.Validate(Amount);
                        GENJNLLINE."Posting Date" := TODAY;
                        GENJNLLINE."Document No." := Loans."No.";
                        GENJNLLINE."Transaction Type" := GENJNLLINE."Transaction Type"::Repayment;
                        GENJNLLINE."Loan No." := Loans."No.";
                        if GENJNLLINE.Amount <> 0 then
                            GENJNLLINE.Insert(true);
                        GENJNLLINE.INIT;

                        LINENUM := LINENUM + 10000;
                        GENJNLLINE."Line No." := LINENUM;
                        GENJNLLINE."Journal Template Name" := 'General';
                        GENJNLLINE."Journal Batch Name" := 'DEFAULT';
                        GENJNLLINE."Account Type" := GENJNLLINE."Account Type"::Customer;
                        GENJNLLINE."Account No." := acccredit."No.";
                        GENJNLLINE.Description := 'Loan balance from Loan ' + Loans."No.";
                        GENJNLLINE.Amount := -Loans."Outstanding Balance";
                        GENJNLLINE.Validate(Amount);
                        GENJNLLINE."Posting Date" := TODAY;
                        GENJNLLINE."Document No." := Loans."No.";
                        if GENJNLLINE.Amount <> 0 then
                            GENJNLLINE.Insert(true);
                    END;
                    // CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line", GENJNLLINE);
                END;
            END;

        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var

        LOANSAPP: Record Loans;
        GENJNLLINE: Record "Gen. Journal Line";
        acccredit: Record "Account Credit";
        AccountBalance: Decimal;
        LINENUM: Integer;


}
