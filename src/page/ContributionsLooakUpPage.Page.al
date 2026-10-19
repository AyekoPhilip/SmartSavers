page 50010 "Contributions LooakUp Page"
{
    ApplicationArea = All;
    Caption = 'Contributions LookUp Page';
    PageType = List;
    Editable=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable = "Monthly Contribution Applic.";
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
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
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
                    ToolTip = 'Specifies the value of the Advise field.';
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



