report 50221 "Dividend Progression"
{
    ApplicationArea = All;
    Caption = 'Dividend Progression';
    UsageCategory = Administration;
    RDLCLayout = './src/report_layout/Dividend Progression.rdl';

    dataset
    {
        dataitem(DividendProgression; "Dividend Progression")

        {
            RequestFilterFields = "Member No";
            column(AccountNo; "Account No")
            {
            }
            column(DividendCalcMethod; "Dividend Calc. Method")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(GrossDividends; "Gross Dividends")
            {
            }
            column(HeaderNo; "Header No.")
            {
            }
            column(MemberNo; "Member No")
            {
            }
            column(NetDividends; "Net Dividends")
            {
            }
            column(PaymentMode; "Payment Mode")
            {
            }
            column(Posted; Posted)
            {
            }
            column(ProcessingDate; "Processing Date")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(QualifyingShares; "Qualifying Shares")
            {
            }
            column(Shares; Shares)
            {
            }
            column(StartDate; "Start Date")
            {
            }
            column(WitholdingTax; "Witholding Tax")
            {
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
}



