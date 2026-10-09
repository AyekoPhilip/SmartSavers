report 50362 "Post QC Rollover"
{
    ApplicationArea = All;
    Caption = 'Post QC Rollover';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(LoansCategorization; Loans)
        {
            RequestFilterFields = "No.", "Product Type", "Disbursement Date", "Account No.";
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
            column(No; "No.")
            { }
            trigger OnPreDataItem()
            begin
                TransType := TransType::"Loan Interest";

            end;

            trigger OnAfterGetRecord()
            begin
                if CustRec.Get("Account No.") then
                    if CustRec.Status = CustRec.Status::Deceased then CurrReport.Skip();
                IntDue := 0;

                if PFact.Get("Product Type") then begin
                    case PFact."Loan Span" of
                        PFact."Loan Span"::"Mobile Loan":
                            begin
                                if TransType = TransType::"Loan Interest" then begin
                                    if "Interest Due Date" = Today then begin

                                        IntDue := Round("Outstanding Balance" * (PFact."Interest Rate (Max.)" / 100));
                                        CalcFields("Outstanding Balance",
                                                  "Outstanding Bill",
                                                  "Outstanding Interest",
                                                  "Outstanding Principal");
                                    end;

                                    if ("Interest Cycles" = 0) or ("Interest Cycles" = 1) then begin

                                    end;
                                    PeriodicMngt.PostMobileLoanInterest(LoansCategorization, 1)
                                end;
                                if TransType = TransType::"Loan Penalty" then begin
                                    ///PeriodicMngt.PostMobileLoanPenalty(LoansCategorization, 1, PenaltyAmt, IntDueDate);
                                end;
                            end;
                    end
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
                group("Transaction Type")
                {
                    field(IntDueDate; IntDueDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                    }
                    field(TransType; TransType)
                    {
                        Caption = 'Transaction Type';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(PenaltyAmt; PenaltyAmt)
                    {
                        Caption = 'Penalty Charged';
                        ApplicationArea = All;
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
    var
        PFact: Record "Product Factory";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        IntDueDate: Date;
        PostDate: Date;
        TransType: Option "","Loan Interest","Loan Penalty";
        PenaltyAmt: Decimal;
        CustRec: Record Member;
        RepayType: Enum "LoanTransactionType";
        IntDue: Decimal;
        TransactionType: Enum MobileTransType;
        FosaAc: Record "Account Banking";
        RegisterMngt: Codeunit "Register Management";
        AvailBalance: Decimal;
        BalanceLCY: Decimal;
        DeductionStatus: Enum MobileDeductionStatus;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        TempEntry: Record "Transaction Types-Mobile";
}



