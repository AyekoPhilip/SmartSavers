report 50383 "Posted Checkoff Variance"
{
    ApplicationArea = All;
    Caption = 'Posted Checkoff Variance';
    UsageCategory = ReportsAndAnalysis;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/PostedCheckoffVariance.rdl';
    dataset
    {
        dataitem(CheckoffHeader; "Checkoff Header")
        {
            DataItemTableView = where(Posted = const(true));
            column(No; "No.")
            { }
            column(AccountNo; "Account No.")
            { }
            column(AccountName; "Account Name")
            { }
            column(AccountType; "Account Type")
            { }
            column(Description; Description)
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(VarianceAmt; VarianceAmt[1])
            { }
            column(VarianceAmt2;VarianceAmt[2])
            {}
            dataitem("Checkoff Receipt Lines"; "Checkoff Receipt Lines")

            {
                DataItemLink = "No." = field("No.");
                column(Member_No_; "Member No.")
                { }
                column(Payroll_Staff_No_; "Payroll/Staff No.")
                { }
                column(Name; Name)
                { }
                column(Amount; Amount)
                { }
                column(ID_No_; "ID No.")
                { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    VarianceAmt[1] := 0;
                    VarianceAmt[2] := 0;

                    DetailedCustEntry.Reset();
                    DetailedCustEntry.SetRange("Document No.", "No.");
                    DetailedCustEntry.SetRange("Member No.", "Member No.");
                    if DetailedCustEntry.FindSet() then begin
                        DetailedCustEntry.CalcSums(Amount);
                        VarianceAmt[1] := Abs(DetailedCustEntry.Amount);
                    end;

                    DetailedVendEntry.Reset();
                    DetailedVendEntry.SetRange("Document No.", "No.");
                    DetailedVendEntry.SetRange("Member No.", "Member No.");
                    if DetailedVendEntry.FindSet() then begin
                        DetailedVendEntry.CalcSums(Amount);
                        VarianceAmt[2] := Abs(DetailedVendEntry.Amount);
                    end;
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
        VarianceAmt: array[7] of Decimal;
        DetailedCustEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedVendEntry: Record "Detailed Vendor Ledg. Entry";
}
