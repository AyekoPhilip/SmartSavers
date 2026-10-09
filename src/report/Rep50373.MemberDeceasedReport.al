report 50373 "Member-Deceased Report"
{
    ApplicationArea = All;
    Caption = 'Member-Deceased Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/DeceasedMembers.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.", "Employer Code";
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(WithdrwalDate; "Withdrawal Date")
            {
            }
            column(FileNo; "File No.")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(MobilePhoneNo; "Mobile Phone No")
            {
            }
            column(Status; Status)
            {

            }
            column(Gender; Gender)
            {
            }
            column(ShareCapBalance; AccBalance[1])
            { }
            column(ShareDepBalance; AccBalance[2])
            { }
            column(FosaBalance; AccBalance[3])
            { }
            column(LoanBalance; AccBalance[4])
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if Status <> Status::Deceased then CurrReport.Skip();
                AccBalance[1] := 0;
                AccBalance[2] := 0;
                AccBalance[3] := 0;
                AccBalance[4] := 0;

                AccBalance[1] := RegMngt.GetMemberAccBalance(ProdtCategory::"Shares Capital", "No.", 2);
                AccBalance[2] := RegMngt.GetMemberAccBalance(ProdtCategory::"Shares Deposit", "No.", 2);
                AccBalance[3] := RegMngt.GetMemberAccBalance(ProdtCategory::Savings, "No.", 1);
                AccBalance[4] := RegMngt.GetMemberAccBalance(ProdtCategory::" ", "No.", 3);

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
        AccBanking: Record "Account Banking";
        BosaAcc: Record "Account Credit";
        ProdtCategory: Enum ProductAccountCategory;
        AccBalance: array[7] of Decimal;
        RegMngt: Codeunit "Register Management";
}



