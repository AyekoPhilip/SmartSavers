page 50927 "Application Doc. Setup Card"
{
    PageType = Card;
    SourceTable = "Application Document Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        SOControl;
    end;

    var
        SinglePartyMultiple: Boolean;


    procedure SOControl()
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Member, Rec."Document Type"::Account:
                begin
                    SinglePartyMultiple := true;
                end;

            Rec."Document Type"::" ", Rec."Document Type"::Loan:
                begin
                    SinglePartyMultiple := false;
                end;
        end;
    end;
}




