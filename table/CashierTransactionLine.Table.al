table 50437 "Cashier Transaction Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Transaction No."; Code[20])
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Transaction Type"; Enum "LoanTransactionType")
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ErrorOnInvalidTransType: Label 'Transaction type -%1- is disabled on this document. Please contact your system administrator.';
            begin
                Rec.TestField("Account Type", Rec."Account Type"::Loan);
                Rec.TestField("Transaction Type", Rec."Transaction Type"::Repayment);
                case "Transaction Type" of
                    "Transaction Type"::Loan:
                        begin
                            Error(ErrorOnInvalidTransType, "Transaction Type");
                        end;
                end;
            end;
        }
        field(50012; "Loan No."; Code[20])
        {
            TableRelation = Loans."No." WHERE("Loan Account" = FIELD("Account No."), "Outstanding Balance" = FILTER(> 0));
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanAc: Record Loans;
            begin
                TestField("Transaction Type");

                if "Account Type" = "Account Type"::Loan then begin
                    if LoanAc.Get("Loan No.") then
                        LoanAc.CalcFields("Outstanding Interest", "Outstanding Principal");
                    "Product Type" := LoanAc."Product Type";
                    "Outstanding Interest" := LoanAc."Outstanding Interest";
                    "Balance (LCY)" := LoanAc."Outstanding Principal";
                    Amount := LoanAc.Repayment;
                    "Total Amount" := LoanAc.Repayment;
                end;
            end;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanAc: Record Loans;
                ProductFact: Record "Product Factory";
                AccountB: Record "Account Banking";
                BosaAc: Record "Account Credit";

            begin
                TestField("Account No.");
                if Rec."Account Type" = Rec."Account Type"::Loan then begin
                    if LoanAc.Get("Loan No.") then begin
                        LoanAc.CalcFields("Outstanding Balance", "Outstanding Principal",
                        "Outstanding Bill", "Outstanding Interest");
                        if Amount > LoanAc."Outstanding Balance" then
                            Amount := LoanAc."Outstanding Balance" else
                            Amount := Amount
                    end;
                end;
                if Rec."Account Category" = Rec."Account Category"::"Registration Fee" then begin

                    if BosaAc.Get(Rec."Account No.") then
                        BosaAc.CalcFields("Balance (LCY)");
                    if ProductFact.Get(Rec."Product Type") then
                        ProductFact.TestField("Minimum Balance");
                    //if (BosaAc."Balance (LCY)" + Rec.Amount) > ProductFact."Minimum Balance" then
                    //   Error('This transaction will result in overpayment of registration fee');
                end;
                "Total Amount" := Amount;
            end;
        }
        field(50014; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50015; "Account No."; Code[100])
        {
            NotBlank = true;
            TableRelation = IF ("Account Type" = CONST(Credit)) "Account Credit"."No." WHERE(Blocked = CONST(" "), "Member No." = field("Member No."), Status = filter(Active | New | Defaulter | Dormant))
            ELSE
            IF ("Account Type" = CONST(Loan)) "Credit Account"."No." WHERE(Blocked = CONST(" "), "Member No." = field("Member No."))
            ELSE
            IF ("Account Type" = CONST(Saving)) "Account Banking"."No." WHERE(Blocked = CONST(" "), "Member No." = field("Member No."), "Account Category" = filter(<> "Certificates of Deposit"), Status = CONST(Active));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                AccBanking: Record "Account Credit";
                FAccount: Record "Account Banking";
                LoanAc: Record "Credit Account";
                Loans: Record Loans;
                prodFact: Record "Product Factory";
            begin
                case "Account Type" of
                    "Account Type"::Credit:
                        begin
                            if AccBanking.Get("Account No.") then
                                AccBanking.CalcFields("Balance (LCY)");
                            "Product Type" := AccBanking."Product Type";
                            "Account Category" := AccBanking."Account Category";
                            "Balance (LCY)" := AccBanking."Balance (LCY)";
                            if prodFact.Get(AccBanking."Product Type") then begin
                                prodFact.TestField("Minimum Balance");
                                if (Amount + AccBanking."Balance (LCY)") >= prodFact."Minimum Balance" then
                                    "Minimum Balance Attained" := true
                            end;
                        end;
                    "Account Type"::Loan:
                        begin
                            if LoanAc.Get("Account No.") then
                                "Product Type" := LoanAc."Product Type";
                        end;
                    "Account Type"::Saving:
                        begin
                            if FAccount.Get("Account No.") then begin
                                FAccount.CalcFields("Balance (LCY)");
                                "Product Type" := FAccount."Product Type";
                                "Account Category" := FAccount."Account Category";
                                "Balance (LCY)" := FAccount."Balance (LCY)";
                            end;
                        end;
                end;
            end;
        }
        field(50016; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                case "Account Type" of
                    "Account Type"::"Fixed Asset",
                    "Account Type"::Vendor,
                    "Account Type"::Prepayment,
                    "Account Type"::"IC Partner",
                    "Account Type"::Employee,
                    "Account Type"::Customer,
                    "Account Type"::"Bank Account",
                    "Account Type"::"G/L Account":
                        begin
                            Error('The Option selected not transactional');
                        end;
                end
            end;
        }
        field(50017; "Product Type"; Code[80])
        {
            Editable = false;
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50018; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50019; "Posted By"; Code[80])
        {
            Editable = false;
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50020; "Date Posted"; Date)
        {
            Editable = false;
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
        field(50021; "Processed"; Boolean)
        {
            Editable = false;
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(50022; "Outstanding Interest"; Decimal)
        {
            Editable = false;
        }
        field(50023; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(50024; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50025; "Balance (LCY)"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50026; "Minimum Balance Attained"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50027; "Clear Loan"; Boolean)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var

            begin
                Rec.TestField("Loan No.");
                case Rec."Clear Loan" of
                    true:
                        begin
                            if Loans.Get("Loan No.") then begin
                                Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill");

                                EndDate := Today;
                                StartDate := CalcDate('-CM', EndDate);
                                IntDays := (EndDate - StartDate) + 1;
                                if (Loans."Product Type" = 'MSACCOLN') or (Loans."Product Type" = 'DIVIDEND') then
                                    "Accrued Interest" := 0 else
                                    "Accrued Interest" := PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate);
                                "Balance (LCY)" := Loans."Outstanding Balance" + "Accrued Interest";
                                "Outstanding Interest" := Loans."Outstanding Interest";
                                Amount := Loans."Outstanding Balance" + "Accrued Interest";
                                "Amount (LCY)" := Amount;
                                "Total Amount" := Amount;

                            end;
                        end;
                    false:
                        begin
                            if Loans.Get("Loan No.") then begin

                                Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill");
                                "Accrued Interest" := 0;
                                "Outstanding Bills" := Loans."Outstanding Bill";
                                "Balance (LCY)" := Loans."Outstanding Balance";
                                "Outstanding Interest" := Loans."Outstanding Interest";
                                Amount := "Amount (LCY)";
                                "Balance (LCY)" := Loans."Outstanding Balance";
                                "Total Amount" := Amount;
                            end;
                        end;
                end;
            end;
        }
        field(50028; "Accrued Interest"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50029; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50030; "Outstanding Bills"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key("Key1"; "Transaction No.", "Account No.", "Loan No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if CashTrans.Get("Transaction No.") then begin
            "Member No." := CashTrans."Member No.";
        end;
    end;

    var
        creditacc: Record "Credit Account";
        savingsacc: Record "Account Banking";
        CashTrans: Record "Teller Transaction";
        Loans: Record Loans;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
}




