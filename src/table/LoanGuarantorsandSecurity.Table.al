table 50400 "Loan Guarantors and Security"
{
    DrillDownPageID = "Loan Guarantors and Security";
    LookupPageID = "Loan Guarantors and Security";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            NotBlank = false;
            TableRelation = "Loan Application"."No.";
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[100])
        {
            TableRelation = if ("Security Type" = filter(Guarantor)) "Account Credit"."No." where(Status = filter(Active | Dormant),
            "Balance (LCY)" = filter(> 0), "Account Category" = const("Shares Deposit"), "Can Guarantee Loan" = const(true))
            else
            if ("Security Type" = filter(Collateral)) Member."No." where("No." = field("Member No. (Loanee)"))
            else
            if ("Security Type" = filter(Lien)) "Account Banking"."No." where(Status = const(Active), "Balance (LCY)" = filter(> 0));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                BankingAc: Record "Account Banking";

            begin

                GenSetUp.Get;
                GenSetUp.TestField("Guarantorship Option");
                if GenSetUp."Guarantorship Option" = GenSetUp."Guarantorship Option"::"Shares Multiplier" then
                    GenSetUp.TestField("Guarantors Multiplier");

                "Self Guaranteed" := false;
                Date := Today;

                if LoansR.Get("No.") then begin
                    "Product Type" := LoansR."Product Type";
                    case "Security Type" of
                        "Security Type"::Guarantor:
                            begin
                                Account.Reset;
                                Account.SetRange("No.", "Account No.");
                                Account.SetRange("Can Guarantee Loan", true);
                                if Account.Find('-') then begin
                                    Account.CalcFields("Balance (LCY)");
                                    GenSetUp.TestField("Max Loans To Guarantee");
                                    if CreditMngt.NoOfGuarantor("Account No.") > GenSetUp."Max Loans To Guarantee" then
                                        Error(Text005);
                                    Account.CheckBlockedCustOnJnls(Account, Enum::"Gen. Journal Document Type"::" ", true);

                                    if RegMngt.CheckifCustHasSelfGuaranteed(Account."Member No.") then
                                        Error(MessageOnSelfGuarant);

                                    CustRecord.Reset();
                                    CustRecord.SetRange("No.", Account."Member No.");
                                    if CustRecord.FindFirst() then begin
                                        CustRecord.TestField("Member Category");

                                        if RegMngt.CheckCustDefaulterStatus(CustRecord."No.", true) then
                                            Error(ErrorOnLoanstatus);

                                        MembCat.Reset();
                                        MembCat.SetRange("No.", CustRecord."Member Category");
                                        if MembCat.FindFirst() then begin
                                            if MembCat."Cannot Guarantee Loan" then
                                                Error(Text0005, MembCat."No.");
                                        end;
                                    end;

                                    "Deposit Shares" := Account."Balance (LCY)";
                                    "ID No." := Account."ID/Passport No.";
                                    "Member No." := Account."Member No.";
                                     Name := Account.Name;
                                end;

                                case GenSetUp."Guarantorship Option" of
                                    GenSetUp."Guarantorship Option"::"Available Shares":
                                        begin
                                            "Available Shares" := CreditMngt.fnCalculateAvailableShares(Account."No.", "Deposit Shares");
                                        end;
                                    GenSetUp."Guarantorship Option"::"Amount Guaranteed",
                                    GenSetUp."Guarantorship Option"::Deposits:
                                        begin

                                            GenSetUp.TestField("Max. Amount to Guarantee");
                                            "Available Shares" := "Deposit Shares";
                                        end;

                                    GenSetUp."Guarantorship Option"::"Shares Multiplier":
                                        begin
                                            "Available Shares" := ("Deposit Shares" * GenSetUp."Guarantors Multiplier");
                                        end;
                                end;
                                Account."Available Shares" := "Available Shares";
                                Account.Modify;
                                CheckSelfGuarantor
                            end;
                        "Security Type"::Lien:
                            begin
                                BankingAc.Reset;
                                BankingAc.SetRange("No.", "Account No.");
                                if BankingAc.Find('-') then begin
                                    BankingAc.CalcFields("Balance (LCY)");
                                    Name := Account.Name;
                                    "Amount Guaranteed" := BankingAc."Balance (LCY)";
                                    "Deposit Shares" := BankingAc."Balance (LCY)";
                                    "Available Shares" := BankingAc."Balance (LCY)";
                                end;
                            end;
                        "Security Type"::Collateral:
                            begin
                                Account.Reset;
                                Account.SetRange("Member No.", "Member No. (Loanee)");
                                Account.SetRange("Account Category", Account."Account Category"::"Shares Deposit");
                                if Account.Find('-') then begin
                                    Account.CalcFields("Balance (LCY)");
                                    Name := Account.Name;
                                    "Deposit Shares" := Account."Balance (LCY)";
                                end;
                            end
                    end
                end;
                
                if GenSetUp."Guarantorship Option" <> GenSetUp."Guarantorship Option"::"Amount Guaranteed" then
                    Validate("Amount Guaranteed", "Available Shares")
            end;
        }
        field(50011; "Name"; Text[200])
        {
            Editable = false;
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Deposit Shares"; Decimal)
        {
            Editable = false;
            Caption = 'Deposit Shares';
            DataClassification = CustomerContent;
        }
        field(50013; "No. of Loans Guaranteed"; Integer)
        {
            Editable = false;
            Caption = 'No. of Loans Guaranteed';
            DataClassification = CustomerContent;
        }
        field(50014; "Substituted"; Boolean)
        {
            Editable = false;
            Caption = 'Substituted';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Date := Today;
            end;
        }
        field(50015; "Date"; Date)
        {
            Editable = false;
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50016; "Amount Guaranteed"; Decimal)
        {
            Caption = 'Amount Guaranteed';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                GenSetUp.Get();

                if "Amount Guaranteed" > "Available Shares" then
                    "Amount Guaranteed" := "Available Shares";

                case GenSetUp."Guarantorship Option" of
                    GenSetUp."Guarantorship Option"::"Amount Guaranteed",
                        GenSetUp."Guarantorship Option"::"Available Shares":
                        begin
                            GenSetUp.TestField("Max. Amount to Guarantee");
                            if "Amount Guaranteed" > GenSetUp."Max. Amount to Guarantee" then
                                Error(ErrotOnMaxAmountToGuarant,GenSetUp."Max. Amount to Guarantee");
                        end;
                end;
            end;
        }
        field(50017; "Self Guaranteed"; Boolean)
        {
            Editable = false;
            Caption = 'Self Guaranteed';
            DataClassification = CustomerContent;
        }
        field(50018; "ID No."; Code[50])
        {
            Editable = false;
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Outstanding Balance"; Decimal)
        {
            CalcFormula = Sum("Loan Ledger Entry".Amount where("Member No." = field("Member No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Outstanding Balance';
        }
        field(50020; "Member Guaranteed"; Code[50])
        {
            Editable = false;
            Caption = 'Member Guaranteed';
            DataClassification = CustomerContent;
        }
        field(50021; "Available Shares"; Decimal)
        {
            Editable = false;
            Caption = 'Available Shares';
            DataClassification = CustomerContent;
        }
        field(50022; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Member."No.";
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50023; "Product Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50024; "Guaranteed Balance"; Decimal)
        {
            Caption = 'Guaranteed Balance';
            DataClassification = CustomerContent;
        }
        field(50025; "Security Type"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien';
            OptionMembers = "Guarantor","Collateral","Lien";
            Caption = 'Security Type';
            DataClassification = CustomerContent;
        }
        field(50026; "Collateral Reg. No."; Code[20])
        {
            TableRelation = "Collateral Register"."No." WHERE("Account No." = FIELD("Account No."), "Approval Status" = const(Approved));
            Caption = 'Collateral Reg. No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                SecReg.Reset();
                SecReg.SetRange("No.", "Collateral Reg. No.");
                if SecReg.Find('-') then begin
                    "Amount Guaranteed" := SecReg."Forced Sale Value";
                    "Collateral Value" := SecReg."Collateral Value";
                    "Available Shares" := SecReg."Forced Sale Value";
                end;

                LoanGuar.Reset;
                LoanGuar.SetRange("Collateral Reg. No.", "Collateral Reg. No.");
                LoanGuar.CalcFields("Outstanding Balance");
                LoanGuar.SetFilter("Outstanding Balance", '>0');
                if LoanGuar.Find('-') then begin
                    LoanGuar.CalcFields("Outstanding Balance");

                    LoansR.Reset();
                    LoansR.SetRange("No.", "No.");
                    if LoansR.FindFirst() then begin
                        LoansR.CalcFields("Total TopUp");
                        if LoansR."Total TopUp" = 0 then
                            Error(Text004, LoanGuar."No.", LoanGuar."Outstanding Balance");
                    end;

                end;
            end;
        }
        field(50027; "Collateral Value"; Decimal)
        {
            Editable = false;
            Caption = 'Collateral Value';
            DataClassification = CustomerContent;
        }
        field(50028; "Notification Sent"; Boolean)
        {
            Editable = false;
            Caption = 'Notification Sent';
            DataClassification = CustomerContent;
        }
        field(50029; "Member Substituted"; Code[20])
        {
            Editable = false;
            Caption = 'Member Substituted';
            DataClassification = CustomerContent;
        }
        field(50030; "Guarantor A/c No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Member;
            Caption = 'Guarantor A/c No.';
        }
        field(50031; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Created By';
        }
        field(50032; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Created';
        }
        field(50033; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified Date';
        }
        field(50034; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Last Modified By';
        }
        field(50035; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
        }
        field(50036; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Deffered,Posted';
            OptionMembers = "Open","Pending Approval","Approved","Rejected","Deffered","Posted";
            Caption = 'Approval Status';
        }
        field(50037; "Member No. (Loanee)"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Loan Application"."Account No.";
            Caption = 'Member No. (Loanee)';
        }
        field(50038; "Total Loan Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Total Loan Balance';
        }
        field(50039; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            AutoIncrement = true;
        }
    }

    keys
    {
        key("Key1"; "No.", "Account No.", "Loan No.", "Member No. (Loanee)", "Collateral Reg. No.")
        {
            Clustered = true;
        }
        key("Key2"; "Entry No.")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        fnCheckRequirement
    end;

    trigger OnInsert()
    begin
        "Self Guaranteed" := false;
        Date := Today;
        "Date Created" := CurrentDateTime;
        "Created By" := UserId
    end;

    trigger OnModify()
    begin
        fnCheckRequirement;
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;
    end;

    trigger OnRename()
    begin
        fnCheckRequirement
    end;

    var
        LoansR: Record "Loan Application";
        GenSetUp: Record "General Set-Up";
        LoanApp: Record Loans;
        RegMngt: Codeunit "Register Management";
        Text004: Label 'This collateral has been used for loan no. %1 and has a outstanding balance of %2';
        Text0005: Label 'Members under Category %1 are not allowed to guarantee Loan';
        MessageOnSelfGuarant: Label 'Member has an existing Active Loan that is self-Guaranteed';
        ErrorOnLoanstatus: Label 'Member has a loan defaulted previously';
        ErrotOnMaxAmountToGuarant: Label 'Member cannot Guarantee more than Max. amount of %1';
        Account: Record "Account Credit";
        CreditMngt: Codeunit "Credit Mgmt.";
        SecReg: Record "Collateral Register";
        LoanGuar: Record "Guarantor & Security Posted";
        MembCat: Record "Member Category";
        CustRecord: Record Member;
        Text005: Label 'Member has guarantee more than max. no. of loan required.';

    local procedure fnCheckRequirement()
    var
        GuarantDetail: Record "Loan Guarantors and Security";
        CredAccount: Record "Account Credit";
    begin
        if LoanApp.Get("No.") then begin
            LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
            if LoanApp."Self Guarantee" then begin
                CredAccount.SetRange("Member No.", LoanApp."Account No.");
                CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Deposit");
                if CredAccount.FindFirst() then begin
                    if CredAccount."No." = "Account No." then
                        LoanApp."Self Guarantee" := false;
                    LoanApp.Modify(true)
                end;
            end;
        end;
    end;

    local procedure CheckSelfGuarantor()
    var
        LoanGuar: Record "Guarantor & Security Posted";
        ErrorOnselfGuaranteed: Label 'Member has already guaranteed other member and therefore cannot self guarantee.';
    begin
        if LoansR.Get("No.") then begin
            if "Account No." = LoansR."Account No." then begin
                "Self Guaranteed" := true;
                LoansR."Self Guarantee" := true;
                LoansR.Modify(true);
            end
            else begin
                "Self Guaranteed" := false;
            end;
            if "Self Guaranteed" then begin
                LoanGuar.Reset;
                LoanGuar.SetRange("Account No.", "Account No.");
                LoanGuar.SetFilter("Outstanding Balance", '>0');
                if LoanGuar.Find('-') then begin
                    LoanGuar.CalcFields("Outstanding Balance");
                    Error(ErrorOnselfGuaranteed);
                end;
            end;
        end
    end;
}




