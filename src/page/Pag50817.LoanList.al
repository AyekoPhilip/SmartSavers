page 50817 "Loan List"
{
    CardPageID = "Loans Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Loans;
    SourceTableView = where("Approval Status" = filter(Approved | Open), "Mode of Disbursement" = filter("Full Disbursement"));
    ApplicationArea = All;

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
                    StyleExpr = true;
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
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
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Account"; Rec."Loan Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Account No."; Rec."Disbursement Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Repayment"; Rec."Interest Repayment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Principle Repayment"; Rec."Principle Repayment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Recovery No."; Rec."Recovery No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control12; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control13; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        Filterstring: Text[250];
        FilterRespCentre: Code[10];
    begin
        if Usersetup.Get(UserId) then begin

            case Usersetup."User Type" of
                Usersetup."User Type"::"Approval Limits",
                Usersetup."User Type"::"Limited to User":
                    begin
                        Rec.SetRange("Captured By", Usersetup."User ID");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Centre", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end else begin
                    if UserMgt.GetLimitedUserFilter() <> '' then begin
                        Rec.FilterGroup(2);
                        Rec.SetRange("Responsibility Centre", UserMgt.GetLimitedUserFilter());
                        Rec.FilterGroup(0);
                    end;
                end;
            end;
        end else
            Error('User %1 ID not found', Usersetup."User ID");
    end;

    var
        Usersetup: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
}




