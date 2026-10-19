table 50462 "Loan Guarantors Sub"
{
    DataClassification = CustomerContent;


    fields
    {
        field(50009; "Loan No"; Code[20])
        {
            NotBlank = true;
            TableRelation = Loans."No.";
            Caption = 'Loan No';
            DataClassification = CustomerContent;
        }
        field(50010; "Member No"; Code[20])
        {
            Editable = false;
            NotBlank = false;
            Caption = 'Member No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50011; "Name"; Text[200])
        {
            Editable = false;
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Loan Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Loan Balance';
            DataClassification = CustomerContent;
        }
        field(50013; "Shares"; Decimal)
        {
            Editable = false;
            Caption = 'Shares';
            DataClassification = CustomerContent;
        }
        field(50014; "No Of Loans Guaranteed"; Integer)
        {
            Editable = false;
            Caption = 'No Of Loans Guaranteed';
            DataClassification = CustomerContent;
        }
        field(50015; "Substituted"; Boolean)
        {
            Caption = 'Substituted';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                GuarantHeader: Record "Guarantors Substitution";
                ErrorOnWrngMatch: Label 'You can only subsitute account No. %1 selected on the header. %2';
            begin
                GuarantHeader.Reset();
                GuarantHeader.SetRange("No.", "No.");
                GuarantHeader.SetRange("Guarantors To Be Substituted", "Savings Account No.");
                if not GuarantHeader.Find('-') then
                    Error(ErrorOnWrngMatch, GuarantHeader."Guarantors To Be Substituted", GuarantHeader.Name);
            end;
        }
        field(50016; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50017; "Shares Recovery"; Boolean)
        {
            Caption = 'Shares Recovery';
            DataClassification = CustomerContent;
        }
        field(50018; "New Upload"; Boolean)
        {
            Caption = 'New Upload';
            DataClassification = CustomerContent;
        }
        field(50019; "Amount Guaranteed"; Decimal)
        {
            Caption = 'Amount Guaranteed';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Aggmngt: Record "Guarantor & Security Posted";
            begin
                TestField(Shares);
                TestField("Savings Account No.");
                if "Amount Guaranteed" > Shares then
                    "Amount Guaranteed" := Shares;
                if Aggmngt.Get("No.") then
                    "Loan No" := Aggmngt."Loan No.";

                if getGuarantSubAmount() > 0 then begin
                    if "Amount Guaranteed" < getGuarantSubAmount() then Error(ErrorInfo, getGuarantSubAmount());
                end else begin
                    Error('Amount Guaranteed cannot be zero %1', "Loan No");
                end;


            end;
        }
        field(50020; "Staff/Payroll No."; Code[20])
        {
            Caption = 'Staff/Payroll No.';
            DataClassification = CustomerContent;
        }
        field(50021; "Self Guarantee"; Boolean)
        {
            Caption = 'Self Guarantee';
            DataClassification = CustomerContent;
        }
        field(50022; "ID No."; Code[50])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50023; "Outstanding Balance"; Decimal)
        {
            CalcFormula = Sum("Loan Ledger Entry".Amount WHERE("Transaction Type" = FILTER(Loan | Repayment),
                                                                "Loan No." = FIELD("Loan No")));
            FieldClass = FlowField;
            Caption = 'Outstanding Balance';
        }
        field(50024; "Member Guaranteed"; Code[50])
        {
            Caption = 'Member Guaranteed';
            DataClassification = CustomerContent;
        }
        field(50025; "Group Account No."; Code[50])
        {
            Caption = 'Group Account No.';
            DataClassification = CustomerContent;
        }
        field(50026; "Loan Product Type"; Code[20])
        {
            Caption = 'Loan Product Type';
            DataClassification = CustomerContent;
        }
        field(50027; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50028; "Line No."; Code[10])
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Savings Account No."; Code[20])
        {
            TableRelation = "Account Credit"."No." where(Status = const(Active), "Balance (LCY)" = filter(> 0), Blocked = const(" "), "Account Category" = const("Shares Deposit"));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Accredit: Record "Account Credit";
                Aggmngt: Record "Guarantor & Security Posted";
                PLoan: Record Loans;
                SubLine: Record "Loan Guarantors Sub";
                AccBanking: Record "Account Banking";
            begin
                GenSetUp.Get();
                case "Security Type" of
                    "Security Type"::Lien:
                        begin
                            
                            if AccBanking.Get("Savings Account No.") then begin
                                AccBanking.CalcFields("Balance (LCY)");
                                Name := AccBanking.Name;
                                Shares := AccBanking."Balance (LCY)";
                                "Amount Guaranteed" := AccBanking."Balance (LCY)";
                                "Available Shares" := AccBanking."Balance (LCY)";
                                SubLine.Reset();
                                SubLine.SetRange("No.", "No.");
                                if SubLine.FindFirst() then
                                    "Loan No" := SubLine."Loan No";
                            end;
                        end;
                    "Security Type"::Collateral,
                    "Security Type"::Guarantor:
                        begin
                            if Accredit.Get("Savings Account No.") then begin
                                Accredit.CalcFields("Balance (LCY)");
                                Name := Accredit.Name;
                                Shares := Accredit."Balance (LCY)";
                                "Amount Guaranteed" := Accredit."Balance (LCY)";
                                "Available Shares" := Accredit."Balance (LCY)";
                                SubLine.Reset();
                                SubLine.SetRange("No.", "No.");
                                if SubLine.FindFirst() then
                                    "Loan No" := SubLine."Loan No";
                            end;
                        end;
                end;
            end;
        }
        field(50030; "SMS Sent"; Boolean)
        {
            Caption = 'SMS Sent';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50031; "Member Substituted"; Code[20])
        {
            TableRelation = "Account Banking";
            Caption = 'Member Substituted';
            DataClassification = CustomerContent;
        }
        field(50032; "Outstanding Liability"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Outstanding Liability';
        }
        field(50033; "Available Shares"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Available Shares';
        }

        field(50034; "Application No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Application No.';
        }
        field(50035; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted';
            Editable = false;
        }
        field(50036; "Non Subsituted"; Boolean)
        {
            Editable = false;
        }
        field(50037; "Ignored"; Boolean)
        {

        }
        field(31; "Security Type"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien';
            OptionMembers = Guarantor,Collateral,Lien;
            Caption = 'Security Type';
            DataClassification = CustomerContent;
        }
    }


    keys
    {
        key("Key1"; "No.", "Savings Account No.", "Member Substituted", "Loan No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CreditAccounts: Record "Credit Account";
        GHeader: Record "Guarantors Substitution";
        Lno: Code[50];
        GenSetUp: Record "General Set-Up";
        ErrorInfo: Label 'Amount Guaranteed cannot be less than %1';

    trigger OnDelete()
    begin
        TestField("Non Subsituted", false);

    end;

    procedure getGuarantSubAmount(): Decimal
    var
        Agreement: Record "Guarantor & Security Posted";
        GuarantHeader: Record "Guarantors Substitution";
    begin
        GuarantHeader.SetRange("No.", "No.");
        if GuarantHeader.FindFirst() then begin
            Agreement.Reset();
            Agreement.SetRange("Account No.", GuarantHeader."Guarantors To Be Substituted");
            if Agreement.Find('-') then begin
                exit("Amount Guaranteed")
            end;
            exit(0)
        end;
        exit(0)
    end;
}




