report 50326 "Loans GL Comparison"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoansGLComparison.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; Loans)
        {

            trigger OnAfterGetRecord()
            begin

                FactP.Reset;
                FactP.SetRange("Product ID", "Product Type");
                FactP.SetRange("Interest Account (G/L)", GLEntryNo);
                if FactP.Find('-') then begin


                    GLEntries.Reset;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GLEntries: Record "G/L Entry";
        FactP: Record "Product Factory";
        GLEntryNo: Code[20];
}




