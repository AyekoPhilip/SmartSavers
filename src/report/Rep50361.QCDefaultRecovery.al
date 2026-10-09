report 50361 "QC Default Recovery"
{
    ApplicationArea = All;
    Caption = 'QC Default Recovery';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(Loans; Loans)
        {
            RequestFilterFields = "No.", "Product Type", "Account No.";
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                PostingType := PostingType::"Post Application";
                if CustRec.Get("Account No.") then
                    if CustRec.Status = CustRec.Status::Deceased then CurrReport.Skip();

                Enddate := 0D;
                CalcFields("Outstanding Balance");
                if "Product Type" = 'MSACCOLN' then begin

                    if "Outstanding Balance" > 0 then begin
                        AccountCredit.Reset();
                        AccountCredit.SetRange("Member No.", "Account No.");
                        AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
                        if AccountCredit.FindFirst() then begin
                            AccountCredit.CalcFields("Balance (LCY)");
                            if AccountCredit."Balance (LCY)" > 0 then begin
                                if PostingType = PostingType::"Post Application" then begin
                                    PeriodicMngt.PerformPostOnMobLoanDefaultedMngtAuto("No.", Today, 1, Today);
                                end;
                            end;
                        end;
                    end else begin
                        CurrReport.Skip();
                    end;
                end else begin
                    CurrReport.Skip();
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
                group(GroupName)
                {
                    field(PostingType; PostingType)
                    {
                        Caption = 'Posting Type';
                        ApplicationArea = All;

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
        AccountBanking: Record "Account Banking";
        RunBal: Decimal;
        TransType: Enum "LoanTransactionType";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        AccountCredit: Record "Account Credit";
        PostingType: Option " ","Post Application","Generate Batch";
        Enddate: Date;
        CustRec: Record Member;

}



