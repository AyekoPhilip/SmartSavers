page 50385 "Alt. Channel Account"
{
    ApplicationArea = All;
    Caption = 'Alt. Channel Account';
    PageType = List;
    SourceTable = "Account (Procedure)";
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    SourceTableView = where("Account Category" = const(Savings));
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Mobile Transaction Status"; Rec."Mobile Transaction Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Card Status"; Rec."Card Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Internet Banking"; Rec."Internet Banking")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action20)
            {
                action(Statement)
                {
                    Image = CustomerGroup;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                actionref(Statement_Promoted; Statement)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.Name := UpperCase(Rec.Name)
    end;

    trigger OnOpenPage()
    begin

    end;


}



