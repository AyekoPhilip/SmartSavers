report 50260 "Demand Letter 3"
{
    ApplicationArea = All;
    Caption = 'Demand Letter 3';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DemandLetter3.rdl';
    dataset
    {
        dataitem(RecoveryHeader; "Recovery Header")
        {
            column(CompanyInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(CommunicationOnlineHomePage; CommunicationOnlineHomePage)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(EmployerCode; EmployerName)
            { }
            column(AccountNo; "Account No.")
            { }
            column(ApplicationType; "Application Type")
            { }
            column(ApprovalStatus; "Approval Status")
            { }
            column(LoanNo; "Loan No.")
            { }
            column(Name; Name)
            {
            }
            column(NoofActiveLoans; "No of Active Loans")
            {
            }
            column(No; "No.")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingBill; "Outstanding Bill")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(SharesDeductable; "Shares Deductable")
            {
            }
            column(SharesDeposits; "Shares Deposits")
            {
            }
            column(TotalAmountLCY; "Total Amount LCY")
            {
            }
            column(TotalLoansBal; "Total Loans Bal.")
            { }
            column(TransactionType; "Transaction Type")
            { }
            column(PhoneNo; PhoneNo)
            { }
            column(ProdDescription; ProdDescription)
            { }
            column(GeneralManagerName; GeneralManagerName)
            { }
            column(NetAmount; NetAmount)
            { }
            trigger OnPreDataItem()
            begin

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' - ' + CompanyInformation."Post Code" + ' ,' +
                CompanyInformation.City + ' , ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";
               // CommunicationOnlineHomePage := 'Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin

                if ObjectEmp.Get(GeneralManager) then
                    GeneralManagerName := ObjectEmp."Last Name" + ' ' + ObjectEmp."First Name" + ' ' + ObjectEmp."Middle Name";
                if CustMember.Get("Account No.") then
                    if Customer.Get(CustMember."Employer Code") then
                        EmployerName := Customer.Name;
                PhoneNo := CustMember."Mobile Phone No";

                if Loan.Get("Loan No.") then
                    ProdDescription := Loan."Product Description";
                NetAmount := ("Outstanding Balance" - "Shares Deductable");

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
                    field(GeneralManager; GeneralManager)
                    {
                        Caption = 'Head of Credit';
                        TableRelation = Employee;
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
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        Customer: Record Customer;
        EmployerName: Text[150];
        CommunicationOnline: Text;
        CommunicationOnlineHomePage: Text;
        GeneralManager: Text;
        GeneralManagerName: Text;
        ObjectEmp: Record Employee;
        RecovHeader: Record "Recovery Header";
        LoanNo: Code[50];
        Deposits: Decimal;
        CustMember: Record Member;
        PayrollNo: Code[50];
        PhoneNo: Code[20];
        Loan: Record Loans;
        ProdDescription: Text[150];
        NetAmount: Decimal;

}



