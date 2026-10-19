report 50341 "Cashflow Projection Credit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CashflowProjectionCredit.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; Loans)
        {

            trigger OnAfterGetRecord()
            begin

                FromDate := StartDate;
                ToDate := CalcDate('1M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[1] := RecRef."Outstanding Balance";
                MonthPrinc[1] := RecRef."Outstanding Interest";

                FromDate := CalcDate('1M', StartDate);
                ToDate := CalcDate('2M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[2] := RecRef."Outstanding Balance";
                MonthPrinc[2] := RecRef."Outstanding Interest";


                FromDate := CalcDate('2M', StartDate);
                ToDate := CalcDate('3M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[3] := RecRef."Outstanding Balance";
                MonthPrinc[3] := RecRef."Outstanding Interest";


                FromDate := CalcDate('3M', StartDate);
                ToDate := CalcDate('4M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[4] := RecRef."Outstanding Balance";
                MonthPrinc[4] := RecRef."Outstanding Interest";


                FromDate := CalcDate('4M', StartDate);
                ToDate := CalcDate('5M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[5] := RecRef."Outstanding Balance";
                MonthPrinc[5] := RecRef."Outstanding Interest";

                FromDate := CalcDate('5M', StartDate);
                ToDate := CalcDate('6M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[6] := RecRef."Outstanding Balance";
                MonthPrinc[6] := RecRef."Outstanding Interest";


                FromDate := CalcDate('6M', StartDate);
                ToDate := CalcDate('7M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[7] := RecRef."Outstanding Balance";
                MonthPrinc[7] := RecRef."Outstanding Interest";


                FromDate := CalcDate('7M', StartDate);
                ToDate := CalcDate('8M-1D', StartDate);
                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RecRef.Reset;
                RecRef.SetFilter("Date Filter", DateFilter);
                RecRef.CalcFields("Outstanding Balance", "Outstanding Interest");
                MonthInt[8] := RecRef."Outstanding Balance";
                MonthPrinc[8] := RecRef."Outstanding Interest";



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
    }

    var
        RecRef: Record Loans;
        MonthInt: array[12] of Decimal;
        MonthPrinc: array[12] of Decimal;
        FromDate: Date;
        StartDate: Date;
        ToDate: Date;
        DateFilter: Text[100];
}




