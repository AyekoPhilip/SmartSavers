report 50316 "Repayment Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/RepaymentSchedule.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; "Loan Application")
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
                DecimalPlaces = 2 : 2;
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
            dataitem(LCharge; "Loan Application Charge")
            {
                DataItemLink = "Application No." = FIELD("No.");
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

                trigger OnAfterGetRecord()
                begin
                    ChAmt := LCharge."Charge Amount";
                    if LCharge."Charge Method" = LCharge."Charge Method"::"% of Amount" then begin
                        if Loans."Loan Rescheduled" then
                            ChAmt := Round(Loans."Approved Amount" * LCharge.Percentage / 100);
                    end;
                    LoanNet -= ChAmt;

                    if CompInfo.Get then
                        CompInfo.CalcFields(CompInfo.Picture);
                    CompanyAddress := CompInfo.Address + ' -Post Code: ' + CompInfo."Post Code" + ' -City:' + CompInfo.City + ' Region: ' + CompInfo."Country/Region Code";
                    CompanyTelephone := 'Tel: ' + CompInfo."Phone No." + ' -Office Tel: ' + CompInfo."Phone No. 2";
                    CommunicationOnline := 'E-mail: ' + CompInfo."E-Mail";// + '- Website: ' + CompInfo."Home Page";
                end;
            }
            dataitem("Loan Repayment Schedule"; "Loan Repayment Schedule")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "Member No.", "Repayment Date");
                RequestFilterFields = "Member No.", "Product Type";
                column(LoanBalance_LoanRepaymentSchedule; "Loan Repayment Schedule"."Loan Balance")
                {
                }
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

                trigger OnAfterGetRecord()
                begin

                    i := i + 1;

                    TotalPrincipalRepayment := TotalPrincipalRepayment + "Loan Repayment Schedule"."Principal Repayment";
                    if "Loan Repayment Schedule"."Reset Schedule" then begin

                        if "Loan Repayment Schedule"."Reset Doc No." = PreviousDocNo then begin

                            TotalPrincipalRepayment2 := TotalPrincipalRepayment2 + "Loan Repayment Schedule"."Principal Repayment";
                            i2 := i2 + 1;
                            if i2 = 1 then
                                LoanBalance := "Loan Repayment Schedule"."Loan Amount"
                            else
                                LoanBalance := "Loan Repayment Schedule"."Loan Amount" - TotalPrincipalRepayment2 + "Loan Repayment Schedule"."Principal Repayment";
                        end
                        else begin
                            i2 := 1;

                            TotalPrincipalRepayment2 := TotalPrincipalRepayment2 + "Loan Repayment Schedule"."Principal Repayment";
                            LoanBalance := "Loan Repayment Schedule"."Loan Amount" - TotalPrincipalRepayment2 + "Loan Repayment Schedule"."Principal Repayment";

                        end;
                    end
                    else begin

                        if i = 1 then
                            LoanBalance := "Loan Repayment Schedule"."Loan Amount"
                        //LoanBalance:="Loan Amount"-(TotalPrincipalRepayment+"Principal Repayment")

                        else begin
                            LoanBalance := "Loan Repayment Schedule"."Loan Amount" - TotalPrincipalRepayment + "Loan Repayment Schedule"."Principal Repayment";
                        end;
                    end;
                    CumInterest := CumInterest + "Loan Repayment Schedule"."Monthly Interest";
                    CumMonthlyRepayment := CumMonthlyRepayment + "Loan Repayment Schedule"."Monthly Repayment";
                    CumPrincipalRepayment := CumPrincipalRepayment + "Loan Repayment Schedule"."Principal Repayment";
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Member No.");
                    i := 0;
                    j := 0;
                    i2 := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Loans.CalcFields("Total TopUp");
                LoanNet := Loans."Approved Amount" - Loans."Total TopUp";


                if "Show Charges" then
                    ShowCharge := 1;

                ShowCust := 1;

                if "Show Schedule" then
                    ShowSchedule := 1;
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.Get
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
                field(ShowBalance; ShowBalance)
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
        LoanBalance: Decimal;
        CumInterest: Decimal;
        CumMonthlyRepayment: Decimal;
        CumPrincipalRepayment: Decimal;
        j: Integer;
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
        ShowBalance: Boolean;
}




