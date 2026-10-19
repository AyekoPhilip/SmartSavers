report 50233 "Collateral Register"
{
    ApplicationArea = All;
    Caption = 'Collateral Register';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/CollateralRegister.rdl';
    dataset
    {
        dataitem(GuarantorSecurityPosted; "Guarantor & Security Posted")
        {
            DataItemTableView = where("Security Type" = const(Collateral));
            column(LoanNo; "Loan No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(Name; Name)
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(SecurityType; "Security Type")
            {
            }
            column(CollateralRegNo; "Collateral Reg. No.")
            {
            }
            column(CollateralValue; "Collateral Value")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MemberNoLoanee; "Member No. (Loanee)")
            {
            }
            column(No; "No.")
            {
            }
            column(PolicyEndDate; PolicyEndDate)
            { }
            column(PolicyRefNo; PolicyRefNo)
            { }
            column(PolicyStartDate; PolicyStartDate)
            { }
            column(IssueDate; IssueDate)
            { }
            column(AppAmount; AppAmount)
            { }
            column(AnnualPremium; AnnualPremium)
            { }
            column(DateOfLastValuation; DateOfLastValuation)
            { }
            column(TittleNoRef; TittleNoRef)
            { }
            column(ReferenceNo; ReferenceNo)
            { }
            column(Collat; Collat)
            { }

            trigger OnPreDataItem()
            begin


            end;

            trigger OnAfterGetRecord()
            begin
                CollRegister.Reset();
                CollRegister.SetRange("No.", "Collateral Reg. No.");
                if CollRegister.FindFirst() then begin
                    TittleNoRef := CollRegister."Registration No.";
                    PolicyRefNo := CollRegister."Policy No.";
                    PolicyStartDate := CollRegister."Policy Start Date";
                    PolicyEndDate := CollRegister."Policy End Date";
                    AnnualPremium := CollRegister."Annual Premium Amount";
                    DateOfLastValuation := CollRegister."Date Premium Last Paid";
                    ReferenceNo := CollRegister."Engine No.";
                    Collat := CollRegister.Collateral;

                end;
                if Loan.Get("Loan No.") then begin
                    AppAmount := Loan."Approved Amount";
                    IssueDate := Loan."Disbursement Date";
                    "Member No." := Loan."Account No.";
                    "ID No." := Loan."ID No."
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
        CollRegister: Record "Collateral Register";
        IssueDate: Date;
        Tenor: Code[20];
        AppAmount: Decimal;
        TittleNoRef: Code[100];
        PolicyRefNo: Code[100];
        PolicyStartDate: Date;
        PolicyEndDate: Date;
        AnnualPremium: Decimal;
        Loan: Record Loans;
        DateOfLastValuation: Date;
        ReferenceNo: Code[100];
        Collat: Code[50];

}



