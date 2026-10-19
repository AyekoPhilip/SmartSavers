report 50401 "Sacco Regulatory (Form 3B)"
{
    ApplicationArea = All;
    Caption = 'Sacco Regulatory (Form 3B)';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    RDLCLayout = './src/report_layout/Form3B.rdl';
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(TempFormData; "Member Account (All)")
        {

            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(SharesCapital; "Shares Capital")
            { }
            column(Shares_Deposit; "Shares Deposit")
            { }
            column(Total_Savings; "Total Savings")
            { }
            column(JuniorSavings; "Junior Savings")
            { }
            column(Loan_Balance; "Loan Balance")
            { }
            trigger OnPreDataItem()
            begin

                CustRecordTemp.DeleteAll();
                getAllMemberAccount();

                if StartDate = 0D then StartDate := 20230101D;
                if EndDate = 0D then EndDate := Today;

            end;

            trigger OnAfterGetRecord()
            begin
                TotLoan := 0;
                TotSavings := 0;
                DateFilter := '';

                DateFilter := Format(StartDate) + '..' + Format(EndDate);

                CredAc.Reset();
                CredAc.SetRange("Member No.", "No.");
                CredAc.SetFilter("Date Filter", DateFilter);
                if CredAc.FindSet() then begin
                    repeat
                        CredAc.CalcFields("Balance (LCY)");
                        case CredAc."Account Category" of
                            CredAc."Account Category"::"Shares Deposit":
                                begin
                                    "Shares Deposit" := CredAc."Balance (LCY)";

                                end;
                            CredAc."Account Category"::"Shares Capital":
                                begin
                                    "Shares Capital" := CredAc."Balance (LCY)";
                                end;
                        end;

                    until CredAc.Next() = 0;
                end;
                AccBanking.Reset();
                AccBanking.SetRange("Member No.", "No.");
                AccBanking.SetFilter("Date Filter", DateFilter);
                if AccBanking.FindSet() then begin
                    repeat
                        AccBanking.CalcFields("Balance (LCY)");

                        case AccBanking."Account Category" of
                            AccBanking."Account Category"::"Specialty Savings":
                                begin
                                    "Specialty Savings" := AccBanking."Balance (LCY)"

                                end;

                        end;
                    until AccBanking.Next() = 0;
                end;

                CredAc.Reset();
                CredAc.SetRange("Member No.", "No.");
                CredAc.SetFilter("Date Filter", DateFilter);
                CredAc.SetFilter("Account Category", '%1 | %2', CredAc."Account Category"::"Shares Capital",
                CredAc."Account Category"::"Shares Deposit");
                if CredAc.FindSet() then begin
                    repeat
                        CredAc.CalcFields("Balance (LCY)");
                        TotSavings := (TotSavings + CredAc."Balance (LCY)");
                    until CredAc.Next() = 0;
                end;

                "Total Savings" := (TotSavings + "Specialty Savings");

                Loan.Reset();
                Loan.SetRange("Account No.", "No.");
                Loan.SetFilter("Date Filter", DateFilter);
                if Loan.FindSet() then begin
                    repeat
                        Loan.CalcFields("Outstanding Balance");
                        TotLoan := TotLoan + Loan."Outstanding Balance";
                    until Loan.Next() = 0;
                end;
                "Loan Balance" := TotLoan;
                Modify(true);

                if (TotSavings = 0) and (TotLoan = 0) then
                    Delete();

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
    trigger OnInitReport()
    begin


    end;

    trigger OnPreReport()
    begin


    end;

    trigger OnPostReport()
    begin


    end;

    var
        RegistryMngt: Codeunit "Registry Mngt.";
        AccBanking: Record "Account Banking";
        CredAc: Record "Account Credit";
        TempCred: Record "Account (Member)";
        TempData: Record "Temp. Form Data";
        TempForm3: Record "Temp. Form Data";
        ValuePost: Integer;
        DateFilter: Text[100];
        TotLoan: Decimal;
        TotSavings: Decimal;
        LoanEntry: Record "Loans Categorization";
        MembCategory: Record "Member Category";
        Loan: Record Loans;
        Custrecord: Record Member;
        CustRecordTemp: Record "Member Account (All)";
        StartDate: Date;
        EndDate: Date;
        LoanAcc: Record "Credit Account";
        Minicount: Integer;
        RegMngt: Codeunit "Register Management";
        TrajectoryTxt: Boolean;
        OptionTxt: Option " ",Top,Bottom;

    local procedure getAllMemberAccount()
    begin
        Custrecord.Reset();
        Custrecord.SetRange("Global Dimension 1 Code", 'CREDIT');
        if Custrecord.FindSet() then begin
            repeat

                CustRecordTemp.Init();
                CustRecordTemp."No." := Custrecord."No.";
                CustRecordTemp.Name := Custrecord.Name;
                CustRecordTemp.Status := Custrecord.Status;
                CustRecordTemp.Gender := Custrecord.Gender;
                CustRecordTemp."Station/Department" := Custrecord."Station/Department";
                CustRecordTemp."Old Member No." := Custrecord."Old Member No.";
                CustRecordTemp."Date of Birth" := Custrecord."Date of Birth";
                CustRecordTemp."Employer Code" := Custrecord."Employer Code";
                CustRecordTemp."Registration Date" := Custrecord."Registration Date";
                CustRecordTemp."Member Category" := Custrecord."Member Category";
                CustRecordTemp."Global Dimension 1 Code" := Custrecord."Global Dimension 1 Code";
                CustRecordTemp."Payroll/Staff No." := Custrecord."Payroll/Staff No.";
                CustRecordTemp."ID No." := Custrecord."ID No.";
                CustRecordTemp.Insert(true)

            until Custrecord.Next() = 0
        end;

    end;
}

