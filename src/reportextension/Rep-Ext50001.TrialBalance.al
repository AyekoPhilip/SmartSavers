reportextension 50001 "Trial Balance" extends "Trial Balance"
{
    dataset
    {
        add("g/l account")
        {

            column(totalcredit; totalcredit)
            {
            }

            column(totalcreditbal; totalcreditbal)
            {
            }
            column(totaldebit; totaldebit)
            {
            }
            column(totaldebitbal; totaldebitbal)
            {
            }
        }
        modify("g/l account")

        {
            trigger OnAfterAfterGetRecord()
            begin
                Totaldebit := 0;
                Totalcreditbal := 0;
                Totalcredit := 0;
                Totaldebitbal := 0;
                CalcFields("Net Change", "Balance at Date");
                if "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting then begin
                    if "Net Change" > 0 then
                        Totaldebit := Totaldebit + "Net Change";
                    if "Net Change" < 0 then
                        Totalcredit := Totalcredit + "Net Change";
                end;

                if "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting then begin
                    if "Balance at Date" > 0 then
                        Totaldebitbal := Totaldebitbal + "Balance at Date";
                    if "Balance at Date" < 0 then
                        Totalcreditbal := Totalcreditbal + "Balance at Date";
                end;
            end;
        }
    }
    var
        totaldebit: Decimal;
        totalcredit: Decimal;
        totaldebitbal: Decimal;
        totalcreditbal: Decimal;
}
