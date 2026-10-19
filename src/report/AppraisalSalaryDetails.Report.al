report 50220 "Appraisal Salary Details"
{
    ApplicationArea = All;
    Caption = 'Appraisal Salary Details';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/LoanAppraisalDetails.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }

            dataitem("Appraisal Salary Details"; "Appraisal Salary Details")
            {
                DataItemLink = "Loan Application No." = field("Application No."), "Client Code" = field("Account No.");
                column(Loan_Application_No_; "Loan Application No.")
                { }
                column(Type; Type)
                { }
                column(Amount; Amount)
                { }
                column(Description; Description)
                { }
                column(Code; Code)
                { }
                column(Client_Code; "Client Code")
                { }



            }
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
}



