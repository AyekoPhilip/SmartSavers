page 50083 "Imprest List"
{
    ApplicationArea = All;
    Caption = 'Imprest List';
    PageType = List;
    CardPageId = "Imprest Header";
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Imprest Header";
    UsageCategory = Lists;
    SourceTableView = where("Payment Type" = filter(Imprest));

    layout
    {
        area(content)
        {

            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Status field.';
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
                    //Rec.REPORT.Run(39005883, true, true, Rec);
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
