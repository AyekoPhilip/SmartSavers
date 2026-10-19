table 50115 "Appraisal Periods"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Period"; Code[30])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Period';
        }
        field(50010; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        
            trigger OnValidate()
            begin
                if Date2DMY("Start Date", 3) <> Date2DMY(Today, 3) then
                    Error(DateMustBeInCurrYearErr);
            end;
        }
        field(50012; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        
            trigger OnValidate()
            begin
                if Date2DMY("End Date", 3) <> Date2DMY(Today, 3) then
                    Error(DateMustBeInCurrYearErr);
            end;
        }
        field(50013; "Appraisal Category"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Appraisal Category';
        }
        field(50014; "Active"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active';
        }
        field(50015; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Mid-Year,Final Year';
            OptionMembers = " ","Mid-Year","Final Year";
            Caption = 'Type';
        }
        field(50016; "Appraisal Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Mid-Year,Final Year';
            OptionMembers = " ","Mid-Year","Final Year";
            Caption = 'Appraisal Type';
        }
        field(50017; "Submission Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Submission Due Date';
        }
    }

    keys
    {
        key("Key1"; "Period")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Period, Description, "Start Date", "End Date")
        {
        }
    }

    var
        DateMustBeInCurrYearErr: Label 'Date must be in the current year';
}


