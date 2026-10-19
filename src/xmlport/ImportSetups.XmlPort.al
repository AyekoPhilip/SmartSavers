xmlport 50006 "Import Setups"
{
    Caption = 'Import Setups';
    Direction = Both;
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(FixedDepositType; "Fixed Deposit Type")
            {
                fieldelement(Code; FixedDepositType."Code")
                {
                }
                fieldelement(Duration; FixedDepositType."Duration")
                {
                }
                fieldelement(Description; FixedDepositType.Description)
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



