report 50228 "Defaulter Notice-3"
{
    ApplicationArea = All;
    Caption = 'Defaulter Notice-Within Deposit';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/DefaulterNotice3.rdl';
    dataset
    {
        dataitem("Loans Categorization"; "Loans Categorization")
        {

            DataItemTableView = where("Outstanding Balance" = filter(> 0));

            column(No; "Account No.")
            { }
            column(Name; "Account Name")
            { }
            column(MobilePhoneNo; CustPhone)
            { }
            column(Payroll_Staff_No_; "Payroll/Staff No.")
            { }
            column(EMail; EmailAddress)
            { }
            column(EmailPersonal; EmailAddress)
            { }
            column(EmployerCode; EmployerName)
            { }
            column(IDNo; "ID No.")
            { }
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
            column(LoanNo; "No.")
            { }
            column(Account_No_; "Account No.")
            { }
            column(Product_Description; "Product Description")
            { }
            column(Product_Type; "Product Type")
            { }
            column(Approved_Amount; "Approved Amount")
            { }
            column(Installments; Installments)
            { }
            column(Outstanding_Balance; "Outstanding Balance")
            { }
            column(Outstanding_Interest; "Outstanding Interest")
            { }
            column(Outstanding_Principal; "Outstanding Principal")
            { }
            column(Amount_In_Arrears; "Amount In Arrears")
            { }
            column(GeneralManagerName; GeneralManagerName)
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
                if Customer.Get("Employer Code") then
                    EmployerName := Customer.Name;

                if ObjectCust.Get("Account No.") then
                    CustPhone := ObjectCust."Mobile Phone No";
                EmailAddress := ObjectCust."E-Mail";

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
                group(Signatories)
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
        ObjectCust: Record Member;
        CustPhone: Code[20];
        EmailAddress: Code[20];

}



