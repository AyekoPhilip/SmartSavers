namespace DynamicsNav.SaccoDatabase.PayrollMgt;

using DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.Company;

report 50019 "Pr Payroll Summary"
{
    ApplicationArea = All;
    Caption = 'Payroll Summary List';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/PayrollSummaryReport.rdl';
    dataset
    {
        dataitem(HREmployees; "HR Employees")
        {
            column(CompInformation; CompanyInformation.Name)
            {
            }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyTelephone; CompanyTelephone)
            {
            }
            column(CommunicationOnline; CommunicationOnline)
            {
            }

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
            column(Grosspay; Grosspay)
{ }
            column(Nssf; Nssf)
            { }
            column(Nssf2; Nssf2)
            { }
            column(HseLevy;HseLevy){}
            column(Nhif; Nhif)
            { }
            column(Paye; Paye)
            { }
            column(NetPay; NetPay)
            { }
            column(TaxablePay; TaxablePay)
            { }
            column(TaxCharged; TaxCharged)
            { }
            column(DefinedContrib; DefinedContrib)
            { }
            column(TaxRelief; TaxRelief)
            { }
            column(SelectedPeriod; SelectedPeriod)
            { }
            column(LoanDeduction; Deduction[1])
            { }
            column(SharesDeduction; Deduction[2])
            { }
            column(SavingsDeduction; Deduction[3])
            { }
            column(PensionDeduction; Deduction[4])
            { }
            column(HseLevyDeduction; Deduction[5])
            { }
            column(TotalDeduct; TotalDeduct)
            { }
            column(TotAllow; TotAllow)
            { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City;
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";
                // + '- Website: ' +CompanyInformation."Home Page";

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
                Nssf := 0;
                Nssf2 := 0;
                Nhif := 0;
                HseLevy:=0;
                Paye := 0;
                BasicPay := 0;
                Grosspay := 0;
                NetPay := 0;
                TotalDeduct := 0;
                TotAllow := 0;
                TaxablePay := 0;
                TaxCharged := 0;
                TaxRelief := 0;
                DefinedContrib := 0;

                PeriodTrans.Reset();
                PeriodTrans.SetRange("Employee Code", "No.");
                PeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                if PeriodTrans.FindSet() then begin
                    repeat

                        case PeriodTrans."Account Dimension" of
                            PeriodTrans."Account Dimension"::" ":
                                begin

                                    if PeriodTrans."Group Order" = 7 then begin
                                        StatutoryDeduct := PeriodTrans.Amount
                                    end;

                                    if PeriodTrans."Transaction Code" = 'TOT-DED' then begin
                                        TotalDeduct := PeriodTrans.Amount;
                                    end;
                                    if PeriodTrans."Transaction Code" = 'HSELVR' then begin
                                        HseLevy := PeriodTrans.Amount;
                                    end;

                                    if PeriodTrans."Transaction Code" = 'DEFCON' then begin
                                        DefinedContrib := DefinedContrib + PeriodTrans.Amount;
                                    end;

                                    if PeriodTrans."Transaction Code" = 'TXBP' then begin
                                        TaxablePay := PeriodTrans.Amount;
                                    end;

                                    if PeriodTrans."Transaction Code" = 'TXCHRG' then begin
                                        TaxCharged := PeriodTrans.Amount;
                                    end;
                                    if (PeriodTrans."Group Order" = 6) and (PeriodTrans."Sub Group Order" = 9) then begin
                                        TaxRelief := TaxRelief + PeriodTrans.Amount;
                                    end;

                                    if (PeriodTrans."Group Order" = 9) and (PeriodTrans."Sub Group Order" = 0) then begin
                                        NetPay := PeriodTrans.Amount;
                                    end;

                                    if (PeriodTrans."Group Order" = 1) and (PeriodTrans."Sub Group Order" = 1) then begin
                                        BasicPay := PeriodTrans.Amount;
                                    end;

                                    if (PeriodTrans."Group Order" = 3) and (PeriodTrans."Sub Group Order" = 0) then begin
                                        TotAllow := TotAllow + PeriodTrans.Amount;
                                    end;

                                    if (PeriodTrans."Group Order" = 4) and (PeriodTrans."Sub Group Order" = 0) then begin
                                        Grosspay := PeriodTrans.Amount
                                    end;

                                    if PeriodTrans."Transaction Code" = 'NSSF' then begin
                                        Nssf := PeriodTrans.Amount
                                    end;

                                    if PeriodTrans."Transaction Code" = 'NSSF2' then begin
                                        Nssf2 := PeriodTrans.Amount
                                    end;

                                    if (PeriodTrans."Group Order" = 7) and (PeriodTrans."Sub Group Order" = 2) then begin
                                        Nhif := PeriodTrans.Amount
                                    end;

                                    if (PeriodTrans."Group Order" = 7) and (PeriodTrans."Sub Group Order" = 3) then begin
                                        Paye := PeriodTrans.Amount
                                    end;

                                end;

                            PeriodTrans."Account Dimension"::Loan:
                                Deduction[1] := Deduction[1] + PeriodTrans.Amount;
                            PeriodTrans."Account Dimension"::Credit,
                                PeriodTrans."Account Dimension"::"Micro Credit":
                                Deduction[2] := Deduction[2] + PeriodTrans.Amount;
                            PeriodTrans."Account Dimension"::Banking:
                                Deduction[3] := Deduction[3] + PeriodTrans.Amount;
                            PeriodTrans."Account Dimension"::Repayment:
                                Error('Case condition %1 not implemented.', PeriodTrans."Account Dimension"::Repayment);
                        end;

                        case PeriodTrans."Coop Parameters" of
                            PeriodTrans."Coop Parameters"::Pension:
                                begin
                                    Deduction[4] := Deduction[4] + PeriodTrans.Amount
                                end;
                            PeriodTrans."Coop Parameters"::"House Levy":
                                begin
                                    Deduction[5] := Deduction[5] + PeriodTrans.Amount
                                end;
                        end;

                    until PeriodTrans.Next() = 0;
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
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        PrTransactioncode: Record "Pr Transaction Code";
        CompanyTelephone: Text;
        HrObject: Record "Hr Employees";
        CommunicationOnline: Text;

        Loan: Record Loans;
        Description: Text[150];
        AmountPosted: Decimal;
        strEmpName: Text[100];
        BasicPay: Decimal;
        HseLevy: Decimal;
        NetPay: Decimal;
        Nssf2: Decimal;
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
        TransCodes: Record "Pr Transaction Code";
        objPeriod: Record "Pr Payroll Period";
        SelectedPeriod: Date;
        Earning: array[12] of Decimal;
        Deduction: array[15] of Decimal;
        TaxablePay: Decimal;
        TaxCharged: Decimal;
        TaxRelief: Decimal;
        DefinedContrib: Decimal;

}
