page 50590 "Instructions-Signatories"
{
    Caption = 'Instructions-Signatories';
    PageType = ListPart;
    SourceTable = "Teller Transaction";
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Signing Instructions"; Rec."Signing Instructions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Signing Instructions field.';
                }
            }
        }
    }
}



