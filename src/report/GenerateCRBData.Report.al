report 50223 "Generate CRB Data"
{
    ApplicationArea = All;
    Caption = 'Generate CRB Data';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/GenerateCRBData.rdl';
    dataset
    {
        dataitem(LoansCategorization; "Loans Categorization")
        {
            column(No; "No.")
            { }
            column(AccountNo; "Account No.")
            { }
            column(ProductType; "Product Type")
            { }
            trigger OnPreDataItem()
            begin
                if Cutoffdate = 0D then Cutoffdate := Today;

            end;

            trigger OnAfterGetRecord()
            begin
                ReportMngt.generateCRBData(LoansCategorization, Cutoffdate);
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
                    field(Cutoffdate; Cutoffdate)
                    {
                        Caption = 'As At';
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
        Cutoffdate: Date;
        ReportMngt: Codeunit "Report Execute Mngt.";
}



