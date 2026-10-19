page 50488 "Proctected Accounts"
{
    ApplicationArea = All;
    Caption = 'Proctected Accounts';
    PageType = List;
    SourceTable = "Proctected Account";
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
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Restrcit Viewship (Record)"; Rec."Restrcit Viewship (Record)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restrcit Viewship (Record) field.';
                }
                field("Restrict Viewship (ATM Card)"; Rec."Restrict Viewship (ATM Card)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Account Card) field.';
                }
                field("Restrict Viewship (Balance)"; Rec."Restrict Viewship (Balance)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Balance) field.';
                }
                field("Restrict Viewship (Mobile No.)"; Rec."Restrict Viewship (Mobile No.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Transactional Mobile No.) field.';
                }
                field("Restrict Viewship (Statement)"; Rec."Restrict Viewship (Statement)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Statement) field.';
                }
            }
        }
    }
}



