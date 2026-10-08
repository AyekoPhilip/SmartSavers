namespace DynamicsNav.SaccoDatabase;

report 50422 "Generate Int. On Deposit"
{
    ApplicationArea = All;
    Caption = 'Generate Int. On Deposit';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(DividendSimulationHeader; "Dividend Simulation Header")
        {
            column(No; "No.")
            {
            }
            column(StartDate; "Start Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            trigger OnPreDataItem()
            begin


            end;

            trigger OnAfterGetRecord()
            begin
                TestField("Start Date");
                TestField("End Date");
                 

            end;
        }
        dataitem(AccountCredit; "Account Credit")
        {
            column(AcNo; "No.")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(Status; Status)
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

                 RintDays := 0;
                NoOfDaysInMonth := 0;
                RintDays := (DividendSimulationHeader."End Date" - DividendSimulationHeader."Start Date");
                RegMngt.GetMonthlyRemittanceOnSharesDeposit("No.", "Product Type",
                DividendSimulationHeader."Start Date", DividendSimulationHeader."End Date",
                DividendSimulationHeader."No.", RintDays);
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var
        NoOfDaysInMonth: Integer;
        MonthNumber: Integer;
        YearNumber: Integer;
        MonthTexts: Text;
        DateMngt: Codeunit "Date Conversion";
        Amt: array[5] of Decimal;
        ProductType: Code[50];
        ProdFact: Record "Product Factory";
        DividendProgression: Record "Dividend Progression";
        StartDate, EndDate : Date;
       // ContSchedule: Record "Contribution Schedule-Deposit";
        RegMngt: Codeunit "Register Management";
        RintDays: Integer;

}
