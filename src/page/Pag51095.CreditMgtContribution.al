page 51095 "Credit. Mgt Contribution"
{
    ApplicationArea = All;
    Caption = 'Credit. Mgt Contribution';
    PageType = List;
    SourceTable = "Member Monthly Contribution";
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    SourceTableView = where("Advise Type" = filter(<> Stoppage), Type = filter("Shares Capital" | "Shares Deposit" | "Specialty Savings"));

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
                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field(ProDescription; ProDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Product Description';
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
                    ToolTip = 'Specifies the value of the Amount off field.';
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
    trigger OnModifyRecord(): Boolean
    begin
        ChangePermission.Reset();
        ChangePermission.SetRange("User ID", UserId);
        ChangePermission.SetRange("Edit Data Sheet", true);
        if not ChangePermission.Find('-') then begin
            Error('You are not allowed to edit or delete on this page');
        end
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangePermission.Reset();
        ChangePermission.SetRange("User ID", UserId);
        ChangePermission.SetRange("Edit Data Sheet", true);
        if not ChangePermission.Find('-') then begin
            Error('You are not allowed to edit or delete on this page');
        end

    end;

    trigger OnOpenPage()
    begin
        ChangePermission.Reset();
        ChangePermission.SetRange("User ID", UserId);
        ChangePermission.SetRange("Edit Data Sheet", true);
        if ChangePermission.FindFirst() then begin
            CurrPage.Editable := true
        end else begin
            CurrPage.Editable := false
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ChangePermission.Reset();
        ChangePermission.SetRange("User ID", UserId);
        ChangePermission.SetRange("Edit Data Sheet", true);
        if ChangePermission.Find('-') then begin
            if Rec.Type = Rec.Type::" " then
                Error('You are not allowed to edit or delete on this page');
        end else begin
            Error('You are not allowed to edit or delete on this page');
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if ProdFact.Get(Rec."Product Type") then
            ProDescription := ProdFact.Description else
            ProDescription := '';

        ChangePermission.Reset();
        ChangePermission.SetRange("User ID", UserId);
        ChangePermission.SetRange("Edit Data Sheet", true);
        if ChangePermission.FindFirst() then begin
            CurrPage.Editable := true
        end else begin
            CurrPage.Editable := false
        end;

    end;

    var
        ChangePermission: Record "Status Change Permissions";
        ProdFact: Record "Product Factory";
        ProDescription: Text[150];
}
