table 50076 "Pr Period Transaction"
{
    Caption = 'Period Transaction';
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            TableRelation = "HR Employees";
            DataClassification = CustomerContent;
        }
        field(50010; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            TableRelation = "Pr Transaction Code";
        }
        field(50011; "Group Text"; Text[100])
        {
            Caption = 'Group Text';
        }
        field(50012; "Transaction Name"; Text[100])
        {
            Caption = 'Transaction Name';
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50014; "Balance"; Decimal)
        {
            Caption = 'Balance';
        }
        field(50015; "Group Order"; Integer)
        {
            Caption = 'Group Order';
        }
        field(50016; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50017; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50018; "Period Filter"; Date)
        {
            Caption = 'Period Filter';
        }
        field(50019; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            TableRelation = "Pr Payroll Period";
        }
        field(50020; "Membership"; Code[100])
        {
            Caption = 'Membership';
        }
        field(50021; "Reference No."; Code[50])
        {
            Caption = 'Reference No.';
        }
        field(50022; "Department Code"; Code[10])
        {
            Caption = 'Department Code';
        }
        field(50023; "Lumpsum Items"; Boolean)
        {
            Caption = 'Lumpsum Items';
        }
        field(50024; "Travel Allowance"; Code[10])
        {
            Caption = 'Travel Allowance';
        }
        field(50025; "G/L Account"; Code[10])
        {
            Caption = 'G/L Account';
        }
        field(50026; "Company Deduction"; Boolean)
        {
            Caption = 'Company Deduction';
        }
        field(50027; "Emp. Amount"; Decimal)
        {
            Caption = 'Emp. Amount';
        }
        field(50028; "Emp. Balance"; Decimal)
        {
            Caption = 'Emp. Balance';
        }
        field(50029; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = filter(Customer | Credit | Loan)) Customer
            else
            if ("Account Type" = filter(Vendor | Saving)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Account Type" = const("Allocation Account")) "Allocation Account"
            else
            if ("Account Type" = const(Employee)) Employee;
        
            trigger OnValidate()

            begin
                case "Account Type" of
                    "Account Type"::Customer:
                        begin

                        end;
                    "Account Type"::Loan:
                        begin
                            "Transaction Type" := "Transaction Type"::Deduction
                        end;
                    "Account Type"::Credit:
                        begin
                            if CredAcc.Get("Account No.") then begin
                                Pfact.Get(CredAcc."Product Type");
                                "Transaction Type" := "Transaction Type"::Deduction;
                                "Account Category" := Pfact."Account Category";
                                "Account Dimension" := Pfact."Account Dimension";
                            end
                        end;
                    "Account Type"::Saving:
                        begin
                            if AccBanking.Get("Account No.") then begin
                                Pfact.Get(AccBanking."Product Type");
                                "Transaction Type" := "Transaction Type"::Deduction;
                                "Account Category" := Pfact."Account Category";
                                "Account Dimension" := Pfact."Account Dimension";
                            end
                        end;
                end;
            end;
        }
        field(50030; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(50031; "Post As"; Enum "PayrollPostAs")
        {
            Caption = 'Post As';
        }
        field(50032; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            TableRelation = Loans;
        
            trigger OnValidate()
            begin
                if Loan.Get("Loan No.") then begin
                    Loan.CalcFields("Outstanding Balance", "Outstanding Principal");
                    Pfact.Get(Loan."Product Type");
                    "Transaction Type" := "Transaction Type"::Deduction;
                    "Account Category" := Pfact."Account Category";
                    "Account Dimension" := Pfact."Account Dimension";
                end
            end;
        }
        field(50033; "Coop Parameters"; Enum "CooParameter")
        {
            Caption = 'Coop Parameters';
        }
        field(50034; "Payroll Code"; Code[100])
        {
            Caption = 'Payroll Code';
        }
        field(50035; "Payment Mode"; Enum "PaymentMode")
        {
            Caption = 'Payment Mode';
        }
        field(50036; "Location/Division"; Code[10])
        {
            Caption = 'Location/Division';
        }
        field(50037; "Department"; Code[10])
        {
            Caption = 'Department';
        }
        field(50038; "Cost Centre"; Code[10])
        {
            Caption = 'Cost Centre';
        }
        field(50039; "Salary Grade"; Code[20])
        {
            Caption = 'Salary Grade';
        }
        field(50040; "Salary Notch"; Code[20])
        {
            Caption = 'Salary Notch';
        }
        field(50041; "Payslip Order"; Integer)
        {
            Caption = 'Payslip Order';
        }
        field(50042; "No. Of Units"; Decimal)
        {
            Caption = 'No. Of Units';
        }
        field(50043; "Employee Clasification"; Code[10])
        {
            Caption = 'Employee Clasification';
        }
        field(50044; "State"; Code[10])
        {
            Caption = 'State';
        }
        field(50045; "Grants"; Code[10])
        {
            Caption = 'Grants';
        }
        field(50046; "Shortcut Dimension 1 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(50047; "Shortcut Dimension 2 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(50048; "Transaction Type"; Enum "PayrollTransType")
        {
            Caption = 'Payroll Type';
        }
        field(50049; "Sub Group Order"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50050; "Original Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50051; "Reference No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50052; "Emp Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50053; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
        field(50054; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
        field(50055; "Statutory category"; Enum "PayrollStatutoryCategory")
        {
            DataClassification = CustomerContent;
        }
        field(50056; "Loan Transaction Type"; Enum "LoanTransactionType")
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Reference No.", "Membership")
        {
            Clustered = true;
        }
        key("Key2"; "Transaction Type")
        {

        }
    }
    var
        Pfact: Record "Product Factory";
        AccBanking: Record "Account Banking";
        CredAcc: Record "Account Credit";
        Loan: Record Loans;

}
