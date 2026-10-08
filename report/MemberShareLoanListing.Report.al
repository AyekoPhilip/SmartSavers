namespace SaccoDatabase.SaccoDatabase;

report 90017 "Member Share Loan Listing"
{
    ApplicationArea = All;
    Caption = 'Member Share Loan Listing';
    UsageCategory = Lists;
    ExcelLayout = './src/report_layout/Membershareloanlisting.xlsx';
    RDLCLayout = './src/report_layout/Membershareloanlisting.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields="No.","Account Category";

            column(No_; "No.")
            { }
            column(Name; Name)
            { }
            column(ID_No_; "ID No.")
            { }
            column(Employer_Code; "Employer Code")
            { }
            column(sharecapital; sharecapital)
            { }
            column(saccodeposit; saccodeposit)
            { }
            column(iesasavings; iesasavings)
            { }
            column(MUSHARAKASAVINGS; MUSHARAKASAVINGS)
            { }
            column(holidaysaving; holidaysaving)
            { }
            column(UboraAmal; UboraAmal)
            { }
            column(BusinessLoan; BusinessLoan)
            { }
            column(DefaulterLoan; DefaulterLoan)
            { }
            column(IesaEmergone; IesaEmergone)
            { }
            column(Iesanormalloan; Iesanormalloan)
            { }
            column(IesaEmergtwo; IesaEmergtwo)
            { }
            column(makarabisholoan; makarabisholoan)
            { }
            column(musharakaNormloan; musharakaNormloan)
            { }
            column(Uboraschoolfeesloan; Uboraschoolfeesloan)
            { }
            column(uboracollageLoan; uboracollageLoan)
            { }
            column(Uboraemergencyloan; Uboraemergencyloan)
            { }
            column(uboradevloan; uboradevloan)
            { }
            column(nums; nums)
            { }
            column(iesanumber;iesanumber)
            {}
            column(uboracollagetwo;uboracollagetwo)
            {}



            trigger OnPreDataItem()
            begin


                IF Enddate = 0D THEN
                    ERROR('You must specify End Date.');

            end;

            trigger OnAfterGetRecord()
            begin
                sharecapital := 0;
                saccodeposit := 0;
                iesasavings := 0;
                holidaysaving := 0;
                MUSHARAKASAVINGS := 0;
                UboraAmal := 0;
                BusinessLoan := 0;
                DefaulterLoan := 0;
                IesaEmergone := 0;
                IesaEmergtwo := 0;
                iesanumber:='';

                // DEPOSIT
                acccredit.Reset();
                acccredit.SetRange("Member No.", "No.");
                acccredit.SetRange("Date Filter", 0D, ENDDATE);
                acccredit.SetRange("Product Type", 'DP-00103');
                IF acccredit.Find('-') THEN begin
                    acccredit.CalcFields("Balance (LCY)");
                    saccodeposit := acccredit."Balance (LCY)";
                end;
                // SHARE CAPITAL
                acccredit.Reset();
                acccredit.SetRange("Member No.", "No.");
                acccredit.SetRange("Date Filter", 0D, ENDDATE);
                acccredit.SetRange("Product Type", 'SC-00102');
                IF acccredit.Find('-') THEN begin
                    acccredit.CalcFields("Balance (LCY)");
                    sharecapital := acccredit."Balance (LCY)";
                end;
                // IESA SAVINGS
                accbanking.Reset();
                accbanking.SetRange("Member No.", "No.");
                accbanking.SetRange("Date Filter", 0D, ENDDATE);
                accbanking.SetRange("Product Type", 'IE-00109');
                if accbanking.Find('-') THEN BEGIN
                    accbanking.CalcFields("Balance (LCY)");
                    iesasavings := accbanking."Balance (LCY)";
                    iesanumber:=accbanking."Old Member No."; 
                END;



                // HOLIDAY SAVINGS
                accbanking.Reset();
                accbanking.SetRange("Member No.", "No.");
                accbanking.SetRange("Date Filter", 0D, ENDDATE);
                accbanking.SetRange("Product Type", 'HD-00108');
                if accbanking.Find('-') THEN BEGIN
                    accbanking.CalcFields("Balance (LCY)");
                    holidaysaving := accbanking."Balance (LCY)";
                END;

                // MUSHARAKA
                accbanking.Reset();
                accbanking.SetRange("Member No.", "No.");
                accbanking.SetRange("Date Filter", 0D, ENDDATE);
                accbanking.SetRange("Product Type", 'MS-0010');
                if accbanking.Find('-') THEN BEGIN
                    accbanking.CalcFields("Balance (LCY)");
                    MUSHARAKASAVINGS := accbanking."Balance (LCY)";
                END;

                
                // loans
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/100');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        UboraAmal := UboraAmal + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;

                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/101');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        BusinessLoan := BusinessLoan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;

                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/105');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        DefaulterLoan := DefaulterLoan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;

                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/109');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        IesaEmergone := IesaEmergone + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;

                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/110');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        IesaEmergtwo := IesaEmergtwo + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;
                uboracollagetwo:= 0;
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/123');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        uboracollagetwo:= uboracollagetwo + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;

                Iesanormalloan := 0;
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/111');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        Iesanormalloan := Iesanormalloan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;
                
                makarabisholoan := 0;

                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/113');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        makarabisholoan := makarabisholoan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;



                musharakaNormloan := 0;
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/115');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        musharakaNormloan := musharakaNormloan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;



                Uboraschoolfeesloan := 0;
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/119');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        Uboraschoolfeesloan := Uboraschoolfeesloan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;
                uboracollageLoan := 0;
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/120');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        uboracollageLoan := uboracollageLoan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;
                Uboraemergencyloan := 0;
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/121');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        Uboraemergencyloan := Uboraemergencyloan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;


                uboradevloan := 0;
                loansapp.Reset();
                loansapp.SetRange("Account No.", "No.");
                loansapp.SetRange("Product Type", 'UB/L/122');
                loansapp.SetRange("Date Filter", 0D, ENDDATE);
                IF loansapp.Find('-') then begin
                    repeat
                        loansapp.CalcFields("Outstanding Principal");
                        uboradevloan := uboradevloan + loansapp."Outstanding Principal";
                    until loansapp.Next = 0;
                end;



                nums := nums + 1;






            end;
        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(ENDDATE; ENDDATE)
                    {
                        ApplicationArea = ALL;
                    }

                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        acccredit: Record "Account Credit";
        accbanking: Record "Account Banking";
        loansapp: Record Loans;
        sharecapital: Decimal;
        saccodeposit: Decimal;
        holidaysaving: Decimal;
        iesasavings: Decimal;
        MUSHARAKASAVINGS: Decimal;
        UboraAmal: Decimal;
        BusinessLoan: Decimal;
        DefaulterLoan: Decimal;
        IesaEmergone: Decimal;
        IesaEmergtwo: Decimal;
        Iesanormalloan: Decimal;
        makarabisholoan: Decimal;
        musharakaNormloan: Decimal;
        Uboraschoolfeesloan: Decimal;
        uboracollageLoan: Decimal;
        Uboraemergencyloan: Decimal;
        uboradevloan: Decimal;
        uboracollagetwo:Decimal;
        
        ENDDATE: Date;
        nums: Integer;
        iesanumber: Code[100];
}
