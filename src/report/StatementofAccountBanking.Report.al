report 50302 "Statement of Account Banking"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StatementofAccountBanking.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(AccountBanking; "Account Banking")
        {
            RequestFilterFields = "No.";
            column(MemberNo_AccountBanking; AccountBanking."Member No.")
            {
            }
            column(ProductType_AccountBanking; AccountBanking."Product Type")
            {
            }
            column(ProductName_AccountBanking; AccountBanking."Product Name")
            {
            }
            column(MobileNo_AccountBanking; AccountBanking."Mobile No.")
            {
            }
            column(No_AccountBanking; AccountBanking."No.")
            {
            }
            column(Name_AccountBanking; AccountBanking.Name)
            {
            }
            column(PhoneNo_AccountBanking; AccountBanking."Phone No.")
            {
            }
            column(GlobalDimension1Code_AccountBanking; AccountBanking."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_AccountBanking; AccountBanking."Global Dimension 2 Code")
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
            dataitem(BankingAcLedgerEntry; "Banking A/c Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                column(CustomerNo_BankingAcLedgerEntry; BankingAcLedgerEntry."Customer No.")
                {
                }
                column(PostingDate_BankingAcLedgerEntry; BankingAcLedgerEntry."Posting Date")
                {
                }
                column(DocumentType_BankingAcLedgerEntry; BankingAcLedgerEntry."Document Type")
                {
                }
                column(DocumentNo_BankingAcLedgerEntry; BankingAcLedgerEntry."Document No.")
                {
                }
                column(Description_BankingAcLedgerEntry; BankingAcLedgerEntry.Description)
                {
                }
                column(Amount_BankingAcLedgerEntry; BankingAcLedgerEntry.Amount)
                {
                }
                column(DebitAmount_BankingAcLedgerEntry; BankingAcLedgerEntry."Debit Amount")
                {
                }
                column(CreditAmount_BankingAcLedgerEntry; BankingAcLedgerEntry."Credit Amount")
                {
                }
                column(DebitAmountLCY_BankingAcLedgerEntry; BankingAcLedgerEntry."Debit Amount (LCY)")
                {
                }
                column(CreditAmountLCY_BankingAcLedgerEntry; BankingAcLedgerEntry."Credit Amount (LCY)")
                {
                }
                column(BalanceBF; BalanceBF)
                {
                }
                column(SavingsAccountRunBal; SavingsAccountRunBal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RunBalance += -BankingAcLedgerEntry."Amount (LCY)";
                    SavingsAccountRunBal := RunBalance + BalanceBF;
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

                RegMngt.RestrictedAccountMngt("No.", UserId);

                if ChargeStatement then begin
                    if NoOfPage <> 0 then begin
                        BnkProcMngt.ChargeAccountStatement("No.", ChargeStatement, NoOfPage);
                    end else begin
                        Error('Kindly Specify the No. of Pages');
                    end;
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
                field(ChargeStatement; ChargeStatement)
                {
                    Caption = 'Charge Statement';
                    ApplicationArea = All;
                }
                field(NoOfPage; NoOfPage)
                {
                    Caption = 'No of Pages';
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
        BalanceBF: Decimal;
        NoOfPage: Integer;
        RegMngt: Codeunit "Registry Mngt.";
        BnkProcMngt: Codeunit "Banking Procedure Mngt.";
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
        Account2: Record "Account Banking";
        Member: Record Member;
        StaffNo: Code[10];
        CustAddress: Code[100];
        EmailAddress: Code[100];
        ChargeStatement: Boolean;
}




