report 50392 "EFT Partial Disbursement"
{
    ApplicationArea = All;
    Caption = 'EFT Partial Disbursement';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/EFTPartialLoanSchedule.rdl';
    dataset
    {
        dataitem(EFTTransferLines; "EFT Transfer Lines")
        {
            column(No; No)
            {
            }
            column(PartialLoanNo; "Partial Loan No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(MobilePhoneNo; "Mobile Phone No.")
            {
            }
            column(ExternalAccountName; "External Account Name")
            {
            }
            column(ExternalAccountNo; "External Account No.")
            {
            }
            column(IBANNo; "IBAN No.")
            {
            }
            column(InstitutionType; "Institution Type")
            {
            }
            column(PaymentDestinationCode; "Payment Destination Code")
            {
            }
            column(OwnReference; "Own Reference")
            {
            }
            column(PaymentDestination; "Payment Destination")
            {
            }
            column(RecipientReference; "Recipient Reference")
            {
            }
            column(SocietyCode; "Society Code")
            {
            }
            column(PhysicalAddress; "Physical Address")
            {
            }
            column(EFTOptions; "EFT Options")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(BranchCode; "Branch Code")
            {
            }
            column(BranchName; "Branch Name")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(ApplicationSource; "Application Source")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(Type; "Type")
            {
            }
            column(AvailableBalance; "Available Balance")
            {
            }
            column(ApproveAmt; ApproveAmt)
            { }
            column(ProductType; ProductType)
            { }
            column(RemaingAmt; RemaingAmt)
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                ApproveAmt := 0;
                ProductType := '';
                RemaingAmt := 0;

                if Loans.Get("Loan No.") then begin
                    Loans.CalcFields("Total Amount Disbursed");

                    ApproveAmt := Loans."Approved Amount";
                    ProductType := Loans."Product Description";
                    RemaingAmt := (Loans."Approved Amount" - Loans."Total Amount Disbursed");
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
        ApproveAmt: Decimal;
        ProductType: Text[150];
        Loans: Record Loans;
        RemaingAmt: Decimal;


}
