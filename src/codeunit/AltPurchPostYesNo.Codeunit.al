namespace DynamicsNav.SaccoDatabase;

codeunit 90006 "Alt. Purch.-Post. (Yes/No)"
{
    var
        ErrorExisfaclity: Label 'Member has an existing Loan running';

    procedure OnAfterCheckDeferralPostAccount(isChannel: Boolean; IsHandled: Code[100]): Boolean
    var
        RegmntAcc: Record "Account (Procedure)";
    begin
        RegmntAcc.Reset();
        RegmntAcc.SetRange("Member No.", IsHandled);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if RegmntAcc.FindFirst() then begin
            exit(true)
        end;
        exit(false)
    end;

   /// [EventSubscriber(ObjectType::Codeunit, codeunit::"Alt. Channel (Mobile Mngt.)", 'OnBeforeCheckDeferralPostAccount', '', false, false)]

    local procedure OnBeforeCheckDeferralPostAccount(isChannel: Boolean; IsHandled: Code[100]; PtyLoad: Code[10])
    var
        ExistLoan: Record Loans;
    begin

        ExistLoan.Reset();
        ExistLoan.SetRange("Account No.", IsHandled);
        ExistLoan.SetRange("Product Type", PtyLoad);
        ExistLoan.SetFilter("Outstanding Balance", '>0');
        IF ExistLoan.FindFirst() then begin
            ExistLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
            Error(ErrorExisfaclity)
        end
    end;
}
