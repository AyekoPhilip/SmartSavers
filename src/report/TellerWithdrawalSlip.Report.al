report 50306 "Teller Withdrawal Slip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/TellerWithdrawalSlip.rdl';
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
            column(Transactions_No; "No.")
            {
            }
            column(ID_No; "ID No")
            {

            }

            column(AccountNo; "Account No.")
            {
            }
            column(Account_No_; "Account No.")
            {

            }
            column(Account_Name; "Account Name")
            {

            }
            column(AccountName; "Account Name")
            {
            }
            column(ChargeAmount; ChargeAmount)
            {
            }
            column(ChargeAmountDuty; ChargeAmountDuty)
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
            column(BranchCode; Transactions."Global Dimension 2 Code")
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
            column(NumberText; NumberText[1])
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
            column(Cashier; Transactions.Cashier)
            {
            }
            column(TransDescr; TransDescr)
            {
            }
            column(NewAccountBalance; Transactions."New Account Balance")
            {
            }
            column(Type; Transactions.Type)
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

            trigger OnAfterGetRecord()
            begin
                Gensetup.Get();
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

                TCharges := 0;

                TransactionCharges.Reset;
                TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
                if TransactionCharges.Find('-') then begin
                    repeat

                        if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                        (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                            ChargeAmount := 0;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                ChargeAmount := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                            else
                                ChargeAmount := TransactionCharges."Charge Amount";

                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" = true then begin
                                                ChargeAmount := Amount * TariffDetails.Percentage * 0.01;
                                            end else begin
                                                ChargeAmount := TariffDetails."Charge Amount";
                                            end;
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;
                        end;

                    until TransactionCharges.Next = 0;
                end;
                Gensetup.TestField("Excise Duty (%)");
                ChargeAmountDuty := Round((ChargeAmount * (Gensetup."Excise Duty (%)" / 100)), 1, '=');
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
        CheckReport: Report Check;
        SumTransactionCharges: Decimal;
        ChAmount: Decimal;
        SavingsLedgerEntry: Record "Banking A/c Ledger Entry";
        Savings: Record "Account Banking";
        StaffNo: Code[20];
        ProductNames: Text[50];
        NumberText: array[2] of Text[80];
        user: Record User;
        CashierName: Text;
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        ChargeAmountDuty: Decimal;
        TransDescr: Text;
        Gensetup: Record "General Set-Up";
}




