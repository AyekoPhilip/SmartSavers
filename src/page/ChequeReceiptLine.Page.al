page 50861 "Cheque Receipt Line"
{
    PageType = ListPart;
    SourceTable = "Cheque Issue Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cheque Serial No"; Rec."Cheque Serial No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Un pay Code"; Rec."Un pay Code")
                {
                    ApplicationArea = All;
                }
                field(Interpretation; Rec.Interpretation)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unpay Date"; Rec."Unpay Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Un Pay Charge Amount"; Rec."Un Pay Charge Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Family Account No."; Rec."Family Account No.")
                {
                    Caption = 'Family Account No';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date _Refference No."; Rec."Date _Refference No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




