xmlport 50000 "Temp. Alt. Channels"
{
    Caption = 'Temp. Alt. Channels';
    TableSeparator = '<NewLine>';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(TempAltChannels; "Temp. Alt. Channels")
            {
                fieldelement(TraceID; TempAltChannels."Trace ID")
                {
                }
                fieldelement(ReferenceNo; TempAltChannels."Reference No")
                {
                }
                fieldelement(Amount; TempAltChannels.Amount)
                {
                }
                fieldelement(ChargeAmount; TempAltChannels."Charge Amount")
                {
                }
                fieldelement(AccountNo; TempAltChannels."Account No")
                {
                }
                fieldelement(Description; TempAltChannels.Description)
                {
                }
                fieldelement(PhoneNo; TempAltChannels."Phone No.")
                {
                }
                fieldelement(ChargeCode; TempAltChannels."Charge Code")
                {
                    FieldValidate = Yes;
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
    trigger OnInitXmlPort()
    begin
     

    end;

    trigger OnPreXmlPort()
    begin

        

    end;

    trigger OnPostXmlPort()
    begin

    end;

    var
        TempData: Record "Temp. Alt. Channels";
}



