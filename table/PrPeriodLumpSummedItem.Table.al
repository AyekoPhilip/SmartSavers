table 50073 "Pr PeriodLumpSummed Item"
{
    Caption = 'Pr PeriodLumpSummed Item';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employer Code"; Code[10])
        {
            Caption = 'Employer Code';
        }
        field(50010; "Pay No."; Code[10])
        {
            Caption = 'Pay No.';
        }
        field(50011; "Transaction Code"; Code[10])
        {
            Caption = 'Transaction Code';
        }
        field(50012; "Transaction No."; Code[10])
        {
            Caption = 'Transaction No.';
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50014; "Cont To Date"; Decimal)
        {
            Caption = 'Cont To Date';
        }
        field(50015; "Balance"; Decimal)
        {
            Caption = 'Balance';
        }
        field(50016; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50017; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50018; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(50019; "Lumpsum"; Boolean)
        {
            Caption = 'Lumpsum';
        }
    }
    keys
    {
        key("PK"; "Employer Code", "Transaction Code", "Transaction No.", "Period Month", "Period Year", "Payroll Period")
        {
            Clustered = true;
        }
    }
}
