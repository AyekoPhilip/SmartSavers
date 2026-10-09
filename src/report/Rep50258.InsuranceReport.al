report 50258 "Insurance Report"
{
    ApplicationArea = All;
    Caption = 'Insurance Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/InsuranceReport.rdl';

    dataset
    {
        dataitem(Loans; Loans)
        {


            RequestFilterFields = "No.", "Product Type", "Account No.", "Disbursement Date";
            DataItemTableView = where("Approval Status" = CONST(Posted));
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
            column(No; "No.")
            { }
            column(Account_No_; "Account No.")
            { }
            column(Account_Name; "Account Name")
            { }
            column(Approved_Amount; "Approved Amount")
            { }
            column(IDNo; "ID No.")
            { }
            column(Disbursement_Date; "Disbursement Date")
            { }
            column(remperiod; remperiod)
            { }
            column(PayrollStaffNo; "Payroll/Staff No.")
            { }
            column(Installments; Installments)
            { }
            column(Product_Description; "Product Description")
            { }
            column(LoanBal; Amt[3])
            { }
            column(Gender; Gen)
            { }
            column(DOB; DOB)
            { }
            column(Outstanding_Principal; "Outstanding Principal")
            { }
            trigger OnPreDataItem()
            begin
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                Amt[1] := 0;
                Amt[2] := 0;
                Amt[3] := 0;
                remperiod := 0;

                IF Loans."Expected Date of Completion" <> 0D THEN Begin
                remperiod := round((Loans."Expected Date of Completion" - EndDate) / 30, 1, '=');
                end;
                
                if remperiod < 0 then
                    remperiod := 0;
                IF MEM.GET(Loans."Account No.") THEN begin
                    DOB := 0D;
                    DOB := MEM."Date of Birth";
                    Gen := '';
                    Gen := Format(MEM.Gender);
                end;
            END;

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
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        Visible = false;
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        Visible = false;
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
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        Loan: Record Loans;
        Accredit: Record "Account Credit";
        Amt: array[4] of Decimal;
        SNo: Integer;
        DateFilter: Text;
        remperiod: Integer;
        DOB: Date;
        MEM: Record Member;
        gen: Text;

}



