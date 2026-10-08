report 90000 "Account Closure Normal"
{
    ApplicationArea = All;
    Caption = 'Membership Closure';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/ClosureMembership.rdl';

    dataset
    {

        dataitem("Account Closure Line"; "Account Closure Line")
        {
            RequestFilterFields="No.";
            column(No_; "No.") { }

            column(CompInformation; CompanyInformation.Name)
            {
            }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyTelephone; CompanyTelephone)
            {
            }
            column(CommunicationOnline; CommunicationOnline)
            {
            }

            column(ReasonText; ReasonText)
            {

            }
            column(ProductDescription; ProductDescription) { }
            column(Producttype; Producttype) { }
            column(Account_No_; "Account No.") { }
            column(Account_Category; "Account Category") { }
            column(Name; Name) { }
            column(Product_Type; "Product Type") { }
            column(Loan_No_; "Loan No.") { }
            column(Outstanding_Interest; "Outstanding Interest") { }
            column(Outstanding_Principal; "Outstanding Principal") { }
            column(Balance; Balance) { }
            column(Amount_to_Post; "Amount to Post") { }
            column(Net_Amount; "Net Amount") { }
            column(customerno; customerno) { }
            column(customername; customername) { }
            column(noticeno; noticeno) { }
            column(chequeno; chequeno) { }
            column(ClosingDate; ClosingDate) { }
            column(accName; Name) { }

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
            end;

            trigger OnAfterGetRecord()
            begin
                customerno := '';
                customername := '';
                noticeno := '';
                chequeno := '';
                ClosingDate := 0D;
                if accountclosure.Get("No.") then
                    if not accountclosure.Posted then CurrReport.Skip();
                

                if NoticeRec.Get(accountclosure."Notice No.") then
                    ReasonText := NoticeRec."Description For Withdrawal" else
                    ReasonText := '';

                customerno := accountclosure."Member No.";
                customername := accountclosure."Member Name";
                noticeno := accountclosure."Notice No.";
                chequeno := accountclosure."Rcv Cheque No";
                ClosingDate := accountclosure."Posting Date";

                if Loantype.Get("Product Type") then
                    ProductDescription := Loantype.Description
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
        closureLine: Record "Account Closure Line";
        Loantype: Record "Product Factory";
        accountclosure: Record "Membership closure";
        NoticeRec: Record "Member withdrawal Notice";
        ProductDescription: Text[150];
        ReasonText: Text[200];
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        customerno: Code[100];
        customername: Text[150];
        noticeno: Code[50];
        chequeno: Code[100];
        ClosingDate: Date;

        CompanyTelephone: Text;
        CommunicationOnline: Text;
        Producttype: Code[20];
}



