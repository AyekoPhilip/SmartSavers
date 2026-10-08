page 50119 "Cash Office User Template"
{
    PageType = List;
    SourceTable = "Cash Office User Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserID field';
                }
                field("Responsibility Centre";Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserID field';

                }
                field("Shortcut Dimension 1 Code";Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserID field';

                }
                field("Shortcut Dimension 2 Code";Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserID field';

                }
                field("Receipt Journal Template"; Rec."Receipt Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Journal Template field';
                }
                field("Receipt Journal Batch"; Rec."Receipt Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Journal Batch field';
                }
                field("Payment Journal Template"; Rec."Payment Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Journal Template field';
                }
                field("Payment Journal Batch"; Rec."Payment Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Journal Batch field';
                }
                field("Petty Cash Template"; Rec."Petty Cash Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Template field';
                }
                field("Petty Cash Batch"; Rec."Petty Cash Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Batch field';
                }
                field("Inter Bank Template Name"; Rec."Inter Bank Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inter Bank Template Name field';
                }
                field("Inter Bank Batch Name"; Rec."Inter Bank Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inter Bank Batch Name field';
                }
                field("Default Receipts Bank"; Rec."Default Receipts Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Receipts Bank field';
                }
                field("Default Payment Bank"; Rec."Default Payment Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Payment Bank field';
                }
                field("Default Petty Cash Bank"; Rec."Default Petty Cash Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Petty Cash Bank field';
                }
                field("Max. Cash Collection"; Rec."Max. Cash Collection")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Cash Collection field';
                }
                field("Max. Cheque Collection"; Rec."Max. Cheque Collection")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Cheque Collection field';
                }
                field("Max. Deposit Slip Collection"; Rec."Max. Deposit Slip Collection")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Deposit Slip Collection field';
                }
                field("Supervisor ID"; Rec."Supervisor ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supervisor ID field';
                }
                field("Bank Pay In Journal Template"; Rec."Bank Pay In Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Pay In Journal Template field';
                }
                field("Bank Pay In Journal Batch"; Rec."Bank Pay In Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Pay In Journal Batch field';
                }
                field("Imprest Template"; Rec."Imprest Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Template field';
                }
                field("Imprest  Batch"; Rec."Imprest  Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest  Batch field';
                }
                field("Claim Template"; Rec."Claim Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claim Template field';
                }
                field("Claim  Batch"; Rec."Claim  Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claim  Batch field';
                }
                field("Advance Template"; Rec."Advance Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Advance Template field';
                }
                field("Advance  Batch"; Rec."Advance  Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Advance  Batch field';
                }
                field("Advance Surr Template"; Rec."Advance Surr Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Advance Surr Template field';
                }
                field("Advance Surr Batch"; Rec."Advance Surr Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Advance Surr Batch field';
                }
                field("Imprest Sur Template"; Rec."Imprest Sur Template")
                {
                    Caption = 'Imprest Surrender Template';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Surrender Template field';
                }
                field("Imprest Sur Batch"; Rec."Imprest Sur Batch")
                {
                    Caption = 'Imprest Surrender Batch';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Surrender Batch field';
                }
            }
        }
    }

    actions
    {
    }
}


