namespace AltChannelPostMgt.AltChannelPostMgt;

codeunit 90005 "Rcv10 Credt Procedure Mgt."
{

    procedure CalcAvailableBal(AccountNo: Code[100]): Decimal
    var
        MinBalance: Decimal;
        Account: Record "Account Banking";
        ProdType: Record "Product Factory";
        ErrorOnAvailableBal: Label 'This account is below Min Balance of % and therefore subsiquent transactions not allowed';
    begin

        MinBalance := 0;

        Account.Reset();
        Account.SetRange("No.", AccountNo);
        if Account.FindFirst() then begin
            Account.CalcFields(Account."Balance (LCY)", Account."Uncleared Cheques",
            Account."Authorised Over Draft", Account."Lien Placed", Account."ATM Transactions");
            
            ProdType.Reset;
            ProdType.SetRange("Product ID", Account."Product Type");
            if ProdType.FindFirst() then begin
                exit(Account."Balance (LCY)" - (Account."Uncleared Cheques" + Account."Lien Placed" + Account."ATM Transactions"));
            end;
        end;
    end;

}
