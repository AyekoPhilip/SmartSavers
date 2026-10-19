table 50440 "Account Transfer Destination"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account Type"; Enum "AccountTypesExtended")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Savings)) "Account Banking" WHERE(Blocked = CONST(" "),
            "Account Category" = filter("Specialty Savings"|"Certificates of Deposit"),
            Status = filter(Active | Defaulter | New | Dormant), "Member No." = field("Member No."))
            ELSE
            IF ("Account Type" = CONST(Credit)) "Account Credit" WHERE(Blocked = CONST(" "),
            Status = filter(Active | Defaulter | New | Dormant | Withdrawn))
            ELSE
            IF ("Account Type" = CONST(Loan)) "Credit Account" WHERE(Blocked = CONST(" "), "Member No." = field("Member No."), "Balance (LCY)" = filter(> 0)) else
            IF ("Account Type" = CONST(Savings), "Transfer Type" = filter("Account Zerolize")) "Account Banking"."No." WHERE(Blocked = CONST(" "),
            "Member No." = field("Member No."));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                AcFosa: Record "Account Banking";
                AcBosa: Record "Account Credit";
                LoansT: Record Loans;
            begin
                if AcFosa.Get("Account No.") then begin
                    "Account Name" := AcFosa.Name;
                    "Product Code" := AcFosa."Product Type";
                    "Product Name" := AcFosa."Product Name";
                end;
                if AcBosa.Get("Account No.") then begin
                    "Account Name" := AcBosa.Name;
                    "Product Code" := AcBosa."Product Type";
                    "Product Name" := AcBosa."Product Name";
                end;
                if AcBosa.Get("Account No.") then begin
                    "Account Name" := AcBosa.Name;
                    "Product Code" := AcBosa."Product Type";
                    "Product Name" := AcBosa."Product Name";
                end;
                LoansT.Reset();
                LoansT.SetRange("Loan Account", "Account No.");
                if LoansT.FindFirst() then begin
                    "Account Name" := LoansT."Account Name";
                    "Product Code" := LoansT."Product Type";
                    "Product Name" := LoansT."Product Description";
                end;
            end;
        }
        field(50012; "Loan No."; Code[100])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = Loans."No." where("Loan Account" = field("Account No."), "Outstanding Balance" = filter(> 0));
        
            trigger OnValidate()
            var
                RegMngt: Codeunit "Register Management";
            begin

                Loans.Reset();
                Loans.SetRange("No.", "Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Balance", "Outstanding Bill", "Outstanding Interest", "Outstanding Insurance");
                    EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;
                    "Accrued Interest" := PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate);
                    "Outstanding Bills" := Loans."Outstanding Bill";
                    "Settlement Fee" := RegMngt.getsettlementFee("Loan No.");
                    "Outstanding Insurance" := Loans."Outstanding Insurance";
                    "Outstanding Interest" := Loans."Outstanding Interest";

                    if "Clear Loan" then begin
                        "Balance (LCY)" := Round(Loans."Outstanding Balance" + "Accrued Interest" + "Settlement Fee");
                        Amount := "Balance (LCY)";
                    end else begin
                        "Accrued Interest" := 0;
                        "Balance (LCY)" := Loans."Outstanding Balance";
                        Amount := Loans.Repayment;
                    end;
                end;

                if Amount <> 0 then begin
                    Validate(Amount);
                end;
            end;
        }
        field(50013; "Transaction Type"; Enum "LoanTransactionType")
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50014; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50015; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::Loan then begin
                    if Amount <> 0 then begin

                        TestField("Clear Loan", false);

                        "Transaction Type" := "Transaction Type"::Repayment;

                        Loans.Reset();
                        Loans.SetRange("No.", "Loan No.");
                        if Loans.FindFirst() then begin
                            Loans.CalcFields("Outstanding Balance", "Outstanding Bill", "Outstanding Interest", "Outstanding Insurance");
                            "Product Code" := Loans."Product Type";
                            "Product Name" := Loans."Product Description";
                            EndDate := Today;
                            StartDate := CalcDate('-CM', Today);
                            IntDays := (EndDate - StartDate) + 1;
                            "Accrued Interest" := PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate);
                            "Outstanding Bills" := Loans."Outstanding Bill";
                            "Outstanding Insurance" := Loans."Outstanding Insurance";
                            "Outstanding Interest" := Loans."Outstanding Interest";
                            if "Clear Loan" then begin
                                "Balance (LCY)" := Round(Loans."Outstanding Balance" + "Accrued Interest" + "Settlement Fee");
                            end else begin
                                "Accrued Interest" := 0;
                                "Balance (LCY)" := Loans."Outstanding Balance";
                            end;
                        end;

                        if Amount >= "Balance (LCY)" then
                            Amount := "Balance (LCY)";
                        "Total Amount" := Amount;
                    end;
                end;
            end;
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
        field(50019; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = CustomerContent;
        }
        field(50020; "Transfer Type"; Enum "IFTTransferTypes")
        {
            Caption = 'Transfer Type';
            DataClassification = CustomerContent;
        }
        field(50021; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50022; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50023; "Date Posted"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50024; "Clear Loan"; Boolean)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                RegMngt: Codeunit "Register Management";
            begin
                Rec.TestField("Loan No.");
                if "Account Type" = "Account Type"::Loan then begin
                    "Transaction Type" := "Transaction Type"::Repayment;
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
                                    "Settlement Fee" := RegMngt.getsettlementFee("Loan No.");
                                    "Outstanding Bills" := Loans."Outstanding Bill";
                                    "Balance (LCY)" := (Loans."Outstanding Balance" + "Accrued Interest" + "Settlement Fee");
                                    "Outstanding Interest" := Loans."Outstanding Interest";
                                    Amount := (Loans."Outstanding Balance" + "Accrued Interest" + "Settlement Fee");
                                    "Total Amount" := Amount;
                                end;
                            end;
                        false:
                            begin
                                if Loans.Get("Loan No.") then begin
                                    Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill");
                                    "Accrued Interest" := 0;
                                    "Settlement Fee" := 0;
                                    "Balance (LCY)" := Loans."Outstanding Balance";
                                    "Outstanding Interest" := Loans."Outstanding Interest";
                                    "Outstanding Bills" := Loans."Outstanding Bill";
                                    Amount := Loans.Repayment;
                                    "Balance (LCY)" := Loans."Outstanding Balance";
                                    "Total Amount" := Amount;
                                end;
                            end;
                    end;
                end;
            end;
        }
        field(50025; "Accrued Interest"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50026; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50027; "Balance (LCY)"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50028; "Outstanding Interest"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50029; "Total Amount"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50030; "Outstanding Bills"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50031; "Outstanding Insurance"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50032; "Settlement Fee"; Decimal)
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
        Loans: Record Loans;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;

}




