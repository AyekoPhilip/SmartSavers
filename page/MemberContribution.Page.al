page 50731 "Member Contribution"
{
    ApplicationArea = All;
    Caption = 'Member Contribution';
    PageType = List;
    SourceTable = "Member Monthly Contribution";
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                    Visible=false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
              
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Amount Off"; Rec."Amount Off")
                {
                    ToolTip = 'Specifies the value of the Amount off field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                }
                  
                  

            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    begin

        ChangePermission.Get(UserId);
        if not ChangePermission."Edit Monthly Remittance" then
            Error('You are not allowed to edit or delete on this page');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangePermission.Get(UserId);
        if not ChangePermission."Edit Monthly Remittance" then
            Error('You are not allowed to edit or delete on this page');

    end;

    trigger OnOpenPage()
    begin
        ChangePermission.Reset();
        ChangePermission.SetRange("User ID", UserId);
        ChangePermission.SetRange("Edit Monthly Remittance", true);
        if ChangePermission.FindFirst() then begin
            CurrPage.Editable := true
        end else begin
            CurrPage.Editable := false
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if ProdFact.Get(Rec."Product Type") then
            ProDescription := ProdFact.Description else
            ProDescription := ''

    end;

    var
        ChangePermission: Record "Status Change Permissions";
        ProdFact: Record "Product Factory";
        ProDescription: Text[150];
}



