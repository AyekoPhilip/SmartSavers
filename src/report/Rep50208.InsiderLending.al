report 50208 "Insider Lending"
{
    ApplicationArea = All;
    Caption = 'Insider Lending';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/InsiderLending.rdl';
    dataset
    {
        dataitem(LoansCategorization; "Loans (Reporting)")
        {
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(ProductDescription; "Product Type")
            {
            }
            column(RequestedAmount; "Requested Amount")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(RepaymentStartDate; "Repayment Start Date")
            {
            }
            column(Disbursement_Date; "Disbursement Date")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(Installments; Installments)
            { }
            column(PerformanceIndicator; "Performance Indicator")
            { }
            column(MemberCat; MemberCat)
            { }
            column(BosaDeposit; BosaDeposit)
            { }
            column(LoanSecurityOption; LoanSecurityOption)
            { }
            column(AmountGuaranteed; AmountGuaranteed)
            { }
            column(System_Non_Created; "System Non-Created")
            { }
            trigger OnPreDataItem()
            begin

                Dfilter := '..' + Format(CalcDate('-1D', StartDate));
                Lfilter := Format(StartDate) + '..';

                Loans.Reset();
                Loans.SetFilter("Outstanding Balance", '>0');
                Loans.SetFilter("Disbursement Date", Lfilter);
                if Loans.FindSet() then begin
                    repeat

                        MemberCust.Reset();
                        MemberCust.SetRange("No.", Loans."Account No.");
                        MemberCust.SetFilter("Member Category", '%1|%2 | %3', 'STAFF', 'DIRECTOR', 'BOARD');
                        if MemberCust.Find('-') then begin

                            Ploan.Init();
                            Ploan."No." := Loans."No.";
                            Ploan."Account No." := Loans."Account No.";
                            Ploan."Account Name" := Loans."Account Name";
                            Ploan."Product Type" := Loans."Product Type";
                            Ploan."Loan Account" := Loans."Loan Account";
                            Ploan."Product Description" := Loans."Product Description";
                            Ploan."Requested Amount" := Loans."Requested Amount";
                            Ploan."Approved Amount" := Loans."Approved Amount";
                            Ploan."Repayment Start Date" := Loans."Repayment Start Date";
                            Ploan."Disbursement Date" := Loans."Disbursement Date";
                            Ploan.Installments := Loans.Installments;
                            Ploan."Performance Indicator" := Loans."Performance Indicator";
                            Ploan."Payroll/Staff No." := Loans."Payroll/Staff No.";
                            Ploan.Insert(true);

                        end;
                    until Loans.Next() = 0;
                end;


                Loans.Reset();
                Loans.SetFilter("Outstanding Balance", '>0');
                Loans.SetFilter("Disbursement Date", Dfilter);
                if Loans.FindSet() then begin
                    repeat
                        MemberCust.Reset();
                        MemberCust.SetRange("No.", Loans."Account No.");
                        MemberCust.SetFilter("Member Category", '%1|%2 | %3', 'STAFF', 'DIRECTOR', 'BOARD');
                        if MemberCust.Find('-') then begin
                            Ploan.Init();
                            Ploan."No." := Loans."No.";
                            Ploan."Account No." := Loans."Account No.";
                            Ploan."Account Name" := Loans."Account Name";
                            Ploan."Product Type" := Loans."Product Type";
                            Ploan."Loan Account" := Loans."Loan Account";
                            Ploan."Product Description" := Loans."Product Description";
                            Ploan."Requested Amount" := Loans."Requested Amount";
                            Ploan."Approved Amount" := Loans."Approved Amount";
                            Ploan."Repayment Start Date" := Loans."Repayment Start Date";
                            Ploan."Disbursement Date" := Loans."Disbursement Date";
                            Ploan.Installments := Loans.Installments;
                            Ploan."Performance Indicator" := Loans."Performance Indicator";
                            Ploan."Payroll/Staff No." := Loans."Payroll/Staff No.";
                            Ploan."System Non-Created" := true;
                            Ploan.Insert(true);
                        end;
                    until Loans.Next() = 0;
                end;
            end;

            trigger OnAfterGetRecord()
            begin

                BosaDeposit := 0;
                AmountGuaranteed := 0;
                MemberCust.Reset();
                MemberCust.SetRange("No.", "Account No.");
                if MemberCust.FindFirst() then begin
                    MemberCat := MemberCust."Member Category";
                    SeriNumber := SeriNumber + 1;

                    SavingsAccounts.Reset();
                    SavingsAccounts.SetRange("Member No.", "Account No.");
                    SavingsAccounts.SetRange(SavingsAccounts."Date Filter", 0D, CalcDate('-1D', StartDate));
                    SavingsAccounts.SetRange("Account Category", SavingsAccounts."Account Category"::"Shares Deposit");
                    if SavingsAccounts.FindFirst() then
                        SavingsAccounts.CalcFields("Balance (LCY)");
                    BosaDeposit := SavingsAccounts."Balance (LCY)";

                    LoanSecurities.Reset();
                    LoanSecurities.SetRange("Loan No.", "No.");
                    IF LoanSecurities.Find('-') then begin
                        LoanSecurities.CalcSums("Deposit Shares");
                        if LoanSecurities."Security Type" = LoanSecurities."Security Type"::Guarantor then begin
                            LoanSecurityOption := LoanSecurityOption::Guarantor;
                            AmountGuaranteed := LoanSecurities."Deposit Shares"
                        end else begin
                            LoanSecurityOption := LoanSecurityOption::Collateral;
                            AmountGuaranteed := LoanSecurities."Collateral Value";
                        end;
                    end;
                end else begin
                    CurrReport.Skip();
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
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As At';
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
    trigger OnPreReport()
    begin
        Ploan.SetRange("Approval Status", Ploan."Approval Status"::Open);
        Ploan.DeleteAll();
    end;

    var

        BosaDeposit: Decimal;
        LoanSecurityOption: Option Guarantor,Collateral,Lien;
        LoanSecurities: Record "Guarantor & Security Posted";
        SavingsAccounts: Record "Account Credit";
        MemberCust: Record Member;
        MemberCat: Code[10];
        StartDate: Date;
        SeriNumber: Integer;
        AmountGuaranteed: Decimal;
        Loans: Record "Loans Categorization";
        Ploan: Record "Loans (Reporting)";
        Dfilter: Text[50];
        Lfilter: Text[50];


        EndDate: Date;
}



