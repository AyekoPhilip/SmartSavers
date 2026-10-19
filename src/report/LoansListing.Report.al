namespace SaccoDB.SaccoDB;

report 90024 "Loans Listing"
{
    ApplicationArea = All;
    Caption = 'Loans Listing';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/LoansListing.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            RequestFilterFields="No.","Account No.","Product Type";
            DataItemTableView = SORTING("No.") WHERE ("Approval Status" = filter(Approved|Posted));
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(Gender; Gender)
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(Source; Source)
            {
            }
            column(InterestCalculationMethod; "Interest Calculation Method")
            {
            }
            column(Installments; Installments)
            {
            }
            column(InterestRate; "Interest Rate")
            {
            }
            column(RepaymentFrequency; "Repayment Frequency")
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            column(No; "No.")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(LastPayDate; "Last Pay Date")
            {
            }
            column(Expected_Date_of_Completion;"Expected Date of Completion"){}
            column(Repayment;Repayment){}
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(DaysinArrears; "Days in Arrears")
            {
            }
            column(SasraCategory; "Sasra Category")
            {
            }
            column(DateOfBirth; DateOfBirth)
            {
            }
            column(Amount_Guaranteed;"Amount Guaranteed"){}
            trigger OnAfterGetRecord()
            begin
                DateOfBirth:=0D;
                if custrec.Get("Account No.") then
                Gender := custrec.Gender;
                "Employer Code" := custrec."Employer Code";
                "ID No." := custrec."ID No.";
                DateOfBirth := custrec."Date of Birth";
                if Source=Source::" " then
                Source:=Source::Credit;
                
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
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
        custrec: Record Member;
        DateOfBirth: Date;
}
