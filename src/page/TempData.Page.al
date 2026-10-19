page 50009 "Temp Data"
{
    ApplicationArea = All;
    Caption = 'Temp Data';
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Amount field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Date field.';
                }

                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field(Installment; Rec.Installment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Installment field.';
                }
                field(Interest; Rec.Interest)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest field.';
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued Date field.';
                }

                field("Outstanding Bal"; Rec."Outstanding Bal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Bal field.';
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Interest field.';
                }
                field("Principal Member"; Rec."Old Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Principal Member field.';
                }
                field("Repayement Start Date"; Rec."Repayement Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayement Start Date field.';
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment field.';
                }
                field("Shares Capital"; Rec."Shares Capital")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shares Capital field.';
                }
                field("Shares Deposits"; Rec."Shares Deposits")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shares Deposits field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Account Found"; Rec."Account Found")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Found field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}



