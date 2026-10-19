namespace DynamicsNav.SaccoDatabase;

using System.Utilities;
using Microsoft.Foundation.Period;
using Microsoft.Inventory.Setup;
report 90009 "Create Fiscal Year- Interest"
{
    ApplicationArea = All;
    Caption = 'Create Fiscal Year- Interest';
    UsageCategory = Administration;
    ProcessingOnly = true;
    dataset
    {

    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; FiscalYearStartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(NoOfPeriods; NoOfPeriods)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Periods';
                        ToolTip = 'Specifies how many accounting periods to include.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if NoOfPeriods = 0 then begin
                NoOfPeriods := 12;
                Evaluate(PeriodLength, '<1M>');
            end;
            if AccountingPeriod.Find('+') then
                FiscalYearStartDate := AccountingPeriod."Date Opened";
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        
        AccountingPeriod."Date Opened" := FiscalYearStartDate;
        AccountingPeriod.TestField("Date Opened");
        AccountingPeriod.SetRange(Closed, false);
        if AccountingPeriod.Find('-') then begin
            FirstPeriodStartDate := AccountingPeriod."Date Opened";
            FirstPeriodLocked := AccountingPeriod.Closed;
            if (not HideDialog) and (FiscalYearStartDate < FirstPeriodStartDate) and FirstPeriodLocked then
                if not ConfirmManagement.GetResponseOrDefault(CreateAndCloseQst, false) then
                    exit;
        end else
            if not HideDialog then
                if not ConfirmManagement.GetResponseOrDefault(CreateQst, false) then
                    exit;

        AccountingPeriod.SetRange(Closed);
        FiscalYearStartDate2 := FiscalYearStartDate;

        for i := 1 to NoOfPeriods + 1 do begin
            if (FiscalYearStartDate <= FirstPeriodStartDate) and (i = NoOfPeriods + 1) then
                exit;

            OnPreReportOnBeforeAccountingPeriodInit(FiscalYearStartDate, PeriodLength, NoOfPeriods, FirstPeriodStartDate, FirstPeriodLocked, i);

            AccountingPeriod.Init();
            AccountingPeriod."Date Opened" := FiscalYearStartDate;
            AccountingPeriod.Validate("Date Opened");
            AccountingPeriod."Period Month" := Date2DMY(AccountingPeriod."Date Opened", 2);
            AccountingPeriod."Period Year" := Date2DMY(AccountingPeriod."Date Opened", 3);
            AccountingPeriod."Period Name" := Format(AccountingPeriod."Date Opened", 0, '<Month Text>');
            AccountingPeriod."Created By" := UserId;
            AccountingPeriod."Posted By" := UserId;

            if not AccountingPeriod.Find('=') then
                AccountingPeriod.Insert();
            FiscalYearStartDate := CalcDate(PeriodLength, FiscalYearStartDate);
        end;
        AccountingPeriod.Get(FiscalYearStartDate2);
    end;

    var
        AccountingPeriod: Record "Loan Interest Periods";
        InvtSetup: Record "Inventory Setup";
        PeriodLength: DateFormula;
        NoOfPeriods: Integer;
        FiscalYearStartDate2: Date;
        FirstPeriodStartDate: Date;
        FirstPeriodLocked: Boolean;
        i: Integer;
        HideDialog: Boolean;
        CreateAndCloseQst: Label 'The new fiscal year begins before an existing fiscal year, so the new year will be closed automatically.\\Do you want to create and close the fiscal year?';
        CreateQst: Label 'After you create the new fiscal year, you cannot change its starting date.\\Do you want to create the fiscal year?';

    protected var
        FiscalYearStartDate: Date;

    procedure InitializeRequest(NewNoOfPeriods: Integer; NewPeriodLength: DateFormula; StartingDate: Date)
    begin
        NoOfPeriods := NewNoOfPeriods;
        PeriodLength := NewPeriodLength;
        if AccountingPeriod.FindLast() then
            FiscalYearStartDate := AccountingPeriod."Date Opened"
        else
            FiscalYearStartDate := StartingDate;
    end;

    procedure HideConfirmationDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPreReportOnBeforeAccountingPeriodInit(FiscalYearStartDate: Date; PeriodLength: DateFormula; NoOfPeriods: Integer; FirstPeriodStartDate: Date; FirstPeriodLocked: Boolean; LoopCounter: Integer)
    begin
    end;
}
