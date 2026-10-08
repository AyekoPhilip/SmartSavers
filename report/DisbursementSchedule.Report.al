report 50334 "Disbursement Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DisbursementSchedule.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Disbursement Header"; "Loan Disbursement Header")
        {
            column(CompInfoName; CompInfo.Name)
            {
            }
            column(CompInfoAddress; CompInfo.Address)
            {
            }
            column(CompInfoPhoneNo; CompInfo."Phone No.")
            {
            }
            column(CompInfoPicture; CompInfo.Picture)
            {
            }
            column(No_LoanDisbursementHeader; "Loan Disbursement Header"."No.")
            {
            }
            column(Date_LoanDisbursementHeader; "Loan Disbursement Header".Date)
            {
            }
            column(TotalAmount_LoanDisbursementHeader; "Loan Disbursement Header"."Total Amount")
            {
            }
            column(Status_LoanDisbursementHeader; "Loan Disbursement Header"."Approval Status")
            {
            }
            column(PaymentType_LoanDisbursementHeader; "Loan Disbursement Header"."Payment Type")
            {
            }
            column(GlobalDimension2Code_LoanDisbursementHeader; "Loan Disbursement Header"."Global Dimension 2 Code")
            {
            }
            column(NoofLoans_LoanDisbursementHeader; "Loan Disbursement Header"."No of Loans")
            {
            }
            column(PostingRemarks_LoanDisbursementHeader; "Loan Disbursement Header"."Posting Remarks")
            {
            }
            column(NumberText1; NumberText[1])
            {
            }
            dataitem(Loans; Loans)
            {
                DataItemLink = "Batch No." = FIELD("No.");
                column(No_Loans; Loans."No.")
                {
                }
                column(ApplicationDate_Loans; Loans."Application Date")
                {
                }
                column(ProductType_Loans; Loans."Product Type")
                {
                }
                column(AccountNo_Loans; Loans."Account No.")
                {
                }
                column(RequestedAmount_Loans; Loans."Requested Amount")
                {
                }
                column(ApprovedAmount_Loans; Loans."Approved Amount")
                {
                }
                column(InterestRate_Loans; Loans."Interest Rate")
                {
                }
                column(AccountName_Loans; Loans."Account Name")
                {
                }
                column(ApprovalDate_Loans; Loans."Approval Date")
                {
                }
                column(Installments_Loans; Loans.Installments)
                {
                }
                column(DisbursementDate_Loans; Loans."Disbursement Date")
                {
                }
                column(ModeofDisbursement_Loans; Loans."Mode of Disbursement")
                {
                }
                column(GracePeriodPrincipal_Loans; Loans."Grace Period (Principal)")
                {
                }
                column(InstallmentPeriod_Loans; Loans."Installment Period")
                {
                }
                column(Repayment_Loans; Loans.Repayment)
                {
                }
                column(ProductDescription_Loans; Loans."Product Description")
                {
                }
                column(InterestRepayment_Loans; Loans."Interest Repayment")
                {
                }
                column(PrincipleRepayment_Loans; Loans."Principle Repayment")
                {
                }
                column(RepaymentStartDate_Loans; Loans."Repayment Start Date")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, "Loan Disbursement Header"."Total Amount", "Currency Code");
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
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
        CompInfo: Record "Company Information";
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
}




