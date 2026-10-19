report 50375 "Member Withdrawal Report"
{
    ApplicationArea = All;
    Caption = 'Member Withdrawal Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/MemberWithdrawalReport.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.", "Employer Code", Status;
            
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
            column(RefundBalance; AccBalance[3])
            { }
            column(LoanBalance; AccBalance[4])
            { }
            column(Charges; AccBalance[5])
            { }
            column(ExitCharge; AccBalance[6])
            { }
            column(DocNo; DocNo)
            { }
            column(Remarks; Remarks)
            { }
            column(ReasonForWithdrawal; ReasonForWithdrawal)
            { }
            column(FosaAcc; FosaAcc)
            { }
            column(PostingDate; PostingDate)
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if Status <> Status::Withdrawn then CurrReport.Skip();

                AccBalance[1] := 0;
                AccBalance[2] := 0;
                AccBalance[3] := 0;
                AccBalance[4] := 0;
                AccBalance[5] := 0;
                AccBalance[6] := 0;
                PostingDate := 0D;

                DocNo := '';
                Remarks := '';
                ReasonForWithdrawal := '';
                FosaAcc := '';

                AccBanking.Reset();
                AccBanking.SetRange("Member No.", "No.");
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then begin
                    FosaAcc := AccBanking."No.";
                end;

                ClosureAc.Reset();
                ClosureAc.SetRange("Member No.", "No.");
                ClosureAc.SetRange(Posted, true);
                if ClosureAc.FindFirst() then begin
                    DocNo := ClosureAc."No.";
                    Remarks := ClosureAc.Remarks;
                    PostingDate := ClosureAc."Date Posted";
                    AccBalance[1] := ClosureAc."Shares Capital";
                    AccBalance[2] := ClosureAc."Member Savings";
                    AccBalance[3] := ClosureAc."Deposit Refundable";
                    AccBalance[4] := ClosureAc."Total Loan";
                    AccBalance[5] := ClosureAc."Other Charges";
                    AccBalance[6] := ClosureAc."Early Exit Charges";
                end else begin
                    CurrReport.Skip();
                end;

                Notices.Reset();
                Notices.SetRange("Member No.", "No.");
                if Notices.FindFirst() then begin
                    Segments.Reset();
                    Segments.SetRange(Code, Notices."Reason for withdrawal");
                    if Segments.FindFirst() then begin
                        ReasonForWithdrawal := Segments.Description;
                        if Notices."Reason for withdrawal" = '10' then
                         ReasonForWithdrawal := '';
                    end;
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
        FosaAcc: Code[100];
        PostingDate: Date;
        BosaAcc: Record "Account Credit";
        ProdtCategory: Enum ProductAccountCategory;
        AccBalance: array[7] of Decimal;
        RegMngt: Codeunit "Register Management";
        ClosureAc: Record "Membership closure";
        Notices: Record "Member withdrawal Notice";
        Remarks: Text[250];
        DocNo: Code[100];
        ReasonForWithdrawal: Text[250];
        Segments: Record "Segment/County/Dividend/Signat";
}



