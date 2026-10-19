report 50259 "Member Loans Register"
{
    ApplicationArea = All;
    Caption = 'Loans Register-Performance';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/RegisteredLoan.rdl';
    dataset
    {
        dataitem(Loans;Loans)
        {
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Date Filter";
            column(No; "No.")
            { }
            column(AccountNo; "Account No.")
            { }

            column(Outstanding_Principal; "Outstanding Principal")
            { }
            column(Outstanding_Interest; "Outstanding Interest")
            { }
            column(Repayment_Start_Date; "Repayment Start Date")
            { }
            column(Amount_In_Arrears; "Amount In Arrears")
            { }

            column(AccountName; "Account Name")
            { }
            column(EmployerCode; "Employer Code")
            { }
            column(ProductType; "Product Type")
            { }
            column(ProductDescription; "Product Description")
            { }
            column(InterestCalculationMethod; "Interest Calculation Method")
            { }
            column(Installments; Installments)
            { }
            column(Repayment; Repayment)
            { }
            column(Employer_Code; "Employer Code")
            { }
            column(InterestRate; "Interest Rate")
            { }
            column(RepaymentFrequency; "Repayment Frequency")
            { }
            column(DisbursementDate; "Disbursement Date")
            { }
            column(RequestedAmount; "Requested Amount")
            { }
            column(ApprovedAmount; "Approved Amount")
            { }
            column(OutstandingBalance; "Outstanding Balance")
            { }
            column(ExpectedDateofCompletion; "Expected Date of Completion")
            { }
            column(Sectors; Sectors)
            { }
            column(Sub_Sectors; "Sub Sectors")
            { }
            column(Purpose_of_Loan; "Purpose of Loan")
            { }
            column(LastPayDate; "Last Pay Date")
            { }
            column(SharesDeposit; Amt[1])
            { }
            column(SharesDepositFilter; Amt[2])
            { }
            column(GuarantorDeposits; Amt[4])
            { }
            column(CollateralName; CollateralName)
            { }
            column(CollateralValue; Amt[5])
            { }
            column(FirstApprover; Approvers[1])
            { }
            column(SecondApprover; Approvers[2])
            { }
            column(Appraiser; Approvers[3])
            { }

            trigger OnPreDataItem()
            begin

                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
            end;

            trigger OnAfterGetRecord()
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

                    field(EndDate; EndDate)
                    {
                        Caption = 'As At';
                        ApplicationArea = All;

                    }
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
    trigger OnPreReport()
    begin

    end;

    var
        Company: Record "Company Information";
        LoanAppcharges: Record "Loan Product Charges";
        TopUpComms: Decimal;
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        ReportExcMngt: Codeunit "Report Execute Mngt.";
        CompanyInformation: Record "Company Information";
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        ExciseDuty: Decimal;
        GeneralSetUp: Record "General Set-Up";
        Loan: Record Loans;
        MinuteNo: Code[50];
        Amt: array[7] of Decimal;
        Accredit: Record "Account Credit";
        CollateralReg: Record "Collateral Register";
        GuarantorDet: Record "Guarantor & Security Posted";
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text;
        CollateralName: Text[150];
        CollRegmgt: Record "Collateral Register";
        Approvers: array[4] of Text[150];
        AppTemplates: Record "Approval Template";
        AddApprovers: Record "Additional Approver";
        PostedAppEntries: Record "Posted Approval Entries";
        ProcLoans: Record "Loans Categorization";

    procedure getMemberAccountBal()
    begin
        DateFilter := Format(StartDate) + '..' + Format(EndDate);

        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;
        Amt[4] := 0;
        Amt[5] := 0;

        Accredit.Reset();
        Accredit.SetRange("Member No.",Loans."Account No.");
        Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
        if Accredit.FindFirst() then begin
            Accredit.CalcFields("Balance (LCY)");
            Amt[1] := Accredit."Balance (LCY)";
        end;

        Accredit.Reset();
        Accredit.SetRange("Member No.",Loans."Account No.");
        Accredit.SetFilter("Date Filter", DateFilter);
        Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
        if Accredit.FindFirst() then begin
            Accredit.CalcFields("Balance (LCY)");
            Amt[2] := Accredit."Balance (LCY)";
        end;

        Loan.Reset();
        Loan.SetRange("Account No.",Loans."Account No.");
        Loan.SetFilter("Date Filter", DateFilter);
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                Amt[3] := Amt[3] + Loan."Outstanding Balance";
            until Loan.Next() = 0;
        end;

        GuarantorDet.Reset();
        GuarantorDet.SetRange("Loan No.",Loans."No.");
        if GuarantorDet.FindSet() then begin
            Accredit.Reset();
            Accredit.SetRange("No.", GuarantorDet."Account No.");
            Accredit.SetFilter("Date Filter", DateFilter);
            Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
            if Accredit.FindFirst() then begin
                Accredit.CalcFields("Balance (LCY)");
                Amt[4] := Amt[4] + Accredit."Balance (LCY)";
            end;
        end;

        GuarantorDet.Reset();
        GuarantorDet.SetRange("Loan No.",Loans."No.");
        GuarantorDet.SetRange("Security Type", GuarantorDet."Security Type"::Collateral);
        if GuarantorDet.FindSet() then begin
            Amt[5] := GuarantorDet."Collateral Value";

            CollateralReg.Reset();
            CollateralReg.SetRange("No.", GuarantorDet."Collateral Reg. No.");
            if CollateralReg.FindFirst() then
                CollateralName := CollateralReg."Collateral Name";
        end;
    end;



}



