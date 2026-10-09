page 51017 "Mobile Registration List"
{
    ApplicationArea = All;
    Caption = 'Mobile Registration List';
    PageType = List;
    SourceTable = "Dsc Mobile Application";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Mobile Registration Page";

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
                field("Customer ID No"; Rec."Customer ID No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer ID No field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Entered field.';
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entered By field.';
                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Type field.';
                }
            }
        }
    }
}



