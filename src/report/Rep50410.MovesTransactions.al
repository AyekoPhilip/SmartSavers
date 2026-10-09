namespace SmartSaverDB.SmartSaverDB;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Bank.BankAccount;
using Microsoft.Purchases.Vendor;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Payables;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Ledger;
using Microsoft.Sales.Customer;
using Microsoft.Bank.Ledger;

report 50410 "Moves Transactions"
{
    ApplicationArea = All;
    Caption = 'Data Deletion';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    Permissions = TableData "Cust. Ledger Entry" = rimd, TableData "Detailed Cust. Ledg. Entry" = rimd, TableData "G/L Entry" = rimd,
    TableData "Bank Account Ledger Entry" = rimd, TableData "Vendor Ledger Entry" = rimd, TableData "Detailed Vendor Ledg. Entry" = rimd;


    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            var
                BankLedger: Record "Bank Account Ledger Entry";
                BankAcc: Record "Bank Account";
                BankPostingGroup: Record "Bank Account Posting Group";
                VendorPostingGroup: Record "Vendor Posting Group";
                VendorLedger: Record "Vendor Ledger Entry";
                CustLedger: Record "Cust. Ledger Entry";
                CustPostingGroup: Record "Customer Posting Group";
                FALedger: Record "FA Ledger Entry";
                FAPostingGroup: Record "FA Posting Group";
                ProductType: Record "Product Factory";
                GLEnt2, GLEnt3 : Record "G/L Entry";
                TestDataCopy: Record TestDataCopy;
                CustLEdgerDet: Record "Detailed Cust. Ledg. Entry";
                VendorLEdgerDet: Record "Detailed Vendor Ledg. Entry";
            begin
                if Confirm('Delete Entries?') then begin
                    TestDataCopy.DeleteAll();
                end;
                TestDataCopy.Reset();
                if TestDataCopy.FindSet() then begin
                    repeat
                        case TestDataCopy."Table No" of
                            Database::"G/L Entry":
                                begin
                                    if GLEntry.get(TestDataCopy."Entry No") then begin
                                        GLEntry."G/L Account No." := TestDataCopy."G/L Account";
                                        GLEntry.Modify();
                                    end;
                                end;
                            Database::"Vendor Ledger Entry":
                                begin
                                    VendorLEdgerDet.Reset();
                                    VendorLEdgerDet.SetRange("Vendor Ledger Entry No.", TestDataCopy."Entry No");
                                    VendorLEdgerDet.ModifyAll("Vendor No.", TestDataCopy."G/L Account");
                                    if VendorLedger.get(TestDataCopy."Entry No") then begin
                                        VendorLedger."Vendor No." := TestDataCopy."G/L Account";
                                        VendorLedger.Modify();
                                    end;
                                end;
                            Database::"Cust. Ledger Entry":
                                begin
                                    CustLEdgerDet.Reset();
                                    CustLEdgerDet.SetRange("Cust. Ledger Entry No.", TestDataCopy."Entry No");
                                    CustLEdgerDet.ModifyAll("Customer No.", TestDataCopy."G/L Account");
                                    if CustLedger.get(TestDataCopy."Entry No") then begin
                                        CustLedger."Customer No." := TestDataCopy."G/L Account";
                                        CustLedger.Modify();
                                    end;
                                end;
                        end;
                    until TestDataCopy.Next() = 0;
                end;
                Commit();
                Error('Done');
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

}
