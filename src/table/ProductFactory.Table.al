table 50351 "Product Factory"
{
    DrillDownPageID = "Product List";
    LookupPageID = "Product List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Product ID"; Code[20])
        {
            Caption = 'Product ID';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Description := UpperCase(Description)
            end;
        }
        field(50011; "Product Class"; Enum "ProductClass")
        {
            Caption = 'Product Class';
            DataClassification = CustomerContent;
        }
        field(50012; "Interest Rate (Min.)"; Decimal)
        {
            Caption = 'Interest Rate (Min.)';
            DataClassification = CustomerContent;
        }
        field(50013; "Interest Rate (Max.)"; Decimal)
        {
            Caption = 'Interest Rate (Max.)';
            DataClassification = CustomerContent;
        }
        field(50014; "Installment Period"; DateFormula)
        {
            Editable = false;
            Caption = 'Installment Period';
            DataClassification = CustomerContent;
        }
        field(50015; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Active,Blocked';
            OptionMembers = "Open","Pending Approval","Active","Blocked";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50016; "Currency"; Code[10])
        {
            TableRelation = Currency.Code;
            Caption = 'Currency';
            DataClassification = CustomerContent;
        }
        field(50017; "Fixed Loan Term"; Boolean)
        {
            Caption = 'Fixed Loan Term';
            DataClassification = CustomerContent;
        }
        field(50018; "Withdrawal Interval"; DateFormula)
        {
            Caption = 'Withdrawal Interval';
            DataClassification = CustomerContent;
        }
        field(50019; "Max. No. of Withdrawal"; Integer)
        {
            Caption = 'Max. No. of Withdrawal';
            DataClassification = CustomerContent;
        }
        field(50020; "Product Ownership"; Option)
        {
            OptionCaption = 'Individual,Joint,Group/Business,Corporate';
            OptionMembers = "Individual","Joint","Group/Business","Corporate";
            Caption = 'Product Ownership';
            DataClassification = CustomerContent;
        }
        field(50021; "Min. Customer Age"; DateFormula)
        {
            Caption = 'Min. Customer Age';
            DataClassification = CustomerContent;
        }
        field(50022; "Max.Customer Age"; DateFormula)
        {
            Caption = 'Max.Customer Age';
            DataClassification = CustomerContent;
        }
        field(50023; "Credit Limit (Overdraft)"; Decimal)
        {
            Caption = 'Credit Limit (Overdraft)';
            DataClassification = CustomerContent;
        }
        field(50024; "Minimum Balance"; Decimal)
        {
            Caption = 'Minimum Balance';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Text0001: Label 'Minimum balance cannot be less than zero.';
            begin
                if "Minimum Balance" < 0 then
                    Error(Text0001);
            end;
        }
        field(50025; "Automatic Overdraft"; Boolean)
        {
            Caption = 'Automatic Overdraft';
            DataClassification = CustomerContent;
        }
        field(50026; "Customer Segment"; Code[30])
        {
            Caption = 'Customer Segment';
            DataClassification = CustomerContent;
        }
        field(50027; "Minimum Contribution"; Decimal)
        {
            Caption = 'Minimum Contribution';
            DataClassification = CustomerContent;
        }
        field(50028; "Product Insured"; Boolean)
        {
            Caption = 'Product Insured';
            DataClassification = CustomerContent;
        }
        field(50029; "Account Minimum Balance(%)"; Decimal)
        {
            Caption = 'Account Minimum Balance(%)';
            DataClassification = CustomerContent;
        }
        field(50030; "Loan Account (G/L)"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
            Caption = 'Loan Account (G/L)';
            DataClassification = CustomerContent;
        }
        field(50031; "Interest Account (G/L)"; Code[15])
        {
            TableRelation = "G/L Account"."No." WHERE("Income/Balance" = CONST("Income Statement"));
            Caption = 'Interest Account (G/L)';
            DataClassification = CustomerContent;
        }
        field(50032; "Receivable Account (G/L)"; Code[15])
        {
            TableRelation = "G/L Account"."No." WHERE("Income/Balance" = CONST("Balance Sheet"));
            Caption = 'Receivable Account (G/L)';
            DataClassification = CustomerContent;
        }
        field(50033; "Use Cycle"; Boolean)
        {
            Caption = 'Use Cycle';
            DataClassification = CustomerContent;
        }
        field(50034; "Grace Period - Interest"; DateFormula)
        {
            Caption = 'Grace Period - Interest';
            DataClassification = CustomerContent;
        }
        field(50035; "Posting Group"; Code[10])
        {
            TableRelation = if ("Account Dimension" = filter(Credit | "Micro Credit" | Loan)) "Customer Posting Group" else
            if ("Account Dimension" = filter(Banking| Repayment)) "Vendor Posting Group";
            Caption = 'Posting Group';
            DataClassification = CustomerContent;
        }
        field(50036; "Closure Fee"; Code[10])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Early Exit"));
            Caption = 'Closure Fee Code';
            DataClassification = CustomerContent;
        }
        field(50037; "Dormancy Period"; DateFormula)
        {
            Caption = 'Dormancy Period';
            DataClassification = CustomerContent;
        }
        field(50038; "Account No. Prefix"; Code[10])
        {
            Caption = 'Account No. Prefix';
            DataClassification = CustomerContent;
        }
        field(50039; "Maximum Guarantors"; Integer)
        {
            Caption = 'Maximum Guarantors';
            DataClassification = CustomerContent;
        }
        field(50040; "Minimum Guarantors"; Integer)
        {
            Caption = 'Minimum Guarantors';
            DataClassification = CustomerContent;
        }
        field(50041; "Min. Re-application Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Min. Qualification Period (Loan)';
        }
        field(50042; "Minimum Loan Amount"; Decimal)
        {
            Caption = 'Minimum Loan Amount';
            DataClassification = CustomerContent;
        }
        field(50043; "Maximum Loan Amount"; Decimal)
        {
            Caption = 'Maximum Loan Amount';
            DataClassification = CustomerContent;
        }
        field(50044; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
        field(50045; "Interest Calculation Method"; Enum "InterestCalculationMethod")
        {
            Caption = 'Interest Calculation Method';
            DataClassification = CustomerContent;
        }
        field(50046; "Prefferential Installments"; Integer)
        {
            Caption = 'Prefferential Installments';
            DataClassification = CustomerContent;
        }
        field(50047; "Ordinary Default Intallments"; Integer)
        {
            Caption = 'Ordinary Default Intallments';
            DataClassification = CustomerContent;
        }
        field(50048; "Can Guarantee Loan"; Boolean)
        {
            Caption = 'Can Guarantee Loan';
            DataClassification = CustomerContent;
        }
        field(50049; "Loan Disbursement Account"; Boolean)
        {
            Caption = 'Loan Disbursement Account';
            DataClassification = CustomerContent;
        }
        field(50050; "Charge Closure Before Maturity"; Decimal)
        {
            Caption = 'Charge Closure Before Maturity';
            DataClassification = CustomerContent;
        }
        field(50051; "Earns Interest"; Boolean)
        {
            Caption = 'Earns Interest';
            DataClassification = CustomerContent;
        }
        field(50052; "Interest Expense Account"; Code[15])
        {
            TableRelation = "G/L Account";
            Caption = 'Interest Expense Account';
            DataClassification = CustomerContent;
        }
        field(50053; "Interest Payable Account"; Code[15])
        {
            TableRelation = "G/L Account";
            Caption = 'Interest Payable Account';
            DataClassification = CustomerContent;
        }
        field(50054; "External EFT Charges"; Decimal)
        {
            Caption = 'External EFT Charges';
            DataClassification = CustomerContent;
        }
        field(50055; "Interest Calc Min Balance"; Decimal)
        {
            Caption = 'Interest Calc Min Balance';
            DataClassification = CustomerContent;
        }
        field(50056; "Penalty Calculation Days"; DateFormula)
        {
            Caption = 'Penalty Calculation Days';
            DataClassification = CustomerContent;
        }
        field(50057; "Penalty Percentage"; Decimal)
        {
            Caption = 'Penalty Percentage';
            DataClassification = CustomerContent;
        }
        field(50058; "Penalty Calculation Method"; Option)
        {
            OptionMembers = "No Penalty","Principal in Arrears","Principal in Arrears+Interest in Arrears","Principal in Arrears+Interest in Arrears+Penalty in Arrears";
            Caption = 'Penalty Calculation Method';
            DataClassification = CustomerContent;
        }
        field(50059; "Penalty Paid Account"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
            Caption = 'Penalty Paid Account';
            DataClassification = CustomerContent;
        }
        field(50060; "Ordinary Deposits Multiplier"; Decimal)
        {
            Caption = 'Ordinary Deposits Multiplier';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Prefferential Installments" := "Ordinary Default Intallments"
            end;
        }
        field(50061; "Preferential Dep. Multiplier"; Decimal)
        {
            Caption = 'Preferential Dep. Multiplier';
            DataClassification = CustomerContent;
        }
        field(50062; "Allow Multiple Running Loans"; Boolean)
        {
            Caption = 'Allow Multiple Running Loans';
            DataClassification = CustomerContent;
        }
        field(50063; "Loan Security Inclination"; Option)
        {
            OptionCaption = ' ,Short Loan Security,Long Term Loan Security';
            OptionMembers = " ","Short Term Loan Security","Long Term Loan Security";
            Caption = 'Loan Security Inclination';
            DataClassification = CustomerContent;
        }
        field(50064; "Loan Span"; Enum "LoanSpan")
        {
            Caption = 'Loan Span';
            DataClassification = CustomerContent;
        }
        field(50065; "Recovery Priority"; Integer)
        {
            Caption = 'Recovery Priority';
            DataClassification = CustomerContent;
        }
        field(50066; "Membership Type"; Option)
        {
            OptionCaption = ',Ordinary,Preferential';
            OptionMembers = "","Ordinary","Preferential";
            Caption = 'Membership Type';
            DataClassification = CustomerContent;
        }
        field(50067; "Repayment Mode"; Enum "LoanRecoverMode")
        {
            Caption = 'Repayment Mode';
            DataClassification = CustomerContent;
        }
        field(50068; "Upfront Interest Options"; Option)
        {
            OptionCaption = ' ,Full Interest,Pro-rata';
            OptionMembers = " ","Full Interest","Pro-rata";
            Caption = 'Upfront Interest Options';
            DataClassification = CustomerContent;
        }
        field(50069; "Withholding Tax Account"; Code[15])
        {
            TableRelation = "G/L Account";
            Caption = 'Withholding Tax Account';
            DataClassification = CustomerContent;
        }
        field(50070; "WithHolding Tax"; Decimal)
        {
            Caption = 'WithHolding Tax';
            DataClassification = CustomerContent;
        }
        field(50071; "Penalty Due Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Penalty Due Account';
            DataClassification = CustomerContent;
        }
        field(50072; "Penalty Account Suspense"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Penalty Account Suspense';
            DataClassification = CustomerContent;
        }
        field(50073; "Auto Open Account"; Boolean)
        {
            Caption = 'Auto Open Account';
            DataClassification = CustomerContent;
        }
        field(50074; "Dividend Calc. Method"; Enum "DividendMethod")
        {
            Caption = 'Dividend Calc. Method';
            DataClassification = CustomerContent;
        }
        field(50075; "Allow Over Draft"; Boolean)
        {
            Caption = 'Allow Over Draft';
            DataClassification = CustomerContent;
        }
        field(50076; "Over Draft Interest (%)"; Decimal)
        {
            Caption = 'Over Draft Interest (%)';
            DataClassification = CustomerContent;
        }
        field(50077; "Over Draft Interest Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Over Draft Interest Account';
            DataClassification = CustomerContent;
        }
        field(50078; "Allow Multiple Over Draft"; Boolean)
        {
            Caption = 'Allow Multiple Over Draft';
            DataClassification = CustomerContent;
        }
        field(50079; "Search Code"; Code[20])
        {
            Caption = 'Search Code';
            DataClassification = CustomerContent;
        }
        field(50080; "Allow Multiple Accounts"; Boolean)
        {
            Caption = 'Allow Multiple Accounts';
            DataClassification = CustomerContent;
        }
        field(50081; "Maximum Deposit Contribution"; Decimal)
        {
            Caption = 'Maximum Deposit Contribution';
            DataClassification = CustomerContent;
        }
        field(50082; "Minimum Deposit Balance"; Decimal)
        {
            Caption = 'Minimum Deposit Balance';
            DataClassification = CustomerContent;
        }
        field(50083; "Type of Discounting"; Option)
        {
            OptionCaption = ' ,Loan Discounting,Invoice Discounting,Cheque Discounting';
            OptionMembers = " ","Loan Discounting","Invoice Discounting","Cheque Discounting";
            Caption = 'Type of Discounting';
            DataClassification = CustomerContent;
        }
        field(50084; "Suspend Interest Account (G/L)"; Code[15])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = FILTER(true));
            Caption = 'Suspend Interest Account (G/L)';
            DataClassification = CustomerContent;
        }
        field(50085; "Repayment Frequency"; Enum "RepaymentFrequency")
        {
            Caption = 'Repayment Frequency';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                fnValidateFrequencyRepay
            end;
        }
        field(50086; "Grace Period-Principle"; DateFormula)
        {
            Caption = 'Grace Period-Principle';
            DataClassification = CustomerContent;
        }
        field(50087; "Nature of Loan Type"; Option)
        {
            OptionCaption = ' ,Normal,Defaulter';
            OptionMembers = " ","Normal","Defaulter";
            Caption = 'Nature of Loan Type';
            DataClassification = CustomerContent;
        }
        field(50088; "Account No. Suffix"; Code[10])
        {
            Caption = 'Account No. Suffix';
            DataClassification = CustomerContent;
        }
        field(50089; "No. Of Months for Appr. Saving"; Integer)
        {
            Caption = 'No. Of Months for Appr. Saving';
            DataClassification = CustomerContent;
        }
        field(50090; "Loan Appraisal Income Acc."; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = FILTER(true));
            Caption = 'Loan Appraisal Income Acc.';
            DataClassification = CustomerContent;
        }
        field(50091; "Minimum Deposit Contribution"; Decimal)
        {
            Caption = 'Minimum Deposit Contribution';
            DataClassification = CustomerContent;
        }
        field(50092; "Savings Duration"; DateFormula)
        {
            Caption = 'Savings Duration';
            DataClassification = CustomerContent;
        }
        field(50093; "Savings Withdrawal penalty"; Decimal)
        {
            Caption = 'Savings Withdrawal penalty';
            DataClassification = CustomerContent;
        }
        field(50094; "Savings Penalty Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Savings Penalty Account';
            DataClassification = CustomerContent;
        }
        field(50095; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
            Caption = 'Member Category';
            DataClassification = CustomerContent;
        }
        field(50096; "Statement Charge"; Code[10])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST(Statement));
            Caption = 'Statement Charge';
            DataClassification = CustomerContent;
        }
        field(50097; "Source of Funds"; Option)
        {
            OptionMembers = "Internal Fund","External Fund";
            Caption = 'Source of Funds';
            DataClassification = CustomerContent;
        }
        field(50098; "Appraisal Parameter Type"; Enum "AppraisalParameter")
        {
            Caption = 'Appraisal Parameter Type';
            DataClassification = CustomerContent;
        }
        field(50099; "Allow Share Boost"; Boolean)
        {
            Caption = 'Allow Share Boost';
            DataClassification = CustomerContent;
        }
        field(50100; "Does not Require Batching"; Boolean)
        {
            Caption = 'Does not Require Batching';
            DataClassification = CustomerContent;
        }
        field(50101; "Grace Period-Interest"; DateFormula)
        {
            Caption = 'Grace Period-Interest';
            DataClassification = CustomerContent;
        }
        field(50102; "Deposits Appraisal Parameter"; Enum "DepositsAppraisalParameter")
        {
            DataClassification = CustomerContent;
            Caption = 'Security Appraisal Parameter';
        }
        field(50103; "Withdrawal Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Withdrawable,Non-withdrawable';
            OptionMembers = " ","Withdrawable","Non-withdrawable";
            Caption = 'Withdrawal Option';
        }
        field(50104; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(
                1, "Shortcut Dimension 1 Code");
            end;
        }

        field(50105; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(
                2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50106; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Set Entry";
        
            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID(
                "Dimension Set ID", "Shortcut Dimension 1 Code",
                "Shortcut Dimension 2 Code");
            end;
        }
        field(50107; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
        field(50108; "Disbursement Destination"; Enum "LoanDisbursementDestination")
        {
            DataClassification = CustomerContent;
            Caption = 'Disbursement Destination';
        }
        field(50109; "Account Validation"; Option)
        {
            Caption = 'Account Validation';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Photo Signature,Account Kin,Signatories';
            OptionMembers = " ","Photo Signature","Account Kin","Signatories";
        }
        field(50110; "Charge Subsiquent withdrawal"; Boolean)
        {
            Caption = 'Charge Subsiquent withdrawal';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50111; "Max. No.(Same Loans)"; Integer)
        {
            Caption = 'Max. No.(Same Loans)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50112; "Salary %"; Decimal)
        {
            Caption = 'Salary % (Net Take Home)';
            DataClassification = CustomerContent;
        }
        field(50113; "Appraise Based on Banking"; Boolean)
        {
            Caption = 'Appraise Based on Banking';
            DataClassification = CustomerContent;
        }
        field(50114; "Min. No (Signatory)"; Integer)
        {
            Caption = 'Min. No (Kin/Signatory)';
            DataClassification = CustomerContent;
        }
        field(50115; "Minutes"; Code[50])
        {
            Caption = 'Minute No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50116; "Ignore Related Balance"; Boolean)
        {
            Caption = 'Ignore Related Balance';
            DataClassification = CustomerContent;
        }
        field(50117; "Source Account"; Option)
        {
            Caption = 'Source Link Account';
            DataClassification = CustomerContent;
            OptionMembers = "Member","Non-Member";
        
            trigger OnValidate()
            begin
                if "Source Account" = "Source Account"::"Non-Member" then begin
                    Rec.TestField("Account Dimension", "Account Dimension"::Banking);
                end;

            end;
        }
        field(50118; "Deposit Multiplier"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50119; "Charge Interest Due"; Enum "ChargeInterestDue")
        {
            Caption = 'Charge Interest Due On Post';
            DataClassification = CustomerContent;
        }
        field(50120; "No. of Times Salary"; Integer)
        {
            Caption = 'Max. No. of Salary Processed';
            DataClassification = CustomerContent;
        }
        field(50121; "Exclude Sacco Deduction"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50122; "No. Series"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50123; "No. Serialization"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Manual","Automated";
            OptionCaption = 'Manual Serialization,Automated Serialization';
        }
        field(50124; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50125; "Responsibility Centre"; Code[20])
        {
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50126; "Interest Charge Option"; Option)
        {
            OptionMembers = " ","Flat Amount","Tiered";
            Caption = 'Interest Charge Option';
            DataClassification = CustomerContent;
        }
        field(50127; "Installment Charge Option"; Option)
        {
            OptionMembers = " ","Flat Amount","Tiered";
            Caption = 'Installment Charge Option';
            DataClassification = CustomerContent;
        }
        field(50128; "Loan Payment Destination"; Enum "LoanPaymentDestination")
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Payment Destination';
        }
        field(50129; "Max. Boost Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50130; "Insurance Due A/c"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Insurance Fee Due A/c';
            DataClassification = CustomerContent;
        }
        field(50131; "Insurance Paid A/c"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Insurance Paid A/c';
            DataClassification = CustomerContent;
        }
        field(50132; "Check Min. Balance On"; Code[20])
        {
            TableRelation = "Product Factory" where("Product Class" = const(Account));
            Caption = 'Min. Balance Based On';
            DataClassification = CustomerContent;
        }
        field(50133; "Insurance Fee"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance';
        }
        field(50134; "Settlement Fee"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Ledger Fee (Islamic Banking)';
        }
        field(50135; "Mobile Money"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Amount (Mobile Money)';
        }
        field(50136; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Factory" where("Product Class" = filter(Account), Status = filter(Active));
        }
        field(50137; "Enforce Min. Share Rule"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enforce Min. Share Capital Rule';
        }
        field(50138; "Allow Online Application"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Online Application';
        }
        field(50139; "Graduation % (Mobile)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Graduation % (Mobile)';
        }
        field(50140; "Downgrade % (Mobile)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Downgrade % (Mobile)';
        }
        field(50141; "Member Segment"; Code[20])
        {
            Caption = 'Member Segment';
            DataClassification = CustomerContent;
            TableRelation = "Segment/County/Dividend/Signat".Code where(Type = filter(Segment | Religion));
        
            trigger OnValidate()
            var
                CustSegment: Record "Segment/County/Dividend/Signat";
            begin

            end;
        }
        field(50142; "Ledger Fee Due A/c"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Ledger Fee Due A/c';
            DataClassification = CustomerContent;
        }
        field(50143; "Ledger Paid A/c"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Ledger Paid A/c';
            DataClassification = CustomerContent;
        }
        field(50144; "Billing Type"; Enum "BillingType")
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Type';
        }
        field(50145; "Charges Options"; Enum "ProductChargeOptions")
        {
            DataClassification = CustomerContent;
            Caption = 'Charges Option';
        }
        field(50146; "Product Dimension"; Enum ProductDimension)
        {
            DataClassification = CustomerContent;
            Caption = 'Product Dimension';
        }
        field(91000; "Rcv Max. Graduated Amount"; Decimal)
        {
            Caption = 'Max. Graduated Amount';
            DataClassification = CustomerContent;
        }
        field(91001; "Rcv Graduated Amount"; Decimal)
        {
            Caption = 'Graduated Amount';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("Key1"; "Product ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Product ID", Description)
        {
        }
    }
    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        DimMgt: Codeunit DimensionManagement;
        IntPeriod: Text;


    procedure fnReceivablesAccount(ProductCode: Code[20]; TransactionType: Enum "LoanTransactionType"): Code[20]
    begin
        Get(ProductCode);
        case TransactionType of

            TransactionType::Loan,
            TransactionType::Repayment:
                begin
                    exit("Loan Account (G/L)");
                end;
            TransactionType::"Interest Due":
                begin
                    exit("Receivable Account (G/L)");
                end;
            TransactionType::"Interest Paid":
                begin
                    exit("Receivable Account (G/L)");
                end;
            TransactionType::"Penalty Due":
                begin
                    exit("Penalty Due Account");
                end;
            TransactionType::"Penalty Paid":
                begin
                    exit("Penalty Due Account");
                end;
            TransactionType::"Insurance Due":
                begin
                    exit("Insurance Due A/c")
                end;
            TransactionType::"Insurance Paid":
                begin
                    exit("Insurance Due A/c")
                end;
            TransactionType::"Ledger Fee Due":
                begin
                    exit("Ledger Fee Due A/c")
                end;
            TransactionType::"Ledger Fee Paid":
                begin
                    exit("Ledger Fee Due A/c")
                end;
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(
        FieldNumber, ShortcutDimCode,
        "Dimension Set ID");
    end;

    procedure fnCheckMinRequirements()
    begin
        TestField("Account No. Prefix");
        TestField("Account No. Suffix");
        TestField("Posting Group");
        TestField(Status, Status::Active);
        if "Product Class" = "Product Class"::Account then begin
            TestField("Account Category");
            TestField("Account Dimension");
        end;
    end;

    procedure fnCheckMinApprovalRequirements()
    var
        TieredRates: Record "Interest Rates Banding";
    begin
        TestField("Account No. Prefix");
        TestField("Account No. Suffix");
        TestField("Posting Group");
        TestField("Member Segment");
        TestField("Account Dimension");
        TestField("Product Class");
        TestField("Responsibility Centre");
        case "Product Class" of
            "Product Class"::Account:
                begin
                    TestField("Dormancy Period");
                    TestField("Account Category");
                    TestField("Withdrawal Option");
                    TestField("Minimum Balance");
                    TestField("Minimum Contribution");
                end;
            "Product Class"::Loan:
                begin
                    TestField("Disbursement Destination");
                    TestField("Installment Period");
                    TestField("Billing Type");
                    TestField("Loan Account (G/L)");
                    TestField("Interest Account (G/L)");
                    TestField("Receivable Account (G/L)");
                    TestField("Min. Re-application Period");
                    TestField("Maximum Loan Amount");
                    TestField("Minimum Loan Amount");
                    TestField("Interest Charge Option");
                    TestField("Installment Charge Option");
                    TestField("Appraisal Parameter Type");
                    if "Interest Calculation Method" <> "Interest Calculation Method"::"Zero Interest" then begin
                        TestField("Interest Rate (Max.)");
                        TestField("Interest Rate (Min.)");
                    end;
                    TestField("Deposits Appraisal Parameter");
                    TestField("Repayment Mode");
                    TestField("Grace Period - Interest");
                    TestField("Grace Period-Principle");
                    TestField("Ordinary Default Intallments");
                    TestField("Ordinary Deposits Multiplier");
                    TestField("Preferential Dep. Multiplier");
                    TestField("Prefferential Installments");
                    TestField("Nature of Loan Type");
                    TestField("Loan Payment Destination");
                    if "Deposits Appraisal Parameter" = "Deposits Appraisal Parameter"::Account then
                        TestField("Product Type");
                    case "Interest Charge Option" of
                        "Interest Charge Option"::Tiered:
                            begin
                                TieredRates.Reset();
                                TieredRates.SetRange("Tier Type", TieredRates."Tier Type"::"Interest Rate");
                                if not TieredRates.Find('-') then
                                    Error('Tiered Interest rates banding cannot be found.');
                            end;
                    end;
                    case "Installment Charge Option" of
                        "Installment Charge Option"::Tiered:
                            begin
                                TieredRates.Reset();
                                TieredRates.SetRange("Tier Type", TieredRates."Tier Type"::Installment);
                                if not TieredRates.Find('-') then
                                    Error('Tiered Installment banding cannot be found.');
                            end;
                    end;

                end;
        end;
    end;

    procedure CheckBlockedProdOnJnls(Prod2: Record "Product Factory"; DocType: Option Open,"Pending Approval",Active,Blocked; Transaction: Boolean)
    begin
        Prod2.fnCheckMinApprovalRequirements;

        if (Prod2."Loan Account (G/L)" = '') or
            ((Prod2."Posting Group" = '') and (DocType in [DocType::Open,
            DocType::"Pending Approval", DocType::Blocked]))
          then
            Prod2.ProdBlockedErrorMessage(Prod2, Transaction)
    end;

    procedure ProdBlockedErrorMessage(Prod2: Record "Product Factory"; Transaction: Boolean)
    var
        "Action": Text[30];
        Text004: Label 'Post';
        Text005: Label 'Create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
    begin
        if Transaction then
            Action := Text004
        else
            Action := Text005;
        Error(Text006, Action, Prod2."Product ID", Prod2.Status);
    end;


    procedure fnValidateFrequencyRepay()
    begin
        TestField("Prefferential Installments");
        TestField("Ordinary Default Intallments");

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

        case "Repayment Frequency" of
            "Repayment Frequency"::Daily:
                begin
                    if xRec."Ordinary Default Intallments" < 12 then begin
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then begin
                            "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 30.41), 1, '=');
                            "Prefferential Installments" := Round(("Prefferential Installments" * 30.41), 1, '=');
                        end;
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then begin
                            "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 7), 1, '=');
                            "Prefferential Installments" := Round(("Prefferential Installments" * 7), 1, '=');
                        end;
                    end;

                    if xRec."Ordinary Default Intallments" >= 12 then begin
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then begin
                            "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 30.41), 1, '=');
                            "Prefferential Installments" := Round(("Prefferential Installments" * 30.41), 1, '=');
                        end;
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then begin
                            "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 7), 1, '=');
                            "Prefferential Installments" := Round(("Prefferential Installments" * 7), 1, '=');
                        end;
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then begin
                            "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 121.6), 1, '=');
                            "Prefferential Installments" := Round(("Prefferential Installments" * 121.6), 1, '=');
                        end;
                        if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then begin
                            "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 30.41), 1, '=');
                            "Prefferential Installments" := Round(("Prefferential Installments" * 30.41), 1, '=');
                        end;
                    end
                end;
            "Repayment Frequency"::Monthly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 30.41), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 30.41), 1, '=');
                        if ("Ordinary Default Intallments" < 0) or ("Prefferential Installments" < 0) then begin
                            "Ordinary Default Intallments" := 1;
                            "Prefferential Installments" := 1;
                        end;
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 4.34), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 4.34), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 4), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" * 4), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 12), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 12), 1, '=');
                    end;
                end;
            "Repayment Frequency"::Weekly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 7), 1, '<');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 7), 1, '<');
                        if ("Ordinary Default Intallments" < 0) or ("Prefferential Installments" < 0) then begin
                            "Ordinary Default Intallments" := 1;
                            "Prefferential Installments" := 1;
                        end;
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 4.34), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" * 4.34), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then begin
                        "Ordinary Default Intallments" := Round((("Ordinary Default Intallments" * 4) * 4.34), 1, '=');
                        "Prefferential Installments" := Round((("Prefferential Installments" * 4) * 4.34), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 52.14), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" * 52.14), 1, '=');
                    end;
                end;

            "Repayment Frequency"::Quarterly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then begin
                        "Ordinary Default Intallments" := Round((("Ordinary Default Intallments" * 365) / 3), 1, '=');
                        "Prefferential Installments" := Round((("Prefferential Installments" * 365) / 3), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then begin
                        "Ordinary Default Intallments" := Round((("Ordinary Default Intallments" / 52.14) / 3), 1, '=');
                        "Prefferential Installments" := Round((("Prefferential Installments" / 52.14) / 3), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 3), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 3), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Yearly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" * 3), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" * 3), 1, '=');
                    end;
                end;

            "Repayment Frequency"::Yearly:
                begin
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Daily then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 365), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 365), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Weekly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 52.14), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 52.14), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Monthly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 12), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 12), 1, '=');
                    end;
                    if xRec."Repayment Frequency" = xRec."Repayment Frequency"::Quarterly then begin
                        "Ordinary Default Intallments" := Round(("Ordinary Default Intallments" / 3), 1, '=');
                        "Prefferential Installments" := Round(("Prefferential Installments" / 3), 1, '=');
                    end;
                end;
        end
    end;

    procedure CheckExistingProdOnJnls(Prod2: Code[10]; Acc2: Code[20]; Topup: Decimal)
    var
        Loans: Record Loans;
        ProductFactory: Record "Product Factory";
        ErrorOnMultipleRunningLoanTxt: Label 'This Product does not allow multiple running loans.Kindly Topup before you continue.';
    begin
        if ProductFactory.Get(Prod2) then begin

            Loans.Reset;
            Loans.SetRange("Account No.", Acc2);
            Loans.SetRange("Product Type", Prod2);
            Loans.SetFilter("Outstanding Principal", '>0');
            if Loans.Find('-') then begin
                Loans.CalcFields("Outstanding Principal");
                if not (ProductFactory."Allow Multiple Running Loans") and (Topup = 0) then
                    Error(ErrorOnMultipleRunningLoanTxt);
            end;
        end
    end;

    procedure fnCheckPostAccount()
    begin
        TestField("Loan Account (G/L)");
        TestField("Interest Account (G/L)");
        TestField("Receivable Account (G/L)");
    end;

    procedure CheckExistingProdApplicationsOnJnls(Prod2: Code[10]; Acc2: Code[20]; LoanNo: Code[20])
    var
        Loans: Record "Loan Application";
        ProductFactory: Record "Product Factory";
        ErrorOnMultipleRunningLoanTxt: Label 'Member has existing application No. %1 still on queue.Kindly work on the existing application before you start a new application. %2';
        Gensetup: Record "General Set-Up";
    begin
        Gensetup.Get();
        if ProductFactory.Get(Prod2) then begin
            if ProductFactory."Product ID" <> 'UB/L/105' then begin

                Loans.Reset;
                Loans.SetRange("Account No.", Acc2);
                Loans.SetFilter("Approval Status", '%1|%2|%3', Loans."Approval Status"::Open,
                Loans."Approval Status"::"Pending Approval", Loans."Approval Status"::Approved);
                Loans.SetFilter("Product Type", '<>%1', 'UB/L/105');
                if Loans.FindFirst then begin
                    if Loans."No." <> LoanNo then begin
                        Error(ErrorOnMultipleRunningLoanTxt, Loans."No.", Loans."Account Name");
                    end
                end;
            end
        end
    end;

    procedure WorkflowRecordMngt(WorkflowSteps: Integer)
    var
        WorkflowManagement: Codeunit "Approval Mgmt.";
        RegMngt: Codeunit "Register Management";
    begin
        case WorkflowSteps of
            1:
                begin
                    fnCheckMinApprovalRequirements;
                    WorkflowManagement.SendProductFactRequest(Rec)
                end;
            2:
                WorkflowManagement.CancelProductFactApprovalRequest(Rec, true, true);
            3:
                WorkflowManagement.OpenProductFactApprovalRequest(Rec, true, true);
            4:
                WorkflowManagement.BlockProductFactApprovalRequest(Rec, true, true)
        end
    end;
}




