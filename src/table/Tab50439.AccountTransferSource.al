table 50439 "Account Transfer Source"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = const(Savings), "Transfer Type" = filter(Self | Other)) "Account Banking"."No." WHERE(Blocked = CONST(" "), "Member No." = field("Member No."),
            Status = filter(Active | New | Dormant | Defaulter), "Account Category" = filter("Specialty Savings"|Savings)) else
            if ("Account Type" = const(Credit), "Transfer Type" = filter("Share Transfer" | Other | Self)) "Account Credit" where(Status = filter(<>Active), "Account Category" = const("Shares Capital"), "Member No." = field("Member No."), "Balance (LCY)" = filter(> 0)) else
            IF ("Account Type" = const(Savings), "Transfer Type" = filter("Account Zerolize")) "Account Banking"."No." WHERE(Blocked = CONST(" "), "Member No." = field("Member No."));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                AcFosa: Record "Account Banking";
                AcBosa: Record "Account Credit";
                MembCategory: Record "Member Category";
                CustRecord: Record Member;
                ErrorOnLessAvailableBalTxt: Label 'Member has Savings less than min. Threshold of %1';
                TellerMngt: Codeunit "Teller-Post (Yes/No)";
                ErrorOnLastWithdrawalTxt: Label 'Member last withdrawal date was %1. The next withdrawal date must be on or after %2. Otherwise this transaction will attract charges';

            begin
                case "Account Type" of
                    "Account Type"::Savings:
                        begin
                            if AcFosa.Get("Account No.") then begin

                                if TellerMngt.CheckAccWithdrawalInterval(AcFosa."Product Type", AcFosa."No.", AcFosa."Account Category") then
                                    Message(ErrorOnLastWithdrawalTxt, AcFosa."Last Withdrawal Date", AcFosa."Next Withdrawal Date");

                                AcFosa.CalcFields("Balance (LCY)");
                                "Account Name" := AcFosa.Name;
                                "Product Code" := AcFosa."Product Type";
                                "Product Name" := AcFosa."Product Name";
                                Balance := AcFosa."Balance (LCY)";
                                if "Transfer Type" = "Transfer Type"::"Account Zerolize" then begin
                                    "Available Balance" := AcFosa."Balance (LCY)";
                                end else begin
                                    "Available Balance" := TellerMngt.CalcAvailableBal(AcFosa."No.");
                                end;
                            end;
                        end;
                    "Account Type"::Credit:
                        begin
                            if AcBosa.Get("Account No.") then begin

                                AcBosa.CalcFields("Balance (LCY)");
                                if AcBosa."Balance (LCY)" <= CalcAvailableBal(1) then
                                    Error(ErrorOnBalanceTxt, CalcAvailableBal(0));

                                "Account Name" := AcBosa.Name;
                                "Product Code" := AcBosa."Product Type";
                                "Product Name" := AcBosa."Product Name";
                                Balance := AcBosa."Balance (LCY)";
                                "Available Balance" := CalcAvailableBal(1);
                            end;
                        end;
                end;
            end;
        }

        field(50011; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Transaction Type"; Enum "LoanTransactionType")
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Loan No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Loan)) "Credit Account"."No.";
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ProductType: Record "Product Factory";
            begin

                if "Account Type" = "Account Type"::Savings then begin
                    "Available Balance" := CalcAvailableBal(0);

                    if Amount > CalcAvailableBal(0) then
                        Error(ErrorOnAvailBalanceTxt);

                    case "Transfer Type" of
                        "Transfer Type"::"Share Transfer":
                            if ProductType.Get("Product Code") then begin
                                ProductType.TestField("Minimum Balance");
                                if Amount >= ProductType."Minimum Balance" then
                                    Error(ErrorOnMinBalText, ProductType."Minimum Balance");
                            end;
                    end
                end;

                if "Account Type" = "Account Type"::Credit then begin
                    if Amount >= "Available Balance" then Error(ErrorOnAvailBalanceTxt);
                end;
                Amount := Round(Amount);
            end;
        }
        field(50015; "Account Type"; Enum "CreditAccountTypes")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50016; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(50017; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50018; "Product Name"; Text[50])
        {
            Editable = false;
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50019; "Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(50020; "Available Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Available Balance';
            DataClassification = CustomerContent;
        }
        field(50021; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = CustomerContent;
        }
        field(50022; "Transfer Type"; Enum "IFTTransferTypes")
        {
            Caption = 'Transfer Type';
            DataClassification = CustomerContent;
        }
        field(50023; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            TableRelation = Member;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50024; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50025; "Date Posted"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.", "Entry No.", "Member No.")
        {
            Clustered = true;
            SumIndexFields = "Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Account No." <> '' then begin
            Transfer.Reset;
            if Transfer.Get("No.") then begin
                if (Transfer.Posted) then
                    Error('Cannot delete approved or posted batch');
            end;
        end;
    end;

    trigger OnModify()
    begin
        if "Account No." <> '' then begin
            Transfer.Reset;
            if Transfer.Get("No.") then begin
                if (Transfer.Posted) then
                    Error('Cannot modify approved or posted batch');
            end;
        end;
    end;

    trigger OnRename()
    begin
        Transfer.Reset;
        if Transfer.Get("No.") then begin
            if (Transfer.Posted) then
                Error('Cannot rename approved or posted batch');
        end;
    end;

    var
        Transfer: Record "Account Transfer Header";
        TChargeAmount: Decimal;
        GenSetup: Record "General Set-Up";
        TransactionCharges: Record "Transaction Charge";
        transtype: Code[20];
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Account: Record "Account Banking";
        AccountTypes: Record "Product Factory";
        ErrorOnBalanceTxt: Label 'Balance cannot be less than the avaiable balance of %1';
        ErrorOnAvailBalanceTxt: Label 'Amount cannot be more than the avaiable balance';
        ErrorOnMinBalText: Label 'You cannot transfer more than Min. account balance of %1';

    local procedure CalcAvailableBal(SourceInt: Integer) Amt: Decimal
    var
        MinBalance: Decimal;
        Account: Record "Account Banking";
        ProdType: Record "Product Factory";
        AcBosa: Record "Account Credit";
        MembCategory: Record "Member Category";
        CustRecord: Record Member;
    begin
        CalcCharges;
        "Available Balance" := 0;
        MinBalance := 0;

        case SourceInt of
            0:
                begin
                    if Account.Get("Account No.") then begin
                        Account.CalcFields(Account."Balance (LCY)", Account."Uncleared Cheques",
                        Account."Authorised Over Draft", Account."Lien Placed", Account."ATM Transactions");

                        ProdType.Reset;
                        ProdType.SetRange(ProdType."Product ID", Account."Product Type");
                        if ProdType.Find('-') then begin
                            MinBalance := ProdType."Minimum Balance";
                            if "Transfer Type" = "Transfer Type"::"Account Zerolize" then
                                Amt := Account."Balance (LCY)" else
                                Amt := Account."Balance (LCY)" - (MinBalance + Account."Uncleared Cheques" + Account."Lien Placed" + Account."ATM Transactions");
                        end;
                    end;
                end;
            1:
                begin
                    if CustRecord.Get("Member No.") then begin
                        CustRecord.TestField("Member Category");
                        MembCategory.SetRange("No.", CustRecord."Member Category");
                        if MembCategory.FindFirst() then begin
                            MembCategory.TestField("Default Share Deposit");
                            case MembCategory."Terms of Service" of
                                MembCategory."Terms of Service"::Contract:
                                    begin
                                        MinBalance := MembCategory."Default Share Deposit";

                                    end;
                                MembCategory."Terms of Service"::Pensioner:
                                    begin
                                        MinBalance := MembCategory."Default Share Deposit";

                                    end else begin
                                    MinBalance := MembCategory."Default Share Deposit";

                                end;
                            end;
                        end;
                    end;
                    if AcBosa.Get("Account No.") then begin
                        AcBosa.CalcFields(AcBosa."Balance (LCY)");
                        if "Transfer Type" = "Transfer Type"::"Account Zerolize" then
                            Amt := AcBosa."Balance (LCY)" else
                            Amt := (AcBosa."Balance (LCY)" - MinBalance);
                    end;
                end;
        end;
        exit(Amt)
    end;

    local procedure CalcCharges()
    begin

        GenSetup.Get;
        TChargeAmount := 0;
        Transfer.Reset;
        Transfer.SetRange(Transfer."No.", "No.");
        if Transfer.Find('-') then begin
            transtype := Transfer."Transaction Type";
        end;
        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", transtype);
        if TransactionCharges.Find('-') then begin
            repeat

                ChargeAmount := 0;

                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin


                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := Amount * TariffDetails.Percentage * 0.01;
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;
                    TChargeAmount := TChargeAmount + ChargeAmount;
                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                        TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                        ;
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;



        if Account.Get("Account No.") then begin
            if AccountTypes.Get(Account."Product Type") then begin
                if Account."Last Withdrawal Date" <> 0D then begin
                    if CalcDate(AccountTypes."Withdrawal Interval", Account."Last Withdrawal Date") > Today then begin

                        TransactionCharges.Reset;
                        TransactionCharges.SetRange(TransactionCharges."Transaction Type", transtype);
                        if TransactionCharges.Find('-') then begin
                            repeat
                                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Withdrawal Frequency") then begin

                                    ChargeAmount := 0;
                                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                        ChargeAmount := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                                    else
                                        ChargeAmount := TransactionCharges."Charge Amount";

                                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                        TariffDetails.Reset;
                                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                        if TariffDetails.Find('-') then begin
                                            repeat
                                                if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                                    if TariffDetails."Use Percentage" = true then begin
                                                        ChargeAmount := Amount * TariffDetails.Percentage * 0.01;
                                                    end else begin
                                                        ChargeAmount := TariffDetails."Charge Amount";
                                                    end;
                                                end;
                                            until TariffDetails.Next = 0;
                                        end;
                                    end;

                                    TChargeAmount := TChargeAmount + ChargeAmount;
                                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                                        TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                                    end;
                                end;
                            until TransactionCharges.Next = 0;
                        end;

                    end;


                end;
            end;
        end;

    end;
}




