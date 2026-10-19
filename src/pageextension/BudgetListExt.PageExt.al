pageextension 50049 "BudgetListExt" extends "G/L Budget Names"
{
    trigger OnDeleteRecord(): Boolean
    var
    begin
        Error('Deleting of budgets not permitted.Contact System administrator ');
    end;
}



