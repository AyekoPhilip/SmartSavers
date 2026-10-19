table 50557 "Loan Charge Posted"
{
    DrillDownPageID = "Application Charges Posted";
    LookupPageID = "Application Charges Posted";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Charge Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Loan Charges"."Charge Code";
            Caption = 'Charge Code';
        
            trigger OnValidate()
            begin
                if LoanChg.Get("Charge Code") then begin
                    "Charge Description" := LoanChg."Charge Description";
                    "Charge Amount" := LoanChg."Charge Amount";
                    "Charge Method" := LoanChg."Charge Method";
                    Percentage := LoanChg.Percentage;
                    "Charging Option" := LoanChg."Charging Option";
                    "Use Percentage" := LoanChg."Use Percentage";
                    "Charge Type" := LoanChg."Charge Type";
                    Percentage := LoanChg.Percentage;
                    "Account Type" := LoanChg."Account Type";
                    "Account No." := LoanChg."Charges Account";
                    "Effect Excise Duty" := LoanChg."Effect Excise Duty";
                end;
            end;
        }
        field(50010; "Charge Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Charge Description';
        }
        field(50011; "Charge Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Charge Amount';
        }
        field(50012; "Use Percentage"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Use Percentage';
        }
        field(50013; "Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Percentage';
        
            trigger OnValidate()
            begin
                TestField("Use Percentage", true);
                "Charge Method" := "Charge Method"::"% of Amount";
            end;
        }
        field(50014; "Charge Type"; Enum "ChargeType")
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Charge Type';
        }
        field(50015; "Charging Option"; Enum "LoanChargeOptions")
        {
            DataClassification = CustomerContent;
            Caption = 'Charging Option';
        }
        field(50016; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Product Code';
        }
        field(50017; "Account No."; Code[15])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" WHERE("Income/Balance" = CONST("Income Statement"));
            Caption = 'Account No.';
        }
        field(50018; "Minimum"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum';
        }
        field(50019; "Maximum"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum';
        }
        field(50020; "Additional Charge %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Charge %';
        }
        field(50021; "Effect Excise Duty"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'No,Yes';
            OptionMembers = "No","Yes";
            Caption = 'Effect Excise Duty';
        }
        field(50022; "Prorate"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Appraisal,Insurance';
            OptionMembers = " ","Appraisal","Insurance";
            Caption = 'Prorate';
        }
        field(50023; "Charge Method"; Enum "ProductChargeMethod")
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Method';
        }
        field(50024; "Staggered Charge Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Tiered Charges Header";
            Caption = 'Staggered Charge Code';
        }
        field(50025; "Application No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Application No.';
        }
        field(50026; "Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Type';
        }
        field(50027; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
        }
        field(50028; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Created By';
        }
        field(50029; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Created';
        }
        field(50030; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified Date';
        }
        field(50031; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Last Modified By';
        }
        field(50032; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Deffered,Posted';
            OptionMembers = "Open","Pending Approval","Approved","Rejected","Deffered","Posted";
            Caption = 'Approval Status';
        }
        field(50033; "Post Charge"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Post Charge';
        }
        field(50034; "Amount to Post"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Amount to Post';
        }
    }

    keys
    {
        key("Key1"; "Charge Code", "Product Code", "Application No.", "Loan No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Date Created" := CurrentDateTime
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime
    end;

    trigger OnRename()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime
    end;

    var
        LoanChg: Record "Loan Charges";


    procedure CopyFromLoanProductCharges(LoanChg: Record "Loan Product Charges")
    begin
        "Charge Code" := LoanChg."Charge Code";
        "Product Code" := LoanChg."Product Code";
        "Charge Description" := LoanChg."Charge Description";
        "Charge Amount" := LoanChg."Charge Amount";
        "Charge Method" := LoanChg."Charge Method";
        Percentage := LoanChg.Percentage;
        "Charging Option" := LoanChg."Charging Option";
        "Use Percentage" := LoanChg."Use Percentage";
        "Charge Type" := LoanChg."Charge Type";
        Percentage := LoanChg.Percentage;
        "Effect Excise Duty" := LoanChg."Effect Excise Duty";
        "Account No." := LoanChg."Charges Account";
    end;


    procedure CopyFromPostedChargesLine(LoanChg: Record "Loan Application Charge")
    begin
        "Charge Description" := LoanChg."Charge Description";
        "Charge Amount" := LoanChg."Charge Amount";
        "Charge Method" := LoanChg."Charge Method";
        Percentage := LoanChg.Percentage;
        "Charging Option" := LoanChg."Charging Option";
        "Use Percentage" := LoanChg."Use Percentage";
        "Charge Type" := LoanChg."Charge Type";
        Percentage := LoanChg.Percentage;
        "Effect Excise Duty" := LoanChg."Effect Excise Duty";
        "Account No." := LoanChg."Account No.";
        "Account Type" := LoanChg."Account Type";
        "Post Charge" := LoanChg."Post Charge";
        "Amount to Post" := LoanChg."Amount to Post"
    end;
}




