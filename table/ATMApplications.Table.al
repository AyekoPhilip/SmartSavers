table 50481 "ATM Applications"
{
    DataClassification = CustomerContent;
   
    fields
    {
        field(50009; "No."; Code[20])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
               
            end;
        }
        field(50010; "Account No"; Code[20])
        {
            TableRelation = "Account Banking"."No." WHERE("Account Category" = CONST(Savings));
            Caption = 'Account No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                ATMApplications.Reset;
                ATMApplications.SetRange(ATMApplications."Account No", "Account No");
                ATMApplications.SetRange(ATMApplications."ATM Delinked", false);
                if ATMApplications.Find('-') then begin
                    repeat
                        if ATMApplications."ATM Charges Applied" = false
                          then
                            Error('This Account has an active ATM application');
                    until ATMApplications.Next = 0;
                end;


                TestField("Card Type");
                UserSetup.Get(UserId);
                SavingsAccounts.Reset;
                SavingsAccounts.SetRange(SavingsAccounts."No.", "Account No");
                if SavingsAccounts.Find('-') then begin
                    "Member No." := SavingsAccounts."Member No.";
                    //SavingsAccounts.TESTFIELD("Transactional Mobile No");
                    Members.Reset;
                    Members.SetRange(Members."No.", SavingsAccounts."Member No.");
                    if Members.Find('-') then begin

                        "Account Name" := Members.Name;
                        "Customer ID" := Members."ID No.";
                        "Phone No." := SavingsAccounts."Mobile No.";
                        Address := Members."Current Address";
                    end else begin

                        "Account Name" := '';
                        "Customer ID" := '';
                        "Phone No." := '';
                        Address := '';
                    end;

                    AvailableBalance := 0;
                    MinBalance := 0;

                    if Account.Get(SavingsAccounts."No.") then begin
                        Account.CalcFields(Account.Balance, Account."Uncleared Cheques",
                        Account."Authorised Over Draft", Account."Balance (LCY)");
                        ProdType.Reset;
                        ProdType.SetRange(ProdType."Product ID", Account."Product Type");
                        if ProdType.Find('-') then begin
                            MinBalance := ProdType."Minimum Balance";
                            AvailableBalance := (Account."Balance (LCY)" + Account."Authorised Over Draft")
                            - (MinBalance + Account."Uncleared Cheques");
                        end;
                    end;

                    GenSetup.Get;
                    ChargeAmount := 0;

                    ATMCardTypes.Reset;
                    ATMCardTypes.SetRange(ATMCardTypes.Code, "Card Type");
                    if ATMCardTypes.Find('-') then begin
                        if "Request Type" = "Request Type"::New then begin
                            TransType.Reset;
                            TransType.SetRange(TransType.Code, ATMCardTypes."Application Charge Code");
                            if TransType.Find('-') then begin
                                ChargeAmount := 0;
                                TransactionCharges.Reset;
                                TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransType.Code);
                                if TransactionCharges.Find('-') then begin


                                    repeat

                                        if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                                        (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin
                                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                                ChargeAmount := TransactionCharges."Charge Amount"
                                            else
                                                ChargeAmount := TransactionCharges."Charge Amount";

                                            TChargeAmount += ChargeAmount;

                                        end;
                                    until TransactionCharges.Next = 0;

                                end;
                            end;
                        end else

                            if "Request Type" = "Request Type"::Replacement then begin
                                TransType.Reset;
                                TransType.SetRange(TransType.Code, ATMCardTypes."Replacement Charge Code");
                                if TransType.Find('-') then begin
                                    ChargeAmount := 0;
                                    TransactionCharges.Reset;
                                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransType.Code);
                                    if TransactionCharges.Find('-') then begin

                                        repeat

                                            if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                                            (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin
                                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                                    ChargeAmount := TransactionCharges."Charge Amount"
                                                else
                                                    ChargeAmount := TransactionCharges."Charge Amount";

                                                TChargeAmount += ChargeAmount;

                                            end;
                                        until TransactionCharges.Next = 0;

                                    end;
                                end;
                            end;
                    end;
                end;
            end;
        }
        field(50011; "Branch Code"; Code[20])
        {
            Editable = false;
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50012; "Account Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Savings,Current';
            OptionMembers = "Savings","Current";
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Account Name"; Text[50])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50014; "Address"; Text[35])
        {
            Editable = false;
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(50015; "Customer ID"; Code[11])
        {
            Editable = false;
            Caption = 'Customer ID';
            DataClassification = CustomerContent;
        }
        field(50016; "Relation Indicator"; Option)
        {
            OptionCaption = 'Primary,Suplimentary';
            OptionMembers = "Primary","Suplimentary";
            Caption = 'Relation Indicator';
            DataClassification = CustomerContent;
        }
        field(50017; "Card Type"; Code[10])
        {
            TableRelation = "ATM Card Types".Code;
            Caption = 'Card Type';
            DataClassification = CustomerContent;
        }
        field(50018; "Request Type"; Option)
        {
            OptionCaption = 'New,Replacement';
            OptionMembers = "New","Replacement";
            Caption = 'Request Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Account No");
                if "Request Type" = "Request Type"::Replacement then begin
                    SavingsAccountss.Get("Account No");
                    "Replacement For Card No" := SavingsAccountss."ATM No.";
                end else begin
                    "Replacement For Card No" := '';
                end;
            end;
        }
        field(50019; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50020; "Card No"; Code[30])
        {
            Caption = 'Card No';
            DataClassification = CustomerContent;
        }
        field(50021; "Date Issued"; Date)
        {
            Editable = false;
            Caption = 'Date Issued';
            DataClassification = CustomerContent;
        }
        field(50022; "Limit"; Decimal)
        {
            Caption = 'Limit';
            DataClassification = CustomerContent;
        }
        field(50023; "Terms Read and Understood"; Boolean)
        {
            Caption = 'Terms Read and Understood';
            DataClassification = CustomerContent;
        }
        field(50024; "Card Issued"; Boolean)
        {
            Editable = false;
            Caption = 'Card Issued';
            DataClassification = CustomerContent;
        }
        field(50025; "Form No"; Code[30])
        {
            Editable = false;
            TableRelation = "ATM Applications"."No.";
            Caption = 'Form No';
            DataClassification = CustomerContent;
        }
        field(50026; "Sent To External File"; Option)
        {
            OptionMembers = "No","Yes";
            Caption = 'Sent To External File';
            DataClassification = CustomerContent;
        }
        field(50027; "Card Status"; Option)
        {
            Editable = false;
            OptionMembers = "Pending","Active","Frozen";
            Caption = 'Card Status';
            DataClassification = CustomerContent;
        }
        field(50028; "Date Activated"; Date)
        {
            Editable = false;
            Caption = 'Date Activated';
            DataClassification = CustomerContent;
        }
        field(50029; "Date Frozen"; Date)
        {
            Editable = false;
            Caption = 'Date Frozen';
            DataClassification = CustomerContent;
        }
        field(50030; "Replacement For Card No"; Code[20])
        {
            Caption = 'Replacement For Card No';
            DataClassification = CustomerContent;
        }
        field(50031; "Phone No."; Code[20])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(50032; "No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50033; "Collected"; Boolean)
        {
            Editable = false;
            Caption = 'Collected';
            DataClassification = CustomerContent;
        }
        field(50034; "Application Approved"; Boolean)
        {
            Editable = false;
            Caption = 'Application Approved';
            DataClassification = CustomerContent;
        }
        field(50035; "Date Collected"; Date)
        {
            Editable = false;
            Caption = 'Date Collected';
            DataClassification = CustomerContent;
        }
        field(50036; "Card Issued By"; Code[20])
        {
            Editable = false;
            Caption = 'Card Issued By';
            DataClassification = CustomerContent;
        }
        field(50037; "Approval Date"; Date)
        {
            Editable = false;
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
        field(50038; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = "Open","Pending Approval","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50039; "Card Expiry Date"; Date)
        {
            Editable = false;
            Caption = 'Card Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50040; "Posted By."; Code[80])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Posted By.';
            DataClassification = CustomerContent;
        }
        field(50041; "Responsibility Center"; Code[10])
        {
            Editable = true;
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50042; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50043; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50044; "Card Issued Date"; Date)
        {
            Editable = false;
            Caption = 'Card Issued Date';
            DataClassification = CustomerContent;
        }
        field(50045; "PIN Issued Date"; Date)
        {
            Editable = false;
            Caption = 'PIN Issued Date';
            DataClassification = CustomerContent;
        }
        field(50046; "PIN Issued By"; Code[20])
        {
            Editable = false;
            Caption = 'PIN Issued By';
            DataClassification = CustomerContent;
        }
        field(50047; "Linked Date"; Date)
        {
            Editable = false;
            Caption = 'Linked Date';
            DataClassification = CustomerContent;
        }
        field(50048; "ATM Linked"; Boolean)
        {
            Editable = false;
            Caption = 'ATM Linked';
            DataClassification = CustomerContent;
        }
        field(50049; "ATM Charges Applied"; Boolean)
        {
            Caption = 'ATM Charges Applied';
            DataClassification = CustomerContent;
        }
        field(50050; "ATM Charged Date"; Date)
        {
            Caption = 'ATM Charged Date';
            DataClassification = CustomerContent;
        }
        field(50051; "PIN Issued"; Boolean)
        {
            Editable = false;
            Caption = 'PIN Issued';
            DataClassification = CustomerContent;
        }
        field(50052; "Linked By"; Code[20])
        {
            Editable = false;
            Caption = 'Linked By';
            DataClassification = CustomerContent;
        }
        field(50053; "Delinked By"; Code[20])
        {
            Editable = false;
            Caption = 'Delinked By';
            DataClassification = CustomerContent;
        }
        field(50054; "ATM Delinked"; Boolean)
        {
            Editable = false;
            Caption = 'ATM Delinked';
            DataClassification = CustomerContent;
        }
        field(50055; "ATM Delinked Date"; Date)
        {
            Editable = false;
            Caption = 'ATM Delinked Date';
            DataClassification = CustomerContent;
        }
        field(50056; "Sales Agent"; Code[20])
        {
            Caption = 'Sales Agent';
            DataClassification = CustomerContent;
        }
        field(50057; "Captured By"; Code[50])
        {
            Editable = false;
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50058; "Capture Date"; Date)
        {
            Editable = false;
            Caption = 'Capture Date';
            DataClassification = CustomerContent;
        }
        field(50059; "Approved  By"; Code[50])
        {
            Editable = false;
            Caption = 'Approved  By';
            DataClassification = CustomerContent;
        }
        field(50060; "Sales Agent Type"; Option)
        {
            OptionCaption = 'BDE,Others';
            OptionMembers = "BDE","Others";
            Caption = 'Sales Agent Type';
            DataClassification = CustomerContent;
        }
        field(50061; "Auto Applied"; Boolean)
        {
            Editable = false;
            Caption = 'Auto Applied';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ATMApplications.Reset;
                ATMApplications.SetRange(ATMApplications."Account No", "Account No");
                ATMApplications.SetRange(ATMApplications."ATM Delinked", false);
                if ATMApplications.Find('-') then begin
                    repeat
                        if ATMApplications."ATM Charges Applied" = false
                          then
                            Error('This Account has an active ATM application');
                    until ATMApplications.Next = 0;
                end;
                TestField("Card Type");
                UserSetup.Get(UserId);
                SavingsAccounts.Reset;
                SavingsAccounts.SetRange(SavingsAccounts."No.", "Account No");
                if SavingsAccounts.Find('-') then begin
                    Members.Reset;
                    Members.SetRange(Members."No.", SavingsAccounts."Member No.");
                    if Members.Find('-') then begin

                        "Account Name" := Members.Name;
                        "Customer ID" := Members."ID No.";
                        "Phone No." := SavingsAccounts."Mobile No.";
                        Address := Members."Current Address";
                    end else begin

                        "Account Name" := '';
                        "Customer ID" := '';
                        "Phone No." := '';
                        Address := '';
                    end;

                    AvailableBalance := 0;
                    MinBalance := 0;

                    if Account.Get(SavingsAccounts."No.") then begin
                        Account.CalcFields(Account.Balance, Account."Uncleared Cheques", Account."Authorised Over Draft", Account."Balance (LCY)");
                        ProdType.Reset;
                        ProdType.SetRange(ProdType."Product ID", Account."Product Type");
                        if ProdType.Find('-') then begin
                            MinBalance := ProdType."Minimum Balance";
                            AvailableBalance := (Account."Balance (LCY)" + Account."Authorised Over Draft") - (MinBalance + Account."Uncleared Cheques");
                        end;
                    end;

                    GenSetup.Get;
                    ChargeAmount := 0;

                    ATMCardTypes.Reset;
                    ATMCardTypes.SetRange(ATMCardTypes.Code, "Card Type");
                    if ATMCardTypes.Find('-') then begin
                        if "Request Type" = "Request Type"::New then begin
                            TransType.Reset;
                            TransType.SetRange(TransType.Code, ATMCardTypes."Application Charge Code");//TransType.Type::"ATM Applications");
                            if TransType.Find('-') then begin
                                ChargeAmount := 0;
                                TransactionCharges.Reset;
                                TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransType.Code);
                                if TransactionCharges.Find('-') then begin
                                    ;
                                    repeat

                                        if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                                        (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin
                                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                                ChargeAmount := TransactionCharges."Charge Amount"//(TransType.Amount*TransactionCharges."Percentage of Amount")*0.01
                                            else
                                                ChargeAmount := TransactionCharges."Charge Amount";

                                            TChargeAmount += ChargeAmount;

                                        end;
                                    until TransactionCharges.Next = 0;

                                end;
                            end;
                        end else

                            if "Request Type" = "Request Type"::Replacement then begin
                                TransType.Reset;
                                TransType.SetRange(TransType.Code, ATMCardTypes."Replacement Charge Code");//"Application Charge Code");//TransType.Type::"ATM Applications");
                                if TransType.Find('-') then begin
                                    ChargeAmount := 0;
                                    TransactionCharges.Reset;
                                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransType.Code);
                                    if TransactionCharges.Find('-') then begin

                                        repeat

                                            if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                                            (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin
                                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                                    ChargeAmount := TransactionCharges."Charge Amount"
                                                else
                                                    ChargeAmount := TransactionCharges."Charge Amount";

                                                TChargeAmount += ChargeAmount;

                                            end;
                                        until TransactionCharges.Next = 0;

                                    end;
                                end;
                            end;
                    end;
                end;
                if AvailableBalance < TChargeAmount then begin

                    SavingsACC.Reset;
                    SavingsACC.SetRange("No.", "Account No");
                    if SavingsACC.Find('-') then begin
                        // SendSMS.SendSms(SourceType::"ATM Collection",SavingsACC."Mobile Phone No",Txt004,"No.","Account No",FALSE);
                    end;

                end;

                CashierTransactions.Init;
                CashierTransactions."No." := '';
                CashierTransactions."Account No." := "Account No";
                CashierTransactions."Account Name" := "Account Name";
                CashierTransactions."Available Balance" := AvailableBalance;
                CashierTransactions."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                CashierTransactions."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                CashierTransactions."ID No" := '';
                CashierTransactions."Responsibility Centre" := "Responsibility Center";
                CashierTransactions.Amount := TChargeAmount;
                CashierTransactions.Cashier := UserId;
                CashierTransactions.Remarks := 'ATM Application Charges';
                CashierTransactions.Posted := true;
                CashierTransactions.Type := CashierTransactions.Type::Lien;
                CashierTransactions.Insert(true);
            end;
        }
        field(50062; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            BankingNoSetup.Get();
            BankingNoSetup.TestField(BankingNoSetup."ATM Application Nos");
            
        end;
        "Application Date" := Today;
        UserSetup.Get(UserId);
       
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");

        "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Center" := UserSetup."Responsibility Centre";

        "Capture Date" := Today;
        "Captured By" := UserId;
        GeneralSetUp.Get();
        Limit := GeneralSetUp."Maximum ATM Limit";
        "Form No" := "No.";
       
    end;

    var
        BankingNoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        SavingsAccounts: Record "Account Banking";
        Members: Record Member;
        SavingsAccountss: Record "Account Banking";
        TChargeAmount: Decimal;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        GenSetup: Record "General Set-Up";
        TransType: Record "Transaction Types";
        Account: Record "Account Banking";
        AvailableBalance: Decimal;
        MinBalance: Decimal;
        ProdType: Record "Product Factory";
        ATMCardTypes: Record "ATM Card Types";
        UserSetup: Record "User Setup";
        ATMApplications: Record "ATM Applications";
        CashierTransactions: Record "Teller Transaction";
        SavingsACC: Record "Account Banking";
        GeneralSetUp: Record "General Set-Up";
}




