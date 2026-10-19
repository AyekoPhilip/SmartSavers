table 50379 "Standing Order Lines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Destination Account Type"; Enum "AccountTypesExtended")
        {
            Caption = 'Destination Account Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                STOLines: Record "Standing Order Lines";
                LoanAc: Record Loans;
                AccBank: Record "Account Banking";
            begin


            end;
        }
        field(50012; "Destination Account No."; Code[50])
        {
            Caption = 'Destination Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Destination Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Destination Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Destination Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Destination Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Destination Account Type" = CONST(Employee)) Employee
            ELSE
            IF ("Destination Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Destination Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Destination Account Type" = CONST(Savings)) "Account Banking" where(Status = filter(Active | New | Dormant | Defaulter | Withdrawn | Blocked))
            ELSE
            IF ("Destination Account Type" = CONST(Credit)) "Account Credit" where(Status = filter(Active | New | Dormant | Defaulter | Withdrawn | Blocked))
            ELSE
            IF ("Destination Account Type" = CONST(Loan)) "Credit Account"."No." where(Status = filter(Active | New | Dormant | Defaulter | Withdrawn | Blocked))
            ELSE
            IF ("Destination Account Type" = CONST(Prepayment)) "Repayment Account";
        
            trigger OnValidate()
            var
                STOLines: Record "Standing Order Lines";
                LoanAc: Record Loans;
                AccBank: Record "Account Banking";
                AccCredit: Record "Account Credit";
                Bnk: Record "Bank Account";
                GLAcc: Record "G/L Account";
            begin

                case "Destination Account Type" of
                    "Destination Account Type"::Savings:
                        begin
                            if AccBank.Get("Destination Account No.") then
                                "Destination Account Name" := AccBank.Name;
                        end;
                    "Destination Account Type"::Credit:
                        begin
                            if AccCredit.Get("Destination Account No.") then
                                "Destination Account Name" := AccCredit.Name;
                        end;
                    "Destination Account Type"::Loan:
                        begin
                            LoanAc.Reset();
                            LoanAc.SetRange("Loan Account", "Destination Account No.");
                            if LoanAc.Find('-') then
                                "Destination Account Name" := LoanAc."Product Description";
                        end;
                    "Destination Account Type"::"G/L Account":
                        begin
                            if GLAcc.Get("Destination Account No.") then
                                "Destination Account Name" := GLAcc.Name;
                        end;
                    "Destination Account Type"::"Bank Account":
                        begin
                            if Bnk.get("Destination Account Name") then
                                "Destination Account Name" := Bnk.Name;
                        end;
                end;

                /* STOLines.RESET;
                STOLines.SETRANGE(STOLines."Document No.","Document No.");
                IF STOLines.FIND('-')=TRUE THEN BEGIN
                IF STOLines.COUNT>1 THEN
                  ERROR('Only one entry is allowed for this type of standing order, Please delete the lines before proceeding');
                END;   */
            end;
        }
        field(50013; "Destination Account Name"; Text[80])
        {
            Editable = false;
            Caption = 'Destination Account Name';
            DataClassification = CustomerContent;
        }
        field(50014; "Loan No."; Code[20])
        {
            TableRelation = IF ("Destination Account No." = FILTER(<> '')) Loans WHERE("Loan Account" = FIELD("Destination Account No."), "Outstanding Balance" = filter(> 0));
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Loan: Record Loans;
            begin
                if Loan.Get("Loan No.") then
                    Loan.CalcFields("Outstanding Balance");
                Amount := Loan.Repayment;
                if Amount > Loan."Outstanding Balance" then
                    Amount := Loan."Outstanding Balance";
            end;
        }
        field(50015; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanApp: Record Loans;
            begin
                if Amount < 0 then
                    Error(LessThanZeroAmount);
                if "Destination Account Type" = "Destination Account Type"::Loan then begin
                    if "Loan No." = '' then
                        Error('Kindly specify the loan no. before proceeding');
                    if loanapp.get("Loan No.") then
                        LoanApp.CalcFields("Outstanding Principal", "Outstanding Interest");
                    if Amount > LoanApp."Outstanding Principal" then
                        Amount := LoanApp."Outstanding Principal";
                end;
                "Amount LCY" := Amount;
            end;
        }
        field(50016; "Bank Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Bank Code";
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Destination Account Type" = "Destination Account Type"::Employee then
                    Error('Only applicable FOR external STOs');

                BankCodeStructure.Reset;
                BankCodeStructure.SetRange(BankCodeStructure."Bank Code", "Bank Code");
                if BankCodeStructure.Find('-') then
                    "Bank Name" := BankCodeStructure."Bank Name";
            end;
        }
        field(50017; "Branch Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Branch Code";
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Destination Account Type" <> "Destination Account Type"::"Bank Account" then
                    Error('Only applicable for external STOs');

                BankCodeStructure.Reset;
                BankCodeStructure.SetRange(BankCodeStructure."Branch Code", "Branch Code");
                if BankCodeStructure.Find('-') then begin
                    "Bank Code" := BankCodeStructure."Bank Code";
                    "Bank Name" := BankCodeStructure."Bank Name";
                    "Branch Name" := BankCodeStructure.Branch;
                end;

                if "Branch Code" = '' then begin
                    "Bank Code" := '';
                    "Bank Name" := '';
                    "Bank Account No." := '';
                end;
            end;
        }
        field(50018; "Bank Name"; Text[100])
        {
            Editable = false;
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Destination Account Type" <> "Destination Account Type"::"Bank Account" then
                    Error('Only applicable for external STOs');
            end;
        }
        field(50019; "Bank Account No."; Code[15])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Destination Account Type" <> "Destination Account Type"::"Bank Account" then
                    Error('Only applicable for external STOs');

                if "Destination Account Type" = "Destination Account Type"::"Bank Account" then begin
                    if StrLen("Bank Account No.") <> 13 then
                        Error('Invalid Bank account No. Please enter the correct Bank Account No.');
                end;
            end;
        }
        field(50020; "Balance"; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(50021; "Branch Name"; Text[150])
        {
            Caption = 'Branch Name';
            DataClassification = CustomerContent;
        }
        field(50022; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50023; "Status"; Enum "STOApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                if Status = Status::Stopped then begin
                    Amount := 0
                end;
            end;
        }
        field(50024; "Amount LCY"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50025; "Selected"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Stop Obligation';
        
            trigger OnValidate()
            begin
                Amount := 0;
                Status := Status::Stopped;
            end;
        }
    }

    keys
    {
        key("Key1"; "Document No.", "Destination Account No.", "Loan No.")
        {
            Clustered = true;
        }
        key("Key2"; "Destination Account Type")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Validate("Destination Account Type");
        if STOHeader.Get("Document No.") then begin
            "Member No." := STOHeader."Member No.";
        end;
    end;

    trigger OnModify()
    begin
        if STOHeader.Get("Document No.") then begin
            "Member No." := STOHeader."Member No.";
            STOHeader.TestField("Approval Status", STOHeader."Approval Status"::Open);
        end;
    end;

    var
        Account: Record "Account Banking";
        BankAcc: Record "Bank Account";
        BankCodeStructure: Record "Bank Code Structure";
        Cust: Record "Credit Account";
        LessThanZeroAmount: Label 'Amount cannot be less than zero (0)';
        STOHeader: Record "Standing Order Header";
}




