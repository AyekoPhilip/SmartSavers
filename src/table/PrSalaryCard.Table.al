table 50079 "Pr Salary Card"
{
    Caption = 'Pr Salary Card';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            Editable = false;
            TableRelation = "HR Employees";
        }
        field(50010; "Basic Pay"; Decimal)
        {
            Caption = 'Basic Pay';
        }
        field(50011; "Payment Mode"; Enum "PaymentMode")
        {
            Caption = 'Payment Mode';
        }
        field(50012; "Currency"; Code[10])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(50013; "Pays NSSF"; Boolean)
        {
            Caption = 'Pays NSSF';
        }
        field(50014; "Pays NHIF"; Boolean)
        {
            Caption = 'Pays NHIF';
        }
        field(50015; "Pays PAYE"; Boolean)
        {
            Caption = 'Pays PAYE';
        }
        field(50016; "Payslip Message"; Text[150])
        {
            Caption = 'Payslip Message';
        }
        field(50017; "Cumm Grosspay"; Decimal)
        {
            Caption = 'Cumm Gross Pay';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info"."Gross Pay" where("Employee Code" = field("Employee Code")));
        }
        field(50018; "Cumm NetPay"; Decimal)
        {
            Caption = 'Cumm Net Pay';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info"."Net Pay" where("Employee Code" = field("Employee Code")));
        }
        field(50019; "Cumm Allowances"; Decimal)
        {
            Caption = 'Cumm Allowances';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info".Allowance where("Employee Code" = field("Employee Code")));
        }
        field(50020; "Cumm Deductions"; Decimal)
        {
            Caption = 'Cumm Deductions';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info".Deductions where("Employee Code" = field("Employee Code")));
        }
        field(50021; "Suspend Pay"; Boolean)
        {
            Caption = 'Suspend Pay';
        }
        field(50022; "Suspension Date"; Date)
        {
            Caption = 'Suspension Date';
        }
        field(50023; "Suspension Reasons"; Text[150])
        {
            Caption = 'Suspension Reasons';
        }
        field(50024; "Period Filter"; Date)
        {
            Caption = 'Period Filter';
            FieldClass = FlowFilter;
            TableRelation = "Pr Payroll Period"."Date Opened";
        }
        field(50025; "Exists"; Boolean)
        {
            Caption = 'Exists';
        }
        field(50026; "Cumm PAYE"; Decimal)
        {
            Caption = 'Cumm PAYE';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info".PAYE where("Employee Code" = field("Employee Code")));
        }
        field(50027; "Cumm NSSF"; Decimal)
        {
            Caption = 'Cumm NSSF';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info".NSSF where("Employee Code" = field("Employee Code")));
        }
        field(50028; "Cumm Pension"; Decimal)
        {
            Caption = 'Cumm Pension';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info".Pension where("Employee Code" = field("Employee Code")));
        }
        field(50029; "Cumm HELB"; Decimal)
        {
            Caption = 'Cumm HELB';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info".HELB where("Employee Code" = field("Employee Code")));
        }
        field(50030; "Cumm NHIF"; Decimal)
        {
            Caption = 'Cumm NHIF';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info".NHIF where("Employee Code" = field("Employee Code")));
        }
        field(50031; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
        }
        field(50032; "Bank Branch"; Code[20])
        {
            Caption = 'Bank Branch';
        }
        field(50033; "Employee's Bank"; Code[20])
        {
            Caption = 'Employee''s Bank';
        }
        field(50034; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = "Pr Employee Posting Group";
        }
        field(50035; "No. Overtime Days(s) Worked"; Decimal)
        {
            Caption = 'No. Overtime Days(s) Worked';
        }
        field(50036; "Identification No."; Code[20])
        {
            Caption = 'Identification No.';
        }
        field(50037; "Mobile No."; Code[20])
        {
            Caption = 'Mobile No.';
        }
        field(50038; "Nationality"; Code[20])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
        }
        field(50039; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
        }
        field(50040; "Scheme Code 2"; Code[20])
        {
            Caption = 'Scheme Code 2';
        }
        field(50041; "Job Title"; Code[20])
        {
            Caption = 'Job Title';
        }
        field(50042; "Job Description"; Text[100])
        {
            Caption = 'Job Description';
        }
        field(50043; "Address"; Text[100])
        {
            Caption = 'Address';
        }
        field(50044; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
        }
        field(50045; "Status"; Text[100])
        {
            Caption = 'Status';
        }
        field(50046; "PIN No."; Code[20])
        {
            Caption = 'PIN No.';
        }

        field(50047; "Contract End Date"; Date)
        {
            Caption = 'Contract End Date';
        }
        field(50048; "Job Group"; Code[10])
        {
            Caption = 'Job Group';
        }
        field(50049; "Company E-Mail"; Text[100])
        {
            Caption = 'Company E-Mail';
        }
        field(50050; "Days Worked"; Decimal)
        {
            Caption = 'Days Worked';
        }
        field(50051; "Grade Level"; Code[10])
        {
            Caption = 'Grade Level';
        }
        field(50052; "Gratuity Amount"; Decimal)
        {
            Caption = 'Gratuity Amount';
        }
        field(50053; "Gratuity"; Integer)
        {
            Caption = 'Gratuity';
        }
        field(50054; "No. Of Days PDM"; Integer)
        {
            Caption = 'No. Of Days PDM';
        }
        field(50055; "Rate Per Day"; Decimal)
        {
            Caption = 'Rate Per Day';
        }
        field(50056; "Scheme Code"; Code[10])
        {
            Caption = 'Scheme Code';
        }
        field(50057; "Employee Contract Type"; Code[10])
        {
            Caption = 'Employee Contract Type';
        }
        field(50058; "No. Of Days Worked"; Decimal)
        {
            Caption = 'No. Of Days Worked';
        }
        field(50059; "Is Paid Daily?"; Boolean)
        {
            Caption = 'Is Paid Daily?';
        }
        field(50060; "No. Of Sunday/Holidays Worked"; Decimal)
        {
            Caption = 'No. Of Sunday/Holidays Worked';
        }
        field(50061; "Assign Resp Allowance"; Boolean)
        {
            Caption = 'Assign Resp Allowance';
        }
        field(50062; "Not Based On Rates"; Boolean)
        {
            Caption = 'Not Based On Rates';
        }
        field(50063; "Insurance Certificate?"; Boolean)
        {
            Caption = 'Insurance Certificate?';
        }
        field(50064; "PAYE Relief?"; Boolean)
        {
            Caption = 'PAYE Relief?';
        }
        field(50065; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
        }
        field(50066; "Is Security?"; Boolean)
        {
            Caption = 'Is Security?';
        }
        field(50067; "Emp Name"; Text[100])
        {
            Caption = 'Emp Name';
        }
        field(50068; "Disable Personal Relief?"; Boolean)
        {
            Caption = 'Disable Personal Relief?';
        }
        field(50069; "1/3 Basic"; Decimal)
        {
            Caption = '1/3 Basic';
        }
        field(50070; "Suspend Half Pay"; Boolean)
        {

        }
        field(50071; "Cumm Basic"; Decimal)
        {
            Caption = 'Cumm Basic pay';
            FieldClass = FlowField;
            CalcFormula = Sum("PR Employee P9 Info"."Basic Pay" where("Employee Code" = field("Employee Code")));
        }
    }
    keys
    {
        key("PK"; "Employee Code")
        {
            Clustered = true;
        }
    }
}
