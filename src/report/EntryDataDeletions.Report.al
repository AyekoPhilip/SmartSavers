namespace SmartSaverDB.SmartSaverDB;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Purchases.Payables;
using Microsoft.Bank.Ledger;

report 90028 "Entry Data Deletions"
{
    ApplicationArea = All;
    Caption = 'Entry Data Deletion';
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
                GENTRY.SetRange("Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if GENTRY.FindSet() then begin
                    GENTRY.DeleteAll();
                end;


                BANKLEDGER.Reset();
                BANKLEDGER.SetRange("Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if BANKLEDGER.FindSet() then begin
                    BANKLEDGER.DeleteAll();
                end;

                BANKLEDGER2.Reset();
                BANKLEDGER2.SetRange("Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if BANKLEDGER2.FindSet() then begin
                    BANKLEDGER2.DeleteAll();
                end;
                 BANKLEDGER2.Reset();
                BANKLEDGER2.SetRange("Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if BANKLEDGER2.FindSet() then begin
                    BANKLEDGER2.DeleteAll();
                end;

                loanledger.Reset();
                loanledger.SetRange("Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if loanledger.FindSet() then begin
                    loanledger.DeleteAll();
                end;

                Custledger.Reset();
                Custledger.SetRange("Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if Custledger.FindSet() then begin
                    Custledger.DeleteAll();
                end;
                dcustledger.Reset();
                dcustledger.SetRange(dcustledger."Cust. Ledger Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if dcustledger.FindSet() then begin
                    dcustledger.DeleteAll();
                end;

                vendledger.Reset();
                vendledger.SetRange("Entry No.",SENTRYNUMBER,EENTRYNUMBER);
                if vendledger.FindSet() then begin
                    vendledger.DeleteAll();
                end;

                Dvendledger.Reset();
                Dvendledger.SetRange(Dvendledger."Vendor Ledger Entry No.",SENTRYNUMBER,EENTRYNUMBER);
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
                    field(SENTRYNUMBER;SENTRYNUMBER)
                    {
                        Caption = 'Starting Entry No.';
                        ApplicationArea = All;
                    }
                    field(EENTRYNUMBER;EENTRYNUMBER)
                    {
                        Caption = 'ENding Entry No.';
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
        SENTRYNUMBER: Integer;
        EENTRYNUMBER: Integer;
        pdate: Date;

}
