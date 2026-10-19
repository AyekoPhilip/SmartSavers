report 50017 "Budget Utilization"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/BudgetUtilization.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Budget Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";

            column(Company_Name; CompanyInformation.Name)
            {
            }
            column(Company_Address; CompanyInformation.Address)
            {
            }
            column(Company_Picture; CompanyInformation.Picture)
            {
            }
            column(Company_PostCode; CompanyInformation."Post Code")
            {
            }
            column(No_GLAccount; "G/L Account"."No.")
            {
            }
            column(Name_GLAccount; "G/L Account".Name)
            {
            }
            column(BudgetedAmount_GLAccount; "G/L Account"."Budgeted Amount")
            {
            }
            column(NetChange_GLAccount; "G/L Account"."Net Change")
            {
            }
            column(Commitment_GLAccount; "G/L Account".Commitment)
            {
            }
            column(DiffPct; DiffPct)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change", "Budgeted Amount", "Balance at Date", Commitment);

                GLAcc2 := "G/L Account";
                GLAcc2.CalcFields("Budget at Date");
                if "Budgeted Amount" = 0 then
                    DiffPct := 0
                else
                    DiffPct := ((Abs("G/L Account"."Net Change") + "G/L Account".Commitment) / "Budgeted Amount") * 100;

                if GLAcc2."Budget at Date" = 0 then
                    DiffAtDatePct := 0
                else
                    DiffAtDatePct := "Balance at Date" / GLAcc2."Budget at Date" * 100;
            end;

            trigger OnPreDataItem()
            begin

                GLAcc2.CopyFilters("G/L Account");
                AccountingPeriod.Reset();
                AccountingPeriod.SetRange("New Fiscal Year", true);
                StartDate := GetRangeMin("Date Filter");
                EndDate := GetRangeMax("Date Filter");
                AccountingPeriod."Starting Date" := GetRangeMin("Date Filter");
                AccountingPeriod.Find('=<');
                //GLAcc2.SETRANGE("Date Filter",AccountingPeriod."Starting Date",EndDate);
                GLAcc2.SetRange("Date Filter", StartDate, EndDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
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
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        CompanyInformation: Record "Company Information";
        GLAcc2: Record "G/L Account";
        EndDate: Date;
        StartDate: Date;
        DiffAtDatePct: Decimal;
        DiffPct: Decimal;
}


