page 50914 "Buffer Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Buffer Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
                field("Shares Account No."; Rec."Shares Account No.")
                {
                    ApplicationArea = All;
                }
                field("Deposits Account No."; Rec."Deposits Account No.")
                {
                    ApplicationArea = All;
                }
                field("Shares Balance"; Rec."Shares Balance")
                {
                    ApplicationArea = All;
                }
                field("Deposit Balance"; Rec."Deposit Balance")
                {
                    ApplicationArea = All;
                }
                field("Product Minimum Bal."; Rec."Product Minimum Bal.")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Product Category"; Rec."Product Category")
                {
                    ApplicationArea = All;
                }
                field("Shares Drive Balance"; Rec."Shares Drive Balance")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




