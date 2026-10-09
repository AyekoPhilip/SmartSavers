table 50419 "Treasury Cashier Transaction"
{
    DataClassification = CustomerContent;
    DrillDownPageID = "Treasury Cashier List";
    LookupPageID = "Treasury Cashier List";

    fields
    {
        field(50009; "No"; Code[20])
        {
            Caption = 'No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50010; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Transaction Type"; Option)
        {
            OptionCaption = 'Issue To Teller,Return To Treasury,Issue From Bank,Return To Bank,Inter Teller Transfers,Branch Treasury Transactions,End of Day Return to Treasury';
            OptionMembers = "Issue To Teller","Return To Treasury","Issue From Bank","Return To Bank","Inter Teller Transfers","Branch Treasury Transactions","End of Day Return to Treasury";
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ("Transaction Type" = "Transaction Type"::"Issue From Bank") or
                ("Transaction Type" = "Transaction Type"::"Branch Treasury Transactions") or
                ("Transaction Type" = "Transaction Type"::"Return To Bank") then
                    Error('Options not allowed');

                if "Transaction Type" = "Transaction Type"::"Issue To Teller" then begin
                    Description := IssuetoTeller;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := UpperCase(UserId);

                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;

                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            BankAccount := BankingSetup."Default  Bank";
                            if bankacc.Get(BankAccount) then begin
                                bankacc.CalcFields(bankacc."Balance (LCY)", bankacc.Balance);
                                Balance := bankacc.Balance;
                            end;
                        end;
                    end;
                end;

                if "Transaction Type" = "Transaction Type"::"Return To Treasury" then begin
                    Description := ReturnToTreasury;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);

                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;

                if "Transaction Type" = "Transaction Type"::"Inter Teller Transfers" then begin
                    Description := InterTellerTrans;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);

                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;

                if "Transaction Type" = "Transaction Type"::"Issue From Bank" then begin
                    Description := IssueFromBank;
                    "From Account" := '';
                    "From Till" := '';
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "To Account" := UpperCase(UserId);

                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "To Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;

                if "Transaction Type" = "Transaction Type"::"Return To Bank" then begin
                    Description := ReturnToBank;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := UpperCase(UserId);

                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;

                if "Transaction Type" = "Transaction Type"::"Branch Treasury Transactions" then begin
                    Description := BranchTreas;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := UpperCase(UserId);

                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;

                if "Transaction Type" = "Transaction Type"::"End of Day Return to Treasury" then begin
                    Description := EndOfDay;

                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);

                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;

                        end;
                    end;

                    BankAccount := '';
                    if BankingSetup.Get(UserId) then begin
                        BankAccount := BankingSetup."Default  Bank";
                        if bankacc.Get(BankAccount) then begin
                            bankacc.CalcFields(bankacc."Balance (LCY)", bankacc.Balance);
                            "Till/Treasury Balance" := bankacc.Balance;
                        end;
                    end;

                end;
                "To Account" := '';
                "To Till" := '';
            end;
        }
        field(50012; "From Account"; Code[50])
        {
            Caption = 'From Account';
            DataClassification = CustomerContent;
            TableRelation = IF ("Transaction Type" = FILTER("Issue To Teller" | "Return To Bank" | "Branch Treasury Transactions")) "Banking User Template"."Account ID" WHERE(Type = CONST(Treasury), "Responsibility Centre" = FIELD("Responsibility Center"))
            ELSE
            IF ("Transaction Type" = FILTER("End of Day Return to Treasury" | "Return To Treasury" | "Inter Teller Transfers")) "Banking User Template"."Account ID" WHERE(Type = CONST(Cashier), "Responsibility Centre" = FIELD("Responsibility Center"), "Account ID" = field("Cashier ID"))
            ELSE
            IF ("Transaction Type" = FILTER("Issue From Bank")) "Bank Account"."No.";
        
            trigger OnValidate()
            begin

                if "From Account" = "To Account" then
                    Error('To account cannot be same as from account');

                if BankingSetup.Get("From Account") then begin
                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        bankacc.CalcFields("Balance (LCY)");
                        if ("Transaction Type" = "Transaction Type"::"Return To Treasury") or ("Transaction Type" = "Transaction Type"::"End of Day Return to Treasury") or
                         ("Transaction Type" = "Transaction Type"::"Inter Teller Transfers") then
                            "From Till Balance" := bankacc."Balance (LCY)" else
                            "From Till Balance" := 0;
                        "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;

                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        bankacc.CalcFields("Balance (LCY)");

                        case "Transaction Type" of
                            "Transaction Type"::"Inter Teller Transfers",
                            "Transaction Type"::"Return To Treasury",
                            "Transaction Type"::"End of Day Return to Treasury":
                                begin
                                    //if bankacc."Bank Type" <> bankacc."Bank Type"::Treasury then
                                    "From Till Balance" := bankacc."Balance (LCY)";
                                end;
                            "Transaction Type"::"Issue To Teller":
                                begin
                                    if bankacc."Bank Type" <> bankacc."Bank Type"::Treasury then
                                        "From Till Balance" := 0
                                end;
                        end;
                        "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;
                end;
                "Cashier ID" := UserId;
            end;
        }
        field(50013; "To Account"; Code[50])
        {
            Caption = 'To Account';
            DataClassification = CustomerContent;
            TableRelation = IF ("Transaction Type" = FILTER("Return To Treasury" | "Issue From Bank" | "Branch Treasury Transactions" | "End of Day Return to Treasury")) "Banking User Template"."Account ID" WHERE(Type = CONST(Treasury))
            ELSE
            IF ("Transaction Type" = FILTER("Issue To Teller")) "Banking User Template"."Account ID" WHERE(Type = CONST(Cashier), "Account ID" = field("Cashier ID"))
            ELSE
            IF ("Transaction Type" = FILTER("Inter Teller Transfers")) "Banking User Template"."Account ID" WHERE(Type = CONST(Cashier))
            ELSE
            IF ("Transaction Type" = FILTER("Return To Bank")) "Bank Account"."No.";
        
            trigger OnValidate()
            begin
                if "To Account" = "From Account" then
                    Error('To account cannot be same as from account');
                if BankingSetup.Get("To Account") then begin
                    "To Till" := BankingSetup."Default  Bank";
                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        bankacc.CalcFields("Balance (LCY)");

                        case "Transaction Type" of
                            "Transaction Type"::"Inter Teller Transfers",
                            "Transaction Type"::"Return To Treasury",
                            "Transaction Type"::"End of Day Return to Treasury":
                                begin

                                    "To Till Balance" := 0;
                                end;
                            "Transaction Type"::"Issue To Teller":
                                begin
                                    if bankacc."Bank Type" <> bankacc."Bank Type"::Treasury then
                                        "To Till Balance" := bankacc."Balance (LCY)";
                                end;
                        end;

                        "To Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;
                end;
                "Cashier ID" := UserId;
            end;
        }
        field(50014; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50015; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Banks: Record "Bank Account";
            begin
                if Amount < 0 then
                    Error('Amount must not be negative');
                if "Transaction Type" = "Transaction Type"::"End of Day Return to Treasury" then begin
                    if Amount > "Till/Treasury Balance" then begin
                        Type := Type::Excess;
                        "Excess/Shortage Amount" := (Amount - "Till/Treasury Balance")
                    end else begin
                        Type := Type::Shortage;
                        "Excess/Shortage Amount" := ("Till/Treasury Balance" - Amount)
                    end;
                end;
                BankingSetup.Reset;
                BankingSetup.SetRange(BankingSetup."Account ID", "To Account");
                if BankingSetup.Find('-') then begin

                    case "Transaction Type" of
                        "Transaction Type"::"Issue To Teller",
                        "Transaction Type"::"Inter Teller Transfers":
                            begin
                                Banks.Reset;
                                Banks.SetRange(Banks."No.", BankingSetup."Default  Bank");
                                if Banks.Find('-') then begin
                                    Banks.CalcFields(Banks."Balance (LCY)");
                                    if Banks."Balance (LCY)" + Amount > BankingSetup."Max. Cashier Withholding" then
                                        Error('The transaction will result in the teller having a balance more than the maximum allowable therefor terminated.');
                                end;
                            end;
                    end;
                end;

            end;
        }
        field(50016; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50017; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
        field(50018; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50019; "Posted By"; Text[50])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50020; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50021; "Transaction Time"; Time)
        {
            Caption = 'Transaction Time';
            DataClassification = CustomerContent;
        }
        field(50022; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50023; "Issued"; Option)
        {
            OptionMembers = "No","Yes","N/A";
            Caption = 'Issued';
            DataClassification = CustomerContent;
        }
        field(50024; "Date Issued"; Date)
        {
            Caption = 'Date Issued';
            DataClassification = CustomerContent;
        }
        field(50025; "Time Issued"; Time)
        {
            Caption = 'Time Issued';
            DataClassification = CustomerContent;
        }
        field(50026; "Issue Received"; Option)
        {
            Editable = false;
            OptionMembers = "No","Yes","N/A";
            Caption = 'Issue Received';
            DataClassification = CustomerContent;
        }
        field(50027; "Date Received"; Date)
        {
            Editable = false;
            Caption = 'Date Received';
            DataClassification = CustomerContent;
        }
        field(50028; "Time Received"; Time)
        {
            Editable = false;
            Caption = 'Time Received';
            DataClassification = CustomerContent;
        }
        field(50029; "Issued By"; Text[50])
        {
            Editable = false;
            Caption = 'Issued By';
            DataClassification = CustomerContent;
        }
        field(50030; "Received By"; Text[50])
        {
            Editable = false;
            Caption = 'Received By';
            DataClassification = CustomerContent;
        }
        field(50031; "Received"; Option)
        {
            Editable = false;
            OptionCaption = 'No,Yes';
            OptionMembers = "No","Yes";
            Caption = 'Received';
            DataClassification = CustomerContent;
        }
        field(50032; "Denomination Total"; Decimal)
        {
            CalcFormula = Sum(Coinage."Total Amount" WHERE(No = FIELD(No)));
            FieldClass = FlowField;
            Caption = 'Denomination Total';
        }
        field(50033; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Total Cash on Treasury Coinage"; Decimal)
        {
            CalcFormula = Sum(Coinage."Total Amount" WHERE(No = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Cash on Treasury Coinage';
        }
        field(50035; "Till/Treasury Balance"; Decimal)
        {
            Caption = 'Till/Treasury Balance';
            DataClassification = CustomerContent;
        }
        field(50036; "Excess/Shortage Amount"; Decimal)
        {
            Caption = 'Excess/Shortage Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Excess/Shortage Amount" < 0 then
                    Error('Amount must not be negative');

                if Type = Type::" " then
                    Error('Please specify the type');
            end;
        }
        field(50037; "From Account Name"; Text[50])
        {
            Caption = 'From Account Name';
            DataClassification = CustomerContent;
        }
        field(50038; "To Account Name"; Text[50])
        {
            Caption = 'To Account Name';
            DataClassification = CustomerContent;
        }
        field(50039; "Actual Cash At Hand"; Decimal)
        {
            Enabled = false;
            Caption = 'Actual Cash At Hand';
            DataClassification = CustomerContent;
        }
        field(50040; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50041; "Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = "Open","Pending","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50042; "Type"; Option)
        {
            OptionCaption = ' ,Excess,Shortage';
            OptionMembers = " ","Excess","Shortage";
            Caption = 'Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Excess/Shortage Amount" := 0;
            end;
        }
        field(50043; "From Till"; Code[50])
        {
            Editable = false;
            Caption = 'From Till';
            DataClassification = CustomerContent;
        }
        field(50044; "To Till"; Code[50])
        {
            Editable = false;
            Caption = 'To Till';
            DataClassification = CustomerContent;
        }
        field(50045; "Balance"; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(50046; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50047; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50048; "Cashier ID"; Code[100])
        {
            Caption = 'Cashier ID';
            TableRelation = "User Setup";
            Editable = false;
        }
        field(50049; "From Till Balance"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(50050; "To Till Balance"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Treasury & Teller Trans Nos.");
            
        end;

        if "Transaction Type" = "Transaction Type"::"Issue To Teller" then begin
            Description := IssuetoTeller;
            if BankingSetup.Get(UserId) then begin
                if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                    "From Account" := UpperCase(UserId);

                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;
                end;
            end;

            if BankingSetup.Get(UserId) then begin
                if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                    BankAccount := BankingSetup."Default  Bank";
                    if bankacc.Get(BankAccount) then begin
                        bankacc.CalcFields(bankacc."Balance (LCY)", bankacc.Balance);
                        Balance := bankacc.Balance;
                    end;
                end;
            end;

        end
        else
            if "Transaction Type" = "Transaction Type"::"Issue From Bank" then
                Description := IssueFromBank
            else
                Description := ReturnToTreasury;

        "Transaction Date" := Today;
        "Transaction Time" := Time;
        Denominations.Reset;
        TransactionCoinage.Reset;
        Denominations.Init;
        TransactionCoinage.Init;

        if Denominations.Find('-') then begin

            repeat
                TransactionCoinage.No := No;
                TransactionCoinage.Code := Denominations.Code;
                TransactionCoinage.Description := Denominations.Description;
                TransactionCoinage.Type := Denominations.Type;
                TransactionCoinage.Value := Denominations.Value;
                TransactionCoinage.Quantity := 0;
                TransactionCoinage.Insert;
            until Denominations.Next = 0;

        end;

        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Center" := UserSetup."Responsibility Centre";
        "Cashier ID" := UserId;

    end;

    trigger OnModify()
    begin
        if Posted then
            Error('you cannot modify this transaction');
    end;

    var
        NoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Denominations: Record Denominations;
        TransactionCoinage: Record Coinage;
        IssuetoTeller: Label 'ISSUE TO TELLER';
        IssueFromBank: Label 'ISSUE FROM BANK';
        ReturnToTreasury: Label 'RETURN TO TREASURY';
        InterTellerTrans: Label 'INTER TELLER TRANSFERS';
        ReturnToBank: Label 'RETURN TO BANK';
        BranchTreas: Label 'BRANCH TREASURY TRANSACTIONS';
        EndOfDay: Label 'END OF DAY RETURN TO TREASURY';
        BankingSetup: Record "Banking User Template";
        bankacc: Record "Bank Account";
        BankAccount: Code[25];
        UserSetup: Record "User Setup";

}




