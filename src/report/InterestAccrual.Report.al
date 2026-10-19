report 50800 "Interest Accrual"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = where("Outstanding Principal" = filter(> 0));
            trigger OnAfterGetRecord()
            begin
                CalcFields("Last Pay Date(Interest)");
                StartDate := "Last Pay Date(Interest)";
                if StartDate = 0D then StartDate := "Repayment Start Date";
                if StartDate = 0D then
                    CurrReport.Skip();
                repeat
                    StartDate := CalcDate('1D', StartDate);
                    AccrualMGt.RunAccrual(Loans, StartDate);
                until StartDate >= Today;
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
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
                action(LayoutName)
                {

                }
            }
        }
    }

    var
        StartDate: Date;
        AccrualMGt: Codeunit LoanAccrualMgt;
}