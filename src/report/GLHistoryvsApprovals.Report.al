report 50216 "GL History vs Approvals"
{
    Caption = 'User Reviews vs Approvals';

    ApplicationArea = All;
    //Caption = 'User Reviews/Posted Documents';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/UserReviewsSummary.rdl';

    dataset
    {
        dataitem(PostedApprovalEntry; "Posted Approval Entry")
        {
            column(Amount; Amount)
            {
            }
            column(AmountLCY; "Amount (LCY)")
            {
            }
            column(ApprovalCode; "Approval Code")
            {
            }
            column(ApprovalType; "Approval Type")
            {
            }
            column(ApproverID; "Approver ID")
            {
            }
            column(AvailableCreditLimitLCY; "Available Credit Limit (LCY)")
            {
            }
            column(Comment; Comment)
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(DateTimeSentforApproval; "Date-Time Sent for Approval")
            {
            }
            column(DelegationDateFormula; "Delegation Date Formula")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(IterationNo; "Iteration No.")
            {
            }
            column(LastDateTimeModified; "Last Date-Time Modified")
            {
            }
            column(LastModifiedByID; "Last Modified By ID")
            {
            }
            column(LimitType; "Limit Type")
            {
            }
            column(NumberofApprovedRequests; "Number of Approved Requests")
            {
            }
            column(NumberofRejectedRequests; "Number of Rejected Requests")
            {
            }
            column(PostedRecordID; "Posted Record ID")
            {
            }
            column(SalespersPurchCode; "Salespers./Purch. Code")
            {
            }
            column(SenderID; "Sender ID")
            {
            }
            column(SequenceNo; "Sequence No.")
            {
            }
            column(Status; Status)
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
            column(TableID; "Table ID")
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



