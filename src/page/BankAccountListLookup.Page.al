page 51066 "Bank Account List Lookup"
{
    ApplicationArea = All;
    Caption = 'Bank Account List Lookup';
    PageType = List;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Cust. Bank Account";
    UsageCategory = Lists;

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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a code to identify this customer bank account.';
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ToolTip = 'Specifies the number of the bank branch.';
                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }
            }
        }
    }
}
