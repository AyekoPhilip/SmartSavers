table 50596 "Member Account (All)"
{
    Caption = 'Member Account (All)';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            SQLDataType = Varchar;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50010; "Name"; Text[80])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }

        field(50011; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50012; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }

        field(50013; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }

        field(50014; "Customer Type"; Enum "CreditCustomerType")
        {
            Caption = 'Customer Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
        }
        field(50016; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50017; "Employer Code"; Code[100])
        {
            TableRelation = Customer where("Account Type" = const(Employer));
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50018; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
            end;
        }

        field(50019; "Payroll/Staff No."; Code[20])
        {
            Caption = 'Payroll/Staff No.';
            DataClassification = CustomerContent;
        }
        field(50020; "ID No."; Code[50])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }

        field(50021; "Marital Status"; Enum "MaritalStatus")
        {
            Caption = 'Marital Status';
            DataClassification = CustomerContent;
        }
        field(50022; "Passport No."; Code[50])
        {
            Caption = 'Passport No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50023; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }

        field(50024; "Account Category"; Option)
        {
            OptionCaption = 'Member,Staff Members,Board Members,Delegates';
            OptionMembers = "Member","Staff Members","Board Members","Delegates";
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }

        field(50025; "Member Segment"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code where(Type = filter(Contract | Pension | Permanent | "Standing Order" | Staff | "Early Retirement" | "Board Member"));
            Caption = 'Member Segment';
            DataClassification = CustomerContent;
        }

        field(50026; "PIN No."; Code[20])
        {
            Caption = 'PIN No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }

        field(50027; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
            Caption = 'Member Category';
            DataClassification = CustomerContent;
        }


        field(50028; "Station/Department"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));
            Caption = 'Station/Department';
        }
        field(50029; "Old Member No."; Code[20])
        {
            Caption = 'Old Member No.';
            DataClassification = CustomerContent;
        }
        field(50030; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Dimension';
        }

        field(50031; "Loan Status"; Enum "MemberStatus")
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(50032; "Mobile Status"; Enum "MemberStatus")
        {
            Caption = 'Mobile Loan';
            DataClassification = CustomerContent;
        }
        field(50033; "Shares Capital"; Decimal)
        {
            Caption = 'Shares Capital';
            DataClassification = CustomerContent;
        }
        field(50034; "Shares Deposit"; Decimal)
        {
            Caption = 'Shares Deposit';
            DataClassification = CustomerContent;
        }
        field(50035; "Specialty Savings"; Decimal)
        {
            Caption = 'Specialty Savings';
            DataClassification = CustomerContent;
        }
        field(50036; "Junior Savings"; Decimal)
        {
            Caption = 'Junior Savings';
            DataClassification = CustomerContent;
        }
         field(50037; "Loan Balance"; Decimal)
        {
            Caption = 'Loan Balance';
            DataClassification = CustomerContent;
        }
         field(50038; "Total Savings"; Decimal)
        {
            Caption = 'Total Savings';
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
}
