report 50300 "Dividend Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DividendRegister2.rdl';
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Members; Member)
        {
            RequestFilterFields = "No.", Status, "Employer Code";
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
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
            column(No_Members; Members."No.")
            {
            }
            column(Name_Members; Members.Name)
            {
            }
            column(Payroll_Staff_No_;"Payroll/Staff No.")
            {}
            column(Shares_DividendProgression; Amount[1])
            {
            }
            column(QualifyingShares_DividendProgression; Amount[2])
            {
            }
            column(GrossDividends_DividendProgression; Amount[3])
            {
            }
            column(WitholdingTax_DividendProgression; Amount[4])
            {
            }
            column(NetDividends_DividendProgression; Amount[5])
            {
            }

            trigger OnAfterGetRecord()
            begin
                DividendProgression.Reset;
                DividendProgression.SetRange(DividendProgression."Member No", Members."No.");
                if DividendProgression.Find('-') then begin
                    DividendProgression.CalcSums(DividendProgression.Shares, DividendProgression."Qualifying Shares", DividendProgression."Gross Dividends",
                                                 DividendProgression."Witholding Tax", DividendProgression."Net Dividends");

                    Amount[1] := DividendProgression.Shares;
                    Amount[2] := DividendProgression."Qualifying Shares";
                    Amount[3] := DividendProgression."Gross Dividends";
                    Amount[4] := DividendProgression."Witholding Tax";
                    Amount[5] := DividendProgression."Net Dividends";


                end else
                    CurrReport.Skip;
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

    trigger OnPreReport()
    begin
        if CompanyInformation.Get then
            CompanyInformation.CalcFields(CompanyInformation.Picture);
        CompanyAddress := CompanyInformation.Address + ' -Post Code: ' + CompanyInformation."Post Code" + ' -City:' + CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
        CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
       // CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' + CompanyInformation."Home Page";
    end;

    var
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        CompanyInformation: Record "Company Information";
        DividendProgression: Record "Dividend Progression";
        Amount: array[10] of Decimal;
}




