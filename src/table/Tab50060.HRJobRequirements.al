table 50060 "HR Job Requirements"
{
    Caption = 'Job Requirements';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Job ID"; Code[10])
        {
            Caption = 'Job ID';
            DataClassification = CustomerContent;
        }
        field(50010; "Qualification Type"; Code[10])
        {
            Caption = 'Qualification Type';
        }
        field(50011; "Qualification Code"; Code[10])
        {
            Caption = 'Qualification Code';
        }
        field(50012; "Priority"; Option)
        {
            Caption = 'Priority';
            OptionMembers = " ","High","Medium","Low";
        }
        field(50013; "Score ID"; Decimal)
        {
            Caption = 'Score ID';
        }
        field(50014; "Need Code"; Code[20])
        {
            Caption = 'Need Code';
        }
        field(50015; "Stage Code"; Code[20])
        {
            Caption = 'Stage Code';
        }
        field(50016; "Mandatory"; Boolean)
        {
            Caption = 'Mandatory';
        }
        field(50017; "Minimum Score"; Decimal)
        {
            Caption = 'Minimum Score';
        }
        field(50018; "Total (Stage) Desired Score"; Decimal)
        {
            Caption = 'Total (Stage) Desired Score';
        }
        field(50019; "Qualification Description"; Text[100])
        {
            Caption = 'Qualification Description';
        }
        field(50020; "Relevant"; Boolean)
        {
            Caption = 'Relevant';
        }
        field(50021; "Related Qualification"; Boolean)
        {
            Caption = 'Related Qualification';
        }
        field(50022; "Maximum Score"; Decimal)
        {
            Caption = 'Maximum Score';
        }
    }
    keys
    {
        key("PK"; "Job ID", "Qualification Type", "Qualification Code")
        {
            Clustered = true;
        }
    }
}
