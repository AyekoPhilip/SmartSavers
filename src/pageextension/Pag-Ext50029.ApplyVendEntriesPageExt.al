pageextension 50029 "ApplyVendEntriesPageExt" extends "Apply Vendor Entries"
{
    procedure SetPaymentLine(NewPaymentLine: Record "Payment Lines"; ApplnTypeSelect: Integer)
    var
        PaymentLine: Record "Payment Lines";
        PaymentRec: Record "Payments Header";
        PaymentLineApply: Boolean;
        ApplnCurrencyCode: Code[20];
        ApplnDate: Date;
        ApplyingAmount: Decimal;
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        CalcType: Option Direct,GenJnlLine,SalesHeader,ServHeader,Payments;
    begin
        PaymentLine := NewPaymentLine;
        PaymentLineApply := true;
        PaymentRec.Get(PaymentLine.No);
        if PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor then
            ApplyingAmount := PaymentLine.Amount;
        ApplnDate := PaymentRec.Date;
        ApplnCurrencyCode := PaymentRec.Currency;
        CalcType := CalcType::Payments;
        case ApplnTypeSelect of
            PaymentLine.FieldNo("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            PaymentLine.FieldNo("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        end;
        SetApplyingVendLedgEntry();
    end;
}


