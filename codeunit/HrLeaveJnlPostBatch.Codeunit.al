namespace SaccoDatabase.SaccoDatabase;
using DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Journal;
using Microsoft.Finance.Currency;
using Microsoft.Utilities;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.Dimension;

codeunit 90011 "Hr Leave Jnl.- Post Batch"
{
    TableNo = "Item Journal Line";
    trigger OnRun()
    begin

    end;

    local procedure InitCode(RecRef: Record "Item Journal Line")
    begin

    end;

    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        PrevGenJnlLine: Record "Hr Leave Journal Line";
        OpenFromBatch: Boolean;
        AccountNames: Dictionary of [Text, Text];
        Text000: Label 'Cannot exceed %1 characters';
        Text001: Label 'Journal Batch Name #1##########\\';
        Text002: Label 'Checking lines #2######\';
        Text003: Label 'Posting lines #3###### @4@@@@@@@@@@@@@';
        Text004: Label 'A maximum of %1 posting number series can be used in each journal.';
        HrLeaveJnlLine: Record "Item Journal Line";
        HrLeaveJnlTempl: Record "Item Journal Template";
        HrLeaveJnlBatch: Record "Item Journal Batch";
        LeaveReg: Record "Hr Leave Register";
        HrLeaveLedgEntry: Record "Hr Leave Ledger Entry";
        HrLeaveJnlLine2: Record "Item Journal Line";
        HrLeaveJnlLine3: Record "Item Journal Line";
        NoSeries: Record "No. Series";
        //HrLeaveJnlPostLine  :Codeunit   HR Leave Jnl.- Post Line
        NoSeriesMgt: Codeunit "No. Series";
        NoSeriesMgt2: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        WindowDialog: Dialog;
        LineCount: Integer;
        StartLineNo: Integer;
        NoOfRecords: Integer;
        HrLeaveRegNo: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;

}
