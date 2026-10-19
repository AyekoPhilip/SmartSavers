page 50101 Receipt
{
    CardPageID = "Receipt Header";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Receipts Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable=false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755010; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102760016>")
            {
                Caption = 'Print';
                Image = Print;
                trigger OnAction()
                begin
                   Rec.TestField(Posted, true);
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    Report.Run(Report::"Official Receipt", true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("<Action1102760016>_Promoted"; "<Action1102760016>")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
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
        Usersetup: Record "User Setup";
        Temp: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        UserMgt: Codeunit "User Setup Management BR";
}


