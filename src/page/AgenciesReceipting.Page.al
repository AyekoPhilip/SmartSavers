page 50029 "Agencies Receipting"
{
    CardPageID = "Receipt Header Agencies";
    Editable = true;
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

        UserSetup.Reset;
        if UserSetup.Get(UserId) then begin
            JTemplate := UserSetup."Receipt Journal Template";
            JBatch := UserSetup."Receipt Journal Batch";
        end;
        Rec."Application Type" := Rec."Application Type"::Member;

        if (JTemplate = '') or (JBatch = '') then;
        if UserSetup."Default Receipts Bank" = '' then;

        Rec.SetRange("Created By", UserId);
        if UserMgt.GetSalesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter());
            Rec.FilterGroup(0);
        end;
    end;

    var
        UserSetup: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        UserMgt: Codeunit "User Setup Management BR";
}



