page 50922 "Standing Order-Approved List"
{
    ApplicationArea = All;
    Caption = 'Standing Order-Approved List';
    PageType = List;
    SourceTable = "Standing Order Header";
    UsageCategory = History;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    CardPageID = "Standing Order";
    SourceTableView = where("Approval Status" = filter(Approved));
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
                field("Source Account No."; Rec."Source Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Account No. field.';
                }
                field("Source Account Name"; Rec."Source Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Account Name field.';
                }
                field("Source Account Type"; Rec."Source Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Account Type field.';
                }
                field("Standing Order Type"; Rec."Standing Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Standing Order Type field.';
                }
                field("Effective/Start Date"; Rec."Effective/Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Effective/Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Income Type"; Rec."Income Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Income Type field.';
                }
                field("Next Run Date"; Rec."Next Run Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Run Date field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}



