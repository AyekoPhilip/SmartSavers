report 50000 "Calculate Benovelent Recovery"
{
    ApplicationArea = All;
    Caption = 'Calculate Benovelent Recovery';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(InterestHeader; "Interest Header")
        {
            RequestFilterFields = "No.";
            dataitem("Account Credit"; "Account Credit")
            {
                DataItemTableView = where("Account Category" = const("Shares Deposit"), Status = filter(Active | New | Dormant | Defaulter | Blocked | "Withdrawal Application" | Closed), "Balance (LCY)" = filter(> 0));
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    Mgt.fnIntEntriesBBF("Account Credit",
                               InterestHeader."Posting Date",
                               InterestHeader."No.", 1, InterestHeader."Application Type",
                               IntDays, InterestHeader."End Date")
                end;

                trigger OnPostDataItem()
                begin


                end;

            }
            trigger OnPreDataItem()
            begin
                IntLines.Reset;
                IntLines.SetRange(Posted, false);
                IntLines.SetRange(No, InterestHeader."No.");
                IntLines.DeleteAll;

                StartDate := InterestHeader."Start Date";
                EndDate := InterestHeader."End Date";

                /* if EndDate = 0D then
                    EndDate := Today; */
            end;

            trigger OnAfterGetRecord()
            begin
                TestField("Posting Date");
                TestField("Application Type");
                TestField("Start Date");
                TestField("End Date");

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
        Mgt: Codeunit "Periodic Activities Mgt.";
        IntLines: Record "Interest Line";
        ReportExctMngt: Codeunit "Report Execute Mngt.";
        PloanCategory: Record "Loans Categorization";
        CustomerMember: Record Member;
        ProdFact: Record "Product Factory";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
}



