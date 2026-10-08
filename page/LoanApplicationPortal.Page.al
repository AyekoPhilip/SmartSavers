page 50007 "Loan Application-Portal"
{
    Caption = 'Loan Application-Portal';
    PageType = Card;
    SourceTable = "Loan Application-Portal";
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Date field.';
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application No. field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the approved amount field.';
                }
                field("Disbursement Account No."; Rec."Disbursement Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disbursement Account No. field.';
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                }
                field("Disbursement Destination"; Rec."Disbursement Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disbursement Destination field.';
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employer Code field.';
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Date of Completion field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID No. field.';
                }
                field("Installment Period"; Rec."Installment Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Installment Period field.';
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Installments field.';
                }
                field("Interest Calculation Method"; Rec."Interest Calculation Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Calculation Method field.';
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                }
                field("Interest Repayment"; Rec."Interest Repayment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Repayment field.';
                }
                field("Loan Account"; Rec."Loan Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Account field.';
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mode of Disbursement field.';
                }
                field("No. of Installment"; Rec."No. of Installment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Installment field.';
                }
                field("Old Account No."; Rec."Old Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Old Account No. field.';
                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll/Staff No. field.';
                }
                field("Principle Repayment"; Rec."Principle Repayment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Principle Repayment field.';
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Description field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Purpose of Loan"; Rec."Purpose of Loan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purpose of Loan field.';
                }
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recommended Amount field.';
                }
                field("Recovery Mode"; Rec."Recovery Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recovery Mode field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment field.';
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment Frequency field.';
                }
                field("Repayment Mode"; Rec."Repayment Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment Mode field.';
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment Start Date field.';
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested amount field.';
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                }
                field("Shares Deposit"; Rec."Shares Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shares Deposit field.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field("Sub Sectors"; Rec."Sub Sectors")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Sectors field.';
                }
                field("Time Created"; Rec."Time Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Created field.';
                }
            }
        }
    }
}



