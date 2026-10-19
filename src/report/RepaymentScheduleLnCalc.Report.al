report 50399 "Repayment Schedule -Ln. Calc"
{
    ApplicationArea = All;
    Caption = 'Repayment Schedule -Ln. Calc';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/LoanCalcRepaymentSchedule.rdl';

    dataset
    {
        dataitem(Loans; "Loan Calculator")
        {
           
            column(ShowCust; ShowCust)
            {
            }
            column(ShowCharge; ShowCharge)
            {
            }
            column(ShowSchedule; ShowSchedule)
            {
            }
            column(No_; "No.")
            { }

            column(Principal_Interest; Loans."Interest Repayment")
            {
            }
            column(LoanPrincipleRepayment_Loans; Loans."Principle Repayment")
            {
            }
            column(LoanInterestRepayment_Loans; Loans."Interest Repayment")
            {
            }
            column(MonthlyTrackingFee_Loans; Loans."Total Disbursed")
            {
            }
            column(Interest; Loans."Interest Rate")
            {
            }
            column(Interest_Rate; "Interest Rate")
            {

            }
            column(Installments_Loans; Loans.Installments)
            {
            }
            column(LoansCleared_Loans; Loans."Total TopUp")
            {
            }
            column(Repayment; Loans.Repayment)
            {
            }
            column(Loans_Loans_Interest; Loans."Interest Rate")
            {

            }
            column(Loans_Loans__Approved_Amount_; Loans."Approved Amount")
            {
            }
            column(Loans_Loans__Loan_Product_Type_Name_; Loans."Product Description")
            {
            }
            column(Loans_Loans__Client_Name_; Loans."Account Name")
            {
            }
            column(Loans_Loans__Client_Code_; Loans."Account No.")
            {
            }
            column(Loans__Repayment_Method_; Loans."Interest Calculation Method")
            {
            }
            column(Intallments__Months_Caption; Intallments__Months_CaptionLbl)
            {
            }
            column(Loans_Loans__Loan__No__; Loans."No.")
            {
            }
            column(Disbursment_DateCaption; Disbursment_DateCaptionLbl)
            {
            }
            column(Current_InterestCaption; Current_InterestCaptionLbl)
            {
            }
            column(Loan_AmountCaption; Loan_AmountCaptionLbl)
            {
            }
            column(Loan_ProductCaption; Loan_ProductCaptionLbl)
            {
            }
            column(Loan_No_Caption; Loan_No_CaptionLbl)
            {
            }
            column(Account_No_Caption; Account_No_CaptionLbl)
            {
            }
            column(COMPANY_NAME; CompanyName)
            {
            }
            column(AmountToDisburse_Loans; Loans."Approved Amount")
            {
            }
            column(ModeofDisbursement_Loans; Loans."Mode of Disbursement")
            {
            }
            column(CompanyInformation_Name; CompInfo.Name)
            {
            }
            column(CompanyInformation_Picture; CompInfo.Picture)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyTelephone; CompanyTelephone)
            {
            }
            column(CommunicationOnline; CommunicationOnline)
            {
            }
            dataitem("Loan Repayment Schedule"; "Loan Repayment Schedule")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "Member No.", "Repayment Date");
                RequestFilterFields = "Member No.", "Product Type";
                column(LoanBalance_LoanRepaymentSchedule; "Loan Repayment Schedule"."Loan Balance")
                {
                }
                column(Insurance_Repayment; "Insurance Repayment")
                { }
                column(Settlement_Fee; "Settlement Fee")
                { }
                column(BalanceBF; BalanceBF)
                { }
                column(TrackingFee_LoanRepaymentSchedule; "Loan Repayment Schedule"."Monthly Insurance")
                {
                }
                column(ROUND__Monthly_Repayment__10_____; "Monthly Repayment")
                {
                }
                column(FORMAT__Repayment_Date__0_4_; "Repayment Date")
                {
                }
                column(ROUND__Principal_Repayment__10_____; "Principal Repayment")
                {
                }
                column(ROUND__Monthly_Interest__10_____; "Monthly Interest")
                {
                }
                column(LoanBalance; LoanBalance)
                {
                }
                column(Loan_Repayment_Schedule__Repayment_Code_; "Repayment Code")
                {
                }
                column(ROUND__Monthly_Repayment__10______Control1000000043; "Monthly Repayment")
                {
                }
                column(ROUND__Principal_Repayment__10______Control1000000014; "Principal Repayment")
                {
                }
                column(ROUND__Monthly_Interest__10______Control1000000015; "Monthly Interest")
                {
                }
                column(Monthly_RepaymentCaption; Monthly_RepaymentCaptionLbl)
                {
                }
                column(InterestCaption; InterestCaptionLbl)
                {
                }
                column(Principal_RepaymentCaption; Principal_RepaymentCaptionLbl)
                {
                }
                column(Due_DateCaption; Due_DateCaptionLbl)
                {
                }
                column(Loan_BalanceCaption; Loan_BalanceCaptionLbl)
                {
                }
                column(Loan_RepaymentCaption; Loan_RepaymentCaptionLbl)
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(Loan_Repayment_Schedule_Loan_No_; "No.")
                {
                }
                column(Loan_Repayment_Schedule_Member_No_; "Member No.")
                {
                }
                column(Loan_Repayment_Schedule_Repayment_Date; "Repayment Date")
                {
                }
                column(FileNo; FileNo)
                { }

                trigger OnAfterGetRecord()
                begin

                    i := i + 1;
                    LoanBalance := "Loan Balance" - "Principal Repayment";
                    if LoanBalance < 0 then
                        LoanBalance := 0;

                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Member No.");
                    i := 0;
                    j := 0;
                    i2 := 0;
                end;
            }
            dataitem(LCharge; "Loan Application Charge")
            {
                DataItemLink = "Application No." = field("No.");
                column(ProductCode_LCharge; LCharge."Product Code")
                {
                }
                column(LoanNo_LCharge; LCharge."Application No.")
                {
                }
                column(LoanNet; LoanNet)
                {
                }
                column(ChargeDescription_LCharge; LCharge."Charge Description")
                {
                }
                column(Percentage_LCharge; LCharge.Percentage)
                {
                }
                column(ChAmt; ChAmt)
                {
                }
                column(ChargeAmount_LCharge; LCharge."Charge Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ChAmt := LCharge."Charge Amount";
                    if LCharge."Use Percentage" then
                        ChAmt := Round(Loans."Approved Amount" * LCharge.Percentage / 100)
                    else
                        ChAmt := LCharge."Charge Amount"
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FileNo := '';
                Loans.CalcFields("Total TopUp");
                LoanNet := Loans."Approved Amount" - Loans."Total TopUp";
                if CustRec.Get("Account No.") then begin
                    FileNo := CustRec."File No."
                end;

                if "Show Charges" then
                    ShowCharge := 1;

                ShowCust := 1;

                if "Show Schedule" then
                    ShowSchedule := 1;
                LRepayment.Reset();
                LRepayment.SetRange("No.", "No.");
                if LRepayment.FindLast() then
                    InstallNo := LRepayment."Instalment No";
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.Get();
                CompInfo.CalcFields(CompInfo.Picture);
                CompanyAddress := CompInfo.Address + ' -Post Code: ' + CompInfo."Post Code" + ' -City:' + CompInfo.City + ' Region: ' + CompInfo."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompInfo."Phone No." + ' -Office Tel: ' + CompInfo."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompInfo."E-Mail";// + '- Website: ' + CompInfo."Home Page";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Show Charges"; "Show Charges")
                {
                    ApplicationArea = All;
                }
                field("Show Schedule"; "Show Schedule")
                {
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            "Show Charges" := true;
            "Show Schedule" := true;
        end;
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        i: Integer;
        LRepayment: Record "Loan Repayment Schedule";
        LoanBalance: Decimal;
        CumInterest: Decimal;
        CumMonthlyRepayment: Decimal;
        CumPrincipalRepayment: Decimal;
        j: Integer;
        InstallNo: Integer;
        TotalPrincipalRepayment: Decimal;
        Intallments__Months_CaptionLbl: Label 'Intallments (Months)';
        Disbursment_DateCaptionLbl: Label 'Disbursment Date';
        Current_InterestCaptionLbl: Label 'Current Interest';
        Loan_AmountCaptionLbl: Label 'Loan Amount';
        Loan_ProductCaptionLbl: Label 'Loan Product';
        Loan_No_CaptionLbl: Label 'Loan No.';
        Account_No_CaptionLbl: Label 'Account No.';
        Monthly_RepaymentCaptionLbl: Label 'Monthly Repayment';
        InterestCaptionLbl: Label 'Interest';
        Principal_RepaymentCaptionLbl: Label 'Principal Repayment';
        Due_DateCaptionLbl: Label 'Due Date';
        Loan_BalanceCaptionLbl: Label 'Loan Balance';
        Loan_RepaymentCaptionLbl: Label 'Loan Repayment';
        TotalCaptionLbl: Label 'Total';
        i2: Integer;
        TotalPrincipalRepayment2: Decimal;
        PreviousDocNo: Code[10];
        ChAmt: Decimal;
        BalanceBF: Decimal;
        LoanNet: Decimal;
        ShowCust: Integer;
        ShowCharge: Integer;
        ShowSchedule: Integer;
        "Show Charges": Boolean;
        "Show Schedule": Boolean;
        CompInfo: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        FileNo: Code[100];
        CustRec: Record Member;
}
