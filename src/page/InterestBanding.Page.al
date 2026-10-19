page 51040 "Interest Banding"
{
    ApplicationArea = All;
    Caption = 'Interest Banding';
    PageType = List;
    SourceTable = "Interest Rates Banding";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product ID field.';
                    Editable = false;
                }
                field("Lower Period"; Rec."Lower Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lower Period field.';
                }
                field("Upper Period"; Rec."Upper Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Upper Period field.';
                }
               
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                }
                field("Tier Type";Rec."Tier Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tier Type field.';

                }
            }
        }
    }
    actions
    {

    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Tier Type" := Rec."Tier Type"::"Interest Rate";

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Tier Type" := Rec."Tier Type"::"Interest Rate";
    end;

    var

}



