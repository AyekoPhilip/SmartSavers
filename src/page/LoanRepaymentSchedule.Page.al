page 50038 "Loan Repayment Schedule"
{
    ApplicationArea = All;
    Caption = 'Loan Repayment Schedule';
    PageType = List;
    SourceTable = "Repayment Schedule";
    UsageCategory = Lists;
    ModifyAllowed=false;
    DeleteAllowed=false;
    InsertAllowed=false;
    Editable=false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Instalment No"; Rec."Instalment No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Instalment No field.';
                }
                field("Loan Amount"; Rec."Loan Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Amount field.';
                }
                field("Loan Application No."; Rec."Loan Application No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Application No. field.';
                }
                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Balance field.';
                }
                field("Monthly Insurance"; Rec."Monthly Insurance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Monthly Insurance field.';
                }
                field("Monthly Interest"; Rec."Monthly Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Monthly Interest field.';
                }
                field("Monthly Repayment"; Rec."Monthly Repayment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Monthly Repayment field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Principal Repayment"; Rec."Principal Repayment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Principal Repayment field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Repayment Code"; Rec."Repayment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment Code field.';
                }
                field("Repayment Date"; Rec."Repayment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment Date field.';
                }
            }
        }
    }
}



