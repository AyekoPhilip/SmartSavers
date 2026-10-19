codeunit 50001 "ModF. Entry"
{
    TableNo = Loans;
    Permissions = TableData "G/L Account" = r,
                  TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = imd,
                  TableData "Vendor Ledger Entry" = imd,
                  TableData "G/L Register" = imd,
                  TableData "G/L Entry - VAT Entry Link" = rimd,
                  TableData "VAT Entry" = imd,
                  TableData "Bank Account Ledger Entry" = imd,
                  TableData "Check Ledger Entry" = imd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = imd,
                  TableData "Line Fee Note on Report Hist." = rim,
                  TableData "Employee Ledger Entry" = imd,
                  TableData "Detailed Employee Ledger Entry" = imd,
                  TableData "FA Ledger Entry" = rimd,
                  TableData "FA Register" = imd,
                  TableData "Maintenance Ledger Entry" = rimd;

    trigger OnRun()
    begin
        ModfLoanAccount(Rec, 62699);
    end;

    procedure ModfLoanAccount(LoanRec: Record Loans; EntryNo: Integer)
    begin

        DetailedCust.Reset();
        DetailedCust.SetRange("Entry No.", EntryNo);
        if DetailedCust.FindFirst() then begin
            Message('%1-%2', LoanRec."No.", DetailedCust."Customer No.");
            DetailedCust."Loan No." := LoanRec."No.";
            DetailedCust.Modify(true)
        end;

    end;

    var
        DetailedCust: Record "Detailed Cust. Ledg. Entry";

}



