table 50064 "HR Lookup Values"
{
    Caption = 'HR Lookup Values';
    DataClassification = CustomerContent;
    DrillDownPageId="HR Lookup Value";
    LookupPageId="HR Lookup Value";
    fields
    {
        field(50009; "Type"; Enum "HRLookUpType")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(50011; "Description"; Text[50])
        {
            Caption = 'Description';
        }
        field(50012; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
        }
        field(50013; "Notice Period"; Date)
        {
            Caption = 'Notice Period';
        }
        field(50014; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }
        field(50015; "Contract Length"; Integer)
        {
            Caption = 'Contract Length';
        }
        field(50016; "Current Appraisal Period"; Boolean)
        {
            Caption = 'Current Appraisal Period';
        }
        field(50017; "Disciplinary Case Rating"; Text[50])
        {
            Caption = 'Disciplinary Case Rating';
        }
        field(50018; "Disciplinary Action"; Code[10])
        {
            Caption = 'Disciplinary Action';
        }
        field(50019; "From"; Date)
        {
            Caption = 'From';
        }
        field(50020; "To"; Date)
        {
            Caption = 'To';
        }
        field(50021; "Score"; Decimal)
        {
            Caption = 'Score';
        }
        field(50022; "Basic Salary"; Decimal)
        {
            Caption = 'Basic Salary';
        }
        field(50023; "Supervisor Only"; Boolean)
        {
            Caption = 'Supervisor Only';
        }
        field(50024; "Appraisal Stage"; Option)
        {
            Caption = 'Appraisal Stage';
            OptionMembers = "Target Setting","FirstQuarter","SecondQuarter","ThirdQuarter","EndYearEvaluation";
        }
        field(50025; "Previous Appraisal Code"; Code[10])
        {
            Caption = 'Previous Appraisal Code';
        }
    }
    keys
    {
        key("PK"; "Type", "Code")
        {
            Clustered = true;
        }
    }
}
