table 50397 "Loan Disbursement Header"
{
     DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            NotBlank = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            // DecimalPlaces is unspecified in the supplied symbols.
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(50012; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50013; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50014; "Date Posted"; DateTime)
        {
            Editable = false;
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
        field(50015; "Time Posted"; Time)
        {
            Editable = false;
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50016; "Posted By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50017; "Total Amount"; Decimal)
        {
            CalcFormula = Sum(Loans."Approved Amount" where("Batch No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Amount';
        }
        field(50018; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50019; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50020; "Payment Type"; Enum "BatchPaymentType")
        {
            Caption = 'Payment Type';
            DataClassification = CustomerContent;
        }
        field(50021; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50022; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50023; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center BR".Code;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50024; "Issued Date From"; Date)
        {
            Caption = 'Issued Date From';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50025; "Issued Date To"; Date)
        {
            Caption = 'Issued Date To';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50026; "Subsequent Disbursements"; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = "No","Yes";
            Caption = 'Subsequent Disbursements';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50027; "Date Created"; Date)
        {
            Editable = false;
            Caption = 'Date Created';
            DataClassification = CustomerContent;
        }
        field(50028; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Posting Date" > Today then error('Posting Date cannot be greater than today')
            end;
        }
        field(50029; "Prepared By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Prepared By';
            DataClassification = CustomerContent;
        }
        field(50030; "Disbursement Destination"; Option)
        {
            OptionCaption = 'Normal,Bank Account,Supplier';
            OptionMembers = "Normal","Bank Account","Supplier";
            Caption = 'Disbursement Destination';
            DataClassification = CustomerContent;
        }
        field(50031; "Disburse Accounts"; Code[20])
        {
            TableRelation = IF ("Disbursement Destination" = CONST(Supplier)) Vendor."No."
            ELSE
            IF ("Disbursement Destination" = CONST("Bank Account")) "Bank Account"."No.";
            Caption = 'Disburse Accounts';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Disbursement Destination" = "Disbursement Destination"::"Bank Account" then begin
                    if BankAcc.Get("Disburse Accounts") then
                        Name := BankAcc.Name;
                end else
                    if "Disbursement Destination" = "Disbursement Destination"::Supplier then begin
                        if Vend.Get("Disburse Accounts") then
                            Name := Vend.Name;
                    end;
            end;
        }
        field(50032; "Special Processing Commission"; Decimal)
        {
            Caption = 'Special Processing Commission';
            DataClassification = CustomerContent;
        }
        field(50033; "Cheque No."; Code[20])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Name"; Text[50])
        {
            Editable = false;
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50035; "Remarks"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50036; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Account Type" <> "Account Type"::Saving then begin
                    "Product Type" := ''
                end;
            end;
        }
        field(50037; "Account No."; Code[100])
        {
            TableRelation = if ("Account Type" = filter(Customer)) Customer."No." where("Account Type" = filter('Employer')) else
            if ("Account Type" = filter("Bank Account")) "Bank Account" where(Blocked = filter(false)) else if ("Account Type" = filter(Saving)) "Account Banking"."No." where("Account Category" = filter(Savings | "Specialty Savings"));
        
            trigger OnValidate()
            begin


            end;
        }
        field(50038; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
            TableRelation = "Product Factory" where("Product Class" = filter(Account), Status = filter(Active), "Account Category" = filter(Savings | "Specialty Savings"));
        }
        field(50039; "Enforce Min. Share Rule"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enforce Min. Shares Rule';
        }
        field(50040; "Enforce Perform Loan Rule"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enforce Performing Loans Rule';
        }
        field(50041; "Posting Type"; Option)
        {
            OptionMembers = " ","Post Application","Generate Batch";
            OptionCaption = ' ,Post Application,Generate Batch';
        }
         field(50042; "Loan Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Loan Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
          
            end;
        }
         field(50043; "No of Loans"; Integer)
        {
            CalcFormula = Count(Loans WHERE("Batch No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'No of Loans';
        }
        field(50044; "Posting Remarks"; Text[50])
        {
            Caption = 'Posting Remarks';
            DataClassification = CustomerContent;
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

    trigger OnDelete()
    begin
        TestField("Approval Status", "Approval Status"::Approved);
    end;

    trigger OnInsert()
    begin

        if "No." = '' then begin
            MembNoSeries.Get;
            MembNoSeries.TestField("Loan Batch Nos");
            "No. Series" := MembNoSeries."Loan Batch Nos";
            if NoSeriesMgt.AreRelated(MembNoSeries."Loan Batch Nos", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;

        if UserSetup.Get(UpperCase(UserId)) then begin
            UserSetup.TestField("Global Dimension 1 Code");
            UserSetup.TestField("Global Dimension 2 Code");
            UserSetup.TestField("Responsibility Centre");
            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            "Responsibility Center" := UserSetup."Responsibility Centre";
            "Prepared By" := UserId;

        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin
        TestField("Approval Status", "Approval Status"::Approved);
    end;

    var
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";
        BankAcc: Record "Bank Account";
        GlEntry: Record "G/L Entry";
        Vend: Record Vendor;
        CustRec: Record Customer;
        CredJnlMgt: Codeunit "Credit. Jnl.-Post Batch";


    procedure CheckRequiredItems()
    begin
        TestField(Date);
        TestField(Remarks);
        TestField("Posting Type");
        if "Payment Type" = "Payment Type"::Refund then
            TestField("Product Type");
        if not PaymentLinesExist() then Error('No line exists on the document');
    end;

    procedure PaymentLinesExist(): Boolean
    var
        PaymentLine: Record "Loan Disbursement Lines";
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange(No, "No.");
        exit(PaymentLine.FindFirst());
    end;

    local procedure TestNoSeries()
    var
        BatchHeader: Record "Loan Disbursement Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not BatchHeader.Get(Rec."No.") then begin
                MembNoSeries.Get();
                NoSeriesMgt.TestManual(MembNoSeries."Loan Batch Nos");
                "No. Series" := '';
            end;
    end;

    procedure CreateEntry()
    begin

        TestField("Approval Status", Rec."Approval Status"::Open);
        CredJnlMgt.CreateBatchLine(Rec."No.", Rec."Payment Type", Rec."Account No.",
                    Rec."Product Type", Rec."Global Dimension 1 Code", Rec."Global Dimension 2 Code");
    end;

    procedure OnPostApplic()
    begin
        Codeunit.Run(Codeunit::"Credit. Jnl.-Post Batch", Rec)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var LoanBatch: Record "Loan Disbursement Header"; xLoanBatch: Record "Loan Disbursement Header"; var IsHandled: Boolean)
    begin
    end;
}




