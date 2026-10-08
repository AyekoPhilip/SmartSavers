report 50034 "Stock Take Variance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StockTakeVarianceReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            column(Company_Name; CompanyInfo.Name)
            {
            }
            column(Comp_Logo; CompanyInfo.Picture)
            {
            }
            column(Posting_Date; "Item Journal Line"."Posting Date")
            {
            }
            column(Item_No; "Item Journal Line"."Item No.")
            {
            }
            column(Description; "Item Journal Line".Description)
            {
            }
            column(Location_Code; "Item Journal Line"."Location Code")
            {
            }
            column(UOM; "Item Journal Line"."Unit of Measure Code")
            {
            }
            column(Inventory_Posting_Group; "Item Journal Line"."Inventory Posting Group")
            {
            }
            column(Qty_Calculated; "Item Journal Line"."Qty. (Calculated)")
            {
            }
            column(Qty_Phys_Inventory; "Item Journal Line"."Qty. (Phys. Inventory)")
            {
            }
            column(Unit_Cost; "Item Journal Line"."Unit Cost")
            {
            }
            column(Narration_ItemJournalLine; "Item Journal Line".Narration)
            {
            }
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }
    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}


