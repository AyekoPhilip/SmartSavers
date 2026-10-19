report 50398 "Risk Claim Form"
{
    ApplicationArea = All;
    Caption = 'Risk Claim Form';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/RiskClaimAnalysis.rdl';
    dataset
    {
        dataitem(MemberwithdrawalNotice; "Member withdrawal Notice")
        {
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
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MaturityDate; "Maturity Date")
            {
            }
            column(Reasonforwithdrawal; "Reason for withdrawal")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DescriptionForWithdrawal; "Description For Withdrawal")
            {
            }
            column(DateofDeath; "Date of Death")
            {
            }
            column(Email; Email)
            {
            }
            column(ClosureType; "Closure Type")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(TimeEntered; "Time Entered")
            {
            }
            column(TotalLiabilities; "Total Liabilities")
            {
            }
            column(TotalSavings; "Total Savings")
            {
            }
            column(WithdrawalNoticeDate; "Withdrawal Notice Date")
            {
            }
            column(DateEntered; "Date Entered")
            {
            }
            column(EnteredBy; "Entered By")
            {
            }
            dataitem(Loans; Loans)
            {
                DataItemLink = "Account No." = field("Member No.");
                DataItemTableView = where("Outstanding Balance" = filter(> 0));
                column(No_; "No.")
                { }
                column(Product_Description; "Product Description")
                { }
                column(Account_No_; "Account No.")
                { }
                column(Disbursement_Date; "Disbursement Date")
                { }
                column(Approved_Amount; "Approved Amount")
                { }
                column(Outstanding_Insurance; "Outstanding Insurance")
                { }
                column(Outstanding_Bill; "Outstanding Bill")
                { }
                column(Outstanding_Interest; "Outstanding Interest")
                { }
                column(Outstanding_Principal; "Outstanding Principal")
                { }
                column(Outstanding_Balance; "Outstanding Balance")
                { }
                column(AccreuedInt; AccreuedInt)
                { }
                column(SettlementFee; SettlementFee)
                { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin

                    AccreuedInt := 0;
                    SettlementFee := 0;
                    IntDays := 0;
                    DaysInMonths := 0;
                    MonthlyAccruedInt := 0;

                    TempFile.Reset();
                    TempFile.SetRange(Posted, false);
                    TempFile.SetRange("Loan No.", "No.");
                    TempFile.SetRange("Product Type", "Product Type");
                    if TempFile.FindFirst() then begin
                        SettlementFee := TempFile.Amount;
                    end;

                    StartDate := CalcDate('-CM', EndDate);
                    IntDays := (EndDate - StartDate) + 1;

                    FirstDate := StartDate;
                    LastDate := CalcDate('CM', Today);
                    DaysInMonths := (LastDate - FirstDate) + 1;
                    AccreuedInt := Round(PeriodAct.fnIntEntriesonSpecificLoan(Loans,
                    Today, "No.", 1, IntDays, StartDate), 0.05, '>');

                    MonthlyAccruedInt := Round(PeriodAct.fnIntEntriesonSpecificLoan(Loans,
                    Today, "No.", 1, DaysInMonths, FirstDate), 0.05, '>');

                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City;
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";

                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;

            end;

            trigger OnPostDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
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
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        ReversedEntry: Boolean;
        CommunicationOnline: Text;
        StartDate: Date;
        PLoan: Record "Loans Categorization";
        PLoan3: Record "Loans Categorization";
        EndDate: Date;
        MonthlyAccruedInt: Decimal;
        AccreuedInt: Decimal;
        SettlementFee: Decimal;
        TotSettlementFee: Decimal;
        IntDays: Decimal;
        FirstDate: Date;
        LastDate: Date;
        DaysInMonths: Integer;
        TempFile: Record "Temp. Files";
        PeriodAct: Codeunit "Periodic Activities Mgt.";
}
