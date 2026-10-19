table 50103 "Pr Monthly Variance"
{
    Caption = 'Pr Monthly Variance';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            TableRelation = "Pr Transaction Code";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50010; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            TableRelation = "Pr Transaction Code";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50011; "Period"; Integer)
        {
            Caption = 'Period';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50012; "Curr. Amount"; Decimal)
        {
            Caption = 'Curr. Amount';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50013; "Prev. Amount"; Decimal)
        {
            Caption = 'Prev. Amount';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50014; "Variance"; Decimal)
        {
            Caption = 'Variance';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50015; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50016; "Transaction Name"; Text[100])
        {
            Caption = 'Transaction Name';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50017; "User Name"; Text[100])
        {
            Caption = 'User Name';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50018; "Current Period"; Date)
        {
            Caption = 'Current Period';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50019; "Previous Period"; Date)
        {
            Caption = 'Previous Period';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50020; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = OrganizationIdentifiableInformation;
        }
    }
    keys
    {
        key("PK"; "Transaction Code")
        {
            Clustered = true;
        }
    }
}
