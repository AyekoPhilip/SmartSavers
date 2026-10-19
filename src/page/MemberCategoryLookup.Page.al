page 51068 "Member Category Lookup"
{
    ApplicationArea = All;
    Caption = 'Member Category Lookup';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Member Category";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Terms of Service"; Rec."Terms of Service")
                {
                    ToolTip = 'Specifies the value of the Terms of Service field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Share Capital"; Rec."Share Capital")
                {
                    ToolTip = 'Specifies the value of the Share Capital field.';
                }
                field("Registration Fee"; Rec."Registration Fee")
                {
                    ToolTip = 'Specifies the value of the Registration Fee field.';
                }
                field("Default Share Deposit"; Rec."Default Share Deposit")
                {
                    ToolTip = 'Specifies the value of the Default Share Deposit field.';
                }
                field("Default Share Capital"; Rec."Default Share Capital")
                {
                    ToolTip = 'Specifies the value of the Default Share Capital field.';
                }
                field("Max. Installment"; Rec."Max. Installment")
                {
                    ToolTip = 'Specifies the value of the Max. Installment field.';
                }
                field("Premier Club Min.Deposits"; Rec."Premier Club Min.Deposits")
                {
                    ToolTip = 'Specifies the value of the Premier Club Min.Deposits field.';
                }
                field("Can Take Loan"; Rec."Can Take Loan")
                {
                    ToolTip = 'Specifies the value of the Can Take Loan field.';
                }
                field("Cannot Guarantee Loan"; Rec."Cannot Guarantee Loan")
                {
                    ToolTip = 'Specifies the value of the Cannot Guarantee Loan field.';
                }
                field(Checkoff; Rec.Checkoff)
                {
                    ToolTip = 'Specifies the value of the Checkoff field.';
                }
            }
        }
    }
}
