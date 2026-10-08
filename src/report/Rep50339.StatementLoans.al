report 50339 "Statement-Loans"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StatementLoans.rdl';
    Caption = 'Statement of Account-Loan';
    ApplicationArea = All;

    dataset
    {
        dataitem(AccountBanking; Member)
        {
            RequestFilterFields = "No.";
            column(MemberNo_AccountBanking; AccountBanking."No.")
            {
            }
            column(ProductType_AccountBanking; AccountBanking."Employer Code")
            {
            }
            column(ProductName_AccountBanking; AccountBanking."E-Mail")
            {
            }
            column(MobileNo_AccountBanking; AccountBanking."Mobile Phone No")
            {
            }
            column(No_AccountBanking; "No.")
            {
            }
            column(Name_AccountBanking; Name)
            {
            }
            column(PhoneNo_AccountBanking; AccountBanking."Phone No.")
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
            column(EmailAddress; AccountBanking."E-Mail")
            {
            }
            dataitem(Loans; Loans)
            {
                DataItemLink = "Account No." = FIELD("No.");
                column(No_Loans; Loans."No.")
                {
                }
                column(ApplicationDate_Loans; Loans."Application Date")
                {
                }
                column(ProductType_Loans; Loans."Product Type")
                {
                }
                column(AccountNo_Loans; Loans."Account No.")
                {
                }
                column(RequestedAmount_Loans; Loans."Requested Amount")
                {
                }
                column(ApprovedAmount_Loans; Loans."Approved Amount")
                {
                }
                column(InterestRate_Loans; Loans."Interest Rate")
                {
                }
                column(AccountName_Loans; Loans."Account Name")
                {
                }
                column(ApprovalDate_Loans; Loans."Approval Date")
                {
                }
                column(Installments_Loans; Loans.Installments)
                {
                }
                column(DisbursementDate_Loans; Loans."Disbursement Date")
                {
                }
                column(ExpectedDateofCompletion_Loans; Loans."Expected Date of Completion")
                {
                }
                dataitem(BankingAcLedgerEntry; "Loan Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("Loan Account"), "Loan No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                    DataItemTableView = WHERE("Transaction Type" = FILTER(Loan | Repayment));
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
                    trigger OnPreDataItem()
                    begin
                        RunBalance := 0;
                        SavingsAccountRunBal := 0;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        RunBalance += BankingAcLedgerEntry."Amount (LCY)";
                        SavingsAccountRunBal := RunBalance;
                    end;
                }
                dataitem(LoanLedgerEntry; "Loan Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("Loan Account"), "Loan No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                    DataItemTableView = WHERE("Transaction Type" = FILTER("Interest Due" | "Interest Paid"));
                    column(LoanNo_LoanLedgerEntry; LoanLedgerEntry."Loan No.")
                    {
                    }
                    column(TransactionType_LoanLedgerEntry; LoanLedgerEntry."Transaction Type")
                    {
                    }
                    column(DebitAmount_LoanLedgerEntry; LoanLedgerEntry."Debit Amount")
                    {
                    }
                    column(CreditAmount_LoanLedgerEntry; LoanLedgerEntry."Credit Amount")
                    {
                    }
                    column(DebitAmountLCY_LoanLedgerEntry; LoanLedgerEntry."Debit Amount (LCY)")
                    {
                    }
                    column(CreditAmountLCY_LoanLedgerEntry; LoanLedgerEntry."Credit Amount (LCY)")
                    {
                    }
                    column(CustomerNo_LoanLedgerEntry; LoanLedgerEntry."Customer No.")
                    {
                    }
                    column(PostingDate_LoanLedgerEntry; LoanLedgerEntry."Posting Date")
                    {
                    }
                    column(DocumentType_LoanLedgerEntry; LoanLedgerEntry."Document Type")
                    {
                    }
                    column(DocumentNo_LoanLedgerEntry; LoanLedgerEntry."Document No.")
                    {
                    }
                    column(Description_LoanLedgerEntry; LoanLedgerEntry.Description)
                    {
                    }
                    column(CurrencyCode_LoanLedgerEntry; LoanLedgerEntry."Currency Code")
                    {
                    }
                    column(Amount_LoanLedgerEntry; LoanLedgerEntry.Amount)
                    {
                    }
                    column(RunBalInt; RunBalInt)
                    { }
                }
            }

            trigger OnAfterGetRecord()
            begin
                // AccountBal:=0;
                // Account2 :=AccountBanking;
                // Account2.SETRANGE("Date Filter",0D,StartDate -1);
                // Account2.CALCFIELDS("Balance (LCY)");
                // BalanceBF:=Account2."Balance (LCY)";
                //SETRANGE("Date Filter",StartDate,EndDate);
                RunBalInt += LoanLedgerEntry."Amount (LCY)";

                AccBanking.Reset();
                AccBanking.SetRange("Member No.", "No.");
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then begin

                    RegMngt.RestrictedAccountMngt(AccBanking."No.", UserId);

                    if ChargeStatement then begin
                        if NoOfPage <> 0 then begin
                            BnkProcMngt.ChargeAccountStatement("No.", ChargeStatement, NoOfPage);
                        end else begin
                            Error('Kindly Specify the No. of Pages');
                        end;
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

    var
        BalanceBF: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        RunBalInt: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[10];
        CustAddress: Code[100];
        AccBanking: Record "Account Banking";

        ChargeStatement: Boolean;
        NoOfPage: Integer;
        RegMngt: Codeunit "Registry Mngt.";
        BnkProcMngt: Codeunit "Banking Procedure Mngt.";
}




