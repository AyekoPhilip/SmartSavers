page 51056 "Witnesses"
{
    ApplicationArea = All;
    Caption = 'Witnesses';
    PageType = List;
    SourceTable = "Segment/County/Dividend/Signat";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type field.';

                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Code field.';

                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Witness
    end;
}



