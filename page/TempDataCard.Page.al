page 51067 "Temp Data Card"
{
    ApplicationArea = All;
    Caption = 'Temp Data Card';
    PageType = List;
    SourceTable = "Temp Data";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Application Date"; Rec."Application Date")
                {
                    ToolTip = 'Specifies the value of the Application Date field.';
                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Application No. field.';
                }
                field(Interest; Rec.Interest)
                {
                    ToolTip = 'Specifies the value of the Interest field.';
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ToolTip = 'Specifies the value of the Issued Date field.';
                }
                field("Old Account No."; Rec."Old Account No.")
                {
                    ToolTip = 'Specifies the value of the Principal Member field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Product Type Found"; Rec."Product Type Found")
                {
                    ToolTip = 'Specifies the value of the Product Type Found field.';
                }
                field("Repayement Start Date"; Rec."Repayement Start Date")
                {
                    ToolTip = 'Specifies the value of the Repayement Start Date field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Client Code"; Rec."Client Code")
                {
                    ToolTip = 'Specifies the value of the Client Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Disbursment Acc"; Rec."Disbursment Acc")
                {
                    ToolTip = 'Specifies the value of the Disbursment Acc field.';
                }
                field(Idemnity; Rec.Idemnity)
                {
                    ToolTip = 'Specifies the value of the Idemnity field.';
                }
                field("Account Found"; Rec."Account Found")
                {
                    ToolTip = 'Specifies the value of the Account Found field.';
                }
                field(Installment; Rec.Installment)
                {
                    ToolTip = 'Specifies the value of the Installment field.';
                }
                field("Outstanding Bal"; Rec."Outstanding Bal")
                {
                    ToolTip = 'Specifies the value of the Outstanding Bal field.';
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ToolTip = 'Specifies the value of the Outstanding Interest field.';
                }
                field(Repayment; Rec.Repayment)
                {
                    ToolTip = 'Specifies the value of the Repayment field.';
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ToolTip = 'Specifies the value of the Requested Amount field.';
                }
                field("Shares Capital"; Rec."Shares Capital")
                {
                    ToolTip = 'Specifies the value of the Shares Capital field.';
                }
                field("Shares Deposits"; Rec."Shares Deposits")
                {
                    ToolTip = 'Specifies the value of the Shares Deposits field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Introduced by"; Rec."Introduced by")
                {
                    ToolTip = 'Specifies the value of the Introduced by field.';
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                }
            }
        }
    }
}
