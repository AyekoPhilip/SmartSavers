page 50124 "Rates & Ceiling List"
{
    ApplicationArea = All;
    Caption = 'Rates & Ceiling List';
    PageType = List;
    Editable = false;
    CardPageId="Rates & Ceiling";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Pr Vital Setup Info";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Max Pension Contribution"; Rec."Max Pension Contribution")
                {
                    ToolTip = 'Specifies the value of the Max Pension Contribution field.';
                }
                field("Max Relief"; Rec."Max Relief")
                {
                    ToolTip = 'Specifies the value of the Max Relief field.';
                }
                field("Minimun Relief Amount"; Rec."Minimun Relief Amount")
                {
                    ToolTip = 'Specifies the value of the Minimun Relief Amount field.';
                }
                field("Loan Corporate Rate"; Rec."Loan Corporate Rate")
                {
                    ToolTip = 'Specifies the value of the Loan Corporate Rate field.';
                }
                field("Tax On Excess Pension"; Rec."Tax On Excess Pension")
                {
                    ToolTip = 'Specifies the value of the Tax On Excess Pension field.';
                }
                field("Tax Relief"; Rec."Tax Relief")
                {
                    ToolTip = 'Specifies the value of the Tax Relief field.';
                }
            }
        }
    }
}
