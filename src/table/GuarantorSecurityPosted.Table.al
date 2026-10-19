table 50558 "Guarantor & Security Posted"
{
    DrillDownPageID = "Guarantors & Security";
    LookupPageID = "Guarantors & Security";
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
            TableRelation = IF ("Security Type" = FILTER(Guarantor)) "Account Credit"."No." WHERE(Status = CONST(Active), "Balance (LCY)" = FILTER(> 0))
            ELSE
            IF ("Security Type" = FILTER(Collateral)) Member."No." WHERE("No." = FIELD("Member No."))
            ELSE
            IF ("Security Type" = FILTER(Lien)) "Account Banking"."No." WHERE(Status = CONST(Active),
                                                                                                                                                                       "Balance (LCY)" = FILTER(> 0));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                UserBranch: Record "User Setup";
                DimValue: Record "Dimension Value";
                AccBanking: Record "Account Banking";
            begin

                "Self Guaranteed" := false;
                Date := Today;
                GenSetUp.Get;

                case "Security Type" of
                    "Security Type"::Guarantor:
                        begin
                            Account.Reset;
                            Account.SetRange("No.", "Account No.");
                            if Account.Find('-') then begin
                                Account.CalcFields("Balance (LCY)");
                                Account.CheckBlockedCustOnJnls(Account, Enum::"Gen. Journal Document Type"::" ", true);
                                "Deposit Shares" := Account."Balance (LCY)";
                                "ID No." := Account."ID/Passport No.";
                                "Member No." := Account."Member No.";
                                Name := Account.Name;
                            end;
                            "Available Shares" := CreditMngt.fnCalculateAvailableShares(
                            Account."No.", "Deposit Shares");
                            Account."Available Shares" := "Available Shares";
                            Account.Modify;
                            if LoansR.Get("Loan No.") then begin
                                "Member No. (Loanee)" := LoansR."Account No.";
                            end;
                            CheckSelfGuarantor
                        end;
                    "Security Type"::Collateral:
                        begin
                        end;
                    "Security Type"::Lien:
                        begin
                            AccBanking.Reset();
                            AccBanking.SetRange("No.", "Account No.");
                            if AccBanking.FindFirst() then begin
                                AccBanking.CalcFields("Balance (LCY)");
                                "Deposit Shares" := AccBanking."Balance (LCY)";
                                "Member No." := AccBanking."Member No.";
                                Name := AccBanking.Name;
                                "Available Shares" := AccBanking."Balance (LCY)";
                            end;
                            if LoansR.Get("Loan No.") then begin
                                "Member No. (Loanee)" := LoansR."Account No.";
                                "Member Name (Loanee)" := LoansR."Account Name";
                            end;

                        end;
                end
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
            FieldClass = FlowField;
            CalcFormula = count("Guarantor & Security Posted" where("Account No." = field("Account No."), Substituted = const(false)));
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
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Loan No." = field("Loan No."), "Posting Date" = field("Date Filter")));
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
        field(50023; "Product Type"; Code[100])
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
            TableRelation = "Collateral Register"."No." WHERE("Account No." = FIELD("Account No."),
                                                               "Chasis No." = CONST('2'));
            Caption = 'Collateral Reg. No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if SecReg.Get("Collateral Reg. No.") then begin
                    "Amount Guaranteed" := SecReg."Collateral Limit";
                    "Collateral Value" := SecReg."Collateral Value";
                    "Available Shares" := SecReg."Collateral Limit";
                end;
                LoanGuar.Reset;
                LoanGuar.SetRange("Collateral Reg. No.", "Collateral Reg. No.");
                LoanGuar.CalcFields("Outstanding Balance");
                LoanGuar.SetFilter("Outstanding Balance", '>0');
                if LoanGuar.Find('-') then begin
                    repeat
                        "Available Shares" := "Available Shares" - LoanGuar."Amount Guaranteed";
                    until LoanGuar.Next = 0;
                end;
                LoanGuar.Reset;
                LoanGuar.SetRange("Collateral Reg. No.", "Collateral Reg. No.");
                LoanGuar.CalcFields("Outstanding Balance");
                LoanGuar.SetFilter("Outstanding Balance", '>0');
                if LoanGuar.Find('-') then begin
                    LoanGuar.CalcFields("Outstanding Balance");
                    Error(Text004, LoanGuar."No.", LoanGuar."Outstanding Balance");
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
        field(50030; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Created By';
        }
        field(50031; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Created';
        }
        field(50032; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified Date';
        }
        field(50033; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Last Modified By';
        }
        field(50034; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
        }
        field(50035; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Approval Status';
        }
        field(50036; "Member No. (Loanee)"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Member No. (Loanee)';
        }
        field(50037; "Member Name (Loanee)"; Text[80])
        {
            Editable = false;
        }
        field(50038; "Member Phone No.(Loanee)"; Text[80])
        {
            Editable = false;
        }
        field(50039; "Member E-Mail (Loanee)"; Text[80])
        {
            Editable = false;
        }
        field(50040; "Member Phone No."; Text[80])
        {
            Editable = false;
        }
        field(50041; "Member E-Mail"; Text[80])
        {
            Editable = false;
        }
        field(50042; "Old Member No."; Code[100])
        {
            Editable = false;
        }
        field(50043; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
    
        field(50044; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key("Key1"; "Entry No.", "No.", "Account No.", "Loan No.")
        {
            Clustered = true;
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
    end;

    trigger OnModify()
    begin
        fnCheckRequirement
    end;

    trigger OnRename()
    begin
        fnCheckRequirement
    end;

    var
        LoansR: Record Loans;
        GenSetUp: Record "General Set-Up";
        LoanApp: Record Loans;
        Text004: Label 'This collateral has been used for loan no. %1 and has a outstanding balance of %2';
        Account: Record "Account Credit";
        CreditMngt: Codeunit "Credit Mgmt.";
        SecReg: Record "Collateral Register";
        LoanGuar: Record "Loan Guarantors and Security";

    local procedure fnCheckRequirement()
    begin
        if LoanApp.Get("No.") then begin
            //LoanApp.TestField("Disbursement Destination", LoanApp."Disbursement Destination"::" ")
        end;
    end;

    local procedure CheckSelfGuarantor()
    var
        LoanGuar: Record "Loan Guarantors and Security";
        ErrorOnselfGuaranteed: Label 'Member has already guaranteed other member and therefore cannot self guarantee.';
    begin
        if LoansR.Get("No.") then begin
            if "Account No." = LoansR."Account No." then
                "Self Guaranteed" := true else
                "Self Guaranteed" := false;
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


    procedure CopyFromLoanGuarantLine(LoanGuarantor: Record "Loan Guarantors and Security")
    begin

        Substituted := LoanGuarantor.Substituted;
        Date := LoanGuarantor.Date;
        "Amount Guaranteed" := LoanGuarantor."Amount Guaranteed";
        "Self Guaranteed" := LoanGuarantor."Self Guaranteed";
        "Member Guaranteed" := LoanGuarantor."Member Guaranteed";
        "Available Shares" := LoanGuarantor."Available Shares";
        "Member No." := LoanGuarantor."Member No.";
        "Product Type" := LoanGuarantor."Product Type";
        "Guaranteed Balance" := LoanGuarantor."Guaranteed Balance";
        "Security Type" := LoanGuarantor."Security Type";
        "Collateral Reg. No." := LoanGuarantor."Collateral Reg. No.";
        "Collateral Value" := LoanGuarantor."Collateral Value";
        "Member No. (Loanee)" := LoanGuarantor."Member No. (Loanee)"
    end;

    procedure CopyFromLoanGuarantLinesub(LoanGuarantor: Record "Loan Guarantors Sub")
    begin

        Date := LoanGuarantor.Date;
        "Amount Guaranteed" := LoanGuarantor."Amount Guaranteed";
        "Member Guaranteed" := LoanGuarantor."Member Guaranteed";
        "Available Shares" := LoanGuarantor."Available Shares";
        "Member No." := LoanGuarantor."Member No";
        "Product Type" := LoanGuarantor."Loan Product Type";
        "Deposit Shares" := LoanGuarantor.Shares;
        "Guaranteed Balance" := LoanGuarantor."Outstanding Balance";
    end;
}




