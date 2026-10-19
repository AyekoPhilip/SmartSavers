report 50367 "Standing Order Line-Detailed"
{
    ApplicationArea = All;
    Caption = 'Standing Order Line-Detailed';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/StandingOrderDetailed.rdl';
    dataset
    {
        dataitem(StandingOrderLines; "Standing Order Lines")
        {

            column(DocumentNo; "Document No.")
            {
            }
            column(DestinationAccountType; "Destination Account Type")
            {
            }
            column(DestinationAccountNo; "Destination Account No.")
            {
            }
            column(DestinationAccountName; "Destination Account Name")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AmountLCY; "Amount LCY")
            {
            }
            column(Balance; Balance)
            {
            }
            column(Status; Status)
            { }
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



