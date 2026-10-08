report 50210 "Daily Cash (Teller) Report"
{
    ApplicationArea = All;
    Caption = 'Daily Cash (Teller) Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DailyCashTellerReport.rdl';
    dataset
    {

        dataitem(BankAccount; "Bank Account")
        {
            RequestFilterFields = "No.";

            column(No; "No.")
            {
            }
            column(BankType; "Bank Type")
            {
            }
            column(CashierID; CashierID)
            {
            }
            column(Balance__LCY_; "Balance (LCY)")
            { }
            column(StartBalance; StartBalance)
            { }
            column(AppAmount1; AppAmount[1])
            { }
            column(AppAmount2; AppAmount[2])
            { }
            column(AppAmount3; AppAmount[3])
            { }
            column(AppAmount4; AppAmount[4])
            { }
            column(AppAmount5; AppAmount[5])
            { }
            column(AppAmount6; AppAmount[6])
            { }
            column(AppAmount7; AppAmount[7])
            { }
            column(NoOfTransaction1; NoOfTransaction[1])
            { }
            column(NoOfTransaction2; NoOfTransaction[2])
            { }
            column(NoOfTransaction3; NoOfTransaction[3])
            { }
            column(NoOfTransaction4; NoOfTransaction[4])
            { }
            column(NoOfTransaction5; NoOfTransaction[5])
            { }

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) then Error('Start Date or End Date must have a value');

            end;

            trigger OnAfterGetRecord()
            begin

                IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                    SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                    CALCFIELDS("Net Change", "Net Change (LCY)");
                    StartBalance := "Net Change";
                    SETFILTER("Date Filter", DateFilter_BankAccount);
                END;
                Bnk := '';

                DateFilter := Format(StartDate) + '..' + Format(EndDate);
                AppAmount[1] := 0;
                AppAmount[2] := 0;
                AppAmount[3] := 0;
                AppAmount[4] := 0;
                AppAmount[5] := 0;
                AppAmount[6] := 0;
                AppAmount[7] := 0;

                NoOfTransaction[1] := 0;
                NoOfTransaction[2] := 0;
                NoOfTransaction[3] := 0;
                NoOfTransaction[4] := 0;
                NoOfTransaction[5] := 0;

                Teller.Reset();
                Teller.SetRange(Posted, true);
                Teller.SetRange("Till Code", "No.");
                Teller.SetFilter("Date Posted", DateFilter);
                Teller.SetFilter(Type, '%1| %2', Teller.Type::"Cash Deposit", Teller.Type::"Credit Receipt");
                if Teller.FindSet() then begin
                    Teller.CalcSums(Amount);
                    AppAmount[1] := Teller.Amount;
                end;

                Teller.Reset();
                Teller.SetRange(Posted, true);
                Teller.SetRange("Till Code", "No.");
                Teller.SetFilter("Date Posted", DateFilter);
                Teller.SetRange(Type, Teller.Type::"Cash Withdrawal");
                if Teller.FindSet() then begin
                    Teller.CalcSums(Amount);
                    AppAmount[2] := Teller.Amount;
                end;

                BankingMngt.Reset();
                BankingMngt.SetRange("Account ID", CashierID);
                BankingMngt.SetRange("Default  Bank", "No.");
                if BankingMngt.FindFirst() then begin

                    Treasury.Reset();
                    Treasury.SetRange(Posted, true);
                    Treasury.SetRange("To Account", BankingMngt."Account ID");
                    Treasury.SetFilter("Date Posted", DateFilter);
                    Treasury.SetRange("Transaction Type", Treasury."Transaction Type"::"Issue To Teller");
                    if Treasury.FindSet() then begin
                        Treasury.CalcSums(Amount);
                        AppAmount[3] := Treasury.Amount;
                    end;


                    Treasury.Reset();
                    Treasury.SetRange(Posted, true);
                    Treasury.SetRange("From Account", BankingMngt."Account ID");
                    Treasury.SetFilter("Date Posted", DateFilter);
                    Treasury.SetRange("Transaction Type", Treasury."Transaction Type"::"Return To Treasury");
                    if Treasury.FindSet() then begin
                        Treasury.CalcSums(Amount);
                        AppAmount[5] := Treasury.Amount;
                    end;

                    /// Cash to Teller
                    Treasury.Reset();
                    Treasury.SetRange(Posted, true);
                    Treasury.SetRange("From Account", BankingMngt."Account ID");
                    Treasury.SetFilter("Date Posted", DateFilter);
                    Treasury.SetRange("Transaction Type", Treasury."Transaction Type"::"Inter Teller Transfers");
                    if Treasury.FindSet() then begin
                        Treasury.CalcSums(Amount);
                        AppAmount[6] := Treasury.Amount;
                    end;

                    /// Cash from Teller 
                    Treasury.Reset();
                    Treasury.SetRange(Posted, true);
                    Treasury.SetRange("To Account", BankingMngt."Account ID");
                    Treasury.SetFilter("Date Posted", DateFilter);
                    Treasury.SetRange("Transaction Type", Treasury."Transaction Type"::"Inter Teller Transfers");
                    if Treasury.FindSet() then begin
                        Treasury.CalcSums(Amount);
                        AppAmount[7] := Treasury.Amount;
                    end;
                end;

                Teller.Reset();
                Teller.SetRange("Till Code", "No.");
                Teller.SetFilter("Date Posted", DateFilter);
                Teller.SetFilter(Type, '%1| %2', Teller.Type::"Cash Deposit", Teller.Type::"Credit Receipt");
                if Teller.FindSet() then begin
                    NoOfTransaction[1] := Teller.Count;
                end;

                Teller.Reset();
                Teller.SetRange(Posted, true);
                Teller.SetRange("Till Code", "No.");
                Teller.SetFilter("Date Posted", DateFilter);
                Teller.SetRange(Type, Teller.Type::"Cash Withdrawal");
                if Teller.FindSet() then begin
                    NoOfTransaction[2] := Teller.Count;
                end;

                Teller.Reset();
                Teller.SetRange(Posted, true);
                Teller.SetRange("Till Code", "No.");
                Teller.SetFilter("Date Posted", DateFilter);
                Teller.SetRange(Type, Teller.Type::"Cheque Deposit");
                if Teller.FindSet() then begin
                    NoOfTransaction[3] := Teller.Count;
                end;

                Teller.Reset();
                Teller.SetRange(Posted, true);
                Teller.SetRange("Till Code", "No.");
                Teller.SetFilter("Date Posted", DateFilter);
                Teller.SetRange(Type, Teller.Type::"Bank Cheques");
                if Teller.FindSet() then begin
                    NoOfTransaction[4] := Teller.Count;
                end;

                Teller.Reset();
                Teller.SetRange(Posted, true);
                Teller.SetRange("Till Code", "No.");
                Teller.SetFilter("Date Posted", DateFilter);
                Teller.SetRange(Type, Teller.Type::"Credit Receipt");
                if Teller.FindSet() then begin
                    NoOfTransaction[5] := Teller.Count;
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
                        Caption = 'Start Date';
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
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
    trigger OnPreReport()
    begin
        DateFilter_BankAccount := BankAccount.GetFilter("Date Filter");
    end;

    var
        BankingAcc: Record "Account Banking";
        NoOfTransaction: array[12] of Integer;
        CredAcc: Record "Account Credit";
        Bnk: Code[50];
        BankingMngt: Record "Banking User Template";
        RegMngt: Codeunit "Register Management";
        SharesCapital: Decimal;
        StartBalance: Decimal;
        DateFilter_BankAccount: Text[150];
        Treasury: Record "Treasury Cashier Transaction";
        CustAge: Integer;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        DepMultiplier: array[5] of Decimal;
        CustEmail: Text[150];
        CustomerRec: Record Member;
        BalanceBF: Decimal;
        CName: Text[150];
        AppAmount: array[12] of Decimal;
        Disdate: Date;
        OutBal: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text[150];
        StaffNo: Code[10];
        Teller: Record "Teller Transaction";

}



