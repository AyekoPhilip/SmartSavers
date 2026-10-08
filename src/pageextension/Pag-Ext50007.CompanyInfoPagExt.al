pageextension 50007 "Company Info Pag Ext" extends "Company Information"
{
    Editable=true;
    layout
    {
        addlast(General)
        {
            field("Document Path"; Rec."Document Path")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Path field';
            }
            field("Online Document Path"; Rec."Online Document Path")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Online Document Path field';
            }
        }
        addafter("Bank Name")
        {
            field("Bank Account Name"; Rec."Bank Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Name field';
            }
        }
        addafter("Bank Branch No.")
        {
            field("Bank Branch Name"; Rec."Bank Branch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Branch Name field';
            }
        }
        addafter("User Experience")
        {
            group("E-Mail Settings")
            {
                field("E-Mail Signature"; EmailSignText)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EmailSignText field';

                    trigger OnValidate()
                    begin
                        Rec.CalcFields("E-Mail Signature");
                        Rec."E-Mail Signature".CreateInStream(InStr);
                        EmailSignBigText.Read(InStr);

                        if EmailSignText <> Format(EmailSignBigText) then begin
                            Clear(Rec."E-Mail Signature");
                            Clear(EmailSignBigText);
                            EmailSignBigText.AddText(EmailSignText);
                            Rec."E-Mail Signature".CreateOutStream(OutStr);
                            EmailSignBigText.Write(OutStr);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("E-Mail Signature");
        Rec."E-Mail Signature".CreateInStream(InStr);
        EmailSignBigText.Read(InStr);
        EmailSignText := Format(EmailSignBigText);
    end;

    var
        EmailSignBigText: BigText;
        InStr: InStream;
        OutStr: OutStream;
        EmailSignText: Text;
}


