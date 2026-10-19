page 50048 "Account Change List"
{
    ApplicationArea = All;
    Caption = 'Account Change List';
    PageType = List;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    CardPageId = "Account Change-Card";
    SourceTable = "Account Application";
    SourceTableView = where("Application Type" = filter("Account Changes"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {

    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Application Source" := Rec."Application Source"::Navision;
        Rec."Application Type" := Rec."Application Type"::"Account Changes";
    end;
}



