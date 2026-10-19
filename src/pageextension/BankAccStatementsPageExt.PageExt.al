pageextension 50066 BankAccStatementsPageExt extends "Bank Account Statement"
{
    actions
    {
        addfirst(Reporting)

        {
            action(BankReconcilliationReport)
            {

                ApplicationArea = All;
                Caption = ' Detailed Bank Reconcilliation Report';
                Image = PostPrint;

                trigger OnAction()
                var
                    BankStmt: report "Bank Account Statement Ext";
                    BankStmRec: record "Bank Account Statement";
                begin
                    BankStmRec.SetRange("Bank Account No.", Rec."Bank Account No.");
                    BankStmRec.SetRange("Statement No.", Rec."Statement No.");
                    BankStmt.SetTableView(BankStmRec);
                    BankStmt.Run();
                end;
            }

            action(ReconcilliationReportSummary)
            {

                ApplicationArea = All;
                Caption = '  Bank Reconcilliation Report Summary';
                Image = PostPrint;
                RunObject = report "Bank Account Statement Ext";
            }


        }
    }
}
