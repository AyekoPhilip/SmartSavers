table 50069 "Pr Payroll Type"
{
    Caption = 'Pr Payroll Type';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Payroll Code"; Code[100])
        {
            Caption = 'Payroll Code';
        }
        field(50010; "Payroll Name"; Text[100])
        {
            Caption = 'Payroll Name';
        }
        field(50011; "Comment"; Text[100])
        {
            Caption = 'Comment';
        }
        field(50012; "Period Length"; DateFormula)
        {
            Caption = 'Period Length';
        }
        field(50013; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Payroll Code")
        {
            Clustered = true;
        }
    }
}
