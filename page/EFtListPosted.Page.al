page 50757 "EFt List-Posted"
{
    ApplicationArea = All;
    Caption = 'EFt List-Posted';
    PageType = List;
    SourceTable = "EFT Transfer Header";
    UsageCategory = History;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Approval Status" = const(Transferred));
    CardPageId = "EFT Transfer Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
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
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Entered field.';
                }
                field("Date Transferred"; Rec."Date Transferred")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Transferred field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
            }
        }
    }
}



