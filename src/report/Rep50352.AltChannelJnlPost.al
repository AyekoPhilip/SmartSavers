report 50352 "Alt. Channel Jnl. Post"
{
    ApplicationArea = All;
    Caption = 'Alt. Channel Jnl. Post';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = where("Product Type" = filter('MSACCOLN'));

            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
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
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                CalcFields("Outstanding Balance");
                if "Outstanding Balance" > 0 then begin
                    if "Product Type" = 'MSACCOLN' then begin
                        PeriodicMngt.PerformPostOnMobLoanMngtAuto(Loans."No.", Today, 1);
                    end;
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
                group("Posting Options")
                {
                    field(PostingType; PostingType)
                    {
                        Caption = 'Posting Type';
                        ApplicationArea = All;
                    }
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
        AccountBanking: Record "Account Banking";
        RunBal: Decimal;
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        PostingType: Option " ","Post Application","Generate Batch";

}



