page 51094 "Customer Bank Ac. List"
{
    ApplicationArea = All;
    Caption = 'Customer Bank Ac. List';
    PageType = List;
    SourceTable = "Cust. Bank Account";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ToolTip = 'Specifies the number of the bank branch.';
                }
               
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a code to identify this customer bank account.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
               
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }
            }
        }
    }
}
