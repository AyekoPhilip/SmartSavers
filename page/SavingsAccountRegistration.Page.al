page 50786 "Savings Account Registration"
{
    DeleteAllowed = false;
    Caption='Default Account';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Default Accounts Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Type"; Rec."Product Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Monthly Contribution"; Rec."Monthly Contribution")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Disbursement A/c"; Rec."Loan Disbursement A/c")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Source"; Rec."Account Source")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control9; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Apply Default Accounts")
            {
                Image = CalendarMachine;
                ApplicationArea = All;

                trigger OnAction()
                var
                    MemberAppl: Record "Member Application";
                begin

                    MemberAppl.Reset;
                    MemberAppl.SetRange("No.", Rec."No.");
                    if MemberAppl.FindFirst then begin
                        MemberAppl.fnValidateFields
                    end
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Apply Default Accounts_Promoted"; "Apply Default Accounts")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PageControl;
    end;


    procedure PageControl()
    var
        MemberAppl: Record "Member Application";
    begin
        if MemberAppl.Get(Rec."No.") then begin
            case MemberAppl."Approval Status" of
                MemberAppl."Approval Status"::"Pending Approval",
                 MemberAppl."Approval Status"::Approved,
                 MemberAppl."Approval Status"::Rejected,
                 MemberAppl."Approval Status"::Posted:
                    begin
                        CurrPage.Editable := false;
                    end;

                MemberAppl."Approval Status"::Open:
                    begin
                        CurrPage.Editable := true;
                    end;
            end;
        end;
    end;
}




