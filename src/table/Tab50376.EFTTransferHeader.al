table 50376 "EFT Transfer Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

               
            end;
        }
        field(50010; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "Time Entered"; Time)
        {
            Editable = false;
            Caption = 'Time Entered';
            DataClassification = CustomerContent;
        }
        field(50012; "No. Series"; Code[50])
        {
            Editable = false;
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50013; "Account Type"; Enum "AccountTypesExtended")
        {
            Caption = 'Account Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50014; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            else
            if
            ("Account Type" = const(Customer)) Customer else
            if
            ("Account Type" = const("Bank Account")) "Bank Account" where("Bank Type" = filter(Bank | Normal), Blocked = const(false)) else
            if
            ("Account Type" = const(Vendor)) Vendor else
            if
            ("Account Type" = const(Savings)) "Account Banking";
        
            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
                TransType: Record "Transaction Types";
            begin

                case "Account Type" of
                    "Account Type"::"Bank Account":
                        begin
                            if BankAccount.Get("Account No.") then
                                "Account Name" := BankAccount.Name;
                        end;
                end;
                TransType.Reset();
                TransType.SetRange(Type, TransType.Type::EFT);
                if TransType.FindFirst() then begin
                    "Transaction Type" := TransType.Code
                end;

            end;
        }
        field(50015; "Account Name"; Text[100])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50016; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50017; "Record Total"; Decimal)
        {
            CalcFormula = Sum("EFT Transfer Lines".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Record Total';
        }
        field(50018; "Record Count"; Integer)
        {
            CalcFormula = Count("EFT Transfer Lines" WHERE("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Record Count';
        }
        field(50019; "Document Type"; Option)
        {
            OptionCaption = ' ,Electronic Fund Transfer,RTGS,Close Account';
            OptionMembers = "","Electronic Fund Transfer","RTGS","Close Account";
            Caption = 'Document Type';
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Transaction Type" := '';
            end;
        }
        field(50020; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50021; "Created By"; Code[60])
        {
            Editable = false;
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50022; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50023; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Bankingsetup: Record "Banking No. Setup";
            begin
                Bankingsetup.Get();
                Bankingsetup.TestField("EFT Post Days");

                if CalcDate(Bankingsetup."EFT Post Days", "Start Date") < Today then
                    Error(ErrorOnInvalidStartDateRange, Bankingsetup."EFT Post Days");

                if "End Date" <> 0D then
                    if "Start Date" > "End Date" then
                        Error(ErrorOnInvalidStartDate);
            end;
        }
        field(50024; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "End Date" > Today then
                    Error('End Date cannot be greater than today');
                if "Start Date" <> 0D then
                    if "End Date" < "Start Date" then
                        Error('End Date cannot be less than Start Date');
            end;
        }
        field(50025; "Date Transferred"; Date)
        {
            Editable = false;
            Caption = 'Date Transferred';
            DataClassification = CustomerContent;
        }
        field(50026; "Time Transferred"; Time)
        {
            Editable = false;
            Caption = 'Time Transferred';
            DataClassification = CustomerContent;
        }
        field(50027; "Transferred By"; Code[60])
        {
            Caption = 'Transferred By';
            DataClassification = CustomerContent;
        }
        field(50028; "Salary Processing No."; Code[20])
        {
            Caption = 'Salary Processing No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Salary Options"; Option)
        {
            OptionMembers = "Add To Existing","Replace Lines";
            Caption = 'Salary Options';
            DataClassification = CustomerContent;
        }
        field(50030; "Transaction Type"; Code[20])
        {
            TableRelation = IF ("Document Type" = filter("Electronic Fund Transfer" | "Close Account")) "Transaction Types".Code WHERE(Type = CONST(EFT))
            ELSE
            IF ("Document Type" = CONST(RTGS)) "Transaction Types".Code WHERE(Type = CONST(RTGS));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                getCharges;
            end;
        }
        field(50031; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50032; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50033; "Responsibility Centre"; Code[20])
        {
            Description = 'LookUp to Responsibility Center BR';
            Editable = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50034; "Standing Order EFT Done"; Boolean)
        {
            Caption = 'Standing Order EFT Done';
            DataClassification = CustomerContent;
        }
        field(50035; "Document No. Filter"; Code[250])
        {
            FieldClass = FlowFilter;
            Caption = 'Document No. Filter';
        }
        field(50036; "Source of funds"; Enum "SourceOfFunds")
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50037; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Application Source" = const(Credit)) "Product Factory" where("Product Class" = const(Loan), Status = const(Active))
            else
            if ("Application Source" = const(Benefits), "Source of funds" = filter("Fosa Savings" | Refunds | "Final Dues")) "Product Factory" where("Product Class" = const(Account), Status = const(Active),
            "Account Category" = filter("Specialty Savings" | "Shares Deposit"))
            else
            if ("Application Source" = const(Teller)) "Product Factory" where("Product Class" = const(Account), Status = const(Active),
            "Account Category" = filter("Specialty Savings")) else
            if ("Application Source" = const(Benefits), "Source of funds" = filter(Junior)) "Product Factory" where("Product Class" = const(Account), Status = const(Active),
            "Account Category" = filter(Junior));
        
            trigger OnValidate()
            begin
                if "Source of funds" = "Source of funds"::Junior then begin
                    TestField("Member No.");
                end;
            end;
        }
        field(50038; "EFT Options"; Enum "EFTPaymentOptions")
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if "Source of funds" = "Source of funds"::Junior then
                    TestField("Member No.");
            end;
        }
        field(50039; "Suggest All Product"; Boolean)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Suggest All Product" then begin
                    Validate("Loan No.", '');
                end;

            end;
        }
        field(50040; "Application Source"; Enum "ApplicationSource")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50041; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Source of funds" = filter(Junior)) Member where(Status = filter(Deceased)) else
            if ("Source of funds" = filter(Refunds)) Member where(Status = filter(Deceased | Withdrawn)) else
            Member where(Status = filter(Active | New | Dormant));
        
            trigger OnValidate()
            begin

                TestField("Source of funds");
            end;
        }
        field(50042; "Re-suggest Application"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50043; "Reason for Re-suggestion"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50044; "Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Loans where("Outstanding Balance" = filter(> 0));
        
            trigger OnValidate()
            var
                EftLine: Record "EFT Transfer Lines";
            begin

                if "Loan No." <> '' then begin
                    TestField("Suggest Single Loan", true);
                end;
            end;
        }
        field(50045; "Suggest Single Loan"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50046; "External Payment Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Loan+External","Loan","External Payment";
            OptionCaption = 'Suggest All,Suggest Loan,Suggest External Payment';
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
    var
        TransType: Record "Transaction Types";
    begin

        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."EFT Nos.");
           
        end;

        "Date Entered" := Today;
        "Time Entered" := Time;
        "Created By" := UserId;

        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");
        UserSetup.TestField("Account Department");
        "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Centre" := UserSetup."Responsibility Centre";
        "Application Source" := UserSetup."Account Department";

        TransType.Reset();
        TransType.SetRange(Type, TransType.Type::EFT);
        if TransType.FindFirst() then
            "Transaction Type" := TransType.Code;
    end;

    var
        SeriesSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        EFTDetails: Record "EFT Transfer Lines";
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        SAccount: Record "Account Banking";
        AvailableBal: Decimal;
        SCharge: Decimal;
        ErrorOnInvalidStartDate: Label 'Start Date cannot be greater than End Date';
        ErrorOnInvalidStartDateRange: Label 'Start Date cannot be less than %1 days from today';
        TCharge: Decimal;
        UserSetup: Record "User Setup";
        ErrorOnReliefLoan: Label 'Suggest single loan only applies to Relief Loans';


    procedure getCharges()
    var
        Text001: Label 'Account %1 has insufficient funds to enable successful transaction.';
    begin

        //*
        TCharge := 0;
        EFTDetails.Reset;
        EFTDetails.SetRange(EFTDetails."Document No.", "No.");
        EFTDetails.SetRange(EFTDetails."Don't Charge", false);
        if EFTDetails.Find('-') then begin
            repeat
                TransactionCharges.Reset;
                TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
                if TransactionCharges.Find('-') then begin
                    SCharge := 0;
                    repeat
                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then
                            SCharge := (EFTDetails.Amount * TransactionCharges."Percentage of Amount") * 0.01
                        else
                            SCharge := TransactionCharges."Charge Amount";

                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                            TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                            TariffDetails.Reset;
                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                            if TariffDetails.Find('-') then begin
                                repeat
                                    if (EFTDetails.Amount >= TariffDetails."Lower Limit") and (EFTDetails.Amount <= TariffDetails."Upper Limit") then begin
                                        if TariffDetails."Use Percentage" then
                                            SCharge := EFTDetails.Amount * TariffDetails.Percentage * 0.01
                                        else
                                            SCharge := TariffDetails."Charge Amount";
                                    end;
                                until TariffDetails.Next = 0;
                            end;
                        end;
                        TCharge += SCharge;
                    until TransactionCharges.Next = 0;
                end;

                EFTDetails."Charge Amount" := TCharge;

                AvailableBal := 0;
                if SAccount.Get(EFTDetails."Account No.") then begin
                    SAccount.CalcFields(SAccount."Balance (LCY)");
                    AvailableBal := SAccount."Balance (LCY)" - (SAccount."Monthly Contribution" + EFTDetails."Charge Amount");
                    if AvailableBal < EFTDetails.Amount then
                        Error(Text001, EFTDetails."Account No." + ' :-' + EFTDetails."Account Name");
                end;

                EFTDetails.Modify
          until EFTDetails.Next = 0;
        end;
    end;

    procedure CheckMinRequired(ValuePost: Integer)
    var
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        LoanRec: Record Loans;
    begin

        case ValuePost of
            0:
                begin
                    Rec.TestField("Document Type");
                    Rec.TestField("Account No.");
                    Rec.TestField("Source of funds");
                    Rec.TestField("EFT Options");
                    if "Application Source" = "Application Source"::Credit then begin
                        Rec.TestField("Start Date");
                        Rec.TestField("End Date");
                    end;

                    Rec.TestField(Remarks);
                    Rec.TestField("Approval Status", "Approval Status"::Approved);

                    EFTDetails.Reset;
                    EFTDetails.SetRange(EFTDetails."Document No.", "No.");
                    if EFTDetails.Find('-') then begin
                        repeat
                            EFTDetails.TestField("Account No.");
                            EFTDetails.TestField(Amount);
                            if "Application Source" = "Application Source"::Credit then begin
                                EFTDetails.TestField("Bank Code");
                                EFTDetails.TestField("Branch Code");
                            end;
                            EFTDetails.TestField("External Account No.");
                        until EFTDetails.Next() = 0;
                    end;
                end;
            1:
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Posted);
                end;
            2:
                begin
                    Rec.TestField("Document Type");
                    Rec.TestField("Account No.");
                    Rec.TestField("Source of funds");
                    Rec.TestField("EFT Options");
                    Rec.TestField(Remarks);
                    if "Application Source" = "Application Source"::Credit then begin
                        Rec.TestField("Start Date");
                        Rec.TestField("End Date");
                    end;
                    EFTDetails.Reset;
                    EFTDetails.SetRange(EFTDetails."Document No.", "No.");
                    if EFTDetails.Find('-') then begin
                        repeat
                            EFTDetails.TestField("Account No.");
                            EFTDetails.TestField(Amount);
                            if "Application Source" = "Application Source"::Credit then begin
                                EFTDetails.TestField("Bank Code");
                                EFTDetails.TestField("Branch Code");
                            end;
                            EFTDetails.TestField("External Account No.");
                        until EFTDetails.Next() = 0;
                    end;
                end;
            3:
                begin
                    Rec.Reset();
                    Rec.SetFilter("No.", Rec."No.");
                    Report.Run(Report::"EFT Report", true, true, Rec);
                    Rec.Reset();
                end;
            4:
                begin

                end;
        end;
    end;

}




