page 51102 "Kin Beneficiary"
{
    ApplicationArea = All;
    Caption = 'Kin Beneficiary';
    PageType = List;
    SourceTable = "Next of KIN";
    UsageCategory = Lists;
    SourceTableView = where(Type=filter("Benevolent Beneficiary"));
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Relationship; Rec.Relationship)
                {
                    ToolTip = 'Specifies the value of the Relationship field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Beneficiary; Rec.Beneficiary)
                {
                    ToolTip = 'Specifies the value of the Beneficiary field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    Caption = 'ID No./Birth Cert. No.';
                    ToolTip = 'Specifies the value of the ID No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                 field("BBF Entitlement"; Rec."BBF Entitlement Code")
                {
                    ToolTip = 'Specifies the value of the BBF field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Allocation; Rec.Allocation)
                {
                    ToolTip = 'Specifies the value of the Allocation field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Telephone; Rec.Telephone)
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
               
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Account No"; Rec."Account No")
                {
                    ToolTip = 'Specifies the value of the Account No field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Application No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        MNotice.Reset();
        MNotice.SetRange("No.", Rec."Application No.");
        MNotice.SetRange("Approval Status", MNotice."Approval Status"::Open);
        if MNotice.FindFirst() then
            CurrPage.Editable := true else
            CurrPage.Editable := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Benevolent Beneficiary";
        Rec.Beneficiary := true;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::"Benevolent Beneficiary";
        Rec.Beneficiary := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        MNotice.Reset();
        MNotice.SetRange("No.", Rec."Application No.");
        MNotice.SetRange("Approval Status", MNotice."Approval Status"::Open);
        if MNotice.FindFirst() then
            CurrPage.Editable := true else
            CurrPage.Editable := false;

    end;

    trigger OnAfterGetRecord()
    begin
        MNotice.Reset();
        MNotice.SetRange("No.", Rec."Application No.");
        MNotice.SetRange("Approval Status", MNotice."Approval Status"::Open);
        if MNotice.FindFirst() then
            CurrPage.Editable := true else
            CurrPage.Editable := false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        MNotice.Reset();
        MNotice.SetRange("No.", Rec."Application No.");
        MNotice.SetRange("Approval Status", MNotice."Approval Status"::Open);
        if MNotice.FindFirst() then
            CurrPage.Editable := true else
            Error(ErrorOnPermission, MNotice."Approval Status");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        MNotice.Reset();
        MNotice.SetRange("No.", Rec."Application No.");
        MNotice.SetRange("Approval Status", MNotice."Approval Status"::Open);
        if MNotice.FindFirst() then
            CurrPage.Editable := true else
            Error(ErrorOnPermission, MNotice."Approval Status");
    end;

    var
        MNotice: Record "Member withdrawal Notice";
        ErrorOnPermission: Label 'Modify/Delete Operation not allowed on this Application. Status - %1';
}
