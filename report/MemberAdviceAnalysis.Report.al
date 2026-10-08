report 50206 "Member Advice Analysis"
{
    ApplicationArea = All;
    Caption = 'Member Advice Analysis';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    ProcessingOnly = true;
    RDLCLayout = './src/report_layout/MemberAdviseAnalysis.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            DataItemTableView = where(Status = filter(Active | New | Dormant | Defaulter | Withdrawn));
            RequestFilterFields = "No.", "Employer Code", "Station/Department", "Member Category";
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(PayrollStaffNo; "Payroll/Staff No.")
            { }
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(SharesCapital; SharesCapital)
            { }
            column(IdentityType; IdentityType)
            { }
            column(StartDate; StartDate)
            { }
            column(EndDate; EndDate)
            { }
            column(MonthName; MonthName)
            { }
            column(Employer_Code; "Employer Code")
            { }
            column(YearInt; YearInt)
            { }
            column(SharesDeposit; SharesDeposit)
            { }
            column(TotalLoans; TotalLoans)
            { }
            column(RegFees; AmountDeductable[1])
            { }
            column(FosaContrib; AmountDeductable[2])
            { }
            column(Jipange; AmountDeductable[3])
            { }
            column(Junior; AmountDeductable[4])
            { }
            column(KinAccount; AmountDeductable[5])
            { }
            column(ChamaContrib; AmountDeductable[6])
            { }
            column(TotalAmountDeductable; AmountDeductable[7])
            { }
            column(CustName; CustName)
            { }
            trigger OnPreDataItem()
            begin

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
                SavingsAccountName := '';
                BalanceBF := 0;
                if StartDate = 0D then Error('Start Date must have a Date. It cannot be null');
                if EndDate = 0D then Error('End Date must have a Date. It cannot be null');
                AdviseAnalysis.DeleteAll();

            end;

            trigger OnAfterGetRecord()
            begin
                DFilter := '';
                DateFilter := '';
                MonthName := '';
                YearInt := 0;
                DateFilter := Format(StartDate) + '..' + Format(EndDate);
                DFilter := '..' + Format(EndDate);
                IdentityType := IdentityType::"Change (Increase/Decrease)";
                AdviceType := AdviceType::"Full Amount";
                MonthName := FORMAT(EndDate, 0, '<Month Text>');
                YearInt := Date2DMY(EndDate, 3);

                TotalLoans := 0;
                SharesCapital := 0;
                SharesDeposit := 0;
                AmountDeductable[1] := 0;

                CustName := '';
                if CustEployer.Get("Employer Code") then begin
                    CustName := CustEployer.Name;
                end;

                if ("Registration Date" >= StartDate) and ("Registration Date" <= EndDate) then begin
                    if Rejoined then
                        IdentityType := IdentityType::Rejoining else
                        IdentityType := IdentityType::"New member";
                end;

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Registration Fee");
                if MonthlyContrib.FindFirst() then begin
                    CredAcc.Reset();
                    CredAcc.SetRange("Member No.", "No.");
                    CredAcc.SetRange("Account Category", CredAcc."Account Category"::"Registration Fee");
                    if CredAcc.FindFirst() then
                        CredAcc.CalcFields("Balance (LCY)");
                    if ProdFact.Get(CredAcc."Product Type") then begin
                        if CredAcc."Balance (LCY)" < ProdFact."Minimum Balance" then
                            AmountDeductable[1] := MonthlyContrib.Amount else
                            AmountDeductable[1] := 0;

                    end;
                end;

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Capital");
                if MonthlyContrib.FindFirst() then begin
                    CredAcc.Reset();
                    CredAcc.SetRange("Member No.", "No.");
                    CredAcc.SetRange("Account Category", CredAcc."Account Category"::"Shares Capital");
                    if CredAcc.FindFirst() then
                        CredAcc.CalcFields("Balance (LCY)");
                    if ProdFact.Get(CredAcc."Product Type") then begin
                        if CredAcc."Balance (LCY)" < ProdFact."Minimum Balance" then
                            SharesCapital := MonthlyContrib.Amount else
                            SharesCapital := 0;

                    end;
                end;

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Deposit");
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            SharesDeposit := MonthlyContrib.Amount else
                                                                       SharesDeposit := (MonthlyContrib.Amount / 2);
                    end;
                end;

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Specialty Savings");
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            AmountDeductable[2] := MonthlyContrib.Amount else
                                                                             AmountDeductable[2] := (MonthlyContrib.Amount / 2)
                    end
                end;

                /* Loans */
                LoanApp.Reset();
                LoanApp.SetRange("Account No.", "No.");
                LoanApp.SetFilter("Outstanding Balance", '>0');
                LoanApp.SetFilter("Disbursement Date", DFilter);
                if LoanApp.FindSet() then begin
                    LoanApp.CalcSums(Repayment);
                    if AdviceType = AdviceType::"Full Amount" then
                        TotalLoans := LoanApp.Repayment else
                        TotalLoans := (LoanApp.Repayment / 2);
                end;

                if Status = Status::Withdrawn then begin
                    if "Withdrawal Date" <> 0D then begin
                        if "Withdrawal Date" < StartDate then CurrReport.Skip();
                    end;
                    if ("Withdrawal Date" >= StartDate) and ("Withdrawal Date" <= EndDate) then begin
                        AmountDeductable[1] := 0;
                        SharesCapital := 0;
                        SharesDeposit := 0;
                        TotalLoans := 0;
                        IdentityType := IdentityType::Withdrawal
                    end;
                end;

                AmountDeductable[7] := (TotalLoans + SharesCapital + SharesDeposit + AmountDeductable[1] + AmountDeductable[2]);
                RegisterMngt.PostAdviseAnalysis("No.", AmountDeductable[1], SharesCapital, SharesDeposit,
                AmountDeductable[2], TotalLoans, IdentityType, StartDate, EndDate, AmountDeductable[7], "Employer Code");

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
                    field(AdviceType; AdviceType)
                    {
                        Caption = 'Advice Type';
                        Editable = false;
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(CuttoffDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;

                    }
                    field(EmployerCode; EmployerCode)
                    {
                        Caption = 'Employer Code';
                        TableRelation = Customer where("Account Type" = const(Employer));
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
        BankingAcc: Record "Account Banking";
        CustEployer: Record Customer;
        CustName: Text[150];
        CuttoffDate: Date;
        AdviseAnalysis: Record "Member Advice Analysis";
        RegisterMngt: Codeunit "Register Management";
        DateFilter: Text;
        DFilter: Text[50];
        LoanApp: Record Loans;
        MonthName: Text[30];
        YearInt: Integer;
        CredAcc: Record "Account Credit";
        ProdFact: Record "Product Factory";
        AdviceType: Option " ","Full Amount","Half Amount";
        RegMngt: Codeunit "Register Management";
        SharesCapital: Decimal;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        MonthlyContrib: Record "Member Monthly Contribution";
        AmountDeductable: array[12] of Decimal;
        CustEmail: Text[150];
        CustomerRec: Record Member;
        BalanceBF: Decimal;
        CName: Text[150];
        AppAmount: Decimal;
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
        StaffNo: Code[10];
        AccountClosure: Record "Membership closure";
        IdentityType: Enum AdviseType;
        EmployerCode: Code[10];
}



