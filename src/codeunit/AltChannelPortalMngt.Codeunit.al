codeunit 50062 "Alt. Channel Portal Mngt."
{
    trigger OnRun()
    begin

    end;

    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        PFactory: Record "Product Factory";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        RegMngt: Codeunit "Register Management";
        AccountTypes: Record "Product Factory";
        Post: Codeunit "Mngt. Post Alt. Channels";
        TransCharges: Record "Transaction Charge";
        TransTypes: Record "Transaction Types";
        TellerTransType: Enum TellerTypes;
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        RegmntAcc: Record "Account (Procedure)";
        LnPortal: Record "Loan Application-Portal";

    procedure LoanApplicationPortal(ApplicNo: code[100]; MemberNo: Code[100]; ProductType: Code[20]; AmountApplied: Decimal) Response: Text[150]
    
    begin
        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Capital");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");

                if AccountTypes.Get(AccCredit."Product Type") then begin
                    if AccCredit."Balance (LCY)" < AccountTypes."Minimum Balance" then
                        Response := '99|Member has not attained Minimum share capital of KES 50,000';
                    exit(Response)
                end;
            end;

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");
                if AccCredit."Balance (LCY)" > 0 then begin
                    LnPortal.Init();
                    LnPortal."No." := '';
                    LnPortal.Validate("Account No.", MemberNo);
                    LnPortal.Validate("Product Type", ProductType);
                    LnPortal.Validate("Requested Amount", AmountApplied);
                    LnPortal.Source := LnPortal.Source::Credit;
                    LnPortal."Application Source" := LnPortal."Application Source"::Web;
                    LnPortal."Application Type" := LnPortal."Application Type"::Portal;
                    LnPortal.Insert(true);
                end else begin
                    Response := '99|Member does not have shares';
                    exit(Response)
                end;
            end else begin
                Response := '99|Account not Found';
                exit(Response)

            end;

        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;

    procedure getAggreementDetails(ApplicNo: Code[100]; MemberNo: Code[100])
    begin


    end;

}



