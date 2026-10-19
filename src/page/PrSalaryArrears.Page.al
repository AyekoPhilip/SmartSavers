page 50108 "Pr Salary Arrears"
{
    ApplicationArea = All;
    Caption = 'Pr Salary Arrears';
    PageType = List;
    SourceTable = "Pr Salary Arrears";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';

                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("Salary Arrears"; Rec."Salary Arrears")
                {
                    ToolTip = 'Specifies the value of the Salary Arrears field.';
                }
                field("PAYE Arrears"; Rec."PAYE Arrears")
                {
                    ToolTip = 'Specifies the value of the PAYE Arrears field.';
                }
                field("Period Month"; Rec."Period Month")
                {
                    ToolTip = 'Specifies the value of the Prriod Month field.';
                }
                field("Period Year"; Rec."Period Year")
                {
                    ToolTip = 'Specifies the value of the Period Year field.';
                }
                field("Current Basic"; Rec."Current Basic")
                {
                    ToolTip = 'Specifies the value of the Current Basic field.';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
            }
        }
    }
}
