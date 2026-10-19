enum 99002 PayrollRequestCalculation
{
    Extensible = false;

    value(0; "Flat amount")
    {
        Caption = 'Flat amount';
    }
    value(1; "% of Basic pay")
    {
        Caption = '% of Basic pay';
    }
    value(2; "% of Gross pay")
    {
        Caption = '% of Gross pay';
    }
    value(3; "% of Insurance Amount")
    {
        Caption = '% of Insurance Amount';
    }
    value(4; "% of Taxable income")
    {
        Caption = '% of Taxable income';
    }
    value(5; "% of Basic after tax")
    {
        Caption = '% of Basic after tax';
    }
    value(6; "Based on Hourly Rate")
    {
        Caption = 'Based on Hourly Rate';
    }
    value(7; "Based on Daily Rate")
    {
        Caption = 'Based on Daily Rate';
    }
    value(8; Formula)
    {
        Caption = 'Formula';
    }
}