report 50405 "Update Bank Ledger Referencin"
{
    ApplicationArea = All;
    Caption = 'Update Bank Ledger Referencing';
    UsageCategory = Lists;
    ProcessingOnly = true;
    Permissions = tabledata "Bank Account Ledger Entry" = rm;
    dataset
    {
        dataitem(BankLedgerEntry; "Bank Account Ledger Entry")
        {

            trigger OnAfterGetRecord()
            var
                Customer: Record Member;
            begin
                BankLedgerEntry.Setfilter("Description", '<>%1', '');
                if BankLedgerEntry.FindSet() then begin
                    repeat
                        //if Customer.Get(Customer.Name, BankLedgerEntry."Description") then begin
                        Customer.SetRange(Customer.Name, BankLedgerEntry."Description");
                        if Customer.FindFirst() then begin
                            BankLedgerEntry."Member No" := Customer."No.";
                            BankLedgerEntry.Modify();
                        end;
                    until BankLedgerEntry.Next() = 0;
                end;
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }

    }

}
