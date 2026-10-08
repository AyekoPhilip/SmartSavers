namespace DynamicsNav.DynamicsNav;

using Microsoft.Finance.GeneralLedger.Journal;

enumextension 50058 JournalSourceType extends "Gen. Journal Source Type"
{
    
    value(50000; Savings)
    {
        Caption = 'Savings';
    }
    value(50001; Credit)
    {
        Caption = 'Credit';
    }
    value(50002; Repayment)
    {
        Caption = 'Repayment';
    }
    value(50003; Loan)
    {
        Caption = 'Loan';
    }
}
