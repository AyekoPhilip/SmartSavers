report 50403 "Regulatory Form 4A"
{
    ApplicationArea = All;
    Caption = 'Regulatory Form 4A';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/Form4A.rdl';
    dataset
    {
        dataitem(TempDataReporting; "Temp. Data (Reporting)")
        {
            column(EntryNo; "Entry No.")
            {
            }
            column(No; "No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Date; "Date")
            {
            }
            column(Decription; Decription)
            {
            }
            column(Found; Found)
            {
            }
            column(TotalMembership; AccCount[1])
            { }
            column(TotalUnspecifiedMembership; AccCount[2])
            { }
            column(TotalMaleMembership; AccCount[3])
            { }
            column(TotalFemaleMembership; AccCount[4])
            { }
            column(MaleCountCredAc; AccCount[5])
            { }
            column(FemaleCountCredAc; AccCount[6])
            { }
            column(UnspecifiedCountCredAc; AccCount[7])
            { }
            column(TotalCountCredAc; AccCount[8])
            { }
            column(TotalMaleSavingCredAc; Amt[1])
            { }
            column(TotalFemaleSavingCredAc; Amt[2])
            { }
            column(TotalUnspecifiedSavingCredAc; Amt[3])
            { }
            column(TotalSavingCredAc; Amt[4])
            { }

            column(MaleCountBankingAc; AccCount[24])
            { }
            column(FemaleCountBankingAc; AccCount[9])
            { }
            column(UnspecifiedCountBankingAc; AccCount[10])
            { }
            column(TotalCountBankingAc; AccCount[11])
            { }

            column(TotalMaleSavingBankingAc; Amt[5])
            { }
            column(TotalFemaleSavingBankingAc; Amt[6])
            { }
            column(TotalUnspecifiedSavingbankingAc; Amt[7])
            { }
            column(TotalSavingBankingAc; Amt[8])
            { }

            column(StaffMaleCount; AccCount[12])
            { }
            column(StaffFemaleCount; AccCount[13])
            { }
            column(StaffUnspecifiedCount; AccCount[14])
            { }
            column(StaffTotalCount; AccCount[23])
            { }
            column(LoanDisbMaleCount; AccCount[15])
            { }
            column(LoanDisbFemaleCount; AccCount[16])
            { }
            column(LoanDisbUnspecifiedCount; AccCount[17])
            { }
            column(TotLoanDisbCount; AccCount[18])
            { }

            column(LoanDisbMaleAmt; Amt[9])
            { }
            column(LoanDisbFemaleAmt; Amt[10])
            { }
            column(LoanDisbUnspecifiedAmt; Amt[11])
            { }
            column(TotLoanDisbAmt; Amt[12])
            { }

            column(LoanPortFoliobMaleCount; AccCount[19])
            { }
            column(LoanPortFolioFemaleCount; AccCount[20])
            { }
            column(LoanPortFolioUnspCount; AccCount[21])
            { }
            column(TotLoanPortFolioCount; AccCount[22])
            { }

            column(LoanPortFolioMaleAmt; Amt[13])
            { }
            column(LoanPortFolioFemaleAmt; Amt[14])
            { }
            column(LoanPortFolioDisbUnspAmt; Amt[15])
            { }
            column(TotLoanPortFolioAmt; Amt[16])
            { }
            column(NoOfLoanToStaff; NoOfLoanToStaff)
            { }
            column(NoOfLoanToBoard; NoOfLoanToBoard)
            { }
            column(TotNoOfLoan; TotNoOfLoan)
            { }
            column(LoanToStaff; LoanToStaff)
            { }
            column(LoanToBoard; LoanToBoard)
            { }
            column(TotLoan; TotLoan)
            { }
            trigger OnPreDataItem()
            begin

                if StartDate = 0D then StartDate := 20230101D;
                if EndDate = 0D then EndDate := Today;

                CompInfo.get();
                TempData.DeleteAll();

                TempData.Init();
                TempData."No." := '002';
                TempData.Insert(true);
                if Getgender then begin
                    CheckModf();
                end;

                DFilter := '..' + Format(EndDate);
                LoanDFilter := Format(StartDate) + '..' + Format(EndDate);
            end;

            trigger OnAfterGetRecord()
            begin
                fnInitialize();

                //Total Membership
                CustRecord.Reset();
                CustRecord.SetFilter("Customer Type", '<>%1', CustRecord."Customer Type"::"Non-Member");
                CustRecord.SetFilter(Status, '<>%1 & <>%2', CustRecord.Status::Deceased, CustRecord.Status::Withdrawn);
                if CustRecord.FindSet() then begin
                    AccCount[1] := CustRecord.Count;
                end;

                //  Total Unspecified Members
                CustRecord.Reset();
                CustRecord.SetFilter(Gender, '%1 | %2', CustRecord.Gender::" ", CustRecord.Gender::Other);
                CustRecord.SetFilter(Status, '<>%1 & <>%2', CustRecord.Status::Deceased, CustRecord.Status::Withdrawn);
                if CustRecord.FindSet() then begin
                    AccCount[2] := CustRecord.Count;
                end;

                // Total Male Membership
                CustRecord.Reset();
                CustRecord.SetRange(Gender, CustRecord.Gender::Male);
                CustRecord.SetFilter(Status, '<>%1 & <>%2', CustRecord.Status::Deceased, CustRecord.Status::Withdrawn);
                if CustRecord.FindSet() then begin
                    AccCount[3] := CustRecord.Count;
                end;

                // Total Female Membership
                CustRecord.Reset();
                CustRecord.SetRange(Gender, CustRecord.Gender::Female);
                CustRecord.SetFilter(Status, '<>%1 & <>%2', CustRecord.Status::Deceased, CustRecord.Status::Withdrawn);
                if CustRecord.FindSet() then begin
                    AccCount[4] := CustRecord.Count;
                end;

                fngetCustomerShares();
                fngetStaffMembershipDetail();
                fngetLoanDetails();

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
                group(Options)
                {
                    field(Getgender; Getgender)
                    {
                        ApplicationArea = All;
                        Caption = 'Update Gender Details';
                    }
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
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CustRecord: Record Member;
        BalanceLCY: array[7] of Decimal;
        Loan: Record Loans;
        Getgender: Boolean;
        Amt: array[27] of Decimal;
        AccCount: array[27] of Integer;
        LoanToBoard: Decimal;
        LoanToStaff: Decimal;
        NoOfLoanToStaff: Integer;
        NoOfLoanToBoard: Integer;
        TotNoOfLoan: Integer;
        TotLoan: Decimal;
        DFilter: Text[100];
        LoanDFilter: Text[100];
        StartDate: Date;
        EndDate: Date;
        CompInfo: Record "Company Information";
        TempData: Record "Temp. Data (Reporting)";

    procedure CheckModf()
    begin
        CustRecord.Reset();
        CustRecord.SetFilter("Customer Type", '<>%1', CustRecord."Customer Type"::"Non-Member");
        if CustRecord.FindSet() then begin
            repeat

                Loan.Reset();
                Loan.SetRange("Account No.", CustRecord."No.");
                if Loan.FindSet() then begin
                    Loan.ModifyAll(Gender, CustRecord.Gender);
                    Loan.ModifyAll("Member Category", CustRecord."Member Category");
                end;

                AccCredit.Reset();
                AccCredit.SetRange("Member No.", CustRecord."No.");
                if AccCredit.FindSet() then begin
                    AccCredit.ModifyAll(Gender, CustRecord.Gender);
                    AccCredit.ModifyAll(Status, CustRecord.Status);
                    AccCredit.ModifyAll("Member Category", CustRecord."Member Category");
                end;

                AccBanking.Reset();
                AccBanking.SetRange("Member No.", CustRecord."No.");
                if AccBanking.FindSet() then begin
                    AccBanking.ModifyAll(Gender, CustRecord.Gender);
                    AccBanking.ModifyAll(Status, CustRecord.Status);
                    AccBanking.ModifyAll("Member Category", CustRecord."Member Category");
                end;
            until CustRecord.Next() = 0;
        end;
    end;

    procedure fngetCustomerShares()
    begin
        // Total Male Membership Number and Savings
        AccCredit.Reset();
        AccCredit.SetFilter("Date Filter", DFilter);
        AccCredit.SetRange(Gender, AccCredit.Gender::Male);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindSet() then begin
            AccCount[5] := AccCredit.Count;
            repeat
                AccCredit.CalcFields("Balance (LCY)");
                Amt[1] := Amt[1] + AccCredit."Balance (LCY)";
            until AccCredit.Next() = 0;
        end;

        // Total Female Membership Number and  Savings

        AccCredit.Reset();
        AccCredit.SetFilter("Date Filter", DFilter);
        AccCredit.SetRange(Gender, AccCredit.Gender::Female);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindSet() then begin
            AccCount[6] := AccCredit.Count;
            repeat
                AccCredit.CalcFields("Balance (LCY)");
                Amt[2] := Amt[2] + AccCredit."Balance (LCY)";
            until AccCredit.Next() = 0;
        end;

        // Total Unspecified Membership Savings

        AccCredit.Reset();
        AccCredit.SetFilter("Date Filter", DFilter);
        AccCredit.SetFilter(Gender, '%1 | %2', AccCredit.Gender::" ", AccCredit.Gender::Other);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindSet() then begin
            AccCount[7] := AccCredit.Count;
            repeat
                AccCredit.CalcFields("Balance (LCY)");
                Amt[3] := Amt[3] + AccCredit."Balance (LCY)";
            until AccCredit.Next() = 0;
        end;

        // Total Ordinary shares
        AccCredit.Reset();
        AccCredit.SetFilter("Date Filter", DFilter);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindSet() then begin
            AccCount[8] := AccCredit.Count;
            repeat
                AccCredit.CalcFields("Balance (LCY)");
                Amt[4] := Amt[4] + AccCredit."Balance (LCY)";
            until AccCredit.Next() = 0;
        end;


        // Total Male Membership Savings
        AccBanking.Reset();
        AccBanking.SetFilter("Date Filter", DFilter);
        AccBanking.SetRange(Gender, AccBanking.Gender::Male);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Specialty Savings");
        if AccBanking.FindSet() then begin
            AccCount[24] := AccBanking.Count;
            repeat
                AccBanking.CalcFields("Balance (LCY)");
                Amt[5] := Amt[5] + AccBanking."Balance (LCY)";
            until AccBanking.Next() = 0;
        end;

        // Total Female Membership Savings

        AccBanking.Reset();
        AccBanking.SetFilter("Date Filter", DFilter);
        AccBanking.SetRange(Gender, AccBanking.Gender::Female);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Specialty Savings");
        if AccBanking.FindSet() then begin
            AccCount[9] := AccBanking.Count;
            repeat
                AccBanking.CalcFields("Balance (LCY)");
                Amt[6] := Amt[6] + AccBanking."Balance (LCY)";
            until AccBanking.Next() = 0;
        end;

        // Total Unspecified Membership Savings

        AccBanking.Reset();
        AccBanking.SetFilter("Date Filter", DFilter);
        AccBanking.SetFilter(Gender, '%1 | %2', AccBanking.Gender::" ", AccBanking.Gender::Other);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Specialty Savings");
        if AccBanking.FindSet() then begin
            AccCount[10] := AccBanking.Count;
            repeat
                AccBanking.CalcFields("Balance (LCY)");
                Amt[7] := Amt[7] + AccBanking."Balance (LCY)";
            until AccBanking.Next() = 0;
        end;

        // Total school fee savings
        AccBanking.Reset();
        AccBanking.SetFilter("Date Filter", DFilter);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Specialty Savings");
        if AccBanking.FindSet() then begin
            AccCount[11] := AccBanking.Count;
            repeat
                AccBanking.CalcFields("Balance (LCY)");
                Amt[8] := Amt[8] + AccBanking."Balance (LCY)";
            until AccBanking.Next() = 0;
        end;

    end;

    procedure fngetStaffMembershipDetail()
    begin
        CustRecord.Reset();
        CustRecord.SetRange("Member Category", 'STAFF');
        CustRecord.SetRange(Gender, CustRecord.Gender::Male);
        if CustRecord.FindSet() then begin
            AccCount[12] := CustRecord.Count;
        end;

        CustRecord.Reset();
        CustRecord.SetRange("Member Category", 'STAFF');
        CustRecord.SetRange(Gender, CustRecord.Gender::Female);
        if CustRecord.FindSet() then begin
            AccCount[13] := CustRecord.Count;
        end;

        CustRecord.Reset();
        CustRecord.SetRange("Member Category", 'STAFF');
        CustRecord.SetFilter(Gender, '%1 | %2', CustRecord.Gender::" ", CustRecord.Gender::Other);
        if CustRecord.FindSet() then begin
            AccCount[14] := CustRecord.Count;
        end;

        CustRecord.Reset();
        CustRecord.SetRange("Employer Code", '1002');
        if CustRecord.FindSet() then begin
            AccCount[23] := CustRecord.Count;
        end;

    end;

    procedure fngetLoanDetails()
    begin

        //>> Loans Disbursed >>
        Loan.Reset();
        Loan.SetFilter("Outstanding Balance", '>0');
        Loan.SetRange(Gender, Loan.Gender::Male);
        Loan.SetFilter("Disbursement Date", LoanDFilter);
        Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
        if Loan.FindSet() then begin
            Loan.CalcFields("Outstanding Balance");
            Loan.CalcSums("Approved Amount");
            Amt[9] := Loan."Approved Amount";
            AccCount[15] := Loan.Count;

        end;

        Loan.Reset();
        Loan.SetFilter("Outstanding Balance", '>0');
        Loan.SetRange(Gender, Loan.Gender::Female);
        Loan.SetFilter("Disbursement Date", LoanDFilter);
        Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
        if Loan.FindSet() then begin
            Loan.CalcFields("Outstanding Balance");
            Loan.CalcSums("Approved Amount");
            Amt[10] := Loan."Approved Amount";
            AccCount[16] := Loan.Count;
        end;

        Loan.Reset();
        Loan.SetFilter("Outstanding Balance", '>0');
        Loan.SetFilter("Disbursement Date", LoanDFilter);
        Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
        Loan.SetFilter(Gender, '%1 | %2', Loan.Gender::" ", Loan.Gender::Other);
        if Loan.FindSet() then begin
            Loan.CalcFields("Outstanding Balance");
            Loan.CalcSums("Approved Amount");
            Amt[11] := Loan."Approved Amount";
            AccCount[17] := Loan.Count;
        end;

        Loan.Reset();
        Loan.SetFilter("Outstanding Balance", '>0');
        Loan.SetFilter("Disbursement Date", LoanDFilter);
        Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
        if Loan.FindSet() then begin
            Loan.CalcFields("Outstanding Balance");
            Loan.CalcSums("Approved Amount");
            Amt[12] := Loan."Approved Amount";
            AccCount[18] := Loan.Count;
        end;
        //<< Loans Disbursed >>

        //>> Loan PortFolio <<

        Loan.Reset();
        Loan.SetFilter("Date Filter", DFilter);
        Loan.SetRange(Gender, Loan.Gender::Male);
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    Amt[13] := Amt[13] + Loan."Outstanding Balance";
                    AccCount[19] := AccCount[19] + 1;
                end;
            until Loan.Next() = 0;
        end;

        Loan.Reset();
        Loan.SetFilter("Date Filter", DFilter);
        Loan.SetRange(Gender, Loan.Gender::Female);
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    Amt[14] := Amt[14] + Loan."Outstanding Balance";
                    AccCount[20] := AccCount[20] + 1;
                end;
            until Loan.Next() = 0;
        end;


        Loan.Reset();
        Loan.SetFilter("Date Filter", DFilter);
        Loan.SetFilter(Gender, '%1 | %2', Loan.Gender::" ", Loan.Gender::Other);
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    Amt[15] := Amt[15] + Loan."Outstanding Balance";
                    AccCount[21] := AccCount[21] + 1;
                end;
            until Loan.Next() = 0;
        end;

        Loan.Reset();
        Loan.SetFilter("Outstanding Balance", '>0');
        Loan.SetFilter("Date Filter", DFilter);
        if Loan.FindSet() then begin
            Loan.CalcFields("Outstanding Balance");
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    Amt[16] := Amt[16] + Loan."Outstanding Balance";
                    AccCount[22] := AccCount[22] + 1;
                end;
            until Loan.Next() = 0;
        end;
        //<< Loan PortFolio >>

        //>> loan to Staff/Board >>
        Loan.Reset();
        Loan.SetFilter("Date Filter", DFilter);
        Loan.SetRange("Member Category", 'STAFF');
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    LoanToStaff := LoanToStaff + Loan."Outstanding Balance";
                    NoOfLoanToStaff := NoOfLoanToStaff + 1;
                end;
            until Loan.Next() = 0;
        end;

        Loan.Reset();
        Loan.SetRange("Member Category", 'DIRECTOR');
        Loan.SetFilter("Date Filter", DFilter);
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    LoanToBoard := LoanToBoard + Loan."Outstanding Balance";
                    NoOfLoanToBoard := NoOfLoanToBoard + 1;
                end;
            until Loan.Next() = 0;
        end;

        Loan.Reset();
        Loan.SetFilter("Date Filter", DFilter);
        Loan.SetFilter("Member Category", '%1 | %2', 'DIRECTOR', 'STAFF');
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    TotLoan := TotLoan + Loan."Outstanding Balance";
                    TotNoOfLoan := TotNoOfLoan + 1;
                end;
            until Loan.Next() = 0;
        end;

    end;

    procedure fnInitialize()
    begin
        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;
        Amt[4] := 0;
        Amt[5] := 0;
        Amt[6] := 0;
        Amt[7] := 0;
        Amt[8] := 0;
        Amt[9] := 0;
        Amt[10] := 0;
        Amt[11] := 0;
        Amt[12] := 0;
        Amt[13] := 0;
        Amt[14] := 0;
        Amt[15] := 0;
        Amt[16] := 0;
        Amt[17] := 0;
        Amt[18] := 0;
        Amt[19] := 0;
        Amt[20] := 0;
        Amt[21] := 0;
        Amt[22] := 0;
        Amt[23] := 0;
        AccCount[24] :=0;
        AccCount[1] := 0;
        AccCount[2] := 0;
        AccCount[3] := 0;
        AccCount[4] := 0;
        AccCount[5] := 0;
        AccCount[6] := 0;
        AccCount[7] := 0;
        AccCount[8] := 0;
        AccCount[9] := 0;
        AccCount[10] := 0;
        AccCount[11] := 0;
        AccCount[12] := 0;
        AccCount[13] := 0;
        AccCount[14] := 0;
        AccCount[15] := 0;
        AccCount[16] := 0;
        AccCount[17] := 0;
        AccCount[18] := 0;
        AccCount[19] := 0;
        AccCount[20] := 0;
        AccCount[21] := 0;
        AccCount[22] := 0;
        AccCount[23] := 0;
        AccCount[24] := 0;
        AccCount[25] := 0;
        AccCount[26] := 0;
        AccCount[27] := 0;
        NoOfLoanToBoard := 0;
        NoOfLoanToStaff := 0;
        LoanToBoard := 0;
        LoanToStaff := 0;
        TotLoan := 0;
        TotNoOfLoan := 0;
    end;
}

