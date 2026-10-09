report 50320 "Fixed Deposit Certificate"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/FixedDepositCertificate.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Account Banking"; "Account Banking")
        {
            RequestFilterFields = "No.";
            column(DayT; Today)
            {
            }
            column(No; "Account Banking"."No.")
            {
            }
            column(Amount; Bal)
            {
            }
            column(Name; "Account Banking".Name)
            {
            }
            column(FixedDuration; DuratinFD)
            {
            }
            column(Rate; Rate)
            {
            }
            column(NumberText; NumberText[1])
            {
            }
            column(InterestExpected; InterestExpected)
            {
            }
            column(RefNo; RefNo)
            {
            }
            column(WthTax; WthTax)
            {
            }
            column(MaturityD; MaturityD)
            {
            }
            column(compName; CompanyName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*
                FixedDepLine.SETRANGE(FixedDepLine."Account No",Table39004418."No.");
                FixedDepLine.SETRANGE(FixedDepLine."Reference No",RefNo);
                IF FixedDepLine.FIND('-') THEN BEGIN
                IF FixedDepLine.Amount>0 THEN BEGIN
                Rate:=FixedDepLine."Negotiated Interest";
                Bal:=FixedDepLine.Amount;
                FdType:=FixedDepLine."Fixed Deposit Type";
                InterestExpected:=FixedDepLine."Interest Expected";
                WthTax:=(FixedDepLine."Interest Expected")*0.15;
                DuratinFD:=FORMAT(FixedDepLine.Duration);
                MaturityD:=FixedDepLine."Maturity Date";
                END;
                END;
                //Amount into words
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText,Bal,'');
                {
                IntRule.RESET;
                IntRule.SETRANGE(IntRule.Code,"SACCO Account"."Fixed Deposit Type");
                IF IntRule.FIND('-') THEN BEGIN
                REPEAT
                IF (Bal>IntRule."Minimum Amount") AND (Bal<IntRule."Maximum Amount") THEN BEGIN
                Rate:=IntRule."Interest Rate";
                END;
                UNTIL IntRule.NEXT=0;
                END;
                IF "SACCO Account"."Neg. Interest Rate"<>0 THEN
                Rate:="SACCO Account"."Neg. Interest Rate";
                }*/

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(RefNo; RefNo)
                {
                    Caption = 'Reference No.';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Rate: Decimal;
        NumberText: array[2] of Text[120];
        Bal: Decimal;
        RefNo: Code[30];
        InterestExpected: Decimal;
        WthTax: Decimal;
        DuratinFD: Code[20];
        MaturityD: Date;
}




