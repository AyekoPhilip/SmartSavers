tableextension 50003 "BankAccLedgEntryExt" extends "Bank Account Ledger Entry"

{

    fields
    {
        field(50009; "Investment Code"; Code[100])
        {
            Caption = 'Investment Code';
            DataClassification = CustomerContent;
        }
        field(50010; "No. of Units"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Units';
        }
         field(50011; "Member No"; Code[50])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
        }
        field(50012;"Statement Difference";Decimal)
        {
            DataClassification = CustomerContent;

        }
    }
    procedure ResolveMemberNo()
    var
        Receipt: Record "Receipts Header";
        Loan: Record Loans;
    begin
        if "Member No" <> '' then
            exit;
        if Receipt.Get("Document No.") then
            "Member No" := Receipt."Member No."
        else
            if Loan.Get("Document No.") then
                "Member No" := Loan."Account No.";
    end;}



