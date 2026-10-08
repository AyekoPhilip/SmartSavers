namespace DynamicsNav.SaccoDatabase;

using Microsoft.Sales.Customer;
using SaccoDatabase.SaccoDatabase;
using Microsoft.Foundation.Company;

report 50020 "Board Allowances"
{
    ApplicationArea = All;
    Caption = 'Board Allowances';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/BoardAllowances.rdl';
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
            column(IESATAXAMOUNT; IESATAXAMOUNT)
            {

            }
            column(BOSATAXAMOUNT; BOSATAXAMOUNT)
            {

            }
            column(BoardSittingallowances; BoardSittingallowances)
            { }
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
            column(TravellAllowances; TravellAllowances)
            { }

            column(IESABoardEducationBoardSittingallowances; iesaBoardSittingallowances)
            {

            }

            column(iesastaffTravellAllowances; iesastaffTravellAllowances)
            {

            }
            column(iesaBoardsAgmAllowances; iesaBoardsAgmAllowances)
            {

            }
            column(iesaBoardspsittingallowances; iesaBoardspsittingallowances)
            {

            }
            column(iesaBoardTravelling; iesaBoardTravelling)
            {

            }
            column(iesaBoardEducation; iesaBoardEducation)
            {

            }

            column(iesaBoardSittingallowances; iesaBoardSittingallowances)
            {

            }

            column(IESATravellAllowances; IESATravellAllowances)
            {

            }
            column(IESATOTALAMOUNT; IESATOTALAMOUNT)
            {

            }
            column(BOSATOTALAMOUNT; BOSATOTALAMOUNT)
            {

            }
            column(totalamountpaid; totalamountpaid)
            { }
            column(netamount; netamount)
            { }
                        column(activity; activity)
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
                IESABoardSittingallowances := 0;
                IESABoardEducation := 0;
                IESABoardTravelling := 0;
                IESAstaffTravellAllowances := 0;
                IESATaxamount := 0;
                IESATravellAllowances := 0;
                IESABoardsAgmAllowances := 0;
                IESABoardspsittingallowances := 0;
                IESATOTALAMOUNT := 0;
                BOSATOTALAMOUNT := 0;
                totalamountpaid := 0;
                IESATAXAMOUNT := 0;
                BOSATAXAMOUNT := 0;

                netamount := 0;



                EVALUATE(FromDateS, FORMAT(startDate));
                EVALUATE(ToDateS, FORMAT(Enddate));
                DateFilter := FromDateS + '..' + ToDateS;


                //1 Bosa
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::Bosa);
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board Sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardSittingallowances := BoardSittingallowances+BoardExpenses."Amount Paid";
                        BOSATAXAMOUNT := BOSATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;

                //2
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::Bosa);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board Travelling and Subsistence");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardTravelling := BoardTravelling + BoardExpenses."Amount Paid";
                        BOSATAXAMOUNT := BOSATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //3
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::Bosa);
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board education and Training Expenses");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardEducation := BoardEducation + BoardExpenses."Amount Paid";
                        BOSATAXAMOUNT := BOSATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //4
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::Bosa);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Staff Travel Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        staffTravellAllowances := staffTravellAllowances + BoardExpenses."Amount Paid";
                        BOSATAXAMOUNT := BOSATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //5
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::Bosa);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Travelling Allwances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        TravellAllowances := TravellAllowances + BoardExpenses."Amount Paid";
                        BOSATAXAMOUNT := BOSATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //6
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::Bosa);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board AGM sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        BoardsAgmAllowances := BoardsAgmAllowances + BoardExpenses."Amount Paid";
                        BOSATAXAMOUNT := BOSATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //7
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::Bosa);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board SP sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        Boardspsittingallowances := Boardspsittingallowances + BoardExpenses."Amount Paid";
                        BOSATAXAMOUNT := BOSATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;

                //1 IESA
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::IESA);
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board Sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        IESABoardSittingallowances := IESABoardSittingallowances+BoardExpenses."Amount Paid";
                        IESATAXAMOUNT := IESATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //2
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::IESA);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board Travelling and Subsistence");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        IESABoardTravelling := IESABoardTravelling + BoardExpenses."Amount Paid";
                        IESATAXAMOUNT := IESATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //3
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::IESA);
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board education and Training Expenses");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        IESABoardEducation := IESABoardEducation + BoardExpenses."Amount Paid";
                        IESATAXAMOUNT := IESATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //4
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::IESA);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Staff Travel Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        IESAstaffTravellAllowances := IESAstaffTravellAllowances + BoardExpenses."Amount Paid";
                        IESATAXAMOUNT := IESATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //5
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::IESA);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Travelling Allwances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        IESATravellAllowances := IESATravellAllowances + BoardExpenses."Amount Paid";
                        IESATAXAMOUNT := IESATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //6
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::IESA);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board AGM sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        IESABoardsAgmAllowances := IESABoardsAgmAllowances + BoardExpenses."Amount Paid";
                        IESATAXAMOUNT := IESATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;
                //7
                BoardExpenses.RESET;
                BoardExpenses.SETRANGE(BoardExpenses."Member Number", Member."No.");
                BoardExpenses.SETFILTER(BoardExpenses."Payment Date", DateFilter);
                BoardExpenses.SETRANGE("Activity Type", BoardExpenses."Activity Type"::IESA);
                BoardExpenses.SETRANGE("Payment Type", BoardExpenses."Payment Type"::"Board SP sitting Allowances");
                IF BoardExpenses.FIND('-') THEN BEGIN
                    REPEAT
                        IESABoardspsittingallowances := IESABoardspsittingallowances + BoardExpenses."Amount Paid";
                        IESATAXAMOUNT := IESATAXAMOUNT + BoardExpenses."Tax Amount";
                        TaxAmount := TaxAmount + BoardExpenses."Tax Amount";
                    UNTIL BoardExpenses.NEXT = 0;
                END;

                totalamountpaid := (BoardSittingallowances + BoardEducation + BoardTravelling + staffTravellAllowances +
                  TravellAllowances + BoardsAgmAllowances + Boardspsittingallowances + iesaboardSittingallowances + iesaBoardEducation + iesaBoardTravelling + 
                  iesastaffTravellAllowances+iesaTravellAllowances + iesaBoardsAgmAllowances + iesaBoardspsittingallowances);
                  
                  IESATOTALAMOUNT := (iesaboardSittingallowances + iesaBoardEducation + iesaBoardTravelling + iesastaffTravellAllowances+
                  iesaTravellAllowances + iesaBoardsAgmAllowances + iesaBoardspsittingallowances);      
                 
                  BOSATOTALAMOUNT:= (BoardSittingallowances + BoardEducation + BoardTravelling + staffTravellAllowances +
                  TravellAllowances + BoardsAgmAllowances + Boardspsittingallowances );
                 

                netamount := (IESATOTALAMOUNT+BOSATOTALAMOUNT) -Taxamount;


                IF totalamountpaid = 0 then
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
        IESABoardSittingallowances: Decimal;
        IESABoardEducation: Decimal;
        IESABoardTravelling: Decimal;
        IESAstaffTravellAllowances: Decimal;
        IESATravellAllowances: Decimal;
        IESABoardsAgmAllowances: Decimal;
        IESABoardspsittingallowances: Decimal;
        IESATOTALAMOUNT: Decimal;
        BOSATOTALAMOUNT: Decimal;
        IESATAXAMOUNT: Decimal;
        BOSATAXAMOUNT: Decimal;
        netamount: Decimal;
        totalamountpaid: Decimal;
        totaltax: Decimal;
        DateFilter: Text[100];
        FromDateS: Text[100];
        ToDateS: Text[100];
        Startdate: Date;
        endDate: date;
        activity: Enum "Board Activity Type";
}

