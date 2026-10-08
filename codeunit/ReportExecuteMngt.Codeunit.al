codeunit 50059 "Report Execute Mngt."
{
    trigger OnRun()
    begin
    end;

    var
        PLoans: Record "Loans Categorization";
        StartDate: Date;
        DateFilter: Text[100];
        Lshedule: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        TotExpBalance: Decimal;
        AmountInArrears: Decimal;
        LoanAge: Decimal;
        TotalExpRepayment: Decimal;
        DaysArrears: Decimal;
        PrincipalPaid: Decimal;
        PrinPaid: Decimal;
        LoanPrinc: Decimal;
        NegTotPaid: Decimal;
        RegMngt: Codeunit "Register Management";
        CredMngt: Codeunit "Credit Mgmt.";
        ToDate: Date;
        TotalAmtPaid: Decimal;
        DaysInArrears: Integer;
        RegisterMngt: Codeunit "Register Management";
        Cust: Record Member;
        CrbData: Record "CRB Data";
        Employer: Record Customer;
        CustMember: Record Member;
        Notif: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        VarVariant: Variant;
        FactProduct: Record "Product Factory";
        AmountApp: Decimal;
        MonthInArrears: Decimal;
        MRepayment: Decimal;

    procedure fnInitialize()
    begin
        TotExpBalance := 0;
        AmountInArrears := 0;
        LoanAge := 0;
        TotalExpRepayment := 0;
        MRepayment := 0;
        AmountApp := 0;
        DaysArrears := 0;
        PrincipalPaid := 0;
        MonthInArrears := 0;
        PrinPaid := 0;
        LoanPrinc := 0;
        NegTotPaid := 0;
        AmountInArrears := 0;
        TotalAmtPaid := 0;
        DaysInArrears := 0;
        MonthInArrears := 0;
    end;

    procedure generateLoanArrears(AccountNo: Code[100]; Cutoffdate: Date; SendNotification: Boolean)
    var
        Loan: Record "Loans Categorization";
    begin
        Loan.Reset();
        Loan.SetRange("No.", AccountNo);
        if Loan.FindFirst() then begin
            Loan.CalcFields("Outstanding Interest", "Outstanding Principal", "Outstanding Balance");
            fnInitialize();

            if (Loan."Outstanding Balance" < 0) or (Loan."Outstanding Balance" = 0) then begin
                AmountInArrears := 0;
                DaysInArrears := 0;
                Loan."Expected Repayment" := 0;
                Loan."Days in Arrears" := DaysInArrears;
                Loan."Amount In Arrears" := AmountInArrears;
                Loan."Performance Indicator" := Loan."Performance Indicator"::"Closed Account";
            end;

            if Loan."Outstanding Balance" > 0 then begin
                Lshedule.Reset();
                Lshedule.SetRange("No.", Loan."No.");
                if Lshedule.FindLast() then begin
                    Loan."Expected Date of Completion" := Lshedule."Repayment Date";
                    Loan.Modify(true);
                end;

                Lshedule.Reset();
                Lshedule.SetRange("No.", Loan."No.");
                if not Lshedule.Find('-') then begin
                    CredMngt.fncreateRepayschedule(false, Loan."No.", 0);
                end;

                ToDate := Loan."Repayment Start Date";
                TotalAmtPaid := (Loan."Approved Amount" - Loan."Outstanding Principal");
                DateFilter := Format(ToDate) + '..' + Format(Cutoffdate);

                Lshedule.Reset();
                Lshedule.SetRange("No.", Loan."No.");
                Lshedule.SetFilter("Repayment Date", DateFilter);
                if Lshedule.FindLast() then begin
                    LoanPrinc := Lshedule."Loan Balance";
                end;

                if Loan."Repayment Start Date" <= Cutoffdate then begin

                    Rshedule.Reset();
                    Rshedule.SetRange("No.", Loan."No.");
                    Rshedule.SetFilter("Repayment Date", DateFilter);
                    if Rshedule.FindSet() then begin
                        LoanAge := Rshedule.Count;
                        MRepayment := Rshedule."Monthly Repayment";
                        Rshedule.CalcSums("Monthly Repayment");
                        TotalExpRepayment := Round(Rshedule."Monthly Repayment", 1, '=');

                        if MRepayment >= Loan."Outstanding Balance" then
                            MRepayment := Loan."Outstanding Balance" else
                            MRepayment := MRepayment;

                        if TotalExpRepayment >= Loan."Outstanding Balance" then
                            TotalExpRepayment := Loan."Outstanding Balance" else
                            Loan."Expected Repayment" := TotalExpRepayment;

                        if Loan."Expected Date of Completion" <= Cutoffdate then
                            AmountInArrears := Loan."Outstanding Balance" else
                            AmountInArrears := (Loan."Outstanding Balance" - LoanPrinc);

                        if AmountInArrears < 0 then
                            AmountInArrears := 0;

                        if Loan."Expected Date of Completion" <= Cutoffdate then begin
                            DaysInArrears := (Cutoffdate - Loan."Expected Date of Completion");
                        end else begin
                            MonthInArrears := Round((AmountInArrears / MRepayment), 1, '=');
                            DaysInArrears := Round((MonthInArrears * 30.41), 1, '=');
                        end;

                        if DaysInArrears < 0 then
                            DaysInArrears := 0;

                        if (Loan."Product Type" = 'MSACCOLN') or (Loan."Product Type" = 'DIVIDEND') then begin
                            DaysInArrears := 0;
                            AmountInArrears := 0;
                            Loan."Performance Indicator" := Loan."Performance Indicator"::Performing;
                        end else begin

                            if AmountInArrears = 0 then begin
                                Loan."Performance Indicator" := Loan."Performance Indicator"::Performing;
                            end else begin

                                case DaysInArrears of

                                    1 .. 30:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Watch;
                                    31 .. 180:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Substandard;
                                    181 .. 365:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Doubtfull;
                                    366 .. 999999999:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Loss
                                end;
                            end;
                        end;
                    end;
                end else begin
                    AmountInArrears := 0;
                    DaysInArrears := 0;
                    Loan."Days in Arrears" := DaysInArrears;
                    Loan."Amount In Arrears" := AmountInArrears;
                    Loan."Expected Repayment" := Loan.Repayment;
                    Loan."Performance Indicator" := Loan."Performance Indicator"::Performing;
                end;
                Loan."Loan Age" := LoanAge;
                Loan."Amount In Arrears" := AmountInArrears;
                Loan."Days in Arrears" := DaysInArrears;
                Loan."Expected Repayment" := TotalExpRepayment;
            end;
            Loan.Modify(true);
        end;

    end;

    procedure Token(VAR Text: Text[100]; Separator: Text[1]) Token: Text[100]
    var
        Pos: Integer;
    begin
        Pos := StrPos(Text, Separator);
        if Pos > 0 then begin
            Token := CopyStr(Text, 1, Pos - 1);
            if Pos + 1 <= StrLen(Text) then
                Text := CopyStr(Text, Pos + 1)
            else
                Text := '';
        end else begin
            Token := Text;
            Text := '';
        end;
    end;

    procedure generateLoanArrearsOnSpecificLoan(LoanNo: Code[100]; Cutoffdate: Date)
    Var
        Loan: Record "Loans Categorization";
        PFact: Record "Product Factory";
    begin

        Loan.Reset();
        Loan.SetRange("No.", LoanNo);
        if Loan.FindFirst() then begin
            Loan.CalcFields("Outstanding Interest", "Outstanding Principal", "Outstanding Balance");
            TotExpBalance := 0;
            AmountInArrears := 0;
            LoanAge := 0;
            TotalExpRepayment := 0;
            DaysArrears := 0;
            PrincipalPaid := 0;
            PrinPaid := 0;
            LoanPrinc := 0;
            NegTotPaid := 0;
            AmountInArrears := 0;
            TotalAmtPaid := 0;
            DaysInArrears := 0;

            if (Loan."Outstanding Balance" < 0) or (Loan."Outstanding Balance" = 0) then begin
                Loan."Days in Arrears" := 0;
                Loan."Amount In Arrears" := 0;
                Loan."Expected Repayment" := 0;
                Loan."Performance Indicator" := Loan."Performance Indicator"::"Closed Account";
                Loan.Modify(true);
            end;

            if Loan."Outstanding Balance" > 0 then begin

                Lshedule.Reset();
                Lshedule.SetRange("No.", Loan."No.");
                if not Lshedule.Find('-') then begin
                    CredMngt.fncreateRepayschedule(false, Loan."No.", 0);
                end;

                ToDate := Loan."Disbursement Date";
                TotalAmtPaid := (Loan."Approved Amount" - Loan."Outstanding Principal");

                DateFilter := Format(ToDate) + '..' + Format(Cutoffdate);

                Lshedule.Reset();
                Lshedule.SetRange("No.", Loan."No.");
                Lshedule.SetFilter("Repayment Date", DateFilter);
                if Lshedule.FindLast() then begin
                    LoanPrinc := Lshedule."Principal Repayment";
                end;

                TotalAmtPaid := (Loan."Approved Amount" - Loan."Outstanding Principal");

                if Loan."Repayment Start Date" <= Cutoffdate then begin

                    Rshedule.Reset();
                    Rshedule.SetRange("No.", Loan."No.");
                    Rshedule.SetFilter("Repayment Date", DateFilter);
                    if Rshedule.FindSet() then begin
                        Rshedule.CalcSums("Principal Repayment");
                        TotalExpRepayment := Round(Rshedule."Principal Repayment", 1, '=');
                        LoanAge := Rshedule.Count;

                        if Loan."Expected Date of Completion" <= Cutoffdate then
                            LoanAge := (Cutoffdate - Loan."Disbursement Date") else
                            LoanAge := LoanAge;

                        Loan."Loan Age" := LoanAge;
                        Loan."Expected Repayment" := TotalExpRepayment;

                        if Loan."Expected Date of Completion" <= Cutoffdate then
                            AmountInArrears := Loan."Outstanding Balance" else
                            AmountInArrears := (TotalExpRepayment - Loan."Amount Paid");

                        if Loan."Amount In Arrears" < 0 then
                            AmountInArrears := 0;

                        Loan."Amount In Arrears" := AmountInArrears;

                        if Loan."Expected Date of Completion" <= Cutoffdate then
                            DaysInArrears := (Cutoffdate - Loan."Disbursement Date") else
                            DaysInArrears := Round((AmountInArrears / LoanPrinc), 1, '=');
                        if DaysInArrears < 0 then
                            DaysInArrears := 0;

                        Loan."Days in Arrears" := DaysInArrears;
                        if AmountInArrears = 0 then begin
                            Loan."Performance Indicator" := Loan."Performance Indicator"::Performing;
                        end else begin
                            case DaysInArrears of
                                1 .. 30:
                                    Loan."Performance Indicator" := Loan."Performance Indicator"::Watch;
                                31 .. 180:
                                    Loan."Performance Indicator" := Loan."Performance Indicator"::Substandard;
                                181 .. 365:
                                    Loan."Performance Indicator" := Loan."Performance Indicator"::Doubtfull;
                                366 .. 999999999:
                                    Loan."Performance Indicator" := Loan."Performance Indicator"::Loss
                            end;
                        end;

                    end else begin
                        if Loan."Expected Date of Completion" <= Cutoffdate then begin
                            AmountInArrears := Loan."Outstanding Balance";
                            DaysInArrears := (Cutoffdate - Loan."Disbursement Date");
                            if Loan."Amount In Arrears" < 0 then
                                AmountInArrears := 0;

                            Loan."Amount In Arrears" := AmountInArrears;

                            if DaysInArrears < 0 then
                                DaysInArrears := 0;
                            Loan."Days in Arrears" := DaysInArrears;
                            if AmountInArrears = 0 then begin
                                Loan."Performance Indicator" := Loan."Performance Indicator"::Performing;
                            end else begin
                                case DaysInArrears of
                                    1 .. 30:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Watch;
                                    31 .. 180:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Substandard;
                                    181 .. 365:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Doubtfull;
                                    366 .. 999999999:
                                        Loan."Performance Indicator" := Loan."Performance Indicator"::Loss
                                end;
                            end;
                        end
                    end;
                end else begin
                    Loan."Days in Arrears" := 0;
                    Loan."Amount In Arrears" := 0;
                    Loan."Expected Repayment" := Loan.Repayment;
                    Loan."Performance Indicator" := Loan."Performance Indicator"::Performing;
                end;
                Loan.Modify(true)
            end;
        end
    end;

    procedure generateCRBData(Loan: Record "Loans Categorization"; Cutoffdate: Date)
    var
        MyString: Text[150];
        String1: Text[150];
        String2: Text[150];
        String3: Text[150];
        String4: Text[150];
        String5: Text[150];
        DateFor: Text[50];
        Day: Integer;
        Month: Integer;
        Year: Integer;
        M: Text;
        D: Text;
        CredLedger: Record "Loan Ledger Entry";
    begin
        Loan.CalcFields("Outstanding Interest", "Outstanding Principal", "Outstanding Balance", "Last Pay Date");
        if Loan."Outstanding Balance" > 0 then begin

            Cust.Reset();
            Cust.SetRange("No.", Loan."Account No.");
            if Cust.Find('-') then begin

                CrbData.Init();
                CrbData."No." := RegisterMngt.InitNextIntEntryNoCRB();
                if Employer.get(Cust."Employer Code") then
                    CrbData."Employer Name" := Employer.Name;
                MyString := Cust.Name;

                String1 := Token(MyString, ' ');
                String2 := Token(MyString, ' ');
                String3 := Token(MyString, ' ');
                String4 := Token(MyString, ' ');
                String5 := Token(MyString, ' ');

                CrbData.Surname := String3;
                CrbData."Forename 1" := String3;
                CrbData."Forename 2" := String1;
                CrbData."Forename 3" := String3;
                CrbData."Name 2" := String1;
                CrbData."Name 3" := String2;
                DateFor := '0';
                if Cust."Date of Birth" <> 0D then begin
                    Day := Date2DMY(Cust."Date of Birth", 1);
                    Month := Date2DMY(Cust."Date of Birth", 2);
                    Year := Date2DMY(Cust."Date of Birth", 3);

                    if Month < 10 then
                        M := '0'
                    else
                        M := '';
                    if Day < 10 then
                        D := '0'
                    else
                        D := '';
                    DateFor := Format(Year) + m + Format(Month) + d + Format(Day);
                    CrbData."Date of Birth" := DateFor;
                    DateFor := '0';
                end;

                CrbData."Client Code" := Cust."No.";
                CrbData."Account Number" := Loan."No.";
                if Cust.Gender = Cust.Gender::Male then begin
                    CrbData.Gender := 'M';
                end else begin
                    CrbData.Gender := 'F';
                end;

                CrbData.Nationality := 'KE';
                if Cust."Marital Status" = Cust."Marital Status"::Married then
                    CrbData."Marital Status" := 'M' else
                    if
                 Cust."Marital Status" = Cust."Marital Status"::Single then
                        CrbData."Marital Status" := 'S' else
                        CrbData."Marital Status" := Format(Cust."Marital Status");
                CrbData."Primary Identification Number" := Cust."ID No.";
                CrbData."Primary Identification code" := '001';
                CrbData."Secondary Identification code" := '';
                CrbData."Secondary Identification" := Cust."Passport No.";
                CrbData."Mobile No" := Cust."Phone No.";
                CrbData."Work Telephone" := Cust."Office Telephone No.";
                CrbData."Postal Address 1" := Cust."Current Address";
                CrbData."Postal Address 2" := Cust."Current Address";
                CrbData."Postal Location Town" := Cust.City;
                CrbData."Postal Location Country" := Cust."Country/Region";
                CrbData."Post Code" := Cust."Post Code";
                CrbData."Physical Address 1" := Cust."Current Residence";
                CrbData."Physical Address 2" := Cust."Current Location";
                CrbData."Location Town" := Cust.Location;
                CrbData."Location Country" := Cust."Country/Region";
                CrbData."Date of Physical Address" := '';
                CrbData."Customer Work Email" := Cust."E-Mail";
                if Employer.Get(Cust."Employer Code") then
                    CrbData."Employer Name" := Employer.Name;
                CrbData."Employment Type" := '003';
                CrbData."Account Type" := 'S';

                if Loan."Last Pay Date" <> 0D then begin
                    Day := Date2DMY(Loan."Last Pay Date", 1);
                    Month := Date2DMY(Loan."Last Pay Date", 2);
                    Year := Date2DMY(Loan."Last Pay Date", 3);

                    if Month < 10 then
                        M := '0'
                    else
                        M := '';

                    if Day < 10 then
                        D := '0'
                    else
                        D := '';
                    DateFor := Format(Year) + m + Format(Month) + d + Format(Day);
                end
                else
                    DateFor := '0';
                CrbData."Installment Due Date" := DateFor;
                CrbData."No of Days in Arreas" := Loan."Days in Arrears";
                if CrbData."No of Days in Arreas" = 0 then
                    CrbData."No of Installment In" := 0 else
                    CrbData."No of Installment In" := Round(((CrbData."No of Days in Arreas") / 30), 1, '=');
                CrbData."Overdue Balance" := DelChr(format(Round(Loan."Outstanding Balance", 1, '=')) + '00', '=', ',');
                CrbData."Overdue Date" := DateFor;
                CrbData."Account Product Type" := 'H';
                if Cust."Registration Date" <> 0D then begin
                    Day := Date2DMY(Cust."Registration Date", 1);
                    Month := Date2DMY(Cust."Registration Date", 2);
                    Year := Date2DMY(Cust."Registration Date", 3);
                    if Month < 10 then
                        M := '0'
                    else
                        M := '';
                    if Day < 10 then
                        D := '0'
                    else
                        D := '';
                    DateFor := Format(Year) + m + Format(Month) + d + Format(Day);
                end
                else
                    DateFor := '0';
                CrbData."Date Account Opened" := DateFor;
                CrbData."Original Amount" := DELCHR(FORMAT(ROUND(Loan."Approved Amount", 1, '=')) + '00', '=', ',');
                CrbData."Currency of Facility" := 'KES';
                CrbData."Amount in Kenya shillings" := DELCHR(FORMAT(ROUND(Loan."Approved Amount", 1, '=')) + '00', '=', ',');
                CrbData."Current Balance" := DELCHR(FORMAT(ROUND(Loan."Outstanding Balance", 1, '=')) + '00', '=', ',');
                CrbData."Lenders Registered Name" := 'UNITED NATIONS DT SACCO';
                CrbData."Lenders Trading Name" := 'UNITED NATIONS DT SACCO';
                CrbData."Lenders Branch Name" := 'UNITED NATIONS DT SACCO';
                CrbData."Lenders Branch Code" := 'N062001';

                if Loan."Performance Indicator" = Loan."Performance Indicator"::Performing then
                    CrbData."Performing / NPL Indicator" := 'A';
                if Loan."Performance Indicator" = Loan."Performance Indicator"::Watch then
                    CrbData."Performing / NPL Indicator" := 'B';
                if Loan."Performance Indicator" = Loan."Performance Indicator"::Performing then
                    CrbData."Account Status" := 'F';
                if Loan."Performance Indicator" = Loan."Performance Indicator"::Watch then
                    CrbData."Account Status" := 'B';

                if Loan."Last Pay Date" <> 0D then begin
                    Day := Date2DMY(Loan."Last Pay Date", 1);
                    Month := Date2DMY(Loan."Last Pay Date", 2);
                    Year := Date2DMY(Loan."Last Pay Date", 3);
                    if Month < 10 then
                        M := '0'
                    else
                        M := '';

                    if Day < 10 then
                        D := '0'
                    else
                        D := '';
                    DateFor := Format(Year) + m + Format(Month) + d + Format(Day);
                end
                else
                    DateFor := '0';
                CrbData."Account Status Date" := DateFor;
                CrbData."Repayment Period" := Loan.Installments;
                CrbData."Payment Frequency" := 'M';

                if Loan."Disbursement Date" <> 0D then begin
                    Day := Date2DMY(Loan."Disbursement Date", 1);
                    Month := Date2DMY(Loan."Disbursement Date", 2);
                    Year := Date2DMY(Loan."Disbursement Date", 3);

                    if Month < 10 then
                        M := '0'
                    else
                        M := '';
                    if Day < 10 then
                        D := '0'
                    else
                        D := '';
                    DateFor := Format(Year) + M + Format(Month) + D + Format(Day);
                end
                else
                    DateFor := '0';
                CrbData."Disbursement Date" := DateFor;
                CrbData."Insallment Amount" := DelChr(Format(Round(Loan."Principle Repayment", 1, '=')) + '00', '=', ',');
                if Loan."Last Pay Date" <> 0D then begin
                    Day := Date2DMY(Loan."Last Pay Date", 1);
                    Month := Date2DMY(Loan."Last Pay Date", 2);
                    Year := Date2DMY(Loan."Last Pay Date", 3);

                    if Month < 10 then
                        M := '0'
                    else
                        M := '';

                    if Day < 10 then
                        D := '0'
                    ELSE
                        D := '';
                    DateFor := Format(Year) + M + Format(Month) + D + Format(Day);
                end
                else
                    DateFor := '0';
                CrbData."Date of Latest Payment" := DateFor;
                CredLedger.Reset();
                CredLedger.SetRange("Loan No.", Loan."No.");
                CredLedger.SetRange("Transaction Type", CredLedger."Transaction Type"::Repayment);
                if CredLedger.FindLast() then
                    CrbData."Last Payment Amount" := DelChr(Format(Round(CredLedger.Amount * -1, 1, '=')) + '00', '=', ',');
                CrbData."Type of Security" := 'S';
                CrbData.Insert(true);
            end;
        end;
    end;


}



