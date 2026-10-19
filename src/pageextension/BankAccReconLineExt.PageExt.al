namespace DynamicsNav.SaccoDatabase;

using Microsoft.Bank.Reconciliation;

pageextension 50008 "Bank Acc. Recon. Line Ext" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter(Difference)
        {
            field(Reconciled; Rec.Reconciled)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reconcile';
                ToolTip = 'Allows users to Reconcile entries';
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'External Document No.';
                ToolTip = 'External Document No.';
            }
            field(CheckNo; Rec."Check No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Check No';
                ToolTip = 'Check No';
            }
        }
    }
}

