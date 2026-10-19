table 50057 "HR Job Application"
{
    Caption = 'Job Application';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "First Name"; Text[50])
        {
            Caption = 'First Name';
        }
        field(50011; "Middle Name"; Text[50])
        {
            Caption = 'Middle Name';
        }
        field(50012; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
        }
        field(50013; "Name"; Text[50])
        {
            Caption = 'Name';
        }
        field(50014; "Initials"; Code[50])
        {
            Caption = 'Initials';
        }
        field(50015; "Postal Address"; Code[50])
        {
            Caption = 'Postal Address';
        }
        field(50016; "Residential Address"; Code[50])
        {
            Caption = 'Residential Address';
        }
        field(50017; "City"; Code[50])
        {
            Caption = 'City';
        }
        field(50018; "Post Code"; Code[50])
        {
            Caption = 'Post Code';
        }
        field(50019; "County"; Code[50])
        {
            Caption = 'County';
        }
        field(50020; "Phone No."; Code[50])
        {
            Caption = 'Phone No.';
        }
        field(50021; "Mobile Phone No."; Code[50])
        {
            Caption = 'Mobile Phone No.';
        }
        field(50022; "E-Mail"; Code[50])
        {
            Caption = 'E-Mail';
        }
        field(50023; "Picture"; MediaSet)
        {
            Caption = 'Picture';
        }
        field(50024; "ID No."; Code[50])
        {
            Caption = 'ID No.';
        }
        field(50025; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
        }
        field(50026; "Status"; Enum "EmployeeStatus")
        {
            Caption = 'Status';
        }
        field(50027; "Country Code"; Code[50])
        {
            Caption = 'Country Code';
        }
        field(50028; "Marital Status"; Enum "MaritalStatus")
        {
            Caption = 'Marital Status';
        }
        field(50029; "Disabled"; Option)
        {
            Caption = 'Disabled';
            OptionMembers = "No","Yes";
        }
        field(50030; "Date Of Birth"; Date)
        {
            Caption = 'Date Of Birth';
        }
        field(50031; "Primary Skill Category"; Option)
        {
            Caption = 'Primary Skill Category';
            OptionMembers = "Auditors","Consultants","Training","Certification","Administration","Marketing","Management","Business Development","Other";
        }
        field(50032; "Disabling Details"; Text[50])
        {
            Caption = 'Disabling Details';
        }
        field(50033; "Passport No."; Code[50])
        {
            Caption = 'Passport No.';
        }
        field(50034; "PIN No."; Code[50])
        {
            Caption = 'PIN No.';
        }
        field(50035; "Job Applied For"; Text[50])
        {
            Caption = 'Job Applied For';
        }
        field(50036; "Employee Requisition No."; Code[50])
        {
            Caption = 'Employee Requisition No.';
        }
        field(50037; "Total Score"; Decimal)
        {
            Caption = 'Total Score';
        }
        field(50038; "Shorlisted"; Boolean)
        {
            Caption = 'Shorlisted';
        }
        field(50039; "Qualified"; Boolean)
        {
            Caption = 'Qualified';
        }
        field(50040; "Stage"; Code[50])
        {
            Caption = 'Stage';
        }
        field(50041; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
        }
        field(50042; "Applicant Type"; Option)
        {
            Caption = 'Applicant Type';
            OptionMembers = " ","External","Internal";
        }
        field(50043; "Expatriate"; Boolean)
        {
            Caption = 'Expatriate';
        }
        field(50044; "Total Score After Interview"; Decimal)
        {
            Caption = 'Total Score After Interview';
        }
        field(50045; "Total Score After Shortlisting"; Decimal)
        {
            Caption = 'Total Score After Shortlisting';
        }
        field(50046; "Date of Interview"; Date)
        {
            Caption = 'Date of Interview';
        }
        field(50047; "From Time"; Time)
        {
            Caption = 'From Time';
        }
        field(50048; "To Time"; Time)
        {
            Caption = 'To Time';
        }
        field(50049; "Job Applied for Description"; Text[50])
        {
            Caption = 'Job Applied for Description';
        }
        field(50050; "Regret Notice Sent"; Boolean)
        {
            Caption = 'Regret Notice Sent';
        }
        field(50051; "Interview Type"; Option)
        {
            Caption = 'Interview Type';
            OptionMembers = "Writen","Practicals","Oral";
        }
        field(50052; "Responsibility Centre"; Code[50])
        {
            Caption = 'Responsibility Centre';
        }
        field(50053; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
        }
        field(50054; "Document Status"; Option)
        {
            Caption = 'Document Status';
            OptionMembers = "Application Stage","Shortlisting Stage","Closed";
        }
        field(50055; "Proposed Salary"; Decimal)
        {
            Caption = 'Proposed Salary';
        }
        field(50056; "Level"; Option)
        {
            Caption = 'Level';
            OptionMembers = "","Level 1","Level 2","Level 3","Level 4","Level 5","Level 6","Level 7";
        }
    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
}
