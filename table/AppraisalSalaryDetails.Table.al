table 50405 "Appraisal Salary Details"
{
    DrillDownPageID = "Appraisal Salary Details";
    LookupPageID = "Appraisal Salary Details";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Client Code"; Code[20])
        {
            Editable = false;
            TableRelation = Member."No.";
            Caption = 'Client Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Appraisal Salary Set-up";
            Caption = 'Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "SalarySet-up".Get(Code) then begin
                    Description := "SalarySet-up".Description;
                    Type := "SalarySet-up".Type;
                end;
            end;
        }
        field(50011; "Description"; Text[30])
        {
            Editable = false;
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Type"; Enum "AppraisalSalaryDetailsOptions")
        {
            Editable = false;
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if (Type = Type::"Net Pay") or (Type = Type::"Gross Pay") or (Type = Type::"Take Home") or (Type = Type::Banding) or (Type = Type::"Sacco Deduction") then
                    Error(Text002);

                case Type of
                    Type::Basic:
                        begin

                            ApprDetails.Reset;
                            ApprDetails.SetRange(Type, Type::Banding);
                            ApprDetails.SetRange("Client Code", "Client Code");
                            ApprDetails.SetRange("Loan Application No.", "Loan Application No.");
                            if ApprDetails.Find('-') then begin
                                ApprDetails.Amount := CredMngt.CreateLoanSharesBanding("Client Code",
                                "Loan Application No.");
                                ApprDetails.Modify(true)
                            end;

                            ApprDetails.Reset;
                            ApprDetails.SetRange(Type, Type::"Sacco Deduction");
                            ApprDetails.SetRange("Client Code", "Client Code");
                            ApprDetails.SetRange("Loan Application No.", "Loan Application No.");
                            if ApprDetails.Find('-') then begin
                                ApprDetails.Amount := CredMngt.getSaccoLoanDeduction("Client Code");
                                ApprDetails.Modify(true)
                            end;

                            ApprDetails.Reset;
                            ApprDetails.SetRange(Type, Type::Bridge);
                            ApprDetails.SetRange("Client Code", "Client Code");
                            ApprDetails.SetRange("Loan Application No.", "Loan Application No.");
                            if ApprDetails.Find('-') then begin
                                ApprDetails.Amount := CredMngt.getBridgeReleaseAmt("Loan Application No.");
                                ApprDetails.Modify(true)
                            end;

                            ApprDetails.Reset;
                            ApprDetails.SetRange(Type, Type::"Gross Pay");
                            ApprDetails.SetRange("Client Code", "Client Code");
                            ApprDetails.SetRange("Loan Application No.", "Loan Application No.");
                            if ApprDetails.Find('-') then begin
                                ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                                ApprDetails.Modify(true)
                            end;
                        end;

                    Type::"Other Allowances",
                    Type::Earnings:
                        begin

                            ApprDetails.Reset;
                            ApprDetails.SetRange(Type, Type::"Gross Pay");
                            ApprDetails.SetRange("Client Code", "Client Code");
                            ApprDetails.SetRange("Loan Application No.", "Loan Application No.");
                            if ApprDetails.Find('-') then begin
                                ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                                ApprDetails.Modify(true)
                            end;
                        end;
                end;

            end;
        }
        field(50014; "No."; Code[20])
        {
            Editable = false;
            TableRelation = Loans;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if LoanApp.Get("No.") then
                    "Client Code" := LoanApp."Account No.";
            end;
        }
        field(50015; "Loan Application No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Loan Application No.';
        }
        field(50016; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Created By';
        }
        field(50017; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Created';
        }
        field(50018; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified Date';
        }
        field(50019; "Auto Computed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.", "Client Code", "Code", "Loan Application No.")
        {
            Clustered = true;
        }
        key("Key2"; "Code", "Client Code", "Type")
        {
            SumIndexFields = "Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LoanApp.Get("Loan Application No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Deffered then
                LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Date Created" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        if LoanApp.Get("Loan Application No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Deffered then
                //LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
        "Last Modified Date" := CurrentDateTime
    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan Application No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Deffered then
                //LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
        "Last Modified Date" := CurrentDateTime
    end;

    var
        "SalarySet-up": Record "Appraisal Salary Set-up";
        LoanApp: Record "Loan Application";
        Text002: Label 'Do not capture anything here';
        ApprDetails: Record "Appraisal Salary Details";
        CredMngt: Codeunit "Credit Mgmt.";
}




