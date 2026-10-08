report 50311 "CashierCredit Deposit Slip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CashierCreditDepositSlip.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Transactions; "Teller Transaction")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(Transactions_Transactions__Book_Balance_; Transactions."Book Balance")
            {
            }
            column(ID_No; "ID No")
            {
            }
            column(Transactions_No; "No.")
            {
            }
            column(Account_No_; "Account No.")
            {

            }
            column(Account_Name; "Account Name")
            {

            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(Amount; Amount)
            {
            }
            column(PayrollNo; StaffNo)
            {
            }
            column(Prod_Name; ProductNames)
            {
            }
            column(BranchCode; Transactions."Global Dimension 2 Code")
            {
            }
            column(Transactions__Transaction_Date_; "Transaction Date")
            {
            }
            column(Transactions_Transactions__Transaction_Time_; Transactions."Transaction Time")
            {
            }
            column(Transactions__Cheque_No_; "Cheque No")
            {
            }
            column(Transactions_Type; Type)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(Company_Address; CompanyInfo.Address)
            {
            }
            column(Co_phone; CompanyInfo."Phone No.")
            {
            }
            column(Company_Pic; CompanyInfo.Picture)
            {
            }
            column(Transactions_Transactions_Cashier; Transactions.Cashier)
            {
            }
            column(Amount_WithdrawnCaption; Amount_WithdrawnCaptionLbl)
            {
            }
            column(Book_Balance_Caption; Book_Balance_CaptionLbl)
            {
            }
            column(Transaction_No_Caption; Transaction_No_CaptionLbl)
            {
            }
            column(Account_No_Caption; Account_No_CaptionLbl)
            {
            }
            column(Account_Name_Caption; Account_Name_CaptionLbl)
            {
            }
            column(Date_Caption; Date_CaptionLbl)
            {
            }
            column(Time_Caption; Time_CaptionLbl)
            {
            }
            column(Transactions__Cheque_No_Caption; FieldCaption("Cheque No"))
            {
            }
            column(Member_No_Caption; Member_No_CaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(Signature_Caption; Signature_CaptionLbl)
            {
            }
            column(I_acknowledge_receipt_of_the_above_amountCaption; I_acknowledge_receipt_of_the_above_amountCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000048; EmptyStringCaption_Control1000000048Lbl)
            {
            }
            column(I_D_No_Caption; I_D_No_CaptionLbl)
            {
            }
            column(Availbal; Available_Balance_CaptionLbl)
            {
            }
            column(BookBal_; Book_Balance_Caption_Control1102760006Lbl)
            {
            }
            column(EmptyStringCaption_Control1102756001; EmptyStringCaption_Control1102756001Lbl)
            {
            }
            column(al; Name_CaptionLbl)
            {
            }
            column(Withdrawn_By_______________________________________Caption; Withdrawn_By_______________________________________CaptionLbl)
            {
            }
            column(You_were_served_by__Caption; You_were_served_by__CaptionLbl)
            {
            }
            column(THANK_YOUCaption; THANK_YOUCaptionLbl)
            {
            }
            column(Better_life_for_our_members_globallyCaption; Better_life_for_our_members_globallyCaptionLbl)
            {
            }
            column(Transactions_Transaction_Type; "Transaction Type")
            {
            }
            column(ExpectedMaturityDate; "Expected Maturity Date")
            {
            }
            column(ChequeNo_Transactions; Transactions."Cheque No")
            {
            }
            column(TransactionDescription_Transactions; Transactions."Transaction Description")
            {
            }
            column(Cashier_Transactions; Transactions.Cashier)
            {
            }
            column(NumberText_1_; NumberText[1])
            {
            }
            column(NumberText; NumberText[1])
            {
            }
            column(SumTransactionCharges; SumTransactionCharges)
            {
            }
            column(AvailableBalance; "Available Balance")
            {
            }
            column(NewAvailable; "Available Balance" - (SumTransactionCharges + Amount))
            {
            }
            column(Dublicate; Transactions.Dublicate)
            {
            }
            column(CashierName; CashierName)
            {
            }
            dataitem("Transaction Charge"; "Transaction Charge")
            {
                DataItemLink = "Transaction Type" = FIELD("Transaction Type");
                column(Description; Description)
                {
                }
                column(ChAmount; ChAmount)
                {
                }
                column(Transaction_Charges_Transaction_Type; "Transaction Type")
                {
                }
                column(Transaction_Charges_Charge_Code; "Charge Code")
                {
                }
            }
            dataitem("Cashier Transaction Line"; "Cashier Transaction Line")
            {
                DataItemLink = "Transaction No." = FIELD("No.");
                column(CL_Account_no; "Cashier Transaction Line"."Account No.")
                {
                }
                column(CL_Loan_no; "Cashier Transaction Line"."Loan No.")
                {
                }
                column(CL_Amount; "Cashier Transaction Line".Amount)
                {
                }
                column(CL_TransType; "Cashier Transaction Line"."Transaction Type")
                {
                }
                column(CSName; CSName)
                {
                }
                column(ProductType_CashierTransactionLines; "Cashier Transaction Line"."Product Type")
                {
                }
                column(ProductNames; ProductNames)
                {

                }

                trigger OnAfterGetRecord()
                var
                    AccCred: Record "Account Credit";
                begin
                    if "Account Type"::Loan = "Account Type"::Loan then begin
                        CSName := '';
                        Credit.Reset;
                        Credit.SetRange(Credit."No.", "Cashier Transaction Line"."Account No.");
                        if Credit.Find('-') then begin
                            CSName := Credit."Product Name";
                        end;
                    end;
                    if "Account Type"::Saving = "Account Type"::Saving then begin
                        Savings.Reset;
                        Savings.SetRange("No.", "Cashier Transaction Line"."Account No.");
                        if Savings.Find('-') then begin
                            CSName := Savings."Product Name";
                        end;
                    end;
                    if "Account Type" = "Account Type"::Credit then begin
                        if AccCred.Get("Account No.") then
                            CSName := AccCred."Product Name";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                CheckReport: Report Check;
            begin
                StaffNo := '';
                ProductNames := '';
                CashierName := '';

                user.Reset;
                user.SetRange("User Name", UserId);
                if user.Find('-') then begin
                    CashierName := user."Full Name";
                end;

                SavingsLedgerEntry.Reset;
                SavingsLedgerEntry.SetRange("Customer No.", "Account No.");
                SavingsLedgerEntry.SetRange("Document No.", "No.");
                if SavingsLedgerEntry.FindSet then begin
                    SavingsLedgerEntry.CalcSums(Amount);
                    SumTransactionCharges := SavingsLedgerEntry.Amount - Amount;

                end;

                Savings.Reset;
                Savings.SetRange(Savings."No.", Transactions."Account No.");
                if Savings.Find('-') then begin
                    StaffNo := Savings."Staff/Payroll No.";
                    ProductNames := Savings."Product Name";
                end;
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, Amount, '');

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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

    var
        Amount_WithdrawnCaptionLbl: Label 'Amount Withdrawn';
        Book_Balance_CaptionLbl: Label 'Book Balance:';
        Transaction_No_CaptionLbl: Label 'Transaction No.';
        Account_No_CaptionLbl: Label 'Account No:';
        Account_Name_CaptionLbl: Label 'Account Name:';
        Date_CaptionLbl: Label 'Date:';
        Time_CaptionLbl: Label 'Time:';
        Member_No_CaptionLbl: Label 'Member No:';
        EmptyStringCaptionLbl: Label '..........................................................';
        Signature_CaptionLbl: Label 'Signature:';
        I_acknowledge_receipt_of_the_above_amountCaptionLbl: Label 'I acknowledge receipt of the above amount';
        EmptyStringCaption_Control1000000048Lbl: Label '..........................................................';
        I_D_No_CaptionLbl: Label 'I/D No.';
        Available_Balance_CaptionLbl: Label 'Available Balance:';
        Book_Balance_Caption_Control1102760006Lbl: Label 'Book Balance:';
        EmptyStringCaption_Control1102756001Lbl: Label '..........................................................';
        Name_CaptionLbl: Label 'Name:';
        Withdrawn_By_______________________________________CaptionLbl: Label 'Withdrawn By :.....................................';
        You_were_served_by__CaptionLbl: Label 'You were served by :';
        THANK_YOUCaptionLbl: Label 'THANK YOU';
        Better_life_for_our_members_globallyCaptionLbl: Label 'Better life for our members globally';
        CompanyInfo: Record "Company Information";
        NumberText: array[2] of Text[120];
        SumTransactionCharges: Decimal;
        ChAmount: Decimal;
        SavingsLedgerEntry: Record "Banking A/c Ledger Entry";
        Savings: Record "Account Banking";
        StaffNo: Code[20];
        ProductNames: Text[50];
        Credit: Record "Credit Account";
        CSName: Text[50];
        CashierName: Text;
        user: Record User;
        PLoan: Record Loans;
        CredAcc: Record "Account Credit";
}




