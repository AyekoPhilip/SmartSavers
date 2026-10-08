report 50303 "Statement of Account-Loan A/c"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StatementofAccountLoanAc.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(AccountBanking; "Credit Account")
        {
            RequestFilterFields = "No.";
            column(MemberNo_AccountBanking; "Member No.")
            {
            }
            column(ProductType_AccountBanking; "Product Type")
            {
            }
            column(ProductName_AccountBanking; "Product Name")
            {
            }
            column(MobileNo_AccountBanking; "Employer Code")
            {
            }
            column(No_AccountBanking; "No.")
            {
            }
            column(Name_AccountBanking; Name)
            {
            }
            column(PhoneNo_AccountBanking; AccountBanking."Employer Code")
            {
            }
            column(GlobalDimension1Code_AccountBanking; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_AccountBanking; "Global Dimension 2 Code")
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
            column(EmailAddress; EmailAddress)
            {
            }
            dataitem(BankingAcLedgerEntry; "Loan Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                column(CustomerNo_BankingAcLedgerEntry; "Customer No.")
                {
                }
                column(PostingDate_BankingAcLedgerEntry; "Posting Date")
                {
                }
                column(DocumentType_BankingAcLedgerEntry; "Document Type")
                {
                }
                column(DocumentNo_BankingAcLedgerEntry; "Document No.")
                {
                }
                column(Description_BankingAcLedgerEntry; Description)
                {
                }
                column(Amount_BankingAcLedgerEntry; Amount)
                {
                }
                column(DebitAmount_BankingAcLedgerEntry; "Debit Amount")
                {
                }
                column(CreditAmount_BankingAcLedgerEntry; "Credit Amount")
                {
                }
                column(DebitAmountLCY_BankingAcLedgerEntry; "Debit Amount (LCY)")
                {
                }
                column(CreditAmountLCY_BankingAcLedgerEntry; "Credit Amount (LCY)")
                {
                }
                column(BalanceBF; BalanceBF)
                {
                }
                column(SavingsAccountRunBal; SavingsAccountRunBal)
                {
                }
                column(TransactionType_BankingAcLedgerEntry; BankingAcLedgerEntry."Transaction Type")
                {
                }
                column(LoanNo_BankingAcLedgerEntry; BankingAcLedgerEntry."Loan No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RunBalance += BankingAcLedgerEntry."Amount (LCY)";
                    SavingsAccountRunBal := RunBalance;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                AccountBal := 0;
                Account2 := AccountBanking;
                Account2.SetRange("Date Filter", 0D, StartDate - 1);
                Account2.CalcFields("Balance (LCY)");
                BalanceBF := Account2."Balance (LCY)";

                SetRange("Date Filter", StartDate, EndDate);

                if Member.Get("Member No.") then
                    StaffNo := Member."Payroll/Staff No.";
                CustAddress := Member."Current Address";
                EmailAddress := Member."E-Mail";
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
            area(content)
            {
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';
                    ApplicationArea = All;
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BalanceBF: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        AccountBal: Decimal;
        Account2: Record "Credit Account";
        Member: Record Member;
        StaffNo: Code[10];
        CustAddress: Code[100];
        EmailAddress: Code[100];
}




