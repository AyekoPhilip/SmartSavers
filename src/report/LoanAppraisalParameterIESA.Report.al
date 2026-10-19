namespace DynamicsNav.SaccoDatabase;

using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;

report 90010 "Loan Appraisal Parameter-IESA"
{
    ApplicationArea = All;
    Caption = 'Appraisal Parameter-IESA';
    UsageCategory = Administration;
    UseRequestPage = true;
    ShowPrintStatus = false;
    RDLCLayout = './src/report_layout/IESALoanAppraisalParameter.rdl';
    dataset
    {
        dataitem("Loan Appraisal Parameter"; "Loan Appraisal Parameter")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            { }
            column(CompInfoName; CompInfo.Name)
            { }
            column(ShowChargeDetails; ShowChargeDetails)
            { }
            column(ShowRefinedDetail; ShowRefinedDetail)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(ReferenceText; ReferenceText)
            { }
            column(A_third_Rule_Violation; "A third Rule Violation")
            { }
            column(WarningsTxtThirdRule; AthirdWarning)
            { }
            column(WarningsTxtSecurity; WarningsTxt[2])
            { }
            column(Deposit_Mutiplier; "Deposit Mutiplier")
            { }
            column(Account_Balance; "Account Balance")
            { }
            column(Account_Category; "Account Category")
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(Minute_No_; "Minute No.")
            { }
            column(LoanNo; LoanNo)
            { }
            column(ShowLoanNo; ShowLoanNo)
            { }
            column(Net_Utilisable_Amount; "Net Utilisable Amount")
            { }
            column(BankAccount; BankAccount)
            { }
            column(RiskText001; RiskText001)
            { }
            column(RiskText002; RiskText002)
            { }
            column(BankName; BankName)
            { }
            column(Net_utilizable; "Net utilizable")
            { }
            column(ShowSalaryDetails; ShowSalaryDetails)
            { }
            column(Max__Loan_Amount; "Max. Loan Amount")
            { }
            column(Total_Stop_Order_Amount; "Total Stop Order Amount")
            { }
            column(Qualification__Business_; "Qualification (Business)")
            { }
            column(Net_On_Salary; "Net On Salary")
            { }
            column(New_Excess_Amount; "New Excess Amount")
            { }
            column(New_Net_Salary; "New Net Salary")
            { }

            column(Total__Deductions_; "Total (Deductions)")
            { }
            column(CustomerAge; CustomerAge)
            { }
            column(CompInfoAddress; CompInfo.Address)
            { }
            column(CompInfoPhone; CompInfo."Phone No.")
            { }
            column(CompInfoPicture; CompInfo.Picture)
            { }
            column(Due_Application; "Due Application")
            { }
            column(Total_Commitment; "Total Commitment")
            { }
            column(Commitment__; "Commitment %")
            { }
            column(Total_Exposure; "Total Exposure")
            { }
            column(Deposit_Purchase; "Deposit Purchase")
            { }
            column(Gross_Pay__; "Gross Pay %")
            { }
            column(External_Commitment; "External Commitment")
            { }
            column(Consolidated_Loans_External_; "Consolidated Loans(External)")
            { }
            column(Consolidated_Loans_Sacco_; "Consolidated Loans(Sacco)")
            { }
            column(Balance__LCY_; "Balance (LCY)")
            { }
            column(Applicant_Age; "Applicant Age")
            { }
            column(EntryNo_LoanAppraisalParameters; "Loan Appraisal Parameter"."Entry No.")
            { }
            column(No_LoanAppraisalParameters; "Loan Appraisal Parameter"."No.")
            { }
            column(Property_Type; "Property Type")
            { }
            column(Property_Description; "Property Description")
            { }
            column(Valuation_Amount; "Valuation Amount")
            { }
            column(Repayment; Repayment)
            { }
            column(Gross_Pay; "Gross Pay")
            { }
            column(Net_Pay; "Net Pay")
            { }
            column(External_Effects; "External Effects")
            { }
            column(Sacco_Deductions; "Sacco Deductions")
            { }
            column(Excess_of_a_Third; "Excess of a Third")
            { }
            column(Third_of_Net_Basic; "Third of Net Basic")
            { }
            column(Commitment; Commitment)
            { }
            column(Remarks; Remarks)
            { }
            column(No__of_Loan_Guaranteed; "No. of Loan Guaranteed")
            {
            }
            column(Qualifying_Dividend; "Qualifying Dividend")
            { }
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
            column(ProductType_LoanAppraisalParameters; "Loan Appraisal Parameter"."Product Type")
            {
            }
            column(AmountRequested_LoanAppraisalParameters; "Loan Appraisal Parameter"."Amount (Requested)")
            {
            }
            column(AccountNo_LoanAppraisalParameters; IesaNo)
            {
            }
            column(AccountName_LoanAppraisalParameters; "Loan Appraisal Parameter"."Account Name")
            {
            }
            column(ApplicationDate_LoanAppraisalParameters; "Loan Appraisal Parameter"."Application Date")
            {
            }
            column(CreatedBy_LoanAppraisalParameters; "Loan Appraisal Parameter"."Created By")
            {
            }
            column(LastModifiedBy_LoanAppraisalParameters; "Loan Appraisal Parameter"."Last Modified By")
            {
            }
            column(LastModifiedDate_LoanAppraisalParameters; "Loan Appraisal Parameter"."Last Modified Date")
            {
            }
            column(AmountApproved_LoanAppraisalParameters; "Loan Appraisal Parameter"."Amount Approved")
            {
            }
            column(PayrollStaffNo_LoanAppraisalParameters; "Loan Appraisal Parameter"."Payroll/Staff No.")
            {
            }
            column(EmployerCode_LoanAppraisalParameters; "Loan Appraisal Parameter"."Employer Code")
            {
            }
            column(Installments_LoanAppraisalParameters; "Loan Appraisal Parameter".Installments)
            {
            }
            column(Interest_LoanAppraisalParameters; "Loan Appraisal Parameter".Interest)
            {
            }
            column(RepaymentStartDate_LoanAppraisalParameters; "Loan Appraisal Parameter"."Repayment Start Date")
            {
            }
            column(ExpectedCompletionDate_LoanAppraisalParameters; "Loan Appraisal Parameter"."Expected Completion Date")
            {
            }
            column(ProductName_LoanAppraisalParameters; "Loan Appraisal Parameter"."Product Name")
            {
            }
            column(ExciseDutyCharges_LoanAppraisalParameters; "Loan Appraisal Parameter"."Excise Duty Charges")
            {
            }
            column(DepositPurchase_LoanAppraisalParameters; "Loan Appraisal Parameter"."Deposit Purchase")
            {
            }
            column(Sector_LoanAppraisalParameters; "Loan Appraisal Parameter".Sector)
            {
            }
            column(SubSector_LoanAppraisalParameters; "Loan Appraisal Parameter"."Sub-Sector")
            {
            }
            column(LoanPurpose_LoanAppraisalParameters; "Loan Appraisal Parameter"."Loan Purpose")
            {
            }
            column(Salary_Remittance; "Salary Remittance")
            {

            }
            column(Salary_Remittance_Multiplier; "Salary Remittance Multiplier")
            {

            }
            column(SectorTxt; SectorTxt)
            { }
            column(SubSectorTxt; SubSectorTxt)
            { }
            column(LoanPurposeTxt; LoanPurposeTxt)
            { }
            column(PhoneNo; PhoneNo)
            { }
            column(EmployerName; EmployerName)
            { }
            column(CustStation; CustStation)
            { }
            column(TermsofEmployment; TermsofEmployment)
            { }
            column(PostCode; PostCode)
            { }
            dataitem(Loans; Loans)
            {
                DataItemLink = "Account No." = field("Account No.");
                DataItemTableView = where("Outstanding Balance" = filter(> 0));
                column(ExistLoanNo; "No.")
                { }
                column(Product_Type; "Product Type")
                { }
                column(Product_Description; "Product Description")
                { }
                column(ExistLoanRepayment; Repayment)
                { }
                column(Outstanding_Balance; "Outstanding Balance")
                { }
                column(Outstanding_Insurance; "Outstanding Insurance")
                { }
                column(Outstanding_Interest; "Outstanding Interest")
                { }
                column(Outstanding_Principal; "Outstanding Principal")
                { }
                column(Outstanding_Bill; "Outstanding Bill")
                { }
                column(Expected_Date_of_Completion; "Expected Date of Completion")
                { }
            }
            dataitem("Member Monthly Contribution"; "Member Monthly Contribution")
            {
                DataItemLink = "Account No." = field("Account No.");
                column(Application_No_; "Application No.")
                { }
                column(Type; Remarks)
                { }
                column(MCAmount; Amount)
                { }
                trigger OnAfterGetRecord()
                var
                    Accbanking: Record "Account Banking";
                    CredAccount: Record "Account Credit";
                begin

                    case Type of
                        Type::"Shares Deposit",
                        Type::"Shares Capital":
                            begin
                                if CredAccount.Get("Application No.") then
                                    Remarks := CredAccount."Product Name";

                            end;
                        Type::"Specialty Savings":
                            begin
                                if Accbanking.Get("Application No.") then
                                    Remarks := Accbanking."Product Name";
                            end;
                    end;
                end;
            }
            dataitem("Other Commitements Clearance"; "Other Commitements Clearance")
            {
                DataItemLink = "Application No." = field("No.");
                column(extAccount_Type; "Account Type")
                { }
                column(Entry_No_; "Entry No.")
                { }
                column(EFT_Options; "EFT Options")
                { }
                column(ExtAccount_Name; "Account Name")
                { }
                column(ExtAccount_No_; "Account No.")
                { }
                column(Bank_Name; "Bank Name")
                { }
                column(ExtAmount; Amount)
                { }
                column(Description; Description)
                { }
                column(Bank_Code; "Bank Code")
                { }
                column(Monthly_Deduction; "Monthly Deduction")
                { }
                column(Payment_Destination; "Payment Destination")
                { }
                column(Payment_Destination_Code; "Payment Destination Code")
                { }
                column(External_Account_No_; "External Account No.")
                { }
                column(External_Account_Name; "External Account Name")
                { }
                column(Recipient_Reference; "Recipient Reference")
                { }
                column(Own_Reference; "Own Reference")
                { }
                column(Branch_Code; "Branch Code")
                { }
                column(Member_No_; "Member No.")
                { }
                column(Mobile_Phone_No_; "Mobile Phone No.")
                { }
            }
            dataitem(Security; "Loan Guarantors and Security")
            {
                DataItemLink = "No." = FIELD("No.");

                column(No_Security; Security."No.")
                {
                }
                column(AccountNo_Security; Security."Account No.")
                {
                }
                column(Name_Security; Security.Name)
                {
                }
                column(DepositShares_Security; Security."Deposit Shares")
                {
                }
                column(NoofLoansGuaranteed_Security; Security."No. of Loans Guaranteed")
                {
                }
                column(Substituted_Security; Security.Substituted)
                {
                }
                column(Date_Security; Security.Date)
                {
                }
                column(AmountGuaranteed_Security; Security."Amount Guaranteed")
                {
                }
                column(SelfGuaranteed_Security; Security."Self Guaranteed")
                {
                }
                column(IDNo_Security; Security."ID No.")
                {
                }
                column(OutstandingBalance_Security; TotOutBalance)
                {
                }
                column(MemberGuaranteed_Security; Security."Member Guaranteed")
                {
                }
                column(AvailableShares_Security; Security."Available Shares")
                {
                }
                column(MemberNo_Security; Security."Member No.")
                {
                }
                column(ProductType_Security; Security."Product Type")
                {
                }
                column(GuaranteedBalance_Security; Security."Guaranteed Balance")
                {
                }
                column(SecurityType_Security; Security."Security Type")
                {
                }
                column(CollateralRegNo_Security; Security."Collateral Reg. No.")
                {
                }
                column(CollateralValue_Security; Security."Collateral Value")
                {
                }
                column(Total_Loan_Balance; Security."Total Loan Balance")
                {
                }
                trigger OnAfterGetRecord()
                var
                    NoOfLoanGuaranteed: Integer;
                    GuarantorsPosted: Record "Guarantor & Security Posted";
                    PostedFacility: Record Loans;
                begin

                    NoOfLoanGuaranteed := 0;
                    TotOutBalance := 0;

                    GuarantorsPosted.Reset();
                    GuarantorsPosted.SetRange(Substituted, false);
                    GuarantorsPosted.SetFilter("Outstanding Balance", '>0');
                    GuarantorsPosted.SetRange("Account No.", Security."Account No.");
                    if GuarantorsPosted.Find('-') then begin
                        GuarantorsPosted.CalcFields("Outstanding Balance");
                        NoOfLoanGuaranteed := GuarantorsPosted.Count;
                    end;

                    PostedFacility.Reset();
                    PostedFacility.SetRange("Account No.", Security."Member No.");
                    PostedFacility.SetFilter("Outstanding Balance", '>0');
                    if PostedFacility.FindSet() then begin
                        repeat
                            PostedFacility.CalcFields("Outstanding Balance");
                            TotOutBalance := TotOutBalance + PostedFacility."Outstanding Balance";
                        until PostedFacility.Next() = 0;
                        Security."Total Loan Balance" := TotOutBalance;
                        Security.Modify(true);
                    end;
                end;
            }
            dataitem(LoanTopup; "Loans Top up")
            {
                DataItemLink = "No." = FIELD("No."), "Account No." = FIELD("Account No.");
                column(No_LoanTopup; LoanTopup."No.")
                { }
                column(LoanTopUp_LoanTopup; LoanTopup."Loan Top Up")
                { }
                column(AccountNo_LoanTopup; LoanTopup."Account No.")
                { }
                column(ProductType_LoanTopup; ProdDescription)
                { }
                column(OutstandingPrinciple_LoanTopup; LoanTopup."Outstanding Principle")
                { }
                column(LoanTopOutstandingInsurance; "Outstanding Insurance")
                { }
                column(OutstandingInterest_LoanTopup; LoanTopup."Outstanding Interest")
                { }
                column(TotalOutstandingAmount_LoanTopup; LoanTopup."Total Outstanding Amount")
                { }
                column(OutstandingBalance_LoanTopup; LoanTopup."Outstanding Balance")
                { }
                column(Commision_LoanTopup; LoanTopup.Commision)
                { }
                column(OutstandingBill_LoanTopup; LoanTopup."Outstanding Bill")
                { }
                column(UntransferedInterest_LoanTopup; LoanTopup."Untransfered Interest")
                { }
                column(OutstandingFee_LoanTopup; LoanTopup."Outstanding Fee")
                { }
                column(Total_Total_Up; "Total Total Up")
                { }
                trigger OnAfterGetRecord()
                var
                    FactoryProd: Record "Product Factory";
                begin
                    ProdDescription := '';
                    "Untransfered Interest" := Round("Untransfered Interest", 0.1, '=');
                    if FactoryProd.Get("Product Type") then
                        ProdDescription := FactoryProd.Description;
                    //if "Outstanding Principle" = 0 then ShowRefinedDetail := false else ShowRefinedDetail := true
                end;

            }
            dataitem(LoanCharges; "Loan Application Charge")
            {
                DataItemLink = "Application No." = FIELD("No.");
                DataItemTableView = WHERE("Post Charge" = CONST(true));
                column(PChargeAmt; PChargeAmt)
                {
                }
                column(ChargeCode_LoanCharges; LoanCharges."Charge Code")
                {
                }
                column(ChargeDescription_LoanCharges; LoanCharges."Charge Description")
                {
                }
                column(ChargeAmount_LoanCharges; LoanCharges."Charge Amount")
                {
                }
                column(UsePercentage_LoanCharges; LoanCharges."Use Percentage")
                {
                }
                column(Percentage_LoanCharges; LoanCharges.Percentage)
                {
                }
                column(ChargeType_LoanCharges; LoanCharges."Charge Type")
                {
                }
                column(ChargingOption_LoanCharges; LoanCharges."Charging Option")
                {
                }
                column(ProductCode_LoanCharges; LoanCharges."Product Code")
                {
                }
                column(AccountNo_LoanCharges; LoanCharges."Account No.")
                {
                }
                column(Minimum_LoanCharges; LoanCharges.Minimum)
                {
                }
                column(Maximum_LoanCharges; LoanCharges.Maximum)
                {
                }
                column(EffectExciseDuty_LoanCharges; LoanCharges."Effect Excise Duty")
                {
                }

                trigger OnAfterGetRecord()
                var
                    LoanApp: Record "Loan Application";
                begin

                    LoanApp.Reset();
                    LoanApp.SetRange("No.", "Application No.");
                    if LoanApp.FindFirst() then begin
                        LoanApp.CalcFields("Total TopUp", "Outstanding Total TopUp", "Total TopUp (Net)");
                        if (LoanApp."Total TopUp" = 0) and ("Charge Code" = '00002') then CurrReport.Skip();
                    end;

                    PChargeAmt := 0;

                    if "Staggered Charge Code" = '' then begin

                        if "Use Percentage" then begin
                            case "Charge Type" of
                                "Charge Type"::Restructure,
                                    "Charge Type"::"Top up":
                                    begin
                                        PChargeAmt := (LoanApp."Total TopUp (Net)" * (Percentage / 100))
                                    end;
                                "Charge Type"::General:
                                    begin
                                        PChargeAmt := ("Loan Appraisal Parameter"."Amount Approved" * (Percentage / 100));
                                    end;
                                "Charge Type"::Boosting:
                                    begin
                                        PChargeAmt := ("Loan Appraisal Parameter"."Deposit Purchase" * (Percentage / 100));
                                    end;
                            end
                        end else begin
                            PChargeAmt := "Charge Amount";
                        end;
                    end else begin

                        TransType.Reset();
                        TransType.SetRange("Staggered Charge Code", "Staggered Charge Code");
                        if TransType.FindFirst() then begin

                            TieredChargeLine.Reset();
                            TieredChargeLine.SetRange(code, TransType."Staggered Charge Code");
                            if TieredChargeLine.FindSet() then begin
                                repeat
                                    if (LoanApp."Total TopUp (Net)" >= TieredChargeLine."Lower Limit") and (LoanApp."Total TopUp (Net)" <= TieredChargeLine."Upper Limit") then begin
                                        if TieredChargeLine."Use Percentage" then begin
                                            PChargeAmt := (LoanApp."Total TopUp (Net)" * (TieredChargeLine.Percentage / 100));
                                        end else begin
                                            PChargeAmt := TieredChargeLine."Charge Amount"
                                        end;
                                    end;
                                until TieredChargeLine.Next() = 0;
                            end;
                        end;
                    end;

                    ///if PChargeAmt = 0 then ShowChargeDetails := false else ShowChargeDetails := true;
                end;
            }
            dataitem("Appraisal Salary Details"; "Appraisal Salary Details")
            {
                DataItemLink = "Loan Application No." = field("No.");

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
                column(No_AppraisalSalaryDetails; "Appraisal Salary Details"."No.")
                {
                }
                column(LoanApplicationNo_AppraisalSalaryDetails; "Appraisal Salary Details"."Loan Application No.")
                {
                }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnPostDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                var
                    ApprDetails: Record "Appraisal Salary Details";
                    Grosspay: Decimal;
                    Utilizable: Decimal;
                    StatutoryDeduction: Decimal;
                    NetSalary: Decimal;
                    OtherIncome: Decimal;
                    BridgeAmt: Decimal;
                    NonPayrollAmt: Decimal;
                    BandingShares: Decimal;
                    saccoDeducts: Decimal;
                    MonthlyContrib: Decimal;
                    CustAccount: Decimal;
                    Loans: Record Loans;
                    NetTakeHome: Decimal;
                    NetUlize: Decimal;
                    LoanApplic: Record "Loan Application";
                    LoansTopUp: Record "Loans Top up";
                    TopUpLoan: Record Loans;
                    PFact: Record "Product Factory";
                begin


                end;
            }
            dataitem("Loans Categorization"; "Loans Categorization")
            {
                DataItemLink = "Account No." = field("Account No.");

                DataItemTableView = where("Outstanding Balance" = filter(> 0));
                column(LoancategoryNo; "No.")
                { }
                column(LoancategoryProductDescription; "Product Description")
                { }
                column(LoancategoryOutstandingBalance; "Outstanding Balance")
                { }
                column(PerformanceIndicator; "Performance Indicator")
                { }
            }

            trigger OnAfterGetRecord()
            begin
                PhoneNo := '';
                PostCode := '';
                EmployerName := '';
                CustStation := '';
                BankAccount := '';
                BankName := '';
                RiskText001 := '';
                RiskText002 := '';
                LoanNo := '';
                IesaNo := '';
                AthirdWarning := '';
                ReferenceText := '';
                WarningsTxt[1] := '';
                WarningsTxt[2] := '';
                ShowLoanNo := false;
                if "Loan No." = '' then
                    ReferenceText := 'DRAFT COPY. Original Copy must be Produced once loan account has been created';
                    
                if "A third Rule Violation" then
                    AthirdWarning := AthirdDescript;

                if "Loan Not fully Secured" then begin
                    WarningsTxt[2] := SecurityWarningDescript
                end;

                GeneralSetUp.Get();
                GeneralSetUp.TestField("Max. Member Age");

                if CustRecord.Get("Account No.") then begin
                    IesaNo := CustRecord."Old Member No.";
                    TermsofEmployment := CustRecord."Terms of Employment";
                    Segments.Reset();
                    Segments.SetRange(Code, CustRecord."Station/Department");
                    if Segments.FindFirst() then
                        CustStation := Segments.Description;

                    PhoneNo := CustRecord."Phone No.";
                    if Employer.Get(CustRecord."Employer Code") then
                        EmployerName := CustRecord."Employer Code";
                    PostCode := 'P.O Box' + ' ' + CustRecord."Post Code" + ' ' + ' ' + CustRecord.City;

                    MembCategory.SetRange("No.", CustRecord."Member Category");
                    if MembCategory.FindFirst() then begin
                        if MembCategory."Terms of Service" <> MembCategory."Terms of Service"::Pensioner then begin
                            if CalcDate(GeneralSetUp."Max. Member Age", CustRecord."Date of Birth") <= Today then
                                RiskText002 := ErrorMembAgeTxt + Format(MembCategory."Terms of Service") else
                                RiskText002 := RemarkOnQualifyCust + Format(MembCategory."Terms of Service");
                        end else begin
                            RiskText002 := RemarksOnPensionableCust + Format(MembCategory."Terms of Service");
                        end;
                    end;
                end;

                Ploan.Reset();
                Ploan.SetRange("Application No.", "No.");
                if Ploan.FindFirst() then begin
                    LoanNo := Ploan."No.";
                    ShowLoanNo := true
                end;

                if LoanApp.Get("No.") then begin

                    BankAccount := LoanApp."Payment Destination";
                    Banks.Reset();
                    Banks.SetRange(Code, LoanApp."Payment Destination Code");
                    if Banks.FindFirst() then
                        BankName := Banks.Name + '-' + BankAccount;

                    if LoanApp.Idemnity then begin

                        if CredReference.Get(LoanApp."ID No.") then begin
                            RiskText001 := 'HIGH : ' + CredReference.Name + ' | ' + CredReference.Position;
                        end else begin
                            RiskText001 := 'LOW : ' + LoanApp."Account Name" + ' NOT listed under PEP Status as risky.';
                        end;
                    end else begin
                        RiskText001 := 'LOW : ' + LoanApp."Account Name" + ' NOT listed under PEP Status as risky.';
                    end;
                end;

                SasraSectors.Reset;
                SasraSectors.SetRange(Code, "Loan Appraisal Parameter".Sector);
                if SasraSectors.Find('-') then
                    SectorTxt := SasraSectors.Code;

                SasraSubSectors.Reset;
                SasraSubSectors.SetRange(Code, "Loan Appraisal Parameter"."Sub-Sector");
                if SasraSubSectors.Find('-') then
                    SubSectorTxt := SasraSubSectors.Code;

                LoanPurpose.Reset;
                LoanPurpose.SetRange(Code, "Loan Appraisal Parameter"."Loan Purpose");
                if LoanPurpose.Find('-') then
                    LoanPurposeTxt := LoanPurpose.Code;
                CustomerAge := getCustomerAge("Account No.");

            end;

            trigger OnPreDataItem()
            begin
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
                CompanyAddress := CompInfo.Address + ' -Post Code: ' + CompInfo."Post Code" + ' -City:' + CompInfo.City;
                CompanyTelephone := 'Tel: ' + CompInfo."Phone No." + ' -Office Tel: ' + CompInfo."Phone No. 2";
                //CommunicationOnline := 'E-mail: ' + CompInfo."E-Mail" + '- Website: ' + CompInfo."Home Page";
                ShowRefinedDetail := true;
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
                    field(ShowChargeDetails; ShowChargeDetails)
                    {
                        Caption = 'Show Charge Details';
                        ApplicationArea = All;

                    }
                    field(ShowRefinedDetail; ShowRefinedDetail)
                    {
                        Caption = 'Show Refinance Details';
                        ApplicationArea = All;
                    }
                    field(ShowSalaryDetails; ShowSalaryDetails)
                    {
                        Caption = 'Show Salary Details';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin


    end;

    procedure getCustomerAge(AccountNo: Code[100]) MemberAge: Integer
    var
        HrDate: Codeunit "Date Conversion";
        CustMember: Record Member;
        gensetup: Record "General Set-Up";
        AgeToRetire: Integer;
    begin
        if CustMember.Get(AccountNo) then begin
            if CustMember."Date of Birth" <> 0D then
                MemberAge := HrDate.DetermineAgeInYears(CustMember."Date of Birth", Today) else
                MemberAge := 0;
        end;
        AgeToRetire := (65 - MemberAge);
        exit(AgeToRetire)
    end;

    var
        CompInfo: Record "Company Information";
        ReferenceText: Text[150];
        Ploan: Record Loans;
        ShowLoanNo: Boolean;
        LoanNo: Code[100];
        PChargeAmt: Decimal;
        Segments: Record "Segment/County/Dividend/Signat";
        CustStation: Text[150];
        PostCode: Text[150];
        CompanyAddress: Text[200];
        CompanyTelephone: Text[200];
        CommunicationOnline: Text[200];
        ProdDescription: Text[150];
        LoanApp: Record "Loan Application";
        BankName: Text[250];
        IesaNo: Code[100];
        ShowRefinedDetail: Boolean;
        ShowChargeDetails: Boolean;
        Banks: Record "Cust. Bank Account";
        BankAccount: Code[100];
        RemarksOnPensionableCust: Label 'Member classified as a -  ';
        RemarkOnQualifyCust: Label 'Member within age for full repayment period. | Member Category - ';
        ErrorMembAgeTxt: Label 'Member due to retire before loan repayment is complete. | Member Category -';
        WarningsTxt: array[3] of Text;
        AthirdWarning: Text;
        AthirdDescript: Label 'Warning! A third of Basic Pay rule not met';
        SecurityWarningDescript: Label 'Warning! Security not sufficient to cover the loan';
        CredReference: Record "High Risk Customer";
        RiskText001: Text[250];
        GeneralSetUp: Record "General Set-Up";
        RiskText002: Text[250];
        PhoneNo: Text[100];
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        EmployerName: Text[150];
        Employer: Record Customer;
        CustRecord: Record member;
        TermsofEmployment: Enum TermsOfEmployment;
        SasraSectors: Record "Sasra Sector";
        SasraSubSectors: Record "Sasra-Sub Sector";
        LoanPurpose: Record "Loan Purpose";
        SectorTxt: Text[250];
        MembCategory: Record "Member Category";
        SubSectorTxt: Text[250];
        LoanPurposeTxt: Text[250];
        TotOutBalance: Decimal;
        CustomerAge: Integer;
        ShowSalaryDetails: Boolean;
}
