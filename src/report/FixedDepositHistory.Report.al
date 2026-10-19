report 50268 "Fixed Deposit History"
{
    ApplicationArea = All;
    Caption = 'Fixed Deposit History';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/FixedDepositHistory.rdl';
    dataset
    {
        dataitem(FixedDepositHistory; "Fixed Deposit History")
        {
            column(CompanyInformation_Name; CompanyInformation.Name)
            { }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(AccountNo; "Account No.")
            {
            }
            column(FDDuration; "FD Duration")
            {
            }
            column(FDMaturityDate; "FD Maturity Date")
            {
            }
            column(FDMaturityInstructions; "FD Maturity Instructions")
            {
            }
            column(FixedAmount; "Fixed Amount")
            {
            }
            column(FixedDepositType; "Fixed Deposit Type")
            {
            }
            column(InterestEarned; "Interest Earned")
            {
            }
            column(NegInterestRate; "Neg. Interest Rate")
            {
            }
            column(No; No)
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(AcStatus; AcStatus)
            { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
               // CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                if Accounts.Get(No) then
                    AcStatus := Accounts.Status;
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
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        Accounts: Record "Account Banking";
        AcStatus: Enum MemberStatus;
        SNo: Integer;
}



