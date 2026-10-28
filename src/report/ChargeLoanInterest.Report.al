report 50801 "Charge Loan Interest"
{
    ApplicationArea = All;
    Caption = 'Charge Loan Interest';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loans; Loans)
        {
            RequestFilterFields = "No.", "Account No.", "Product Type";

            trigger OnPreDataItem()
            begin
                LockTable();
                SetRange("Date Filter", 0D, PostingDate);
                SetRange("Interest Options", "Interest Options"::"Charge Interest");
            end;

            trigger OnAfterGetRecord()
            var
                Product: Record "Product Factory";
                InterestAmount: Decimal;
            begin
                CalcFields("Outstanding Principal");
                if ("Outstanding Principal" <= 0) or
                   ("Interest Calculation Method" = "Interest Calculation Method"::"Zero Interest") or
                   ("Interest Rate" = 0) or (Installments = 1)
                then
                    CurrReport.Skip();

                if InterestAlreadyCharged("No.") then begin
                    AlreadyChargedCount += 1;
                    CurrReport.Skip();
                end;

                if "Interest Rate" < 0 then
                    FieldError("Interest Rate", 'must not be negative');
                TestField("Loan Account");
                Product.Get("Product Type");
                Product.TestField("Interest Account (G/L)");
                Product.TestField("Receivable Account (G/L)");

                // Outstanding Principal is an LCY FlowField, so post the charge in LCY.
                InterestAmount := Round("Outstanding Principal" * "Interest Rate" / 1200 * GetInterestPeriodFactor("No."),
                    GLSetup."Amount Rounding Precision");
                if InterestAmount <= 0 then
                    CurrReport.Skip();

                LineNo += 10000;
                JournalPost.PostJournal(JournalTemplate, JournalBatch, LineNo,
                    Enum::"Gen. Journal Account Type"::Customer, DocumentNo,
                    CopyStr(StrSubstNo('Interest charge - %1', "No."), 1, 100),
                    InterestAmount, "Loan Account", PostingDate,
                    Enum::"Gen. Journal Account Type"::"G/L Account", Product."Interest Account (G/L)",
                    "Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code",
                    Enum::LoanTransactionType::"Interest Due", "No.", "Group Code", '',
                    Enum::"Gen. Journal Document Type"::" ", '', Enum::"Gen. Journal Document Type"::" ");
                ChargedCount += 1;
                TotalInterest += InterestAmount;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(AsAtDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As-at / Posting Date';
                        ToolTip = 'Specifies the balance and posting date. Monthly interest is prorated from the latest interest charge in this month through this date using actual calendar days. If no interest has been charged in this month, a full month is charged.';

                        trigger OnValidate()
                        begin
                            UpdateDocumentNo();
                        end;
                    }
                    field(PostingDocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                        Editable = false;
                        ToolTip = 'Specifies the document number generated from the posting date, for example OCT-2026. Loans already charged under this document number are skipped.';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        PostingDate := WorkDate();
        UpdateDocumentNo();
    end;

    trigger OnPreReport()
    var
        UserTemplate: Record "Banking User Template";
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if PostingDate = 0D then
            Error('Enter an as-at / posting date.');
        UpdateDocumentNo();
        GLSetup.Get();
        GLSetup.TestField("Amount Rounding Precision");
        UserTemplate.SetRange("Account ID", UserId());
        UserTemplate.SetRange("Account Type", UserTemplate."Account Type"::"Automated Posting");
        if not UserTemplate.FindFirst() then
            Error('No automated posting setup exists for user %1.', UserId());
        UserTemplate.TestField("Bills Template");
        UserTemplate.TestField("Bills Batch");
        JournalTemplate := UserTemplate."Bills Template";
        JournalBatch := UserTemplate."Bills Batch";
        GenJournalTemplate.Get(JournalTemplate);
        GenJournalTemplate.TestField(Recurring, false);
        GenJournalBatch.Get(JournalTemplate, JournalBatch);
        GenJournalLine.LockTable();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJournalLine.FindSet() then
           GenJournalLine.DeleteAll();
        ChargedCount := 0;
        AlreadyChargedCount := 0;
        TotalInterest := 0;
        LineNo := 0;
    end;

    trigger OnPostReport()
    var
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        if GenJournalLine.FindFirst() then begin
            GenJnlPostBatch.SetSuppressCommit(true);
            GenJnlPostBatch.Run(GenJournalLine);
        end;
        if GuiAllowed() then
            Message('Interest charging completed. Loans charged: %1. Total interest (LCY): %2. Loans already charged for this document number: %3.',
                ChargedCount, TotalInterest, AlreadyChargedCount);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GenJournalLine: Record "Gen. Journal Line";
        JournalPost: Codeunit "Journal Post Mngt.";
        PostingDate: Date;
        DocumentNo: Code[20];
        JournalTemplate: Code[10];
        JournalBatch: Code[10];
        TotalInterest: Decimal;
        LineNo: Integer;
        ChargedCount: Integer;
        AlreadyChargedCount: Integer;

    local procedure UpdateDocumentNo()
    begin
        if PostingDate = 0D then begin
            Clear(DocumentNo);
            exit;
        end;
        DocumentNo := SelectStr(Date2DMY(PostingDate, 2), 'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC') +
            '-' + Format(PostingDate, 0, '<Year4>');
    end;

    local procedure GetInterestPeriodFactor(LoanNo: Code[20]): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        MonthStart: Date;
        MonthEnd: Date;
        LastInterestChargeDate: Date;
    begin
        MonthStart := CalcDate('<-CM>', PostingDate);
        MonthEnd := CalcDate('<CM>', PostingDate);
        CustLedgerEntry.SetRange("Loan No.", LoanNo);
        CustLedgerEntry.SetRange("Posting Date", MonthStart, PostingDate);
        CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Interest Due");
        CustLedgerEntry.SetRange(Reversed, false);
        // Compare posting dates explicitly: backdated entries may have higher entry numbers.
        if CustLedgerEntry.FindSet() then
            repeat
                if CustLedgerEntry."Posting Date" > LastInterestChargeDate then
                    LastInterestChargeDate := CustLedgerEntry."Posting Date";
            until CustLedgerEntry.Next() = 0;

        if LastInterestChargeDate = 0D then
            exit(1);

        // The previous charge covers its posting date; start counting the following day.
        exit((PostingDate - LastInterestChargeDate) / (MonthEnd - MonthStart + 1));
    end;

    local procedure InterestAlreadyCharged(LoanNo: Code[20]): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Loan No.", LoanNo);
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Interest Due");
        CustLedgerEntry.SetRange(Reversed, false);
        exit(not CustLedgerEntry.IsEmpty());
    end;
}
