report 50256 "Guarantor Payment Certificate"
{
    ApplicationArea = All;
    Caption = 'Guarantor Payment Certificate';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/GuarantorPaymentCertificate.rdl';
    dataset
    {
        dataitem(GuarantorSecurityPosted; "Guarantor & Security Posted")
        {
            RequestFilterFields = "Account No.";
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
            column(Salutation; Salutation)
            { }
            column(GeneralManagerName; GeneralManagerName)
            { }
            column(AmtDeducted; AmtDeducted)
            { }
            column(DefaultedAmt; DefaultedAmt)
            { }
            column(IDNo; AccID)
            { }
            column(AccName; AccName)
            { }
            column(AccNo; AccNo)
            { }
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
            column(Outstanding_Balance; "Outstanding Balance")
            { }
            column(Salutation1; Salutation1)
            { }
            column(Salutation2; Salutation2)
            { }
            column(Salut3; Salut3)
            { }

            trigger OnPreDataItem()
            begin
                Gensetup.Get();
                Gensetup.CalcFields("Letter Header");

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
              // CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin

                if Loans.Get("Loan No.") then begin
                    AccID := Loans."ID No.";
                    AccName := Loans."Account Name";
                    AccNo := Loans."Account No.";
                end;

                AmtDeducted := 0;
                DefaultedAmt := 0;
                RecoverHeader.Reset();
                RecoverHeader.SetRange("Loan No.", "Loan No.");
                RecoverHeader.SetRange("Application Type", RecoverHeader."Application Type"::"Recover from guarantors");
                if RecoverHeader.FindFirst() then begin
                    RecoverHeader.CalcFields(RecoverHeader."Total Amount LCY");

                    LoanRecvMngt.Reset();
                    LoanRecvMngt.SetRange("Loan No.", "Loan No.");
                    LoanRecvMngt.SetRange("Account No.", "Account No.");
                    if LoanRecvMngt.FindFirst() then begin
                        AmtDeducted := LoanRecvMngt.Amount;
                        DefaultedAmt := RecoverHeader."Total Amount LCY";
                    end;
                end;

                Salutation := '';
                Salutation1 := '';
                Salutation2 := '';
                Salut3 := '';
                if CustM.Get("Member No. (Loanee)") then begin
                    if CustM.Gender = CustM.Gender::Male then
                        Salut3 := 'his' else
                        Salut3 := 'her'
                end;
                if CustMember.Get("Member No.") then
                    case CustMember.Gender of
                        CustMember.Gender::Male:
                            begin
                                Salutation := 'he';
                                Salutation1 := 'his';
                                Salutation2 := 'him';
                            end;
                        CustMember.Gender::Female:
                            begin
                                Salutation := 'she';
                                Salutation1 := 'her';
                                Salutation2 := 'her';
                            end;
                        CustMember.Gender::" ",
                        CustMember.Gender::Other:
                            begin
                                Salutation := CustMember."Last Name";
                                Salutation1 := 'them';
                                Salutation2 := 'them';
                            end;
                    end;
                if ObjectEmp.Get(GeneralManager) then
                    GeneralManagerName := ObjectEmp."Last Name" + ' ' + ObjectEmp."First Name" + ' ' + ObjectEmp."Middle Name";

                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, AmtDeducted, '');

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
        DefaultedAmt: Decimal;
        Gensetup: Record "General Set-Up";
        Loans: Record Loans;
        RecoverHeader: Record "Recovery Header";
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CustMember: Record Member;
        Salutation: Text[100];
        Salutation1: Text[100];
        Salutation2: Text[100];
        LoanRecvMngt: Record "Loan Disbursement Lines";
        NumberText: array[2] of Text[80];
        CheckReport: Report Check;
        GeneralManager: Text;
        GeneralManagerName: Text;
        ObjectEmp: Record Employee;
        AccName: Text[150];
        AccID: Code[20];
        AccNo: Code[50];
        Salut3: Text;
        CustM: Record Member;

}



