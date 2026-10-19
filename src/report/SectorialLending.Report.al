report 50207 "Sectorial Lending"
{
    ApplicationArea = All;
    Caption = 'Sectorial Lending';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/SectorialLending.rdl';
    dataset
    {
        dataitem(LoanPurpose; "Loan Purpose")
        {
            RequestFilterFields="Date Filter",Sector,"Sub Sector",Code;
            
            column(Code; "Code")
            {
            }
            column(Description; Description)
            {
            }
            column(Sector; Sector)
            {
            }
            column(SubSector; "Sub Sector")
            {
            }
            column(Amount; Amount)
            {
            }
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
            column(Sect; Descript[1])
            { }
            column(SubSec; Descript[2])
            { }
            trigger OnAfterGetRecord()
            begin
                AppAmount[1] := 0;
                AppAmount[2] := 0;
                AppAmount[3] := 0;

                IF Sektor.GET(Sector) THEN BEGIN
                    Descript[1] := Sektor.Description
                END;

                IF Subsector.GET("Sub Sector") THEN BEGIN
                    Descript[2] := Subsector.Description
                END;

                IF LoanPurposes.GET(Code) THEN BEGIN
                    Descript[3] := LoanPurposes.Description
                END;

                PLoan.RESET;
                PLoan.SETRANGE(Sectors, Sector);
                IF PLoan.FIND('-') THEN BEGIN
                    PLoan.CALCSUMS(PLoan."Approved Amount");
                    AppAmount[1] := ROUND(PLoan."Approved Amount", 1, '=')
                END;

                PLoan.RESET;
                PLoan.SETRANGE("Sub Sectors", "Sub Sector");
                IF PLoan.FIND('-') THEN BEGIN
                    PLoan.CALCSUMS(PLoan."Approved Amount");
                    AppAmount[3] := ROUND(PLoan."Approved Amount", 1, '=')
                END;

            end;
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
                SavingsAccountName := '';
                BalanceBF := 0;
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;
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
        BalanceBF: Decimal;
        LoanPurposes: Record "Loan Purpose";
        CName: Text[150];
        AppAmount: array[7] of Decimal;
        Disdate: Date;
        OutBal: Decimal;
        PLoan: Record "Loans Categorization";
        Descript: array[7] of Text[250];
        Sektor: Record "Sasra Sector";
        Subsector: Record "Sasra-Sub Sector";
        SavingsAccountName: Text;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[10];
        CustAddress: Code[100];
}



