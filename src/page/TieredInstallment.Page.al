page 51065 "Tiered Installment"
{
    ApplicationArea = All;
    Caption = 'Tiered Installment';
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
                field("Min. Limit"; Rec."Min. Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Min. Limit field.';
                }
                field("Max. Limit"; Rec."Max. Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Limit field.';
                }
                field("Lower Period"; Rec."Lower Period")
                {
                    ApplicationArea = All;

                }
                field("Upper Period"; Rec."Upper Period")
                {
                    ApplicationArea = All;
                }
                field(Installment; Rec.Installment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Installment field.';

                }
                field("Tier Type"; Rec."Tier Type")
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
        Rec."Tier Type" := Rec."Tier Type"::Installment;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Tier Type" := Rec."Tier Type"::Installment;
    end;

}
