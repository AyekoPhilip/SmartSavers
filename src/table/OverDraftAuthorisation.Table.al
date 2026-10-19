table 50436 "Over Draft Authorisation"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52140622;
    LookupPageID = 52140622; */

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50010; "Account No."; Code[20])
        {
            TableRelation = "Account Banking";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if Account.Get("Account No.") then begin
                    "Account Name" := Account.Name;
                    "Product Type" := Account."Product Type";
                    if ProductTypes.Get("Product Type") then begin
                        if ProductTypes."Allow Over Draft" = false then
                            Error('Overdraft not allowed for this account type.');
                        ProductTypes.TestField(ProductTypes."Over Draft Interest Account");

                        "Overdraft Interest %" := ProductTypes."Over Draft Interest (%)";
                    end;
                end else begin
                    if Bank.Get("Account No.") then begin
                        "Account Name" := Bank.Name;
                    end;
                end;
            end;
        }
        field(50011; "Account Name"; Text[50])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Client No."; Code[20])
        {
            Caption = 'Client No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Effective/Start Date"; Date)
        {
            Caption = 'Effective/Start Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                "Expiry Date" := CalcDate(Duration, "Effective/Start Date");
                Validate("Expiry Date");
            end;
        }
        field(50014; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                AllowMultipleOD := false;

                if ("Effective/Start Date" <> 0D) and ("Expiry Date" <> 0D) then begin
                    if Account.Get("Account No.") then begin
                        if ProductTypes.Get("Product Type") then begin
                            AllowMultipleOD := ProductTypes."Allow Multiple Over Draft";
                        end;
                    end;


                    OverDraftAuth.Reset;
                    OverDraftAuth.SetCurrentKey(OverDraftAuth."Account No.", OverDraftAuth.Status, OverDraftAuth.Expired);
                    OverDraftAuth.SetRange(OverDraftAuth."Account No.", "Account No.");
                    OverDraftAuth.SetRange(OverDraftAuth.Status, OverDraftAuth.Status::Pending);
                    OverDraftAuth.SetRange(OverDraftAuth.Expired, false);
                    if OverDraftAuth.Find('-') then begin
                        repeat
                            if ("Effective/Start Date" >= OverDraftAuth."Effective/Start Date") and ("Effective/Start Date" <= OverDraftAuth."Expiry Date") then begin
                                if AllowMultipleOD = true then begin
                                    if Confirm('There is an already approved Over Draft within the specified period. - %1. Do you wish to issue another one?' +
                                       '', false, OverDraftAuth."No.") = false then
                                        Error('Process Terminated.');
                                end else
                                    Error('There is an already approved Over Draft within the specified period. - %1. Cancel an existing one if you' +
                                           ' want to issue another one.', OverDraftAuth."No.");

                            end;


                            if ("Expiry Date" >= OverDraftAuth."Effective/Start Date") and ("Expiry Date" <= OverDraftAuth."Expiry Date") then begin
                                if AllowMultipleOD = true then begin
                                    if Confirm('There is an already approved Over Draft within the specified period. - %1. Do you wish to issue another one?' +
                                       '', false, OverDraftAuth."No.") = false then
                                        Error('Process Terminated.');
                                end else
                                    Error('There is an already approved Over Draft within the specified period. - %1. Cancel an existing one if you' +
                                           ' want to issue another one.', OverDraftAuth."No.");

                            end;

                        until OverDraftAuth.Next = 0;
                    end;
                end;
            end;
        }
        field(50015; "Duration"; DateFormula)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                TestField("Effective/Start Date");
                TestField(Duration);

                if "Effective/Start Date" < Today then
                    Error('Effective date cannot be in the past.');

                "Expiry Date" := CalcDate(Duration, "Effective/Start Date");
                Validate("Expiry Date");
            end;
        }
        field(50016; "Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = "Open","Pending","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50017; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50018; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Approved Amount" > "Requested Amount" then
                    Error('Approved Amount cannot be greater than the requeested amount.');
            end;
        }
        field(50019; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50020; "Created By"; Code[50])
        {
            Editable = false;
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50021; "Date Approved"; Date)
        {
            Caption = 'Date Approved';
            DataClassification = CustomerContent;
        }
        field(50022; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST(Overdraft));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50023; "Liquidated"; Boolean)
        {
            Editable = false;
            Caption = 'Liquidated';
            DataClassification = CustomerContent;
        }
        field(50024; "Date Liquidated"; Date)
        {
            Editable = false;
            Caption = 'Date Liquidated';
            DataClassification = CustomerContent;
        }
        field(50025; "Liquidated By"; Code[50])
        {
            Editable = false;
            Caption = 'Liquidated By';
            DataClassification = CustomerContent;
        }
        field(50026; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50027; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50028; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50029; "Approved By"; Code[50])
        {
            Editable = false;
            Caption = 'Approved By';
            DataClassification = CustomerContent;
        }
        field(50030; "Canceled By"; Code[50])
        {
            Editable = false;
            Caption = 'Canceled By';
            DataClassification = CustomerContent;
        }
        field(50031; "Overdraft Interest %"; Decimal)
        {
            Caption = 'Overdraft Interest %';
            DataClassification = CustomerContent;
        }
        field(50032; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50033; "Application Date"; Date)
        {
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50034; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50035; "Issue to"; Option)
        {
            OptionCaption = 'Account,Cashier';
            OptionMembers = "Account","Cashier";
            Caption = 'Issue to';
            DataClassification = CustomerContent;
        }
        field(50036; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                "Approved Amount" := "Requested Amount";
                Validate("Approved Amount");
            end;
        }
        field(50037; "Expired"; Boolean)
        {
            Editable = false;
            Caption = 'Expired';
            DataClassification = CustomerContent;
        }
        field(50038; "Available Balance"; Decimal)
        {
            Caption = 'Available Balance';
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
            NoSetup.Get;
            NoSetup.TestField(NoSetup."Overdraft Nos");
           
        end;


        "Created By" := UpperCase(UserId);



        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if UserSetup.Find('-') then begin
            //UserSetup.TESTFIELD(UserSetup."Responsibility Center");
            UserSetup.TestField(UserSetup."Global Dimension 1 Code");
            UserSetup.TestField(UserSetup."Global Dimension 2 Code");
            //"Responsibility Center":=UserSetup."Responsibility Center";
            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        end;
    end;

    var
        NoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Account: Record "Account Banking";
        Bank: Record "Bank Account";
        ProductTypes: Record "Product Factory";
        OverDraftAuth: Record "Over Draft Authorisation";
        AllowMultipleOD: Boolean;
        UserSetup: Record "User Setup";

    local procedure CalcAvailableBal()
    var
        TCharges: Decimal;
        MinAccBal: Decimal;
        Account: Record "Account Banking";
        AccountTypes: Record "Product Factory";
    begin

        TCharges := 0;
        "Available Balance" := 0;
        MinAccBal := 0;



        if Account.Get("Account No.") then begin
            Account.CalcFields(Account.Balance, Account."Uncleared Cheques", Account."Authorised Over Draft");

            AccountTypes.Reset;
            AccountTypes.SetRange(AccountTypes."Product ID", "Product Type");
            if AccountTypes.Find('-') then begin
                MinAccBal := AccountTypes."Minimum Contribution";

                "Available Balance" := (Account.Balance + Account."Authorised Over Draft") - (MinAccBal + Account."Uncleared Cheques");

            end;
        end;
    end;
}




