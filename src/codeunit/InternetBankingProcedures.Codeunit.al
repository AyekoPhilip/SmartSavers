codeunit 50012 "Internet Banking Procedures"
{
    procedure GetCusomterBalance(CustNo: Code[20]): Decimal
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustNo);
        Customer.CalcFields(Balance, "Balance (LCY)");

        exit(Customer."Balance (LCY)");
    end;
}



