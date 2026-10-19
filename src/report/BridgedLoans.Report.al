report 50234 "Bridged Loans"
{
    ApplicationArea = All;
    Caption = 'Bridged Loans';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/BridgedLoanRegister.rdl';

    dataset
    {
        dataitem(Loans; "Loans Categorization")
        {
            DataItemTableView = where("Total TopUp" = filter(> 0));
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
            dataitem("Loans Top up Posted"; "Loans Top up Posted")
            {
                DataItemLink = "No." = field("No.");

                column(Loan_Top_Up; "Loan Top Up")
                { }
                column(Loan_No_; "Loan No.")
                { }
                column(No_; "No.")
                { }
                column(TopupOutstanding_Balance; "Outstanding Balance")
                { }
                column(TopUpOutstanding_Interest; "Outstanding Interest")
                { }
                column(TopupOutstanding_Principle; "Outstanding Principle")
                { }
                column(Total_Amount; "Total Amount")
                { }
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
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                //CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin

                CalcFields("Total TopUp");

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
}



