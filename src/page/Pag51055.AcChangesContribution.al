page 51055 "Ac. Changes -Contribution"
{
    ApplicationArea = All;
    Caption = 'Ac. Changes -Contribution';
    PageType = List;
    SourceTable = "Contribution-Changes";
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount Off"; Rec."Amount Off")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Off field.';
                }
                field("Advise Type"; Rec."Advise Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advise Type field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }
}



