report 50201 "Official Receipt"
{
    ApplicationArea = All;
    Caption = 'Official Receipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/OfficialReceipt.rdl';

    dataset
    {
        dataitem(ReceiptsHeader; "Receipts Header")
        {
            column(No; "No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(OnBehalfOf; "On Behalf Of")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(AmountRecieved; "Amount Recieved")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(Cashier; Cashier)
            {
            }
            column(ChequeNo; "Cheque No.")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(Date; "Date")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(ReceivedFrom; "Received From")
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(DatePosted; "Date Posted")
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
            column(EmailAddress; CustEmail)
            {
            }
            column(SavingsAccountName; SavingsAccountName)
            {

            }
            column(NumberText; NumberText[1])
            {

            }
            column(EntrNo; EntrNo)
            {

            }
            dataitem("Receipt Line"; "Receipt Line")
            {
                DataItemLink = No = FIELD("No.");
                column(LineNo; No)
                { }
                column(lineAmount; Amount)
                { }
                column(Product_Description; "Product Description")
                { }
                column(Product_Category; "Product Category")
                { }
                column(LineAccount_Type; "Account Type")
                { }
                column(LineAccount_No_; "Account No.")
                {

                }
                column(LineAccount_Name; "Account Name")
                {

                }
                column(Pay_Mode; "Pay Mode")
                {

                }
                column(Loan_No_; "Loan No.")
                {

                }
                column(Transaction_Type; TransactionTypel)
                {

                }
                column(Product_Type; "Product Type")
                {

                }
                trigger OnAfterGetRecord()
                begin
                    TransactionTypel := '';

                    if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::Customer,
                 "Account Type"::Vendor, "Account Type"::"IC Partner", "Account Type"::Employee,
                 "Account Type"::Saving, "Account Type"::Credit, "Account Type"::Prepayment, "Account Type"::Loan] then
                        case "Account Type" of
                            "Account Type"::"G/L Account":
                                begin
                                    GLAcc.Get("Account No.");
                                end;

                            "Account Type"::"Bank Account":
                                begin
                                    BankAcc.Get("Account No.");
                                    "Account Name" := BankAcc.Name;
                                end;
                            "Account Type"::"Fixed Asset":
                                begin
                                    FA.Get("Account No.");
                                    "Account Name" := FA.Description;
                                end;
                            "Account Type"::Vendor,
                        "Account Type"::Saving:
                                begin

                                    if Vend.Get("Account No.") then begin
                                        if SavingsAcc.Get(Vend."No.") then begin
                                            SavingsAcc.CalcFields("Balance (LCY)");
                                            "Product Category" := SavingsAcc."Account Category";
                                            "Product Description" := SavingsAcc."Product Name";
                                            "Product Type" := SavingsAcc."Product Type";
                                            TransactionTypel := SavingsAcc."Product Name";
                                        end;
                                    end
                                end;
                            "Account Type"::Customer,
                        "Account Type"::Credit:
                                begin
                                    if Cust.Get("Account No.") then begin

                                        if AccCredit.Get(Cust."No.") then begin
                                            AccCredit.CalcFields("Balance (LCY)");
                                            "Product Category" := AccCredit."Account Category";
                                            "Product Description" := AccCredit."Product Name";
                                            "Product Type" := AccCredit."Product Type";
                                            TransactionTypel := AccCredit."Product Name";
                                        end;
                                    end
                                end;

                            "Account Type"::Loan:
                                begin
                                    LoanAcc.Reset();
                                    if LoanAcc.Get("Loan No.") then begin
                                        "Product Type" := LoanAcc."Product Type";
                                        "Product Description" := LoanAcc."Product Description";
                                        TransactionTypel := Format("Transaction Type");
                                    end;
                                end;
                            "Account Type"::Prepayment:
                                begin
                                    if CreditRepayAcc.Get("Account No.") then begin
                                        "Product Type" := CreditRepayAcc."Product Type";
                                        "Product Description" := CreditRepayAcc."Product Name";
                                    end;
                                end;
                        end;


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
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;
                EntrNo := EntrNo + 1;

            end;

            trigger OnAfterGetRecord()
            begin

                if CustRec.Get("Member No.") then begin
                    SavingsAccountName := CustRec.Name;
                    CustEmail := CustRec."E-Mail";
                    CustAddress := CustRec."Current Address";
                    StaffNo := CustRec."Payroll/Staff No.";
                    EntrNo := EntrNo + 1;
                end;
                CalcFields("Total Amount");
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, "Total Amount", '');
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
        AccBanking: Record "Account Banking";
        AccBosa: Record "Account Credit";
        pfact: Record "Product Factory";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        TransactionTypel: Text[150];
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        SavingsAcc: Record "Account Banking";
        CreditAcc: Record "Credit Account";
        CreditRepayAcc: Record "Repayment Account";
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
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
        EndDate: Date;
        StaffNo: Code[10];
        CustAddress: Code[100];
        CustEmail: Text[100];
        CustRec: Record Member;
        EntrNo: Integer;
        AccCredit: Record "Account Credit";
        LoanAcc: Record Loans;
        Getsetup: Record "General Set-Up";
        LoanCategory: Record "Loans Categorization";
       

}



