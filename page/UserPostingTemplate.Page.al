page 50072 "User Posting Template"
{
    PageType = List;
    SourceTable = "User Posting Template";
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
                field("Petty Cash Journal Template"; Rec."Petty Cash Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Journal Template field';
                }
                field("Petty Cash Journal Batch"; Rec."Petty Cash Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Journal Batch field';
                }
                field("Bank Trans. Journal Template"; Rec."Bank Trans. Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Trans. Journal Template field';
                }
                field("Bank Trans. Journal Batch"; Rec."Bank Trans. Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Trans. Journal Batch field';
                }
                field("Item Journal Template"; Rec."Item Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Template field';
                }
                field("Item Journal Batch"; Rec."Item Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Batch field';
                }
                field("Payroll Journal Template"; Rec."Payroll Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Journal Template field';
                }
                field("Payroll Journal Batch"; Rec."Payroll Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Journal Batch field';
                }
                field("Job Journal Template"; Rec."Job Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Journal Template field';
                }
                field("Job Journal Batch"; Rec."Job Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Journal Batch field';
                }
            }
        }
    }

    actions
    {
    }
}


