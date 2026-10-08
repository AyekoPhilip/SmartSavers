report 90003 "Payroll P9"
{
    ApplicationArea = All;
    Caption = 'Payroll P9';
    UsageCategory = Administration;
    RDLCLayout = './src/report_layout/PayrollP9.rdl';
    dataset
    {
        dataitem(HrEmployees; "Hr Employees")
        {
            DataItemTableView = where(Status = filter(Active));
            RequestFilterFields = "No.", "Employee Type", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(PINNo; "PIN No.")
            {
            }
            column(NHIF_No_; "HELB No.")
            { }
            column(ID_No_; "ID No.")
            { }

            column(TaxablePay; IncAllowance[2])
            { }
            column(CompInformation; CompanyInformation.Name)
            {
            }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyInfoAddress; CompanyInformation.Address)
            {
            }
            column(CompanyInfoPhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(CompanyInforEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyInfoPicture; CompanyInformation.Picture)
            { }
            column(CompanyInformation; CompanyInformation."VAT Registration No.") { }
            column(NoOfActiveEmployee; NoOfActiveEmployee)
            { }
            dataitem("Pr Employee P9 Info"; "Pr Employee P9 Info")
            {
                DataItemLink = "Employee Code" = field("No.");
                DataItemTableView = sorting("Employee Code", "Payroll Period") order(Ascending);
                PrintOnlyIfDetail = false;
                column(Employee_Code; "Employee Code") { }
                column(Payroll_Period; "Payroll Period") { }
                column(Period_Month; PeriodMonth) { }
                column(Period_Year; "Period Year") { }
                column(Basic_Pay; "Basic Pay") { }
                column(Benefits; Benefits) { }
                column(InsuranceRelief; InsuranceRelief) { }
                column(Value_Of_Quarters; "Value Of Quarters") { }
                column(Gross_Pay; "Gross Pay") { }
                column(Owner_Occupier_Interest; "Owner Occupier Interest") { }
                column(Tax_Charged; "Tax Charged") { }
                column(Tax_Relief; "Tax Relief") { }
                column(Taxable_Pay; "Taxable Pay") { }
                column(NSSF; NSSF) { }
                column(Insurance_Relief; "Insurance Relief") { }
                column(PAYE; PAYE) { }
                column(Pension; Pension) { }
                column(NHIF; NHIF) { }
                column(House_Levy; "House Levy") { }
                column(Deductions; Deductions) { }
                trigger OnAfterGetRecord()
                begin
                    SetFilter("Period Year", '%1', SelectedYearText);
                    PeriodMonth := '';
                    PeriodMonth := Format("Payroll Period", 0, '<Month Text>');
                end;

            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);

            end;

            trigger OnAfterGetRecord()
            begin


                InsuranceRelief := 0;
                PensionContr := 0;
                // TotTaxableAllow := 0;
                BasicPay := 0;
                BpayLessPension := 0;
                NSSFContribution := 0;
                TotPensionContr := 0;
                VolNSSFContribution := 0;

                PeriodTrans.SetCurrentKey(PeriodTrans."Employee Code", PeriodTrans."Period Month",
                PeriodTrans."Period Year", PeriodTrans."Group Order", PeriodTrans."Sub Group Order");

                PeriodTrans.Reset();
                PeriodTrans.SetRange("Employee Code", "No.");
                PeriodTrans.SetRange("Payroll Period", PayrollPeriod);
                if PeriodTrans.FindSet() then begin
                    repeat
                        case PeriodTrans."Transaction Code" of
                            'D0060':
                                IncAllowance[1] := PeriodTrans.Amount;
                            'TXBP':
                                IncAllowance[2] := PeriodTrans.Amount;
                        end;
                    until PeriodTrans.Next() = 0;
                end;
                NoOfActiveEmployee := i;

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Period)
                {
                    field(SelectedYearText; SelectedYearText)
                    {
                        Caption = 'Payroll Year';
                        ApplicationArea = All;
                        //TableRelation = "Pr Payroll Period"."Period Year";
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
    trigger OnPreReport()
    begin



    end;

    var
        CustRec: Record Customer;
        i: Integer;
        PayrollPostEventMgt: Codeunit "Payroll Post Event Mgt";
        NoOfActiveEmployee: Integer;
        CompanyInformation: Record "Company Information";
        BasicPay: Decimal;
        InsuranceRelief: Decimal;
        PensionContr: Decimal;
        PeriodMonth: Text;
        BPayLessPension: Decimal;
        NSSFContribution: Decimal;
        TotPensionContr: Decimal;
        VolNSSFContribution: Decimal;
        SelectedYearText: Integer;
        PayrollPeriod: Date;
        PeriodTrans: Record "Pr Period Transaction";
        Dimvalue: Record "Dimension Value";
        Dimvalue1: Record "Dimension Value";
        Dim1: Text[150];
        Dim2: Text[150];
        AccName: Text[150];

        prsalaryInfo: Record "Pr Salary Card";
        prsalaryCard: Record "Pr Salary Card";
        prEmployeeTrans: Record "Pr Employee Transaction";
        prEmployeeTransact: Record "Pr Employee Transaction";
        objtEmp: Record "Hr Employees";
        emplPostgroup: Record "Pr Employee Posting Group";
        prTranscode: Record "Pr Transaction Code";
        //HrPayrollRequest: Record "Pr Payroll Request";
        IncAllowance: array[21] of Decimal;
        Taxcalculation: array[21] of Decimal;
        InsuranceDeduction: array[21] of Decimal;
        OtherDeduction: array[21] of Decimal;
        AdvanceDeduction: array[21] of Decimal;
        StatutoryDeduction: array[21] of Decimal;

}
