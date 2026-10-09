codeunit 50052 "G/L Reg.-Credit.Ledger"
{
    TableNo = "G/L Register";

    trigger OnRun()
    begin
        CreditLedgEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        PAGE.Run(PAGE::"Loan Ledger Entries", CreditLedgEntry);
    end;

    var
        CreditLedgEntry: Record "Loan Ledger Entry";
}




