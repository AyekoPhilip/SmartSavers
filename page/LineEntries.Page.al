page 50032 "Line Entries"
{
    ApplicationArea = All;
    Caption = 'Line Entries';
    PageType = List;
    SourceTable = "Interest Line";
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false; 
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account Matured"; Rec."Account Matured")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Matured field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrued Interest field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Appraisal Amount"; Rec."Appraisal Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Appraisal Amount field.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                }
                field("Bal. Account No. (Suspence)"; Rec."Bal. Account No. (Suspence)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                }
                field("Bill Account"; Rec."Bill Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Account field.';
                }
                field("Bill Loan"; Rec."Bill Loan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Loan field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Charge Interest"; Rec."Charge Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Interest field.';
                }
                field("Date Captured"; Rec."Date Captured")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Captured field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Interest Bills"; Rec."Interest Bills")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Bills field.';
                }
                field("Interest Date"; Rec."Interest Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Date field.';
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued Date field.';
                }
                field("Late Interest"; Rec."Late Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Late Interest field.';
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan No. field.';
                }
                field("Loans Category-Sasra"; Rec."Loans Category-Sasra")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loans Category-Sasra field.';
                }
                field("Mark For Deletion"; Rec."Mark For Deletion")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mark For Deletion field.';
                }
                field("Monthly Repayment"; Rec."Monthly Repayment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Monthly Repayment field.';
                }
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Balance field.';
                }
                field("Outstanding Bills"; Rec."Outstanding Bills")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Bills field.';
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Interest field.';
                }
                field("Outstanding Principal"; Rec."Outstanding Principal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Principal field.';
                }
                field("Penalty Bills"; Rec."Penalty Bills")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Penalty Bills field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Transfer Interest to Susp Ac."; Rec."Transfer Interest to Susp Ac.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Interest to Susp Ac. field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
            }
        }
    }
}



