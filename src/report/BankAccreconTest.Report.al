namespace DynamicsNav.SaccoDatabase;

using Microsoft.Bank.Reconciliation;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Company;
report 50032 "Bank Acc. recon Test"
{
    ApplicationArea = All;
    Caption = 'Bank Acc. Recon Test';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/BankAccReconTestReport.rdl';
    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(BankCode; BankCode)
            { }
            column(BankAccNo; BankAccNo)
            { }
            column(BankName; BankName)
            { }
            column(Bank_Account_No_; "Bank Account No.")
            { }
            column(Statement_Date; "Statement Date")
            { }
            column(Statement_No_; "Statement No.")
            { }
            column(Statement_Ending_Balance; "Statement Ending Balance")
            { }
            column(Total_Applied_Amount; "Total Applied Amount")
            { }
            column(Total_Transaction_Amount; "Total Transaction Amount")
            { }
            column(TotalDifference; TotalDifference)
            { }
            column(BankAccountBalanceasperCashBook; BankAccountBalanceasperCashBook)
            { }
            column(UnpresentedChequesTotal; UnpresentedChequesTotal)
            { }
            column(UncreditedBanking; UncreditedBanking)
            { }
            column(UncreditedChqs; UncreditedChqs)
            { }
            column(ReconciliationStatement; ReconciliationStatement)
            { }
            column(TotalPresented; TotalPresented)
            { }
            column(TotalUnpresentedChqs; TotalUnpresentedChqs)
            { }
            column(TotalDifferenceUncredited; TotalDifferenceUncredited)
            { }
            column(TotalDifferenceUnPresented; TotalDifferenceUnPresented)
            { }
            column(DifferenceToExplain; DifferenceToExplain)
            { }
            column(ReconciledCashBook; (BankAccountBalanceasperCashBook + UnpresentedChequesTotal) - UncreditedBanking)
            { }
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
                DataItemTableView = where(Reconciled = filter(false));
                column(BankAccountNo; "Bank Account No.")
                { }
                column(Check_No_; "Check No.")
                { }
                column(Document_No_; "Document No.")
                { }
                column(Transaction_Date; "Transaction Date")
                { }
                column(Description; Description)
                { }
                column(Statement_Amount; "Statement Amount")
                { }
                column(Open_Type; "Open Type")
                { }
                column(Reconciled; Reconciled)
                { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    if ("Bank Acc. Reconciliation Line"."Statement Amount" > 0) and ("Bank Acc. Reconciliation Line"."Document No." <> '') then
                        "Bank Acc. Reconciliation Line"."Open Type" := "Bank Acc. Reconciliation Line"."Open Type"::Uncredited;
                    if ("Bank Acc. Reconciliation Line"."Statement Amount" < 0) and ("Bank Acc. Reconciliation Line"."Document No." <> '') then
                        "Bank Acc. Reconciliation Line"."Open Type" := "Bank Acc. Reconciliation Line"."Open Type"::Unpresented;
                    if "Bank Acc. Reconciliation Line"."Document No." = '' then
                        "Bank Acc. Reconciliation Line"."Open Type" := "Bank Acc. Reconciliation Line"."Open Type"::Manual;
                    "Bank Acc. Reconciliation Line".Modify(true);

                end;

                trigger OnPostDataItem()
                begin

                end;

            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City;
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";

                ReconciliationStatement := 'Reconciliation is incomplete please go through it again';

            end;

            trigger OnAfterGetRecord()
            begin
                BankAccNo := '';
                BankName := '';
                BankAccountBalanceasperCashBook := 0;
                UnpresentedChequesTotal := 0;
                UncreditedBanking := 0;
                TotalDiffFunc();

                Bank.Reset();
                Bank.SetRange(Bank."No.", "Bank Account No.");
                if Bank.Find('-') then begin
                    BankCode := Bank."No.";
                    BankAccountNo := Bank."Bank Account No.";
                    BankName := Bank.Name;
                    Bank.SetRange(Bank."Date Filter", 0D, "Statement Date");
                    Bank.CalcFields(Bank."Balance at Date");
                    BankAccountBalanceasperCashBook := Bank."Balance at Date";
                    DifferenceToExplain := Abs("Bank Acc. Reconciliation"."Statement Ending Balance" - BankAccountBalanceasperCashBook);

                    BankStatementLine.Reset();
                    BankStatementLine.SetRange("Bank Account No.", Bank."No.");
                    BankStatementLine.SetRange("Statement No.", "Statement No.");
                    BankStatementLine.SetRange(Reconciled, false);
                    if BankStatementLine.FIND('-') then
                        repeat
                            if (BankStatementLine."Statement Amount" < 0) and (BankStatementLine."Document No." <> '') then
                                UnpresentedChequesTotal := UnpresentedChequesTotal + BankStatementLine."Statement Amount"
                            else if (BankStatementLine."Statement Amount" > 0) and (BankStatementLine."Document No." <> '') then
                                UncreditedBanking := UncreditedBanking + BankStatementLine."Statement Amount";
                        Until BankStatementLine.Next() = 0;
                    UnpresentedChequesTotal := UnpresentedChequesTotal * -1;

                    BankStatBalance := "Bank Acc. Reconciliation"."Statement Ending Balance";
                    Bal := (BankAccountBalanceasperCashBook + UnpresentedChequesTotal - UncreditedBanking) + TotalDifference;
                    if Bal = BankStatBalance then
                        ReconciliationStatement := ''
                    else
                        ReconciliationStatement := 'Reconciliation is incomplete please go through it again';
                end;
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
    trigger OnPreReport()
    begin

    end;

    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;

    local procedure TotalDiffFunc()
    begin
        BankRecPresented.Reset();
        BankRecPresented.SetRange("Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
        BankRecPresented.SetRange("Statement No.", "Bank Acc. Reconciliation"."Statement No.");
        BankRecPresented.SetRange("Document No.", '');
        if BankRecPresented.Find('-') then begin
            repeat
                TotalDifference := TotalDifference + BankRecPresented."Statement Amount";
                if BankRecPresented."Statement Amount" > 0 then
                    TotalDifferenceUncredited := TotalDifferenceUncredited + BankRecPresented."Statement Amount"
                else if BankRecPresented."Statement Amount" < 0 then
                    TotalDifferenceUnPresented := TotalDifferenceUnPresented + BankRecPresented."Statement Amount";

            Until BankRecPresented.Next() = 0;
        end;

    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        ReversedEntry: Boolean;
        TotalDifferenceUncredited: Decimal;
        TotalDifferenceUnPresented: Decimal;
        CommunicationOnline: Text;
        VarBankRec: Record "Bank Acc. Reconciliation";
        BankRecPresented: Record "Bank Acc. Reconciliation Line";
        BankRecUnPresented: Record "Bank Acc. Reconciliation Line";
        TotalPresented: Decimal;
        BankAccountBalanceasperCashBook: Decimal;
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
        TotalUnPresented: Decimal;
        BankStatBalance: Decimal;
        BankLastBalance: Decimal;
        BankName: Text[50];
        BankAcc: Record "Bank Account";
        CashBkBal: Decimal;
        Difference: Decimal;
        UncreditedChqs: Decimal;
        BankAccNo: Code[30];
        ReconciliationStatement: Text[250];
        Finished: Boolean;
        PrintWithRecon: Boolean;
        IsDifferent: Boolean;
        TotalUnpresentedChqs: Decimal;
        TotalDifference: Decimal;
        BankRecLine: Record "Bank Acc. Reconciliation Line";
        Unreceipted: Decimal;

        ////////

        Bank: Record "Bank Account";
        BankCode: Code[20];
        BankAccountNo: Code[20];
        BankStatementLine: Record "Bank Acc. Reconciliation Line";
        Bal: Decimal;
        DifferenceToExplain: Decimal;
}
