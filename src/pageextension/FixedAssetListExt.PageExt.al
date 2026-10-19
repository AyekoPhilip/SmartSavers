pageextension 50059 "Fixed Asset List Ext" extends "Fixed Asset List"
{
    layout
    {

        addafter("FA Subclass Code")
        {
            field(BookValue; BookValue)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Book Value';
                DrillDown = true;
                Editable = false;
                ToolTip = 'Specifies the book value for the fixed asset.';

                trigger OnDrillDown()
                    begin
                        FADepreciationBook.DrillDownOnBookValue();
                    end;


            }

        }

    }

    actions
    {
        addlast(processing)
        {
            action("Generate Multiple Barcodes")
            {
                Caption = 'Generate Multiple Barcodes';
                Image = BarCode;
                ApplicationArea = All;
                ToolTip = 'Generates a Fixed Asset Barcode';

                trigger OnAction()
                var
                    
                begin
                   
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("Generate Multiple Barcodes_Promoted"; "Generate Multiple Barcodes")
            {
            }
        }



    }

    var

        BookValue: Decimal;

        FADepreciationBook: Record "FA Depreciation Book";
}



