
page 90002"Loan Appraisal Parameter"
{
    ApplicationArea = All;
    Caption = 'Loan Appraisal Parameter';
    PageType = List;
    SourceTable = "Loan Appraisal Parameter";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.', Comment = '%';
                }
                field("Application Date"; Rec."Application Date")
                {
                    ToolTip = 'Specifies the value of the Application Date field.', Comment = '%';
                }
                field("Net On Deposit"; Rec."Net On Deposit")
                {
                    ToolTip = 'Specifies the value of the Net On Deposit field.', Comment = '%';
                }
                field("Net On Salary"; Rec."Net On Salary")
                {
                    ToolTip = 'Specifies the value of the Net On Salary field.', Comment = '%';
                }
                field("Net Pay"; Rec."Net Pay")
                {
                    ToolTip = 'Specifies the value of the Net Pay field.', Comment = '%';
                }
                field("Net Salary"; Rec."Net Salary")
                {
                    ToolTip = 'Specifies the value of the Net Salary field.', Comment = '%';
                }
                field("Net Utilisable Amount"; Rec."Net Utilisable Amount")
                {
                    ToolTip = 'Specifies the value of the Net Utilisable Amount field.', Comment = '%';
                }
                field("Net utilizable"; Rec."Net utilizable")
                {
                    ToolTip = 'Specifies the value of the Net utilizable field.', Comment = '%';
                }
                field("New Amount"; Rec."New Amount")
                {
                    ToolTip = 'Specifies the value of the New Amount field.', Comment = '%';
                }
                field("New Excess Amount"; Rec."New Excess Amount")
                {
                    ToolTip = 'Specifies the value of the New Excess Amount field.', Comment = '%';
                }
                field("New Net Salary"; Rec."New Net Salary")
                {
                    ToolTip = 'Specifies the value of the New Net Salary field.', Comment = '%';
                }
                field("Gross Pay"; Rec."Gross Pay")
                {
                    ToolTip = 'Specifies the value of the Gross Pay field.', Comment = '%';
                }
                field("Gross Pay %"; Rec."Gross Pay %")
                {
                    ToolTip = 'Specifies the value of the Gross Pay % field.', Comment = '%';
                }
            }
        }
    }
}
