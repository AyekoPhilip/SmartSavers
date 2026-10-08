namespace SaccoDatabase.SaccoDatabase;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;

report 90019 "Loan Sasra "
{
    ApplicationArea = All;
    Caption = 'Loan Sasra Category';
    UsageCategory = ReportsAndAnalysis;
    //ExcelLayout = './src/report_layout/Loansasra.xlsx';
    RDLCLayout = './src/report_layout/Loansasra.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Employer Code", "Date Filter";
            DataItemTableView = where("Outstanding Balance" = filter(<> 0));
            column(AccountDimension; "Account Dimension")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccruedInterest; "Accrued Interest")
            {
            }
            column(AmountDeducted; "Amount Deducted")
            {
            }
            column(AmountGuaranteed; "Amount Guaranteed")
            {
            }
            column(AmounttoDisburse; "Amount to Disburse")
            {
            }
            column(AmounttoPost; "Amount to Post")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(ApplicationSource; "Application Source")
            {
            }
            column(ApplicationType; "Application Type")
            {
            }
            column(AppraisalParameterType; "Appraisal Parameter Type")
            {
            }
            column(ApprovalDate; "Approval Date")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(BatchNo; "Batch No.")
            {
            }
            column(BillingType; "Billing Type")
            {
            }
            column(CRMApplicationNo; "CRM Application No.")
            {
            }
            column(CRMCapturedBy; "CRM Captured By")
            {
            }
            column(CRMCreated; "CRM Created")
            {
            }
            column(CRMDate; "CRM Date")
            {
            }
            column(CapturedBy; "Captured By")
            {
            }
            column(ChargeInterestonPosting; "Charge Interest on Posting")
            {
            }
            column(ChargesCommissions; "Charges & Commissions")
            {
            }
            column(CheckLine; "Check Line")
            {
            }
            column(ChequeNo; "Cheque No")
            {
            }
            column(ChequesType; "Cheques Type")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(DateRescheduled; "Date Rescheduled")
            {
            }
            column(Amount_in_Arrears; "Amount in Arrears")
            {
            }
            column(DepositPurchase; "Deposit Purchase")
            {
            }
            column(DepositPurchaseAccount; "Deposit Purchase Account")
            {
            }
            column(DepositsAppraisalParameter; "Deposits Appraisal Parameter")
            {
            }
            column(DisbursementAccountNo; "Disbursement Account No.")
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            column(DisbursementDestination; "Disbursement Destination")
            {
            }
            column(EFTOptions; "EFT Options")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(ExcludeFromRelatedBalance; "Exclude From Related Balance")
            {
            }
            column(ExpectedDateofCompletion; "Expected Date of Completion")
            {
            }
            column(FullyDisbursed; "Fully Disbursed")
            {
            }
            column(Gender; Gender)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(GracePeriodInterest; "Grace Period (Interest)")
            {
            }
            column(GracePeriodPrincipal; "Grace Period (Principal)")
            {
            }
            column(GroupCode; "Group Code")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(IgnoreRelatedBalance; "Ignore Related Balance")
            {
            }
            column(InstallmentPeriod; "Installment Period")
            {
            }
            column(Installments; Installments)
            {
            }
            column(InterestCalculationMethod; "Interest Calculation Method")
            {
            }
            column(InterestDefaulted; "Interest Defaulted")
            {
            }
            column(InterestDueDate; "Interest Due Date")
            {
            }
            column(InterestOptions; "Interest Options")
            {
            }
            column(InterestPostingDate; "Interest Posting Date")
            {
            }
            column(InterestRate; "Interest Rate")
            {
            }
            column(InterestRepayment; "Interest Repayment")
            {
            }
            column(LastPayDate; "Last Pay Date")
            {
            }
            column(LoanAccount; "Loan Account")
            {
            }

            column(LoanCycle; "Loan Cycle")
            {
            }
            column(LoanPaymentDestination; "Loan Payment Destination")
            {
            }
            column(LoanRejectionReason; "Loan Rejection Reason")
            {
            }
            column(LoanRescheduled; "Loan Rescheduled")
            {
            }
            column(LoanSpan; "Loan Span")
            {
            }
            column(LoanStatus; "Loan Status")
            {
            }
            column(MemberCategory; "Member Category")
            {
            }
            column(MinuteNo; "Minute No.")
            {
            }
            column(ModeofDisbursement; "Mode of Disbursement")
            {
            }
            column(MonthsInarrears; "Months In arrears")
            {
            }
            column(No; "No.")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(NoofInstallment; "No. of Installment")
            {
            }
            column(OldAccountNo; "Old Account No.")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingBill; "Outstanding Bill")
            {
            }
            column(OutstandingInsurance; "Outstanding Insurance")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(PaymentDestination; "Payment Destination")
            {
            }
            column(PaymentDestinationCode; "Payment Destination Code")
            {
            }
            column(PaymentMode; "Payment Mode")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(PostApplicationAs; "Post Application As")
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(PrincipleRepayment; "Principle Repayment")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(PurposeofLoan; "Purpose of Loan")
            {
            }
            column(RecommendedAmount; "Recommended Amount")
            {
            }
            column(RecoveryMode; "Recovery Mode")
            {
            }
            column(RecoveryNo; "Recovery No.")
            {
            }
            column(RelatedBalance; "Related Balance")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(Repayment; Repayment)
            {
            }
            column(RepaymentFrequency; "Repayment Frequency")
            {
            }
            column(RepaymentMode; "Repayment Mode")
            {
            }
            column(RepaymentStartDate; "Repayment Start Date")
            {
            }
            column(RequestedAmount; "Requested Amount")
            {
            }
            column(RescheduleBy; "Reschedule By")
            {
            }
            column(ResponsibilityCentre; "Responsibility Centre")
            {
            }
            column(SMSNotificationSent; "SMS Notification Sent")
            {
            }
            column(Sectors; Sectors)
            {
            }
            column(SelfGuarantee; "Self Guarantee")
            {
            }
            column(SettlementFee; "Settlement Fee")
            {
            }
            column(SharesDeposit; "Shares Deposit")
            {
            }
            column(Source; Source)
            {
            }
            column(SubSectors; "Sub Sectors")
            {
            }
            column(SystemNonCreated; "System Non-Created")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TimeCreated; "Time Created")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(TopUpLoan; "TopUp Loan")
            {
            }
            column(ToppedUpLoan; "Topped Up Loan")
            {
            }
            column(TotalAmountDisbursed; "Total Amount Disbursed")
            {
            }
            column(TotalCharges; "Total Charges")
            {
            }
            column(TotalDisbured; "Total Disbured")
            {
            }
            column(TotalDisbursed; "Total Disbursed")
            {
            }
            column(TotalTopUp; "Total TopUp")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                daysinarrears := 0;
                AmountInarrears := 0;
                ExpectedAmount := 0;
                AmountPaid := 0;

                LoansT.Reset();
                LoansT.SetRange("No.", "No.");
                LoansT.SetRange("Date Filter", 0D, StartDate);
                IF LoansT.Find('-') THEN BEGIN
                    LoansT.CalcFields("Outstanding Principal", "Outstanding Balance", "Total Schedule Repayment", "Loan principal Schedule");



                    ExpectedAmount := LoansT."Loan principal Schedule";
                    AmountPaid := LOANST."Approved Amount" - LoansT."Outstanding Principal";

                    AmountInarrears := ExpectedAmount - AmountPaid;


                    IF AmountInarrears <= 0 then
                        AmountInarrears := 0;


                    if LoansT."Expected Date of Completion" <= StartDate then
                        AmountInarrears := LoansT."Outstanding Principal";

                    if LoansT."Repayment Start Date" > StartDate then
                        AmountInarrears := 0;

                    IF AmountInarrears > 0 then begin
                        if LoansT."Principle Repayment" <> 0 then
                            Monthsinarrears := Round((AmountInarrears / LoansT."Principle Repayment"), 1, '=');
                    end;

                    if (Monthsinarrears <= 1) then begin
                        LoansT."Months In arrears" := Monthsinarrears;
                        /// LoansT."Loan Categorisation" := LoansT."Loan Categorisation"::Performing;
                        Loanst."Amount in Arrears" := AmountInarrears;
                    end;

                    if (Monthsinarrears > 1) and (Monthsinarrears <= 3) then begin
                        LoansT."Months In arrears" := Monthsinarrears;
                        // LoansT."Loan Categorisation" := LoansT."Loan Categorisation"::Watch;
                        Loanst."Amount in Arrears" := AmountInarrears;
                    end;

                    if (Monthsinarrears > 3) and (Monthsinarrears <= 6) then begin
                        LoansT."Months In arrears" := Monthsinarrears;
                        ///LoansT."Loan Categorisation" := LoansT."Loan Categorisation"::Substandard;
                        Loanst."Amount in Arrears" := AmountInarrears;
                    end;

                    if (Monthsinarrears > 6) and (Monthsinarrears <= 12) then begin
                        LoansT."Months In arrears" := Monthsinarrears;
                        // LoansT."Loan Categorisation" := LoansT."Loan Categorisation"::Doubtful;
                        Loanst."Amount in Arrears" := AmountInarrears;
                    end;


                    if (Monthsinarrears > 12) then begin
                        LoansT."Months In arrears" := Monthsinarrears;
                        ///LoansT."Loan Categorisation" := LoansT."Loan Categorisation"::Loss;
                        Loanst."Amount in Arrears" := AmountInarrears;
                    end;

                    LoansT.Modify();


                END
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
                    field(StartDate; StartDate)
                    {
                        Caption = 'StartDate';
                        ApplicationArea = All;
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


        daysinarrears: Integer;
        Monthsinarrears: Integer;
        AmountInarrears: Decimal;
        TotalLoans: Record Loans;
        CustEmail: Text[150];
        Employer: Record Customer;
        CustomerRec: Record Member;
        AmountPaid: Decimal;
        ExpectedAmount: Decimal;
        EmpName: Text;
        LastDepositDate: Date;
        AppAmount: Decimal;
        Disdate: Date;
        OutBal: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        LastTransDate: Date;
        StartDate: Date;
        EndDate: Date;
        LoansT: Record Loans;
        rschedule: Record "Repayment Schedule";



}
