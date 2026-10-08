report 50270 "Generate Account Interest"
{
    ApplicationArea = All;
    Caption = 'Generate Account Interest';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem("Savings Interest Header"; "Savings Interest Header")
        {
            column(Document_No_; "Document No.")
            { }
            trigger OnPreDataItem()
            begin

                IntBuffer.SetRange("Header No.", "Savings Interest Header"."No.");
                IntBuffer.SetRange(Transferred, false);
                IntBuffer.DeleteAll();

                IntLine.SetRange(No, "Savings Interest Header"."No.");
                IntLine.SetRange(Posted, false);
                IntLine.DeleteAll();

                SavingsBuffer.Reset();
                SavingsBuffer.SetRange("No.", "Savings Interest Header"."No.");
                SavingsBuffer.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPostDataItem()
            begin

            end;

        }
        dataitem("Account Banking"; "Account Banking")
        {
            RequestFilterFields = "No.", "Account Category", "Product Type";
            column(No_; "No.")
            {

            }
            trigger OnPreDataItem()
            begin

                if EndDate = 0D then
                    EndDate := Today;
                IntDays := (EndDate - StartDate) + 1;
            end;

            trigger OnAfterGetRecord()
            begin
                DivMngt.generateAccountInterestTiered("Account Banking", IntDays, StartDate, 0,
                "Savings Interest Header"."No.", "Savings Interest Header".Description);
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
                group("Posting Date")
                {
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
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
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        IntBuffer: Record "Interest Buffer";
        IntLine: Record "Interest Line";
        DivMngt: Codeunit "Dividend Process";
        ApplicationType: Option " ","Tiered Rate","Flat Rate";
        InterestEntry: Record "Interest Line";
        SavingsBuffer: Record "Savings Interest Buffer";
}



