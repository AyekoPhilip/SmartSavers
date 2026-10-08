codeunit 50054 "Alt. Channel (Teller Mngt.)"
{
    TableNo = "Teller Transaction";

    trigger OnRun()
    begin
        RunWithCheck(Rec)
    end;

    var
        TellerTransaction: Record "Teller Transaction";
        Temp: Record "Banking User Template";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        Tillno: Code[20];
        CmemberNo: Code[100];
        Excess: Code[20];
        Shortage: Code[20];
        Text0006: Label 'Please specify the Account No';
        Text0007: Label 'Please specify an amount greater than zero.';
        Text0008: Label 'Please select the transaction type.';
        Text0010: Label 'You are not authorised to transact your own account';

    procedure RunWithCheck(var TellerTransaction2: Record "Teller Transaction")
    begin
        TellerTransaction.Copy(TellerTransaction2);
        Code(TellerTransaction, true, Today);
        TellerTransaction2 := TellerTransaction
    end;

    procedure RunWithoutCheck(var TellerTransaction2: Record "Teller Transaction")
    begin
        TellerTransaction.Copy(TellerTransaction2);
        Code(TellerTransaction, false, Today);
        TellerTransaction2 := TellerTransaction
    end;


    procedure "Code"(RecRef: Record "Teller Transaction"; CheckLine: Boolean; PostingDate: Date)
    var
        ErrorOnPendinggApprovalApplicTxt: Label 'The transaction must be fully approved before proceeding.';
    begin
        RecRef.CheckRequiredItems;
        fnInitialize(RecRef);
        CheckTillCurrency(Tillno, RecRef."Currency Code");
        RecRef.CalcFields("Allocated Amount");
        if RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval" then
            Error(ErrorOnPendinggApprovalApplicTxt);
        CODEUNIT.Run(CODEUNIT::"Teller-Post (Yes/No)", RecRef);
    end;

    procedure fnInitialize(TellerTransaction: Record "Teller Transaction")
    begin
        TellerTransaction.TestField(Cashier, UserId);
        TellerTransaction.TestField("Transaction Date", Today);
        TellerTransaction.TestField(Posted, false);

        Temp.Get(UserId);
        Temp.TestField("Cashier Journal Template");
        Temp.TestField("Cashier Journal Batch");
        Temp.TestField("Default  Bank");
        Temp.TestField("Account No.");

        Temp.TestField("Excess Account");
        Temp.TestField("Shortage Account");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";
        Tillno := Temp."Default  Bank";
        CmemberNo := Temp."Account No.";
        Excess := Temp."Excess Account";
        Shortage := Temp."Shortage Account";

        if CmemberNo = TellerTransaction."Member No." then begin
            TellerTransaction."Attempted Self Transaction" := true;
            TellerTransaction.Modify;
            Message(Text0010);
            exit;
        end;

        if TellerTransaction."Account No." = '' then
            Error(Text0006);
        if TellerTransaction.Amount <= 0 then
            Error(Text0007);
        if TellerTransaction."Transaction Type" = '' then
            Error(Text0008);
    end;


    procedure CheckTillCurrency(BankAcc: Code[20]; CurrCode: Code[20])
    var
        BankAcct: Record "Bank Account";
        ErrorOnTillCurrencyTxt: Label 'This bank [%1:- %2] can only transact in Local Currency.';
        ErrorOnTillSpecCurrencyTxt: Label 'This bank [%1:- %2] can only transact in %3.';
    begin
        BankAcct.Reset;
        BankAcct.SetRange(BankAcct."No.", BankAcc);
        if BankAcct.Find('-') then begin
            if BankAcct."Currency Code" <> CurrCode then begin
                if BankAcct."Currency Code" = '' then
                    Error(ErrorOnTillCurrencyTxt, BankAcct."No.", BankAcct.Name)
                else
                    Error(ErrorOnTillSpecCurrencyTxt, BankAcct."No.", BankAcct.Name, BankAcct."Currency Code");
            end;
        end;
    end;

    local procedure CheckBankersNo(ChequeNo: Code[20]; GlobalDim2: Code[20]; TAmount: Decimal)
    var
        Bregister: Record "Bankers Cheques Register";
        Text00001: Label 'Bankers cheque no has already been used.';
        Text00002: Label 'Bankers cheque amount cannot be more than the leaf limit of %1.';
    begin
        Bregister.Reset;
        Bregister.SetRange(Bregister.Status, Bregister.Status::Pending);
        Bregister.SetRange(Bregister."Global Dimension 2 Code", GlobalDim2);
        Bregister.SetRange(Bregister."Cheque No.", ChequeNo);
        if not Bregister.Find('-') then
            Error(Text00001);
        Bregister.Reset;
        Bregister.SetRange(Bregister.Status, Bregister.Status::Pending);
        Bregister.SetRange(Bregister."Global Dimension 2 Code", GlobalDim2);
        Bregister.SetRange(Bregister."Cheque No.", ChequeNo);
        if Bregister.Find('-') then begin
            if Bregister."Leaf Limit Amount" < TAmount then
                Error(Text00002, Bregister."Leaf Limit Amount");
        end;
    end;
}




