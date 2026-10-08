xmlport 50017 "Temp Data"
{
    Caption = 'Temp Data';
    Direction = Both;
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(RecRef; "Temp Data")
            {
                fieldelement(nos; RecRef."No.")
                { }
                fieldelement(no; RecRef."Application No.")
                { }
                fieldelement(amount; RecRef."Application Date")
                { }
                fieldelement(Descript; RecRef."Product Type")
                { }
                fieldelement(Custno; RecRef."Old Account No.")
                { }
                fieldelement(disAmount; RecRef."Account No.")
                { }
                fieldelement(outbal; RecRef."Requested Amount")
                { }
                fieldelement(outInt; RecRef.Amount)
                { }
                fieldelement(Installm; RecRef.Installment)
                { }
                fieldelement(Issuedate; RecRef."Issued Date")
                { }
                fieldelement(intm; RecRef."Interest Method")
                { }
                fieldelement(RepayDate; RecRef."Repayement Start Date")
                { }
                fieldelement(outBal; RecRef."Outstanding Bal")
                { }


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
