page 50730 "Member Contribution Applic."
{
    ApplicationArea = All;
    Caption = 'Member Contribution Applic.';
    PageType = List;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
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
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Advise Type"; Rec."Advise Type")
                {
                    ToolTip = 'Specifies the value of the Advise field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Amount Off"; Rec."Amount Off")
                {
                    ToolTip = 'Specifies the value of the Amount Off field.';
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnOpenPage()
    var
        Application: Record "Member Application";
    begin
        Application.Reset();
        Application.SetRange("No.", Rec."Account No.");
        if Application.FindFirst() then begin
            if Application."Approval Status" = Application."Approval Status"::Open then
                CurrPage.Editable := true else
                CurrPage.Editable := false;
        end

    end;
}



