page 50734 "Loans Lookup Page"
{
    ApplicationArea = All;
    Caption = 'Loans Lookup Page';
    PageType = List;
    SourceTable = Loans;
    UsageCategory = Lists;
    Editable = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ToolTip = 'Specifies the value of the Application Date field.';
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    ApplicationArea = All;
                }
                field("Product Description"; Rec."Product Description")
                {
                    ToolTip = 'Specifies the value of the Product Description field.';
                    ApplicationArea = All;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ToolTip = 'Specifies the value of the Requested Amount field.';
                    ApplicationArea = All;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.';
                    ApplicationArea = All;
                }
                field("Disbursement Account No."; Rec."Disbursement Account No.")
                {
                    ToolTip = 'Specifies the value of the Disbursement Account No. field.';
                    ApplicationArea = All;
                }
                field("Loan Account"; Rec."Loan Account")
                {
                    ToolTip = 'Specifies the value of the Loan Account field.';
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                    ApplicationArea = All;
                }
                field(Installments; Rec.Installments)
                {
                    ToolTip = 'Specifies the value of the Installments field.';
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                    ApplicationArea = All;
                }
                field(Repayment; Rec.Repayment)
                {
                    ToolTip = 'Specifies the value of the Repayment field.';
                    ApplicationArea = All;
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ToolTip = 'Specifies the value of the Outstanding Interest field.';
                    ApplicationArea = All;
                }
                field("Outstanding Principal"; Rec."Outstanding Principal")
                {
                    ToolTip = 'Specifies the value of the Outstanding Principal field.';
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ToolTip = 'Specifies the value of the Outstanding Balance field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}



