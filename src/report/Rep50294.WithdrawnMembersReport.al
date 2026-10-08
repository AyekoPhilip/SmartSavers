report 50294 "Withdrawn Members Report"
{
     UsageCategory = ReportsAndAnalysis;
     ApplicationArea = All;
     DefaultLayout = RDLC;
     
    RDLCLayout = './src/report_layout/WithdrawnMembers.rdl';
    
    Caption = 'Withdrawn Members Report';

    dataset
    {
        dataitem(Membershipclosure; "Membership closure")
        {
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(BenevolentFund; "Benevolent Fund")
            {
            }
            column(CloseAccount; "Close Account")
            {
            }
            column(ClosingDate; "Closing Date")
            {
            }
            column(ClosureType; "Closure Type")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(DepositRefundable; "Deposit Refundable")
            {
            }
            column(EarlyExitCharges; "Early Exit Charges")
            {
            }
            column(EnteredBy; "Entered By")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(IncludeCharges; "Include Charges")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(LoansOption; "Loans Option")
            {
            }
            column(MemberName; "Member Name")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MemberSavings; "Member Savings")
            {
            }
            column(No; "No.")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(NoticeMDate; "Notice M. Date")
            {
            }
            column(NoticeNo; "Notice No.")
            {
            }
            column(OtherCharges; "Other Charges")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(ProductFactory; "Product Factory")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(SharesCapital; "Shares Capital")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(TotalAmountLCY; "Total Amount (LCY)")
            {
            }
            column(TotalInterest; "Total Interest")
            {
            }
            column(TotalLoan; "Total Loan")
            {
            }
            column(Transaction; Transaction)
            {
            }
            column(TransactionType; "Transaction Type")
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
