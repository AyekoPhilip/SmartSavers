xmlport 50019 "ImportBanking"
{
    Caption = 'ImportBanking';
    Direction = Both;
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(AccountBanking; "Account Banking")
            {
                fieldelement(No; AccountBanking."No.")
                {
                }
                fieldelement(Status; AccountBanking.Status)
                {
                }

                fieldelement(NameTxt; AccountBanking.Name)
                {

                }
                fieldelement(IDPassportNo; AccountBanking."ID/Passport No.")
                {
                }
                fieldelement(ProductType; AccountBanking."Product Type")
                {
                }

            }
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



