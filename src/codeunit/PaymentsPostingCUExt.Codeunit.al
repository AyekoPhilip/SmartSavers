codeunit 50010 "PaymentsPostingCUExt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-SetAppl.ID", 'OnAfterUpdateVendLedgerEntry', '', false, false)]
    local procedure ValidateAppliesToID(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var TempVendLedgEntry: Record "Vendor Ledger Entry" temporary; ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; AppliesToID: Code[50])
    begin
        VendorLedgerEntry.Validate("Applies-to ID");
        VendorLedgerEntry.Modify();
    end;

   /*  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeInitBankAccLedgEntry', '', false, false)]
    local procedure PreventOverdrawingBank(var GenJournalLine: Record "Gen. Journal Line")
    var
        BankAcc: Record "Bank Account";
        OverdrawWarningMsg: Label 'Please note that this transaction will result in an Overdraw of Bank Account %1';
    begin
        if BankAcc.Get(GenJournalLine."Account No.") then begin
            BankAcc.CalcFields("Balance (LCY)");
            if GenJournalLine."Credit Amount" <> 0 then begin
                if (BankAcc."Balance (LCY)" - GenJournalLine."Credit Amount") < 0 then
                    Message(OverdrawWarningMsg, BankAcc.Name);
            end;
        end; */
   // end;
}


