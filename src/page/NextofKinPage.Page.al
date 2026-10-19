page 51061 "Next of Kin Page"
{
    ApplicationArea = All;
    Caption = 'Next of Kin Page';
    PageType = Card;
    SourceTable = "Next of KIN Application";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Information';

                field("Account No"; Rec."Account No")
                {
                    ToolTip = 'Specifies the value of the Account No field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = false;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                    ValuesAllowed=0,2;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Relationship; Rec.Relationship)
                {
                    ToolTip = 'Specifies the value of the Relationship field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Beneficiary;Rec.Beneficiary)
                {
                    ToolTip = 'Specifies the value of the Next of Kin field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field(Allocation; Rec.Allocation)
                {
                    ToolTip = 'Specifies the value of the Allocation field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Communication)
            {
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Nationality; Rec.Nationality)
                {
                    ToolTip = 'Specifies the value of the Nationality field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Telephone; Rec.Telephone)
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Fax; Rec.Fax)
                {
                    ToolTip = 'Specifies the value of the Fax field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
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
    actions
    {

    }
    trigger OnOpenPage()
    begin
        if Applications.Get(Rec."Account No") then begin
            if Applications."Approval Status" = Applications."Approval Status"::Open then
                CurrPage.Editable := true else
                CurrPage.Editable := false;
        end;
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    var
        Applications: Record "Member Application";
}
