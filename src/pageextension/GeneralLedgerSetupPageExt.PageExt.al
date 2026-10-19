pageextension 50012 "GeneralLedgerSetupPageExt" extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            
            group(Budgeting)
            {
                field("Budget Approval Nos"; Rec."Budget Approval Nos")
                {
                    ToolTip = 'Specifies the value of the Budget Approval Nos field.';
                    ApplicationArea = All;
                }
                field("Proposed Budget Approval Nos"; Rec."Proposed Budget Approval Nos")
                {
                    ToolTip = 'Specifies the value of the Proposed Budget Approval Nos field.';
                    ApplicationArea = All;
                }
                field("Current Budget"; Rec."Current Budget")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Budget field';
                }
                field("Current Budget Start Date"; Rec."Current Budget Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Budget Start Date field';
                }
                field("Current Budget End Date"; Rec."Current Budget End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Budget End Date field';
                }
                field("Use Dimensions For Budget"; Rec."Use Dimensions For Budget")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Use Dimensions For Budget field';
                }
                
            }
        }
    }
}


