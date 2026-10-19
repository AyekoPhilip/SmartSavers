page 50850 "Coinage"
{
    Editable = true;
    PageType = ListPart;
    SourceTable = Coinage;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(No; Rec.No)
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    Editable = true;
                    Enabled = true;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




