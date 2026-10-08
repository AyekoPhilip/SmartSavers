report 50273 "Consolidate Div. Line"
{
    ApplicationArea = All;
    Caption = 'Consolidate Div. Line';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem("Dividend Simulation Header"; "Dividend Simulation Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            { }

        }
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.", Status;
            column(No; "No.")
            {
            }
            column(Status; Status)
            {
            }
            trigger OnPreDataItem()
            begin
                DivLine.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin

                GrossDiv := 0;
                NetDividend := 0;
                QualShares := 0;
                TSHARES := 0;
                WTAX := 0;

                DivProgress.Reset();
                DivProgress.SetRange("Member No", Member."No.");
                DivProgress.SetRange("Header No.", "Dividend Simulation Header"."No.");
                if DivProgress.FindSet() then begin

                    DivProgress.CalcSums("Gross Dividends");
                    DivProgress.CalcSums("Net Dividends");
                    DivProgress.CalcSums("Qualifying Shares");
                    DivProgress.CalcSums("Witholding Tax");
                    DivProgress.CalcSums(Shares);

                    GrossDiv := DivProgress."Gross Dividends";
                    NetDividend := DivProgress."Net Dividends";
                    QualShares := DivProgress."Qualifying Shares";
                    WTAX := DivProgress."Witholding Tax";
                    TSHARES := DivProgress.Shares;

                    DivLine.Init();
                    DivLine."No." := DivProgress."Header No.";
                    DivLine."Account No." := DivProgress."Account No";
                    DivLine."Account Name" := Member.Name;
                    DivLine."staff payroll" := Member."Payroll/Staff No.";
                    DivLine."Member No." := DivProgress."Member No";
                    DivLine."Product Type" := DivProgress."Product Type";
                    DivLine."Product Name" := DivProgress."Product Name";
                    DivLine."Processing Date" := Today;
                    DivLine."Dividend Calc. Method" := DivProgress."Dividend Calc. Method";
                    DivLine.Shares := TSHARES;
                    DivLine."Qualifying Shares" := QualShares;
                    DivLine."Gross Dividends" := GrossDiv;
                    DivLine."Witholding Tax" := WTAX;
                    DivLine."Net Dividends" := NetDividend;
                    DivLine.Insert(true);

                end else begin
                    CurrReport.Skip();
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
        DivProgress: Record "Dividend Progression";
        DivLine: Record "Simulation Line";
        AccountCredit: Record "Account Credit";
        GrossDiv: Decimal;
        QualShares: Decimal;
        NetDividend: Decimal;
        CustRec: Record Member;
        WTAX: Decimal;
        TSHARES: Decimal;

}



