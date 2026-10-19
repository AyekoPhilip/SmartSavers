report 50402 "Gen. Regulatory Form 3B"
{
    ApplicationArea = All;
    Caption = 'Gen. Regulatory Form 3B';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/GenForm3B.rdl';
    dataset
    {
        dataitem(TempFormData; "Temp. Form Data")
        {
            column(EntryNo; "Entry No.")
            { }
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(SharesCapital; "Shares Capital")
            { }
            column(SharesDeposits; "Shares Deposits")
            { }
            column(SpecialitySavings; "Speciality Savings")
            { }
            column(JuniorSavings; "Junior Savings")
            { }
            column(FixedDeposits; "Fixed Deposits")
            { }
            column(Loans; Loans)
            { }
            column(TransactionType; "Transaction Type")
            { }
            column(Total_Savings; "Total Savings")
            { }
            column(ValuePost; ValuePost)
            { }

            trigger OnPreDataItem()
            begin
                TempFormData.DeleteAll();

                case OptionTxt of
                    OptionTxt::Top:
                        TrajectoryTxt := false;
                    else
                        TrajectoryTxt := true;

                end;
                Minicount[1] := 0;
                Minicount[2] := 0;

                case OptionDirection of
                    OptionDirection::" ":
                        begin

                            TempData.Reset();
                            TempData.SetCurrentKey("Total Savings");
                            TempData.Ascending(TrajectoryTxt);
                            TempData.SetRange("Global Dimension 1 Code", 'CREDIT');
                            TempData.SetFilter("Total Savings", '<>0');
                            if TempData.FindSet() then begin
                                repeat
                                    Minicount[1] := Minicount[1] + 1;

                                    TempForm3.Init();
                                    TempForm3."Entry No." := RegMngt.InitNextFormEntryNo();
                                    TempForm3."No." := TempData."No.";
                                    TempForm3.Name := TempData.Name;
                                    TempForm3."Transaction Type" := CredAc."Account Category";
                                    TempForm3."Shares Deposits" := TempData."Shares Deposit";
                                    TempForm3."Shares Capital" := TempData."Shares Capital";
                                    TempForm3."Speciality Savings" := TempData."Specialty Savings";
                                    TempForm3."Total Savings" := TempData."Total Savings";
                                    TempForm3."Transaction Type" := TempForm3."Transaction Type"::"Shares Deposit";
                                    if TempData."Total Savings" <> 0 then
                                        TempForm3.Insert(true);

                                    if Minicount[1] >= ValuePost then exit
                                until TempData.Next() = 0;
                            end;

                            TempData.Reset();
                            TempData.SetCurrentKey("Loan Balance");
                            TempData.Ascending(TrajectoryTxt);
                            TempData.SetFilter("Loan Balance", '<>0');
                            TempData.SetRange("Global Dimension 1 Code", 'CREDIT');
                            if TempData.FindSet() then begin
                                repeat
                                    Minicount[2] := Minicount[2] + 1;

                                    TempForm3.Init();
                                    TempForm3."Entry No." := RegMngt.InitNextFormEntryNo();
                                    TempForm3."No." := TempData."No.";
                                    TempForm3.Name := TempData.Name;
                                    TempForm3."Transaction Type" := CredAc."Account Category";
                                    TempForm3."Shares Deposits" := TempData."Shares Deposit";
                                    TempForm3."Shares Capital" := TempData."Shares Capital";
                                    TempForm3."Speciality Savings" := TempData."Specialty Savings";
                                    TempForm3.Loans := TempData."Loan Balance";
                                    TempForm3."Transaction Type" := TempForm3."Transaction Type"::" ";
                                    if TempData."Loan Balance" <> 0 then
                                        TempForm3.Insert(true);

                                    if Minicount[2] >= ValuePost then exit
                                until TempData.Next() = 0;

                            end;

                        end;
                    OptionDirection::Loans:
                        begin
                            TempData.Reset();
                            TempData.SetCurrentKey("Loan Balance");
                            TempData.Ascending(TrajectoryTxt);
                            TempData.SetRange("Global Dimension 1 Code", 'CREDIT');
                            if TempData.FindSet() then begin
                                repeat
                                    Minicount[2] := Minicount[2] + 1;

                                    TempForm3.Init();
                                    TempForm3."Entry No." := RegMngt.InitNextFormEntryNo();
                                    TempForm3."No." := TempData."No.";
                                    TempForm3.Name := TempData.Name;
                                    TempForm3."Transaction Type" := CredAc."Account Category";
                                    TempForm3."Shares Deposits" := TempData."Shares Deposit";
                                    TempForm3."Shares Capital" := TempData."Shares Capital";
                                    TempForm3."Speciality Savings" := TempData."Specialty Savings";
                                    TempForm3.Loans := TempData."Loan Balance";
                                    TempForm3."Transaction Type" := TempForm3."Transaction Type"::" ";
                                    if TempData."Loan Balance" <> 0 then
                                        TempForm3.Insert(true);

                                    if Minicount[2] >= ValuePost then exit
                                until TempData.Next() = 0;
                            end;
                        end;
                    OptionDirection::Savings:
                        begin
                            TempData.Reset();
                            TempData.SetCurrentKey("Total Savings");
                            TempData.Ascending(TrajectoryTxt);
                            TempData.SetRange("Global Dimension 1 Code", 'CREDIT');
                            if TempData.FindSet() then begin
                                repeat
                                    Minicount[1] := Minicount[1] + 1;

                                    TempForm3.Init();
                                    TempForm3."Entry No." := RegMngt.InitNextFormEntryNo();
                                    TempForm3."No." := TempData."No.";
                                    TempForm3.Name := TempData.Name;
                                    TempForm3."Transaction Type" := CredAc."Account Category";
                                    TempForm3."Shares Deposits" := TempData."Shares Deposit";
                                    TempForm3."Shares Capital" := TempData."Shares Capital";
                                    TempForm3."Speciality Savings" := TempData."Specialty Savings";
                                    TempForm3."Total Savings" := TempData."Total Savings";
                                    TempForm3."Transaction Type" := TempForm3."Transaction Type"::"Shares Deposit";
                                    if TempData."Total Savings" <> 0 then
                                        TempForm3.Insert(true);

                                    if Minicount[1] >= ValuePost then exit
                                until TempData.Next() = 0;
                            end;

                        end;

                end;
            end;

            trigger OnAfterGetRecord()
            begin

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
                    field(TrajectoryTxt; OptionTxt)
                    {
                        Caption = 'Option';
                        ApplicationArea = All;
                    }
                    field(OptionDirection; OptionDirection)
                    {
                        Caption = 'Direction';
                        ApplicationArea = All;

                    }
                    field(ValuePost; ValuePost)
                    {
                        Caption = 'No. Of Count';
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
        TempData: Record "Member Account (All)";
        TempData1: Record "Member Account (All)";
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
        Minicount: array[3] of Integer;
        RegMngt: Codeunit "Register Management";
        TrajectoryTxt: Boolean;
        OptionTxt: Option " ",Top,Bottom;
        OptionDirection: Option " ",Savings,Loans;

}
