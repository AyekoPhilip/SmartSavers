table 50384 "Member Category"
{
    DrillDownPageID = "Member Category Lookup";
    LookupPageID = "Member Category Lookup";
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Type);
            end;
        }
        field(50010; "Registration Fee"; Decimal)
        {
            Caption = 'Registration Fee';
            DataClassification = CustomerContent;
        }
        field(50011; "Share Capital"; Decimal)
        {
            Caption = 'Share Capital';
            DataClassification = CustomerContent;
        }
        field(50012; "Max. Installment"; Integer)
        {
            Caption = 'Max. Installment';
            DataClassification = CustomerContent;
        }
        field(50013; "Default Share Capital"; Decimal)
        {
            Caption = 'Default Share Capital';
            DataClassification = CustomerContent;
        }
        field(50014; "Default Share Deposit"; Decimal)
        {
            Caption = 'Default Share Deposit';
            DataClassification = CustomerContent;
        }
        field(50015; "Checkoff"; Boolean)
        {
            Caption = 'Checkoff';
            DataClassification = CustomerContent;
        }
        field(50016; "Can Take Loan"; Boolean)
        {
            Caption = 'Can Take Loan';
            DataClassification = CustomerContent;
        }
        field(50017; "Auto Generate Staff No"; Boolean)
        {
            Caption = 'Auto Generate Staff No';
            DataClassification = CustomerContent;
        }
        field(50018; "Acronym"; Code[10])
        {
            Caption = 'Acronym';
            DataClassification = CustomerContent;
        }
        field(50019; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50020; "Premier Club Min.Deposits"; Decimal)
        {
            Caption = 'Premier Club Min.Deposits';
            DataClassification = CustomerContent;
        }
        field(50021; "Type"; Enum "MemberCategoryType")
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(50022; "Cannot Guarantee Loan"; Boolean)
        {
            Caption = 'Cannot Guarantee Loan';
            DataClassification = CustomerContent;
        }
        field(50023; "Terms of Service"; Enum "TermsOfEmployment")
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




