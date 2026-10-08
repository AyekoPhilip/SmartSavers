report 50404 "Loans Register Mngt"
{
    ApplicationArea = All;
    Caption = 'Loans Register Mngt';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/LoanNormalization.rdl';
    UseRequestPage = true;
    ShowPrintStatus = false;
    dataset
    {
        dataitem(Loans; Loans)
        {
            column(No; "No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingBill; "Outstanding Bill")
            {
            }
            column(OutstandingInsurance; "Outstanding Insurance")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(PostedAmt; PostedAmt)
            {

            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                PostedAmt := 0;

                CredLedger.Reset();
                CredLedger.SetRange("Loan No.", "No.");
                CredLedger.SetRange("Transaction Type", CredLedger."Transaction Type"::Loan);
                if CredLedger.FindSet() then begin
                    CredLedger.CalcSums(Amount);
                    PostedAmt := CredLedger.Amount;
                end;

                if SkipUnrelatedEntry then begin
                    if "Approved Amount" <> PostedAmt then
                        CurrReport.Skip();
                end;
                if Normalize then begin
                    Validate("Requested Amount", PostedAmt);
                    Modify(true)
                end
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
                group(Option)
                {
                    field(SkipUnrelatedEntry; SkipUnrelatedEntry)
                    {
                        Caption = 'Skip Related entries';
                        ApplicationArea = All;
                    }
                    field(Normalize; Normalize)
                    {
                        Caption = 'Normalize unrelated Entries';
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
        CredLedger: Record "Detailed Cust. Ledg. Entry";
        PostedAmt: Decimal;
        Normalize: Boolean;
        SkipUnrelatedEntry: Boolean;
}
