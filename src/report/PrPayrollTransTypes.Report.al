namespace DynamicsNav.SaccoDatabase.PayrollMgt;

using DynamicsNav.SaccoDatabase.HrManagementMgt;

report 50010 "Pr Payroll Trans. Types"
{
    ApplicationArea = All;
    Caption = 'Pr Payroll Trans. Types';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/PayrollTransTypes.rdl';
    dataset
    {
        dataitem(HREmployees; "HR Employees")
        {
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(NHIFNo; "NHIF No.")
            {
            }
            column(NSSFNo; "NSSF No.")
            {
            }
            column(PINNo; "PIN No.")
            {
            }
            column(BasicPay; BasicPay)
            { }
            column(ID_No_; "ID No.")
            {

            }
            column(Grosspay; Grosspay)
            { }
            column(Nssf; Nssf)
            { }
            column(Nhif; Nhif)
            { }
            column(Paye; Paye)
            { }
            column(NetPay; NetPay)
            { }
            column(Deduction; Deduction[1])
            { }
            column(EmployerDeduction; Deduction[2])
            { }
            column(PayrollTransCode; PayrollTransCode)
            { }
            column(TransacTxt; TransacTxt)
            { }
            column(SelectedPeriod; SelectedPeriod)
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

                Deduction[1] := 0;
                Deduction[2] := 0;
                Deduction[3] := 0;
                Deduction[4] := 0;
                Deduction[5] := 0;
                Deduction[6] := 0;
                Deduction[7] := 0;
                StatutoryDeduct := 0;
                TransacTxt := '';
                Nssf := 0;
                Nhif := 0;
                Paye := 0;
                BasicPay := 0;
                Grosspay := 0;
                NetPay := 0;
                TotalDeduct := 0;
                TotAllow := 0;

                PeriodTrans.Reset();
                PeriodTrans.SetRange("Employee Code", "No.");
                PeriodTrans.SetRange("Transaction Code", PayrollTransCode);
                PeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                if PeriodTrans.FindSet() then begin

                    Deduction[1] := PeriodTrans.Amount;
                    TransacTxt := PeriodTrans."Transaction Name";

                    if TransCodes.Get(PeriodTrans."Transaction Code") then begin
                        if TransCodes."Inc. Employer Deduction" then begin

                            PrEmployerDeduct.Reset();
                            PrEmployerDeduct.SetRange("Payroll Period", PeriodTrans."Payroll Period");
                            PrEmployerDeduct.SetRange("Employee Code", PeriodTrans."Employee Code");
                            PrEmployerDeduct.SetRange("Transaction Code", PeriodTrans."Transaction Code");
                            if PrEmployerDeduct.FindFirst() then begin
                                Deduction[2] := PrEmployerDeduct.Amount
                            end;
                        end;
                    end;
                end;
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
            area(Content)
            {
                group(Options)
                {
                    field(SelectedPeriod; SelectedPeriod)
                    {
                        Caption = 'Payroll Period';
                        ApplicationArea = All;
                        TableRelation = "Pr Payroll Period";
                    }
                    field(PayrollTransCode; PayrollTransCode)
                    {
                        Caption = 'Transaction Code';
                        ApplicationArea = All;
                        TableRelation = "Pr Transaction Code".Code;
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
        strEmpName: Text[100];
        BasicPay: Decimal;
        NetPay: Decimal;
        Paye: Decimal;
        Allow: Decimal;
        Grosspay: Decimal;
        PenGrat: Decimal;
        StatutoryDeduct: Decimal;
        TotalDeduct: Decimal;
        Nssf: Decimal;
        Nhif: Decimal;
        subTotNssf: Decimal;
        TotBasicPay: Decimal;
        TotAllow: Decimal;
        TotGrosspay: Decimal;
        TotPenGrat: Decimal;
        TotNssf: Decimal;
        PeriodTrans: Record "Pr Period Transaction";
        PrEmployerDeduct: Record "Pr Employer Deduction";
        TransCodes: Record "Pr Transaction Code";
        objPeriod: Record "Pr Payroll Period";
        SelectedPeriod: Date;
        Earning: array[12] of Decimal;
        Deduction: array[15] of Decimal;
        PayrollTransCode: Code[20];
        TransacTxt: Text[150];
        StatutoryDeduction: Boolean;

}
