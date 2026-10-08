report 50281 "Gen. Remittance File"
{
    ApplicationArea = All;
    Caption = 'Gen. Remittance File';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/GenRemittanceFile.rdl';
    dataset
    {
        dataitem("Checkoff Header"; "Checkoff Header")
        {
            column(No_; "No.")
            {
            }
        }
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.", "Employer Code";
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Employer_Code; "Employer Code")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(CompInformation; CompanyInformation.Name)
            {
            }
            column(CompanyInformationPicture; CompanyInformation.Picture)
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
            column(SharesCapital; SharesCapital)
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
            trigger OnPreDataItem()
            begin
                if AdviceType = AdviceType::" " then
                    Error('Advice Type must have a value. It cannot be blank');

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
               // CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                //CompanyInformation."Home Page";
                SavingsAccountName := '';
                BalanceBF := 0;
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;

            end;

            trigger OnAfterGetRecord()
            begin
                DateFilter := Format(StartDate) + '..' + Format(EndDate);

                TotalLoans := 0;
                SharesCapital := 0;
                SharesDeposit := 0;
                AmountDeductable[1] := 0;
                AmountDeductable[2] := 0;
                AmountDeductable[3] := 0;
                AmountDeductable[4] := 0;

                AmountDeductable[5] := 0;
                AmountDeductable[6] := 0;
                AmountDeductable[7] := 0;

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Registration Fee");
                if MonthlyContrib.FindFirst() then begin
                    CredAcc.Reset();
                    CredAcc.SetRange("Member No.", "No.");
                    CredAcc.SetRange("Account Category", CredAcc."Account Category"::"Registration Fee");
                    if CredAcc.FindFirst() then
                        CredAcc.CalcFields("Balance (LCY)");
                    if CredAcc."Balance (LCY)" > 0 then
                        AmountDeductable[1] := 0 else
                        AmountDeductable[1] := MonthlyContrib.Amount
                end;

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Capital");
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            SharesCapital := MonthlyContrib.Amount else
                                                                       SharesCapital := (MonthlyContrib.Amount / 2);
                    end
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

                // Fosa Contrib
                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::Savings);
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            AmountDeductable[2] := MonthlyContrib.Amount else
                                                                             AmountDeductable[2] := (MonthlyContrib.Amount / 2)
                    end
                end;

                // Jipange
                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::Other);
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            AmountDeductable[3] := MonthlyContrib.Amount else
                                                                             AmountDeductable[3] := (MonthlyContrib.Amount / 2)
                    end
                end;

                /// Junior
                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::Junior);
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            AmountDeductable[4] := MonthlyContrib.Amount else
                                                                             AmountDeductable[4] := (MonthlyContrib.Amount / 2)
                    end
                end;

                /// Kin
                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::KinAccount);
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            AmountDeductable[5] := MonthlyContrib.Amount else
                                                                             AmountDeductable[5] := (MonthlyContrib.Amount / 2)
                    end
                end;

                /// Chama
                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", "No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Money Market");
                if MonthlyContrib.FindFirst() then begin
                    case AdviceType of
                        AdviceType::"Full Amount":
                            AmountDeductable[6] := MonthlyContrib.Amount else
                                                                             AmountDeductable[6] := (MonthlyContrib.Amount / 2)
                    end
                end;

                //Loans
                LoanApp.Reset();
                LoanApp.SetRange("Account No.", "No.");
                LoanApp.SetFilter("Outstanding Balance", '>0');
                LoanApp.SetFilter("Disbursement Date", DateFilter);
                if LoanApp.FindSet() then begin
                    LoanApp.CalcSums(Repayment);
                    ProdFact.Reset();
                    ProdFact.SetRange("Product ID", LoanApp."Product Type");
                    ProdFact.SetFilter("Loan Span", '<>%1 &<>%2', ProdFact."Loan Span"::"Mobile Loan", ProdFact."Loan Span"::Dividends);
                    if ProdFact.FindSet() then begin
                        if AdviceType = AdviceType::"Full Amount" then
                            TotalLoans := LoanApp.Repayment else
                            TotalLoans := (LoanApp.Repayment / 2);
                    end;
                end;

                AmountDeductable[7] := (SharesCapital + SharesDeposit + TotalLoans +
                AmountDeductable[1] + AmountDeductable[2] + AmountDeductable[3] +
                AmountDeductable[4] + AmountDeductable[5] + AmountDeductable[6]);
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
                        ApplicationArea = All;
                    }
                    field(CuttoffDate; EndDate)
                    {
                        Caption = 'CutOff Date';
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
        CuttoffDate: Date;
        DateFilter: Text;
        LoanApp: Record Loans;
        CredAcc: Record "Account Credit";
        AdviceType: Option " ","Full Amount","Half Amount";
        RegMngt: Codeunit "Register Management";
        SharesCapital: Decimal;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        MonthlyContrib: Record "Member Monthly Contribution";
        AmountDeductable: array[7] of Decimal;
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
        ProdFact: Record "Product Factory";
}




