report 50255 "Payment Certificate"
{
    ApplicationArea = All;
    Caption = 'Payment Certificate';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/PaymentCertificate.rdl';

    dataset
    {
        dataitem(Loans; Loans)
        {
            RequestFilterFields = "No.", "Account No.", "Product Type";
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(AccountNo; "Account No.")
            { }
            column(NumberText; NumberText[1])
            { }
            column(No; "No.")
            { }
            column(AccountName; "Account Name")
            { }
            column(ApprovedAmount; "Approved Amount")
            { }
            column(OutstandingBalance; "Outstanding Balance")
            { }
            column(IDNo; "ID No.")
            { }
            column(Salutation; Salutation)
            { }
            column(GeneralManagerName; GeneralManagerName)
            { }
            column(AmtDeducted; AmtDeducted)
            { }
            dataitem("Guarantor & Security Posted"; "Guarantor & Security Posted")
            {
                DataItemLink = "Loan No." = field("No.");
                RequestFilterFields = "Account No.";
                column(No_; "No.")
                { }
                column(Account_No_; "Account No.")
                { }
                column(Name; Name)
                { }
                column(ID_No_; "ID No.")
                { }
                column(Loan_No_; "Loan No.")
                { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    AmtDeducted := 0;

                    LoanRecvMngt.Reset();
                    LoanRecvMngt.SetRange("Loan No.", "Loan No.");
                    LoanRecvMngt.SetRange("Account No.", "Account No.");
                    if LoanRecvMngt.FindFirst() then begin
                        AmtDeducted := LoanRecvMngt."Shares Deducted";
                    end;
                    CheckReport.InitTextVariable();
                    CheckReport.FormatNoText(NumberText, AmtDeducted, '');

                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
            end;

            trigger OnAfterGetRecord()
            begin
                if CustMember.Get("Account No.") then
                    case CustMember.Gender of
                        CustMember.Gender::Male:
                            Salutation := 'He';
                        CustMember.Gender::Female:
                            Salutation := 'She';
                        CustMember.Gender::" ",
                    CustMember.Gender::Other:
                            Salutation := CustMember."Last Name"
                    end;
                if ObjectEmp.Get(GeneralManager) then
                    GeneralManagerName := ObjectEmp."Last Name" + ' ' + ObjectEmp."First Name" + ' ' + ObjectEmp."Middle Name";

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
                group(Signature)
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
        AmtDeducted: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CustMember: Record Member;
        Salutation: Text[100];
        LoanRecvMngt: Record "Loan Recovery Mngt.";
        NumberText: array[2] of Text[80];
        CheckReport: Report Check;
        GeneralManager: Text;
        GeneralManagerName: Text;
        ObjectEmp: Record Employee;

}



