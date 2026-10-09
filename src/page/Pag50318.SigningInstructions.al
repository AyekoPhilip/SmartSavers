page 50318 "Signing Instructions"
{
    Caption = 'Signing Instructions';
    PageType = ListPart;
    SourceTable = "Signing Instructions";
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the No. field.';
                    Visible = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the ID No. field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Signatory; Rec.Signatory)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Signatory field.';
                }
                field("Must Sign"; Rec."Must Sign")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Must Sign field.';
                }
                field("Must be Present"; Rec."Must be Present")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Must be Present field.';
                }
                field(Available; Rec.Available)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Available field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SelectMultiItems)
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Photo';
                Ellipsis = true;
                Image = PostedShipment;
                ToolTip = 'View Photos.';
                RunObject = page "Signatory Picture";
                RunPageLink = "Account No." = FIELD("Account No."), "ID No." = FIELD("ID No.");
                trigger OnAction()
                begin

                end;
            }
            action(SelectMultiItem)
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Signature';
                Ellipsis = true;
                Image = PostedShipment;
                ToolTip = 'View Signature.';
                RunObject = page "Signatory Signature";
                RunPageLink = "Account No." = FIELD("Account No."), "ID No." = FIELD("ID No.");
                trigger OnAction()
                begin

                end;
            }

        }

    }
}



