report 50089 "Create Payroll Period"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Control1)
                {
                    ShowCaption = false;

                    field("Starting Date"; FiscalYearStartDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the FiscalYearStartDate field';
                    }
                    field("No. of Periods"; NoOfPeriods)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the NoOfPeriods field';
                    }
                    field("Period Length"; PeriodLength)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PeriodLength field';
                    }
                }
            }
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

       
    end;

    var
        AccountingPeriod: Record "Loan Interest Periods";
        PeriodLength: DateFormula;
        FirstPeriodLocked: Boolean;
        FirstPeriodStartDate: Date;
        FiscalYearStartDate: Date;
        LastPeriodStartDate: Date;
        i: Integer;
        NoOfPeriods: Integer;
        Text001: Label 'Do you want to create and close the fiscal year?';
        Text003: Label 'Do you want to create the fiscal year?';
        Text004: Label 'It is only possible to create new fiscal years before or after the existing ones.';
        Text002: Label 'Once you create the new fiscal year you cannot change its starting date.\\';
        Text000: Label 'The new fiscal year begins before an existing fiscal year, so the new year will be closed automatically.\\';
}


