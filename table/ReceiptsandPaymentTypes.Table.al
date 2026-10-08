table 50002 "Receipts and Payment Types"
{
    DrillDownPageID = "Receipts & Payment Types";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(50010; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Type = Type::Invoice then begin
                    if "Account Type" in ["Account Type"::"Bank Account", "Account Type"::Customer, "Account Type"::Employee, "Account Type"::"IC Partner", "Account Type"::Vendor] then
                        Error('Account type can only be G/L Account , Fixed Asset, Item or Charge (Item) for Invoices ');
                end;

                if "Account Type" = "Account Type"::"G/L Account" then
                    "Direct Expense" := true
                else
                    "Direct Expense" := false;
            end;
        }
        field(50012; "Type"; Option)
        {
            NotBlank = true;
            OptionCaption = ' ,Receipt,Payment,Imprest,Claim,Advance,Expense,Petty Cash,Receipt-Property,Input Tax,Service Charge,Invoice';
            OptionMembers = " ","Receipt","Payment","Imprest","Claim","Advance","Expense","Petty Cash","Receipt-Property","Input Tax","Service Charge","Invoice";
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(50013; "VAT Chargeable"; Option)
        {
            OptionMembers = "No","Yes";
            DataClassification = CustomerContent;
            Caption = 'VAT Chargeable';
        }
        field(50014; "Withholding Tax Chargeable"; Option)
        {
            OptionMembers = "No","Yes";
            DataClassification = CustomerContent;
            Caption = 'Withholding Tax Chargeable';
        }
        field(50015; "VAT Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            Caption = 'VAT Code';
        }
        field(50016; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            Caption = 'Withholding Tax Code';
        }
        field(50017; "Default Grouping"; Code[20])
        {
            TableRelation = if ("Account Type" = filter(Customer | Credit | Loan)) "Customer Posting Group"
            else
            if ("Account Type" = filter(Vendor | Saving)) "Vendor Posting Group"
            else
            if ("Account Type" = const("Bank Account")) "Bank Account Posting Group"
            else
            if ("Account Type" = const("Fixed Asset")) "FA Posting Group"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";
            DataClassification = CustomerContent;
            Caption = 'Default Grouping';
        }
        field(50018; "Account No."; Code[20])
        {
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
            if ("Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Account Type" = const(Employee)) Employee;
            DataClassification = CustomerContent;
            Caption = 'Account No.';
        
            trigger OnValidate()
            begin
                GLAcc.Reset();
                if GLAcc.Get("Account No.") then begin
                    // "Old Account No":=GLAcc."Old Account No";
                    // IF Type=Type::Payment THEN
                    // //Ensure all Income statement accounts are set for budget control
                    // IF GLAcc."Income/Balance"= GLAcc."Income/Balance"::"Income Statement" THEN
                    //     GLAcc.TESTFIELD(GLAcc."Budget Controlled",TRUE);
                    //
                    //   GLAcc.TESTFIELD(GLAcc."Budget Controlled",TRUE);
                    if GLAcc."Direct Posting" = false then begin
                        Error('Direct Posting must be True');
                    end;
                end;

                if ("Account Type" = "Account Type"::"G/L Account") and (GLAcc."Income/Balance" = GLAcc."Income/Balance"::"Income Statement") then
                    "Direct Expense" := true
                else
                    "Direct Expense" := false;
            end;
        }
        field(50019; "Pending Voucher"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pending Voucher';
        }
        field(50020; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
            DataClassification = CustomerContent;
            Caption = 'Bank Account';
        
            trigger OnValidate()
            begin
                if "Account Type" <> "Account Type"::"Bank Account" then begin
                    Error('You can only enter Bank No where Account Type is Bank Account');
                end;
            end;
        }
        field(50021; "Transation Remarks"; Text[250])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
            Caption = 'Transation Remarks';
        }
        field(50022; "Payment Reference"; Option)
        {
            OptionMembers = "Normal","Farmer Purchase";
            DataClassification = CustomerContent;
            Caption = 'Payment Reference';
        }
        field(50023; "Customer Payment On Account"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Payment On Account';
        }
        field(50024; "Direct Expense"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Direct Expense';
        }
        field(50025; "Calculate Retention"; Option)
        {
            OptionMembers = "No","Yes";
            DataClassification = CustomerContent;
            Caption = 'Calculate Retention';
        }
        field(50026; "Retention Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            Caption = 'Retention Code';
        }
        field(50027; "Blocked"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Blocked';
        }
        field(50028; "Based On Travel Rates Table"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Based On Travel Rates Table';
        }
        field(50029; "Receipt Reference"; Option)
        {
            OptionMembers = "Normal","Travel Advance Refunds","Other Advance Refunds";
            DataClassification = CustomerContent;
            Caption = 'Receipt Reference';
        
            trigger OnValidate()
            begin
                if "Receipt Reference" <> "Receipt Reference"::Normal then
                    TestField("Account Type", "Account Type"::Customer);
            end;
        }
        field(50030; "Based On a Table"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Based On a Table';
        }
        field(50031; "Old Account No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Old Account No';
        }
        field(50032; "Do NOT Allow Apply Twice"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Do NOT Allow Apply Twice';
        }
        field(50033; "Payment Option"; Option)
        {
            OptionMembers = " ","Medical Claims","Training";
            DataClassification = CustomerContent;
            Caption = 'Payment Option';
        }
        field(50034; "Imprest Payment"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Imprest Payment';
        }
        field(50035; "Claim Payment"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Claim Payment';
        }
        field(50036; "Cost of Sale"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cost of Sale';
        }
        field(50037; "Check Medical Ceiling"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Check Medical Ceiling';
        }
        field(50038; "Property Receipt"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Property Receipt';
        }
        field(50039; "Property Receipt Type"; Option)
        {
            Caption = 'Property Transaction Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Rent Receipt,Service Charge,TPS Repayment,TPS Deposit';
            OptionMembers = "Rent Receipt","Service Charge","TPS Repayment","TPS Deposit";
        }
        field(50040; "Manual Allocation"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Allocation';
        }
        field(50041; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(50042; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(50043; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            Caption = 'Shortcut Dimension 3 Code';
        }
        field(50044; "VAT Deductable"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Deductable';
        }
        field(50045; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group".Code;
            Caption = 'VAT Bus. Posting Group';
        }
        field(50046; "VAT Withholding Code"; Code[20])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50047; "G/L Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = filter("G/L Account")) "G/L Account";
        
            trigger OnValidate()
            begin

            end;
        }
    }

    keys
    {
        key("Key1"; "Code", "Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, "Account Type", "Account No.")
        {
        }
    }

    var
        GLAcc: Record "G/L Account";
}


