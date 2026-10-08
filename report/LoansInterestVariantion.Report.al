report 50345 "Loans Interest Variantion"
{
    ApplicationArea = All;
    Caption = 'Loans Interest Variantion';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/InterestVariantion.rdl';
    UseRequestPage = true;
    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView=where("Approval Status"=const(Posted));
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccruedInterest; "Accrued Interest")
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
            column(CurrencyCode; "Currency Code")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(DateRescheduled; "Date Rescheduled")
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
            column(EmployerCode; "Employer Code")
            {
            }
            column(ExpectedDateofCompletion; "Expected Date of Completion")
            {
            }
            column(FullyDisbursed; "Fully Disbursed")
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
            column(MinuteNo; "Minute No.")
            {
            }
            column(ModeofDisbursement; "Mode of Disbursement")
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
            column(SharesDeposit; "Shares Deposit")
            {
            }
            column(Source; Source)
            {
            }
            column(SubSectors; "Sub Sectors")
            {
            }
            column(TotalTopUp; "Total TopUp")
            {
            }
            column(IntRate;IntRate)
            {
                
            }
            trigger OnPreDataItem()
            begin

            end;
            trigger OnAfterGetRecord()
            begin
                IntRate:=0;
                if ProdFact.Get(Loans."Product Type") then begin
                    IntRate:=ProdFact."Interest Rate (Max.)"
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
    var
    ProdFact: Record "Product Factory";
    IntRate: Decimal;
}



