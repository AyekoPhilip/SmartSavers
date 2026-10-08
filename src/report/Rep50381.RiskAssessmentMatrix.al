report 50381 "Risk Assessment Matrix"
{
    ApplicationArea = All;
    Caption = 'Risk Assessment Matrix';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/RiskAssessmentMatrix.rdl';
    dataset
    {
        dataitem(Member; "Member Application")
        {
            RequestFilterFields = "No.", "Employer Code", "Station/Department";
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(PayrollStaffNo; "Payroll No.")
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
            column(Plot_Bldg_Street_Road; "Plot/Bldg/Street/Road")
            { }
            column(ID_No_; "ID No.")
            { }
            column(NationalityTxt; NationalityTxt)
            { }
            column(CustName; CustName)
            { }
            column(RiskRating; RiskRating)
            { }
            column(Idemnity; Idemnity)
            { }
            dataitem("Risk Assessment Matrix"; "Risk Assessment Matrix")
            {
                DataItemLink = "Account No." = field("No.");
                column(Code; Code)
                { }
                column(Description; Description)
                { }
                column(Account_No_; "Account No.")
                { }
                column(Score; Score)
                { }
                column(Value; Value)
                { }
                trigger OnAfterGetRecord()
                begin


                end;

            }
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
                if StartDate = 0D then StartDate := 19800101D;
                if EndDate = 0D then EndDate := Today;

            end;

            trigger OnAfterGetRecord()
            begin

                CustName := '';
                NationalityTxt := '';
                if CustEployer.Get("Employer Code") then begin
                    CustName := CustEployer.Name;
                end;
                if CountryRegion.Get(Nationality) then
                    NationalityTxt := CountryRegion.Name;

                if Idemnity then begin
                    RiskRating := RiskRating::High
                end else begin

                    RiskAssessMatrix.Reset();
                    RiskAssessMatrix.SetRange("Account No.", "No.");
                    if RiskAssessMatrix.FindSet() then begin
                        repeat
                            if (RiskAssessMatrix.Code = '0001') or (RiskAssessMatrix.Code = '0002') then begin
                                if RiskAssessMatrix.Value then
                                    RiskRating := RiskRating::Medium else
                                    RiskRating := RiskRating::Low
                            end;
                        until RiskAssessMatrix.Next() = 0
                    end;
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
        RiskAssessMatrix: Record "Risk Assessment Matrix";
        CountryRegion: Record "Country/Region";
        NationalityTxt: Text[150];
        CustName: Text[150];
        CuttoffDate: Date;
        DateFilter: Text;
        LoanApp: Record Loans;
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
        FeedBackTxt: Text[20];
        EndDate: Date;
        RiskRating: Option " ",Low,Medium,High;
        RiskRate: Option " ",Low,Medium,High;
        StaffNo: Code[10];

}
