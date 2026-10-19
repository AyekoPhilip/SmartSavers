report 50035 "Stock Taking & Adjust. Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StockTakingAdjustForm.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            RequestFilterFields = "Inventory Posting Group";

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
            column(WorkingDate; WorkingDate)
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
        WorkingDate := WorkDate();
    end;

    var
        CompanyInfo: Record "Company Information";
        WorkingDate: Date;
}


