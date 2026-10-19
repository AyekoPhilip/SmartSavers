tableextension 50032 "CurrencyExchangeRate.Table.Ext" extends "Currency Exchange Rate"
{
    fields
    {
        field(50009; "Custom Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Custom Exchange Rate';
        
            trigger OnValidate()
            begin
                ExchangeRates.reset;
                // ExchangeRates.

                Conversion := (1 / "Custom Exchange Rate");
                "Exchange Rate Amount" := Conversion;

            end;
        }
    }

    var

        Curr: Record Currency;
        Conversion: Decimal;

        ExchangeRates: Record "Currency Exchange Rate";
}



