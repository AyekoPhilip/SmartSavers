report 50332 "Sasra Sectoral Lending Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/SasraSectoralLendingReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Purpose"; "Loan Purpose")
        {
            RequestFilterFields = "Code", Sector, "Sub Sector";
            column(Code_LoanPurpose; "Loan Purpose".Code)
            {
            }
            column(Description_LoanPurpose; "Loan Purpose".Description)
            {
            }
            column(Sector_LoanPurpose; "Loan Purpose".Sector)
            {
            }
            column(SubSector_LoanPurpose; "Loan Purpose"."Sub Sector")
            {
            }
            column(Sect; Descript[1])
            {
            }
            column(SubSec; Descript[2])
            {
            }
            column(Totsect; Amt[1])
            {
            }
            column(Totsubsect; Amt[2])
            {
            }
            column(TotLoanPurpose; Amt[3])
            {
            }
            column(Amount_LoanPurpose; "Loan Purpose".Amount)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Amt[1] := 0;
                Amt[2] := 0;
                Amt[3] := 0;

                if Sektor.Get(Sector) then begin
                    Descript[1] := Sektor.Description
                end;

                if Subsector.Get("Sub Sector") then begin
                    Descript[2] := Subsector.Description
                end;

                if LoanPurposes.Get(Code) then begin
                    Descript[3] := LoanPurposes.Description
                end;

                PLoan.Reset;
                PLoan.SetRange(Sectors, Sector);
                if PLoan.Find('-') then begin
                    PLoan.CalcSums(PLoan."Approved Amount");
                    Amt[1] := Round(PLoan."Approved Amount", 1, '=')
                end;

                PLoan.Reset;
                PLoan.SetRange("Sub Sectors", "Sub Sector");
                if PLoan.Find('-') then begin
                    PLoan.CalcSums(PLoan."Approved Amount");
                    Amt[3] := Round(PLoan."Approved Amount", 1, '=')
                end;

                PLoan.Reset;
                PLoan.SetRange("Purpose of Loan", '4110');
                if PLoan.Find('-') then begin
                    PLoan.CalcSums(PLoan."Approved Amount");
                    Amt[3] := Round(PLoan."Approved Amount", 1, '=')
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PLoan: Record Loans;
        CompanyInfo: Record "Company Information";
        Descript: array[7] of Text[250];
        Sektor: Record "Sasra Sector";
        Subsector: Record "Sasra-Sub Sector";
        LoanPurposes: Record "Loan Purpose";
        Amt: array[7] of Integer;
}




