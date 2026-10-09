report 50351 "Post Loan Interest-Mobile"
{
    ApplicationArea = All;
    Caption = 'Post Loan Interest-Mobile';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingBill; "Outstanding Bill")
            {
            }
            column(OutstandingInsurance; "Outstanding Insurance")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if "Interest Due Date" = 0D then begin
                    "Interest Due Date" := CalcDate('30D', "Disbursement Date");
                    Modify(true);
                end;
                if PFact.Get("Product Type") then begin
                    case PFact."Loan Span" of
                        PFact."Loan Span"::"Mobile Loan":
                            begin
                                if "Interest Due Date" = Today then begin
                                    PeriodicMngt.PostMobileLoanInterest(Loans, 1);
                                end;
                            end;
                    end
                end;
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
        PFact: Record "Product Factory";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        IntDueDate: Date;

}



