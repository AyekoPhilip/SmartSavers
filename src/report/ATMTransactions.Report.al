report 50278 "ATM Transactions"
{
    ApplicationArea = All;
    Caption = 'ATM Transactions';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/ATMTransactionsReport.rdl';
    dataset
    {
        dataitem(ATMTransaction; "ATM Transaction")
        {
            column(ATMCardNo; "ATM Card No")
            {
            }
            column(AccountNo; "Account No")
            {
            }
            column(AccountNoCredit; "Account No.(Credit)")
            {
            }
            column(Amount; Amount)
            {
            }
            column(CardAcceptorTerminalID; "Card Acceptor Terminal ID")
            {
            }
            column(ChargeAmount; "Charge Amount")
            {
            }
            column(ChargeCode; "Charge Code")
            {
            }
            column(CustomerNames; "Customer Names")
            {
            }
            column(Description; Description)
            {
            }
            column(EntryNo; "Entry No")
            {
            }
            column(ErrorLog; "Error Log")
            {
            }
            column(IsCoopBank; "Is Coop Bank")
            {
            }
            column(POSVendor; "POS Vendor")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(Postings; Postings)
            {
            }
            column(ProcessCode; "Process Code")
            {
            }
            column(ReferenceNo; "Reference No")
            {
            }
            column(ReversalTraceID; "Reversal Trace ID")
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(ReversedPosted; "Reversed Posted")
            {
            }
            column(Source; Source)
            {
            }
            column(TraceID; "Trace ID")
            {
            }
            column(TransTime; "Trans Time")
            {
            }
            column(TransactionChargeCode; "Transaction Charge Code")
            {
            }
            column(TransactionDate; "Transaction Date")
            {
            }
            column(TransactionDescription; "Transaction Description")
            {
            }
            column(TransactionTime; "Transaction Time")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(TransactionTypeCharges; "Transaction Type Charges")
            {
            }
            column(UnitID; "Unit ID")
            {
            }
            column(WithdrawalLocation; "Withdrawal Location")
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



