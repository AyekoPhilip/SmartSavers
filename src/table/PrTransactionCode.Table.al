table 50086 "Pr Transaction Code"
{
    Caption = 'Pr Transaction Code';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(50010; "Name"; Text[100])
        {
            Caption = 'Name';
        
            trigger OnValidate()
            begin
                Name := UpperCase(Name);
            end;
        }
        field(50011; "Balance Type"; Option)
        {
            Caption = 'Balance Type';
            OptionMembers = " ","Increasing","Reducing";
        }
        field(50012; "Transaction Type"; Enum "PayrollTransType")
        {
            Caption = 'Transaction Type';
        }
        field(50013; "Frequency"; Option)
        {
            Caption = 'Frequency';
            OptionMembers = "Fixed","Varied";
        }
        field(50014; "Is Cash"; Boolean)
        {
            Caption = 'Is Cash';
        }
        field(50015; "Taxable"; Boolean)
        {
            Caption = 'Taxable';
        
            trigger OnValidate()
            begin
                TestField("Transaction Type", "Transaction Type"::Income);
            end;
        }
        field(50016; "Is Formula"; Boolean)
        {
            Caption = 'Is Formula';
        }
        field(50017; "Formula"; Text[150])
        {
            Caption = 'Formula';
        }
        field(50018; "Amount Preference"; Option)
        {
            Caption = 'Amount Preference';
            OptionMembers = "Posted Amount","Take Higher","Take Lower";
        }
        field(50019; "Special Transactions"; Enum "PayrollSpecialTransaction")
        {
            Caption = 'Special Transactions';
        }
        field(50020; "Deduct Premium"; Boolean)
        {
            Caption = 'Deduct Premium';
        }
        field(50021; "Interest Rate"; Decimal)
        {
            Caption = 'Interest Rate';
        }
        field(50022; "Repayment Method"; Enum "InterestCalculationMethod")
        {
            Caption = 'Repayment Method';
        }
        field(50023; "Fringe Benefit"; Boolean)
        {
            Caption = 'Fringe Benefit';
        }
        field(50024; "Employer Deduction"; Boolean)
        {
            Caption = 'Employer Deduction';
        }
        field(50025; "Is House Allowance"; Boolean)
        {
            Caption = 'Is House Allowance';
        }
        field(50026; "Inc. Employer Deduction"; Boolean)
        {
            Caption = 'Inc. Employer Deduction';
        }
        field(50027; "Is Formula For Employer"; Text[50])
        {
            Caption = 'Is Formula For Employer';
        }
        field(50028; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(50029; "Account No."; Code[100])
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
        field(50030; "Coop Parameter"; Enum "CooParameter")
        {
            Caption = 'Coop Parameter';
        }
        field(50031; "Is Coop/Loan"; Boolean)
        {
            Caption = 'Is Coop/Loan';
        }
        field(50032; "Deduct Morgage"; Boolean)
        {
            Caption = 'Deduct Morgage';
        }
        field(50033; "Welfare"; Boolean)
        {
            Caption = 'Welfare';
        }
        field(50034; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(50035; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
        }
        field(50036; "Suspended"; Boolean)
        {
            Caption = 'Suspended';
        }
        field(50037; "Shortcut Dimension 1 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");

            end;
        }
        field(50038; "Shortcut Dimension 2 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));
        
            trigger OnValidate()
            begin
                // ValidateShortcutDimCode(1, "Shortcut Dimension 2 Code");

            end;
        }
        field(50039; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            TableRelation = if ("Account Category" = filter(Loan)) "Product Factory" where(Status = filter(Active), "Product Class" = filter(Loan))
            else
            if ("Account Category" = filter("Shares Capital" | "Shares Deposit" | "Registration Fee" | "Benevolent Fund" | Insurance | Savings | "Specialty Savings" | "Islamic Banking" | "Women Savings"))
            "Product Factory" where(Status = filter(Active), "Product Class" = filter(Account), "Account Category" = field("Account Category"));
        }
        field(50040; "Previous Month Filter"; Date)
        {
            Caption = 'Previous Month Filter';
            FieldClass = FlowFilter;
            TableRelation = "Pr Payroll Period"."Date Opened";
        }
        field(50041; "Current Month Filter"; Date)
        {
            Caption = 'Current Month Filter';
            FieldClass = FlowFilter;
        }
        field(50042; "Prev. Amount"; Decimal)
        {
            Caption = 'Prev. Amount';
        }
        field(50043; "Current Amount"; Decimal)
        {
            Caption = 'Current Amount';
        }
        field(50044; "Transaction Category"; Option)
        {
            Caption = 'Transaction Category';
            OptionMembers = "","Housing","Transport","Other Allowances","NHF","Pension","Company Loan","Housing Deduction","Personal Loan","Inconvinience","Bonus Special","Other Deductions","Overtime","Entertainment","Leave","Utility","Other Co-deductions","Car Loan","Call Duty","Co-op","Lunch","Compassionate Loan";
        }
        field(50045; "Voluntary Deduction"; Boolean)
        {

        }
        field(99000; "Is Not Gross Allowance "; Boolean)
        {

        }
    
        field(50046; "Ignored on Gross Pay"; Boolean)
        {

        }
    }
    keys
    {
        key("PK"; "Code")
        {
            Clustered = true;
        }
    }
    var
        DimMgt: Codeunit DimensionManagement;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"Pr Transaction Code", Code, FieldNumber, ShortcutDimCode);
        Modify;
    end;
}
