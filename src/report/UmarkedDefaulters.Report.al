report 50347 "Umarked Defaulters"
{
    ApplicationArea = All;
    Caption = 'Umarked Defaulters';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/UnmarkedDefaulter.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            column(Name; Name)
            {
            }
            column(No; "No.")
            {
            }
            column(Status; Status)
            {
            }
            column(AmountInArrears; AmountInArrears)
            {

            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                AmountInArrears := 0;
                Loans.Reset();
                Loans.SetFilter("Outstanding Balance", '>0');
                Loans.SetRange("Account No.", "No.");
                if Loans.FindSet() then begin
                    Loans.CalcSums("Amount In Arrears");
                    AmountInArrears := Loans."Amount In Arrears";
                end;
                if AmountInArrears < 0 then AmountInArrears:=0;
                if AmountInArrears=0 then
                CurrReport.Skip();
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
        Loans: Record "Loans Categorization";
        AmountInArrears: Decimal;

}



