table 50096 "Pr Employee Transaction"
{
    Caption = 'Pr Employee Transaction';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            TableRelation = "HR Employees";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            TableRelation = "Pr Transaction Code";
        
            trigger OnValidate()
            begin

                EmployeeTrans.Reset();
                EmployeeTrans.SetRange("Transaction Code", "Transaction Code");
                EmployeeTrans.SetRange("Employee Code", "Employee Code");
                EmployeeTrans.SetRange("Payroll Period", "Payroll Period");
                if EmployeeTrans.Find('-') then begin
                    Error(ErrorOnExistCode, "Transaction Code", "Employee Code");
                end;

                PrTransCode.Reset();
                PrTransCode.SetRange(Code, "Transaction Code");
                if PrTransCode.FindFirst() then begin

                    "Transaction Name" := PrTransCode.Name;
                    "Transaction Type" := PrTransCode."Transaction Type";
                    if PrTransCode."Account Type" = PrTransCode."Account Type"::"G/L Account" then begin
                        "Account Type" := PrTransCode."Account Type";
                        "Account No." := PrTransCode."Account No.";
                    end;

                    "Product Type" := PrTransCode."Product Type";

                    HrObjtEmpl.Reset();
                    HrObjtEmpl.SetRange("No.", "Employee Code");
                    if HrObjtEmpl.FindFirst() then begin
                        HrObjtEmpl.TestField("Member No.");
                        "Member No." := HrObjtEmpl."Member No.";
                    end;

                    case PrTransCode."Account Type" of
                        PrTransCode."Account Type"::Saving:
                            begin
                                "Account Type" := PrTransCode."Account Type";
                                AccBanking.SetRange("Member No.", "Member No.");
                                AccBanking.SetRange("Product Type", "Product Type");
                                if AccBanking.FindFirst() then
                                    "Account No." := AccBanking."No.";
                            end;
                        PrTransCode."Account Type"::Credit:
                            begin
                                "Account Type" := PrTransCode."Account Type";
                                AcCredit.SetRange("Member No.", "Member No.");
                                AcCredit.SetRange("Product Type", "Product Type");
                                if AcCredit.FindFirst() then
                                    "Account No." := AcCredit."No.";
                            end;
                    end;
                end;
                fngetcurrentPayrollPeriod();
            end;
        }
        field(50011; "Transaction Name"; Text[150])
        {
            Caption = 'Transaction Name';
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50013; "Balance"; Decimal)
        {
            Caption = 'Balance';
        }
        field(50014; "Original Amount"; Decimal)
        {
            Caption = 'Original Amount';
        }
        field(50015; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50016; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50017; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            TableRelation = "Pr Payroll Period"."Date Opened";
        }
        field(50018; "No. of Repayment"; Integer)
        {
            Caption = 'No. of Repayment';
        }
        field(50019; "Membership"; Code[100])
        {
            Caption = 'Membership';
        }
        field(50020; "Reference No."; Code[20])
        {
            Caption = 'Reference No.';
        }
        field(50021; "Integera"; Integer)
        {
            Caption = 'Integera';
        }
        field(50022; "Employer Amount"; Decimal)
        {
            Caption = 'Employer Amount';
        }
        field(50023; "Employer Balance"; Decimal)
        {
            Caption = 'Employer Balance';
        }
        field(50024; "Stop Next Period"; Boolean)
        {
            Caption = 'Stop Next Period';
        }
        field(50025; "Amortized Loan Repayment"; Decimal)
        {
            Caption = 'Amortized Loan Repayment';
        }
        field(50026; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(50027; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(50028; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            TableRelation = Loans where("Account No." = field("Member No."), "Outstanding Balance" = filter(> 0), "Product Type" = field("Product Type"));
        
            trigger OnValidate()
            var
                Loan: Record Loans;
            begin

                if Loan.Get("Loan No.") then begin
                    Loan.CalcFields("Outstanding Balance");
                    "Account Type" := "Account Type"::Loan;
                    Amount := Loan.Repayment;
                    Balance := Loan."Outstanding Balance";
                    "Account No." := Loan."Loan Account";
                end;
            end;
        }
        field(50029; "Payroll Code"; Code[100])
        {
            Caption = 'Payroll Code';
        }
        field(50030; "No. Of Units"; Decimal)
        {
            Caption = 'No. Of Units';
        }
        field(50031; "Suspended"; Boolean)
        {
            Caption = 'Suspended';
        }
        field(50032; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(50033; "Is Coop/Loanrep"; Boolean)
        {
            Caption = 'Is Coop/Loanrep';
        }
        field(50034; "Employee Posting Group"; Code[10])
        {
            Caption = 'Employee Posting Group';
            TableRelation = "Pr Employee Posting Group";
        }
        field(50035; "Grants"; Code[20])
        {
            Caption = 'Grants';
        }
        field(50036; "Stopped"; Boolean)
        {
            Caption = 'Stopped';
        }
        field(50037; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(50038; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const(Employee)) Employee
            else
            if ("Account Type" = const(Saving)) "Account Banking" where(Status = const(Active))
            else
            if ("Account Type" = const(Credit)) "Account Credit" where(Status = const(Active))
            else
            if ("Account Type" = const(Loan)) "Credit Account" where(Status = const(Active));
        }
        field(50039; "Sacco Loan"; Boolean)
        {
            Caption = 'Sacco Loan';
        }
        field(50040; "Sacco Shares"; Boolean)
        {
            Caption = 'Sacco Shares';
        }
        field(50041; "Grade"; Code[50])
        {
            Caption = 'Grade';
        }
        field(50042; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            TableRelation = Member;
            Editable = false;
        }
        field(50043; "Transaction Type"; Enum "PayrollTransType")
        {
            Caption = 'Transaction Type';
        }
        field(50044; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            TableRelation = "Product Factory";
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period", "Reference No.")
        {
            Clustered = true;
        }
    }
    procedure fngetcurrentPayrollPeriod()
    begin
        objPeriod.Reset();
        objPeriod.SetRange(objPeriod.Closed, false);
        if objPeriod.FindFirst() then begin
            "Payroll Period" := objPeriod."Date Opened";
            "Period Month" := objPeriod."Period Month";
            "Period Year" := objPeriod."Period Year";
        end;
    end;


    var
        EmployeeTrans: Record "Pr Employee Transaction";
        PrTransCode: Record "Pr Transaction Code";
        HrObjtEmpl: Record "HR Employees";
        AccBanking: Record "Account Banking";
        AcCredit: Record "Account Credit";
        objPeriod: Record "Pr Payroll Period";
        ErrorOnExistCode: Label 'Transaction Code [ %1 ] has already been assigned to Staff no [ %2 ]';
}
