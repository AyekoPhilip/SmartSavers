report 50199 "Account Transfer"
{
    ApplicationArea = All;
    Caption = 'Account Transfer';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/AccountTransferReport.rdl';
    dataset
    {
        dataitem(AccountTransferHeader; "Account Transfer Header")
        {

            column(No; "No.")
            {
            }
            column(MemberNo; "Member No")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(TotalCredits; "Total Credits")
            {
            }
            column(TotalDebits; "Total Debits")
            {
            }
            column(TransactionDate; "Transaction Date")
            {
            }
            column(TransactionTime; "Transaction Time")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(TransferType; "Transfer Type")
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
            column(EndDate; EndDate)
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
            dataitem("Account Transfer Source"; "Account Transfer Source")
            {
                DataItemLink = "No." = field("No.");

                column(Account_Type; "Account Type")
                { }
                column(Account_No_; "Account No.")
                { }
                column(Account_Name; "Account Name")
                { }
                column(Product_Code; "Product Code")
                { }
                column(Product_Name; "Product Name")
                { }
                column(Transaction_Type; "Transaction Type")
                { }
                column(Loan_No_; "Loan No.")
                { }
                column(Amount; Amount)
                { }


            }
            dataitem("Account Transfer Destination"; "Account Transfer Destination")
            {
                DataItemLink = "No." = field("No.");
                column(DestAccount_Type; "Account Type")
                { }
                column(DestAccount_No_; "Account No.")
                { }
                column(DestAccount_Name; "Account Name")
                { }
                column(DestProduct_Code; "Product Code")
                { }
                column(DestProduct_Name; "Product Name")
                { }
                column(DestTransaction_Type; "Transaction Type")
                { }
                column(DestLoan_No_; "Loan No.")
                { }
                column(DestAmount; Amount)
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
               // CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                //CompanyInformation."Home Page";
                SavingsAccountName := '';
                BalanceBF := 0;
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;

            end;

            trigger OnAfterGetRecord()
            begin

                CalcFields("Total Credits", "Total Debits");
                if Member.Get("Member No") then
                    CustAddress := Member."Current Address";
                CustEmail := Member."E-Mail";
                SavingsAccountName := Member.Name;
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, ("Total Debits"), '');
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



