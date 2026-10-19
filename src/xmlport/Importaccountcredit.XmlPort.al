namespace SaccoDatabase.SaccoDatabase;

xmlport 90000 Importaccountcredit
{
    Caption = 'Importaccountcredit';
    Direction = Both;
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(AccountCredit; "Account Credit")
            {
                 fieldelement(No; AccountCredit."No.")
                {
                }
                fieldelement(Name; AccountCredit.Name)
                {
                }
                fieldelement(ProductType; AccountCredit."Product Type")
                {
                }
                fieldelement(ProductName; AccountCredit."Product Name")
                {
                }
                fieldelement(StaffPayrollNo; AccountCredit."Staff/Payroll No.")
                {
                }
                fieldelement(AccountCategory; AccountCredit."Account Category")
                {
                }
                fieldelement(Balance; AccountCredit.Balance)
                {
                }
               
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
