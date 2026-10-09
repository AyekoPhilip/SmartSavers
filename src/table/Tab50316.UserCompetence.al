table 50316 "User Competence"
{
    Caption = 'User Competence';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
        
            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                Employee: Record Employee;
            begin
                UserSetup.Get("User ID");
                "Employee No." := UserSetup."Employee No.";
                Employee.Get("Employee No.");
                Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
            end;
        }
        field(50010; "User Competence Description"; Text[100])
        {
            Caption = 'User Competence Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
        }
        field(50012; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key("PK"; "User ID")
        {
            Clustered = true;
        }
    }
}



