report 50192 "Gen. Dividend-All Products"
{
    ApplicationArea = All;
    Caption = 'Gen. Dividend-All Products';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem("Dividend Simulation Header"; "Dividend Simulation Header")
        {

        }
        dataitem(Member; Member)
        {
            column(No; "No.")
            {
            }
            column(Status; Status)
            {
            }
            trigger OnPreDataItem()
            var

            begin
                DividendProgression.Reset();
                        DividendProgression.SetRange("Product Type", "Dividend Simulation Header"."Product Type");
                        if DividendProgression.Find('-') then begin
                            DividendProgression.DeleteAll();
                        end;

            end;

            trigger OnAfterGetRecord()
            begin
                DivGen.GenerateDividendsOnallAccount(Member."No.", "Dividend Simulation Header"."No.", "Dividend Simulation Header"."Product Type");
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
        DivGen: Codeunit "Dividend Process";
        DividendProgression: Record "Dividend Progression";


    trigger OnPreReport()
    begin

    end;

    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;



}



