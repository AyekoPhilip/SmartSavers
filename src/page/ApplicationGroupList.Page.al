page 50780 "Application Group List"
{
    CardPageID = "Application Group";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Member Application";
    SourceTableView = WHERE("Approval Status" = FILTER(Open | "Pending Approval"),
                            "Customer Type" = CONST(Groups),
                            "Group Account" = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control13)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Company Registration No."; Rec."Company Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("P.I.N Number"; Rec."PIN No.")
                {
                    Caption = 'PIN No.';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




