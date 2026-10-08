namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using Microsoft.Inventory.Ledger;

enumextension 90000 "Leave Entry Type" extends "Item Ledger Entry Type"
{

    value(50000; Reimbursement)
    {
        Caption = 'Reimbursement';
    }
}
