query 50000 "Sales_ItemCategoryTest"
{
    elements
    {
        dataitem(Item; Item)
        {
            column(Inventory_Posting_Group; "Inventory Posting Group")
            {
            }
            dataitem(QueryElement2; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = Item."No.";
                DataItemTableFilter = "Entry Type" = const(Sale);
                column(Sum_Sales_Amount_Actual; "Sales Amount (Actual)")
                {
                    Method = Sum;
                }
            }
        }
    }
}
