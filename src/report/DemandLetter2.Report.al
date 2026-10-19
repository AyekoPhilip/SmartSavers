report 50230 "Demand Letter 2"
{
    ApplicationArea = All;
    Caption = 'Demand Letter 2';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/DemandLetter2.rdl';

    dataset
    {
        dataitem(Member; Member)
        {
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(MobilePhoneNo; "Mobile Phone No")
            {
            }
            column(Payroll_Staff_No_; "Payroll/Staff No.")
            { }
            column(EMail; "E-Mail")
            {
            }
            column(EmailPersonal; "E-mail (Personal)")
            {
            }
            column(EmployerCode; EmployerName)
            {
            }

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
            dataitem("Loans Categorization"; "Loans Categorization")
            {
                DataItemLink = "Account No." = field("No.");
                DataItemTableView = where("Outstanding Balance" = filter(> 0));
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

            }
            trigger OnPreDataItem()
            begin

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' - ' + CompanyInformation."Post Code" + ' ,' +
                CompanyInformation.City + ' , ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";
                //CommunicationOnlineHomePage := 'Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                if ObjectEmp.Get(GeneralManager) then
                    GeneralManagerName := ObjectEmp."Last Name" + ' ' + ObjectEmp."First Name" + ' ' + ObjectEmp."Middle Name";
                if Customer.Get("Employer Code") then
                    EmployerName := Customer.Name;

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
}



