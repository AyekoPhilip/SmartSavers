table 50562 "Loans Categorization"
{
    DrillDownPageID = "Loan-Performance Indicator";
    LookupPageID = "Loan-Performance Indicator";
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[20])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Product Type"; Code[100])
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
            TableRelation = Member."No.";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ObjCust: Record Member;
                ErrorMembAgeTxt: Label 'Member due to retire before loan repayment is complete. Do you wish to continue?';
                STermLoan: Record Loans;
                MaxLoan: Decimal;
                SalDetails: Record "Appraisal Salary Details";
            begin
                GetCustomerAccount;
                OnValidateAccountNoOnAfterAssignValue(Rec, xRec)
            end;
        }
        field(50013; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
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
        }
        field(50016; "Account Name"; Text[250])
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
            begin

                if "Approved Amount" > 0 then begin
                    TestField("Product Type");
                    Validate("Approved Amount");
                end;
            end;
        }
        field(50019; "Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if "Repayment Start Date" = 0D then
                    "Repayment Start Date" := getrepaymentStartDate;
                case "Repayment Frequency" of
                    "Repayment Frequency"::Daily:
                        begin
                            "Expected Date of Completion" := CalcDate(
                            Format(Installments) + 'D', "Repayment Start Date");
                        end;
                    "Repayment Frequency"::Weekly:
                        begin
                            "Expected Date of Completion" := CalcDate(
                            Format(Installments) + 'W', "Repayment Start Date");
                        end;
                    "Repayment Frequency"::Monthly:
                        begin

                            if "Application Type" = "Application Type"::Mobile then begin
                                "Expected Date of Completion" := CalcDate(
                                Format(Installments) + 'M', "Repayment Start Date")
                            end else begin
                                "Expected Date of Completion" := CalcDate(
                                Format(Installments) + 'M', "Repayment Start Date");
                            end;
                        end;
                    "Repayment Frequency"::Quarterly:
                        begin
                            "Expected Date of Completion" := CalcDate(
                            Format(Installments) + 'Q', "Repayment Start Date");
                        end;
                    "Repayment Frequency"::Yearly:
                        begin
                            "Expected Date of Completion" := CalcDate(
                            Format(Installments) + 'Y', "Repayment Start Date");
                        end;
                end
            end;
        }
        field(50020; "Mode of Disbursement"; Option)
        {
            OptionCaption = 'Full Disbursement,Partial Disbursement';
            OptionMembers = "Full Disbursement","Partial Disbursement";
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
        field(50056; "Charge Interest on Posting"; Option)
        {
            OptionCaption = ' ,Full Interest,Pro-rata';
            OptionMembers = " ","Full Interest","Pro-rata";
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
        
            trigger OnValidate()
            var
                PFactory: Record "General Set-Up";
            begin
            end;
        }
        field(50074; "Total TopUp"; Decimal)
        {
            CalcFormula = Sum("Loans Top up Posted"."Total Amount" where("Loan No." = FIELD("No."),
                                                                          "No." = FIELD("Application No.")));
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
            TableRelation = "Account Credit"."No." WHERE("Member No." = FIELD("No."),
                                                          "Account Category" = FILTER("Shares Capital" | "Shares Deposit"),
                                                          Status = CONST(Active));
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
        field(50086; "Application No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Loan Application"."No.";
            Caption = 'Application No.';
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
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Loan Account"), "Loan No." = field("No."), "Posting Date" = field("Date Filter"),"Transaction Type" = filter(Loan | Repayment), "Entry Type" = filter("Initial Entry")));
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
            Editable = false;
            Caption = 'Accrued Interest';
        }
        field(50099; "Performance Indicator"; Enum "LoanPerformanceIndicator")
        {
            DataClassification = CustomerContent;
            Caption = 'Performance Indicator';
        }
        field(50100; "Loan Age"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50101; "Days in Arrears"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50102; "Expected Repayment"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50103; "Amount In Arrears"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50104; "Amount Paid"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50105; "Deposits Appraisal Parameter"; Enum "DepositsAppraisalParameter")
        {
            DataClassification = CustomerContent;
            Caption = 'Security Appraisal Parameter';
            Editable = false;
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
        field(50108; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50109; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50110; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(50111; "Loan Payment Destination"; Enum "LoanPaymentDestination")
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Payment Destination';
        }
        field(50112; "Account Status"; Enum "LoanAccountStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50113; "OverDue Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50114; "Next Installment Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50115; "Current Balance"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'Current Balance';
        }
        field(50116; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
            Caption = 'Member Category';
            DataClassification = CustomerContent;
        }
        field(50117; "System Non-Created"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
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

    var
        MembNoSeries: Record "Credit Nos. Series";
        DimMgt: Codeunit DimensionManagement;
        RegMngt: Codeunit "Register Management";
        VarVariant: Variant;
        CredMngt: Codeunit "Credit Mgmt.";
        Credit: Record "Credit Account";
        InterestErrorTxt: Label 'Interest Rate is not within allowed range.';
        ProdFac: Record "Product Factory";
        GeneralSetUp: Record "General Set-Up";

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
        if Cust.Get("Account No.") then begin
            UpdateDescription(Cust.Name);
            "Payroll/Staff No." := Cust."Payroll/Staff No.";
            "ID No." := Cust."ID No.";
            "Employer Code" := Cust."Employer Code";
            "Shares Deposit" := RegMngt.GetOperationAccBalanceTxt(prodtCategory::"Shares Deposit", Cust."No.", 2);
            case "Disbursement Destination" of
                "Disbursement Destination"::"Mobile Money",
                "Disbursement Destination"::"Banking Account":
                    begin
                        "Disbursement Account No." := RegMngt.GetOperationAcc(Accountcat::Savings, Cust."No.", 1);
                    end;
            end;
            PassDocumentNo;
            OnAfterAccountNoOnValidateGetCustomerAccount(Rec, Cust, CurrFieldNo);
        end;
    end;

    procedure UpdateFields(ProductFactory: Record "Product Factory")
    var
        AppCharges: Record "Loan Application Charge";
    begin

        Installments := ProductFactory."Ordinary Default Intallments";
        "Product Description" := ProductFactory.Description;
        "Interest Calculation Method" := ProductFactory."Interest Calculation Method";
        "Interest Rate" := ProductFactory."Interest Rate (Max.)";
        "Installment Period" := ProductFactory."Installment Period";
        "Disbursement Destination" := ProductFactory."Disbursement Destination";
        "Repayment Frequency" := ProductFactory."Repayment Frequency";
        "Repayment Mode" := ProductFactory."Repayment Mode";
        "Appraisal Parameter Type" := ProductFactory."Appraisal Parameter Type";
        "Installment Period" := ProductFactory."Installment Period";
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
    local procedure OnAfterAccountNoOnValidateGetCustomerAccount(var xLoan: Record "Loans Categorization"; var Customer: Record Member; CallingFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateAccountNoOnAfterAssignValue(var Loan: Record "Loans Categorization"; var XLoans: Record "Loans Categorization")
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
        OnAfterAccountNoOnValidateGetProduct(Rec, ProdFact, CurrFieldNo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetProduct(var Loanx: Record "Loans Categorization"; var Customer: Record "Product Factory"; CallingFieldNo: Integer)
    begin
    end;

    local procedure UpdateRequestAmt()
    var
        ProdFac: Record "Product Factory";
        ErrorOnLoanAmountErrTxt: Label 'The loan amount applied is not within allowed margins of %1 and %2';
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
        "Amount to Disburse" := "Approved Amount";
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
    end;


    procedure fnValidateFrequencyRepay(Frequency: Integer)
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
            0:
                begin
                    exit
                end;
            1:
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

            2:
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

            3:
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

            4:
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

            5:
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

        "Approval Date" := LoanApplication."Approval Date";
        "Disbursement Date" := LoanApplication."Disbursement Date";
        "Amount to Disburse" := LoanApplication."Amount to Disburse";
        "Fully Disbursed" := LoanApplication."Fully Disbursed";
        "Total Disbursed" := LoanApplication."Total Disbursed";
        "Repayment Start Date" := LoanApplication."Repayment Start Date";
        Remarks := LoanApplication.Remarks;
        "Currency Code" := LoanApplication."Currency Code";
        "Expected Date of Completion" := LoanApplication."Expected Date of Completion";
        "Approval Status" := LoanApplication."Approval Status";
        "Loan Rejection Reason" := LoanApplication."Loan Rejection Reason";
        "Recommended Amount" := LoanApplication."Recommended Amount";
        "Loan Span" := LoanApplication."Loan Span";
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
    end;

    procedure fnTestFields()
    begin
        TestField("Account No.");
        TestField("Product Type");
        TestField("Loan Account");
        TestField("Approved Amount");
        TestField("Disbursement Date");
        TestField("Disbursement Account No.");
        TestField("Approval Status", "Approval Status"::Approved);
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

                        ProdFac.TestField("Grace Period-Principle");
                        CheckOffdate := CalcDate(ProdFac."Grace Period-Principle", "Disbursement Date");
                        exit(CheckOffdate);
                    end else begin

                    GeneralSetUp.Get();
                    GeneralSetUp.TestField("Checkoff Cutoff Days");
                    StartMonthDate := CalcDate('-CM', "Disbursement Date");
                    EndMonthDate := CalcDate('CM', "Disbursement Date");
                    MidCheckDate := CalcDate(GeneralSetUp."Checkoff Cutoff Days", StartMonthDate);
                    if "Disbursement Date" >= MidCheckDate then
                        CheckOffdate := CalcDate('1M', EndMonthDate) else
                        CheckOffdate := CalcDate('CM', "Disbursement Date");
                    exit(CheckOffdate);
                end;
            end;
        end;
    end;

    procedure CopyFromLoanApplicationLine(LoanApplication: Record Loans)
    begin

        "Approval Date" := LoanApplication."Approval Date";
        "Interest Rate" := LoanApplication."Interest Rate";
        Installments := LoanApplication.Installments;
        "Interest Repayment" := LoanApplication."Interest Repayment";
        "Principle Repayment" := LoanApplication."Principle Repayment";
        "Disbursement Date" := LoanApplication."Disbursement Date";
        "Amount to Disburse" := LoanApplication."Amount to Disburse";
        "Product Description" := LoanApplication."Product Description";
        "Fully Disbursed" := LoanApplication."Fully Disbursed";
        "Total Disbursed" := LoanApplication."Total Disbursed";
        "Repayment Start Date" := LoanApplication."Repayment Start Date";
        "Currency Code" := LoanApplication."Currency Code";
        Remarks := LoanApplication.Remarks;
        "Approval Status" := LoanApplication."Approval Status";
        "Loan Rejection Reason" := LoanApplication."Loan Rejection Reason";
        "Recommended Amount" := LoanApplication."Recommended Amount";
        "Loan Span" := LoanApplication."Loan Span";
        "Time Created" := LoanApplication."Time Created";
        "Disbursement Destination" := LoanApplication."Disbursement Destination";
        "Self Guarantee" := LoanApplication."Self Guarantee";
        "Appraisal Parameter Type" := LoanApplication."Appraisal Parameter Type";
        "Old Account No." := LoanApplication."Old Account No.";
        "Application Source" := LoanApplication."Application Source";
        "Repayment Frequency" := LoanApplication."Repayment Frequency";
        "Purpose of Loan" := LoanApplication."Purpose of Loan";
        "Charges & Commissions" := LoanApplication."Charges & Commissions";
        "Deposit Purchase" := LoanApplication."Deposit Purchase";
        "Loan Status" := LoanApplication."Loan Status";
        "Application Type" := LoanApplication."Application Type";
        "Shares Deposit" := LoanApplication."Shares Deposit";
        "Deposit Purchase Account" := LoanApplication."Deposit Purchase Account";
        Sectors := LoanApplication.Sectors;
        "Sub Sectors" := LoanApplication."Sub Sectors";
        "Expected Date of Completion" := LoanApplication."Expected Date of Completion";
        "Deposits Appraisal Parameter" := LoanApplication."Deposits Appraisal Parameter";
    end;

    procedure OpenCustomerLedgerEntries(FilterOnDueEntries: Boolean)
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOpenCustomerLedgerEntries(Rec, DetailedCustLedgEntry, FilterOnDueEntries, IsHandled);
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
    local procedure OnBeforeOpenCustomerLedgerEntries(var Customer: Record "Loans Categorization"; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; FilterOnDueEntries: Boolean; var IsHandled: Boolean)
    begin
    end;

    var
        Accountcat: Enum ProductAccountCategory;



}




