table 50404 "Other Commitements Clearance"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan No."; Code[50])
        {
            TableRelation = Loans."No.";
            Editable = false;
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanApps: Record "Loan Application";
            begin
                if LoanApps.Get("Application No.") then begin
                    LoanApps.TestField("Mode of Disbursement", LoanApps."Mode of Disbursement"::"Full Disbursement");
                    "Member No." := LoanApps."Account No.";
                end;
            end;
        }
        field(50010; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Payee"; Text[50])
        {
            NotBlank = true;
            Caption = 'Payee';
            DataClassification = CustomerContent;
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                case "EFT Options" of
                    "EFT Options"::"Money Wallet",
                    "EFT Options"::"Mobile Money":
                        begin
                            TestField("Mobile Phone No.");
                        end;
                end;
                if LoanApp.Get("Loan No.") then begin
                    if (Amount > LoanApp."Approved Amount") or (Amount > LoanApp."Amount to Disburse") then Error('Amount cannot be more than approved amount');
                end;
            end;
        }
        field(50013; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50014; "Bankers Cheque No"; Code[20])
        {
            Caption = 'Bankers Cheque No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Bankers Cheque No" <> '' then begin
                    FieldLength("Bankers Cheque No", 6, 6);

                end;
            end;
        }
        field(50015; "Bankers Cheque No 2"; Code[20])
        {
            Caption = 'Bankers Cheque No 2';
            DataClassification = CustomerContent;
        }
        field(50016; "Bankers Cheque No 3"; Code[20])
        {
            Caption = 'Bankers Cheque No 3';
            DataClassification = CustomerContent;
        }
        field(50017; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(50018; "Affects 2/3 Rule"; Boolean)
        {
            Caption = 'Affects 2/3 Rule';
            DataClassification = CustomerContent;
        }
        field(50019; "Monthly Deduction"; Decimal)
        {
            Caption = 'Monthly Deduction';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Monthly Deduction" > 0 then
                    "Affects 2/3 Rule" := true
                else
                    "Affects 2/3 Rule" := false;
            end;
        }
        field(50020; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("Bank Account"), Type = const(Account)) "Bank Account" where(Blocked = const(false)) else
            if ("Account Type" = const(Vendor), Type = const(Account)) Vendor where("Account Type" = filter(" " | Others)) else
            if ("Account Type" = const("External Bank"), Type = const(Account)) Banks;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                case "Account Type" of
                    "Account Type"::"G/L Account":
                        GetGLAccount();
                    "Account Type"::Customer:
                        GetCustomerAccount();
                    "Account Type"::Vendor:
                        GetVendorAccount();
                    "Account Type"::"Bank Account":
                        GetBankAccount();
                    "Account Type"::"External Bank":
                        GetExternalBankAccount();
                end;
                TestField(Amount);
            end;
        }
        field(50021; "Account Name"; Text[50])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50022; "Application No."; Code[100])
        {
            TableRelation = "Loan Application"."No.";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50023; "Account Type"; Enum "MicroCredAccountTypes")
        {
            Caption = 'Account Type';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50024; "Type"; Option)
        {
            OptionMembers = "Account","Micro Finance";
            OptionCaption = 'Account,Micro Finance';
            Editable = false;
        }
        field(50025; "Payment Destination"; Code[100])
        {
            TableRelation = "Cust. Bank Account"."Bank Account No." where(Code = field("Payment Destination Code"));
            DataClassification = CustomerContent;
            Caption = 'Destination A/c';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50026; "Payment Destination Code"; Code[100])
        {
            TableRelation = Banks.Code;
            DataClassification = CustomerContent;
            Caption = 'Pay Point';
        
            trigger OnValidate()
            var
                BanksList: Record Banks;
                LoanApps: Record "Loan Application";
            begin
                if LoanApps.Get("Application No.") then
                    LoanApps.TestField("Mode of Disbursement", LoanApps."Mode of Disbursement"::"Full Disbursement");

                if "EFT Options" <> "EFT Options"::"Money Wallet" then
                    TestField("External Account No.");

                BanksList.Reset();
                BanksList.Setrange(Code, Rec."Payment Destination Code");
                if BanksList.FindFirst() then begin
                    BanksList.TestField("Bank No.");
                    "Bank Name" := BanksList.Name;
                    if BanksList."Institution Type" = BanksList."Institution Type"::Bank then begin
                        Rec."Institution Type" := Rec."Institution Type"::Bank;
                        Rec."Own Reference" := Rec."Member No.";
                        Rec."Society Code" := '';

                    end else begin
                        BanksList.TestField("Society Code");
                        Rec.Validate("External Account No.", BanksList."Society Code");
                        Rec."Institution Type" := Rec."Institution Type"::"Building Society";
                        Rec."Society Code" := BanksList."Society Code";
                        Rec."Own Reference" := Rec."Member No.";
                        Rec."External Account No." := BanksList."Society Code";
                    end;
                    Rec.Validate("Branch Code", BanksList."Bank No.");
                end;
            end;
        }
        field(50027; "Mobile Phone No."; Code[20])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                PhoneCode: Code[10];
            begin
                PhoneCode := '268';
                "Mobile Phone No." := PhoneCode + "Mobile Phone No.";
            end;
        }
        field(50028; "Institution Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Bank","Building Society";
            Editable = false;
        }
        field(50029; "Society Code"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50030; "Branch Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50031; "External Account No."; Text[100])
        {
            Caption = 'External Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if StrLen("External Account No.") > 100 then
                    Error('Destnation account no %1 more than 14 characters.', "External Account No.");
            end;
        }

        field(50032; "Bank Code"; Code[10])
        {
            TableRelation = Banks;
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                BankCodes: Record Banks;
            begin
                BankCodes.Reset;
                BankCodes.SetRange(Code, "Bank Code");
                if BankCodes.Find('-') then
                    "Bank Name" := BankCodes.Name;
            end;
        }
        field(50033; "Branch Code"; Code[10])
        {
            TableRelation = Banks."Bank No.";
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                BankBranch: Record "Bank Branches";
            begin

                BankBranch.Reset();
                BankBranch.SetRange("Branch Code", "Branch Code");
                BankBranch.SetRange("Bank Code", "Bank Code");
                if BankBranch.FindFirst() then
                    "Branch Name" := BankBranch."Branch Name"
            end;
        }
        field(50034; "Bank Name"; Text[100])
        {
            Editable = false;
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(50035; "External Account Name"; Text[250])
        {
            Caption = 'External Account Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var

            begin
            end;
        }
        field(50036; "Own Reference"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50037; "EFT Options"; Enum "EFTPaymentOptions")
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanApps: Record "Loan Application";
                BankAcc: Record "Bank Account";
                BanksList: Record Banks;
            begin
                if LoanApps.Get("Application No.") then begin
                    "Member No." := LoanApps."Account No.";
                    "Own Reference" := "Member No.";
                end;

                if "EFT Options" = "EFT Options"::"Mobile Money" then begin

                    BanksList.Reset();
                    BanksList.Setrange("Bank Type", BanksList."Bank Type"::Mobile);
                    if BanksList.FindFirst() then begin
                        Validate("External Account No.", BanksList."Mobile Money Code");
                        Validate("Payment Destination Code", BanksList.Code);
                    end;
                end;

                if "EFT Options" = "EFT Options"::"Money Wallet" then begin
                    BanksList.Reset();
                    BanksList.Setrange("Bank Type", BanksList."Bank Type"::Mobile);
                    if BanksList.FindFirst() then begin
                        Validate("Payment Destination Code", BanksList.Code);
                    end;
                end;
            end;
        }
        field(50038; "Member No."; Code[20])
        {
            TableRelation = Member."No." where(Status = filter(Active|New));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            var
                ObjCust: Record Member;
                ErrorMembAgeTxt: Label 'Member due to retire before loan repayment is complete. Do you wish to continue?';
                STermLoan: Record Loans;
                MaxLoan: Decimal;
                SalDetails: Record "Appraisal Salary Details";
                TestD: Integer;
            begin

            end;
        }
        field(50039; "Recipient Reference"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50040; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50041; "EFT No."; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "EFT Transfer Header";
        }
        field(50042; "EFT Line No."; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "EFT Transfer Lines";
        }
        field(50043; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }

        field(50044; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50045; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Time Posted';
        }
        field(50046; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50047; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                appStatus: Enum ApprovalStatus;
            begin

            end;
        }
        field(50048; "Disbursement Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

    
        field(50049; "No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Loans;
        }
    }
    keys
    {
        key("Key1"; "Loan No.", "Account No.", "Application No.", "Entry No.")
        {
            Clustered = true;
            SumIndexFields = "Amount";
        }
    }

    fieldgroups
    {
    }


    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure GetGLAccount()
    var
        BankAcc: Record "G/L Account";
    begin
        BankAcc.Get("Account No.");
        BankAcc.TestField(Blocked, false);
        UpdateDescription(BankAcc.Name);
    end;

    procedure GetBankAccount()
    var
        BankAcc: Record "Bank Account";
    begin
        BankAcc.Get("Account No.");
        BankAcc.TestField(Blocked, false);
        UpdateDescription(BankAcc.Name);
    end;

    procedure GetCustomerAccount()
    var
        BankAcc: Record Customer;
    begin
        BankAcc.Get("Account No.");
        BankAcc.TestField(Blocked, BankAcc.Blocked::" ");
        UpdateDescription(BankAcc.Name);

    end;

    procedure GetVendorAccount()
    var
        BankAcc: Record Vendor;
    begin
        BankAcc.Get("Account No.");
        BankAcc.TestField(Blocked, BankAcc.Blocked::" ");
        UpdateDescription(BankAcc.Name);
    end;

    procedure GetExternalBankAccount()
    var
        BankAcc: Record Banks;
    begin
        BankAcc.Reset();
        BankAcc.SetRange(Code, "Account No.");
        if BankAcc.FindFirst() then
            UpdateDescription(BankAcc.Name);
    end;

    procedure UpdateDescription(Name: Text[100])
    begin
        if not IsAdHocDescription() then
            "Account Name" := Name;
    end;

    procedure FieldLength(VarVariant: Text; MinLength: Integer; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be less than %1 or more than %2 Characters.';
    begin
        if (StrLen(VarVariant) < MinLength) or (StrLen(VarVariant) > FldLength) then
            Error(FieldLengthError, MinLength, FldLength);
    end;

    local procedure IsAdHocDescription() Result: Boolean
    var
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        Employee: Record Employee;
        IsHandled: Boolean;
    begin

        case xRec."Account Type" of
            xRec."Account Type"::"G/L Account":
                exit(GLAccount.Get(xRec."Account No.") and (GLAccount.Name <> Description));
            xRec."Account Type"::Customer:
                exit(Customer.Get(xRec."Account No.") and (Customer.Name <> Description));
            xRec."Account Type"::Vendor:
                exit(Vendor.Get(xRec."Account No.") and (Vendor.Name <> Description));
            xRec."Account Type"::"Bank Account":
                exit(BankAccount.Get(xRec."Account No.") and (BankAccount.Name <> Description));
            xRec."Account Type"::"Fixed Asset":
                exit(FixedAsset.Get(xRec."Account No.") and (FixedAsset.Description <> Description));
            xRec."Account Type"::"IC Partner":
                exit(ICPartner.Get(xRec."Account No.") and (ICPartner.Name <> Description));
            xRec."Account Type"::Employee:
                exit(Employee.Get(xRec."Account No.") and (Employee.FullName() <> Description));
        end;
        exit(false);
    end;

    procedure GetTotalCommit(AppNo: Code[50]): Decimal
    Var
        TotalCommittment: Decimal;
    begin
        OtherCommitment.Reset();
        OtherCommitment.SetRange(Posted, false);
        OtherCommitment.SetRange("Application No.", AppNo);
        OtherCommitment.SetRange("Approval Status", OtherCommitment."Approval Status"::Posted);
        if OtherCommitment.Find('-') then begin
            OtherCommitment.CalcSums(Amount);
            exit(OtherCommitment.Amount)
        end;
        exit(0)
    end;

    var
        Text001: Label 'You cannot modify/delete this record since the loan is already %1';
        Vend: Record Vendor;
        OtherCommitment: Record "Other Commitements Clearance";
        LoanApp: Record Loans;
}




