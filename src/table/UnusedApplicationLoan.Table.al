// Reconstructed from SmartSaver symbols. Original triggers/procedure bodies are unavailable.
table 50031 "Unused Application- Loan"
{
    Caption = 'Unused Application- Loan';
    DataClassification = SystemMetadata;
    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(50010; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class" = const(Loan),
                                                                  Status = const(Active));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Account No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "Interest Rate"; Decimal)
        {
            Editable = false;
            Caption = 'Interest Rate';
            DataClassification = CustomerContent;
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
        }
        field(50019; "Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
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
            TableRelation = "Account Banking"."No." Where("Account Category" = const(Savings), "Loan Disbursement Account" = filter(true), "Member No." = field("Account No."));
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
        }
        field(50046; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
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
        }
        field(50058; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
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
        }
        field(50062; "Self Guarantee"; Boolean)
        {
            Editable = false;
            Caption = 'Self Guarantee';
            DataClassification = CustomerContent;
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
        }
        field(50087; "Last Pay Date"; Date)
        {
            CalcFormula = max("Detailed Cust. Ledg. Entry"."Posting Date" where("Loan No." = field("No."), "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Last Pay Date';
        }
        field(50088; "Outstanding Interest"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Loan No." = field("No."), "Transaction Type" = filter("Interest Due" | "Interest Paid"), "Entry Type" = filter("Initial Entry"), "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Interest';
        }
        field(50089; "Outstanding Bill"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Loan No." = field("No."), "Transaction Type" = filter("Penalty Due" | "Penalty Paid"), "Entry Type" = filter("Initial Entry"), "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Bill';
        }
        field(50090; "Outstanding Insurance"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Loan No." = field("No."), "Transaction Type" = filter("Insurance Due" | "Insurance Paid"), "Entry Type" = filter("Initial Entry"), "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Insurance';
        }
        field(50091; "Outstanding Principal"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Loan No." = field("No."), "Transaction Type" = filter(Loan | Repayment),
             "Entry Type" = filter("Initial Entry"), "Posting Date" = field("Date Filter")));
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
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Loan No." = field("No."), "Entry Type" = filter("Initial Entry"), "Posting Date" = field("Date Filter")));
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
            Editable = false;
            Caption = 'Interest Posting Date';
        }
        field(50097; "Recovery Mode"; Enum "LoanRecoverMode")
        {
            DataClassification = CustomerContent;
            Caption = 'Recovery Mode';
        }
        field(50098; "Accrued Interest"; Decimal)
        {
            Editable = false;
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
        }
        field(50118; "Payment Destination Code"; Code[100])
        {
            TableRelation = if ("Loan Payment Destination" = const("Bank Account")) "Cust. Bank Account".Code where("Member No." = field("Account No.")) else
            if ("Loan Payment Destination" = filter("Mobile Money" | "Fosa Account")) "Account Banking" where("Account Category" = const(Savings), "Member No." = field("Account No.")) else
            if ("Loan Payment Destination" = const(Supplier)) Vendor where("Account Type" = filter(<> Banking));
            DataClassification = CustomerContent;
            Caption = 'Pay Point';
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
            TableRelation = Loans where("Account No." = field("Account No."),
            "Product Type" = field("Product Type"), "Outstanding Balance" = filter(> 0));
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
        }
        field(50131; "Cheques Type"; Enum "ChequeType")
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque Type';
        }
        field(50132; "Last Pay Date(Interest)"; Date)
        {
            CalcFormula = max("Cust. Ledger Entry"."Posting Date" where("Loan No." = field("No."), "Posting Date" = field("Date Filter"), "Transaction Type" = filter("Interest Due"), Reversed = filter(false)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Last Pay Date(Interest)';
        }
        field(50133; "Performance Indicator"; Enum "LoanPerformanceIndicator")
        {
            DataClassification = CustomerContent;
            Caption = 'Performance Indicator';
        }
        field(50134; "Loan Age"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50135; "Days in Arrears"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50136; "Expected Repayment"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50137; "Amount In Arrears"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50138; "Account Status"; Enum "LoanAccountStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50139; "Schedule  Repayment"; Decimal)
        {
            CalcFormula = sum("Loan Repayment Schedule"."Monthly Repayment" where("No." = field("No."), "Repayment Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Schedule  Repayment';
        }
        field(50140; "Schedule Principal Payment"; Decimal)
        {
            CalcFormula = sum("Repayment Schedule"."Principal Repayment" where("No." = field("No."), "Repayment Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Schedule Principal Payment';
        }
        field(50141; "Schedule Interest"; Decimal)
        {
            CalcFormula = sum("Repayment Schedule"."Monthly Interest" where("No." = field("No."), "Repayment Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Schedule Interest';
        }
        field(50142; "Average Payment"; Decimal)
        {
            CalcFormula = Average("Repayment Schedule"."Principal Repayment" where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Average Payment';
        }
        field(50143; "Loan principal Schedule"; Decimal)
        {
            CalcFormula = Sum("Repayment Schedule"."Principal Repayment" where("Loan Application No." = field("No."), "Repayment Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Loan principal Schedule';
        }
        field(50144; "Amount Paid"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Loan No." = field("No."), "Amount (LCY)" = filter(< 0), "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Amount Paid';
        }
    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
}
