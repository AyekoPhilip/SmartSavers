namespace SaccoDB.SaccoDB;
using Microsoft.Sales.Receivables;
using Microsoft.Purchases.Payables;

report 90025 "Mobile Payments"
{
    ApplicationArea = All;
    Caption = 'Mobile Payments';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MobilePaymentsReport.rdl';
    dataset
    {
        dataitem(MPESATransactions; "MPESA Transactions")

        {
            RequestFilterFields = "Transaction Date", "Account No.";
            DataItemTableView = where("Processed" = filter(true));
            column(ReceiptNo; "Receipt No.")
            {
            }
            column(Status; Status)
            {
            }
            column(TransactionDate; "Transaction Date")
            {
            }
            column(ReceivedOn; "Received On")
            {
            }
            column(Phone; "Phone")
            {
            }
            column(PaybilNumber; "Paybil Number")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(Balance; Balance)
            {
            }
            column(Amount; Amount)
            {
            }
            column(PostedOn; "Posted On")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(CompletionTime; "Completion Time")
            {
            }
            column(customerno; customerno) { }
            column(keyword; keyword) { }
            column(PayrollNo; PayrollNo) { }
            column(OutBalance; OutBalance) { }
            column(accounttype; accounttype) { }
            column(Loanno; Loanno) { }
            trigger OnAfterGetRecord()
            begin
                customerno := '';
                keyword := '';
                PayrollNo := '';
                OutBalance := 0;
                Loanno := '';
                //customerno := CopyStr("Account No.", 1, 5);
                //keyword := CopyStr("Account No.", 6, 3);

                vendledger.Reset();
                vendledger.SetRange("Document No.", "Receipt No.");
                if vendledger.FindFirst() then begin

                    accmgt.Reset();
                    accmgt.SetRange("No.", vendledger."Vendor No.");
                    if accmgt.FindFirst() then begin
                        accmgt.CalcFields("Balance (LCY)");
                        OutBalance := accmgt."Balance (LCY)";
                        accounttype := accmgt."Product Type" + ' - ' + accmgt."Product Name";
                        Loanno := accmgt."No.";

                        Custmgt.Reset();
                        Custmgt.SetRange("No.", accmgt."Member No.");
                        if Custmgt.FindFirst() then begin
                            "Customer Name" := Custmgt."Name";
                            "Phone" := Custmgt."Mobile Phone No";
                            PayrollNo := Custmgt."Payroll/Staff No.";
                            customerno := Custmgt."No.";
                        end;
                    end
                end else begin

                    custledger.Reset();
                    custledger.SetRange("Document No.", "Receipt No.");
                    if custledger.FindFirst() then begin

                        credaccmgt.Reset();
                        credaccmgt.SetRange("No.", custledger."Customer No.");
                        if credaccmgt.FindFirst() then begin
                            credaccmgt.CalcFields("Balance (LCY)");
                            OutBalance := credaccmgt."Balance (LCY)";
                            accounttype := credaccmgt."Product Type" + ' - ' + credaccmgt."Product Name";
                            Loanno:=credaccmgt."No.";

                            Custmgt.Reset();
                            Custmgt.SetRange("No.", credaccmgt."Member No.");
                            if Custmgt.FindFirst() then begin
                                "Customer Name" := Custmgt."Name";
                                "Phone" := Custmgt."Mobile Phone No";
                                PayrollNo := Custmgt."Payroll/Staff No.";
                                customerno := Custmgt."No.";
                            end;
                        end else begin

                            Loanmgt.Reset();
                            Loanmgt.SetRange("No.", custledger."Loan No.");
                            if Loanmgt.FindFirst() then begin
                                Loanmgt.CalcFields("Outstanding Balance");
                                Loanno := Loanmgt."No.";
                                accounttype := Loanmgt."Product Type" + ' - ' + Loanmgt."Product Description";
                                OutBalance := Loanmgt."Outstanding Balance";

                                Custmgt.Reset();
                                Custmgt.SetRange("No.", Loanmgt."Account No.");
                                if Custmgt.FindFirst() then begin
                                    "Customer Name" := Custmgt."Name";
                                    "Phone" := Custmgt."Mobile Phone No";
                                    PayrollNo := Custmgt."Payroll/Staff No.";
                                    customerno := Custmgt."No.";
                                end;
                            end
                        end;
                    end
                end
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        Custmgt: Record Member;
        accmgt: Record "Account Banking";
        credaccmgt: Record "Account Credit";
        Loanmgt: Record Loans;
        customerno: Code[100];
        custledger: Record "Cust. Ledger Entry";
        custledger2: Record "Cust. Ledger Entry";
        vendledger: Record "Vendor Ledger Entry";
        keywordsetup: Record "Keyword Setup";
        keyword: Code[20];
        PayrollNo: Code[20];
        OutBalance: Decimal;
        accounttype: Code[250];
        Loanno: Code[50];
}
