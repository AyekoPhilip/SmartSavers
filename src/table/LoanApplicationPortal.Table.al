table 50570 "Loan Application-Portal"
{
    Caption = 'Loan Application-Portal';
    DataClassification = ToBeClassified;

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
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class" = CONST(Loan),
                                                                  Status = CONST(Active));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                CustEmp: Record Customer;
                ProductFact: Record "Product Factory";
                PayShedule: Record "Schedule of Loan Payment";
            begin
                TestField("Account No.");
                GetProductType;

            end;
        }
        field(50012; "Account No."; Code[20])
        {
            TableRelation = Member."No." WHERE(Status = FILTER(Active));
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
                GetCustomerAccount;

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
            begin

                IF ProdFac.GET("Product Type") THEN BEGIN
                    IF Installments > ProdFac."Ordinary Default Intallments" THEN
                        ERROR(Text006, ProdFac."Ordinary Default Intallments");
                END;
                IF "Approved Amount" > 0 THEN
                    VALIDATE("Approved Amount");

            end;
        }
        field(50019; "Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Disbursement Date" < Today then Error('Disbursement Date cannot be less than today');
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
            Editable = true;
            TableRelation = "Credit Account"."No.";
            Caption = 'Loan Account';
            DataClassification = CustomerContent;
        }
        field(50050; "Loan Span"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Short Term,Long Term';
            OptionMembers = " ","Short Term","Long Term";
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
            TableRelation = "Loan Disbursement Header"."No." where("Approval Status" = filter(Open),
                                                                    Posted = const(false));
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
            CalcFormula = Sum("Loans Top up"."Total Outstanding Amount" WHERE("No." = FIELD("No."),
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
        field(50077; "Application Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Normal,Mobile,Defaulter,Loan Restructure,Loan Calculator,Portal';
            OptionMembers = "Normal","Mobile","Defaulter","Loan Restructure","Loan Calculator","Portal";
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
            TableRelation = "Account Credit"."No." WHERE("Member No." = FIELD("Account No."),
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
        }
        field(50102; "Qualifying Dividend Amount"; Decimal)
        {
            Editable = false;
        }
        field(50103; "Application No."; Code[100])
        {
            Editable = false;
        
            trigger OnValidate()
            var
                LnPortal: Record "Loan Application-Portal";
            begin
                if "Application No." <> '' then begin
                    LnPortal.Reset();
                    LnPortal.SetRange("Application No.", "Application No.");
                    if LnPortal.FindFirst() then begin
                        Error('Application No. Already exists- %1-%2', LnPortal."No.", LnPortal."Account Name");
                    end;
                end;
            end;
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
        RecRefHeader: Record "Loan Application-Portal";
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
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Loan Application-Portal"; xRecRef: Record "Loan Application-Portal"; var IsHandled: Boolean)
    begin
    end;

    var
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        RegMngt: Codeunit "Register Management";
        VarVariant: Variant;
        CredMngt: Codeunit "Credit Mgmt.";
        Credit: Record "Credit Account";
        InterestErrorTxt: Label 'Interest Rate is not within allowed range.';
        ProdFac: Record "Product Factory";
        ErrorOnAmtGuarantMoreThanAppAmtTxt: Label 'Amount guaranteed cannot be less than Approved Amount or Topup amount cannot be more than approved amount.';
        GeneralSetUp: Record "General Set-Up";
        ErrorOnLessNoOfGuarantorTxt: Label 'Loan has less No. of guarantor %1, allowed to guarantee a loan. The Min. No is %2.';

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Loan Application", "No.", FieldNumber, ShortcutDimCode);
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
        ShareBanding: Record "Shares Banding";
        MonthlyContrib: Record "Member Monthly Contribution";
        ProdtCategory: Enum ProductAccountCategory;
        HrDate: Codeunit "Date Conversion";
        GuarantDetail: Record "Loan Guarantors and Security";
        CredAccount: Record "Account Credit";
    begin
        GeneralSetUp.Get();
        Cust.Get("Account No.");
        Cust.TestField("Registration Date");
        Cust.TestField("Date of Birth");
        Cust.TestField("ID No.");
        MngtMinShareBalance();
        Cust.CheckBlockedCustOnJnls(Cust, Cust.Status, false);
        UpdateDescription(Cust.Name);
        "Payroll/Staff No." := Cust."Payroll/Staff No.";
        "ID No." := Cust."ID No.";
        "Employer Code" := Cust."Employer Code";
        if GeneralSetUp."Nofity Guarantors" then
            Cust.TestField("Mobile Phone No");

        MonthlyContrib.Reset();
        MonthlyContrib.SetRange("Account No.", "Account No.");
        MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Deposit");
        if MonthlyContrib.Find('-') then
            "Shares Banding" := MonthlyContrib.Amount;
        "Shares Deposit" := RegMngt.GetOperationAccBalanceTxt(ProdtCategory::"Shares Deposit", Cust."No.", 2);
        "Total Balance" := RegMngt.getCustLoanBalance(0, "Account No.", 0);
        case "Disbursement Destination" of
            "Disbursement Destination"::"Mobile Money",
            "Disbursement Destination"::"Banking Account":
                begin
                    "Disbursement Account No." := RegMngt.GetOperationAcc(Accountcat::Savings, Cust."No.", 1);
                end;
        end;
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

    end;


    procedure UpdateFields(ProductFactory: Record "Product Factory")
    var
        LnAppCharges: Record "Loan Product Charges";
        ApplicationCharge: Record "Loan Application Charge";
    begin

        Rec.CalcFields("Total TopUp");
        CredMngt.CheckCustomerExistingProduct("Account No.", "Product Type", "Total TopUp", "No.");
        Installments := ProductFactory."Ordinary Default Intallments";
        "Product Description" := ProductFactory.Description;
        "Interest Calculation Method" := ProductFactory."Interest Calculation Method";
        "Interest Rate" := ProductFactory."Interest Rate (Max.)";
        "Installment Period" := ProductFactory."Installment Period";
        "Disbursement Destination" := ProductFactory."Disbursement Destination";
        "Repayment Frequency" := ProductFactory."Repayment Frequency";
        "Recovery Mode" := ProductFactory."Repayment Mode";
        "Repayment Mode" := ProductFactory."Repayment Mode";
        if "Repayment Mode" = "Repayment Mode"::Dividend then begin
            Validate("Repayment Frequency");
        end;
        "Appraisal Parameter Type" := ProductFactory."Appraisal Parameter Type";
        "Installment Period" := ProductFactory."Installment Period";
        "Deposits Appraisal Parameter" := ProductFactory."Deposits Appraisal Parameter";
        "Charge Interest on Posting" := ProductFactory."Charge Interest Due";
        "Ignore Related Balance" := ProductFactory."Ignore Related Balance";
        "Disbursement Destination" := ProductFactory."Disbursement Destination";
        "Loan Account" := '';

        Credit.Reset;
        Credit.SetRange("Member No.", "Account No.");
        Credit.SetRange("Product Type", ProductFactory."Product ID");
        if Credit.Find('-') then begin
            "Loan Account" := Credit."No."
        end else begin
            "Loan Account" := CredMngt.CreateLoanAccount(
            "Account No.", ProductFactory."Product ID")
        end;
        if "Loan Account" <> '' then begin

            ApplicationCharge.Reset();
            ApplicationCharge.SetRange("Application No.", "No.");
            ApplicationCharge.DeleteAll();

            LnAppCharges.Reset();
            LnAppCharges.SetRange("Product Code", "Product Type");
            if LnAppCharges.FindSet() then begin
                repeat

                    ApplicationCharge.Init();
                    ApplicationCharge."Application No." := Rec."No.";
                    ApplicationCharge."Product Code" := LnAppCharges."Product Code";
                    ApplicationCharge."Charge Code" := LnAppCharges."Charge Code";
                    ApplicationCharge."Charge Amount" := LnAppCharges."Charge Amount";
                    ApplicationCharge.Percentage := LnAppCharges.Percentage;
                    ApplicationCharge."Use Percentage" := LnAppCharges."Use Percentage";
                    ApplicationCharge."Charge Description" := LnAppCharges."Charge Description";
                    ApplicationCharge."Charge Method" := LnAppCharges."Charge Method";
                    ApplicationCharge."Charge Type" := LnAppCharges."Charge Type";
                    ApplicationCharge."Charging Option" := LnAppCharges."Charging Option";
                    ApplicationCharge."Effect Excise Duty" := LnAppCharges."Effect Excise Duty";
                    ApplicationCharge."Staggered Charge Code" := LnAppCharges."Staggered Charge Code";
                    ApplicationCharge."Account Type" := LnAppCharges."Account Type";
                    ApplicationCharge."Account No." := LnAppCharges."Charges Account";
                    ApplicationCharge."Post Charge" := true;
                    ApplicationCharge.Maximum := LnAppCharges.Maximum;
                    ApplicationCharge.Minimum := LnAppCharges.Maximum;
                    ApplicationCharge.Insert(true)
                until LnAppCharges.Next() = 0;
            end;
        end;
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
        ErrorOnMinPeriodTxt: Label 'Member has not achieved minimum loan application period of %1';
    begin

        TestField("Account No.");
        Cust.Get("Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, Cust.Status, false);
        CheckCustExistingApplication();

        ProdFact.Get("Product Type");
        ProdFact.TestField("Disbursement Destination");
        if fncheckMinLoanApplicationPeriod(Cust."No.") then
            Error(ErrorOnMinPeriodTxt, ProdFact."Min. Re-application Period");
        ProdFact.fnCheckMinRequirements();
        ProdFact.CheckBlockedProdOnJnls(ProdFact, ProdFact.Status, false);
        ProdFact.CheckExistingProdApplicationsOnJnls("Product Type", "Account No.", "No.");
        UpdateFields(ProdFact);

        if "Product Type" <> '' then begin
            InsertSelfGuaranteedEntry();
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
    begin
        TestField("Account No.");
        if "Requested Amount" < 0 then Error(ErrorNegatatedValue);

        "Approved Amount" := "Requested Amount";
        "Recommended Amount" := "Requested Amount";
        "Amount to Disburse" := "Requested Amount";
        Validate("Approved Amount");
        "Application Date" := Today;

        if ProdFac.Get("Product Type") then begin
            ProdFac.fnCheckMinApprovalRequirements;
            if ("Requested Amount" > ProdFac."Maximum Loan Amount") or
               ("Requested Amount" < ProdFac."Minimum Loan Amount") then
                Error(ErrorOnLoanAmountErrTxt, ProdFac."Minimum Loan Amount",
                ProdFac."Maximum Loan Amount");
            Validate("Approved Amount");
            ;
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

    begin
        TestField("Product Type");

        if FactProd.Get("Product Type") then begin
            FactProd.TestField("Maximum Loan Amount");
            if "Approved Amount" > FactProd."Maximum Loan Amount" then
                Error(ErrorOnDiffAmounttxt);
        end;

        if "Approved Amount" > "Requested Amount" then
            Error(ErrorOnApprovedAmtErrTxt);
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
                    LPrincipal := Round(LoanAmount / RepayPeriod);
                    Repayment := Round(LPrincipal, 1, '=');
                end
        end;
        if "Approved Amount" > 0 then begin

            PostedLoan.Reset();
            PostedLoan.SetCurrentKey("Approved Amount");
            PostedLoan.Ascending(false);
            PostedLoan.SetFilter("Outstanding Balance", '>0');
            PostedLoan.SetRange("Account No.", "Account No.");
            PostedLoan.SetFilter("Product Type", '<>%1', 'RS-ASSET');
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
                AccDredit."Monthly Contribution" := "Shares Banding";
                AccDredit.Modify(true)
            end;

            MonthlyContrib.Reset();
            MonthlyContrib.SetRange("Account No.", "Account No.");
            MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Deposit");
            if MonthlyContrib.FindFirst() then begin
                MonthlyContrib.Amount := "Shares Banding";
                MonthlyContrib.Modify(true)
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
    begin
        TestField("Account No.");
        TestField("Product Type");
        TestField("Approved Amount");
        if "Application Type" <> "Application Type"::Mobile then begin
            TestField(Sectors);
            TestField("Sub Sectors");
            TestField("Purpose of Loan");
        end;
        TestField("Loan Account");
        TestField(Installments);
        TestField(Remarks);
        TestField("Repayment Start Date");
        TestField("Disbursement Account No.");
        if "Application Type" <> "Application Type"::Mobile then begin
            CalcFields("Amount Guaranteed", "Total TopUp");
            if ("Amount Guaranteed" < "Approved Amount") or ("Total TopUp" > "Approved Amount") then
                Error(ErrorOnAmtGuarantMoreThanAppAmtTxt)
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
    begin
        TestField("Account No.");
        RegMngt.GetOperationAccBalanceTxt(ProdtCategory::"Shares Deposit", "Account No.", 2);
        TestField(Sectors);
        TestField(Remarks);
        TestField(Installments);
        TestField("Sub Sectors");
        TestField("Loan Account");
        TestField("Product Type");
        TestField("Purpose of Loan");
        TestField("Approved Amount");
        TestField("Repayment Start Date");
        TestField("Disbursement Account No.");
        TestField("Loan Status", Rec."Loan Status"::Appraisal);
        CalcFields("Amount Guaranteed", "Total TopUp");
        if ("Amount Guaranteed" < "Approved Amount") or ("Total TopUp" > "Approved Amount") then
            Error(ErrorOnAmtGuarantMoreThanAppAmtTxt);
        if Rec."Loan Status" = Rec."Loan Status"::Appraisal then begin
            if Rec."Approved Amount" > Rec."Recommended Amount" then
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
            Modify()
        end;

        GeneralSetUp.Get();
        if not GeneralSetUp."Override Setup Control" then begin
            GeneralSetUp.TestField("Min No. of Guarantors");
            PFact.Get("Product Type");
            if not "Self Guarantee" then begin
                if PFact."Deposits Appraisal Parameter" <> PFact."Deposits Appraisal Parameter"::Collateral then
                    if NoOfGuarantor("No.") < GeneralSetUp."Min No. of Guarantors" then
                        Error(ErrorOnLessNoOfGuarantorTxt, NoOfGuarantor("No."), GeneralSetUp."Min No. of Guarantors")
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
    begin
        if "Deposit Purchase" < 0 then
            Error('Amount cannot be less than zero');

        if "Deposit Purchase" > "Approved Amount" then
            "Deposit Purchase" := "Approved Amount" else
            "Deposit Purchase" := "Deposit Purchase";

        if "Deposit Purchase" > 0 then begin
            "Deposit Purchase Account" := RegMngt.GetOperationAcc(Accountcat::"Shares Deposit", "Account No.", 2);
            ApplicationCharges.Reset;
            ApplicationCharges.SetRange("Application No.", "No.");
            ApplicationCharges.SetRange("Charge Type", ApplicationCharges."Charge Type"::Boosting);
            if ApplicationCharges.FindSet then begin
                ApplicationCharges.ModifyAll("Post Charge", true);
            end;

        end else begin
            "Deposit Purchase Account" := '';
            ApplicationCharges.Reset;
            ApplicationCharges.SetRange("Application No.", "No.");
            ApplicationCharges.SetRange("Charge Type", ApplicationCharges."Charge Type"::Boosting);
            if ApplicationCharges.FindSet then begin
                ApplicationCharges.ModifyAll("Post Charge", false);
            end;
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
        end else begin

            GeneralSetUp.Get();
            GeneralSetUp.TestField("Checkoff Cutoff Days");
            StartMonthDate := CalcDate('-CM', "Disbursement Date");
            EndMonthDate := CalcDate('CM', "Disbursement Date");
            MidCheckDate := CalcDate(GeneralSetUp."Checkoff Cutoff Days", StartMonthDate);
            if "Disbursement Date" >= MidCheckDate then
                CheckOffdate := CalcDate('1M', EndMonthDate) else
                CheckOffdate := CalcDate('CM', "Disbursement Date");
        end;
        exit(CheckOffdate)
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
        if not GeneralSetUp."Override Setup Control" then begin
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

    local procedure InsertSelfGuaranteedEntry()
    var
        GuarantDetail: Record "Loan Guarantors and Security";
        Guarantor: Record "Loan Guarantors and Security";
        CredAcDetail: Record "Account Credit";
    begin
        ProdFac.Reset();
        ProdFac.SetRange("Product ID", "Product Type");
        if ProdFac.FindFirst() then begin

            case ProdFac."Deposits Appraisal Parameter" of
                ProdFac."Deposits Appraisal Parameter"::Dividends,
                    ProdFac."Deposits Appraisal Parameter"::Deposits:
                    begin

                        Guarantor.Reset();
                        Guarantor.SetRange("No.", Rec."No.");
                        if Guarantor.FindSet() then
                            Guarantor.DeleteAll();

                        CredAcDetail.SetRange("Member No.", "Account No.");
                        CredAcDetail.SetRange("Account Category", CredAcDetail."Account Category"::"Shares Deposit");
                        if CredAcDetail.FindFirst() then begin
                            GuarantDetail.Init();
                            GuarantDetail."No." := "No.";
                            GuarantDetail.Validate("Account No.", CredAcDetail."No.");
                            GuarantDetail."Member No. (Loanee)" := "Account No.";
                            GuarantDetail."Security Type" := GuarantDetail."Security Type"::Guarantor;
                            GuarantDetail.Insert(true);
                            "Self Guarantee" := true;
                        end;

                    end
            end
        end
    end;

    procedure MngtMinShareBalance()
    ApprovalMngt: Codeunit "Approval Mgmt.";
    var
        CustAccount: Record "Account Credit";
    begin
        CustAccount.Reset();
        CustAccount.SetRange("Member No.", "Account No.");
        CustAccount.SetRange("Account Category", CustAccount."Account Category"::"Shares Capital");
        if CustAccount.FindFirst() then begin
            CustAccount.CalcFields("Balance (LCY)");
            if ProdFac.Get(CustAccount."Product Type") then
                ProdFac.TestField("Minimum Balance");
            if CustAccount."Balance (LCY)" < ProdFac."Minimum Balance" then
                Error('Member has not attained Min. Share Capital of %1', ProdFac."Minimum Balance");
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
        LoanApp.SetFilter("Approval Status", '%1|%2|%3', LoanApp."Approval Status"::Open, LoanApp."Approval Status"::"Pending Approval", LoanApp."Approval Status"::Approved);
        if LoanApp.Find('-') then begin
            if LoanApp."No." <> Rec."No." then
                Error(ErrorOnExistingLoanApplicationTxt, LoanApp."Product Description", "Loan Account", LoanApp."No.");
        end;
    end;

    var
        Accountcat: Enum ProductAccountCategory;
}


