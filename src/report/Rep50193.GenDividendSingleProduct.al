report 50193 "Gen. Dividend-Single Product"
{
    ApplicationArea = All;
    Caption = 'Gen. Dividend-Single Product';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem("Dividend Simulation Header"; "Dividend Simulation Header")
        {
            trigger OnAfterGetRecord()
            begin
                StartDate := 0D;
                EndDate := 0D;

                StartDate := "Dividend Simulation Header"."Start Date";
                EndDate := "Dividend Simulation Header"."End Date";
            end;
        }
        dataitem(AccountCredit; "Account Credit")
        {
            column(No; "No.")
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
                DividendProgression.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin

                if "Product Type" = "Dividend Simulation Header"."Product Type" then begin
                    SetRange("Date Filter", StartDate, EndDate);
                    CalcFields("Balance (LCY)");

                    ProdFact.Get("Product Type");
                    ProdFact.TestField("Dividend Calc. Method");
                    ProdFact.TestField("Minimum Balance");
                    ProdFact.TestField("Interest Rate (Max.)");

                    if "Balance (LCY)" >= ProdFact."Minimum Balance" then begin
                        DivProcess.fnCalculateCustDivdends(AccountCredit, "Dividend Simulation Header"."Product Type",
                        "Dividend Simulation Header"."No.");
                    end else begin
                        CurrReport.Skip();
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
        DivProcess: Codeunit "Dividend Process";

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;

    var
        ProductType: Code[50];
        ProdFact: Record "Product Factory";
        DividendProgression: Record "Dividend Progression";
        StartDate, EndDate : Date;
}



