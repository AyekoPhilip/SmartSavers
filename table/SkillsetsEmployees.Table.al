table 50205 "Skillsets Employees"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Employee No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
        }
        field(50010; "SkillSet"; Code[500])
        {
            DataClassification = CustomerContent;
            TableRelation = "Skill Code";
            Caption = 'SkillSet';
        
            trigger OnValidate()
            var
                skillcode: Record "Skill Code";
            begin
                if skillcode.Get(SkillSet) then
                    Description := skillcode.Description;
            end;
        }
        field(50011; "Description"; Code[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50012; "Start date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start date';
        }
        field(50013; "End date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End date';
        }
    }

    keys
    {
        key("Key1"; "Employee No.", "SkillSet")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


