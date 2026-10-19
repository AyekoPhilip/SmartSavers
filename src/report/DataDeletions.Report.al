namespace SmartSaverDB.SmartSaverDB;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Purchases.Payables;
using Microsoft.Bank.Ledger;

report 90029 "Data Deletions"
{
    ApplicationArea = All;
    Caption = 'Data Deletion';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    Permissions = TableData "Cust. Ledger Entry" = rimd, TableData "Detailed Cust. Ledg. Entry" = rimd, TableData "G/L Entry" = rimd,
    TableData "Bank Account Ledger Entry" = rimd, TableData "Vendor Ledger Entry" = rimd, 
    TableData "Detailed Vendor Ledg. Entry" = rimd, tabledata "Banking A/c Ledger Entry" = rimd;


    dataset
    {
        dataitem(GLEntry; Loans)
        {
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin


                GENTRY.Reset();
                GENTRY.SetRange("Document No.", documentnumber);
                GENTRY.SetRange("Posting Date", pdate);
                if GENTRY.FindSet() then begin
                    GENTRY.DeleteAll();
                end;


                BANKLEDGER.Reset();
                BANKLEDGER.SetRange("Document No.", documentnumber);
                BANKLEDGER.SetRange("Posting Date", pdate);
                if BANKLEDGER.FindSet() then begin
                    BANKLEDGER.DeleteAll();
                end;

                BANKLEDGER2.Reset();
                BANKLEDGER2.SetRange("Document No.", documentnumber);
                BANKLEDGER2.SetRange("Posting Date", pdate);
                if BANKLEDGER2.FindSet() then begin
                    BANKLEDGER2.DeleteAll();
                end;
                 BANKLEDGER2.Reset();
                BANKLEDGER2.SetRange("Document No.", documentnumber);
                BANKLEDGER2.SetRange("Posting Date", pdate);
                if BANKLEDGER2.FindSet() then begin
                    BANKLEDGER2.DeleteAll();
                end;

                loanledger.Reset();
                loanledger.SetRange("Document No.", documentnumber);
                loanledger.SetRange("Posting Date", pdate);
                if loanledger.FindSet() then begin
                    loanledger.DeleteAll();
                end;

                Custledger.Reset();
                Custledger.SetRange("Document No.", documentnumber);
                Custledger.SetRange("Posting Date", pdate);
                if Custledger.FindSet() then begin
                    Custledger.DeleteAll();
                end;
                dcustledger.Reset();
                dcustledger.SetRange("Document No.", documentnumber);
                dcustledger.SetRange("Posting Date", pdate);
                if dcustledger.FindSet() then begin
                    dcustledger.DeleteAll();
                end;

                vendledger.Reset();
                vendledger.SetRange("Document No.", documentnumber);
                vendledger.SetRange("Posting Date", pdate);
                if vendledger.FindSet() then begin
                    vendledger.DeleteAll();
                end;

                Dvendledger.Reset();
                Dvendledger.SetRange("Document No.", documentnumber);
                Dvendledger.SetRange("Posting Date", pdate);
                if Dvendledger.FindSet() then begin
                    Dvendledger.DeleteAll();
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
            area(Content)
            {
                group("Options")


                {

                    Caption = 'Options';
                    field(documentnumber; documentnumber)
                    {
                        Caption = 'Document Number';
                        ApplicationArea = All;
                    }
                    field(pdate; pdate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                    }

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
        GENTRY: Record "G/L Entry";
        BANKLEDGER: Record "Bank Account Ledger Entry";
        Custledger: Record "Cust. Ledger Entry";
        dcustledger: Record "Detailed Cust. Ledg. Entry";
        vendledger: Record "Vendor Ledger Entry";
        Dvendledger: Record "Detailed Vendor Ledg. Entry";
        BANKLEDGER2: Record "Banking A/c Ledger Entry";

        loanledger: Record "Loan Ledger Entry";
        documentnumber: Code[100];
        pdate: Date;

}
