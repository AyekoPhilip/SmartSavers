page 50056 "Dividend Listing"
{
    ApplicationArea = All;
    Caption = 'Dividend Listing';
    PageType = List;
    CardPageId = "Dividend Simulation Header";
    SourceTable = "Dividend Simulation Header";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
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
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("Operation Type"; Rec."Operation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Operation Type field.';
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Type field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }

            }
        }
    }
}



