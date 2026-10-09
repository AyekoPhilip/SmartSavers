report 50319 "Post Loan Interest/Penalty"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Interest Header"; "Interest Header")
        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                if not "Interest Header".fnCheckIfIntPeriodExist() then
                    Error(ErrorOnNoInterestPeriod);
            end;

            trigger OnAfterGetRecord()
            begin
                "Interest Header".TestField("Posting Date");
                "Interest Header".TestField("Start Date");
                "Interest Header".TestField("End Date");
                "Interest Header".TestField("Application Type");
            end;
        }
        dataitem(Loans; Loans)
        {
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date";
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
            trigger OnAfterGetRecord()
            begin
                Loans.CalcFields("Outstanding Balance");
                case "Interest Options" of
                    "Interest Options"::"Charge Interest":
                        begin

                            CustomerMember.Reset();
                            CustomerMember.SetRange("No.", "Account No.");
                            CustomerMember.SetFilter(Status, '<>%1', CustomerMember.Status::Deceased);
                            if CustomerMember.Find('-') then begin
                                Mgt.fnIntEntries(Loans, "Interest Header"."Posting Date", "Interest Header"."No.",
                                "Interest Header"."Application Type", IntDays, StartDate, "Interest Header"."Interest Frequency")
                            end;
                        end;
                end;
            end;

            trigger OnPreDataItem()
            begin

                IntLines.Reset;
                IntLines.SetRange(Posted, false);
                IntLines.SetRange(No, "Interest Header"."No.");
                IntLines.DeleteAll;
                EndDate := "Interest Header"."End Date";

                if EndDate = 0D then
                    EndDate := Today;
                StartDate := CalcDate('-CM', EndDate);
                IntDays := (EndDate - StartDate) + 1;
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
            }
        }

        actions
        {
        }
    }

    labels
    {
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
        RunDate: Date;
        ErrorOnNoInterestPeriod: Label 'No Interest Period found. Create Interest period before you can Create Interest Entries';
}




