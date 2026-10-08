pageextension 50064 VendorListExt extends "Vendor List"
{
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Account Type", Rec."Account Type"::" ");
        Rec.FilterGroup(0);
    end;
}
