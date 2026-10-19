report 50331 "DCS Credit Scoring New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DCSCreditScoringNew.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; Loans)
        {
            dataitem("Loan Application Credit Score"; "Loan Application Credit Score")
            {
                DataItemLink = "Loan No." = FIELD("No.");
                DataItemTableView = SORTING("Qualification Type") ORDER(Ascending);
                RequestFilterFields = "Loan No.";
                column(CustomerNo_LoanApplicationCreditScore; "Loan Application Credit Score"."Customer No.")
                {
                }
                column(ProductCode_LoanApplicationCreditScore; "Loan Application Credit Score"."Product Code")
                {
                }
                column(ParameterCode_LoanApplicationCreditScore; "Loan Application Credit Score"."Parameter Code")
                {
                }
                column(Score_LoanApplicationCreditScore; "Loan Application Credit Score".Score)
                {
                }
                column(CalculatedSuccess_LoanApplicationCreditScore; "Loan Application Credit Score"."Calculated Success")
                {
                }
                column(CalculatedFailure_LoanApplicationCreditScore; "Loan Application Credit Score"."Calculated Failure")
                {
                }
                column(RequestedAmount_LoanApplicationCreditScore; "Loan Application Credit Score"."Requested Amount")
                {
                }
                column(QualifyingAmount_LoanApplicationCreditScore; "Loan Application Credit Score"."Qualifying Amount")
                {
                }
                column(RequestTime_LoanApplicationCreditScore; "Loan Application Credit Score".RequestTime)
                {
                }
                column(GeneralOutput_LoanApplicationCreditScore; "Loan Application Credit Score"."General Output")
                {
                }
                column(LoanNo_LoanApplicationCreditScore; "Loan Application Credit Score"."Loan No.")
                {
                }
                column(ParameterCalculation_LoanApplicationCreditScore; "Loan Application Credit Score"."Parameter Calculation")
                {
                }
                column(Priority_LoanApplicationCreditScore; "Loan Application Credit Score".Priority)
                {
                }
                column(Variable_LoanApplicationCreditScore; "Loan Application Credit Score".Variable)
                {
                }
                column(QualificationType_LoanApplicationCreditScore; "Loan Application Credit Score"."Qualification Type")
                {
                }
                column(SystemGenScore_LoanApplicationCreditScore; "Loan Application Credit Score"."System Gen. Score")
                {
                }
                column(AmtI; "Loan Application Credit Score"."Score Value")
                {
                }
                column(VeryLow_LoanApplicationCreditScore; "Loan Application Credit Score"."Very Low")
                {
                }
                column(Low_LoanApplicationCreditScore; "Loan Application Credit Score".Low)
                {
                }
                column(Moderate_LoanApplicationCreditScore; "Loan Application Credit Score".Moderate)
                {
                }
                column(High_LoanApplicationCreditScore; "Loan Application Credit Score".High)
                {
                }
                column(VeryHigh_LoanApplicationCreditScore; "Loan Application Credit Score"."Very High")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Amt[1] := 0;
                    Amt[2] := 0;
                    Amt[3] := 0;
                    Amt[4] := 0;
                    Amt[5] := 0;

                    AthirdAmt := 0;
                    TBasic := 0;
                    TEarning := 0;
                    TAllowance := 0;
                    TDeductions := 0;
                    Varscore := 0;

                    AppraisalSal.Reset;
                    AppraisalSal.SetRange("No.", "Loan No.");
                    if not AppraisalSal.Find('-') then begin
                        Error('No Salary Details available');
                    end else begin
                        repeat
                            if AppraisalSal.Type = AppraisalSal.Type::Basic then
                                TBasic := TBasic + AppraisalSal.Amount
                            else
                                if AppraisalSal.Type = AppraisalSal.Type::Earnings then
                                    TEarning := AppraisalSal.Amount
                                else
                                    if AppraisalSal.Type = AppraisalSal.Type::"Other Allowances" then
                                        TAllowance := TAllowance + AppraisalSal.Amount
                                    else
                                        if AppraisalSal.Type = AppraisalSal.Type::Deductions then
                                            TDeductions := TDeductions + AppraisalSal.Amount;
                        until AppraisalSal.Next = 0;
                    end;

                    AthirdAmt := (TBasic * (1 / 3));
                end;
            }
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
        Amt: array[5] of Decimal;
        AppraisalSal: Record "Appraisal Salary Details";
        TBasic: Decimal;
        TEarning: Decimal;
        TAllowance: Decimal;
        TDeductions: Decimal;
        AthirdAmt: Decimal;
        Varscore: Decimal;
}




