namespace DynamicsNav.SaccoDatabase;

using Microsoft.Foundation.Company;

report 50031 "Insider Lending II"
{
    ApplicationArea = All;
    Caption = 'Insider Lending';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {

    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the Starting Date.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin

        end;
    }
    labels
    {

    }
    trigger OnPreReport()
    begin

        Dfilter := '..' + Format(CalcDate('-1D', StartDate));
        Lfilter := Format(StartDate) + '..';

        Loans.Reset();
        Loans.SetFilter("Outstanding Balance", '>0');
        Loans.SetFilter("Disbursement Date", Lfilter);
        if Loans.FindSet() then begin
            repeat
            
                MemberCust.Reset();
                MemberCust.SetRange("No.", Loans."Account No.");
                MemberCust.SetFilter("Member Category", '%1|%2 | %3', 'STAFF', 'DIRECTOR', 'BOARD');
                if MemberCust.FindSet() then begin

                    Ploan.Init();
                    Ploan."No." := Loans."No.";
                    Ploan."Account No." := Loans."Account No.";
                    Ploan."Account Name" := Loans."Account Name";
                    Ploan."Product Type" := Loans."Product Type";
                    Ploan."Product Description" := Loans."Product Description";
                    Ploan."Requested Amount" := Loans."Requested Amount";
                    Ploan."Approved Amount" := Loans."Approved Amount";
                    Ploan."Repayment Start Date" := Loans."Repayment Start Date";
                    Ploan."Disbursement Date" := Loans."Disbursement Date";
                    Ploan.Installments := Loans.Installments;
                    Ploan."Payroll/Staff No." := Loans."Payroll/Staff No.";
                    Ploan.Insert(true);

                end;
            until Loans.Next() = 0;
        end;

        Loans.Reset();
        Loans.SetFilter("Outstanding Balance", '>0');
        Loans.SetFilter("Disbursement Date", Dfilter);
        if Loans.FindSet() then begin
            repeat
                MemberCust.Reset();
                MemberCust.SetRange("No.", Loans."Account No.");
                MemberCust.SetFilter("Member Category", '%1|%2 | %3', 'STAFF', 'DIRECTOR', 'BOARD');
                if MemberCust.FindSet() then begin
                    Ploan.Init();
                    Ploan."No." := Loans."No.";
                    Ploan."Account No." := Loans."Account No.";
                    Ploan."Account Name" := Loans."Account Name";
                    Ploan."Product Type" := Loans."Product Type";
                    Ploan."Product Description" := Loans."Product Description";
                    Ploan."Requested Amount" := Loans."Requested Amount";
                    Ploan."Approved Amount" := Loans."Approved Amount";
                    Ploan."Repayment Start Date" := Loans."Repayment Start Date";
                    Ploan."Disbursement Date" := Loans."Disbursement Date";
                    Ploan.Installments := Loans.Installments;
                    Ploan."Payroll/Staff No." := Loans."Payroll/Staff No.";
                    Ploan."System Non-Created" := true;
                    Ploan.Insert(true);

                end;
            until Loans.Next() = 0;
        end;
    end;

    trigger OnInitReport()
    begin


    end;

    trigger OnPostReport()
    begin


    end;

    var
        StartDate: Date;
        Loans: Record "Loans Categorization";
        Ploan: Record "Loans (Reporting)";
        Dfilter: Text[50];
        Lfilter: Text[50];
        MemberCust: Record Member;
}
