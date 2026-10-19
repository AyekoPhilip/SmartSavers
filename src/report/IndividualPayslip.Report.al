report 50058 "Individual Payslip"
{
    ApplicationArea = All;
    Caption = 'Individual Payslip';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/IndividualPayslip.rdl';
    dataset
    {
        dataitem(HREmployee; "HR Employees")
        {
            PrintOnlyIfDetail = true;
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {
            }
            column(NSSFNo; "NSSF No.")
            {
            }
            column(NHIFNo; "NHIF No.")
            {
            }
            column(PINNo; "PIN No.")
            {
            }
            column(HELBNo; "HELB No.")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(Job_Title; "Job Title")
            { }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            { }
            column(CompanyInfoName; CompanyInfo.Name)
            { }
            dataitem("Pr Salary Card"; "Pr Salary Card")
            {
                PrintOnlyIfDetail = false;
                DataItemLink = "Employee Code" = field("No.");
                column(Employee_Code; "Employee Code")
                { }
                Column(NoDaysWorked; NoDaysWorked) { }
                Column(RatePerDay; RatePerDay) { }
                Column(Trans_1__1_; Trans[1] [1]) { }
                Column(TransAmt_1__1_; TransAmt[1] [1]) { }
                Column(TransBal_1__1_; TransBal[1] [1]) { }
                Column(TransBal_1__2_; TransBal[1] [2]) { }
                Column(TransAmt_1__2_; TransAmt[1] [2]) { }
                Column(Trans_1__2_; Trans[1] [2]) { }
                Column(TransBal_1__3_; TransBal[1] [3]) { }
                Column(TransAmt_1__3_; TransAmt[1] [3]) { }
                Column(Trans_1__3_; Trans[1] [3]) { }
                Column(TransBal_1__4_; TransBal[1] [4]) { }
                Column(TransBal_1__5_; TransBal[1] [5]) { }
                Column(TransBal_1__6_; TransBal[1] [6]) { }
                Column(TransAmt_1__4_; TransAmt[1] [4]) { }
                Column(TransAmt_1__5_; TransAmt[1] [5]) { }
                Column(TransAmt_1__6_; TransAmt[1] [6]) { }
                Column(Trans_1__4_; Trans[1] [4]) { }
                Column(Trans_1__5_; Trans[1] [5]) { }
                Column(Trans_1__6_; Trans[1] [6]) { }
                Column(TransBal_1__7_; TransBal[1] [7]) { }
                Column(TransBal_1__8_; TransBal[1] [8]) { }
                Column(TransBal_1__9_; TransBal[1] [9]) { }
                Column(TransAmt_1__7_; TransAmt[1] [7]) { }
                Column(TransAmt_1__8_; TransAmt[1] [8]) { }
                Column(TransAmt_1__9_; TransAmt[1] [9]) { }
                Column(Trans_1__7_; Trans[1] [7]) { }
                Column(Trans_1__8_; Trans[1] [8]) { }
                Column(Trans_1__9_; Trans[1] [9]) { }
                Column(TransBal_1__10_; TransBal[1] [10]) { }
                Column(TransBal_1__12_; TransBal[1] [12]) { }
                Column(TransBal_1__13_; TransBal[1] [13]) { }
                Column(TransAmt_1__10_; TransAmt[1] [10]) { }
                Column(TransAmt_1__12_; TransAmt[1] [12]) { }
                Column(TransAmt_1__13_; TransAmt[1] [13]) { }
                Column(Trans_1__10_; Trans[1] [10]) { }
                Column(Trans_1__12_; Trans[1] [12]) { }
                Column(Trans_1__13_; Trans[1] [13]) { }
                Column(TransBal_1__14_; TransBal[1] [14]) { }
                Column(TransBal_1__15_; TransBal[1] [15]) { }
                Column(TransBal_1__16_; TransBal[1] [16]) { }
                Column(TransBal_1__17_; TransBal[1] [17]) { }
                Column(TransBal_1__18_; TransBal[1] [18]) { }
                Column(TransBal_1__19_; TransBal[1] [19]) { }
                Column(TransBal_1__11_; TransBal[1] [11]) { }
                Column(TransBal_1__20_; TransBal[1] [20]) { }
                Column(TransAmt_1__14_; TransAmt[1] [14]) { }
                Column(TransAmt_1__15_; TransAmt[1] [15]) { }
                Column(TransAmt_1__16_; TransAmt[1] [16]) { }
                Column(TransAmt_1__17_; TransAmt[1] [17]) { }
                Column(TransAmt_1__18_; TransAmt[1] [18]) { }
                Column(TransAmt_1__19_; TransAmt[1] [19]) { }
                Column(TransAmt_1__11_; TransAmt[1] [11]) { }
                Column(TransAmt_1__20_; TransAmt[1] [20]) { }
                Column(Trans_1__14_; Trans[1] [14]) { }
                Column(Trans_1__15_; Trans[1] [15]) { }
                Column(Trans_1__16_; Trans[1] [16]) { }
                Column(Trans_1__17_; Trans[1] [17]) { }
                Column(Trans_1__18_; Trans[1] [18]) { }
                Column(Trans_1__19_; Trans[1] [19]) { }
                Column(Trans_1__11_; Trans[1] [11]) { }
                Column(Trans_1__20_; Trans[1] [20]) { }
                Column(Addr_1__1_; Addr[1] [1]) { }
                Column(Addr_1__2_; Addr[1] [2]) { }
                Column(Addr_1__3_; Addr[1] [3]) { }
                Column(TransBal_1__21_; TransBal[1] [21]) { }
                Column(TransBal_1__22_; TransBal[1] [22]) { }
                Column(TransAmt_1__21_; TransAmt[1] [21]) { }
                Column(TransAmt_1__22_; TransAmt[1] [22]) { }
                Column(TransBal_1__23_; TransBal[1] [23]) { }
                Column(TransAmt_1__23_; TransAmt[1] [23]) { }
                Column(TransBal_1__24_; TransBal[1] [24]) { }
                Column(TransAmt_1__24_; TransAmt[1] [24]) { }
                Column(Trans_1__21_; Trans[1] [21]) { }
                Column(Trans_1__23_; Trans[1] [23]) { }
                Column(Trans_1__24_; Trans[1] [24]) { }
                Column(Trans_1__22_; Trans[1] [22]) { }
                Column(TransBal_1__25_; TransBal[1] [25]) { }
                Column(TransAmt_1__25_; TransAmt[1] [25]) { }
                Column(Trans_1__25_; Trans[1] [25]) { }
                Column(TransBal_1__26_; TransBal[1] [26]) { }
                Column(TransAmt_1__26_; TransAmt[1] [26]) { }
                Column(Trans_1__26_; Trans[1] [26]) { }
                Column(TransBal_1__27_; TransBal[1] [27]) { }
                Column(TransAmt_1__27_; TransAmt[1] [27]) { }
                Column(Trans_1__27_; Trans[1] [27]) { }
                Column(TransBal_1__28_; TransBal[1] [28]) { }
                Column(TransAmt_1__28_; TransAmt[1] [28]) { }
                Column(Trans_1__28_; Trans[1] [28]) { }
                Column(TransBal_1__29_; TransBal[1] [29]) { }
                Column(TransAmt_1__29_; TransAmt[1] [29]) { }
                Column(Trans_1__29_; Trans[1] [29]) { }
                Column(TransBal_1__30_; TransBal[1] [30]) { }
                Column(TransAmt_1__30_; TransAmt[1] [30]) { }
                Column(Trans_1__30_; Trans[1] [30]) { }
                Column(TransBal_1__31_; TransBal[1] [31]) { }
                Column(TransAmt_1__31_; TransAmt[1] [31]) { }
                Column(Trans_1__31_; Trans[1] [31]) { }
                Column(TransBal_1__32_; TransBal[1] [32]) { }
                Column(TransBal_1__33_; TransBal[1] [33]) { }
                Column(TransBal_1__34_; TransBal[1] [34]) { }
                Column(TransBal_1__35_; TransBal[1] [35]) { }
                Column(TransBal_1__36_; TransBal[1] [36]) { }
                Column(TransBal_1__37_; TransBal[1] [37]) { }
                Column(TransBal_1__38_; TransBal[1] [38]) { }
                Column(TransBal_1__39_; TransBal[1] [39]) { }
                Column(TransBal_1__40_; TransBal[1] [40]) { }
                Column(TransAmt_1__32_; TransAmt[1] [32]) { }
                Column(TransAmt_1__33_; TransAmt[1] [33]) { }
                Column(TransAmt_1__34_; TransAmt[1] [34]) { }
                Column(TransAmt_1__35_; TransAmt[1] [35]) { }
                Column(TransAmt_1__36_; TransAmt[1] [36]) { }
                Column(TransAmt_1__37_; TransAmt[1] [37]) { }
                Column(TransAmt_1__38_; TransAmt[1] [38]) { }
                Column(TransAmt_1__39_; TransAmt[1] [39]) { }
                Column(TransAmt_1__40_; TransAmt[1] [40]) { }
                Column(Trans_1__32_; Trans[1] [32]) { }
                Column(Trans_1__34_; Trans[1] [34]) { }
                Column(Trans_1__35_; Trans[1] [35]) { }
                Column(Trans_1__33_; Trans[1] [33]) { }
                Column(Trans_1__36_; Trans[1] [36]) { }
                Column(Trans_1__37_; Trans[1] [37]) { }
                Column(Trans_1__38_; Trans[1] [38]) { }
                Column(Trans_1__39_; Trans[1] [39]) { }
                Column(Trans_1__40_; Trans[1] [40]) { }
                Column(Trans_1__45_; Trans[1] [45]) { }
                Column(TransAmt_1__45_; TransAmt[1] [45]) { }
                Column(TransAmt_1__46_; TransAmt[1] [46]) { }
                Column(TransAmt_1__47_; TransAmt[1] [47]) { }
                Column(TransAmt_1__48_; TransAmt[1] [48]) { }
                Column(TransAmt_1__49_; TransAmt[1] [49]) { }
                Column(Trans_1__46_; Trans[1] [46]) { }
                Column(Trans_1__47_; Trans[1] [47]) { }
                Column(Trans_1__48_; Trans[1] [48]) { }
                Column(Trans_1__49_; Trans[1] [49]) { }
                Column(TransAmt_1__50_; TransAmt[1] [50]) { }
                Column(TransAmt_1__51_; TransAmt[1] [51]) { }
                Column(Trans_1__50_; Trans[1] [50]) { }
                Column(Trans_1__51_; Trans[1] [51]) { }
                Column(Trans_1__53_; Trans[1] [53]) { }
                Column(TransBal_1__42_; TransBal[1] [42]) { }
                Column(TransAmt_1__42_; TransAmt[1] [42]) { }
                Column(Trans_1__42_; Trans[1] [42]) { }
                Column(TransBal_1__43_; TransBal[1] [43]) { }
                Column(TransAmt_1__43_; TransAmt[1] [43]) { }
                Column(Trans_1__43_; Trans[1] [43]) { }
                Column(TransBal_1__44_; TransBal[1] [44]) { }
                Column(TransAmt_1__44_; TransAmt[1] [44]) { }
                Column(Trans_1__44_; Trans[1] [44]) { }
                Column(Trans_1__41_; Trans[1] [41]) { }
                Column(TransAmt_1__41_; TransAmt[1] [41]) { }
                Column(TransBal_1__41_; TransBal[1] [41]) { }
                Column(TransAmt_1__52_; TransAmt[1] [52]) { }
                Column(Trans_1__52_; Trans[1] [52]) { }
                Column(TransBal_1__45_; TransBal[1] [45]) { }
                Column(TransBal_1__46_; TransBal[1] [46]) { }
                Column(TransBal_1__47_; TransBal[1] [47]) { }
                Column(TransBal_1__48_; TransBal[1] [48]) { }
                Column(TransBal_1__49_; TransBal[1] [49]) { }

                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    strNssfNo := '. ';
                    strNhifNo := '. ';
                    strBank := '. ';
                    strBranch := '. ';
                    strAccountNo := '. ';
                    strPin := '. ';
                    StrGratuity := 0;
                    RecordNo := RecordNo + 1;
                    ColumnNo := ColumnNo + 1;

                    HREmployeePR.Reset();
                    HREmployeePR.SetRange("No.", "Employee Code");
                    if HREmployeePR.FindFirst() then begin

                        strPin := HREmployeePR."PIN No.";
                        dtDOE := HREmployeePR."Date Of Join";
                        EmpStatus := HREmployeePR.Status;
                        dept := HREmployeePR."Department Code";
                        dtOfLeaving := HREmployeePR."Date Of Leaving";
                        strNssfNo := HREmployeePR."NSSF No.";
                        strNhifNo := HREmployeePR."NHIF No.";
                        strPin := HREmployeePR."PIN No.";
                    end;

                    Addr[ColumnNo] [1] := '';
                    Addr[ColumnNo] [2] := '';
                    Addr[ColumnNo] [3] := '';
                    Addr[ColumnNo] [4] := '';
                    Addr[ColumnNo] [5] := '';

                    PeriodTrans.Reset();
                    PeriodTrans.SetRange("Employee Code", "Employee Code");
                    PeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                    PeriodTrans.SetRange("Company Deduction", false);
                    PeriodTrans.SetCurrentKey(PeriodTrans."Employee Code", PeriodTrans."Period Month",
                    PeriodTrans."Period Year", PeriodTrans."Group Order", PeriodTrans."Sub Group Order");

                    Addr[ColumnNo] [1] := Format(strEmpName);
                    Addr[ColumnNo] [2] := dept;
                    Addr[ColumnNo] [3] := PeriodName;
                    Addr[ColumnNo] [4] := strPin;
                    Addr[ColumnNo] [5] := '--------------------------';
                    if PeriodTrans.Find('-') then begin
                        repeat
                            if strGrpText <> PeriodTrans."Group Text" then begin

                                if PeriodTrans."Group Order" <> 1 then begin
                                    Index := Index + 1;
                                end;

                                Index := Index + 1;
                                strGrpText := PeriodTrans."Group Text";
                                Trans[ColumnNo, Index] := strGrpText;
                                TransAmt[ColumnNo, Index] := '.';
                                TransBal[ColumnNo, Index] := '.';

                                Index := Index + 1;
                                Trans[ColumnNo, Index] := PeriodTrans."Transaction Name";
                                Evaluate(TransAmt[ColumnNo, Index], Format(PeriodTrans.Amount));

                                if PeriodTrans.Balance = 0 then
                                    Evaluate(TransBal[ColumnNo, Index], Format('                           '))
                                else
                                    Evaluate(TransBal[ColumnNo, Index], Format(PeriodTrans.Balance));
                            end else begin
                                Index := Index + 1;
                                strGrpText := PeriodTrans."Group Text";
                                Trans[ColumnNo, Index] := PeriodTrans."Transaction Name";

                                Evaluate(TransAmt[ColumnNo, Index], Format(PeriodTrans.Amount));
                                if PeriodTrans.Balance = 0 then
                                    Evaluate(TransBal[ColumnNo, Index], Format('                           '))
                                else
                                    //  Evaluate(TransBal[ColumnNo, Index], Format(PeriodTrans.Balance + PeriodTrans."Emp Amount"));
                                    Evaluate(TransBal[ColumnNo, Index], Format(PeriodTrans.Balance));
                            end;
                        until PeriodTrans.Next() = 0;
                    end;
                    Index += 1;
                    Trans[ColumnNo, Index] := '......................................';
                    Evaluate(TransAmt[ColumnNo, Index], '......................................');

                    Index += 1;
                    Trans[ColumnNo, Index] := 'EMPLOYER CONTRIBUTIONS:';
                    Evaluate(TransAmt[ColumnNo, Index], '.');

                    PREmployerContr.Reset();
                    PREmployerContr.SetRange("Payroll Period", SelectedPeriod);
                    PREmployerContr.SetRange("Employee Code", strEmpCode);
                    if PREmployerContr.Find('-') then begin
                        repeat
                            if PREmployerContr."Transaction Code" = 'NSSF' then begin
                                Index += 1;
                                Trans[ColumnNo, Index] := 'N.S.S.F: ';
                                EVALUATE(TransAmt[ColumnNo, Index], FORMAT(PREmployerContr.Amount));
                            end;
                            if PREmployerContr."Transaction Code" = 'D003' then begin
                                Index += 1;
                                Trans[ColumnNo, Index] := 'Pension (Employer): ';
                                EVALUATE(TransAmt[ColumnNo, Index], FORMAT(PREmployerContr.Amount));
                            end;
                        until PREmployerContr.Next() = 0;
                    end;

                    if (RecordNo = NoOfRecords) and (ColumnNo < 3) then begin
                        for i := ColumnNo + 1 to NoOfColumns do begin
                            CLEAR(Addr[i]);
                            CLEAR(Trans[i]);
                            CLEAR(TransAmt[i]);
                            CLEAR(TransBal[i]);
                        end;
                        ColumnNo := 0;

                    end else begin
                        if ColumnNo = NoOfColumns then
                            ColumnNo := 0;
                    end;

                end;

                trigger OnPostDataItem()
                begin

                end;

            }

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;
                NoOfColumns := 2;
                strNssfNo := '.';
                strNhifNo := '.';
                strBank := '.';
                strBranch := '.';
                strAccountNo := '.';
            end;

            trigger OnAfterGetRecord()
            begin

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
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    labels
    {

    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        PeriodFilter := "Pr Salary Card".GetFilter("Period Filter");
        if PeriodFilter = '' then Error('You must specify the period filter');
        SelectedPeriod := "PR Salary Card".GetRangeMin("Period Filter");
        PRPayrollPeriods.Reset();
        if PRPayrollPeriods.Get(SelectedPeriod) then PeriodName := PRPayrollPeriods."Period Name";

        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);

    end;

    trigger OnPostReport()
    begin


    end;



    var
        CompanyInfo: Record "Company Information";
        Addr: array[2, 10] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        intInfo: Integer;
        i: Integer;
        PeriodTrans: Record "Pr Period Transaction";
        intRow: Integer;
        Index: Integer;
        HREmployeePR: Record "HR Employees";
        strEmpName: Text[250];
        strPin: Text[30];
        Trans: array[2, 60] of Text[50];
        TransAmt: array[2, 60] of Text[50];
        TransBal: array[2, 60] of Text[50];
        strGrpText: Text[100];
        strNssfNo: Text[30];
        strNhifNo: Text[30];
        strBank: Text[100];
        strBranch: Text[100];
        strAccountNo: Text[100];
        strMessage: Text[100];
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        SelectedPeriod: Date;
        PRPayrollPeriods: Record "Pr Payroll Period";
        dtDOE: Date;
        strEmpCode: Text[30];
        EmpStatus: Enum "Employee Status";
        dtOfLeaving: Date;
        ServedNoticePeriod: Boolean;
        dept: Text[30];
        PRBankStructure: Record "Bank Code Structure";
        emploadva: Record "Pr Employee Transaction";
        strBankno: Text[30];
        strBranchno: Text[30];
        PRPayrollProcessing: Codeunit "Payroll Post Mngt.";
        STRGRATUITY: Decimal;
        Gratuitty: Decimal;
        Gratuittities: Decimal;
        //PRSalaryCard: Record prJournal Details
        PREmployerContr: Record "Pr Employer Deduction";
        PayslipMessage: Text[50];
        RatePerDay: Decimal;
        NoDaysWorked: Decimal;
        PRPerTrans: Record "Pr Period Transaction";
        CountyName: Text;
        DimensionValue: Record "Dimension Value";
        EmptyStringCaption: Label '.......................';
        EmployeeCaption: Label 'Employee:';
        DepartmentCaption: Label 'Department:';
        PeriodCaption: Label 'Period:';
        Spacer: Label '-';


}
