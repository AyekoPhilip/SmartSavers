report 50236 "Loans Topup"
{
    ApplicationArea = All;
    Caption = 'Loans Topup';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoansTopupRegister.rdl';

    dataset
    {
        dataitem(LoansTopupPosted; "Loans Top up Posted")
        {
            column(AccountNo; "Account No.")
            { }
            column(Commision; Commision)
            { }
            column(LoanNo; "Loan No.")
            { }
            column(LoanTopUp; "Loan Top Up")
            { }
            column(No; "No.")
            { }
            column(OutstandingBalance; "Outstanding Balance")
            { }
            column(OutstandingBill; "Outstanding Bill")
            { }
            column(OutstandingFee; "Outstanding Fee")
            { }
            column(OutstandingInterest; "Outstanding Interest")
            { }
            column(OutstandingPrinciple; "Outstanding Principle")
            { }
            column(ProductType; "Product Type")
            { }
            column(Loandescription;Loandescription)
            {}
            column(TotalAmount; "Total Amount")
            { }
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
            column(Address; Company.Address)
            { }
            column(AppAmount; AppAmount)
            { }
            column(Instllment; Instllment)
            { }
            column(AccName; AccName)
            { }

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
                if Loans.Get("Loan No.") then begin
                    AppAmount := Loans."Approved Amount";
                    Instllment := Loans.Installments;
                    AccName := Loans."Account Name";
                    Loandescription:=loans."Product Description";
                end else begin
                    AppAmount := 0;
                    Instllment := 0;
                    AccName := '';
                    Loandescription:='';
                end;
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
        Company: Record "Company Information";
        LoanAppcharges: Record "Loan Product Charges";
        TopUpComms: Decimal;
        CompanyAddress: Text;
        Loans: Record Loans;
        Loandescription: code[100];
        AppAmount: Decimal;
        AccName: Text[150];
        Instllment: Integer;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CompanyInformation: Record "Company Information";
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        ExciseDuty: Decimal;
        GeneralSetUp: Record "General Set-Up";
}



