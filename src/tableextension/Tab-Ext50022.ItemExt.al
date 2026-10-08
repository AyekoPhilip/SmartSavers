tableextension 50022 "ItemExt" extends Item
{
    fields
    {
        field(50009; "Item G/L Budget Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Item G/L Budget Account';
        }
    }
}


