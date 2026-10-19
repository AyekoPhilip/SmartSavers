report 50200 "Standing Order Register"
{
    ApplicationArea = All;
    Caption = 'Standing Order Register';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StandingOrderRegister.rdl';
    dataset
    {
        dataitem(StandingOrderHeader; "Standing Order Header")
        {
            column(No; "No.")
            {
            }
            column(SourceAccountType; "Source Account Type")
            {
            }
            column(SourceAccountNo; "Source Account No.")
            {
            }
            column(StandingOrderType; "Standing Order Type")
            {
            }
            column(IncomeType; "Income Type")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(Balance; Balance)
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(EffectiveStartDate; "Effective/Start Date")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(IDNumber; "ID Number")
            {
            }
            column(Unsuccessfull; Unsuccessfull)
            {
            }
            column(Description; Description)
            {
            }
            column(ApplicationDate; "Application Date")
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
            column(StartDate; StartDate)
            {
            }

            column(StaffNo; StaffNo)
            {
            }
            column(CustAddress; CustAddress)
            {
            }
            column(SavingsAccountName; SavingsAccountName)
            { }
            column(CustEmail; CustEmail)
            { }
            column(NumberText; NumberText[1])
            { }
            dataitem("Standing Order Lines"; "Standing Order Lines")
            {
                column(Destination_Account_Type; "Destination Account Type")
                { }
                column(Destination_Account_No_; "Destination Account No.")
                { }
                column(Destination_Account_Name; "Destination Account Name")
                { }
                column(LineAmount; Amount)
                { }
                column(Loan_No_; "Loan No.")
                { }

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
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;

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
        BalanceBF: Decimal;
        CName: Text[150];
        CheckReport: Report Check;
        AppAmount: Decimal;
        Disdate: Date;
        OutBal: Decimal;
        SavingsAccountName: Text;
        Member: Record Member;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        NumberText: array[2] of Text[80];
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[10];
        CustAddress: Code[100];
        CustEmail: Code[100];
}



