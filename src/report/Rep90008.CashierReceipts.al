namespace DynamicsNav.SaccoDatabase;

using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
using Microsoft.Purchases.Vendor;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Account;

report 90008 "Cashier Receipts"
{
    ApplicationArea = All;
    Caption = 'Cashier Receipts';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CashierReceipts.rdl';
    dataset
    {
        dataitem(ReceiptLine; "Receipt Line")
        {
            DataItemTableView = where(Posted = filter(true));
            RequestFilterFields = No, "Member No.", "Account No.";
            column(No; No)
            {
            }
            column(CompanyInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(Date; Date)
            { }
            column(Date_Posted; "Date Posted")
            { }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyTelephone; CompanyTelephone)
            {
            }
            column(CommunicationOnline; CommunicationOnline)
            {
            }

            column(MemberNo; "Member No.")
            {
            }
            column(AccountName; AccName)
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(PayrollNo; PayrollNo)
            { }
            column(BalanceLCY; BalanceLCY[1])
            { }
            column(LoanBalanceLCY; BalanceLCY[2])
            { }
            column(AccountType; "Account Type")
            {
            }
            column(Amount; Amount)
            {
            }
            column(TransactionType; TransactionTypel)
            {

            }
            column(Type; "Type")
            {
            }
            column(PayMode; "Pay Mode")
            {
            }
            column(ProductCategory; "Product Category")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ReceivedFrom; "Received From")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(InterestBalance; "Interest Balance")
            {
            }
            column(OnBehalfOf; "On Behalf Of")
            {
            }
            column(ChequeDepositSlipBank; "Cheque/Deposit Slip Bank")
            {
            }
            column(ChequeDepositSlipDate; "Cheque/Deposit Slip Date")
            {
            }
            column(ChequeDepositSlipNo; "Cheque/Deposit Slip No")
            {
            }
            column(ChequeDepositSlipType; "Cheque/Deposit Slip Type")
            {
            }
            column(Balance; Balance)
            {
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

            end;

            trigger OnAfterGetRecord()
            begin

                ReceiptHeader.Reset();
                ReceiptHeader.SetRange("No.", No);
                if ProductDimension <> '' then begin
                    ReceiptHeader.SetRange("Account No.", ProductDimension);
                end;
                if ReceiptHeader.Find('-') then begin

                    TransactionTypel := '';
                    BalanceLCY[1] := 0;
                    BalanceLCY[2] := 0;
                    PayrollNo := '';
                    AccName := '';

                    if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::Customer,
                 "Account Type"::Vendor, "Account Type"::"IC Partner", "Account Type"::Employee,
                 "Account Type"::Saving, "Account Type"::Credit, "Account Type"::Prepayment, "Account Type"::Loan] then
                        case "Account Type" of
                            "Account Type"::"G/L Account":
                                begin
                                    if GLAcc.Get("Account No.") then
                                        TransactionTypel := GLAcc.Name
                                end;
                            "Account Type"::Vendor,
                        "Account Type"::Saving:
                                begin

                                    Vend.Reset();
                                    if Vend.Get("Account No.") then begin

                                        SavingsAcc.Reset();
                                        if SavingsAcc.Get(Vend."No.") then begin
                                            SavingsAcc.CalcFields("Balance (LCY)");
                                            "Product Category" := SavingsAcc."Account Category";
                                            AccName := SavingsAcc.Name;
                                            "Product Description" := SavingsAcc."Product Name";
                                            "Product Type" := SavingsAcc."Product Type";
                                            BalanceLCY[1] := SavingsAcc."Balance (LCY)";
                                            TransactionTypel := SavingsAcc."Product Name";
                                            Custmember.Reset();
                                            Custmember.SetRange("No.", SavingsAcc."Member No.");
                                            if Custmember.FindFirst() then
                                                PayrollNo := Custmember."Payroll/Staff No."
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
                                            AccName := AccCredit.Name;
                                            "Product Description" := AccCredit."Product Name";
                                            "Product Type" := AccCredit."Product Type";
                                            TransactionTypel := AccCredit."Product Name";
                                            BalanceLCY[1] := AccCredit."Balance (LCY)";
                                            Custmember.Reset();
                                            Custmember.SetRange("No.", AccCredit."Member No.");
                                            if Custmember.FindFirst() then
                                                PayrollNo := Custmember."Payroll/Staff No."
                                        end;
                                    end
                                end;
                            "Account Type"::Loan:
                                begin
                                    LoanAcc.Reset();
                                    if LoanAcc.Get("Loan No.") then begin
                                        LoanAcc.CalcFields("Outstanding Balance");
                                        ProductType.Get(LoanAcc."Product Type");
                                        LoanAcc."Product Dimension" := ProductType."Product Dimension";
                                        LoanAcc.Modify(true);
                                        "Product Type" := LoanAcc."Product Type";
                                        AccName := LoanAcc."Account Name";
                                        "Product Description" := LoanAcc."Product Description";
                                        TransactionTypel := Format("Transaction Type");
                                        BalanceLCY[2] := LoanAcc."Outstanding Balance";
                                        if LoanAcc."Product Dimension" = LoanAcc."Product Dimension"::Account then begin
                                            SavingsAcc.Reset();
                                            SavingsAcc.SetRange("Member No.", LoanAcc."Account No.");
                                            SavingsAcc.SetRange("Account Category", SavingsAcc."Account Category"::"Money Market");
                                            if SavingsAcc.FindFirst() then begin
                                                SavingsAcc.CalcFields("Balance (LCY)");
                                                BalanceLCY[1] := SavingsAcc."Balance (LCY)";
                                            end;
                                        end else begin
                                            BalanceLCY[1] := RegMngt.GetOperationAccBalanceTxt(Enum::ProductAccountCategory::"Shares Deposit", LoanAcc."Account No.", 2);
                                        end;
                                        Custmember.Reset();
                                        Custmember.SetRange("No.", LoanAcc."Account No.");
                                        if Custmember.FindFirst() then
                                            PayrollNo := Custmember."Payroll/Staff No."
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
                end else begin
                    CurrReport.Skip();
                end;
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
                    field(ProductDimension; ProductDimension)
                    {
                        ApplicationArea = All;
                        TableRelation="Bank Account"."No.";
                        Caption = 'Product Dimension';
                    }
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

        BalanceLCY: array[9] of Decimal;
        PayrollNo: Code[20];
        ReceiptHeader: Record "Receipts Header";
        AccBanking: Record "Account Banking";
        AccBosa: Record "Account Credit";
        pfact: Record "Product Factory";
        GLAcc: Record "G/L Account";
        Vend: Record Vendor;
        Custmember: Record Member;
        Cust: Record Customer;
        AccName: Text[250];
        TransactionTypel: Text[150];

        SavingsAcc: Record "Account Banking";
        CreditAcc: Record "Credit Account";
        CreditRepayAcc: Record "Repayment Account";
        RegMngt: Codeunit "Register Management";
        SharesCapital: Decimal;
        CustAge: Integer;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        DepMultiplier: array[5] of Decimal;
        CustEmail: Text[150];
        Employer: Record Customer;
        CustomerRec: Record Member;
        BalanceBF: Decimal;
        CName: Text[150];
        AccCredit: Record "Account Credit";
        LoanAcc: Record Loans;
        EmpName: Text;
        LastDepositDate: Date;
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
        LoanGuarantTotal: Decimal;
        LastTransDate: Date;

        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[100];
        ProductType: Record "Product Factory";
        MembershipAge: Integer;
        BankingAcc: Record "Account Banking";
        CredAcc: Record "Account Credit";
        LoansT: Record Loans;
        AccType: Enum ProductAccountCategory;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        ProductDimension: Code[50];
}
