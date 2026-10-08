tableextension 50042 "RelativeExt" extends Relative
{
    fields
    {
        field(50009; "Medical Scheme No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Medical Scheme No';
        }
        field(50010; "Employee Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Code';
        }
        field(50011; "National ID/Passport No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'National ID/Passport No';
        }
        field(50012; "Fiscal Year"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Fiscal Year';
        }
        field(50013; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(50014; "Gender"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " Male","Female";
            Caption = 'Gender';
        }
        field(50015; "In-Patient Entitlement"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'In-Patient Entitlement';
        }
        field(50016; "Out-Patient Entitlment"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Out-Patient Entitlment';
        }
        field(50017; "Amount Spend (In-Patient)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Spend (In-Patient)';
        }
        field(50018; "Amout Spend (Out-Patient)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amout Spend (Out-Patient)';
        }
        field(50019; "Policy Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Start Date';
        }
        field(50020; "Medical Cover Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","In House","Outsourced";
            Caption = 'Medical Cover Type';
        }
        field(50021; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Birth';
        }
    }
}


