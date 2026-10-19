report 50293 "Loans Paid Within Month"
{


    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoansPaidWithinMonth.rdl';
    ApplicationArea = All;
    dataset
    {
        dataitem(Loans; "Loans Categorization")
        {

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
            column(LoanNo; Loans."No.")
            { }
            column(MemberNo; Loans."Account No.")
            { }
            column(MemberName; Loans."Account Name")
            { }
            column(LoanType; Loans."Product Type")
            { }
            column(RequestedAmount; Loans."Requested Amount")
            { }
            column(ApprovedAmount; Loans."Approved Amount")
            { }
            column(Total_TopUp; "Total TopUp")
            { }
            column(Amount_to_Disburse; "Amount to Disburse")
            { }
            column(Installments; Loans.Installments)
            { }
            column(Interest_Rate; "Interest Rate")
            { }
            column(Repayment; Repayment)
            { }
            column(DisbursementDate; Loans."Disbursement Date")
            { }
            column(Expected_Date_of_Completion; "Expected Date of Completion")
            { }
            column(Outstanding_Interest; "Outstanding Interest")
            { }
            column(Outstanding_Principal; "Outstanding Principal")
            { }
            column(Outstanding_Balance; "Outstanding Balance")
            { }
            column(Performance_Indicator; "Performance Indicator")
            { }
            column(Last_Pay_Date; "Last Pay Date")
            { }
            column(Picture; Company.Picture)
            { }
            column(Address; Company.Address)
            { }
            column(Company_Name; Company.Name)
            { }
            column(TopUpComms; TopUpComms)
            { }
            column(MinuteNo; MinuteNo)
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
                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('Start and End Date must have a value. It cannot be null');
            end;

            trigger OnAfterGetRecord()
            begin
                CalcFields("Outstanding Balance");
                if ("Outstanding Balance" = 0) and ("Approval Status" = "Approval Status"::Posted) then begin
                    MinuteNo := '';
                    if Loan.Get("No.") then begin
                        MinuteNo := Loan."Minute No.";
                    end;
                    CalcFields("Last Pay Date");
                    if ("Disbursement Date" < StartDate) and ("Last Pay Date" > EndDate) then
                        CurrReport.Skip();

                end else begin
                    CurrReport.Skip();

                end;
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
            area(Content)
            {
                group(GroupName)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;

                    }

                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if Company.Get() then
            Company.CalcFields(Company.Picture);
    end;

    var
        Company: Record "Company Information";
        LoanAppcharges: Record "Loan Product Charges";
        TopUpComms: Decimal;
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CompanyInformation: Record "Company Information";
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        ExciseDuty: Decimal;
        GeneralSetUp: Record "General Set-Up";
        Loan: Record Loans;
        StartDate: Date;
        EndDate: Date;
        MinuteNo: Code[50];

}



