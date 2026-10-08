namespace SaccoDatabase.SaccoDatabase;

report 50438 "Board Expenses"
{
    ApplicationArea = All;
    Caption = 'Board Allowances';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/Boardexpenses.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            DataItemTableView = where("Member Category" = filter('DIRECTOR' | 'STAFF'));
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }
            column(Startdate; Startdate)
            {

            }
            column(endDate; endDate)
            {

            }
            column(Taxamount; Taxamount)
            {

            }
            column(staffTravellAllowances; staffTravellAllowances)
            {

            }
            column(BoardsAgmAllowances; BoardsAgmAllowances)
            {

            }
            column(Boardspsittingallowances; Boardspsittingallowances)
            {

            }
            column(BoardTravelling; BoardTravelling)
            {

            }
            column(BoardEducation; BoardEducation)
            {

            }
            column(BoardSittingallowances; BoardSittingallowances)
            {

            }
            column(TravellAllowances; TravellAllowances)
            {

            }
    
            trigger OnPreDataItem()
            begin
                IF startDate = 0D THEN
                    ERROR('You must specify start Date.');

                IF Enddate = 0D THEN
                    ERROR('You must specify End Date.');
            end;

            trigger OnAfterGetRecord()
            begin

                BoardSittingallowances := 0;
                BoardEducation := 0;
                BoardTravelling := 0;
                staffTravellAllowances := 0;
                Taxamount := 0;
                TravellAllowances := 0;
                BoardsAgmAllowances := 0;
                Boardspsittingallowances := 0;


                EVALUATE(FromDateS, FORMAT(startDate));
                EVALUATE(ToDateS, FORMAT(Enddate));
                DateFilter := FromDateS + '..' + ToDateS;
                //1
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board Sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardSittingallowances := BoardSittingallowances + BoardExpenses."Amount Paid";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //2
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board Travelling and Subsistence");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardTravelling := BoardTravelling + BoardExpenses."Amount Paid";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //3
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board education and Training Expenses");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardEducation := BoardEducation + BoardExpenses."Amount Paid";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //4
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Staff Travel Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        staffTravellAllowances := staffTravellAllowances + BoardExpenses."Amount Paid";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //5
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Travelling Allwances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        TravellAllowances := TravellAllowances + BoardExpenses."Amount Paid";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //6
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board AGM sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardsAgmAllowances := BoardsAgmAllowances + BoardExpenses."Amount Paid";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //7
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board SP sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        Boardspsittingallowances := Boardspsittingallowances + BoardExpenses."Amount Paid";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                IF (BoardSittingallowances + BoardEducation + BoardTravelling + staffTravellAllowances + Taxamount +
                                 TravellAllowances + BoardsAgmAllowances + Boardspsittingallowances) = 0 then
                    CurrReport.Skip();


            end;

            trigger OnPostDataItem()
            begin

            end;
        }

    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field(Startdate; Startdate)
                {
                    ApplicationArea = All;
                }
                field(endDate; endDate)
                {
                    ApplicationArea = All;
                }

            }
        }

    }
    VAR
        BoardExpenses: Record "Board allowance table";
        BoardSittingallowances: Decimal;
        BoardEducation: Decimal;
        BoardTravelling: Decimal;
        staffTravellAllowances: Decimal;
        Taxamount: Decimal;
        TravellAllowances: Decimal;
        BoardsAgmAllowances: Decimal;
        Boardspsittingallowances: Decimal;
        DateFilter: Text[100];
        FromDateS: Text[100];
        ToDateS: Text[100];
        Startdate: Date;
        endDate: date;
}

