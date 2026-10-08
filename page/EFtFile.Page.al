page 51081 "EFt File"
{
    ApplicationArea = All;
    Caption = 'EFt File';
    PageType = List;
    SourceTable = "EFT File";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ToolTip = 'Specifies the value of the Sequence No. field.';
                }
                field("EFT No."; Rec."EFT No.")
                {
                    ToolTip = 'Specifies the value of the EFT No. field.';
                }
                 field("File No."; Rec."File No.")
                {
                    ToolTip = 'Specifies the value of the File No. field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {

                }
                field("Bank Account No."; Rec."Bank Account No.")
                {

                }
                field("Account Name"; Rec."Account Name")
                {

                }
                field("Product Type"; Rec."Product Type")
                {

                }
                field("No. of Files"; Rec."No. of Files")
                {
                    ToolTip = 'Specifies the value of the No. of Files field.';
                }

                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ToolTip = 'Specifies the value of the EFT Options field.';
                }
                field("Captured By"; Rec."Captured By")
                {
                    ToolTip = 'Specifies the value of the Captured By field.';
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ToolTip = 'Specifies the value of the Date Entered field.';
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    ToolTip = 'Specifies the value of the Time Entered field.';
                }
            }
        }
    }
}
