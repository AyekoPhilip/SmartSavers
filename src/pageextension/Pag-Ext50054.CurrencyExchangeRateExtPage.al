pageextension 50054 "CurrencyExchangeRateExt.Page" extends "Currency Exchange Rates"
{
    layout
    {
        addafter("Exchange Rate Amount")
        {
            field("Custom Exchange Rate"; Rec."Custom Exchange Rate")
            {
                ApplicationArea = All;
                Caption = 'Custom Exchange Rate';
            }
        }
    }
}




