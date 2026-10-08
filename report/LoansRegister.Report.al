report 50315 "Loans Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoanRegister.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; "Loans")
        {
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Employer Code", "Date Filter";
            DataItemTableView = where("Approval Status" = CONST(Posted), "Disbursement Date" = filter(<> ''));

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
            column(Product_Description; "Product Description")
            { }
            column(RequestedAmount; Loans."Requested Amount")
            { }
            column(ApprovedAmount; Loans."Approved Amount")
            { }
            column(Total_TopUp; "Total TopUp")
            { }
            column(Amount_to_Disburse; "Amount to Disburse")
            { }
            column(Installments; Loans.Installments) { }
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
            column(Months_In_arrears; "Months In arrears")
            { }
            column(Amount_In_Arrears; "Amount In Arrears")
            { }
            column(Sasra_Category; "Sasra Category")
            { }
            column(Days_in_Arrears; "Days in Arrears")
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
            column(InterestPaid; InterestPaid) { }
            column(Interest_Paid; "Rcv Interest Paid") { }
            column(loannumber; loannumber) { }

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
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
/*
                MinuteNo := '';
                BalanceLCY := 0;

                CalcFields("Outstanding Balance","Interest Paid","Outstanding Principal");

                if Loan.Get("No.") then begin
                    MinuteNo := Loan."Minute No.";
                end;
                if FactP.Get("Product Type") then begin
                    IntRate := FactP."Interest Rate (Max.)";
                end;

                CalcFields("Total TopUp", "Outstanding Balance");

                CalcFields("Total TopUp", "Outstanding Balance","Outstanding Principal");

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

                                BosaAc.Reset();
                                BosaAc.SetRange("Member No.", "Account No.");
                                BosaAc.SetRange("Account Category", BosaAc."Account Category"::"Shares Deposit");
                                if BosaAc.FindFirst() then begin
                                    BosaAc.CalcFields("Balance (LCY)");
                                    BalanceLCY := BosaAc."Balance (LCY)";
                                end;
                */

                if "Outstanding Balance" = 0 then
                    CurrReport.Skip();

                loannumber := loannumber + 1;

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
        Loan: Record Loans;
        loannumber: Integer;
        MinuteNo: Code[50];
        IntRate, InterestPaid : Decimal;
        FactP: Record "Product Factory";
        ShowAccountZeroBal: Boolean;
        BosaAc: Record "Account Credit";
        BalanceLCY: Decimal;

}




