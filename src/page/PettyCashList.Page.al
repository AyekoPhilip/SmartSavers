page 50094 "Petty Cash List"
{
    CardPageID = "Petty Cash";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Payments Header";
    SourceTableView = where("Payment Type" = const("Petty Cash"));
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Date field';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Pay Mode field';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Payee field';
                }
                field("Payment Narration"; Rec."Payment Narration")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Payment Narration field';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Created By field';
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Status field';
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Currency field';
                }

                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Cashier field';
                }

            }
        }
        area(factboxes)
        {
            systempart(Control12; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control13; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control14; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

    end;

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
                        Rec.SetRange("Created By", Usersetup."User ID");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Center", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end else begin
                    if UserMgt.GetLimitedUserFilter() <> '' then begin
                        Rec.FilterGroup(2);
                        Rec.SetRange("Responsibility Center", UserMgt.GetLimitedUserFilter());
                        Rec.FilterGroup(0);
                    end;
                end;
            end;
        end else
            Error('User ID not found');

    end;

    var

        ObjEmp: Record Customer;
        ObjName: Text[150];
        Usersetup: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
}