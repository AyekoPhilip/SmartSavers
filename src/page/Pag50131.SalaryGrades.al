page 50131 "Salary Grades"
{
    ApplicationArea = All;
    Caption = 'Salary Grades';
    PageType = List;
    SourceTable = "Pr Salary Grade";
    UsageCategory = Administration;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Salary Amount"; Rec."Salary Amount")
                {
                    ToolTip = 'Specifies the value of the Salary Amount field.';
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ToolTip = 'Specifies the value of the Minimum Amount field.';
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ToolTip = 'Specifies the value of the Maximum Amount field.';
                }
                field("Pays NHIF"; Rec."Pays NHIF")
                {
                    ToolTip = 'Specifies the value of the Pays NHIF field.';
                }
                field("Pays NSSF"; Rec."Pays NSSF")
                {
                    ToolTip = 'Specifies the value of the Pays NSSF field.';
                }
            }
        }
    }
}
