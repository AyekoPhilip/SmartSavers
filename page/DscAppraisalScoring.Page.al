page 50023 "Dsc. Appraisal Scoring"
{
    ApplicationArea = All;
    Caption = 'Dsc. Appraisal Scoring';
    PageType = Card;
    SourceTable = "DSC Appraisal Scoring";
    UsageCategory = Lists;
    ModifyAllowed = false;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Product Type";Rec."Product Type")
                {
                    ApplicationArea = All;

                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field.';
                }
                field("Membership Age"; Rec."Membership Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Membership Age field.';
                }
                field("Monthly Contribution"; Rec."Monthly Contribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Monthly Contribution field.';
                }
                field("Monthly Deposit"; Rec."Monthly Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Monthly Deposit field.';
                }
                field("Deposit Exposure"; Rec."Deposit Exposure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deposit Exposure field.';
                }
                field("Banking Remittance"; Rec."Banking Remittance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Banking Remittance field.';
                }
                field("Credit History"; Rec."Credit History")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit History field.';
                }
                field("Individual Score"; Rec."Individual Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Individual Score field.';
                }
                field(Parameter; Rec.Parameter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parameter field.';
                }
                field("Shares Banding"; Rec."Shares Banding")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shares Banding field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Qualify Amount"; Rec."Qualify Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qualify Amount field.';
                }
                field("Total Deposits"; Rec."Total Deposits")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Deposits field.';
                }
                field("Score (Max. Score)"; Rec."Score (Max. Score)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Score (Max. Score) field.';
                }
                field("Total Score"; Rec."Total Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Score field.';
                }
                field("Existing Member"; Rec."Existing Member")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Existing Member field.';
                }
            }
        }
    }
}



