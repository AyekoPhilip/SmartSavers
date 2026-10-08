report 50335 "Repayment Schedule-Loans"
{
    ApplicationArea = All;
    Caption = 'Repayment Schedule-Loans';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/LoanAccountRepaySchedule.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            column(No; "No.")
            { }
            column(CompInfoName; CompInfo.Name)
            { }
            column(AccountNo; "Account No.")
            { }
            column(AccountName; "Account Name")
            { }
            column(Approved_Amount; "Approved Amount")
            { }
            column(Product_Description; "Product Description")
            { }
            column(Installments; Installments)
            { }
            column(Interest_Rate; "Interest Rate")
            { }
            column(FileNo; FileNo)
            {

            }
            dataitem("Repayment Schedule"; "Repayment Schedule")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("No.", "Account No.", "Repayment Date");
                RequestFilterFields = "Account No.", "Product Type";
                column(No_; "No.")
                { }
                column(Account_No_; "Account No.")
                { }
                column(Loan_Application_No_; "Loan Application No.")
                { }
                column(Repayment_Code; "Repayment Code")
                { }
                column(Repayment_Date; "Repayment Date")
                { }
                column(Loan_Amount; "Loan Amount")
                { }
                column(Loan_Balance; "Loan Balance")
                { }
                column(Monthly_Interest; "Monthly Interest")
                { }
                column(Monthly_Repayment; "Monthly Repayment")
                { }
                column(Principal_Repayment; "Principal Repayment")
                { }
                column(LoanBalance; LoanBalance)
                { }
                column(Monthly_Insurance; "Monthly Insurance")
                { }
                trigger OnAfterGetRecord()
                begin
                    LoanBalance := "Loan Balance" - "Principal Repayment";
                end;

            }
            trigger OnAfterGetRecord()
            begin
                if CustRecord.Get("Account No.") then
                    FileNo := CustRecord."File No." else
                    FileNo := '';
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
        LoanBalance: Decimal;
        CompInfo: Record "Company Information";
        CustRecord: Record Member;
        FileNo: Code[20];
}



