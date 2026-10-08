tableextension 50048 "VendLedgerExt" extends "Vendor Ledger Entry"
{
    fields
    {
        modify("Applies-to ID")
        {
            trigger OnAfterValidate()
            begin
                if "Applies-to ID" <> '' then begin
                    if "Applies-to ID" <> xRec."Appl. To ID Copy" then
                        "Appl. To ID Copy" := "Applies-to ID";
                end;
            end;
        }
        field(50009; "Appl. To ID Copy"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Appl. To ID Copy';
        }
    }

    keys
    {
    }
}


