report 50309 "Salary Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/SalaryReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Salary Header"; "Salary Header")
        {
            column(Picture; CompanyInfo.Picture)
            {
            }
            /* column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            } */
            column(us; UserId)
            {
            }
            column(date; Format(Today, 0, 4))
            {
            }
            column(CompName; CompanyName)
            {
            }
            column(No; "Salary Header".No)
            {
            }
            column(DocNo; "Salary Header"."Document No")
            {
            }
            column(AmountHeader; "Salary Header".Amount)
            {
            }
            column(IncomeType; "Salary Header"."Income Type")
            {
            }
            column(EnteredBy; "Salary Header"."Entered By")
            {
            }
            dataitem("Salary Lines"; "Salary Lines")
            {
                DataItemLink = "Salary Header No." = FIELD(No);
                column(Account; "Salary Lines"."Account No.")
                {
                }
                column(StaffNo; "Salary Lines"."Staff No.")
                {
                }
                column(Name; "Salary Lines".Name)
                {
                }
                column(ID; "Salary Lines"."ID No.")
                {
                }
                column(Amount; "Salary Lines".Amount)
                {
                }
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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
        CompanyInfo: Record "Company Information";
}




