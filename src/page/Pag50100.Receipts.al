page 50100 "Receipts"
{
    Editable = false;
    PageType = List;
    SourceTable = "Receipts Header";
    SourceTableView = where(Posted = const(false));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Received From"; Rec."Received From")
                {
                }
                field("Bank Code"; Rec."Bank Code")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Cashier; Rec.Cashier)
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
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

        UserSetup.Reset;
        if UserSetup.Get(UserId) then begin
            JTemplate := UserSetup."Receipt Journal Template";
            JBatch := UserSetup."Receipt Journal Batch";
        end;
        Rec."Application Type" := Rec."Application Type"::Member;

        if TempRec.Get(UserId) then begin

            case TempRec."User Type" of
                TempRec."User Type"::"Limited to User":
                    begin
                        Rec.SetRange("Created By", UserId);
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Center", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end;
                TempRec."User Type"::"Approval Limits":
                    begin
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Center", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end;
                TempRec."User Type"::"View All":
                    begin
                        TempRec.TestField("Office/Group");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            FilterApproverID := '';
                            FilterApproverID := TempRec."Office/Group";
                            Rec.SetFilter("Responsibility Center", ('%1|%2'), FilterApproverID, UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end;
            end;
        end else
            Error('User %1 ID not found', TempRec."User ID");
    end;

    var
        UserSetup: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        Filterstring: Text[250];
        FilterRespCentre: Code[10];
        TempRec: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
  
}


