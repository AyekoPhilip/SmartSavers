page 50813 "Standing Order Register List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Standing Order Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Date Processed"; Rec."Date Processed")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Source Account No."; Rec."Source Account No.")
                {
                    ApplicationArea = All;
                }
                field("Source Account Name"; Rec."Source Account Name")
                {
                    ApplicationArea = All;
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                }
                field("Allow Partial Deduction"; Rec."Allow Partial Deduction")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Deducted"; Rec."Amount Deducted")
                {
                    ApplicationArea = All;
                }
                field("Fosa Balance"; Rec."Fosa Balance")
                {
                    ApplicationArea = All;

                }
                field("Deduction Status"; Rec."Deduction Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Process Standing Order")
            {
                Image = Add;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ProcessStandingOrder: Codeunit "Registry Mngt.";
                begin
                    ProcessStandingOrder.Run;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Process Standing Order_Promoted"; "Process Standing Order")
                {
                }
            }
        }
    }
}




