report 50059 "PrPayroll Slip -New"
{
    ApplicationArea = All;
    Caption = 'PrPayroll Slip -New';
    UsageCategory = Administration;
    RDLCLayout = './src/report_layout/PrPayrollSlipNew.rdl';
    dataset
    {
        dataitem(HrEmployees; "Hr Employees")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Current Month Filter", "Employee Type", "Global Dimension 1 Code";
            PrintOnlyIfDetail = true;
            column(NHIFNo; "NHIF No.")
            { }
            column(NSSFNo; "NSSF No.")
            { }
            column(Name; Name) { }
            column(No; "No.") { }
            column(JobID; "Job ID") { }
            column(JobTitle; JobDescription) { }
            column(DepartmentCode; "Department Code") { }
            column(SocialSecurityNo; "Social Security No.") { }
            column(HELBNo; "HELB No.") { }
            column(IDNo; "ID No.") { }
            column(PIN_No_; "PIN No.") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(Grade; Grade) { }
            column(BankAcc; BankAcc) { }
            column(BankBranch; BankBranch) { }
            column(BankCode; BankCode) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfoemail; CompanyInfo."E-Mail") { }
            column(CompanyInfoPhone; CompanyInfo."Phone No.") { }
            column(CompanyInfoHomePage; CompanyInfo."Home Page") { }
            column(PeriodName; PeriodName) { }
            column(Netpay; Netpay) { }
            column(grosspay; grosspay) { }
            column(totdeduction; totdeduction) { }

            dataitem("Pr Period Transaction"; "Pr Period Transaction")
            {
                PrintOnlyIfDetail = false;
                DataItemLink = "Employee Code" = field("No."), "Payroll Period" = field("Current Month Filter");
                DataItemTableView = sorting("Group Order");
                column(Transaction_Type; "Transaction Type") { }
                column(Statutory_category; "Statutory category") { }
                column(Transaction_Code; "Transaction Code") { }
                column(Group_Text; "Group Text") { }
                column(Group_Order; "Group Order") { }
                column(Transaction_Name; "Transaction Name") { }
                column(Hours_Units; OvertimeHrs) { }
                column(Amount; Amount) { }
                column(Payroll_Period; "Payroll Period") { }
                column(Period_Year; "Period Year") { }
                column(Period_Month; "Period Month") { }
                column(Balance; PrBalance) { }
                column(Coop_Parameters; "Coop Parameters") { }
                trigger OnAfterGetRecord()
                begin

                    SetFilter("Payroll Period", '%1', SelectedPeriod);
                    PrBalance := '';
                    OvertimeHours := 0;
                    OvertimeHrs := '';
                    if Amount <= 0 then Amount := Abs(Amount);

                    if Balance = 0 then
                        PrBalance := '.' else
                        PrBalance := Format(Balance);
                    ProratedDay := 0;

                    if "No. Of Units" = 0 then
                        OvertimeHrs := '.' else
                        OvertimeHrs := Format("No. Of Units")
                end;

            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture)
            end;

            trigger OnAfterGetRecord()
            begin

                if employeeMgt.Get("No.") then
                    // employeeMgt.CalcFields("Job Position Title");

                    BankAcc := '';
                BankBranch := '';
                BankCode := '';
                SortCode := '';
                grosspay := 0;
                Netpay := 0;
                totdeduction := 0;
                JobDescription := '';

                BankAcc := employeeMgt."Bank Account Number";
                BankBranch := employeeMgt."Employee Branch Name";
                BankCode := employeeMgt."Employee Bank Name";
                SortCode := employeeMgt."Employee Bank Sort Code";
                JobDescription := employeeMgt."Job Position Title";

                PeriodTrans.Reset();
                PeriodTrans.SetRange("Employee Code", "No.");
                PeriodTrans.SetRange("Transaction Code", 'NPAY');
                PeriodTrans.SetFilter("Payroll Period", '%1', SelectedPeriod);
                if PeriodTrans.FindFirst() then
                    Netpay := PeriodTrans.Amount;

                PeriodTrans.Reset();
                PeriodTrans.SetRange("Employee Code", "No.");
                PeriodTrans.SetRange("Transaction Code", 'TOT-DED');
                PeriodTrans.SetFilter("Payroll Period", '%1', SelectedPeriod);
                if PeriodTrans.FindFirst() then
                    totdeduction := PeriodTrans.Amount;

                PeriodTrans.Reset();
                PeriodTrans.SetRange("Employee Code", "No.");
                PeriodTrans.SetRange("Transaction Code", 'GPAY');
                PeriodTrans.SetFilter("Payroll Period", '%1', SelectedPeriod);
                if PeriodTrans.FindFirst() then
                    grosspay := PeriodTrans.Amount

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

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        PeriodFilter := HREmployees.GetFilter("Current Month Filter");
        if PeriodFilter = '' then Error('You must specify the period filter');
        SelectedPeriod := HREmployees.GetRangeMin("Current Month Filter");

        PRPayrollPeriods.Reset();
        if PRPayrollPeriods.Get(SelectedPeriod) then PeriodName := PRPayrollPeriods."Period Name";
        PeriodYear := PRPayrollPeriods."Period Year";

        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);

    end;

    trigger OnPostReport()
    begin


    end;

    var
        CompanyInfo: Record "Company Information";
        BankDetails: array[10] of Text[250];
        PrPayrollReq: Record "Payroll Requests";
        OvertimeHrs: Text;
        NoOfRecords: Integer;
        grosspay: Decimal;
        Netpay: Decimal;
        totdeduction: Decimal;
        PrsalaryCard: Record "Pr Salary Card";
        ProratedDay: Decimal;
        JobDescription: Text;
        ShowOnBothCurrency: Boolean;
        JobGrade: Text;
        OvertimeHours: Decimal;
        Dimvalue: Record "Dimension Value";
        Dimvalue1: Record "Dimension Value";
        Dim1: Text[150];
        Dim2: Text[150];
        PrBalance: Text[50];
        Premployeebank: Record "Pr Employee Bank";
        PrBankCodeStructure: Record "Bank Code Structure";
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        intInfo: Integer;
        i: Integer;
        PeriodTrans: Record "Pr Period Transaction";
        intRow: Integer;
        Index: Integer;
        HREmployeePR: Record Employee;
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
        PeriodYear: Integer;
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
        CurrencyText: Text;
        CurrencyCode: Code[10];
        ExchangeRate: Decimal;
        ExchangeRateDate: Date;
        CurrencyRec: Record Currency;
        Gratuittities: Decimal;
        PREmployerContr: Record "Pr Employer Deduction";
        PayslipMessage: Text[50];
        RatePerDay: Decimal;
        NoDaysWorked: Decimal;
        PRPerTrans: Record "Pr Period Transaction";
        CountyName: Text;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        DimensionValue: Record "Dimension Value";
        EmptyStringCaption: Label '.......................';
        EmployeeCaption: Label 'Employee:';
        DepartmentCaption: Label 'Department:';
        PeriodCaption: Label 'Period:';
        Spacer: Label '-';
        employeeMgt: Record Employee;
        BankAcc: Text[250];
        BankCode: Text[250];
        SortCode: Text[150];
        BankBranch: Text[250];
        TitleDescrip: Text;
}
