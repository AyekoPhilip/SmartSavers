page 50946 "Social Listening Sites App."
{
    PageType = List;
    SourceTable = "Social Listening Sites App.";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No."; Rec."Account No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control6; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; Links)
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
        if MemberApplication.Get(Rec."Account No.") then begin
            if MemberApplication."Approval Status" <> MemberApplication."Approval Status"::Open then
                CurrPage.Editable := false
            else
                CurrPage.Editable := true;
        end;
    end;

    var
        MemberApplication: Record "Member Application";
}




