namespace SaccoDB.SaccoDB;
using Microsoft.Foundation.Company;

report 90022 "Deposit Insurance Report"
{
    ApplicationArea = All;
    Caption = 'Deposit Insurance Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DepositInsuranceReport.rdl';

    dataset
    {
        dataitem("Account Credit";"Account Credit")
        {


            RequestFilterFields = "No.", "Product Type","Member No.", "Registration Date";
            DataItemTableView = where("Product Type" = CONST('DP-00103'));
            column(CInfo_Name; cinfo.name)
            { }
            column(CInfo_Picture; CInfo.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(No; "No.")
            { }
            column(Member_No_;"Member No.")
            { }
            column(Name;Name)
            { }

            column(IDNo; IDNUM)
            { }
            column(Gender;Gen)
            {}
            column(DOB;DOB)
            { }
            column(Outstanding_Principal;BALANCE)
            { }
            trigger OnPreDataItem()
            begin
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;
                CInfo.Get();
                CInfo.CalcFields(CInfo.Picture);
                CompanyAddress := CInfo.Address + ' -Post Code: ' +
                CInfo."Post Code" + ' -City:' +
                CInfo.City + ' Region: ' + CInfo."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CInfo."Phone No." + ' -Office Tel: ' + CInfo."Phone No. 2";
                //CommunicationOnline := 'E-mail: ' + CInfo."E-Mail" + '- Website: ' + CInfo."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                
     IF MEM.GET("Account Credit"."Member No.") THEN begin
     DOB := 0D;
                DOB := MEM."Date of Birth";
                Gen := '';
                Gen := Format(MEM.Gender);
                IDNUM:='';
                IDNUM:=MEM."ID No.";
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
        CInfo: Record "Company Information";
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
        MEM:Record Member;
        gen: Text;
        IDNUM:Code[20];
        

}



