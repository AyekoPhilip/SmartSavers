table 50058 "HR Job Occupation"
{
    Caption = 'Job Occupation';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee No."; Code[100])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
        }
        field(50010; "First name"; Text[50])
        {
            Caption = 'First name';
        }
        field(50011; "Middle Name"; Text[50])
        {
            Caption = 'Middle Name';
        }
        field(50012; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
        }
        field(50013; "Extension"; Text[50])
        {
            Caption = 'Extension';
        }
        field(50014; "Email"; Code[50])
        {
            Caption = 'Email';
        }
        field(50015; "Date of Join"; Date)
        {
            Caption = 'Date of Join';
        }
        field(50016; "Department"; Code[10])
        {
            Caption = 'Department';
        }
        field(50017; "Job Description"; Text[50])
        {
            Caption = 'Job Description';
        }
        field(50018; "Job ID"; Code[10])
        {
            Caption = 'Job ID';
        }
    }
    keys
    {
        key("PK"; "Employee No.", "Job ID")
        {
            Clustered = true;
        }
    }
}
