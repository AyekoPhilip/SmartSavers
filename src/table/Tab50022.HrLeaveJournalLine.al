namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Finance.Dimension;
using System.Utilities;
using Microsoft.Finance.GeneralLedger.Journal;
table 50022 "Hr Leave Journal Line"
{
    Caption = 'Leave Journal Line';
    DataClassification = SystemMetadata;
    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Hr Leave Journal Template".Name;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Hr Leave Journal Batch".Name where("Journal Template Name" = field("Journal Batch Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Leave Calendar Code"; Code[20])
        {
            Caption = 'Leave Calendar Code';
            TableRelation = "Hr Leave Calendar"."Calendar Code";
        }
        field(5; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            TableRelation = "Hr Employees"."No.";
        }
        field(6; "Staff Name"; Text[150])
        {
            Caption = 'Staff Name';
        }
        field(7; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(8; "Leave Entry Type"; Option)
        {
            Caption = 'Leave Entry Type';
            OptionMembers = "Positive","Negative","Reimbursement";
        }
        field(9; "Leave Approval Date"; Date)
        {
            Caption = 'Leave Approval Date';
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(11; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(12; "No. of Days"; Decimal)
        {
            Caption = 'No. of Days';
        }
        field(13; "Description"; Text[150])
        {
            Caption = 'Description';
        }
        field(14; "Global Dimension 1 Code"; Code[10])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(15; "Global Dimension 2 Code"; Code[10])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
        }
        field(16; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(17; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(18; "Index Entry"; Boolean)
        {
            Caption = 'Index Entry';
        }
        field(19; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(20; "Leave Type"; Code[10])
        {
            Caption = 'Leave Type';
            TableRelation = "Hr Leave Type".Code;
        }
        field(21; "Leave Recalled No."; Code[10])
        {
            Caption = 'Leave Recalled No.';
        }
        field(22; "Leave Period Start Date"; Date)
        {
            Caption = 'Leave Period Start Date';
        }
        field(23; "Leave Period End Date"; Date)
        {
            Caption = 'Leave Period End Date';
        }
        field(24; "Positive Transaction Type"; Option)
        {
            Caption = 'Positive Transaction Type';
            OptionMembers = " ","Leave Allocation","Leave Recall","Overtime";
        }
        field(25; "Negative Transaction Type"; Option)
        {
            Caption = 'Negative Transaction Type';
            OptionMembers = " ","Leave Taken","Leave Forfeited";
        }
        field(26; "Leave Application No."; Code[50])
        {
            Caption = 'Leave Application No.';
            TableRelation = "Hr Leave Mgt."."No.";
        }
        field(27; "Currency Code"; Code[20])
        {

        }
        field(28; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
        }
        field(29; "Debit Amount"; Decimal)
        {

        }
        field(30; "Credit Amount"; Decimal)
        {

        }

    }
    keys
    {
        key("PK"; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure DataCaption(): Text[250]
    var
        GenJnlBatch: Record "Hr Leave Journal Batch";
    begin
        if GenJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then
            exit(GenJnlBatch.Name + '-' + GenJnlBatch.Description);
    end;

    procedure SwitchLinesWithErrorsFilter(var ShowAllLinesEnabled: Boolean)
    var
        TempErrorMessage: Record "Error Message" temporary;
        JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
    begin
        if ShowAllLinesEnabled then begin
            MarkedOnly(false);
            ShowAllLinesEnabled := false;
        end else begin
            JournalErrorsMgt.GetErrorMessages(TempErrorMessage);
            if TempErrorMessage.FindSet() then
                repeat
                    if Rec.Get(TempErrorMessage."Context Record ID") then
                        Rec.Mark(true)
                until TempErrorMessage.Next() = 0;
            MarkedOnly(true);
            ShowAllLinesEnabled := true;
        end;
    end;
        procedure IsOpenedFromBatch(): Boolean
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GetFilter("Journal Batch Name");
        if (BatchFilter = '') and ("Journal Batch Name" <> '') then
            BatchFilter := "Journal Batch Name";

        if BatchFilter <> '' then begin
            TemplateFilter := GetFilter("Journal Template Name");
            if (TemplateFilter = '') and ("Journal Template Name" <> '') then begin
                TemplateFilter := "Journal Template Name";
                SetFilter("Journal Template Name", TemplateFilter);
            end;
            if TemplateFilter <> '' then
                GenJournalBatch.SetFilter("Journal Template Name", TemplateFilter);
            if DelChr(BatchFilter, '=', SpecialSymbolsTok) <> BatchFilter then
                BatchFilter := '''' + BatchFilter + '''';
            GenJournalBatch.SetFilter(Name, BatchFilter);
            GenJournalBatch.FindFirst();
        end;

        exit((("Journal Batch Name" <> '') and ("Journal Template Name" = '')) or (BatchFilter <> ''));
    end;


    procedure GetStyle(): Text
    begin
        exit('Favorable')
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupCurrentJnlBatchNameOnAfterSetDataForSimpleModeOnBatchChange(CurrentJnlBatchName: Code[10])
    begin
    end;
    var
    SpecialSymbolsTok: Label '=|&@()<>', Locked = true;

}
