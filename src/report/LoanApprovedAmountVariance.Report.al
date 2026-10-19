report 50400 "Loan Approved Amount Variance"
{
    ApplicationArea = All;
    Caption = 'Loan Approved Amount Variance';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/LoanApprovedRegister.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(LoanNo; Loans."No.")
            { }
            column(MemberNo; Loans."Account No.")
            { }
            column(MemberName; Loans."Account Name")
            { }
            column(LoanType; Loans."Product Type")
            { }
            column(RequestedAmount; Loans."Requested Amount")
            { }
            column(ApprovedAmount; Loans."Approved Amount")
            { }
            column(Total_TopUp; "Total TopUp")
            { }
            column(Amount_to_Disburse; "Amount to Disburse")
            { }
            column(Installments; Loans.Installments)
            { }
            column(Interest_Rate; "Interest Rate")
            { }
            column(Repayment; Repayment)
            { }
            column(DisbursementDate; Loans."Disbursement Date")
            { }
            column(Expected_Date_of_Completion; "Expected Date of Completion")
            { }
            column(Outstanding_Interest; "Outstanding Interest")
            { }
            column(Outstanding_Principal; "Outstanding Principal")
            { }
            column(Outstanding_Balance; "Outstanding Balance")
            { }
            column(Picture; Company.Picture)
            { }
            column(Address; Company.Address)
            { }
            column(Company_Name; Company.Name)
            { }
            column(TopUpComms; TopUpComms)
            { }
            column(MinuteNo; MinuteNo)
            { }
            column(BalanceLCY; BalanceLCY)
            { }
            column(IntRate; IntRate)
            { }
            column(TotLoan; TotLoan)
            { }

            trigger OnPreDataItem()
            begin

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
               // CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                //CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                MinuteNo := '';
                BalanceLCY := 0;
                TotLoan := 0;
                CalcFields("Outstanding Balance");

                if Loan.Get("No.") then begin
                    MinuteNo := Loan."Minute No.";
                end;
                if FactP.Get("Product Type") then begin
                    IntRate := FactP."Interest Rate (Max.)";
                end;

                CalcFields("Total TopUp", "Outstanding Balance");

                LedgerEntry.Reset();
                LedgerEntry.SetRange("Loan No.", "No.");
                LedgerEntry.SetRange("Document No.", 'OPENBALOAN');
                LedgerEntry.SetRange("Transaction Type", LedgerEntry."Transaction Type"::Loan);
                if LedgerEntry.FindFirst() then begin
                    TotLoan := LedgerEntry.Amount;
                end;
                if "Approved Amount" <> TotLoan then begin
                    Validate("Requested Amount",TotLoan);
                    Modify(true)
                end;
                if TotLoan = 0 then CurrReport.Skip();
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
                    field(ShowAccountZeroBal; ShowAccountZeroBal)
                    {
                        Caption = 'Show Account Zero Deposit Balance';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if Company.Get() then
            Company.CalcFields(Company.Picture);
    end;

    var
        Company: Record "Company Information";
        LoanAppcharges: Record "Loan Product Charges";
        TopUpComms: Decimal;
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CompanyInformation: Record "Company Information";
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        ExciseDuty: Decimal;
        GeneralSetUp: Record "General Set-Up";
        TotLoan: Decimal;
        Loan: Record Loans;
        MinuteNo: Code[50];
        ShowAccountZeroBal: Boolean;
        BosaAc: Record "Account Credit";
        BalanceLCY: Decimal;
        IntRate: Decimal;
        FactP: Record "Product Factory";
        LedgerEntry: Record "Detailed Cust. Ledg. Entry";
}
