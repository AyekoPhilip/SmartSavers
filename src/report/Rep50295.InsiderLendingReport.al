report 50295 "Insider Lending Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/InsiderLendingReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = WHERE("Purpose of Loan" = FILTER(<> '0'));
            column(LoanProductType_Loans; Loans."Product Type")
            {
            }
            column(RequestedAmount_Loans; Loans."Requested Amount")
            {
            }
            column(ApprovedAmount_Loans; Loans."Approved Amount")
            {
            }
            column(ApprovalDate_Loans; Loans."Approval Date")
            {
            }
            column(Installment_Period; Loans.Installments)
            {
            }
            column(RepaymentStartDate_Loans; Loans."Currency Code")
            {
            }
            column(DisbursementDate_Loans; Loans."Disbursement Date")
            {
            }
            column(BosaDeposit; BosaDeposit)
            {
            }
            column(LoanSecurityOption; LoanSecurityOption)
            {
            }
            column(SerialNumber; SeriNumber)
            {
            }
            column(MemberNo_Loans; Loans."Account No.")
            {
            }
            column(MemberName_Loans; Loans."Account Name")
            {
            }
            column(StaffNo_Loans; Loans."Repayment Mode")
            {
            }
            column(MemberCat; MemberCat)
            {
            }

            trigger OnAfterGetRecord()
            begin
                BosaDeposit := 0;
                MemberCust.Reset;
                MemberCust.SetRange("No.", Loans."Account No.");
                MemberCust.SetFilter("Member Category", '%1|%2', 'STAFF', 'BOARD');
                if MemberCust.Find('-') then begin
                    MemberCat := MemberCust."Member Category";
                    SeriNumber := SeriNumber + 1;

                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange("Employer Code", Loans."Account No.");
                    SavingsAccounts.SetRange("Account Category", SavingsAccounts."Account Category"::"Certificates of Deposit");
                    if SavingsAccounts.Find('-') then
                        SavingsAccounts.CalcFields("Balance (LCY)");
                    BosaDeposit := SavingsAccounts."Balance (LCY)";

                    LoanSecurities.Reset;
                    LoanSecurities.SetRange("Member Substituted", Loans."Account No.");
                    if LoanSecurities.Find('-') then
                        LoanSecurityOption := LoanSecurities."Security Type";
                end else
                    CurrReport.Skip;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BosaDeposit: Decimal;
        LoanSecurityOption: Option Guarantor,Collateral,Lien;
        LoanSecurities: Record "Loan Guarantors and Security";
        SavingsAccounts: Record "Account Banking";
        SeriNumber: Integer;
        MemberCust: Record Member;
        MemberCat: Code[20];
}




