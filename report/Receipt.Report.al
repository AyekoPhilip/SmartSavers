report 50011 "Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/Receipt.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = where(Positive = const(true));

            dataitem(Copies; "Integer")
            {
                column(Comp_Address; StrSubstNo(TXT002, CompanyInfo.Address, CompanyInfo."Post Code", CompanyInfo.City))
                {
                }
                column(Comp_Picture; CompanyInfo.Picture)
                {
                }
                column(PostingDate; Format("Bank Account Ledger Entry"."Posting Date"))
                {
                }
                column(ChequeNo; "Bank Account Ledger Entry"."External Document No.")
                {
                }
                column(ReceivedFrom; "Bank Account Ledger Entry".Description)
                {
                }
                column(NumberText_1; NumberText[1])
                {
                }
                column(NumberText_2; NumberText[2])
                {
                }
                column(Desc; Desc)
                {
                }
                column(AmoountInFigures; StrSubstNo('%1  %2', CurrencyCodeText, TotalAmount))
                {
                }
                column(Comp_Name; UpperCase(CompanyInfo.Name))
                {
                }
                column(DocumentNo; "Bank Account Ledger Entry"."Document No.")
                {
                }
                column(Pay_Mode; PayMode)
                {
                }
                column(Number; Number)
                {
                }

                trigger OnPreDataItem()
                begin
                    Copies.SetRange(Number, 1, 1);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                if "Currency Code" <> '' then
                    CurrencyCodeText := "Currency Code"
                else
                    CurrencyCodeText := GLsetup."LCY Code";



                Banks.Reset();
                Banks.SetRange(Banks."No.", "Bank Account Ledger Entry"."Bank Account No.");
                if Banks.Find('-') then begin
                    BankName := Banks.Name;
                end
                else begin
                    BankName := '';
                end;
                /*
                PaymentMgt.InitTextVariable;
                PaymentMgt.FormatNoText(NumberText,Amount,CurrencyCodeText);
                */
                TotalAmount := TotalAmount + Amount;
                Users.Reset();
                Users.SetRange("User Name", "User ID");
                if Users.FindFirst() then
                    if Users."Full Name" <> '' then
                        UserName := Users."Full Name"
                    else
                        UserName := "User ID";
                //Get Description
                GLEntry.SetRange(GLEntry."Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
                GLEntry.SetFilter(GLEntry."Source No.", '<>%1', "Bank Account Ledger Entry"."Bank Account No.");
                if GLEntry.FindFirst() then begin
                    repeat
                        Desc := GLEntry.Description;
                    until
                    GLEntry.Next() = 0;
                end;

                //Pay Mode
                // ReceiptRec.Reset();
                //// ReceiptRec.SetRange("No.", "Bank Account Ledger Entry"."Document No.");
                // if ReceiptRec.Find('-') then
                ///// PayMode := ReceiptRec."Pay Mode";
                /////
                //  PaymentMgt.InitTextVariable();
                // PaymentMgt.FormatNoText(NumberText, TotalAmount, CurrencyCodeText);
            end;

            trigger OnPreDataItem()
            begin

                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }
    labels
    {
        Rcpt = 'RECEIPT';
        RcptNo = 'RECEIPT NUMBER';
        RcptD = 'RECEIPT DETAILS';
        Date = 'DATE';
        PayMode = 'PAY MODE';
        RFrom = 'RECEIVED FROM';
        CDate = 'CHEQUE DATE';
        SumOf = 'THE SUM OF';
        BeingP = 'BEING PAYMENT FOR';
        Amount = 'AMOUNT';
        WThanks = 'WITH THANKS';
    }

    var
        Banks: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        GLsetup: Record "General Ledger Setup";
        ReceiptRec: Record "Payments Header";
        Users: Record User;
        CurrencyCodeText: Code[150];
        PayMode: Code[150];
        TotalAmount: Decimal;
        TXT002: Label '%1, %2 %3';
        Text029: Label '%1 results in a written number that is too long.';
        Text028: Label 'AND';
        Text061: Label 'BILLION';
        Text039: Label 'EIGHT';
        Text049: Label 'EIGHTEEN';
        Text057: Label 'EIGHTY';
        Text042: Label 'ELEVEN';
        Text046: Label 'FIFTEEN';
        Text054: Label 'FIFTY';
        Text036: Label 'FIVE';
        Text053: Label 'FORTY';
        Text035: Label 'FOUR';
        Text045: Label 'FOURTEEN';
        Text027: Label 'HUNDRED';
        Text060: Label 'MILLION';
        Text040: Label 'NINE';
        Text050: Label 'NINETEEN';
        Text058: Label 'NINETY';
        Text032: Label 'ONE';
        Text038: Label 'SEVEN';
        Text048: Label 'SEVENTEEN';
        Text056: Label 'SEVENTY';
        Text037: Label 'SIX';
        Text047: Label 'SIXTEEN';
        Text055: Label 'SIXTY';
        Text041: Label 'TEN';
        Text044: Label 'THIRTEEN';
        Text052: Label 'THIRTY';
        Text059: Label 'THOUSAND';
        Text034: Label 'THREE';
        Text043: Label 'TWELVE';
        Text051: Label 'TWENTY';
        Text033: Label 'TWO';
        Text026: Label 'ZERO';
        BankName: Text[250];
        Desc: Text[250];
        ExponentText: array[5] of Text[250];
        NumberText: array[2] of Text[250];
        OnesText: array[20] of Text[250];
        TensText: array[10] of Text[250];
        UserName: Text[250];

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Exponent: Integer;
        Hundreds: Integer;
        NoTextIndex: Integer;
        Ones: Integer;
        Tens: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, Format(No * 100) + '/100');

        if CurrencyCode <> '' then
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;
}


