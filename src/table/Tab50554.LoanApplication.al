table 50554 "Loan Application"
{
    DrillDownPageID = "Loan Application";
    LookupPageID = "Loan Application";
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[20])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Product Type"; Code[20])
        {
            TableRelation = if ("Application Type" = filter("Loan Restructure")) "Product Factory"."Product ID" where("Product Class" = CONST(Loan),
            Status = const(Active)) else
            if ("Application Type" = filter(Normal | Mobile | "Loan Calculator"))
            "Product Factory"."Product ID" where("Product Class" = const(Loan), Status = const(Active), "Responsibility Centre" = field("Responsibility Centre"), "Nature of Loan Type" = filter(Normal)) else
            if ("Application Type" = filter(Defaulter))
            "Product Factory"."Product ID" where("Product Class" = const(Loan), Status = const(Active), "Nature of Loan Type" = filter(Defaulter));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                CustEmp: Record Customer;
                ProductFact: Record "Product Factory";
                PayShedule: Record "Schedule of Loan Payment";
            begin
                GetProductType;
                OnValidateAccountNoOnAfterAssignValue(Rec, xRec)
            end;
        }
        field(50012; "Account No."; Code[20])
        {
            TableRelation = Member."No." where(Status = filter(Active), "Global Dimension 1 Code" = field("Global Dimension 1 Code"));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ObjCust: Record Member;
                ErrorMembAgeTxt: Label 'Member due to retire before loan repayment is complete. Do you wish to continue?';
                STermLoan: Record Loans;
                MaxLoan: Decimal;
                SalDetails: Record "Appraisal Salary Details";
                TestD: Integer;
            begin

                if "Account No." <> '' then begin
                    GetCustomerAccount;
                    OnValidateAccountNoOnAfterAssignValue(Rec, xRec)
                end;
            end;
        }
        field(50013; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Requested Amount" <> 0 then
                    UpdateRequestAmt
            end;
        }
        field(50014; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                RSchedule: Record "Schedule of Loan Payment";
                ProductFact: Record "Product Factory";
                PayShedule: Record "Schedule of Loan Payment";
                LoanProc: Codeunit "Gen.Jnl.-Post Periodic";
            begin
                UpdateApprovedAmt
            end;
        }
        field(50015; "Interest Rate"; Decimal)
        {
            Editable = false;
            Caption = 'Interest Rate';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Product Type");
                if ProdFac.Get("Product Type") then begin
                    if ("Interest Rate" < ProdFac."Interest Rate (Min.)") or
                      ("Interest Rate" > ProdFac."Interest Rate (Max.)") then
                        Error(InterestErrorTxt);
                end;
                if "Approved Amount" > 0 then
                    Validate("Approved Amount");
            end;
        }
        field(50016; "Account Name"; Text[50])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50017; "Approval Date"; Date)
        {
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
        field(50018; "Installments"; Integer)
        {
            Caption = 'Installments';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ErrorOnMaxThreshTxt: Label 'Member due to retire before loan repayment is complete. Do you wish to continue?';
                Text006: Label 'The value exceeds the maximum installments of %1';
                InstallmentPeriod: Integer;
                TieredRates: Record "Interest Rates Banding";
                CollatRegister: Record "Collateral Register";
                PeriodLimit: Integer;
                MembCategory: Record "Member Category";
                CustRecord: Record Member;
                HrDateConversion: Codeunit "Date Conversion";
                AgreementTxt: Record "Loan Guarantors and Security";
                DefaultInst: Integer;
            begin
                InstallmentPeriod := 0;
                PeriodLimit := 0;

                if "Approved Amount" > 0 then begin
                    TestField("Product Type");
                    if ProdFac.Get("Product Type") then begin
                        InstallmentPeriod := getMaxInstallmentPeriod(Installments);
                        if Installments > InstallmentPeriod then
                            Error(Text006, InstallmentPeriod);
                    end;
                    Validate("Approved Amount");
                end;
            end;
        }
        field(50019; "Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ErrorDisbDate: Label 'Disbursement Date cannot be less than today';
            begin
                if "Disbursement Date" < Today then Error(ErrorDisbDate);
                "Repayment Start Date" := getrepaymentStartDate;
                case "Repayment Frequency" of
                    "Repayment Frequency"::Daily:
                        "Expected Date of Completion" := CalcDate(
                        Format(Installments) + 'D', "Repayment Start Date");
                    "Repayment Frequency"::Weekly:
                        "Expected Date of Completion" := CalcDate(
                        Format(Installments) + 'W', "Repayment Start Date");
                    "Repayment Frequency"::Monthly:
                        "Expected Date of Completion" := CalcDate(
                        Format(Installments) + 'M', "Repayment Start Date");
                    "Repayment Frequency"::Quarterly:
                        "Expected Date of Completion" := CalcDate(
                        Format(Installments) + 'Q', "Repayment Start Date");
                    "Repayment Frequency"::Yearly:
                        "Expected Date of Completion" := CalcDate(
                        Format(Installments) + 'Y', "Repayment Start Date");
                end
            end;
        }
        field(50020; "Mode of Disbursement"; Enum "LoanModeofDisbursement")
        {
            Caption = 'Mode of Disbursement';
            DataClassification = CustomerContent;
        }
        field(50021; "Grace Period (Principal)"; DateFormula)
        {
            Caption = 'Grace Period (Principal)';
            DataClassification = CustomerContent;
        }
        field(50022; "Installment Period"; DateFormula)
        {
            Caption = 'Installment Period';
            DataClassification = CustomerContent;
        }
        field(50023; "Repayment"; Decimal)
        {
            Editable = false;
            Caption = 'Repayment';
            DataClassification = CustomerContent;
        }
        field(50024; "Product Description"; Text[50])
        {
            Editable = false;
            Caption = 'Product Description';
            DataClassification = CustomerContent;
        }
        field(50025; "Amount to Disburse"; Decimal)
        {
            Editable = false;
            Caption = 'Amount to Disburse';
            DataClassification = CustomerContent;
        }
        field(50026; "Fully Disbursed"; Boolean)
        {
            Caption = 'Fully Disbursed';
            DataClassification = CustomerContent;
        }
        field(50027; "No. of Installment"; Integer)
        {
            Caption = 'No. of Installment';
            DataClassification = CustomerContent;
        }
        field(50028; "Loan Rescheduled"; Boolean)
        {
            Caption = 'Loan Rescheduled';
            DataClassification = CustomerContent;
        }
        field(50029; "Date Rescheduled"; Date)
        {
            Caption = 'Date Rescheduled';
            DataClassification = CustomerContent;
        }
        field(50030; "Reschedule By"; Code[50])
        {
            Caption = 'Reschedule By';
            DataClassification = CustomerContent;
        }
        field(50031; "Interest Calculation Method"; Enum "InterestCalculationMethod")
        {
            Editable = false;
            Caption = 'Interest Calculation Method';
            DataClassification = CustomerContent;
        }
        field(50032; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50033; "Loan Cycle"; Integer)
        {
            Caption = 'Loan Cycle';
            DataClassification = CustomerContent;
        }
        field(50034; "Total Disbursed"; Decimal)
        {
            FieldClass = Normal;
            Caption = 'Total Disbursed';
            DataClassification = CustomerContent;
        }
        field(50035; "Repayment Start Date"; Date)
        {
            Editable = false;
            Caption = 'Repayment Start Date';
            DataClassification = CustomerContent;
        }
        field(50036; "Disbursement Account No."; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Disbursement Destination" = CONST("Banking Account")) "Account Banking"."No." WHERE(Status = CONST(Active),
                                                                                                    "Account Category" = CONST(Savings),
                                                                                                Blocked = CONST(" "))
            ELSE
            IF ("Disbursement Destination" = CONST("Banking Account")) "Bank Account"."No." WHERE(Blocked = CONST(false))
            ELSE
            IF ("Disbursement Destination" = CONST(Supplier)) Vendor."No." WHERE(Blocked = CONST(" "))
            ELSE
            IF ("Disbursement Destination" = CONST("Mobile Money")) "Account Banking"."No." WHERE(Status = CONST(Active),
                                                "Account Category" = CONST(Savings),
                                                Blocked = CONST(" "),
                                        "Mobile No." = FILTER(<> ''));
            Caption = 'Disbursement Account No.';
            DataClassification = CustomerContent;
        }
        field(50037; "Payroll/Staff No."; Code[20])
        {
            Editable = false;
            Caption = 'Payroll/Staff No.';
            DataClassification = CustomerContent;
        }
        field(50038; "Source"; Option)
        {
            OptionCaption = ' ,Banking,Credit,Repayment,Micro Credit';
            OptionMembers = " ","Banking","Credit","Repayment","Micro Credit";
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(50039; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50040; "Grace Period (Interest)"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Grace Period (Interest)';
        }
        field(50041; "Captured By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50042; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(50043; "Expected Date of Completion"; Date)
        {
            Caption = 'Expected Date of Completion';
            DataClassification = CustomerContent;
        }
        field(50044; "Repayment Mode"; Enum "LoanRecoverMode")
        {
            Editable = false;
            Caption = 'Repayment Mode';
            DataClassification = CustomerContent;
        }
        field(50045; "Repayment Frequency"; Enum "RepaymentFrequency")
        {
            Caption = 'Repayment Frequency';
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                fnValidateFrequencyRepay("Repayment Frequency")
            end;
        }
        field(50046; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                appStatus: Enum ApprovalStatus;
            begin
                CredMngt.OnValidateLoanStatusTxt("Approval Status", "Account No.",
                "Requested Amount", Repayment, "No.", "Disbursement Account No.",
                "Requested Amount", "Loan Rejection Reason", "Product Description")
            end;
        }
        field(50047; "Loan Rejection Reason"; Text[50])
        {
            Caption = 'Loan Rejection Reason';
            DataClassification = CustomerContent;
        }
        field(50048; "Recommended Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Recommended Amount';
            DataClassification = CustomerContent;
        }
        field(50049; "Loan Account"; Code[100])
        {
            Editable = true;
            TableRelation = "Credit Account"."No.";
            Caption = 'Loan Account';
            DataClassification = CustomerContent;
        }
        field(50050; "Loan Span"; Enum "LoanSpan")
        {
            Editable = false;
            Caption = 'Loan Span';
            DataClassification = CustomerContent;
        }
        field(50051; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50052; "Time Created"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Time Created';
        }
        field(50053; "Principle Repayment"; Decimal)
        {
            Editable = false;
            Caption = 'Principle Repayment';
            DataClassification = CustomerContent;
        }
        field(50054; "Interest Repayment"; Decimal)
        {
            Editable = false;
            Caption = 'Interest Repayment';
            DataClassification = CustomerContent;
        }
        field(50055; "Employer Code"; Code[20])
        {
            Editable = false;
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50056; "Charge Interest on Posting"; Enum "ChargeInterestDue")
        {
            Caption = 'Charge Interest on Posting';
            DataClassification = CustomerContent;
        }
        field(50057; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code")
            end;
        }
        field(50058; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(50059; "Disbursement Destination"; Enum "LoanDisbursementDestination")
        {
            Editable = false;
            Caption = 'Disbursement Destination';
            DataClassification = CustomerContent;
        }
        field(50060; "Responsibility Centre"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50061; "Batch No."; Code[20])
        {
            TableRelation = if ("Loan Payment Destination" = const("Fosa Account"))
                                         "Loan Disbursement Header"."No." where("Approval Status" = filter(Open), Posted = const(false)) else
            if ("Loan Payment Destination" = filter("Bank Account" | Supplier)) "EFT Transfer Header" where("Approval Status" = filter(Approved));
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Approval Status", "Approval Status"::Approved);
            end;
        }
        field(50062; "Self Guarantee"; Boolean)
        {
            Editable = false;
            Caption = 'Self Guarantee';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                PFacts: Record "Product Factory";
            begin
            end;
        }
        field(50063; "Appraisal Parameter Type"; Enum "AppraisalParameter")
        {
            Editable = false;
            Caption = 'Appraisal Parameter Type';
            DataClassification = CustomerContent;
        }
        field(50064; "Old Account No."; Code[20])
        {
            Caption = 'Old Account No.';
            DataClassification = CustomerContent;
        }
        field(50065; "Application Source"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Navision,Mobile,Web';
            OptionMembers = "Navision","Mobile","Web";
            Caption = 'Application Source';
        }
        field(50066; "Purpose of Loan"; Code[20])
        {
            TableRelation = "Loan Purpose".Code WHERE(Sector = FIELD(Sectors),
                                                       "Sub Sector" = FIELD("Sub Sectors"));
            Caption = 'Purpose of Loan';
            DataClassification = CustomerContent;
        }
        field(50067; "SMS Notification Sent"; Boolean)
        {
            Caption = 'SMS Notification Sent';
            DataClassification = CustomerContent;
        }
        field(50068; "CRM Application No."; Code[50])
        {
            TableRelation = "CRM Application"."No." WHERE("Application Type" = CONST("Loan Application"),
                                                           Created = CONST(false), "Approval Status" = FILTER(Open | Deffered));
            Caption = 'CRM Application No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                AttachCrmApplicationNo
            end;
        }
        field(50069; "CRM Captured By"; Code[100])
        {
            Editable = false;
            Caption = 'CRM Captured By';
            DataClassification = CustomerContent;
        }
        field(50070; "CRM Date"; Date)
        {
            Editable = false;
            Caption = 'CRM Date';
            DataClassification = CustomerContent;
        }
        field(50071; "CRM Created"; Boolean)
        {
            Editable = false;
            Caption = 'CRM Created';
            DataClassification = CustomerContent;
        }
        field(50072; "Charges & Commissions"; Decimal)
        {
            Caption = 'Charges & Commissions';
            DataClassification = CustomerContent;
        }
        field(50073; "Deposit Purchase"; Decimal)
        {
            Caption = 'Deposit Purchase';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                PFactory: Record "General Set-Up";
            begin
                updateDepositPurchase
            end;
        }
        field(50074; "Total TopUp"; Decimal)
        {
            CalcFormula = Sum("Loans Top up"."Total Total Up" WHERE("No." = FIELD("No."),
                                                                               "Account No." = FIELD("Account No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total TopUp';
        }
        field(50075; "ID No."; Code[20])
        {
            Editable = false;
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50076; "Loan Status"; Enum "LoanStatus")
        {
            Editable = false;
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(50077; "Application Type"; Enum "LoanApplictionType")
        {
            Editable = false;
            Caption = 'Application Type';
            DataClassification = CustomerContent;
        }
        field(50078; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50079; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Time Posted';
        }
        field(50080; "Shares Deposit"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Shares Deposit';
        }
        field(50081; "Amount Guaranteed"; Decimal)
        {
            CalcFormula = Sum("Loan Guarantors and Security"."Amount Guaranteed" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Amount Guaranteed';
        }
        field(50082; "Deposit Purchase Account"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Account Dimension" = filter(Credit | "Micro Credit")) "Account Credit"."No." WHERE("Member No." = FIELD("Account No."),
                                                          "Account Category" = filter("Shares Deposit"),
                                                          Status = const(Active), "Global Dimension 1 Code" = field("Global Dimension 1 Code")) else
            if ("Account Dimension" = const(Banking)) "Account Banking" where("Member No." = field("Account No."), Status = filter(Active | New | Dormant | Closed),
            "Account Category" = filter("Money Market" | "Specialty Savings" | "Women Savings")) else
            if ("Account Dimension" = filter(Loan)) Loans."No." where("Account No." = field("Account No."), "Outstanding Balance" = filter('>0'));
            Caption = 'Deposit Purchase Account';
        }
        field(50083; "Sectors"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sasra Sector";
            Caption = 'Sectors';
        }
        field(50084; "Sub Sectors"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sasra-Sub Sector".Code WHERE(Sector = FIELD(Sectors));
            Caption = 'Sub Sectors';
        }
        field(50085; "Related Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Related Balance';
        }
        field(50086; "Post Application As"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Generate Batch,Post Application';
            OptionMembers = " ","Generate Batch","Post Application";
            Caption = 'Post Application As';
        }
        field(50087; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50088; "Recovery Mode"; Enum "LoanRecoverMode")
        {
            DataClassification = CustomerContent;
            Caption = 'Recovery Mode';
        }
        field(50089; "Shares Banding"; Decimal)
        {
            Caption = 'Shares Banding';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50090; "Minutes No. Series"; Code[50])
        {
            Caption = 'Minute No. Series';
            TableRelation = "No. Series";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50091; "Minute"; Code[50])
        {
            Caption = 'Minute No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50092; "Contract Period"; Code[50])
        {

        }
        field(50093; "Total Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Loan Balance (LCY)';
        }
        field(50094; "Deposits Appraisal Parameter"; Enum "DepositsAppraisalParameter")
        {
            DataClassification = CustomerContent;
            Caption = 'Security Appraisal Parameter';
            Editable = false;
        }
        field(50095; "Accrued Interest"; Decimal)
        {
            CalcFormula = Sum("Interest Line".Amount WHERE("Loan No." = FIELD("No."), Posted = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Accrued Interest';
        }
        field(50096; "Comments"; Text[250])
        {
            Caption = 'Comment Line';
        
            trigger OnValidate()
            begin
                "Comment Date" := Today;
            end;
        }
        field(50097; "Comment Date"; Date)
        {
            Editable = false;
        }
        field(50098; "Ignore Related Balance"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ignore Related Balance';
            Editable = false;
        }
        field(50099; "Total Disbured"; Decimal)
        {
            CalcFormula = Sum("Partial Disbursement Schedule".Amount where("Loan No." = field("No."), Posted = const(true), "Suggested for Disbursement" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50100; "Amount to Post"; Decimal)
        {
            CalcFormula = Sum("Partial Disbursement Schedule".Amount where("Loan No." = field("No."), "Suggested for Disbursement" = const(true), Posted = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101; "Sacco Deductions"; Decimal)
        {
            Editable = false;
            Caption = 'Existing deduction';
        }
        field(50102; "Qualifying Dividend Amount"; Decimal)
        {
            Editable = false;
        }
        field(50103; "Adjust Approved Amount"; Boolean)
        {
            Editable = true;
        }
        field(50104; "Exclude From Related Balance"; Boolean)
        {
            Editable = false;
            Caption = 'Exclude From Sacco Deduction';
        }
        field(50105; "Group Code"; Code[100])
        {
            Editable = false;
        }
        field(50106; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        
            trigger OnValidate()
            begin
                "Deposit Purchase Account" := '';
            end;
        }
        field(50107; "Loan Payment Destination"; Enum "LoanPaymentDestination")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Payment Destination';
        }
        field(50108; "Payment Destination"; Code[100])
        {
            TableRelation = if ("Loan Payment Destination" = const("Bank Account")) "Bank Account" where("Bank Type" = filter(Normal), Blocked = filter(false)) else
            if ("Loan Payment Destination" = filter("Mobile Money" | "Fosa Account"))
            "Account Banking" where("Account Category" = const(Savings), "Member No." = field("Account No."))
            else
            if ("Loan Payment Destination" = const(Supplier)) Vendor where("Account Type" = filter(<> Banking));
            DataClassification = CustomerContent;
            Caption = 'Payment Destination A/c';
            Editable = false;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50109; "Payment Destination Code"; Code[100])
        {
            TableRelation = if ("Loan Payment Destination" = const("Bank Account")) "Bank Account" where("Bank Type" = filter(Normal), Blocked = filter(false)) else
            if ("Loan Payment Destination" = filter("Mobile Money" | "Fosa Account")) "Account Banking" where("Account Category" = const(Savings), "Member No." = field("Account No.")) else
            if ("Loan Payment Destination" = const(Supplier)) Vendor where("Account Type" = filter(<> Banking));
            DataClassification = CustomerContent;
            Caption = 'Pay Point';
        
            trigger OnValidate()
            var
                AccBanking: Record "Account Banking";
            begin

                case "Loan Payment Destination" of

                    "Loan Payment Destination"::"Fosa Account",
                    "Loan Payment Destination"::"Mobile Money":
                        begin
                            "Payment Destination" := "Payment Destination Code";
                            "Payment Mode" := "Payment Mode"::"Fosa Account";
                        end;
                    "Loan Payment Destination"::Supplier:
                        begin
                            "Payment Destination" := "Payment Destination Code"
                        end;
                    "Loan Payment Destination"::"Bank Account":
                        begin
                            "Payment Destination" := "Payment Destination Code";
                            "Payment Mode" := "Payment Mode"::Cheque;
                        end;
                end;
            end;
        }
        field(50110; "Terms of Employment"; Enum "TermsOfEmployment")
        {
            Caption = 'Terms of Employment';
            DataClassification = CustomerContent;
        }
        field(50111; "Contract End Date"; Date)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Contract End Date" <= Today then
                    Error('Contract cannot be less than or equal to today');
            end;
        }
        field(50112; "Old Loan No."; Code[100])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50113; "Savings Balance(LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50114; "Billing Type"; Enum "BillingType")
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Type';
        }
        field(50115; "Tiered Installment (Default)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50116; "Idemnity"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'High Risk Classified';
            Editable = false;
        }
        field(50117; "EFT Options"; Enum "EFTPaymentOptions")
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                ProdFac.Get("Product Type");

                case "EFT Options" of
                    "EFT Options"::"Mobile Money":
                        begin
                            ProdFac.TestField("Mobile Money");
                            "EFT Options" := "EFT Options"::"Mobile Money";
                            if "Approved Amount" > 0 then begin
                                if "Approved Amount" > ProdFac."Mobile Money" then
                                    "Approved Amount" := ProdFac."Mobile Money"
                            end;
                        end;
                    "EFT Options"::"Money Wallet":
                        begin
                            ProdFac.TestField("Settlement Fee");
                            if "Approved Amount" > 0 then begin
                                if "Approved Amount" > ProdFac."Settlement Fee" then
                                    "Approved Amount" := ProdFac."Settlement Fee"
                            end;

                        end;
                end;
            end;
        }
        field(50118; "Swift Code"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50119; "Mobile Phone No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50120; "Other Purpose"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50121; "Outstanding Total TopUp"; Decimal)
        {
            CalcFormula = Sum("Loans Top up"."Total Outstanding Amount" WHERE("No." = FIELD("No."), "Account No." = FIELD("Account No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50122; "TopUp Loan"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Loans where("Account No." = field("Account No."), "Product Type" = field("Product Type"), "Outstanding Balance" = filter(> 0));
        }
        field(50123; "Check Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50124; "Payment Mode"; Enum "PaymentMode")
        {
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(50125; "Recovery Header No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50126; "Defaulted Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50127; "Charges Options"; Enum "ProductChargeOptions")
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Option';
        }
        field(50128; "Total TopUp (Net)"; Decimal)
        {
            CalcFormula = Sum("Loans Top up"."Total Outstanding Amount" where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total TopUp (Net)';
        }
        field(99000; "Product Dimension"; Enum "ProductDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Product Dimension';
        }
        field(50130; "Total Liquidation"; Decimal)
        {
            CalcFormula = Sum("Loans Liquidation"."Total Total Up" Where("No." = field("No."), "Account No." = field("Account No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total TopUp';
        }
    
        field(50129; "Total TopUp (Charge)"; Decimal)
        {
            CalcFormula = Sum("Loans Top up"."Total Outstanding Amount" where("No." = field("No."), "Ignore Charges" = filter(false)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total TopUp (Chargeable)';
        }
    }
    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            MembNoSeries.Get();

            case
                Rec."Application Type" of
                Rec."Application Type"::Normal:
                    begin
                        MembNoSeries.TestField("Loan Application Nos.");
                        "No. Series" := MembNoSeries."Loan Application Nos.";
                        if NoSeriesMgt.AreRelated(MembNoSeries."Loan Application Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")

                    end;
                Rec."Application Type"::"Loan Calculator":
                    begin
                        MembNoSeries.TestField("Loan Calculator Nos.");
                        "No. Series" := MembNoSeries."Loan Calculator Nos.";
                        if NoSeriesMgt.AreRelated(MembNoSeries."Loan Calculator Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")


                    end;
                Rec."Application Type"::"Loan Restructure":
                    begin
                        MembNoSeries.TestField("Loan Restructure Nos.");
                        "No. Series" := MembNoSeries."Loan Restructure Nos.";
                        if NoSeriesMgt.AreRelated(MembNoSeries."Loan Restructure Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")

                    end;
                Rec."Application Type"::Defaulter:
                    begin
                        MembNoSeries.TestField("Loan Applic Nos.(Defaulter)");
                        "No. Series" := MembNoSeries."Loan Applic Nos.(Defaulter)";
                        if NoSeriesMgt.AreRelated(MembNoSeries."Loan Applic Nos.(Defaulter)", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")
                    end;
            end;

            PassDocumentNo
        end;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Loan Application";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin

                case
                Rec."Application Type" of
                    Rec."Application Type"::Normal:
                        begin
                            MembNoSeries.Get();
                            NoSeriesMgt.TestManual(MembNoSeries."Loan Application Nos.");
                            "No. Series" := '';

                        end;
                    Rec."Application Type"::"Loan Calculator":
                        begin
                            MembNoSeries.Get();
                            NoSeriesMgt.TestManual(MembNoSeries."Loan Calculator Nos.");
                            "No. Series" := '';

                        end;
                    Rec."Application Type"::"Loan Restructure":
                        begin
                            MembNoSeries.Get();
                            NoSeriesMgt.TestManual(MembNoSeries."Loan Restructure Nos.");
                            "No. Series" := '';

                        end;
                    Rec."Application Type"::Defaulter:
                        begin
                            MembNoSeries.Get();
                            NoSeriesMgt.TestManual(MembNoSeries."Loan Applic Nos.(Defaulter)");
                            "No. Series" := '';
                        end;
                end;
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Loan Application"; xRecRef: Record "Loan Application"; var IsHandled: Boolean)
    begin
    end;

    var
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        RegMngt: Codeunit "Register Management";
        ErrorOnLoanRestructure: Label 'No existing loan found to restructure this application';
        VarVariant: Variant;
        CredMngt: Codeunit "Credit Mgmt.";
        Credit: Record "Credit Account";
        InterestErrorTxt: Label 'Interest Rate is not within allowed range.';
        ProdFac: Record "Product Factory";
        LoanDisbAccountNotFound: Label 'Loan Disbursement Account not Found.';
        ErrorOnAmtGuarantMoreThanAppAmtTxt: Label 'Amount guaranteed cannot be less than Approved Amount or Topup amount cannot be more than approved amount.';
        GeneralSetUp: Record "General Set-Up";
        ErrorOnInvalidEntry: Label 'This field amount is auto calculated. You can edit this amount.';
        ErrorOnLessNoOfGuarantorTxt: Label 'Loan has less No. of guarantor %1, allowed to guarantee a loan. The Min. No is %2.';

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"Loan Application", "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    local procedure AvailableCreditLimit()
    begin
        "Amount to Disburse" := xRec."Amount to Disburse";
        Installments := xRec.Installments;
    end;

    local procedure PassDocumentNo()
    var
        ExemptionsApprvl: Record "User Setup";
        PFact: Record "Product Factory";
        ObjectEmp: Record Employee;
    begin

        ExemptionsApprvl.Get(UserId);
        ExemptionsApprvl.TestField("Responsibility Centre");
        ExemptionsApprvl.TestField("Global Dimension 1 Code");
        ExemptionsApprvl.TestField("Global Dimension 2 Code");
        ExemptionsApprvl.TestField("Employee No.");

        "Responsibility Centre" := ExemptionsApprvl."Responsibility Centre";
        "Global Dimension 1 Code" := ExemptionsApprvl."Global Dimension 1 Code";
        "Global Dimension 2 Code" := ExemptionsApprvl."Global Dimension 2 Code";
        "Captured By" := UserId;
        "Application Date" := Today;
        "Disbursement Date" := Today;
    end;

    local procedure GetCustomerAccount()
    var
        Cust: Record Member;
        ErrorOnLoanstatus: Label 'Member has a Loan defaulted previously- %1';
        MsgOnNonGuaranteeAccount: Label 'Member no permitted to guarantee loan.Check comments. Are you you want to proceed?';
        ShareBanding: Record "Shares Banding";
        MonthlyContrib: Record "Member Monthly Contribution";
        ProdtCategory: Enum ProductAccountCategory;
        HrDate: Codeunit "Date Conversion";
        GuarantDetail: Record "Loan Guarantors and Security";
        CredAccount: Record "Account Credit";
        CustBank: Record "Cust. Bank Account";
        Membercategory: Record "Member Category";
        ErrorMembAgeTxt: Label 'Member less than Minimum age of %1.';
        ErrorOnMissingBankDetails: Label 'Customer have a corresponding bank account for payment';
        ExistingLoan: Record "Loans Categorization";
        Text012: Label 'The applicant has a Loan classified as -%1 - Loan No. %2.';
        ErrorOnMinShareBal: Label 'Member has shares less than Min. Balance of %1';
        Loan: Record Loans;
        TopupLoan: Record "Loans Top up";
        PostedFacility: Record Loans;
        TopUpRepayment: Decimal;
        Mcontrib: Decimal;
        TotalDeduct: Decimal;
        HighRiskCust: Record "High Risk Customer";
        ProdFact: Record "Product Factory";
        AccType: Record "Product Factory";
        CredtMngt: Record "Account Credit";
        ErrorOnMissingShareCapAc: Label 'Member does not have a %1 Account.';
        ErrorOnMinBalShareCapAc: Label 'Member has attained Min. Account balance of %1.';

    begin
        GeneralSetUp.Get();
        GeneralSetUp.TestField("Max. Member Age");
        GeneralSetUp.TestField("Max. Pensionable Age");
        fnInitializeEntryAcc();

        Idemnity := false;
        Cust.Get("Account No.");
        if "Application Type" <> "Application Type"::Defaulter then begin

            Cust.TestField("Registration Date");
            Cust.TestField("Date of Birth");
            Cust.TestField("ID No.");
            Cust.TestField("Mobile Phone No");
            Cust.TestField("Member Category");

            if CalcDate(GeneralSetUp."Min. Member Age", Cust."Date of Birth") > Today then
                Error(ErrorMembAgeTxt, GeneralSetUp."Min. Member Age");
        end;

        if not RegMngt.GetOperationAccTxt(ProdtCategory::"Shares Capital", Cust."No.", 2) then
            Error(ErrorOnMissingShareCapAc, ProdtCategory::"Shares Capital");

        CredtMngt.Reset();
        CredtMngt.SetRange("Member No.", Cust."No.");
        CredtMngt.SetRange("Account Category", CredtMngt."Account Category"::"Shares Capital");
        if CredtMngt.FindFirst() then begin

            ProdFact.Reset();
            if ProdFact.Get(CredtMngt."Product Type") then
                ProdFact.TestField("Minimum Balance");

            if RegMngt.GetOperationAccBalanceTxt(ProdtCategory::"Shares Capital", Cust."No.", 2) < ProdFact."Minimum Balance" then begin
                if ProdFact."Enforce Min. Share Rule" then begin
                    "Account Dimension" := "Account Dimension"::Credit;
                    "Deposit Purchase Account" := CredtMngt."No.";
                    "Deposit Purchase" := DocMngt.fnCustgetMinShare(CredtMngt."No.", CredtMngt."Account Category"::"Shares Capital");
                end;
            end;
        end;

        "Sacco Deductions" := 0;
        "Shares Deposit" := 0;
        "Shares Banding" := 0;
        "Savings Balance(LCY)" := 0;

        if "Product Type" <> '' then begin

            ProdFact.Reset();
            ProdFact.Get("Product Type");
            ProdFact.TestField("Minimum Balance");
            ProdFact.TestField("Disbursement Destination");

            if ProdFact."Check Min. Balance On" <> '' then begin
                if AccType.Get(ProdFact."Check Min. Balance On") then begin
                    case AccType."Account Dimension" of
                        AccType."Account Dimension"::Banking:
                            begin
                                if RegMngt.GetOperationAccBalanceTxt(AccType."Account Category", Cust."No.", 1) < ProdFact."Minimum Balance" then
                                    Error(ErrorOnMinShareBal, ProdFact."Minimum Balance");
                            end;
                        AccType."Account Dimension"::Credit,
                        AccType."Account Dimension"::"Micro Credit":
                            begin
                                if RegMngt.GetOperationAccBalanceTxt(AccType."Account Category", Cust."No.", 2) < ProdFact."Minimum Balance" then
                                    Error(ErrorOnMinShareBal, ProdFact."Minimum Balance");
                            end;
                    end;
                end;
            end;
        end;

        ExistingLoan.Reset();
        ExistingLoan.SetRange("Account No.", "Account No.");
        ExistingLoan.SetFilter("Outstanding Balance", '>0');
        if ExistingLoan.FindSet() then begin
            repeat
                ExistingLoan.CalcFields("Outstanding Balance");
                case ExistingLoan."Performance Indicator" of
                    ExistingLoan."Performance Indicator"::Doubtfull,
                    ExistingLoan."Performance Indicator"::Loss:
                        begin
                            if not GeneralSetUp."Override Setup Control" then
                                Error(Text012, ExistingLoan."Performance Indicator", ExistingLoan."No.");
                        end;
                end;
            until ExistingLoan.Next() = 0;
        end;

        if Cust."Loan Status" = Cust."Loan Status"::Defaulter then
            Error(ErrorOnLoanstatus, Cust."No.");

        CredAccount.Reset();
        CredAccount.SetRange("Can Guarantee Loan", false);
        CredAccount.SetRange("Member No.", Rec."Account No.");
        CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Deposit");
        if CredAccount.FindFirst() then begin
            if Confirm(MsgOnNonGuaranteeAccount, true) = false then exit;
        end;

        Cust.CheckBlockedCustOnJnls(Cust, Cust.Status, false);
        UpdateDescription(Cust.Name);
        "Payroll/Staff No." := Cust."Payroll/Staff No.";
        "ID No." := Cust."ID No.";
        "Group Code" := Cust."Group Account No.";
        "Employer Code" := Cust."Employer Code";
        "Mobile Phone No." := Cust."Mobile Phone No";
        "Contract End Date" := Cust."Contract End Date";
        Membercategory.Reset();
        Membercategory.SetRange("No.", Cust."Member Category");
        if Membercategory.FindFirst() then begin
            "Terms of Employment" := Membercategory."Terms of Service";
        end;

        if Cust."ID No." <> '' then begin
            HighRiskCust.Reset();
            HighRiskCust.SetRange("No.", Cust."ID No.");
            if HighRiskCust.FindFirst() then begin
                Idemnity := true;
            end
        end;

        if GeneralSetUp."Nofity Guarantors" then
            Cust.TestField("Mobile Phone No");

        MonthlyContrib.Reset();
        MonthlyContrib.SetRange("Account No.", "Account No.");
        MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Deposit");
        if MonthlyContrib.Find('-') then
            "Shares Banding" := MonthlyContrib.Amount;
        "Shares Deposit" := RegMngt.GetOperationAccBalanceTxt(ProdtCategory::"Shares Deposit", Cust."No.", 2);
        "Savings Balance(LCY)" := RegMngt.GetOperationAccBalanceTxt(ProdtCategory::"Specialty Savings", Cust."No.", 1);

        "Total Balance" := RegMngt.getCustLoanBalance(0, "Account No.", 0);
        if RegMngt.GetOperationAcc(Accountcat::Savings, Cust."No.", 1) <> '' then
            "Disbursement Account No." := RegMngt.GetOperationAcc(Accountcat::Savings, Cust."No.", 1) else
            Error(LoanDisbAccountNotFound);

        if "Account No." <> '' then begin
            if "Self Guarantee" then begin

                CredAccount.SetRange("Member No.", "Account No.");
                CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Deposit");
                if CredAccount.FindFirst() then begin
                    GuarantDetail.SetRange("No.", "No.");
                    GuarantDetail.SetRange("Member No. (Loanee)", "Account No.");
                    GuarantDetail.SetRange("Account No.", CredAccount."No.");
                    if GuarantDetail.FindFirst() then begin
                        GuarantDetail.Delete();
                        "Self Guarantee" := false;
                    end;
                end;
            end
        end;
        PassDocumentNo;
        OnAfterAccountNoOnValidateGetCustomerAccount(Rec, Cust, CurrFieldNo);
    end;

    procedure UpdateFields(ProductFactory: Record "Product Factory")
    var
        LnAppCharges: Record "Loan Product Charges";
        ApplicationCharge: Record "Loan Application Charge";
        JnsLoanAc: Record "Credit Account";
        CustRecord: Record Member;
        OperationAc: Record "Account Banking";
        MembCategory: Record "Member Category";
        ErrorMembAgeTxt: Label 'Member due to retire before loan repayment is complete.';
        ErrorOnMissingAccTxt: Label 'Member does not %1 account attached to the appraisal of this loan';
        ErrorOnNoBalTxt: Label 'Member does not have %1 savings balance';
        ErrorMembRegistrationDateTxt: Label 'Member has not met the minimum threshhold of %1 to qualify for loan application.';
        CustBank: Record "Cust. Bank Account";
        Membercategory: Record "Member Category";
        ErrorOnMissingBankDetails: Label 'Customer have a corresponding bank account for payment';
    begin

        GeneralSetUp.Get();
        if ProductFactory.Get("Product Type") then begin

            if ProductFactory."Disbursement Destination" = ProductFactory."Disbursement Destination"::"Bank Account" then begin
                CustBank.Reset();
                CustBank.SetRange("Member No.", "Account No.");
                if not CustBank.Find('-') then
                    Error(ErrorOnMissingBankDetails);
            end;

            Rec.CalcFields("Total TopUp");
            CredMngt.CheckCustomerExistingProduct("Account No.", "Product Type", "Total TopUp", "No.");
            if "Application Type" <> "Application Type"::"Loan Restructure" then
                Installments := ProductFactory."Ordinary Default Intallments" else
                Installments := getMaxInstallmentPeriod(0);
            "Product Description" := ProductFactory.Description;
            "Interest Calculation Method" := ProductFactory."Interest Calculation Method";
            "Interest Rate" := ProductFactory."Interest Rate (Max.)";
            "Installment Period" := ProductFactory."Installment Period";
            "Disbursement Destination" := ProductFactory."Disbursement Destination";
            "Loan Payment Destination" := ProductFactory."Loan Payment Destination";
            "Repayment Frequency" := ProductFactory."Repayment Frequency";
            "Recovery Mode" := ProductFactory."Repayment Mode";
            "Repayment Mode" := ProductFactory."Repayment Mode";
            "Charges Options" := ProductFactory."Charges Options";

            if "Repayment Mode" = "Repayment Mode"::Dividend then begin
                Validate("Repayment Frequency");
            end;

            "Appraisal Parameter Type" := ProductFactory."Appraisal Parameter Type";
            "Loan Span" := ProductFactory."Loan Span";
            "Deposits Appraisal Parameter" := ProductFactory."Deposits Appraisal Parameter";
            "Charge Interest on Posting" := ProductFactory."Charge Interest Due";
            "Ignore Related Balance" := ProductFactory."Ignore Related Balance";
            "Billing Type" := ProductFactory."Billing Type";
            "Exclude From Related Balance" := ProductFactory."Exclude Sacco Deduction";
            "Disbursement Destination" := ProductFactory."Disbursement Destination";
            "Loan Payment Destination" := ProductFactory."Loan Payment Destination";
            "Product Dimension" := ProductFactory."Product Dimension";

            case ProductFactory."Disbursement Destination" of
                ProductFactory."Disbursement Destination"::"Banking Account":
                    begin
                        "Payment Destination Code" := "Disbursement Account No.";
                        "Payment Destination" := "Disbursement Account No.";
                        "EFT Options" := "EFT Options"::"Bank Account";
                    end;
            end;

            if ProductFactory."Loan Span" = ProductFactory."Loan Span"::"Mobile Loan" then
                "EFT Options" := "EFT Options"::"Mobile Money";

            if CustRecord.Get("Account No.") then begin
                if "Application Type" <> "Application Type"::Defaulter then begin
                    CustRecord.TestField("Date of Birth");
                    GeneralSetUp.TestField("Max. Member Age");
                    if CustRecord."Date of Birth" <> 0D then begin
                        if CalcDate(GeneralSetUp."Max. Member Age", CustRecord."Date of Birth") >= Today then
                            "Billing Type" := "Billing Type"::Interest else
                            "Billing Type" := "Billing Type"::"Interest+Insurance";
                    end;
                end;
            end;

            case ProductFactory."Deposits Appraisal Parameter" of
                ProductFactory."Deposits Appraisal Parameter"::Account:
                    begin
                        OperationAc.Reset();
                        OperationAc.SetRange("Member No.", "Account No.");
                        OperationAc.SetRange("Product Type", ProductFactory."Product Type");
                        if OperationAc.FindFirst() then
                            OperationAc.CalcFields("Balance (LCY)");

                        if CheckBankingAccount("Account No.", OperationAc."Account Category") = '' then
                            Error(ErrorOnMissingAccTxt, OperationAc."Product Name");

                        if OperationAc."Balance (LCY)" <= 0 then
                            Error(ErrorOnNoBalTxt);
                    end;
            end;

            ProductFactory.TestField("Min. Re-application Period");

            CustRecord.TestField("Registration Date");
            if CalcDate(ProductFactory."Min. Re-application Period", CustRecord."Registration Date") > Today then
                Error(ErrorMembRegistrationDateTxt, ProductFactory."Min. Re-application Period");

            "Loan Account" := '';

            Credit.Reset;
            Credit.SetRange("Member No.", "Account No.");
            if GeneralSetUp."Loan Account Options" = GeneralSetUp."Loan Account Options"::Multiple then
                Credit.SetRange("Product Type", ProductFactory."Product ID");
            if Credit.Find('-') then begin
                "Loan Account" := Credit."No.";
            end else begin
                "Loan Account" := CredMngt.CreateLoanAccount("Account No.", ProductFactory."Product ID")
            end;

            if "Loan Account" <> '' then begin
                if "TopUp Loan" = '' then begin

                    case "Charges Options" of
                        "Charges Options"::Always:
                            DocMngt.fnInsertLoanCharge("No.", "Product Type", "Application Type");
                    end;

                end else begin
                    if GeneralSetUp."Post Topup Charges" then begin
                        DocMngt.fnInsertLoanCharge("No.", "Product Type", "Application Type");
                    end;
                end;
            end;
        end;
    end;

    local procedure UpdateDescription(Name: Text[100])
    begin
        VarVariant := Rec;
        if not IsAdHocDescription(VarVariant) then
            "Account Name" := Name;
    end;

    procedure CheckBankingAccount(MemberNo: Code[100]; Accountcategory: Enum ProductAccountCategory) Accno: Code[100]
    begin
        Accno := RegMngt.GetOperationAcc(Accountcategory, MemberNo, 1);
        exit(Accno)
    end;

    local procedure IsAdHocDescription(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
        Customer: Record Member;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Loan Application":
                begin
                    RecRef.SetTable(Rec);
                    if "Account Name" = '' then
                        exit(false);
                    if xRec."Account No." = '' then
                        exit(true);
                    exit(Customer.Get(xRec."Account No.") and (Customer.Name <> "Account Name"));
                    Variant := Rec;
                end;
            else
                exit(false);
        end
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record "Loan Application"; var Customer: Record Member; CallingFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateAccountNoOnAfterAssignValue(var GenJournalLine: Record "Loan Application"; var xGenJournalLine: Record "Loan Application")
    begin
    end;

    local procedure GetProductType()
    var
        ProdFact: Record "Product Factory";
        Cust: Record Member;
        PFact: Record "Product Factory";
        ProdtCategory: Enum ProductAccountCategory;
        ErrorOnMinShareBal: Label 'Member has shares less than Min. Balance of %1';
        ErrorOnMinPeriodTxt: Label 'Member has not achieved minimum loan application period of %1';
        AccType: Record "Product Factory";
        LoansTopUp: Record "Loans Top up";
    begin

        TestField("Account No.");
        Cust.Get("Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, Cust.Status, false);
        CheckCustExistingApplication();
        fnInitializeEntry();

        CalcFields("Total TopUp");

        ProdFact.Get("Product Type");
        ProdFact.TestField("Minimum Balance");
        ProdFact.TestField("Disbursement Destination");

        if ProdFact."Check Min. Balance On" <> '' then begin
            if AccType.Get(ProdFact."Check Min. Balance On") then begin
                case AccType."Account Dimension" of
                    AccType."Account Dimension"::Banking:
                        begin
                            if RegMngt.GetOperationAccBalanceTxt(AccType."Account Category", Cust."No.", 1) < ProdFact."Minimum Balance" then
                                Error(ErrorOnMinShareBal, ProdFact."Minimum Balance");
                        end;
                    AccType."Account Dimension"::Credit,
                    AccType."Account Dimension"::"Micro Credit":
                        begin

                            if RegMngt.GetOperationAccBalanceTxt(AccType."Account Category", Cust."No.", 2) < ProdFact."Minimum Balance" then
                                Error(ErrorOnMinShareBal, ProdFact."Minimum Balance");
                        end;
                end;
            end;
        end;

        if fncheckMinLoanApplicationPeriod(Cust."No.") then
            Error(ErrorOnMinPeriodTxt, ProdFact."Min. Re-application Period");

        ProdFact.fnCheckMinRequirements();
        ProdFact.CheckBlockedProdOnJnls(ProdFact, ProdFact.Status, false);
        ProdFact.CheckExistingProdApplicationsOnJnls("Product Type", "Account No.", "No.");
        UpdateFields(ProdFact);

        if "Product Type" <> '' then begin
            if CalcDate(GeneralSetUp."Max. Member Age", Cust."Date of Birth") <= Today then begin
                InsertSelfGuaranteedEntry("Product Type");
            end else begin
            end;
            if "Self Guarantee" then
                InsertSelfGuaranteedEntry("Product Type");
        end;

        if "Approved Amount" > 0 then
            Validate(Installments);
        PassDocumentNo;
        if Minute = '' then begin
            if PFact.Get("Product Type") then
                PFact.TestField(Minutes);

            "Minutes No. Series" := PFact.Minutes;
            if NoSeriesMgt.AreRelated(PFact.Minutes, xRec."Minutes No. Series") then
                "No. Series" := xRec."Minutes No. Series";
            "No." := NoSeriesMgt.GetNextNo("Minutes No. Series");
        end;
        OnAfterAccountNoOnValidateGetProduct(Rec, ProdFact, CurrFieldNo);
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeDocPostMgtLoanRegistration(var LoanLine: Record "Loan Application"; CallingFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetProduct(var GenJournalLine: Record "Loan Application"; var Customer: Record "Product Factory"; CallingFieldNo: Integer)
    begin
    end;

    local procedure UpdateRequestAmt()
    var
        ProdFac: Record "Product Factory";
        ErrorOnLoanAmountErrTxt: Label 'The loan amount applied is not within allowed margins of %1 and %2';
        ErrorNegatatedValue: Label 'Amount must be more than zero';
        CustRecord: Record Member;
        MemberCategory: Record "Member Category";
    begin
        TestField("Account No.");
        "Loan Status" := "Loan Status"::Application;
        if "Requested Amount" < 0 then Error(ErrorNegatatedValue);

        "Approved Amount" := "Requested Amount";
        "Recommended Amount" := "Requested Amount";
        "Amount to Disburse" := "Requested Amount";
        Validate("Approved Amount");
        "Application Date" := Today;

        if ProdFac.Get("Product Type") then begin
            ProdFac.fnCheckMinApprovalRequirements;
            Rec.TestField("Account No.");
            CustRecord.Get("Account No.");

            MemberCategory.SetRange("No.", CustRecord."Member Category");
            if MemberCategory.FindFirst() then begin

                case MemberCategory."Terms of Service" of
                    MemberCategory."Terms of Service"::Pensioner,
                    MemberCategory."Terms of Service"::Contract:
                        begin


                            if ("Requested Amount" > ProdFac."Maximum Loan Amount") or
                            ("Requested Amount" < ProdFac."Minimum Loan Amount") then
                                Error(ErrorOnLoanAmountErrTxt, ProdFac."Minimum Loan Amount",
                                ProdFac."Maximum Loan Amount");
                        end;
                end;
            end;
            Validate("Approved Amount");

        end;
    end;

    local procedure UpdateApprovedAmt()
    var
        ErrorOnApprovedAmtErrTxt: Label 'Approved Amount cannot be more than Requested amount';
        ErrorOnDiffAmounttxt: Label 'Approved Amount cannot be more than different of Max. loan amount less total loan balance';
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        InterestRate: Decimal;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        ShareBanding: Record "Shares Banding";
        BandingShare: Decimal;
        AccDredit: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        TempAmt: Decimal;
        FactProd: Record "Product Factory";
        CustRec: Record Member;
        TieredRates: Record "Interest Rates Banding";
        SettlementFee: Decimal;
        InsuranceFee: Decimal;
        TopUpFacility: Record "Loans Top up";
        TotalTopup: Decimal;
        Loan: Record Loans;
        TopupLoan: Record "Loans Top up";
        PostedFacility: Record Loans;
        TopUpRepayment: Decimal;
        Mcontrib: Decimal;
        TotalDeduct: Decimal;
        InstallPeriod: Integer;
        CollateralReg: Record "Collateral Register";
        GuarantPosted: Record "Loan Guarantors and Security";
        HrDate: Codeunit "Date Conversion";
        BLoanDedudct: Decimal;
        LoansTopUp: Record "Loans Top up";

        Text006: Label 'The value exceeds the maximum installments of %1';
    begin

        TotalMRepay := 0;
        LPrincipal := 0;
        LInterest := 0;
        SettlementFee := 0;
        InsuranceFee := 0;
        TotalTopup := 0;
        InstallPeriod := 0;
        BLoanDedudct := 0;
        TestField("Product Type");
        GeneralSetUp.Get();
        GeneralSetUp.TestField("Max. Member Age");

        if "Approved Amount" > 0 then begin
            CalcFields("Total TopUp");

            if "Total TopUp" = 0 then begin
                if "Application Type" = "Application Type"::Normal then
                    CheckCustExistingfacility();
            end;

            if "Total TopUp" > 0 then begin

                LoansTopUp.Reset();
                LoansTopUp.SetRange("No.", "No.");
                LoansTopUp.SetRange("Account No.", "Account No.");
                LoansTopUp.SetRange("Product Type", "Product Type");
                if not LoansTopUp.Find('-') then
                    if "Application Type" = "Application Type"::Normal then
                        CheckCustExistingfacility();
            end;

            if FactProd.Get("Product Type") then begin

                FactProd.TestField("Maximum Loan Amount");
                if "Approved Amount" > FactProd."Maximum Loan Amount" then
                    Error(ErrorOnDiffAmounttxt);

                if FactProd."Deposits Appraisal Parameter" <> FactProd."Deposits Appraisal Parameter"::Collateral then begin

                    case FactProd."Installment Charge Option" of
                        FactProd."Installment Charge Option"::Tiered:
                            begin
                                TieredRates.Reset();
                                TieredRates.SetRange("Product ID", FactProd."Product ID");
                                TieredRates.SetRange("Tier Type", TieredRates."Tier Type"::Installment);
                                if TieredRates.Find('-') then begin
                                    repeat
                                        if ("Approved Amount" >= TieredRates."Min. Limit") and ("Approved Amount" <= TieredRates."Max. Limit") then begin
                                            InstallPeriod := TieredRates.Installment;
                                            "Tiered Installment (Default)" := TieredRates.Installment;
                                        end;
                                    until TieredRates.Next() = 0;
                                end;
                            end else begin
                            InstallPeriod := FactProd."Ordinary Default Intallments"
                        end;
                    end;
                end else begin

                    if Rec."Product Type" = 'A117' then begin

                        GuarantPosted.Reset();
                        GuarantPosted.SetRange("No.", "No.");
                        GuarantPosted.SetRange("Member No. (Loanee)", "Account No.");
                        GuarantPosted.SetRange("Security Type", GuarantPosted."Security Type"::Collateral);
                        if GuarantPosted.FindFirst() then begin

                            CollateralReg.Reset();
                            CollateralReg.SetRange("Account No.", Rec."Account No.");
                            CollateralReg.SetRange("No.", GuarantPosted."Collateral Reg. No.");
                            CollateralReg.SetRange("Inward/Outward", CollateralReg."Inward/Outward"::"In-Store");
                            CollateralReg.SetRange("Approval Status", CollateralReg."Approval Status"::Approved);
                            if CollateralReg.FindLast() then begin
                                CollateralReg.TestField("Year of Manufacture");
                                if CollateralReg."Year of Manufacture" <> 0D then
                                    InstallP := HrDate.DetermineAgeInYears(CollateralReg."Year of Manufacture", Today);

                                TieredRecords.Reset();
                                TieredRecords.SetRange("Product ID", FactProd."Product ID");
                                TieredRecords.SetRange("Tier Type", TieredRecords."Tier Type"::Installment);
                                if TieredRecords.FindSet() then begin
                                    repeat
                                        if (InstallP >= TieredRecords."Lower Period") and (InstallP <= TieredRecords."Upper Period") then begin
                                            InstallPeriod := TieredRecords.Installment
                                        end;
                                    until TieredRecords.Next() = 0;
                                end;
                            end;
                        end;
                    end else begin
                        InstallPeriod := FactProd."Ordinary Default Intallments"
                    end;
                end;
            end;

            if InstallPeriod >= getMaxInstallmentPeriod(InstallPeriod) then
                InstallPeriod := getMaxInstallmentPeriod(InstallPeriod);

            if Installments >= InstallPeriod then
                Installments := InstallPeriod else
                Installments := Installments;

            if "Approved Amount" > "Requested Amount" then
                Error(ErrorOnApprovedAmtErrTxt);

            "Amount to Disburse" := "Approved Amount";
            LoanAmount := "Approved Amount";
            LBalance := "Approved Amount";

            TestField(Installments);

            InterestRate := "Interest Rate";
            RepayPeriod := Installments;
            CalcFields("Total TopUp");

            if CustRec.Get("Account No.") then
                if "Application Type" <> "Application Type"::Defaulter then
                    CustRec.TestField("Date of Birth");

            case "Interest Calculation Method" of
                "Interest Calculation Method"::Amortised:
                    begin

                        TestField("Interest Rate");
                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 -
                        Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount));
                        LInterest := Round(LBalance * InterestRate / 12 / 100);
                        LPrincipal := (TotalMRepay - LInterest);
                        Repayment := (LPrincipal + LInterest + InsuranceFee);
                        "Principle Repayment" := LPrincipal;
                        "Interest Repayment" := LInterest;
                    end;
                "Interest Calculation Method"::"Straight Line":
                    begin

                        TestField("Interest Rate");
                        LPrincipal := Round(LoanAmount / RepayPeriod, 1, '=');
                        LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '=');
                        "Principle Repayment" := LPrincipal;
                        "Interest Repayment" := LInterest;
                        Repayment := Round((LPrincipal + LInterest + InsuranceFee), 1, '=');

                    end;
                "Interest Calculation Method"::"Reducing Balance":
                    begin

                        TestField("Interest Rate");
                        LPrincipal := LoanAmount / RepayPeriod;
                        LInterest := (InterestRate / 12 / 100) * LBalance;
                        Repayment := Round((LPrincipal + LInterest + InsuranceFee), 1, '=');
                        "Principle Repayment" := LPrincipal;
                        "Interest Repayment" := LInterest;

                    end;
                "Interest Calculation Method"::"Reducing Flat":
                    begin

                        TestField("Interest Rate");
                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                        LInterest := Round(("Approved Amount" * 0.6) * (Installments + 1) / (Installments * 100), 1, '=');
                        Repayment := Round((LPrincipal + LInterest + InsuranceFee), 1, '=');
                        "Principle Repayment" := LPrincipal;
                        "Interest Repayment" := LInterest;

                    end;
                "Interest Calculation Method"::"Zero Interest":
                    begin
                        LPrincipal := Round(LoanAmount / RepayPeriod);
                        "Principle Repayment" := LPrincipal;
                        Repayment := Round((LPrincipal + InsuranceFee), 1, '=');
                    end
            end;

            PostedLoan.Reset();
            PostedLoan.SetCurrentKey("Approved Amount");
            PostedLoan.Ascending(false);
            PostedLoan.SetFilter("Outstanding Balance", '>0');
            PostedLoan.SetRange("Account No.", "Account No.");
            PostedLoan.SetFilter("Deposits Appraisal Parameter", '<>%1', PostedLoan."Deposits Appraisal Parameter"::Collateral);
            if PostedLoan.Find('-') then begin
                PostedAmt := PostedLoan."Approved Amount";
                ShareBanding.Reset();
                if ShareBanding.Find('-') then begin
                    repeat
                        if (PostedAmt >= ShareBanding.Minimum) and (PostedAmt <= ShareBanding.Maximum) then begin
                            TempAmt := ShareBanding."Shares Amount";
                        end;
                    until ShareBanding.Next() = 0
                end;
            end;

            "Shares Banding" := TempAmt;

            if Rec."Product Type" = 'RS-ASSET' then begin
                if TempAmt = 0 then begin
                    AccDredit.Reset();
                    AccDredit.SetRange("Member No.", Rec."Account No.");
                    AccDredit.SetRange("Account Category", AccDredit."Account Category"::"Shares Deposit");
                    if AccDredit.FindFirst() then begin
                        if ProdFac.Get(AccDredit."Product Type") then
                            ProdFac.TestField("Minimum Contribution");
                        "Shares Banding" := ProdFac."Minimum Contribution";
                    end;
                end else begin
                    ShareBanding.Reset();
                    if ShareBanding.Find('-') then begin
                        repeat
                            if ("Approved Amount" >= ShareBanding.Minimum) and ("Approved Amount" <= ShareBanding.Maximum) then begin
                                BandingShare := ShareBanding."Shares Amount";
                            end;
                        until ShareBanding.Next() = 0
                    end;
                end;
            end else begin

                ShareBanding.Reset();
                if ShareBanding.Find('-') then begin
                    repeat
                        if ("Approved Amount" >= ShareBanding.Minimum) and ("Approved Amount" <= ShareBanding.Maximum) then begin
                            BandingShare := ShareBanding."Shares Amount";
                        end;
                    until ShareBanding.Next() = 0
                end;
            end;

            if BandingShare >= "Shares Banding" then
                "Shares Banding" := BandingShare else
                "Shares Banding" := "Shares Banding";

            AccDredit.Reset();
            AccDredit.SetRange("Member No.", "Account No.");
            AccDredit.SetRange("Account Category", AccDredit."Account Category"::"Shares Deposit");
            if AccDredit.FindFirst() then begin
                if AccDredit."Monthly Contribution" = 0 then begin
                    AccDredit."Monthly Contribution" := "Shares Banding";
                end else begin
                    if "Shares Banding" > AccDredit."Monthly Contribution" then
                        AccDredit."Monthly Contribution" := "Shares Banding";
                end;
                AccDredit.Modify(true)
            end;

            MonthlyContrib.Reset();
            MonthlyContrib.SetRange("Account No.", "Account No.");
            MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Deposit");
            if MonthlyContrib.FindFirst() then begin
                if MonthlyContrib.Amount = 0 then begin
                    MonthlyContrib.Amount := "Shares Banding";
                end else begin
                    if CustRec.Get("Account No.") then begin
                        if not CustRec."Allow Min. Banding" then begin
                            if "Shares Banding" > MonthlyContrib.Amount then
                                MonthlyContrib.Amount := "Shares Banding";
                        end;
                    end;
                end;
                MonthlyContrib.Modify(true)
            end;

            if "Approved Amount" > 0 then begin

                TopUpRepayment := 0;
                TotalDeduct := 0;
                Mcontrib := 0;

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "Account No.");
                MonthlyContrib.SetFilter(Type, '<>%1', MonthlyContrib.Type::" ");
                if MonthlyContrib.Find('-') then begin
                    MonthlyContrib.CalcSums(Amount);
                    Mcontrib := MonthlyContrib.Amount;
                end;

                if Rec."Total TopUp" > 0 then begin
                    TopupLoan.Reset();
                    TopupLoan.SetRange("No.", Rec."No.");
                    if TopupLoan.FindSet() then begin
                        TopupLoan.CalcSums("Monthly Repayment");
                        TopUpRepayment := TopupLoan."Monthly Repayment";
                    end;
                end else begin
                    TopUpRepayment := 0
                end;

                Loan.Reset;
                Loan.SetFilter("Outstanding Balance", '>0');
                Loan.SetRange("Account No.", Rec."Account No.");
                Loan.SetFilter("Product Type", '%1', 'A106');
                if Loan.Find('-') then begin
                    Loan.CalcFields("Outstanding Balance", "Outstanding Interest");
                    Loan.CalcSums(Repayment);
                    BLoanDedudct := (Loan.Repayment / 2);
                    MonthlyContrib.Reset();
                    MonthlyContrib.SetRange("Account No.", "Account No.");
                    MonthlyContrib.SetFilter("Application No.", Loan."No.");
                    if MonthlyContrib.Find('-') then begin
                        MonthlyContrib.Amount := BLoanDedudct;
                        MonthlyContrib.Modify(true)
                    end;
                end;

                Loan.Reset;
                Loan.SetRange("Account No.", Rec."Account No.");
                Loan.SetFilter("Product Type", '<>%1', 'A106');
                if Loan.Find('-') then begin
                    repeat
                        Loan.CalcFields("Outstanding Balance", "Outstanding Interest");
                        if Loan."Outstanding Balance" > 0 then begin
                            TotalDeduct := (TotalDeduct + Loan.Repayment);
                        end;
                    Until Loan.Next() = 0;
                end;
                "Sacco Deductions" := (TotalDeduct + Mcontrib + BLoanDedudct);
            end;

            if "Application Type" = "Application Type"::"Loan Calculator" then begin
                CredMngt.GenerateRepaymentSchedule(false, "No.", 0);
            end;

            if FactProd."Allow Share Boost" then begin
                "Account Dimension" := "Account Dimension"::Credit;

                AccDredit.Reset();
                AccDredit.SetRange("Member No.", Rec."Account No.");
                AccDredit.SetRange("Account Category", AccDredit."Account Category"::"Shares Deposit");
                if AccDredit.FindFirst() then begin
                    "Deposit Purchase Account" := AccDredit."No.";
                end;

                TestField("Deposit Purchase Account");
                FactProd.TestField("Deposit Multiplier");
                "Deposit Purchase" := RegMngt.fnCalculateShareBoost("Account No.", FactProd."Product ID", "Requested Amount");
            end;











        end;
    end;

    procedure fnValidateFrequencyRepay(Frequency: Enum RepaymentFrequency)
    var
        IntPeriod: Text;
    begin
        TestField(Installments);

        case "Repayment Frequency" of
            "Repayment Frequency"::Daily:
                begin
                    Evaluate("Installment Period", '1D');
                    IntPeriod := Format("Installment Period");
                end;
            "Repayment Frequency"::Monthly:
                begin
                    Evaluate("Installment Period", '1M');
                    IntPeriod := Format("Installment Period");
                end;
            "Repayment Frequency"::Weekly:
                begin
                    Evaluate("Installment Period", '1W');
                    IntPeriod := Format("Installment Period");
                end;
            "Repayment Frequency"::Quarterly:
                begin
                    Evaluate("Installment Period", '1Q');
                    IntPeriod := Format("Installment Period");
                end;
            "Repayment Frequency"::Yearly:
                begin
                    Evaluate("Installment Period", '1Y');
                    IntPeriod := Format("Installment Period");
                end
        end;
        case Frequency of

            Frequency::Daily:
                begin
                    if xRec.Installments < 12 then begin
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then
                            Validate(Installments, Round((Installments * 30.41), 1, '='))
                        else
                            if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then
                                Validate(Installments, Round((Installments * 7), 1, '='));
                    end;
                    if xRec.Installments >= 12 then begin
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then
                            Installments := Round((Installments * 30.41), 1, '=')
                        else
                            if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then
                                Validate(Installments, Round((Installments * 7), 1, '='))
                            else
                                if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then
                                    Validate(Installments, Round((Installments * 121.6), 1, '='))
                                else
                                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then
                                        Validate(Installments, Round((Installments * 30.41), 1, '='));
                    end
                end;

            Frequency::Weekly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then
                        Validate(Installments, Round((Installments / 7), 1, '<'));
                    if (Installments < 0) or (Installments < 0) then begin
                        Installments := 1;
                        Installments := 1;
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then
                        Installments := Round((Installments * 4.34), 1, '=')
                    else
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then
                            Installments := Round(((Installments * 4) * 4.34), 1, '=')
                        else
                            if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then
                                Validate(Installments, Round((Installments * 52.14), 1, '='));
                end;

            Frequency::Monthly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then
                        Validate(Installments, Round((Installments / 30.41), 1, '='));
                    if (Installments < 0) or (Installments < 0) then begin
                        Installments := 1;
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then
                        Validate(Installments, Round((Installments / 4.34), 1, '='))
                    else
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then
                            Validate(Installments, Round((Installments * 4), 1, '='))
                        else
                            if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then
                                Validate(Installments, Round((Installments / 12), 1, '='));
                end;

            Frequency::Quarterly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then
                        Validate(Installments, Round(((Installments * 365) / 3), 1, '='))
                    else
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then
                            Validate(Installments, Round(((Installments / 52.14) / 3), 1, '='))
                        else
                            if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then
                                Validate(Installments, Round((Installments / 3), 1, '='))
                            else
                                if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then
                                    Validate(Installments, Round((Installments * 3), 1, '='));
                end;

            Frequency::Yearly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then
                        Validate(Installments, Round((Installments / 365), 1, '='))
                    else
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then
                            Validate(Installments, Round((Installments / 52.14), 1, '='))
                        else
                            if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then
                                Validate(Installments, Round((Installments / 12), 1, '='))
                            else
                                if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then
                                    Validate(Installments, Round((Installments / 3), 1, '='));
                end;
        end
    end;

    procedure AttachCrmApplicationNo()
    var
        LoansApp: Record "Loan Application";
        CRMLoanApplication: Record "CRM Application";
        Err002: Label 'CRM application is already in use by Loan No. %1';
    begin
        LoansApp.Reset;
        LoansApp.SetRange("CRM Application No.", "CRM Application No.");
        if LoansApp.Find('-') then begin
            if "CRM Application No." <> '' then
                Error(Err002, LoansApp."No.");
        end;

        CRMLoanApplication.Reset;
        CRMLoanApplication.SetRange("No.", "CRM Application No.");
        if CRMLoanApplication.Find('-') then begin
            "CRM Captured By" := CRMLoanApplication."Captured By";
            Validate("Account No.", CRMLoanApplication."Member No.");
            Validate("Product Type", CRMLoanApplication."Product Type");
            Validate("Requested Amount", CRMLoanApplication."Requested Amount");
        end;
    end;

    procedure CheckMinRequirement()
    var
        ProdDact: Record "Product Factory";
        AccBanking: Record "Account Banking";

    begin

        TestField("Account No.");
        TestField("Product Type");
        TestField("Approved Amount");
        TestField("Loan Account");
        TestField(Installments);
        TestField(Remarks);
        TestField(Sectors);
        TestField("Sub Sectors");
        TestField("Purpose of Loan");
        TestField("Repayment Start Date");

        if "Disbursement Account No." = '' then begin
            AccBanking.Reset();
            AccBanking.SetRange("Member No.", "Account No.");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
            if AccBanking.FindFirst() then
                "Disbursement Account No." := AccBanking."No.";
            Modify(true)
        end;

        if "Application Type" = "Application Type"::Normal then begin
            CalcFields("Amount Guaranteed", "Total TopUp");
            if ProdDact.Get("Product Type") then begin

                if "Amount Guaranteed" < "Approved Amount" then
                    Error(ErrorOnAmtGuarantMoreThanAppAmtTxt);
            end;

            if ("Total TopUp" + "Deposit Purchase") > "Approved Amount" then
                Error(ErrorOnAmtGuarantMoreThanAppAmtTxt);
        end
    end;

    procedure ChargeUpfrontInterest(ChargeOption: Integer; InterestMethod: Integer): Decimal
    begin
        case ChargeOption of
            0:
                begin
                    exit
                end;
            1:
                begin

                end;
            2:
                begin

                end;
        end
    end;

    procedure CheckMinRequirementApprovals()
    var
        Agreement: Record "Loan Guarantors and Security";
        PFact: Record "Product Factory";
        ProdtCategory: Enum ProductAccountCategory;
        LoanGuarant: Record "Loan Guarantors and Security";
        LoanTopUp: Record "Loans Top up";
        ProdDact: Record "Product Factory";
        ErrorOnMinBalOnEftOption: Label 'Maximum amount for EFT Option %1 is %2. It cannot be %3';
    begin
        TestField("Account No.");
        RegMngt.GetOperationAccBalanceTxt(ProdtCategory::"Shares Deposit", "Account No.", 2);

        TestField(Remarks);
        if "Terms of Employment" = "Terms of Employment"::Contract then
            TestField("Contract End Date");

        TestField(Installments);
        TestField(Sectors);
        if "Application Type" = "Application Type"::Normal then begin
            TestField("Loan Payment Destination");
            TestField("Payment Destination");
            TestField("Payment Mode");
            TestField("Payment Destination Code");

            TestField("EFT Options");
            case "EFT Options" of
                "EFT Options"::"Mobile Money":
                    begin
                        TestField("Mobile Phone No.");
                        if "Amount to Disburse" > 50000 then
                            Error(ErrorOnMinBalOnEftOption, Rec."EFT Options",
                                   50000, Rec."Approved Amount");
                    end;
                "EFT Options"::"Money Wallet":
                    begin
                        TestField("Mobile Phone No.");
                        if "Amount to Disburse" > 15000 then
                            Error(ErrorOnMinBalOnEftOption, Rec."EFT Options",
                                  15000, Rec."Approved Amount");
                    end;
            end;
        end;

        TestField("Sub Sectors");
        TestField("Purpose of Loan");
        TestField("Loan Account");
        TestField("Product Type");
        TestField("Approved Amount");
        TestField("Repayment Start Date");
        TestField("Disbursement Account No.");
        TestField("Loan Status", Rec."Loan Status"::Appraisal);
        CalcFields("Amount Guaranteed", "Total TopUp");
        if ProdDact.Get("Product Type") then begin
            if ProdDact."Deposits Appraisal Parameter" = ProdDact."Deposits Appraisal Parameter"::Collateral then
                if "Amount Guaranteed" < "Approved Amount" then
                    Error(ErrorOnAmtGuarantMoreThanAppAmtTxt);
        end;

        if "Total TopUp" = 0 then begin
            if CheckAccountExistApplic("Product Type", "Account No.") then Error(ErrorOnExistingLoan);
        end;

        if ("Total TopUp" + "Deposit Purchase"+"Total Liquidation") > "Approved Amount" then
            Error(ErrorOnAmtGuarantMoreThanAppAmtTxt);

        if "Loan Status" = "Loan Status"::Appraisal then begin
            if "Approved Amount" > "Recommended Amount" then
                Error('Approved Amount must not be more than the recommended amount');
        end;

        LoanGuarant.Reset();
        LoanGuarant.SetRange("No.", Rec."No.");
        if LoanGuarant.FindSet() then begin
            repeat
                if LoanGuarant."Member No." = Rec."Account No." then
                    "Self Guarantee" := true;
                Modify()
            until LoanGuarant.Next() = 0
        end else begin
            "Self Guarantee" := false;
            Modify(true)
        end;
        GeneralSetUp.Get();
        if not GeneralSetUp."Override Setup Control" then begin
            GeneralSetUp.TestField("Min No. of Guarantors");
            if GeneralSetUp."Guarantorship Option" = GeneralSetUp."Guarantorship Option"::Deposits then begin

                PFact.Get("Product Type");
                if not "Self Guarantee" then begin
                    if PFact."Deposits Appraisal Parameter" <> PFact."Deposits Appraisal Parameter"::Collateral then
                        if NoOfGuarantor("No.") < GeneralSetUp."Min No. of Guarantors" then
                            Error(ErrorOnLessNoOfGuarantorTxt, NoOfGuarantor("No."), GeneralSetUp."Min No. of Guarantors")
                end;
            end;
        end;
    end;

    procedure fnCheckOnExistingApplicationEntry(): Boolean
    var
        Loans: Record Loans;
    begin
        Loans.Reset;
        Loans.SetRange("Application No.", "No.");
        if Loans.Find('-') then begin
            exit(true)
        end else begin
            exit(false);
        end
    end;

    local procedure updateDepositPurchase()
    var
        ApplicationCharges: Record "Loan Application Charge";
        ChargeType: Enum ChargeType;
        CredtMngt: Record "Account Credit";
    begin

        if "Deposit Purchase" < 0 then
            Error('Amount cannot be less than zero');

        if "Deposit Purchase" > "Approved Amount" then
            "Deposit Purchase" := "Approved Amount" else
            "Deposit Purchase" := "Deposit Purchase";

        if "Deposit Purchase" > 0 then begin
            DocMngt.fnCreateTopUpCharge("No.", "Product Type", 0, ChargeType::Boosting);

            CredtMngt.Reset();
            CredtMngt.SetRange("Member No.", "Account No.");
            CredtMngt.SetRange("Account Category", CredtMngt."Account Category"::"Shares Capital");
            if CredtMngt.FindFirst() then begin
                if DocMngt.CustHasNotAttainedMinShares(CredtMngt."No.") then begin
                    Error(ErrorOnInvalidEntry);
                end;
            end;

        end else begin

            "Deposit Purchase Account" := '';
            ApplicationCharges.Reset;
            ApplicationCharges.SetRange("Application No.", "No.");
            ApplicationCharges.SetRange("Charge Type", ApplicationCharges."Charge Type"::Boosting);
            ApplicationCharges.DeleteAll();

        end
    end;

    local procedure getrepaymentStartDate(): Date
    var
        StartMonthDate: Date;
        CheckOffdate: Date;
        EndMonthDate: Date;
        MidCheckDate: Date;
    begin

        if ("Application Type" = "Application Type"::Mobile) or ("Repayment Mode" = "Repayment Mode"::Dividend) then begin
            if ProdFac.Get("Product Type") then
                ProdFac.TestField("Grace Period-Principle");
            CheckOffdate := CalcDate(ProdFac."Grace Period-Principle", "Disbursement Date");
            exit(CheckOffdate)
        end else begin

            GeneralSetUp.Get();
            GeneralSetUp.TestField("Checkoff Cutoff Days");
            StartMonthDate := CalcDate('-CM', "Disbursement Date");
            EndMonthDate := CalcDate('CM', "Disbursement Date");
            MidCheckDate := CalcDate(GeneralSetUp."Checkoff Cutoff Days", StartMonthDate);
            if "Disbursement Date" >= MidCheckDate then
                CheckOffdate := CalcDate('1M', EndMonthDate) else
                CheckOffdate := CalcDate('CM', "Disbursement Date");
            exit(CheckOffdate)
        end;
    end;

    procedure NoOfGuarantor(LoanNo: Code[20]): Integer
    var
        GuarantorSecurity: Record "Loan Guarantors and Security";
        NoOfGuarant: Integer;
    begin
        GuarantorSecurity.Reset;
        GuarantorSecurity.SetRange("No.", LoanNo);
        if GuarantorSecurity.FindSet then begin
            NoOfGuarant := GuarantorSecurity.Count;
            exit(NoOfGuarant);
        end
    end;

    local procedure fncheckMinLoanApplicationPeriod(CustomerNo: Code[100]): Boolean
    var
        CustRec: Record Member;
        HrDates: Codeunit "Date Conversion";
    begin

        GeneralSetUp.Get();
        if CustRec.Get("Account No.") then begin
            if CustRec."Registration Date" <> 0D then begin
                ProdFac.Get("Product Type");
                ProdFac.TestField("Min. Re-application Period");
                if CalcDate(ProdFac."Min. Re-application Period", CustRec."Registration Date") >= Today then
                    exit(true) else
                    exit(false);
            end;
        end;
    end;

    procedure getCustomerAge() MemberAge: Integer
    var
        HrDate: Codeunit "Date Conversion";
        CustMember: Record Member;
    begin
        if CustMember.Get(Rec."Account No.") then begin
            if CustMember."Date of Birth" <> 0D then
                MemberAge := HrDate.DetermineAgeInYears(CustMember."Date of Birth", Today) else
                MemberAge := 0;
        end;
        exit(MemberAge)
    end;

    procedure getCustYearToRetirement(PeriodInstallMent: Integer): Integer
    var
        HrDate: Codeunit "Date Conversion";
        CustMember: Record Member;
        YearToRetirement: Integer;
        YearToRetire: Integer;
        MembAge: Integer;
        MembCategory: Record "Member Category";
    begin
        YearToRetirement := 0;
        MembAge := 0;
        YearToRetire := 0;
        if CustMember.Get(Rec."Account No.") then begin
            if "Application Type" <> "Application Type"::Defaulter then begin
                CustMember.TestField("Date of Birth");
                CustMember.TestField("Member Category");
                CustMember.TestField("Terms of Employment");
            end;

            MembCategory.Reset();
            MembCategory.SetRange("No.", CustMember."Member Category");
            MembCategory.SetFilter("Terms of Service", '<>%1', MembCategory."Terms of Service"::Contract);
            if MembCategory.FindFirst() then begin
                if CalcDate(GeneralSetUp."Max. Member Age", CustMember."Date of Birth") >= Today then begin
                    MembAge := HrDate.DetermineAgeInMonths(CustMember."Date of Birth", Today);
                    if MembAge < 720 then begin
                        YearToRetirement := (720 - MembAge);
                        YearToRetire := YearToRetirement;
                        exit(YearToRetire)
                    end else begin
                        exit(0)
                    end;
                end;
            end else begin
                exit(0)
            end;
            exit(0)
        end;
    end;

    procedure getMaxLoanPeriodForContractCust(): Integer
    var
        HrDate: Codeunit "Date Conversion";
        CustMember: Record Member;
        YearToRetirement: Integer;
        YearToRetire: Integer;
        ContractPeriod: Integer;
        MembCategory: Record "Member Category";
    begin
        YearToRetirement := 0;
        ContractPeriod := 0;
        YearToRetire := 0;

        if CustMember.Get(Rec."Account No.") then begin
            MembCategory.SetRange("No.", CustMember."Member Category");
            MembCategory.SetFilter("Terms of Service", '%1', MembCategory."Terms of Service"::Contract);
            if MembCategory.FindFirst() then begin
                Rec.TestField("Contract End Date");
                if Rec."Contract End Date" <> 0D then
                    YearToRetire := Date2DMY(Rec."Contract End Date", 2) - Date2DMY(Today, 2)
                 + 12 * (Date2DMY(Rec."Contract End Date", 3) - Date2DMY(Today, 3));
            end;
            exit(YearToRetire)
        end;
    end;

    procedure InsertSelfGuaranteedEntry(ProductType: Code[10])
    var
        GuarantDetail: Record "Loan Guarantors and Security";
        Guarantor: Record "Loan Guarantors and Security";
        CredAcDetail: Record "Account Credit";
        BankingAc: Record "Account Banking";
        CollateralReg: Record "Collateral Register";
        ErrorOnExistingLoan: Label 'Member has an existing running loan. Kindly refinance before you can continue.';
        ErrorOnMissingCollateralTxt: Label 'No Collateral found attached to this Member account No. %2';
    begin
        ProdFac.Reset();
        ProdFac.SetRange("Product ID", ProductType);
        if ProdFac.FindFirst() then begin

            Guarantor.Reset();
            Guarantor.SetRange("No.", Rec."No.");
            if Guarantor.FindSet() then
                Guarantor.DeleteAll();

            case ProdFac."Deposits Appraisal Parameter" of
                ProdFac."Deposits Appraisal Parameter"::Dividends,
                ProdFac."Deposits Appraisal Parameter"::Business,
                ProdFac."Deposits Appraisal Parameter"::"Requested Amount",
                ProdFac."Deposits Appraisal Parameter"::"Guarantor+Salary",
                ProdFac."Deposits Appraisal Parameter"::"Security+Salary+Deposit",
                    ProdFac."Deposits Appraisal Parameter"::Deposits:
                    begin

                        CredAcDetail.SetRange("Member No.", "Account No.");
                        CredAcDetail.SetRange("Account Category", CredAcDetail."Account Category"::"Shares Deposit");
                        if CredAcDetail.FindFirst() then begin
                            GuarantDetail.Init();
                            GuarantDetail."No." := "No.";
                            GuarantDetail."Security Type" := GuarantDetail."Security Type"::Guarantor;
                            GuarantDetail.Validate("Account No.", CredAcDetail."No.");
                            GuarantDetail."Member No. (Loanee)" := "Account No.";
                            GuarantDetail.Insert(true);
                            "Self Guarantee" := true;
                        end;
                    end;
                ProdFac."Deposits Appraisal Parameter"::Collateral:
                    begin
                        InstallP := 0;

                        CollateralReg.Reset();
                        CollateralReg.SetRange("Account No.", Rec."Account No.");
                        CollateralReg.SetRange("Inward/Outward", CollateralReg."Inward/Outward"::"In-Store");
                        CollateralReg.SetRange("Approval Status", CollateralReg."Approval Status"::Approved);
                        if CollateralReg.FindLast() then begin
                            if CollateralReg."Collateral Type" = CollateralReg."Collateral Type"::"Motor Vehicle" then begin
                                CollateralReg.TestField("Year of Manufacture");
                                if CollateralReg."Year of Manufacture" <> 0D then
                                    InstallP := (Today - CollateralReg."Year of Manufacture");
                            end;

                            GuarantDetail.Init();
                            GuarantDetail."No." := "No.";
                            GuarantDetail."Security Type" := GuarantDetail."Security Type"::Collateral;
                            GuarantDetail."Member No. (Loanee)" := "Account No.";
                            GuarantDetail.Validate("Account No.", CollateralReg."Account No.");
                            GuarantDetail.Validate("Collateral Reg. No.", CollateralReg."No.");
                            GuarantDetail.Insert(true);

                            TieredRecords.Reset();
                            TieredRecords.SetRange("Product ID", Rec."Product Type");
                            TieredRecords.SetRange("Tier Type", TieredRecords."Tier Type"::Installment);
                            if TieredRecords.FindSet() then begin
                                repeat
                                    if (InstallP >= TieredRecords."Lower Period") and (InstallP <= TieredRecords."Upper Period") then begin
                                        Installments := TieredRecords.Installment
                                    end;
                                until TieredRecords.Next() = 0;
                            end;

                            "Self Guarantee" := true;
                        end else begin
                            Error(ErrorOnMissingCollateralTxt, "Account Name");
                        end;
                    end;
                ProdFac."Deposits Appraisal Parameter"::Account:
                    begin

                        BankingAc.Reset();
                        BankingAc.SetRange("Member No.", "Account No.");
                        BankingAc.SetRange("Account Category", BankingAc."Account Category"::"Specialty Savings");
                        if BankingAc.FindFirst() then begin
                            GuarantDetail.Init();
                            GuarantDetail."No." := "No.";
                            GuarantDetail."Security Type" := GuarantDetail."Security Type"::Lien;
                            GuarantDetail.Validate("Account No.", BankingAc."No.");
                            GuarantDetail."Member No. (Loanee)" := "Account No.";
                            GuarantDetail.Insert(true);
                            "Self Guarantee" := true;
                        end;
                    end;
            end
        end
    end;

    procedure MngtMinShareBalance(AcNo: Code[100]; ProdID: Code[20]; ValuePost: Integer)
    ApprovalMngt: Codeunit "Approval Mgmt.";
    var
        CustAccount: Record "Account Credit";
        AccBanking: Record "Account Banking";
    begin
        ProdFac.Get(ProdID);
        case ProdFac."Account Dimension" of
            ProdFac."Account Dimension"::Banking:
                begin
                    if RegMngt.GetOperationAccBalanceTxt(ProdFac."Account Category", AcNo, 1) < ProdFac."Minimum Balance" then
                        Error('Member has not attained Min. Shares of %1', ProdFac."Minimum Balance");

                end;
            ProdFac."Account Dimension"::Credit,
            ProdFac."Account Dimension"::"Micro Credit":
                begin

                    if RegMngt.GetOperationAccBalanceTxt(ProdFac."Account Category", AcNo, 2) < ProdFac."Minimum Balance" then
                        Error('Member has not attained Min. Shares of %1', ProdFac."Minimum Balance");
                end;
        end;

    end;

    procedure CheckCustExistingApplication()
    var
        ErrorOnExistingLoanApplicationTxt: Label 'Member already has an existing %1 application: %2 - %3.';
        LoanApp: Record "Loan Application";
    begin

        LoanApp.Reset();
        LoanApp.SetRange("Account No.", Rec."Account No.");
        LoanApp.SetRange("Product Type", Rec."Product Type");
        LoanApp.SetRange("Application Type", LoanApp."Application Type"::Normal);
        LoanApp.SetFilter("Approval Status", '%1|%2|%3', LoanApp."Approval Status"::Open,
        LoanApp."Approval Status"::"Pending Approval", LoanApp."Approval Status"::Approved);
        if LoanApp.Find('-') then begin
            if LoanApp."No." <> Rec."No." then
                Error(ErrorOnExistingLoanApplicationTxt, LoanApp."Product Description", "Loan Account", LoanApp."No.");
        end;
    end;

    procedure CheckCustExistingfacility()
    var
        ErrorOnExistingLoanApplicationTxt: Label 'Member already has an existing outstanding facility running. Kindly Revolve and continue. %1 loan: %2 - %3.';
        LoanApp: Record Loans;
    begin
        LoanApp.CalcFields("Total TopUp");
        if "Total TopUp" <= 0 then begin
            LoanApp.Reset();
            LoanApp.SetRange("Account No.", Rec."Account No.");
            LoanApp.SetRange("Product Type", Rec."Product Type");
            LoanApp.SetFilter("Outstanding Balance", '>0');
            if LoanApp.Find('-') then begin
                LoanApp.CalcFields("Outstanding Balance");
                Error(ErrorOnExistingLoanApplicationTxt, LoanApp."Product Description", "Loan Account", LoanApp."No.");
            end;
        end

    end;

    procedure getMaxInstallmentPeriod(PeriodTxt: Integer): Integer
    var
        CustRecord: Record Member;
        MembCategory: Record "Member Category";
        ProductFactory: Record "Product Factory";
        PeriodInstall: Integer;
        MembSegment: Record "Segment/County/Dividend/Signat";
    begin
        Rec.TestField("Account No.");
        ProductFactory.Get("Product Type");
        GeneralSetUp.Get();
        GeneralSetUp.TestField("Max. Retirement Age");

        case PeriodTxt of
            0:
                begin
                    if CustRecord.Get("Account No.") then
                        CustRecord.TestField("Terms of Employment");
                    if "Application Type" <> "Application Type"::Defaulter then begin
                        CustRecord.TestField("Date of Birth");
                        CustRecord.TestField("Member Category");
                        CustRecord.TestField("Member Segment");
                    end;

                    MembCategory.Reset();
                    MembCategory.SetRange("No.", CustRecord."Member Category");
                    if MembCategory.FindFirst() then begin
                        Case MembCategory."Terms of Service" of
                            MembCategory."Terms of Service"::Contract:
                                begin
                                    if getMaxLoanPeriodForContractCust() <= ProductFactory."Ordinary Default Intallments" then
                                        PeriodInstall := getMaxLoanPeriodForContractCust() else
                                        PeriodInstall := ProductFactory."Ordinary Default Intallments"
                                end else begin

                                if CalcDate(GeneralSetUp."Max. Retirement Age", CustRecord."Date of Birth") >= Today then begin

                                    MembSegment.Reset();
                                    MembSegment.SetRange(Code, CustRecord."Member Segment");
                                    MembSegment.SetRange(Type, MembSegment.Type::"Early Retirement");
                                    if MembSegment.FindFirst() then begin
                                        PeriodInstall := ProductFactory."Ordinary Default Intallments";

                                    end else begin
                                        if getCustYearToRetirement(0) > 0 then begin
                                            if getCustYearToRetirement(0) <= ProductFactory."Ordinary Default Intallments" then
                                                PeriodInstall := getCustYearToRetirement(0) else
                                                PeriodInstall := ProductFactory."Ordinary Default Intallments"
                                        end else begin
                                            PeriodInstall := ProductFactory."Ordinary Default Intallments"
                                        end;
                                    end;

                                end else begin
                                    PeriodInstall := ProductFactory."Ordinary Default Intallments";
                                end;
                            end;
                        End;
                    end else begin
                        Error('Member Category not found');
                    end;

                end else begin

                if CustRecord.Get("Account No.") then
                    MembCategory.SetRange("No.", CustRecord."Member Category");
                if MembCategory.FindFirst() then begin
                    Case MembCategory."Terms of Service" of
                        MembCategory."Terms of Service"::Contract:
                            begin

                                if getMaxLoanPeriodForContractCust() <= PeriodTxt then
                                    PeriodInstall := getMaxLoanPeriodForContractCust() else
                                    PeriodInstall := PeriodTxt

                            end else begin

                            if CalcDate(GeneralSetUp."Max. Member Age", CustRecord."Date of Birth") >= Today then begin

                                MembSegment.Reset();
                                MembSegment.SetRange(Code, CustRecord."Member Segment");
                                MembSegment.SetRange(Type, MembSegment.Type::"Early Retirement");
                                if MembSegment.FindFirst() then begin
                                    PeriodInstall := PeriodTxt

                                end else begin

                                    if getCustYearToRetirement(0) > 0 then begin
                                        if getCustYearToRetirement(0) <= PeriodTxt then
                                            PeriodInstall := getCustYearToRetirement(0) else
                                            PeriodInstall := PeriodTxt

                                    end else begin

                                        PeriodInstall := PeriodTxt
                                    end;
                                end;
                            end else begin
                                PeriodInstall := PeriodTxt
                            end;
                        end;
                    End;
                end;
            end;
        end;
        exit(PeriodInstall)
    end;

    procedure CheckMinReqOnExternalComms()
    begin

        OtherCommitment.Reset();
        OtherCommitment.SetRange("Application No.", "No.");
        if OtherCommitment.Find('-') then begin
            repeat
                OtherCommitment.TestField("External Account Name");
                OtherCommitment.TestField("EFT Options");
                OtherCommitment.TestField("Own Reference");
                OtherCommitment.TestField("Recipient Reference");
                OtherCommitment.TestField(Amount);
                Case OtherCommitment."EFT Options" of
                    OtherCommitment."EFT Options"::"Mobile Money",
                    OtherCommitment."EFT Options"::"Money Wallet":
                        begin
                            OtherCommitment.TestField("Mobile Phone No.");
                        end;
                    OtherCommitment."EFT Options"::"Bank Account":
                        begin
                            OtherCommitment.TestField("Branch Code");
                            OtherCommitment.TestField("External Account No.");
                            OtherCommitment.TestField("Payment Destination Code");
                        end;
                end;
            until OtherCommitment.Next() = 0;
        end
    end;

    var
        Accountcat: Enum ProductAccountCategory;
        TieredRecords: Record "Interest Rates Banding";
        DocMngt: Codeunit "Doc-PostMgt";
        InstallP: Integer;
        OtherCommitment: Record "Other Commitements Clearance";
        ErrorOnExistingLoan: Label 'Member has an existing running loan, Kindly refinance and continue.';

    procedure CheckAccountExistApplic(ProductType: Code[10]; MemberNo: code[10]): Boolean
    var
        LoanApp: Record Loans;
    begin
        if "TopUp Loan" = '' then begin

            LoanApp.Reset();
            LoanApp.SetRange("Account No.", MemberNo);
            LoanApp.SetRange("Product Type", ProductType);
            LoanApp.SetFilter("Outstanding Balance", '>0');
            if LoanApp.FindFirst() then begin
                LoanApp.CalcFields("Outstanding Balance");
                exit(true)
            end;
        end;
        exit(false)
    end;

    local procedure fnInitializeEntry()
    var
        ApplicationCharge: Record "Loan Application Charge";
    begin

        TestField("Account No.");
        "Approved Amount" := 0;
        "Approved Amount" := 0;
        Installments := 0;
        "Interest Rate" := 0;
        "Disbursement Account No." := '';
        "Loan Account" := '';
        "Recommended Amount" := 0;
        "Interest Repayment" := 0;
        "Principle Repayment" := 0;
        "Loan Status" := "Loan Status"::Application;
        "Charges Options" := "Charges Options"::"Ignore Charge";

        ApplicationCharge.Reset();
        ApplicationCharge.SetRange("Application No.", "No.");
        ApplicationCharge.DeleteAll();

    end;

    local procedure fnInitializeEntryAcc()
    begin

        "Product Type" := '';
        "Approved Amount" := 0;
        "Approved Amount" := 0;
        Installments := 0;
        "Interest Rate" := 0;
        "Disbursement Account No." := '';
        "Loan Account" := '';
        "Recommended Amount" := 0;
        "Interest Repayment" := 0;
        "Principle Repayment" := 0;
        "Loan Status" := "Loan Status"::Application;
        "Deposit Purchase" := 0;
        "Deposit Purchase Account" := '';
        "Account Dimension" := "Account Dimension"::" ";
    end;

    procedure CopyFromRecoveryLine(RecLine: Record "Loan Disbursement Lines")
    begin

        "Defaulted Loan No." := RecLine."Loan No.";
        Validate("Disbursement Date", Today);
        "Loan Status" := "Loan Status"::Issued;
        "Approval Status" := "Approval Status"::Posted;
    end;
}






