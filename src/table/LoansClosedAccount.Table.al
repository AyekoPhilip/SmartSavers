table 50029 "Loans-Closed Account"
{
    Caption = 'Loans-Closed Account';
    DataClassification = AccountData;


    fields
    {
        field(50009; "No."; Code[50])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

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
            TableRelation = "Product Factory"."Product ID" where("Product Class" = const(Loan),
                                                                  Status = const(Active));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                CustEmp: Record Customer;
                ProductFact: Record "Product Factory";
                PayShedule: Record "Schedule of Loan Payment";
            begin

            end;
        }
        field(50012; "Account No."; Code[20])
        {
            TableRelation = Member."No.";
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ObjCust: Record Member;
                ErrorMembAgeTxt: Label 'Member due to retire before loan repayment is complete. Do you wish to continue?';
                STermLoan: Record Loans;
                MaxLoan: Decimal;
                SalDetails: Record "Appraisal Salary Details";
            begin

            end;
        }
        field(50013; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

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

            end;
        }
        field(50016; "Account Name"; Text[150])
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

            end;
        }
        field(50019; "Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

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
            IF ("Disbursement Destination" = CONST("Bank Account")) "Bank Account"."No." WHERE(Blocked = CONST(false))
            ELSE
            IF ("Disbursement Destination" = CONST(Supplier)) Vendor."No." WHERE(Blocked = CONST(" "))
            ELSE
            IF ("Disbursement Destination" = CONST("Mobile Money")) "Account Banking"."No." WHERE(Status = CONST(Active), "Account Category" = CONST(Savings), Blocked = CONST(" "), "Mobile No." = FILTER(<> ''));
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
            begin
                CredMngt.OnValidateLoanStatusTxt("Approval Status", "Account No.",
                "Approved Amount", Repayment, "No.", "Disbursement Account No.",
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
        field(50049; "Loan Account"; Code[20])
        {
            Editable = false;
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
            TableRelation = Customer where("Account Type" = const(Employer));
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
            TableRelation = "Loan Disbursement Header"."No." WHERE("Approval Status" = FILTER(Open),
                                                                    Posted = CONST(false));
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
        field(50064; "Old Account No."; Code[100])
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
                                                           Created = CONST(false),
                                                           Case360_Docs = CONST(1),
                                                           "Approval Status" = FILTER(Open | Deffered));
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
                if "Deposit Purchase" > "Approved Amount" then
                    "Deposit Purchase" := "Approved Amount" else
                    "Deposit Purchase" := "Deposit Purchase";

                if "Deposit Purchase" > 0 then
                    "Deposit Purchase Account" := RegMngt.GetOperationAcc(Accountcat::"Shares Deposit", "Account No.", 2)
                else
                    "Deposit Purchase Account" := ''
            end;
        }
        field(50074; "Total TopUp"; Decimal)
        {
            CalcFormula = Sum("Loans Top up Posted"."Total Total Up" where("Loan No." = field("No."),
            "Account No." = field("Account No.")));
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
            CalcFormula = Sum("Guarantor & Security Posted"."Amount Guaranteed" WHERE("Loan No." = FIELD("No."),
                                                                                       "No." = FIELD("Application No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Amount Guaranteed';
        }
        field(50082; "Deposit Purchase Account"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Account Dimension" = filter(Credit | "Micro Credit")) "Account Credit"."No." WHERE("Member No." = FIELD("Account No."),
                                                          "Account Category" = FILTER("Shares Capital" | "Shares Deposit"),
                                                          Status = CONST(Active)) else
            if ("Account Dimension" = const(Banking)) "Account Banking" where("Member No." = FIELD("Account No."), Status = filter(Active | New | Dormant | Closed), "Account Category" = filter("Money Market" | "Specialty Savings" | "Women Savings"));
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
        field(50086; "Application No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Loan Application"."No.";
            Caption = 'Application No.';
        
            trigger OnValidate()
            begin
                fnValidateApplicationNo
            end;
        }
        field(50087; "Last Pay Date"; Date)
        {
            CalcFormula = max("Detailed Cust. Ledg. Entry"."Posting Date" where("Customer No." = field("Loan Account"), "Loan No." = field("No."), "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Last Pay Date';
        }
        field(50088; "Outstanding Interest"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Loan Account"), "Loan No." = field("No."), "Transaction Type" = filter("Interest Due" | "Interest Paid"), "Entry Type" = filter("Initial Entry")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Interest';
        }
        field(50089; "Outstanding Bill"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Loan Account"), "Loan No." = field("No."), "Transaction Type" = filter("Penalty Due" | "Penalty Paid"), "Entry Type" = filter("Initial Entry")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Bill';
        }
        field(50090; "Outstanding Insurance"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Loan Account"), "Loan No." = field("No."), "Transaction Type" = filter("Insurance Due" | "Insurance Paid")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Insurance';
        }
        field(50091; "Outstanding Principal"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Loan Account"), "Loan No." = field("No."), "Transaction Type" = filter(Loan | Repayment), "Entry Type" = filter("Initial Entry")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Principal';
        }
        field(50092; "Group Code"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Code';
        }
        field(50093; "Outstanding Balance"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Loan Account"), "Loan No." = field("No."), "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Balance';
        }
        field(50094; "Post Application As"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Generate Batch,Post Application';
            OptionMembers = " ","Generate Batch","Post Application";
            Caption = 'Post Application As';
        }
        field(50095; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Posted';
        }
        field(50096; "Interest Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Interest Posting Date';
        }
        field(50097; "Recovery Mode"; Enum "LoanRecoverMode")
        {
            DataClassification = CustomerContent;
            Caption = 'Recovery Mode';
        }
        field(50098; "Accrued Interest"; Decimal)
        {
            CalcFormula = Sum("Interest Line".Amount WHERE("Loan No." = FIELD("No."),
                                                            Posted = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Accrued Interest';
        }

        field(50099; "Deposits Appraisal Parameter"; Enum "DepositsAppraisalParameter")
        {
            DataClassification = CustomerContent;
            Caption = 'Security Appraisal Parameter';
            Editable = false;
        }
        field(50100; "Ignore Related Balance"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ignore Related Balance';
            Editable = false;
        }
        field(50101; "Minute No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50102; "Total Disbured"; Decimal)
        {
            CalcFormula = Sum("Partial Disbursement Schedule".Amount where("Loan No." = field("Application No."), Posted = const(true), "Suggested for Disbursement" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50103; "Amount to Post"; Decimal)
        {
            CalcFormula = Sum("Partial Disbursement Schedule".Amount where("Loan No." = field("No."),
                          "Suggested for Disbursement" = const(true),
                                   Posted = const(false), "Approval Status" = filter(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50104; "Exclude From Related Balance"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50105; "Topped Up Loan"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50106; "Interest Options"; Option)
        {
            OptionMembers = "Charge Interest","Suspend Interest";
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50107; "Interest Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50108; "Amount Deducted"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Amount Deducted(Remittance)';
        }
        field(50109; "Interest Defaulted"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50110; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50111; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50112; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(50113; "Interest Cycles"; Integer)
        {
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(50114; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
        field(50115; "Loan Payment Destination"; Enum "LoanPaymentDestination")
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Payment Destination';
        }
        field(50116; "Billing Type"; Enum "BillingType")
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Type';
        }
        field(50117; "Payment Destination"; Code[100])
        {
            TableRelation = if ("Loan Payment Destination" = const("Bank Account"))
            "Cust. Bank Account"."Bank Account No." where(Code = field("Payment Destination Code"),
            "Member No." = field("Account No.")) else
            if ("Loan Payment Destination" = filter("Mobile Money" | "Fosa Account"))
            "Account Banking" where("Account Category" = const(Savings), "Member No." = field("Account No."))
            else
            if ("Loan Payment Destination" = const(Supplier)) Vendor where("Account Type" = filter(<> Banking));
            DataClassification = CustomerContent;
            Caption = 'Payment Destination A/c';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50118; "Payment Destination Code"; Code[100])
        {
            TableRelation = if ("Loan Payment Destination" = const("Bank Account")) "Cust. Bank Account".Code where("Member No." = field("Account No.")) else
            if ("Loan Payment Destination" = filter("Mobile Money" | "Fosa Account")) "Account Banking" where("Account Category" = const(Savings), "Member No." = field("Account No.")) else
            if ("Loan Payment Destination" = const(Supplier)) Vendor where("Account Type" = filter(<> Banking));
            DataClassification = CustomerContent;
            Caption = 'Pay Point';
        
            trigger OnValidate()
            var
                AccBanking: Record "Account Banking";
            begin


            end;
        }
        field(50119; "EFT Options"; Enum "EFTPaymentOptions")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50120; "Total Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50121; "Total Amount Disbursed"; Decimal)
        {
            CalcFormula = Sum("Partial Disbursement Schedule".Amount where("Loan No." = field("No."),
                          "Suggested for Disbursement" = const(true),
                                   Posted = const(true), "Approval Status" = filter(Posted)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50122; "Settlement Fee"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50123; "Check Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50124; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(50125; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
            Caption = 'Member Category';
            DataClassification = CustomerContent;
        }
        field(50126; "TopUp Loan"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50127; "System Non-Created"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50128; "Payment Mode"; Enum "PaymentMode")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50129; "Recovery No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50130; "Cheque No"; Code[20])
        {
            TableRelation = if ("Cheques Type" = filter("Computer Check")) "Cheque Register"."Cheque No." where("Bank Account No." = field("Payment Destination"),
                                                                                                              Issued = const(false),
                                                                                                              Voided = const(false),
                                                                                                              Cancelled = const(false));
            DataClassification = CustomerContent;
            Caption = 'Cheque No.';
        
            trigger OnValidate()
            var
                ChequeRegister: Record "Cheque Register";
            begin


            end;
        }
        field(50131; "Cheques Type"; Enum "ChequeType")
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque Type';
        }
         field(50132; "Amount in Arrears"; Decimal)
        {

            DataClassification = CustomerContent;
            Caption = 'Amount in Arrears';
            Editable = false;
        }
        field(50133; "Months In arrears"; Integer)
        {

            DataClassification = CustomerContent;
            Caption = 'Months In Arrears';
            Editable = false;
        }

        field(50134; "Cheque Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Individual Cheque,Multiple Cheque';
            OptionMembers = " ","Individual Cheque","Multiple Cheque";
            Caption = 'Cheque Options';
            trigger OnValidate()
            var

            begin
                case "Cheque Option" of
                    "Cheque Option"::"Multiple Cheque":
                        begin
                            "Cheque No" := '';
                            "Cheques Type" := "Cheques Type"::" ";
                            "Payment Destination" := '';
                            "Payment Destination Code" := '';
                        end;
                    "Cheque Option"::"Individual Cheque":
                        begin
                            OtherCommitment.Reset();
                            OtherCommitment.SetRange("Loan No.", "No.");
                            OtherCommitment.DeleteAll();
                        end;
                end;


            end;
        }

        field(50135; "External Payment"; Decimal)
        {
            CalcFormula = Sum("Other Commitements Clearance".Amount where("Loan No." = field("No."), "Application No." = field("Application No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'External Payment';
        }
        field(50136; "Loan principal Schedule"; Decimal)
        {
            CalcFormula = Sum("Repayment Schedule"."Principal Repayment" where("Loan Application No." = field("No."), "Repayment Date" = field("Date Filter")));

            Editable = false;
            FieldClass = FlowField;
            Caption = 'Loan principal Schedule';
        }
        field(50137; "Total Schedule Repayment"; Decimal)
        {
            CalcFormula = Sum("Repayment Schedule"."Monthly Repayment" where("Loan Application No." = field("No."), "Repayment Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Schedule Repayment';
        }

    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
        key("key2"; "Disbursement Date")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin


    end;

    var
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        RegMngt: Codeunit "Register Management";
        VarVariant: Variant;
        GenjViewMngt: Codeunit "Gen.Jnl.+Preview";
        CredMngt: Codeunit "Credit Mgmt.";
        Credit: Record "Credit Account";
        InterestErrorTxt: Label 'Interest Rate is not within allowed range.';
        ProdFac: Record "Product Factory";
        GeneralSetUp: Record "General Set-Up";
        ErrorOnLoanStatus: Label 'Member has a loan that is defaulted.';

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Loans, "No.", FieldNumber, ShortcutDimCode);
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
        Temp: Record "User Setup";
        PostID: Code[100];
    begin
        PostID := '';
        if "Application Source"::Mobile = "Application Source"::Mobile then begin

            Temp.Reset();
            Temp.SetRange("Account Type", Temp."Account Type"::"Automated Posting");
            if Temp.FindFirst() then begin
                ExemptionsApprvl.Get(Temp."User ID");
                "Captured By" := Temp."User ID";
            end else begin
                ExemptionsApprvl.Get(UserId);
            end;
        end else begin
            ExemptionsApprvl.Get(UserId);
        end;
        ExemptionsApprvl.TestField("Responsibility Centre");
        ExemptionsApprvl.TestField("Global Dimension 1 Code");
        ExemptionsApprvl.TestField("Global Dimension 2 Code");
        "Responsibility Centre" := ExemptionsApprvl."Responsibility Centre";
        "Global Dimension 1 Code" := ExemptionsApprvl."Global Dimension 1 Code";
        "Global Dimension 2 Code" := ExemptionsApprvl."Global Dimension 2 Code";
        "Application Date" := Today;
    end;

    local procedure GetCustomerAccount()
    var
        Cust: Record Member;
        ProdtCategory: Enum ProductAccountCategory;
    begin
        GeneralSetUp.Get();
        if Cust.Get("Account No.") then begin
            UpdateDescription(Cust.Name);
            "Payroll/Staff No." := Cust."Payroll/Staff No.";
            "ID No." := Cust."ID No.";
            Gender := Cust.Gender;
            "Employer Code" := Cust."Employer Code";
            "Shares Deposit" := RegMngt.GetOperationAccBalanceTxt(prodtCategory::"Shares Deposit", Cust."No.", 2);
            case "Disbursement Destination" of
                "Disbursement Destination"::"Mobile Money",
                "Disbursement Destination"::"Banking Account":
                    begin
                        "Disbursement Account No." := RegMngt.GetOperationAcc(Accountcat::Savings, Cust."No.", 0);
                    end;
            end;
        end else begin
            if not GeneralSetUp."Override Setup Control" then
                Error('Member account found');
        end;

        PassDocumentNo;

    end;

    procedure UpdateFields(ProductFactory: Record "Product Factory")
    var
        AppCharges: Record "Loan Application Charge";
        CustRecord: Record Member;
    begin
        GeneralSetUp.Get();

        AppCharges.Reset;
        AppCharges.SetRange("Application No.", "No.");
        AppCharges.DeleteAll;

        "Product Description" := ProductFactory.Description;
        "Interest Calculation Method" := ProductFactory."Interest Calculation Method";
        "Appraisal Parameter Type" := ProductFactory."Appraisal Parameter Type";
        "Interest Rate" := ProductFactory."Interest Rate (Max.)";
        Installments := ProductFactory."Ordinary Default Intallments";
        "Disbursement Destination" := ProductFactory."Disbursement Destination";
        "Repayment Frequency" := ProductFactory."Repayment Frequency";
        "Repayment Mode" := ProductFactory."Repayment Mode";
        "Billing Type" := ProductFactory."Billing Type";
        "Recovery Mode" := ProductFactory."Repayment Mode";
        "Appraisal Parameter Type" := ProductFactory."Appraisal Parameter Type";
        "Installment Period" := ProductFactory."Installment Period";
        "Appraisal Parameter Type" := ProductFactory."Appraisal Parameter Type";
        "Disbursement Destination" := ProductFactory."Disbursement Destination";
        "Charge Interest on Posting" := ProductFactory."Charge Interest Due";
        "Loan Span" := ProductFactory."Loan Span";
        "Loan Payment Destination" := ProductFactory."Loan Payment Destination";
        "Disbursement Destination" := ProductFactory."Disbursement Destination";
        "Loan Payment Destination" := ProductFactory."Loan Payment Destination";
        if ProductFactory."Loan Span" = ProductFactory."Loan Span"::"Mobile Loan" then
            "EFT Options" := "EFT Options"::"Mobile Money";
        "Deposits Appraisal Parameter" := ProductFactory."Deposits Appraisal Parameter";
        "Ignore Related Balance" := ProductFactory."Ignore Related Balance";
        "Loan Account" := '';

        Credit.Reset;
        Credit.SetRange("Member No.", "Account No.");
        Credit.SetRange("Product Type", ProductFactory."Product ID");
        if Credit.Find('-') then begin
            "Loan Account" := Credit."No."
        end else begin
            "Loan Account" := CredMngt.CreateLoanAccount("Account No.", ProductFactory."Product ID")
        end
    end;

    local procedure UpdateDescription(Name: Text[100])
    begin
        VarVariant := Rec;
        if not IsAdHocDescription(VarVariant) then
            "Account Name" := Name;
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
    local procedure OnAfterAccountNoOnValidateGetCustomerAccount(var xLoan: Record Loans; var Customer: Record Member; CallingFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateAccountNoOnAfterAssignValue(var Loan: Record Loans; var XLoans: Record Loans)
    begin
    end;

    local procedure GetProductType()
    var
        ProdFact: Record "Product Factory";
        Cust: Record Member;
    begin
        TestField("Account No.");
        Cust.Get("Account No.");
        ProdFact.Get("Product Type");
        UpdateFields(ProdFact);
        if "Approved Amount" > 0 then
            Validate(Installments);
        PassDocumentNo;

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetProduct(var Loanx: Record Loans; var Customer: Record "Product Factory"; CallingFieldNo: Integer)
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeValidatePerformPostOnLoansPostMgt(var RecRef: Record Loans; CallingFieldNo: Integer)
    begin


    end;

    local procedure UpdateRequestAmt()
    var
        ProdFac: Record "Product Factory";
        ErrorOnLoanAmountErrTxt: Label 'The Loan amount applied is not within allowed margins of %1 and %2';
    begin
        TestField("Account No.");
        "Approved Amount" := "Requested Amount";
        "Recommended Amount" := "Requested Amount";
        "Amount to Disburse" := "Requested Amount";
        Validate("Approved Amount");
        "Application Date" := Today;
    end;

    local procedure UpdateApprovedAmt()
    var
        ErrorOnApprovedAmtErrTxt: Label 'Approved Amount cannot be more than Requested amount';
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        InterestRate: Decimal;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
    begin
        // if "Approved Amount" > "Requested Amount" then
        //    Error(ErrorOnApprovedAmtErrTxt);
        "Amount to Disburse" := "Approved Amount";
        if "Approved Amount" > 0 then begin

            "Total Charges" := GenjViewMngt.getLoanCharge("No.", "Approved Amount");

            TotalMRepay := 0;
            LPrincipal := 0;
            LInterest := 0;
            InterestRate := "Interest Rate";
            LoanAmount := "Approved Amount";
            RepayPeriod := Installments;
            LBalance := "Approved Amount";

            TestField(Installments);

            case "Interest Calculation Method" of
                "Interest Calculation Method"::Amortised:
                    begin
                        TestField("Interest Rate");
                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 -
                        Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 1, '>');
                        LInterest := Round(LBalance * InterestRate / 12 / 100, 0.01, '=');
                        LPrincipal := (TotalMRepay - LInterest);
                        Repayment := Round((LPrincipal + LInterest), 1, '=');
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
                        Repayment := Round((LPrincipal + LInterest), 1, '=');
                    end;
                "Interest Calculation Method"::"Reducing Balance":
                    begin
                        TestField("Interest Rate");
                        LPrincipal := LoanAmount / RepayPeriod;
                        LInterest := (InterestRate / 12 / 100) * LBalance;
                        Repayment := Round((LPrincipal + LInterest), 1, '=');
                        "Principle Repayment" := LPrincipal;
                        "Interest Repayment" := LInterest;
                    end;
                "Interest Calculation Method"::"Reducing Flat":
                    begin
                        TestField("Interest Rate");
                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                        LInterest := Round(("Approved Amount" * 0.6) * (Installments + 1) / (Installments * 100), 1, '=');
                        Repayment := Round((LPrincipal + LInterest), 1, '=');
                        "Principle Repayment" := LPrincipal;
                        "Interest Repayment" := LInterest;
                    end;
                "Interest Calculation Method"::"Zero Interest":
                    begin
                        LPrincipal := LoanAmount / RepayPeriod;
                        Repayment := Round(LPrincipal, 1, '=');
                    end
            end
        end
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
            Validate("Requested Amount", CRMLoanApplication."Requested Amount");
            Validate("Product Type", CRMLoanApplication."Product Type");
        end;
    end;


    procedure CopyFromLoanApplicationLine(LoanApplication: Record "Loan Application")
    begin

        "Repayment Frequency" := LoanApplication."Repayment Frequency";
        "Approval Date" := LoanApplication."Approval Date";
        "Product Description" := LoanApplication."Product Description";
        "Amount to Disburse" := LoanApplication."Amount to Disburse";
        "EFT Options" := LoanApplication."EFT Options";
        "Fully Disbursed" := LoanApplication."Fully Disbursed";
        "Group Code" := LoanApplication."Group Code";
        "Total Disbursed" := LoanApplication."Total Disbursed";
        Remarks := LoanApplication.Remarks;
        "Minute No." := LoanApplication.Minute;
        "Currency Code" := LoanApplication."Currency Code";
        "Repayment Start Date" := LoanApplication."Repayment Start Date";
        "Expected Date of Completion" := LoanApplication."Expected Date of Completion";
        "Approval Status" := LoanApplication."Approval Status";
        "Loan Rejection Reason" := LoanApplication."Loan Rejection Reason";
        "Recommended Amount" := LoanApplication."Recommended Amount";
        "Loan Span" := LoanApplication."Loan Span";
        "Billing Type" := LoanApplication."Billing Type";
        "Time Created" := LoanApplication."Time Created";
        "Disbursement Destination" := LoanApplication."Disbursement Destination";
        "Self Guarantee" := LoanApplication."Self Guarantee";
        "Appraisal Parameter Type" := LoanApplication."Appraisal Parameter Type";
        "Old Account No." := LoanApplication."Old Account No.";
        "Application Source" := LoanApplication."Application Source";
        "Purpose of Loan" := LoanApplication."Purpose of Loan";
        Validate("CRM Application No.", LoanApplication."CRM Application No.");
        "Charges & Commissions" := LoanApplication."Charges & Commissions";
        "Deposit Purchase" := LoanApplication."Deposit Purchase";
        "Loan Status" := LoanApplication."Loan Status";
        "Application Type" := LoanApplication."Application Type";
        "Shares Deposit" := LoanApplication."Shares Deposit";
        "Deposit Purchase Account" := LoanApplication."Deposit Purchase Account";
        Sectors := LoanApplication.Sectors;
        "Sub Sectors" := LoanApplication."Sub Sectors";
        "Recovery Mode" := LoanApplication."Recovery Mode";
        "Deposits Appraisal Parameter" := LoanApplication."Deposits Appraisal Parameter";
        "Ignore Related Balance" := LoanApplication."Ignore Related Balance";
        "Loan Payment Destination" := LoanApplication."Loan Payment Destination";
        "Payment Destination" := LoanApplication."Payment Destination";
        "Payment Destination Code" := LoanApplication."Payment Destination Code";
        "Mode of Disbursement" := LoanApplication."Mode of Disbursement";
        "Payment Mode" := LoanApplication."Payment Mode";
    end;

    procedure fnTestFields()
    begin
        TestField("Account No.");
        TestField("Product Type");
        TestField("Loan Account");
        TestField("Approved Amount");
        TestField("Cheques Type");
        TestField("Cheque No");
        TestField("Disbursement Date");
        TestField("Disbursement Account No.");
        if "TopUp Loan" = '' then
            TestField("Approval Status", "Approval Status"::Approved) else
            TestField("Approval Status", "Approval Status"::Posted);

    end;

    local procedure fnValidateApplicationNo()
    var
        LoanPosted: Record Loans;
        ErrorOnExistingApplicNo: Label 'Application No-%1 allready attached to Loan No.-%2.';
    begin
        LoanPosted.Reset;
        LoanPosted.SetRange("Application No.", "Application No.");
        if LoanPosted.Find('-') then begin
            if "Application No." <> '' then
                Error(ErrorOnExistingApplicNo,
              LoanPosted."Application No.", LoanPosted."No.");
        end
    end;

    local procedure getrepaymentStartDate(): Date
    var
        StartMonthDate: Date;
        CheckOffdate: Date;
        EndMonthDate: Date;
        MidCheckDate: Date;
    begin
        if ProdFac.Get("Product Type") then begin
            case ProdFac."Loan Span" of
                ProdFac."Loan Span"::"Mobile Loan",
                ProdFac."Loan Span"::Dividends:
                    begin

                        CheckOffdate := CalcDate('1M', "Disbursement Date");
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
        end;
    end;

    procedure OpenCustomerLedgerEntries(FilterOnDueEntries: Boolean)
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        DetailedCustLedgEntry.SetRange("Customer No.", "Loan Account");
        CopyFilter("Global Dimension 1 Filter", DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        CopyFilter("Global Dimension 2 Filter", DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        if FilterOnDueEntries and (GetFilter("Date Filter") <> '') then begin
            CopyFilter("Date Filter", DetailedCustLedgEntry."Initial Entry Due Date");
            DetailedCustLedgEntry.SetFilter("Posting Date", '<=%1', GetRangeMax("Date Filter"));
        end;
        CopyFilter("Currency Filter", DetailedCustLedgEntry."Currency Code");
        CustLedgerEntry.DrillDownOnEntries(DetailedCustLedgEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenCustomerLedgerEntries(var Customer: Record Loans; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; FilterOnDueEntries: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnRetrieveRecord(var RecRef: Record "Loans-Closed Account"; xRecRef: Record "Loans-Closed Account"; IsHandled: Boolean)
    begin
    end;

    procedure InsertSelfGuaranteedEntry(ProductType: Code[10]; AccountNo: Code[100]; RecNo: Code[100]; ApplicationNo: Code[100])
    var
        GuarantDetail: Record "Guarantor & Security Posted";
        Guarantor: Record "Guarantor & Security Posted";
        CredAcDetail: Record "Account Credit";
        BankingAc: Record "Account Banking";
        CollateralReg: Record "Collateral Register";
        ErrorOnMissingCollateralTxt: Label 'No Collateral found attached to this Member account No. %2';
    begin

        ProdFac.Reset();
        ProdFac.SetRange("Product ID", ProductType);
        if ProdFac.FindFirst() then begin

            Guarantor.Reset();
            Guarantor.SetRange("Loan No.", RecNo);
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
                        CredAcDetail.SetRange("Member No.", AccountNo);
                        CredAcDetail.SetRange("Account Category", CredAcDetail."Account Category"::"Shares Deposit");
                        if CredAcDetail.FindFirst() then begin
                            GuarantDetail.Init();
                            GuarantDetail."Loan No." := RecNo;
                            GuarantDetail."No." := ApplicationNo;
                            GuarantDetail.Validate("Account No.", CredAcDetail."No.");
                            GuarantDetail."Member No. (Loanee)" := AccountNo;
                            GuarantDetail."Security Type" := GuarantDetail."Security Type"::Guarantor;
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

    procedure FieldLength(VarVariant: Text; MinLength: Integer; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be less than %1 or more than %2 Characters.';
    begin
        if (StrLen(VarVariant) < MinLength) or (StrLen(VarVariant) > FldLength) then
            Error(FieldLengthError, MinLength, FldLength);
    end;

    local procedure TestNoSeries()
    var
        RecRef: Record Loans;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRef.Get(Rec."No.") then begin
                MembNoSeries.Get();
                NoSeriesMgt.TestManual(MembNoSeries."Loan Batch Nos");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record Loans; xRecRef: Record Loans; var IsHandled: Boolean)
    begin
    end;

    var
        Accountcat: Enum ProductAccountCategory;
        TieredRecords: Record "Interest Rates Banding";
        InstallP: Integer;
        OtherCommitment: Record "Other Commitements Clearance";
}
