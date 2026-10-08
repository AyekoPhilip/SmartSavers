codeunit 50051 "G/L Reg.-Savings.Ledger"
{
    TableNo = "G/L Register";

    trigger OnRun()
    begin
        SavingsLedgEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        PAGE.Run(PAGE::"Savings Ledger Entries", SavingsLedgEntry);
    end;

    var
        SavingsLedgEntry: Record "Banking A/c Ledger Entry";
}




