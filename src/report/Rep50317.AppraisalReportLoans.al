report 50317 "Appraisal Report-Loans"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/AppraisalReportLoans.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "No.", "Account No.";
            column(CompInfoName; CompInfo.Name)
            {
            }
            column(CompInfoAddress; CompInfo.Address)
            {
            }
            column(CompInfoPicture; CompInfo.Picture)
            {
            }
            column(CompInfoPostCode; CompInfo."Post Code")
            {
            }
            column(CompInfoHomePage; CompInfo."E-Mail")
            {
            }
            column(CompInfoEMail; CompInfo."E-Mail")
            {
            }
            column(CompInfoPhoneNo; CompInfo."Phone No.")
            {
            }
            column(No_LoanApplication; "Loan Application"."No.")
            {
            }
            column(ApplicationDate_LoanApplication; "Loan Application"."Application Date")
            {
            }
            column(ProductType_LoanApplication; "Loan Application"."Product Type")
            {
            }
            column(ProductDescription_LoanApplication; "Loan Application"."Product Description")
            {
            }
            column(AccountNo_LoanApplication; "Loan Application"."Account No.")
            {
            }
            column(RequestedAmount_LoanApplication; "Loan Application"."Requested Amount")
            {
            }
            column(ApprovedAmount_LoanApplication; "Loan Application"."Approved Amount")
            {
            }
            column(InterestRate_LoanApplication; "Loan Application"."Interest Rate")
            {
            }
            column(AccountName_LoanApplication; "Loan Application"."Account Name")
            {
            }
            column(Installments_LoanApplication; "Loan Application".Installments)
            {
            }
            column(DisbursementDate_LoanApplication; "Loan Application"."Disbursement Date")
            {
            }
            column(Repayment_LoanApplication; "Loan Application".Repayment)
            {
            }
            column(AmounttoDisburse_LoanApplication; "Loan Application"."Amount to Disburse")
            {
            }
            column(FullyDisbursed_LoanApplication; "Loan Application"."Fully Disbursed")
            {
            }
            column(RepaymentStartDate_LoanApplication; "Loan Application"."Repayment Start Date")
            {
            }
            column(DisbursementAccountNo_LoanApplication; "Loan Application"."Disbursement Account No.")
            {
            }
            column(GlobalDimension2Code_LoanApplication; "Loan Application"."Global Dimension 2 Code")
            {
            }
            column(IDNo_LoanApplication; "Loan Application"."ID No.")
            {
            }
            column(PayrollStaffNo_LoanApplication; "Loan Application"."Payroll/Staff No.")
            {
            }
            column(EmployerCode_LoanApplication; "Loan Application"."Employer Code")
            {
            }
            column(DepositPurchase_LoanApplication; "Loan Application"."Deposit Purchase")
            {
            }
            dataitem("Loan Appraisal Parameter"; "Loan Appraisal Parameter")
            {
                DataItemLink = "No." = FIELD("No.");
                column(DepositMutiplier_LoanAppraisalParameters; "Loan Appraisal Parameter"."Deposit Mutiplier")
                {
                }
                column(Multiplier_LoanAppraisalParameters; "Loan Appraisal Parameter".Multiplier)
                {
                }
                column(QualificationShares_LoanAppraisalParameters; "Loan Appraisal Parameter"."Qualification (Shares)")
                {
                }
                column(QualificationSalary_LoanAppraisalParameters; "Loan Appraisal Parameter"."Qualification (Salary)")
                {
                }
                column(QualificationSecurity_LoanAppraisalParameters; "Loan Appraisal Parameter"."Qualification (Security)")
                {
                }
                column(RelatedBalance_LoanAppraisalParameters; "Loan Appraisal Parameter"."Related Balance")
                {
                }
                column(MaxCreditAvailable_LoanAppraisalParameters; "Loan Appraisal Parameter"."Max. Credit Available")
                {
                }
                column(TotalTopup_LoanAppraisalParameters; "Loan Appraisal Parameter"."Total Topup")
                {
                }
                column(BoostingCharges_LoanAppraisalParameters; "Loan Appraisal Parameter"."Boosting (Charges)")
                {
                }
                column(AmountRecommended_LoanAppraisalParameters; "Loan Appraisal Parameter"."Amount (Recommended)")
                {
                }
                column(AmountNetTakeHome_LoanAppraisalParameters; "Loan Appraisal Parameter"."Amount (Net Take Home)")
                {
                }
                column(AmountTotalCharges_LoanAppraisalParameters; "Loan Appraisal Parameter"."Amount (Total Charges)")
                {
                }
                column(SharesDeposits_LoanAppraisalParameters; "Loan Appraisal Parameter"."Shares Deposits")
                {
                }
                column(AverageInterest_LoanAppraisalParameters; "Loan Appraisal Parameter"."Average Interest")
                {
                }
                column(NetOnDeposit_LoanAppraisalParameters; "Loan Appraisal Parameter"."Net On Deposit")
                {
                }
                column(TotalBasic_LoanAppraisalParameters; "Loan Appraisal Parameter"."Total (Basic)")
                {
                }
                column(TotalAllowance_LoanAppraisalParameters; "Loan Appraisal Parameter"."Total (Allowance)")
                {
                }
                column(TotalDeductions_LoanAppraisalParameters; "Loan Appraisal Parameter"."Total (Deductions)")
                {
                }
                column(TotalEarnings_LoanAppraisalParameters; "Loan Appraisal Parameter"."Total (Earnings)")
                {
                }
                column(TotalExternalDeduct_LoanAppraisalParameters; "Loan Appraisal Parameter"."Total External Deduct.")
                {
                }
                column(ExternalEffects_LoanAppraisalParameters; "Loan Appraisal Parameter"."External Effects")
                {
                }
                column(NetSalary_LoanAppraisalParameters; "Loan Appraisal Parameter"."Net Salary")
                {
                }
                column(NetOnSalary_LoanAppraisalParameters; "Loan Appraisal Parameter"."Net On Salary")
                {
                }
                column(LoanNetAmount_LoanAppraisalParameters; "Loan Appraisal Parameter"."Loan Net Amount")
                {
                }
                column(TotAmtGuaranteed_LoanAppraisalParameters; "Loan Appraisal Parameter"."Tot Amt. Guaranteed")
                {
                }
                column(TotalLoan_LoanAppraisalParameters; "Loan Appraisal Parameter"."Total Loan")
                {
                }
                column(QualifyingAmount_LoanAppraisalParameters; "Loan Appraisal Parameter"."Qualifying Amount")
                {
                }
                column(TopUpCommission_LoanAppraisalParameters; "Loan Appraisal Parameter"."TopUp Commission")
                {
                }
            }
            dataitem("Loan Application Charge"; "Loan Application Charge")
            {
                DataItemLink = "Application No." = FIELD("No.");
                DataItemTableView = SORTING("Charge Code", "Product Code") ORDER(Ascending);
                column(LChargeAmt; LChargeAmt)
                {
                }
                column(ChargeCode_LoanApplicationCharges; "Loan Application Charge"."Charge Code")
                {
                }
                column(ChargeDescription_LoanApplicationCharges; "Loan Application Charge"."Charge Description")
                {
                }
                column(ChargeAmount_LoanApplicationCharges; "Loan Application Charge"."Charge Amount")
                {
                }
                column(UsePercentage_LoanApplicationCharges; "Loan Application Charge"."Use Percentage")
                {
                }
                column(Percentage_LoanApplicationCharges; "Loan Application Charge".Percentage)
                {
                }
                column(ChargeType_LoanApplicationCharges; "Loan Application Charge"."Charge Type")
                {
                }
                column(ChargingOption_LoanApplicationCharges; "Loan Application Charge"."Charging Option")
                {
                }
                column(ProductCode_LoanApplicationCharges; "Loan Application Charge"."Product Code")
                {
                }
                column(AccountNo_LoanApplicationCharges; "Loan Application Charge"."Account No.")
                {
                }
                column(Minimum_LoanApplicationCharges; "Loan Application Charge".Minimum)
                {
                }
                column(Maximum_LoanApplicationCharges; "Loan Application Charge".Maximum)
                {
                }
                column(AdditionalCharge_LoanApplicationCharges; "Loan Application Charge"."Additional Charge %")
                {
                }
                column(EffectExciseDuty_LoanApplicationCharges; "Loan Application Charge"."Effect Excise Duty")
                {
                }
                column(Prorate_LoanApplicationCharges; "Loan Application Charge".Prorate)
                {
                }
                column(ChargeMethod_LoanApplicationCharges; "Loan Application Charge"."Charge Method")
                {
                }
                column(StaggeredChargeCode_LoanApplicationCharges; "Loan Application Charge"."Staggered Charge Code")
                {
                }
                column(LoanNo_LoanApplicationCharges; "Loan Application Charge"."Application No.")
                {
                }
                column(AccountType_LoanApplicationCharges; "Loan Application Charge"."Account Type")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LChargeAmt := 0;
                    case "Charge Type" of
                        "Charge Type"::General:
                            begin
                                if "Use Percentage" then
                                    LChargeAmt := Round(("Loan Application"."Approved Amount" * (Percentage / 100)), 1, '=') else
                                    LChargeAmt := "Charge Amount";
                            end;
                        "Charge Type"::Boosting:
                            begin
                                if "Use Percentage" then
                                    LChargeAmt := Round(("Loan Application"."Deposit Purchase" * (Percentage / 100)), 1, '=') else
                                    LChargeAmt := "Charge Amount";
                            end;
                        "Charge Type"::"Top up":
                            begin
                                if "Use Percentage" then
                                    LChargeAmt := Round(("Loan Application"."Total TopUp" * (Percentage / 100)), 1, '=') else
                                    LChargeAmt := "Charge Amount";
                            end;
                    end
                end;
            }
            dataitem("Loan Guarantors and Security"; "Loan Guarantors and Security")
            {
                DataItemLink = "No." = FIELD("No.");
                column(No_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."No.")
                {
                }
                column(AccountNo_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Account No.")
                {
                }
                column(Name_LoanGuarantorsandSecurity; "Loan Guarantors and Security".Name)
                {
                }
                column(DepositShares_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Deposit Shares")
                {
                }
                column(NoofLoansGuaranteed_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."No. of Loans Guaranteed")
                {
                }
                column(Substituted_LoanGuarantorsandSecurity; "Loan Guarantors and Security".Substituted)
                {
                }
                column(Date_LoanGuarantorsandSecurity; "Loan Guarantors and Security".Date)
                {
                }
                column(AmountGuaranteed_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Amount Guaranteed")
                {
                }
                column(SelfGuaranteed_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Self Guaranteed")
                {
                }
                column(IDNo_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."ID No.")
                {
                }
                column(OutstandingBalance_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Outstanding Balance")
                {
                }
                column(MemberGuaranteed_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Member Guaranteed")
                {
                }
                column(AvailableShares_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Available Shares")
                {
                }
                column(MemberNo_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Member No.")
                {
                }
                column(ProductType_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Product Type")
                {
                }
                column(GuaranteedBalance_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Guaranteed Balance")
                {
                }
                column(SecurityType_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Security Type")
                {
                }
                column(CollateralRegNo_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Collateral Reg. No.")
                {
                }
                column(CollateralValue_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Collateral Value")
                {
                }
                column(NotificationSent_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Notification Sent")
                {
                }
                column(MemberSubstituted_LoanGuarantorsandSecurity; "Loan Guarantors and Security"."Member Substituted")
                {
                }
            }
            dataitem("Loans Top up"; "Loans Top up")
            {
                DataItemLink = "No." = FIELD("No.");
                column(No_LoansTopup; "Loans Top up"."No.")
                {
                }
                column(LoanTopUp_LoansTopup; "Loans Top up"."Loan Top Up")
                {
                }
                column(AccountNo_LoansTopup; "Loans Top up"."Account No.")
                {
                }
                column(ProductType_LoansTopup; "Loans Top up"."Product Type")
                {
                }
                column(OutstandingPrinciple_LoansTopup; "Loans Top up"."Outstanding Principle")
                {
                }
                column(OutstandingInterest_LoansTopup; "Loans Top up"."Outstanding Interest")
                {
                }
                column(TotalAmount_LoansTopup; "Loans Top up"."Total Outstanding Amount")
                {
                }
                column(OutstandingBalance_LoansTopup; "Loans Top up"."Outstanding Balance")
                {
                }
                column(Commision_LoansTopup; "Loans Top up".Commision)
                {
                }
                column(OutstandingBill_LoansTopup; "Loans Top up"."Outstanding Bill")
                {
                }
                column(UntransferedInterest_LoansTopup; "Loans Top up"."Untransfered Interest")
                {
                }
                column(OutstandingFee_LoansTopup; "Loans Top up"."Outstanding Fee")
                {
                }
            }
            dataitem("Appraisal Salary Details"; "Appraisal Salary Details")
            {
                DataItemLink = "No." = FIELD("No.");
                column(ClientCode_AppraisalSalaryDetails; "Appraisal Salary Details"."Client Code")
                {
                }
                column(Code_AppraisalSalaryDetails; "Appraisal Salary Details".Code)
                {
                }
                column(Description_AppraisalSalaryDetails; "Appraisal Salary Details".Description)
                {
                }
                column(Type_AppraisalSalaryDetails; "Appraisal Salary Details".Type)
                {
                }
                column(Amount_AppraisalSalaryDetails; "Appraisal Salary Details".Amount)
                {
                }
                column(LoanNo_AppraisalSalaryDetails; "Appraisal Salary Details"."No.")
                {
                }
            }
            dataitem(Loans; Loans)
            {
                DataItemLink = "Account No." = FIELD("Account No.");
                DataItemTableView = WHERE("Purpose of Loan" = FILTER(> '0'));
                column(LoanNo_Loans; Loans."No.")
                {
                }
                column(LoanProductTypeName_Loans; Loans."Product Description")
                {
                }
                column(LoanProductType_Loans; Loans."Product Type")
                {
                }
                column(ApprovedAmount_Loans; Loans."Approved Amount")
                {
                }
                column(Installments_Loans; Loans.Installments)
                {
                }
                column(DisbursementDate_Loans; Loans."Disbursement Date")
                {
                }
                column(OutstandingBalance_Loans; Loans."Purpose of Loan")
                {
                }
                column(OutstandingInterest_Loans; Loans."SMS Notification Sent")
                {
                }
                column(OutstandingBills_Loans; Loans."CRM Application No.")
                {
                }
                column(LoansCategorySASRA_Loans; Loans."Time Created")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                CompInfo.Get();
                CompInfo.CalcFields(Picture)
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInfo: Record "Company Information";
        LChargeAmt: Decimal;
}




