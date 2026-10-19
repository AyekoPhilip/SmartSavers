table 50155 "Next of Kin Change Request"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = Employee;
        }
        field(50010; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Relative Code"; Code[10])
        {
            Caption = 'Relative Code';
            DataClassification = CustomerContent;
            TableRelation = Relative;
        }
        field(50012; "First Name"; Text[30])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
            DataClassification = CustomerContent;
        }
        field(50014; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        }
        field(50015; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                HRSetup.Get();
                HRSetup.TestField("Dependant Maximum Age");
                
                 if CalcDate(HRSetup."Dependant Maximum Age","Birth Date")<Today then
                  Error('The Minimum age for Dependants is '+Format(HRSetup."Dependant Maximum Age"));
                */

            end;
        }
        field(50016; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        }
        field(50017; "Relative's Employee No."; Code[20])
        {
            Caption = 'Relative''s Employee No.';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(50018; "Comment"; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const("Employee Relative"),
                                                                     "No." = field("Employee No."),
                                                                     "Table Line No." = field("Line No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50019; "Dependant"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Dependant';
        
            trigger OnValidate()
            begin
                /*
                HRSetup.Get();
                HRSetup.TestField("Dependant Maximum Age");
                
                 if CalcDate(HRSetup."Dependant Maximum Age","Birth Date")<Today then
                  Error('The Minimum age for Dependants is '+Format(HRSetup."Dependant Maximum Age"));
                */

            end;
        }
        field(50020; "Gender"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ","Male","Female";
            Caption = 'Gender';
        }
        field(50021; "Dependant No"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Dependant No';
        }
        field(50022; "Date Registered"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Registered';
        }
    }

    keys
    {
        key("Key1"; "Employee No.", "Dependant No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


