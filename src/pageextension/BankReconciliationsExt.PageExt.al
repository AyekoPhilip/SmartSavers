pageextension 50060 BankReconciliationsExt extends "Bank Acc. Reconciliation"
{
   
    actions
    {

        addlast("P&osting")

        {
            action(PostAndPrintSumarry)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Summary';
                Image = PostPrint;
                ShortCutKey = 'Shift+F9';
                ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    BankAccRecTestRepVisible: Codeunit "Bank Acc.Rec.Test Rep. Visible";
                    BankAccountStatement: Report "Bank Account Statement Ext";
                //BankAccReconPostPrint: Codeunit "Bank Acc. Recon. Post+Print";
                begin
                    BindSubscription(BankAccRecTestRepVisible);
                    BankAccountStatement.Run();
                end;
            }

        }
    }
   
}
