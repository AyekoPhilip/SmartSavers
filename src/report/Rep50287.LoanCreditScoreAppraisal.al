report 50287 "Loan Credit Score Appraisal"
{
    ApplicationArea = All;
    Caption = 'Loan Credit Score Appraisal';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {


    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(ProductType; ProductType)
                    {
                        Caption = 'Product Type';
                        TableRelation = "Product Factory" where("Product Class" = const(Loan), "Loan Span" = filter("Mobile Loan" | Dividends), Status = const(Active));
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
    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;

    trigger OnPreReport()
    begin



    end;

    var
        ProductType: Code[20];
        RegMnt: Codeunit "Register Management";
        ShowOutPut: Boolean;
        PFact: Record "Product Factory";
        ProdDescription: Text[150];
}



