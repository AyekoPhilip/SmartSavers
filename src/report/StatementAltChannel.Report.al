report 50276 "Statement -Alt. Channel"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DetailedStatementofAccount.rdl';
    Caption = 'Statement of Accounts';
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
            column(BankingAccount; BankingAccounts)
            {
            }
            column(CreditAccount; CredicAccounts)
            {
            }
            column(LoanAccount; LoanAccounts)
            {
            }
            dataitem(Banking; "Account Banking")
            {
                DataItemLink = "Member No." = FIELD("No.");
                column(No_Banking; Banking."No.")
                {
                }
                column(Name_Banking; Banking.Name)
                {
                }
                column(ProductType_Banking; Banking."Product Type")
                {
                }
                column(ProductName_Banking; Banking."Product Name")
                {
                }
                column(MemberNo_Banking; Banking."Member No.")
                {
                }
                dataitem(AccLedgerEntry; "Banking A/c Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                    column(DebitAmount_AccLedgerEntry; AccLedgerEntry."Debit Amount")
                    {
                    }
                    column(CreditAmount_AccLedgerEntry; AccLedgerEntry."Credit Amount")
                    {
                    }
                    column(DebitAmountLCY_AccLedgerEntry; AccLedgerEntry."Debit Amount (LCY)")
                    {
                    }
                    column(CreditAmountLCY_AccLedgerEntry; AccLedgerEntry."Credit Amount (LCY)")
                    {
                    }
                    column(CustomerNo_AccLedgerEntry; AccLedgerEntry."Customer No.")
                    {
                    }
                    column(PostingDate_AccLedgerEntry; AccLedgerEntry."Posting Date")
                    {
                    }
                    column(DocumentType_AccLedgerEntry; AccLedgerEntry."Document Type")
                    {
                    }
                    column(DocumentNo_AccLedgerEntry; AccLedgerEntry."Document No.")
                    {
                    }
                    column(Description_AccLedgerEntry; AccLedgerEntry.Description)
                    {
                    }
                    column(CurrencyCode_AccLedgerEntry; AccLedgerEntry."Currency Code.")
                    {
                    }
                    column(Amount_AccLedgerEntry; AccLedgerEntry.Amount)
                    {
                    }
                    column(BankingBalBF; BankingBalBF)
                    {
                    }
                    column(BankingRunBalance; BankingRunBalance)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BankingRunBalance += -AccLedgerEntry."Amount (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        BankingRunBalance := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        BankingBalBF := 0;
                        Account2 := Banking;
                        Account2.SetRange("Date Filter", 0D, StartDate - 1);
                        Account2.CalcFields("Balance (LCY)");
                        BankingBalBF := Account2."Balance (LCY)";
                        SetRange("Date Filter", StartDate, EndDate);
                        BankingRunBalance := BankingBalBF
                    end else begin
                        BankingRunBalance := 0;
                    end
                end;
            }
            dataitem(CreditAcc; "Account Credit")
            {
                DataItemLink = "Member No." = FIELD("No.");
                column(No_CreditAcc; CreditAcc."No.")
                {
                }
                column(Name_CreditAcc; CreditAcc.Name)
                {
                }
                column(ProductType_CreditAcc; CreditAcc."Product Type")
                {
                }
                column(ProductName_CreditAcc; CreditAcc."Product Name")
                {
                }
                dataitem(CreditAcLedgerEntry; "Credits A/c Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                    column(DebitAmount_CreditAcLedgerEntry; CreditAcLedgerEntry."Debit Amount")
                    {
                    }
                    column(CreditAmount_CreditAcLedgerEntry; CreditAcLedgerEntry."Credit Amount")
                    {
                    }
                    column(DebitAmountLCY_CreditAcLedgerEntry; CreditAcLedgerEntry."Debit Amount (LCY)")
                    {
                    }
                    column(CreditAmountLCY_CreditAcLedgerEntry; CreditAcLedgerEntry."Credit Amount (LCY)")
                    {
                    }
                    column(DocumentDate_CreditAcLedgerEntry; CreditAcLedgerEntry."Document Date")
                    {
                    }
                    column(ExternalDocumentNo_CreditAcLedgerEntry; CreditAcLedgerEntry."External Document No.")
                    {
                    }
                    column(CustomerNo_CreditAcLedgerEntry; CreditAcLedgerEntry."Customer No.")
                    {
                    }
                    column(PostingDate_CreditAcLedgerEntry; CreditAcLedgerEntry."Posting Date")
                    {
                    }
                    column(DocumentType_CreditAcLedgerEntry; CreditAcLedgerEntry."Document Type")
                    {
                    }
                    column(DocumentNo_CreditAcLedgerEntry; CreditAcLedgerEntry."Document No.")
                    {
                    }
                    column(Description_CreditAcLedgerEntry; CreditAcLedgerEntry.Description)
                    {
                    }
                    column(CurrencyCode_CreditAcLedgerEntry; CreditAcLedgerEntry."Currency Code.")
                    {
                    }
                    column(Amount_CreditAcLedgerEntry; CreditAcLedgerEntry.Amount)
                    {
                    }
                    column(CredAccBalBF; CredAccBalBF)
                    {
                    }
                    column(CredAccRunBalance; CredAccRunBalance)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CredAccRunBalance += -CreditAcLedgerEntry."Amount (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        CredAccRunBalance := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        CredAccBalBF := 0;
                        Account3 := CreditAcc;
                        Account3.SetRange("Date Filter", 0D, StartDate - 1);
                        Account3.CalcFields("Balance (LCY)");
                        CredAccBalBF := Account3."Balance (LCY)";
                        SetRange("Date Filter", StartDate, EndDate);
                        CredAccRunBalance := CredAccBalBF
                    end else begin
                        CredAccRunBalance := 0;
                    end
                end;
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
                    column(TransactionType_BankingAcLedgerEntry; "Transaction Type")
                    {
                    }
                    column(LoanNo_BankingAcLedgerEntry; "Loan No.")
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
                }
            }
            trigger OnAfterGetRecord()
            begin
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
                Gensetup.Get();
                Gensetup.TestField("Statement Frequency");

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
                StartDate := CalcDate('-3M', Today);
                EndDate := Today;
                BankingAccounts := true;
                CredicAccounts := true;
                LoanAccounts := true;

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
                group(Options)
                {
                    Caption = 'Options';
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
                group(Include)
                {
                    Caption = 'Include';
                    field(BankingAccounts; BankingAccounts)
                    {
                        Caption = 'Banking Account';
                        ApplicationArea = All;
                    }
                    field(CredicAccounts; CredicAccounts)
                    {
                        Caption = 'Credit Account';
                        ApplicationArea = All;
                    }
                    field(LoanAccounts; LoanAccounts)
                    {
                        Caption = 'Loan Account';
                        ApplicationArea = All;
                    }


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
        Account2: Record "Account Banking";
        Account3: Record "Account Credit";
        StaffNo: Code[10];
        CustAddress: Code[100];
        BankingBalBF: Decimal;
        BankingRunBalance: Decimal;
        CredAccBalBF: Decimal;
        CredAccRunBalance: Decimal;
        BankingAccounts: Boolean;
        CredicAccounts: Boolean;
        LoanAccounts: Boolean;
        AccBanking: Record "Account Banking";
        ChargeStatement: Boolean;
        NoOfPage: Integer;
        Gensetup: Record "General Set-Up";
        RegMngt: Codeunit "Registry Mngt.";
        BnkProcMngt: Codeunit "Banking Procedure Mngt.";

    procedure GetDefaults(var FromDate: Date; var ToDate: Date)
    begin
        StartDate := FromDate;
        EndDate := ToDate;
        BankingAccounts := true;
        CredicAccounts := true;
        LoanAccounts := true;
    end;
}




