report 50323 "Membership Closure Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MembershipClosureReport.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Membership closure"; "Membership closure")
        {
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
            column(Posting_Date;"Posting Date")
            {}
            column(Account_Name; "Account Name")
            { }
            column(Account_Type; "Account Type")
            { }
            column(AccountNo; "Account No.")
            { }
            column(PayingAccountNo; "Paying Account No.")
            { }
            column(IntEarned; IntEarned)
            { }
            column(Cheque_No; "Rcv Cheque No")
            { }
            column(Deposit_Refundable; "Deposit Refundable")
            { }
            column(CommunicationOnline; CommunicationOnline)
            {
            }
            column(EFT_Options; "EFT Options")
            { }
            column(Pay_Mode; "Pay Mode")
            { }
            column(Paying_Account_No_; "Paying Account No.")
            { }
            column(Payment_Destination; "Payment Destination")
            { }
            column(Payment_Destination_Code; "Payment Destination Code")
            { }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(StaffNo; StaffNo)
            {
            }
            column(Notice_M__Date; "Notice M. Date")
            {
            }
            column(CustAddress; CustAddress)
            {
            }
            column(EmailAddress; CustEmail)
            {
            }
            column(CName; Company.Name)
            {
            }
            column(CAddress; Company.Address)
            {
            }
            column(CPicture; Company.Picture)
            {
            }
            column(No; "Membership closure"."No.")
            {
            }
            column(MemberNo; "Membership closure"."Member No.")
            {
            }
            column(MemberName; "Membership closure"."Member Name")
            {
            }
            column(ClosingDate; "Membership closure"."Closing Date")
            {
            }
            column(TotalLoan; "Membership closure"."Total Loan")
            {
            }
            column(TotalInterest; "Membership closure"."Total Interest")
            {
            }
            column(MemberSavings; "Membership closure"."Member Savings")
            {
            }
            column(ClosureType; "Membership closure"."Closure Type")
            {
            }
            column(RefundableDeposit; "Membership closure"."Deposit Refundable")
            {
            }
            dataitem("Account Closure Line"; "Account Closure Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = where("Product Class" = filter(Account));
                column(Account_No_; "Account No.")
                { }
                column(AcclosureNo_; "No.")
                { }
                column(Account_Category; "Account Category")
                { }
                column(Accrued_Interest; "Accrued Interest")
                { }
                column(Member_No_; "Member No.")
                { }
                column(Name; Name)
                { }
                column(Product_Type; "Product Type")
                { }
                column(Loan_No_; "Loan No.")
                { }
                column(OutBal; OutBal)
                { }
                column(Outstanding_Interest; "Outstanding Interest")
                { }
                column(Outstanding_Principal; "Outstanding Principal")
                { }
                column(Balance; Balance)
                { }
                column(Amount_to_Post; "Amount to Post")
                { }
                trigger OnAfterGetRecord()
                begin

                end;
            }
            dataitem(AccountClosureLine; "Account Closure Line")
            {
                DataItemTableView = where("Product Class" = filter(" "| Loan|charge));
                DataItemLink = "No." = FIELD("No.");
                column(LoanTAccount_No_; "Account No.")
                { }
                column(LoanTNo_; "No.")
                { }
                column(LoanTAccount_Category; "Account Category")
                { }
                column(LoanTAccrued_Interest; "Accrued Interest")
                { }
                column(LoanTMember_No_; "Member No.")
                { }
                column(LoanTName; Name)
                { }
                column(LoanTProduct_Type; "Product Type")
                { }
                column(LoanTLoan_No_; "Loan No.")
                { }
                column(LoanTOutBal; OutBal)
                { }
                column(LoanTOutstanding_Interest; "Outstanding Interest")
                { }
                column(LoanTOutstanding_Principal; "Outstanding Principal")
                { }
                column(LoanTBalance; Balance)
                { }
                column(LoanTAmount_to_Post; "Amount to Post")
                { }
                trigger OnAfterGetRecord()
                begin

                end;

            }

            trigger OnAfterGetRecord()
            begin
                IntEarned := 0;
                if CustMember.Get("Member No.") then
                    CustEmail := CustMember."E-Mail";
                ClosureLine.Reset();
                ClosureLine.SetRange("No.", "No.");
                ClosureLine.SetFilter("Account Category", '%1|%2|%3', ClosureLine."Account Category"::"Shares Capital",
                ClosureLine."Account Category"::"Shares Deposit", ClosureLine."Account Category"::"Specialty Savings");
                if ClosureLine.FindSet() then begin
                    ClosureLine.CalcSums("Accrued Interest");
                    IntEarned := ClosureLine."Accrued Interest";
                end;
            end;

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
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Company.Get;
        Company.CalcFields(Company.Picture);
    end;

    var
        Company: Record "Company Information";

    var
        BalanceBF: Decimal;
        CName: Text[150];
        AppAmount: Decimal;
        Disdate: Date;
        OutBal: Decimal;
        CustMember: Record Member;
        IntEarned: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        ClosureLine: Record "Account Closure Line";
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[10];
        CustEmail: Code[100];
        CustAddress: Code[100];
}




