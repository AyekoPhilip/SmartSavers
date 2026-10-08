report 50346 "Loans Matching Deposit"
{
    DefaultLayout = RDLC;
    Caption = 'Loan Without Matching Deposits';
    RDLCLayout = './src/report_layout/LoansMatchingDeposits.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; "Loans Categorization")
        {
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
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
            column(Performance_Indicator; "Performance Indicator")
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
            column(GuarantorDep; GuarantorDep)
            {

            }

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
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                MinuteNo := '';
                BalanceLCY := 0;
                CalcFields("Outstanding Balance");

                if Loan.Get("No.") then begin
                    MinuteNo := Loan."Minute No.";
                end;
                if FactP.Get("Product Type") then begin
                    IntRate := FactP."Interest Rate (Max.)";
                end;

                CalcFields("Total TopUp", "Outstanding Balance");

                if "Total TopUp" > 0 then begin
                    LoanAppcharges.Reset;
                    LoanAppcharges.SetRange("Product Code", "Product Type");
                    LoanAppcharges.SetRange("Charge Type", LoanAppcharges."Charge Type"::"Top up");
                    if LoanAppcharges.FindSet then begin
                        repeat
                            if LoanAppcharges."Staggered Charge Code" = '' then begin
                                if LoanAppcharges."Use Percentage" then begin
                                    LoanAppcharges.TestField(Percentage);
                                    TopUpComms := Round((TopUpComms + ("Total TopUp" * (LoanAppcharges.Percentage / 100))), 1, '=');
                                end else begin
                                    LoanAppcharges.TestField("Charge Amount");
                                    TopUpComms := (TopUpComms + LoanAppcharges."Charge Amount")
                                end;
                            end else begin
                                TransType.Reset();
                                TransType.SetRange("Staggered Charge Code", LoanAppcharges."Staggered Charge Code");
                                if TransType.FindFirst() then begin

                                    TieredChargeLine.Reset();
                                    TieredChargeLine.SetRange(code, TransType."Staggered Charge Code");
                                    if TieredChargeLine.FindSet() then begin
                                        repeat
                                            if ("Total TopUp" >= TieredChargeLine."Lower Limit") and ("Total TopUp" <= TieredChargeLine."Upper Limit") then begin
                                                if TieredChargeLine."Use Percentage" then begin
                                                    TopUpComms := Round("Total TopUp" * (TieredChargeLine.Percentage / 100), 1, '=');
                                                end else begin
                                                    TopUpComms := TieredChargeLine."Charge Amount"
                                                end;
                                            end;
                                        until TieredChargeLine.Next() = 0;
                                    end;
                                end;
                            end;

                            if LoanAppcharges."Effect Excise Duty" = LoanAppcharges."Effect Excise Duty"::Yes then begin
                                ExciseDuty := Round((ExciseDuty + (TopUpComms * GeneralSetUp."Excise Duty (%)" / 100)), 1, '=');
                            end;
                        until LoanAppcharges.Next = 0;
                    end;
                end else begin
                    TopUpComms := 0
                end;

                GuarantorDep := 0;

                Guarantor.Reset();
                Guarantor.SetRange(Substituted, false);
                Guarantor.SetRange("Loan No.", "No.");
                if Guarantor.FindSet() then begin
                    repeat
                        if AccBosa.Get(Guarantor."Account No.") then begin
                            AccBosa.CalcFields("Balance (LCY)");
                            GuarantorDep := GuarantorDep + AccBosa."Balance (LCY)";
                        end;
                    until Guarantor.Next() = 0;
                end;

                if ShowAccountZeroBal then begin
                    BosaAc.Reset();
                    BosaAc.SetRange("Member No.", "Account No.");
                    BosaAc.SetRange("Account Category", BosaAc."Account Category"::"Shares Deposit");
                    if BosaAc.FindFirst() then begin
                        BosaAc.CalcFields("Balance (LCY)");
                        BalanceLCY := BosaAc."Balance (LCY)";
                    end;

                    if BalanceLCY > 0 then
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
        AccBosa: Record "Account Credit";
        CompanyInformation: Record "Company Information";
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        ExciseDuty: Decimal;
        GeneralSetUp: Record "General Set-Up";
        Loan: Record Loans;
        MinuteNo: Code[50];
        ShowAccountZeroBal: Boolean;
        BosaAc: Record "Account Credit";
        BalanceLCY: Decimal;
        IntRate: Decimal;
        FactP: Record "Product Factory";
        GuarantorDep: Decimal;
        Guarantor: Record "Guarantor & Security Posted";

}


