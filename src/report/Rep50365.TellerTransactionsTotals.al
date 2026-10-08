report 50365 "Teller Transactions-Totals"
{
    ApplicationArea = All;
    Caption = 'Teller Transactions-Totals';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/TellerTransactions.rdl';
    dataset
    {
        dataitem(ProductFactory; "Product Factory")
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "Product ID", "Account Dimension", "Product Class";
            column(ProductID; "Product ID")
            {
            }
            column(Description; Description)
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(CashDeposit; AmountPosted[1])
            {

            }
            column(ChequeDeposit; AmountPosted[2])
            {

            }
            column(CashWithdrawal; AmountPosted[3])
            {

            }
            column(BankerCheque; AmountPosted[4])
            {

            }
            column(CreditReceipt; AmountPosted[5])
            {

            }
            column(CreditCheque; AmountPosted[6])
            {

            }
            column(FixedDep; AmountPosted[7])
            {

            }
            trigger OnPreDataItem()
            begin
                if StartDate = 0D then Error('Start Date or End Date must have a value');
                if EndDate = 0D then EndDate := Today;

            end;

            trigger OnAfterGetRecord()
            begin
                AmountPosted[1] := 0;
                AmountPosted[2] := 0;
                AmountPosted[3] := 0;
                AmountPosted[4] := 0;
                AmountPosted[5] := 0;
                AmountPosted[6] := 0;
                AmountPosted[7] := 0;

                TellerTrans.Reset();
                TellerTrans.SetRange(Posted, true);
                TellerTrans.SetRange("Product Type", "Product ID");
                TellerTrans.SetFilter("Transaction Date", DateFilter);
                TellerTrans.SetRange(Type, TellerTrans.Type::"Cash Deposit");
                if TellerTrans.FindSet() then begin
                    TellerTrans.CalcSums(Amount);
                    AmountPosted[1] := TellerTrans.Amount;
                end;

                TellerTrans.Reset();
                TellerTrans.SetRange(Posted, true);
                TellerTrans.SetRange("Product Type", "Product ID");
                TellerTrans.SetFilter("Transaction Date", DateFilter);
                TellerTrans.SetRange(Type, TellerTrans.Type::"Cheque Deposit");
                if TellerTrans.FindSet() then begin
                    TellerTrans.CalcSums(Amount);
                    AmountPosted[2] := TellerTrans.Amount;
                end;

                TellerTrans.Reset();
                TellerTrans.SetRange(Posted, true);
                TellerTrans.SetRange("Product Type", "Product ID");
                TellerTrans.SetFilter("Transaction Date", DateFilter);
                TellerTrans.SetRange(Type, TellerTrans.Type::"Cash Withdrawal");
                if TellerTrans.FindSet() then begin
                    TellerTrans.CalcSums(Amount);
                    AmountPosted[3] := TellerTrans.Amount;
                end;

                TellerTrans.Reset();
                TellerTrans.SetRange(Posted, true);
                TellerTrans.SetRange("Product Type", "Product ID");
                TellerTrans.SetFilter("Transaction Date", DateFilter);
                TellerTrans.SetRange(Type, TellerTrans.Type::"Bankers Cheque");
                if TellerTrans.FindSet() then begin
                    TellerTrans.CalcSums(Amount);
                    AmountPosted[4] := TellerTrans.Amount;
                end;

                TellerTrans.Reset();
                TellerTrans.SetRange(Posted, true);
                TellerTrans.SetFilter("Transaction Date", DateFilter);
                TellerTrans.SetRange(Type, TellerTrans.Type::"Credit Receipt");
                if TellerTrans.FindSet() then begin
                    TellerTransLines.Reset();
                    TellerTransLines.SetRange("Product Type", "Product ID");
                    TellerTransLines.SetRange("Transaction No.", TellerTrans."No.");
                    if TellerTransLines.FindFirst() then begin
                        AmountPosted[5] := TellerTransLines.Amount;
                    end else begin
                        AmountPosted[5] := 0
                    end;
                end;

                TellerTrans.Reset();
                TellerTrans.SetRange(Posted, true);
                TellerTrans.SetFilter("Transaction Date", DateFilter);
                TellerTrans.SetRange(Type, TellerTrans.Type::"Credit Cheque");
                if TellerTrans.FindSet() then begin

                    TellerTransLines.Reset();
                    TellerTransLines.SetRange("Product Type", "Product ID");
                    TellerTransLines.SetRange("Transaction No.", TellerTrans."No.");
                    if TellerTransLines.FindFirst() then begin
                        AmountPosted[6] := TellerTransLines.Amount;
                    end else begin
                        AmountPosted[6] := 0;
                    end;
                end;

                case "Account Category" of
                    "Account Category"::"Certificates of Deposit":
                        begin
                            FixedDeposit.Reset();
                            FixedDeposit.SetRange("Product Type", "Product ID");
                            FixedDeposit.SetFilter("Registration Date", DateFilter);
                            FixedDeposit.SetRange("Fixed Deposit Status", FixedDeposit."Fixed Deposit Status"::Active);
                            if FixedDeposit.FindSet() then begin
                                repeat
                                    FixedDeposit.CalcFields("Balance (LCY)");
                                    AmountPosted[7] := (AmountPosted[7] + FixedDeposit."Balance (LCY)");
                                until FixedDeposit.Next() = 0;
                            end;
                        end;
                end
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
                group("Date Filter")
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
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
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text[250];
        Deposits: Decimal;
        Withdrawal: Decimal;
        TellerTrans: Record "Teller Transaction";
        AmountPosted: array[7] of Decimal;
        TellerTransLines: Record "Cashier Transaction Line";
        FixedDeposit: Record "Account Banking";

}



