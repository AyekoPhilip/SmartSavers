table 50319 "DSC Continous Membership"
{
    Caption = 'DSC Continous Membership';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Continous Membership";
    LookupPageId = "Continous Membership";

    fields
    {
        field(50009; "Parameter"; Code[10])
        {
            Caption = 'Parameter';
            DataClassification = ToBeClassified;
        }
        field(50010; "Min. Age"; Integer)
        {
            Caption = 'Min. Age';
            DataClassification = ToBeClassified;
        }
        field(50011; "Max. Age"; Integer)
        {
            Caption = 'Max. Age';
            DataClassification = ToBeClassified;
        }
        field(50012; "Score"; Integer)
        {
            Caption = 'Score';
            DataClassification = ToBeClassified;
        }
        field(50013; "Score Type"; Option)
        {
            Caption = 'Score';
            OptionMembers = "Membership","Loan";
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key("PK"; "Parameter", "Min. Age", "Max. Age")
        {
            Clustered = true;
        }
    }
}



