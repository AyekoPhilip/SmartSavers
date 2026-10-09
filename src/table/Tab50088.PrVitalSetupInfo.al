table 50088 "Pr Vital Setup Info"
{
    Caption = 'Pr Vital Setup Info';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Setup Code"; Code[10])
        {
            Caption = 'Setup Code';
        }
        field(50010; "Tax Relief"; Decimal)
        {
            Caption = 'Tax Relief';
        }
        field(50011; "Insurance Relief"; Decimal)
        {
            Caption = 'Insurance Relief';
        }
        field(50012; "Max Relief"; Decimal)
        {
            Caption = 'Max Relief';
        }
        field(50013; "Mortgage Relief"; Decimal)
        {
            Caption = 'Mortgage Relief';
        }
        field(50014; "Max Pension Contribution"; Decimal)
        {
            Caption = 'Max Pension Contribution';
        }
        field(50015; "Tax On Excess Pension"; Decimal)
        {
            Caption = 'Tax On Excess Pension';
        }
        field(50016; "Loan Market Rate"; Decimal)
        {
            Caption = 'Loan Market Rate';
        }
        field(50017; "Loan Corporate Rate"; Decimal)
        {
            Caption = 'Loan Corporate Rate';
        }
        field(50018; "Taxable Pay (Normal)"; Decimal)
        {
            Caption = 'Taxable Pay (Normal)';
        }
        field(50019; "Taxable Pay (Agricultural)"; Decimal)
        {
            Caption = 'Taxable Pay (Agricultural)';
        }
        field(50020; "NHIF Based On"; Enum "NhifBasedOn")
        {
            Caption = 'NHIF Based On';
        }
        field(50021; "NSSF Employee"; Decimal)
        {
            Caption = 'NSSF Employee';
        }
        field(50022; "NSSF Employer Factor"; Decimal)
        {
            Caption = 'NSSF Employer Factor';
        }
        field(50023; "OOI Deduction"; Decimal)
        {
            Caption = 'OOI Deduction';
        }
        field(50024; "OOI December"; Decimal)
        {
            Caption = 'OOI December';
        }
        field(50025; "Security Day (U)"; Decimal)
        {
            Caption = 'Security Day (U)';
        }
        field(50026; "Security Night (U)"; Decimal)
        {
            Caption = 'Security Night (U)';
        }
        field(50027; "Ayah (U)"; Decimal)
        {
            Caption = 'Ayah (U)';
        }
        field(50028; "Gardener (U)"; Decimal)
        {
            Caption = 'Gardener (U)';
        }
        field(50029; "Security Day (R)"; Decimal)
        {
            Caption = 'Security Day (R)';
        }
        field(50030; "Security Night (R)"; Decimal)
        {
            Caption = 'Security Night (R)';
        }
        field(50031; "Ayah (R)"; Decimal)
        {
            Caption = 'Ayah (R)';
        }
        field(50032; "Gardener (R)"; Decimal)
        {
            Caption = 'Gardener (R)';
        }
        field(50033; "Benefit Threshold"; Decimal)
        {
            Caption = 'Benefit Threshold';
        }
        field(50034; "NSSF Based On"; Enum "NhifBasedOn")
        {
            Caption = 'NSSF Based On';
        }
        field(50035; "Value Posting"; Decimal)
        {
            Caption = 'Value Posting';
        }
        field(50036; "Disabled Tax Limit"; Decimal)
        {
            Caption = 'Disabled Tax Limit';
        }
        field(50037; "Minimun Relief Amount"; Decimal)
        {
            Caption = 'Minimun Relief Amount';
        }
        field(50038; "Secondary Tax Percentage"; Decimal)
        {
            Caption = 'Secondary Tax Percentage';
        }
        field(50039; "Mortgage Relief Percentage"; Decimal)
        {
            Caption = 'Mortgage Relief Percentage';
        }
        field(50040; "NHF - Maximum Age"; DateFormula)
        {
            Caption = 'NHF - Maximum Age';
        }
        field(50041; "Leave Allownace Percentage"; Decimal)
        {
            Caption = 'Leave Allownace Percentage';
        }
        field(50042; "Incremental Percentage"; Decimal)
        {
            Caption = 'Incremental Percentage';
        }
        field(50043; "Max. Leave Allownace"; Decimal)
        {
            Caption = 'Max. Leave Allownace';
        }
        field(50044; "Acting Allowance Percentage"; Decimal)
        {
            Caption = 'Acting Allowance Percentage';
        }
        field(50045; "Acting Allowance Based On"; Option)
        {
            Caption = 'Acting Allowance Based On';
            OptionMembers = " ","Basic Pay","Gross Pay","Net Pay";
        }
        field(50046; "Acting Allowance Duration"; DateFormula)
        {
            Caption = 'Acting Allowance Duration';
        }
        field(50047; "Leave Allowance Based On"; Option)
        {
            Caption = 'Leave Allowance Based On';
            OptionMembers = " ","Basic Pay","Gross Pay","Net Pay";
        }
        field(50048; "Training Deduction Percentage"; Decimal)
        {
            Caption = 'Training Deduction Percentage';
        }
        field(50049; "Based On Hours Worked"; Option)
        {
            Caption = 'Based On Hours Worked';
            OptionMembers = " ","BasedOnWorkedHrs";
        }
        field(50050; "Monthly Expected Work Hrs"; Decimal)
        {
            Caption = 'Monthly Expected Work Hrs';
        }
        field(50051; "PrVitalsetup"; Decimal)
        {
            Caption = 'PrVitalsetup';
        }
        field(50052; "Salary Incremental %"; Decimal)
        {
            Caption = 'Salary Incremental %';
        }
        field(50053; "Max. Non Taxable"; Decimal)
        {

        }
        field(50054; "Housing Levy Relief"; Decimal)
        {

        }
        field(50055; "NHIF Relief"; Decimal)
        {

        }
        field(99000; "Housing Levy %"; Decimal)
        {

        }
        field(50056; "SHIF %"; Decimal)
        {

        }
        field(50057; "Earliest Start Time (Weekday)"; Time)
        {

        }
        field(50058; "Earliest Start Time (Weekend)"; Time)
        {
            Caption = 'Earliest Start Time (Weekend)';
        }

        field(50059; "Earliest End Time (Weekday)"; Time)
        {

        }
        field(50060; "Earliest End Time (Weekend)"; Time)
        {
            Caption = ' Earliest End Time (Weekend/Holiday)';
        }
        field(50061; "Max. hours (Weekdays)"; Decimal)
        {

        }
        field(50062; "Max. Hours (Weekend)"; Decimal)
        {
            Caption = 'Max. Hours (Weekend/Holiday)';
        }
        field(50063; "Overtime Rate (WeekDay)"; Decimal)
        {
            Caption = 'Overtime Rate (WeekDay)';
        }
        field(50064; "Overtime Rate (Weekend)"; Decimal)
        {
            Caption = 'Overtime Rate (Weekend)';
        }
        field(50065; "Daily Salary Rate"; Decimal)
        {
            Caption = 'Daily Salary Rate';
        }
        field(50070; "Checkoff-Cuttof Day"; DateFormula)
        {
            Caption = 'Checkoff-Cuttof Day';
        }


    }
    keys
    {
        key("PK"; "Setup Code")
        {
            Clustered = true;
        }
    }
}
