report 50217 "Checkoff Variance Report"
{
    ApplicationArea = All;
    Caption = 'Checkoff Variance Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CheckoffVariance.rdl';
    dataset
    {
        dataitem(CheckoffHeader; "Checkoff Header")
        {
            column(No; "No.")
            {
            }
            column(ApplicationType; "Application Type")
            {
            }
            dataitem("Checkoff Receipt Lines"; "Checkoff Receipt Lines")
            {
                DataItemLink = "No." = field("No.");
                column(No_; "No.")
                { }
                column(Member_No_; "Member No.")
                { }
                column(Employer_Code; "Employer Code")
                { }
                column(Payroll_Staff_No_; "Payroll/Staff No.")
                { }
                column(Name; Name)
                { }
                column(Amount; Amount)
                { }
                column(ExpectedAmt; Amt[3])
                { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin

                    Amt[1] := 0;
                    Amt[2] := 0;
                    Amt[3] := 0;
                    //Amount:=;

                    Loan.Reset();
                    Loan.SetRange("Account No.", "Member No.");
                    Loan.SetFilter("Outstanding Balance", '>0');
                    if Loan.FindSet() then begin
                        Loan.CalcSums(Repayment);
                        Amt[1] := Loan.Repayment;
                    end;

                    Contribt.Reset();
                    Contribt.SetRange("Account No.", "Member No.");
                    Contribt.SetFilter(Type, '<>%1|<>%2', Contribt.Type::" ", Contribt.Type::"Benevolent Fund");
                    if Contribt.FindSet() then begin
                        Contribt.CalcSums(Amount);
                        Amt[2] := Contribt.Amount;
                    end;

                    //Solution 1
                    /*  Contribt.Reset();
                    Contribt.SetRange("Account No.", "Member No.");
                    if Contribt.FindSet() then begin
                        if not (Contribt.Type in [Contribt.Type::" ", Contribt.Type::"Benevolent Fund"]) then begin
                            Contribt.CalcSums(Amount);
                            Amt[2] := Contribt.Amount;
                        end;
                    end;  */
//
                    //Solution 2
                     Contribt.Reset();
                    Contribt.SetRange("Account No.", "Member No.");
                    Contribt.SetFilter(Type, '<>%1|<>%2', Contribt.Type::" ", Contribt.Type::"Benevolent Fund");
                    if Contribt.FindSet() then begin
                        repeat
                            Amt[2] += Contribt.Amount;
                        until Contribt.Next() = 0;
                    end; 

                    Amt[3] := (Amt[1] + Amt[2]);
                end;

                trigger OnPostDataItem()
                begin

                end;
            }
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
        Amt: array[7] of Decimal;
        Loan: Record "Loans Categorization";
        AccBanking: Record "Account Banking";
        Contribt: Record "Member Monthly Contribution";

}



