report 50368 "Dividend Post Mngt."
{
    ApplicationArea = All;
    Caption = 'Dividend Post Mngt.';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(DividendSimulationHeader; "Dividend Simulation Header")
        {
            RequestFilterFields = "No.", "Start Date", "End Date";
            column(No; "No.")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(OperationType; "Operation Type")
            {
            }
            dataitem("Simulation Line"; "Simulation Line")
            {
                DataItemLink = "No." = field("No.");


                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin


                end;

                trigger OnPostDataItem()
                begin
                    //fgfgfgf

                end;

            }
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
                    field(PostInt; PostInt)
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
        BnkMngt: Codeunit "Banking Procedure Mngt.";
        PostInt: Option " ","Generate Batch","Post Application";
}



