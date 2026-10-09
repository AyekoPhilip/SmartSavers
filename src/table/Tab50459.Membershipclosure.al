table 50459 "Membership closure"
{
    DrillDownPageID = "Membership Closure List";
    LookupPageID = "Membership Closure List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = if ("Close Account" = const(Specific),
            "Closure Type" = filter("Withdrawal - Normal")) Member where(Status = filter(Active | Dormant | New | "Withdrawal Application"))
            else
            if ("Close Account" = const(Specific), "Closure Type" = filter("Withdrawal - Death")) Member where(Status = filter(Deceased));
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                RegMgt: Codeunit "Register Management";
                TransacType: Record "Transaction Types";
                AccCredit: Record "Account Credit";
                AccBanking: Record "Account Banking";
                PFact: Record "Product Factory";
                Notice: Record "Member withdrawal Notice";
            begin
                GenSetup.Get();
                GenSetup.TestField("A/c Notice Charges Options");

                if Members.Get("Member No.") then begin
                    "Member Name" := Members.Name;
                    "ID No." := Members."ID No.";
                    "Total Loan" := RegMgt.getCustAccruedIntLoanBalance(0, Members."No.", 0);
                end;

                case Rec."Document Type" of
                    Rec."Document Type"::"Account Closure":
                        begin
                            Rec.TestField("Close Account", "Close Account"::Specific);
                            case "Account Dimension" of
                                "Account Dimension"::Credit,
                                "Account Dimension"::"Micro Credit":
                                    begin
                                        AccCredit.Reset();
                                        AccCredit.SetRange("No.", "Account No.");
                                        if AccCredit.FindFirst() then begin
                                            AccCredit.CalcFields("Balance (LCY)");
                                            "Member Savings" := AccCredit."Balance (LCY)";
                                            "Product Factory" := AccCredit."Product Type";

                                            TransacType.Reset();
                                            TransacType.SetRange(Type, TransacType.Type::Closure);
                                            if TransacType.FindFirst() then
                                                "Transaction Type" := TransacType.Code;
                                            "Other Charges" := RegMngt.getTransactionalCharges("Transaction Type", '', "Member Savings");
                                        end;
                                    end;
                                "Account Dimension"::Banking:
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("No.", "Account No.");
                                        if AccBanking.FindFirst() then begin
                                            AccBanking.CalcFields("Balance (LCY)");
                                            "Member Savings" := AccBanking."Balance (LCY)";
                                            "Product Factory" := AccBanking."Product Type";

                                            case AccBanking."Account Category" of
                                                AccBanking."Account Category"::"Money Market":
                                                    begin
                                                        TransacType.Reset();
                                                        TransacType.SetRange(Type, TransacType.Type::Closure);
                                                        if TransacType.FindFirst() then
                                                            "Transaction Type" := TransacType.Code;
                                                        "Other Charges" := RegMngt.getTransactionalCharges("Transaction Type", '', "Member Savings");

                                                    end else begin
                                                    TransacType.Reset();
                                                    TransacType.SetRange(Type, TransacType.Type::"Member Withdrawal");
                                                    if TransacType.FindFirst() then
                                                        "Transaction Type" := TransacType.Code;
                                                    "Other Charges" := RegMngt.getTransactionalCharges("Transaction Type", '', "Member Savings");
                                                end;
                                            end;
                                        end;
                                    end;
                            end;

                            case GenSetup."A/c Notice Charges Options" of
                                GenSetup."A/c Notice Charges Options"::"Charge Early Exit Fee":
                                    begin

                                        if "Notice M. Date" > Today then begin
                                            if PFact.Get("Product Factory") then begin
                                                PFact.TestField("Closure Fee");
                                                "Early Exit Charges" := RegMngt.getTransactionalCharges(PFact."Closure Fee", '', "Member Savings");
                                            end else begin
                                                "Early Exit Charges" := 0
                                            end;
                                        end;
                                    end;
                                GenSetup."A/c Notice Charges Options"::"Allow After Notice Expiry":
                                    begin
                                        if Notices."Maturity Date" > Today then Error(ErrorOnMaturityNotDateTxt, Notices."Maturity Date");
                                    end;
                                GenSetup."A/c Notice Charges Options"::"Ignore Charges":
                                    begin
                                        "Early Exit Charges" := 0;
                                    end;
                            end;
                            Validate("Close Account");
                        end;

                    Rec."Document Type"::"Membership Closure":
                        begin
                            case Rec."Close Account" of
                                Rec."Close Account"::All:
                                    begin

                                        AccCredit.Reset();
                                        AccCredit.SetRange("Member No.", "Member No.");
                                        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                                        if AccCredit.FindFirst() then begin
                                            AccCredit.CalcFields("Balance (LCY)");
                                            "Product Factory" := AccCredit."Product Type";

                                            if "Recovery from Fosa" then begin
                                                AccBanking.Reset();
                                                AccBanking.SetRange("Member No.", "Member No.");
                                                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                                                if AccBanking.FindFirst() then
                                                    "Member Savings" := TellerMngt.CalcAvailableBal(AccBanking."No.");

                                            end else begin
                                                "Member Savings" := AccCredit."Balance (LCY)";
                                            end;
                                            "Shares Capital" := RegMngt.GetOperationAccBalanceTxt(ProdtCategory::"Shares Capital", "Member No.", 2);

                                            TransacType.Reset();
                                            TransacType.SetRange(Type, TransacType.Type::"Member Withdrawal");
                                            if TransacType.FindFirst() then
                                                "Transaction Type" := TransacType.Code;
                                            "Include Charges" := true;
                                            "Other Charges" := RegMngt.getTransactionalCharges("Transaction Type", '', "Member Savings");

                                            if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then begin
                                                case GenSetup."A/c Notice Charges Options" of

                                                    GenSetup."A/c Notice Charges Options"::"Charge Early Exit Fee":
                                                        begin

                                                            if "Notice M. Date" > Today then begin
                                                                if PFact.Get("Product Factory") then begin
                                                                    PFact.TestField("Closure Fee");
                                                                    "Early Exit Charges" := RegMngt.getTransactionalCharges(PFact."Closure Fee", '', "Member Savings");
                                                                end else begin
                                                                    "Early Exit Charges" := 0
                                                                end;
                                                            end;
                                                        end;
                                                    GenSetup."A/c Notice Charges Options"::"Allow After Notice Expiry":
                                                        begin
                                                            if Notices."Maturity Date" > Today then Error(ErrorOnMaturityNotDateTxt, Notices."Maturity Date");
                                                        end;
                                                    GenSetup."A/c Notice Charges Options"::"Ignore Charges":
                                                        begin
                                                            "Early Exit Charges" := 0;
                                                        end;
                                                end;
                                            end else begin
                                                "Early Exit Charges" := 0
                                            end;

                                            if "Closure Type" = "Closure Type"::"Withdrawal - Death" then
                                                "Sum Insured" := RegMgt.getCustAccruedIntLoanBalance(0, Members."No.", 0) else
                                                "Sum Insured" := 0;

                                            CalcFields("Total Savings");
                                            "Deposit Refundable" := ("Sum Insured" + "Total Savings") - ((RegMngt.getCustLoanBalance(0, AccCredit."Member No.", 0) + "Other Charges" + "Early Exit Charges"));
                                            if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then
                                                if RegMgt.GetOperationAccBalanceTxt(AccCredit."Account Category", AccCredit."Member No.", 4) < (RegMngt.getCustLoanBalance(0, AccCredit."Member No.", 0) + ("Other Charges" + "Early Exit Charges")) then
                                                    Error(Txt0001);
                                            Validate("Close Account");

                                        end;
                                    end;
                            end;
                        end;
                end;
            end;
        }
        field(50011; "Member Name"; Text[150])
        {
            Editable = false;
            TableRelation = Member;
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Closing Date"; Date)
        {
            Editable = false;
            Caption = 'Closing Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50014; "Posted"; Boolean)
        {
            Editable = true;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50015; "Total Loan"; Decimal)
        {
            Caption = 'Total Loan';
            DataClassification = CustomerContent;
        }
        field(50016; "Total Interest"; Decimal)
        {
            Caption = 'Total Interest';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Validate("Loans Option");
            end;
        }
        field(50017; "Member Savings"; Decimal)
        {
            Caption = 'Member Savings';
            DataClassification = CustomerContent;
        }
        field(50018; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50019; "Closure Type"; Enum "AccClosureType")
        {
            Caption = 'Closure Type';
            DataClassification = CustomerContent;
            ValuesAllowed = 0, 1, 2, 4;
        
            trigger OnValidate()
            begin

                gensetup.Get();
                case "Closure Type" of
                    "Closure Type"::"Withdrawal - Normal":
                        begin
                            TestField("Document Type", "Document Type"::"Membership Closure");
                            "Account Type" := Rec."Account Type"::"Bank Account";
                        end;
                    "Closure Type"::"Withdrawal - Death":
                        begin
                            TestField("Document Type", "Document Type"::"Membership Closure");
                            Rec."Account Type" := Rec."Account Type"::"G/L Account";
                            gensetup.TestField("Membership Closure Control A/c");
                            "Paying Account No." := gensetup."Membership Closure Control A/c";
                        end;
                    "Closure Type"::"Close Specific Account":
                        begin
                            TestField("Document Type", "Document Type"::"Account Closure");
                            "Account Type" := "Account Type"::"Bank Account";
                        end;
                end;
            end;
        }
        field(50020; "Application Date"; Date)
        {
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50021; "Deposit Refundable"; Decimal)
        {
            Caption = 'Deposit Refundable';
            DataClassification = CustomerContent;
        }
        field(50022; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50023; "Close Account"; Option)
        {
            Editable = false;
            OptionCaption = ' ,All,Specific';
            OptionMembers = " ","All","Specific";
            Caption = 'Close Account';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Regmnt: Codeunit "Register Management";
                RunBal: Decimal;
                TransCharges: Record "Transaction Charge";
                AccCredit: Record "Account Credit";
                ProdFact: Record "Product Factory";
                gensetup: Record "General Set-Up";
                GlAcc: Record "G/L Account";
                AccBanking: Record "Account Banking";
                CreditAc: Record "Account Credit";
            begin
                Validate("Closure Type");

                RunBal := 0;

                AccLine.Reset();
                AccLine.SetRange(AccLine."No.", Rec."No.");
                AccLine.DeleteAll();

                gensetup.Get();
                //gensetup.TestField("Excise Duty (%)");
                //gensetup.TestField("Excise Duty G/L");

                Case "Document Type" of

                    "Document Type"::"Account Closure":
                        begin
                            if "Other Charges" > 0 then begin

                                TransCharges.Reset();
                                TransCharges.SetRange("Transaction Type", Rec."Transaction Type");
                                if TransCharges.FindFirst() then
                                    Regmnt.CreateClosureLine(Rec."No.", TransCharges."G/L Account",
                                           TransCharges.Description, 'FEE',
                                           "Member No.", "Other Charges",
                                           0, 0, 0, "Other Charges", '', ProdtCategory::Charges, Enum::ProductClass::Charge);

                                if TransCharges."Recover Excise Duty" then begin
                                    Regmnt.CreateClosureLine(Rec."No.", gensetup."Excise Duty G/L",
                                        'Excise Duty on ' + TransCharges.Description,
                                        'EXCISE DUTY',
                                         "Member No.", Round(("Other Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '='),
                                         0, 0, 0, Round(("Other Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '='), '', ProdtCategory::Charges, Enum::ProductClass::Charge);
                                end;
                            end;
                            if "Early Exit Charges" > 0 then begin

                                if ProdFact.Get("Product Factory") then
                                    TransCharges.Reset();
                                TransCharges.SetRange("Transaction Type", ProdFact."Closure Fee");
                                if TransCharges.FindFirst() then
                                    Regmnt.CreateClosureLine(Rec."No.", TransCharges."G/L Account",
                                    TransCharges.Description, 'PENALTY', AccCredit."Member No.", "Early Exit Charges", 0, 0, 0, "Early Exit Charges", '', ProdtCategory::Charges, Enum::ProductClass::Charge);

                                if TransCharges."Recover Excise Duty" then begin
                                    Regmnt.CreateClosureLine(Rec."No.", gensetup."Excise Duty G/L",
                                    'Excise Duty on ' + TransCharges.Description, 'EXCISE DUTY',
                                    AccCredit."Member No.", Round(("Early Exit Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '=')
                                    , 0, 0, 0, Round(("Early Exit Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '='), '', ProdtCategory::Charges, Enum::ProductClass::Charge);
                                end;
                            end;

                            case "Account Dimension" of
                                "Account Dimension"::Banking:
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("No.", "Account No.");
                                        if AccBanking.Find('-') then begin
                                            AccBanking.CalcFields("Balance (LCY)");
                                            if AccBanking."Balance (LCY)" > 0 then begin
                                                if ("Other Charges" + "Early Exit Charges") <= AccBanking."Balance (LCY)" then begin
                                                    Regmnt.CreateClosureLine("No.", AccBanking."No.",
                                                    AccBanking."Product Name",
                                                    AccBanking."Product Type", AccBanking."Member No.",
                                                    AccBanking."Balance (LCY)", 0, 0, 0,
                                                    AccBanking."Balance (LCY)", '', AccBanking."Account Category",
                                                    Enum::ProductClass::Account);
                                                end else begin
                                                    Error(ErrorOnAvailableBalTxt);

                                                end;
                                            end;
                                        end;
                                    end;
                                "Account Dimension"::Credit:
                                    begin

                                        CreditAc.Reset();
                                        CreditAc.SetRange("No.", "Account No.");
                                        if CreditAc.FindSet() then begin
                                            CreditAc.CalcFields("Balance (LCY)");
                                            if CreditAc."Balance (LCY)" > 0 then begin
                                                if ("Other Charges" + "Early Exit Charges") <= CreditAc."Balance (LCY)" then begin
                                                    Regmnt.CreateClosureLine("No.", CreditAc."No.", CreditAc."Product Name",
                                                                 CreditAc."Product Type", CreditAc."Member No.",
                                                                 CreditAc."Balance (LCY)", 0, 0, 0, CreditAc."Balance (LCY)", '',
                                                                 CreditAc."Account Category", Enum::ProductClass::Account);
                                                end else begin
                                                end;
                                            end;
                                        end;
                                    end;
                            end;
                            RunBal := "Member Savings" - ("Other Charges" + "Early Exit Charges");
                            "Deposit Refundable" := RunBal;
                        end;

                    "Document Type"::"Membership Closure":
                        begin

                            if "Close Account" = "Close Account"::All then begin
                                "Product Factory" := '';
                                "Loans Option" := "Loans Option"::All;

                                AccCredit.Reset();
                                AccCredit.SetRange("Member No.", "Member No.");
                                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                                if AccCredit.FindFirst() then begin
                                    "Product Factory" := AccCredit."Product Type";
                                    if "Other Charges" > 0 then begin

                                        TransCharges.Reset();
                                        TransCharges.SetRange("Transaction Type", Rec."Transaction Type");
                                        if TransCharges.FindFirst() then
                                            Regmnt.CreateClosureLine(Rec."No.", TransCharges."G/L Account",
                                            TransCharges.Description, 'FEE', AccCredit."Member No.", "Other Charges", 0, 0, 0,
                                            "Other Charges", '', ProdtCategory::Charges, Enum::ProductClass::Charge);
                                        if TransCharges."Recover Excise Duty" then begin
                                            Regmnt.CreateClosureLine(Rec."No.", gensetup."Excise Duty G/L",
                                            'Excise Duty on ' + TransCharges.Description, 'EXCISE DUTY',
                                            AccCredit."Member No.", Round(("Other Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '=')
                                            , 0, 0, 0, Round(("Other Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '='), '', ProdtCategory::Charges, Enum::ProductClass::Charge);
                                        end;
                                    end;

                                    if "Early Exit Charges" > 0 then begin

                                        if ProdFact.Get(AccCredit."Product Type") then
                                            TransCharges.Reset();
                                        TransCharges.SetRange("Transaction Type", ProdFact."Closure Fee");
                                        if TransCharges.FindFirst() then
                                            Regmnt.CreateClosureLine(Rec."No.", TransCharges."G/L Account",
                                            TransCharges.Description, 'PENALTY', AccCredit."Member No.", "Early Exit Charges", 0, 0, 0, "Early Exit Charges", '', ProdtCategory::Charges, Enum::ProductClass::Charge);

                                        if TransCharges."Recover Excise Duty" then begin
                                            Regmnt.CreateClosureLine(Rec."No.", gensetup."Excise Duty G/L",
                                            'Excise Duty on ' + TransCharges.Description, 'EXCISE DUTY',
                                            AccCredit."Member No.", Round(("Early Exit Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '=')
                                            , 0, 0, 0, Round(("Early Exit Charges" * (gensetup."Excise Duty (%)" / 100)), 1, '='), '', ProdtCategory::Charges, Enum::ProductClass::Charge);
                                        end;
                                    end;
                                end;

                                if "Sum Insured" > 0 then begin
                                    if GlAcc.Get("Paying Account No.") then
                                        Regmnt.CreateClosureLine(Rec."No.", "Paying Account No.", GlAcc.Name, 'INS', AccCredit."Member No.",
                                        "Sum Insured", 0, 0, 0, "Sum Insured", '', ProdtCategory::Insurance, Enum::ProductClass::" ");
                                end;
                                Regmnt.getMemberAccount(Rec."Member No.", Rec."No.", Rec."Close Account",
                                Rec."Closure Type", Rec."Account No.", Rec."Document Type", Rec."Member Savings", 0, "Account Dimension");
                                "Deposit Refundable" := "Member Savings" - ("Other Charges" + "Early Exit Charges" + "Total Loan");
                            end;
                        end;
                end;
            end;
        }
        field(50024; "Loans Option"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term,All,Specific';
            OptionMembers = " ","Short Term","Long Term","All","Specific";
            Caption = 'Loans Option';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                GenSetup.Get;
            end;
        }
        field(50025; "Entered By"; Code[30])
        {
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50026; "Transaction"; Option)
        {
            OptionCaption = 'Member Withdrawal';
            OptionMembers = "Member Withdrawal";
            Caption = 'Transaction';
            DataClassification = CustomerContent;
        }
        field(50027; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50028; "Benevolent Fund"; Decimal)
        {
            Caption = 'Benevolent Fund';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Validate("Loans Option");
            end;
        }
        field(50029; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50030; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50031; "Notice No."; Code[20])
        {
            TableRelation = "Member withdrawal Notice"."No." where(Paid = CONST(false),
                                                            Expired = CONST(false),
                                                                    "Approval Status" = CONST(Approved));
            Caption = 'Notice No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                PFact: Record "Product Factory";
                Gensetup: Record "General Set-Up";
            begin
                TestField("Posting Date");
                fnInitialize();
                AccLine.Reset();
                AccLine.SetRange(AccLine."No.", Rec."No.");
                AccLine.DeleteAll();

                if "Notice No." <> '' then begin

                    Gensetup.Get();
                    PendWithdrawal.Reset;
                    PendWithdrawal.SetRange("Notice No.", "Notice No.");
                    PendWithdrawal.SetFilter("Approval Status", '<>%1', PendWithdrawal."Approval Status"::Posted);
                    if PendWithdrawal.Find('-') then begin
                        Error(ErrorOnExistApplicTxt, PendWithdrawal."Notice No.",
                        PendWithdrawal."No.", PendWithdrawal."Member Name");
                    end;

                    Notices.Reset;
                    Notices.SetRange("No.", "Notice No.");
                    if Notices.Find('-') then begin
                        Validate("Document Type", Notices."Document Type");
                        Validate("Closure Type", Notices."Closure Type");
                        Validate("Account Dimension", Notices."Account Dimension");
                        "Member No." := Notices."Member No.";
                        Validate("Notice M. Date", Notices."Maturity Date");

                        case Notices."Document Type" of
                            Notices."Document Type"::"Account Closure":
                                begin
                                    Validate("Account No.", Notices."Account No.");
                                end;
                            Notices."Document Type"::"Membership Closure":
                                begin
                                    "Account No." := Notices."Account No."
                                end;
                        end;
                    end;
                end;
                Validate("Member No.");
            end;
        }
        field(50032; "Notice M. Date"; Date)
        {
            Editable = false;
            Caption = 'Notice M. Date';
            DataClassification = CustomerContent;
        }
        field(50033; "Include Charges"; Boolean)
        {
            Editable = false;
            Caption = 'Include Charges';
            DataClassification = CustomerContent;
        }
        field(50034; "Shares Capital"; Decimal)
        {
            Editable = false;
            Caption = 'Shares Capital';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Validate("Loans Option");
            end;
        }
        field(50035; "Loan No."; Code[20])
        {
            TableRelation = Loans."No." WHERE("Account No." = FIELD("Member No."),
                                               "Outstanding Balance" = FILTER(> 0));
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Total Interest")
            end;
        }
        field(50036; "Responsibility Center"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Center';
        }
        field(50037; "Product Factory"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class" = CONST(Account),
                                                                   Status = filter(Active),
                                                                  "Account Category" = FILTER("Shares Deposit" | "Shares Capital" | Junior));
            Caption = 'Product Factory';
        }
        field(50038; "Other Charges"; Decimal)
        {
            Editable = false;
            Caption = 'Other Charges';
        }
        field(50039; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Posted';
        }
        field(50040; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Posted By';
        }
        field(50041; "Transaction Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Close Account" = filter(Specific | All)) "Transaction Types" where(Type = const(Closure))
            else
            if ("Close Account" = const(All)) "Transaction Types" where(Type = const("Shares Transfer"));
        }
        field(50042; "Outstanding Principal"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50043; "Early Exit Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50044; "Total Amount (LCY)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Account Closure Line"."Amount to Post" where("No." = field("No."), "Member No." = field("Member No.")));
        }
        field(50045; "Date Posted"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50046; "Document Type"; Option)
        {
            OptionMembers = " ","Membership Closure","Account Closure";
            OptionCaption = ' ,Membership Withdrawal,Account Closure';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                AccLine.Reset();
                AccLine.SetRange(AccLine."No.", Rec."No.");
                AccLine.DeleteAll();

                case "Document Type" of
                    "Document Type"::"Account Closure":
                        begin
                            "Closure Type" := "Closure Type"::"Close Specific Account";
                            "Close Account" := "Close Account"::Specific;
                            "Account Type" := "Account Type"::Savings;
                            "Destination Type" := "Destination Type"::Savings;
                            "Loans Option" := "Loans Option"::" ";
                        end;
                    "Document Type"::"Membership Closure":
                        begin
                            "Close Account" := "Close Account"::All;
                            "Closure Type" := "Closure Type"::" ";
                        end;
                end;
            end;
        }
        field(50047; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Account Dimension" = const(Banking)) "Account Banking"."No." where(Blocked = const(" "), "Member No." = field("Member No."),
            Status = filter(Active | New | Dormant | Defaulter), "Account Category" = filter(Junior | "Money Market" | "Women Savings" | "Specialty Savings" | "Islamic Banking")) else
            if ("Account Dimension" = filter(Credit)) "Account Credit"."No." where(Blocked = const(" "), "Member No." = field("Member No."), "Account Category" = filter("Benevolent Fund"), Status = filter(Active | New | Dormant | Defaulter));
        
            trigger OnValidate()
            var
                FosaAc: Record "Account Banking";
            begin

            end;
        }
        field(50048; "Member Category"; Code[20])
        {
            TableRelation = "Member Category";
            DataClassification = CustomerContent;
        }
        field(50049; "Account Type"; Enum "CreditAccountTypes")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50050; "Destination Type"; Enum "AccountTypesExtended")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50051; "Destination Account No."; Code[20])
        {
            TableRelation = if ("Destination Type" = const(Savings), "Transfer Type" = const(Self)) "Account Banking"."No." where(Blocked = const(" "), "Member No." = field("Member No."),
            Status = filter(Active | New | Dormant | Defaulter), "Account Category" = filter(Savings)) else
            if ("Destination Type" = const(Savings), "Transfer Type" = const(Other)) "Account Banking"."No." where(Blocked = const(" "),
            Status = filter(Active | New | Dormant | Defaulter), "Account Category" = filter(Savings)) else

            if ("Destination Type" = const(credit), "Transfer Type" = const(Other)) Member."No.";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                FosaAc: Record "Account Banking";
            begin


            end;
        }
        field(50052; "Transfer Type"; Enum "IFTTransferTypes")
        {
            Caption = 'Transfer To';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            Var
                AccountB: Record "Account Banking";
            begin
                if "Transfer Type" = "Transfer Type"::Self then begin
                    AccountB.Reset();
                    AccountB.SetRange("Member No.", Rec."Member No.");
                    if AccountB.FindFirst() then begin
                        "Destination Type" := "Destination Type"::Savings;
                        "Destination Account No." := AccountB."No."
                    end;
                end else begin
                    "Destination Type" := "Destination Type"::Credit;
                    "Account No." := '';
                    "Destination Account No." := '';
                    "Other Charges" := 0;
                end;
            end;
        }
        field(50053; "Customer Type"; Enum "CreditCustomerType")
        {
            Editable = false;
            ValuesAllowed = 1, 4;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50054; "Recovery from Fosa"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }

        field(50055; "Paying Account No."; Code[20])
        {
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
                            if BankAccount.Get("Paying Account No.") then
                                "Account Name" := BankAccount.Name;
                        end;
                    "Account Type"::"G/L Account":
                        begin
                            gensetup.Get();
                            gensetup.TestField("Membership Closure Control A/c");
                            Rec.TestField("Paying Account No.", gensetup."Membership Closure Control A/c");
                        end;
                end;
                if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then begin
                    "EFT Bank Account" := "Paying Account No.";
                end;
            end;
        }

        field(50056; "Account Name"; Text[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50057; "Payment Destination"; Code[100])
        {
            TableRelation = "Cust. Bank Account"."Bank Account No." where(Code = field("Payment Destination Code"),
            "Member No." = field("Member No."));
            DataClassification = CustomerContent;
            Caption = 'Destination A/c';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50058; "Payment Destination Code"; Code[100])
        {
            TableRelation = "Cust. Bank Account".Code where("Member No." = field("Member No."));
            DataClassification = CustomerContent;
            Caption = 'Pay Point';
        
            trigger OnValidate()
            var
                AccBanking: Record "Account Banking";
            begin

            end;
        }
        field(50059; "EFT Options"; Enum "EFTPaymentOptions")
        {
            DataClassification = CustomerContent;
            Caption = 'EFT Option';
        }
        field(50060; "Pay Mode"; Enum "PaymentMode")
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Mode';
        }
        field(50061; "Total Savings"; Decimal)
        {
            Caption = 'Total Savings';
            FieldClass = FlowField;
            CalcFormula = sum("Account Closure Line"."Amount to Post" where("No." = field("No."), "Account Category" = filter(Savings | "Shares Capital" | "Shares Deposit" | "Specialty Savings" | Insurance)));
        }
        field(50062; "Total Liabilities"; Decimal)
        {
            Caption = 'Total Liabilities';
            FieldClass = FlowField;
            CalcFormula = sum("Account Closure Line"."Amount to Post" where("No." = field("No."), "Account Category" = filter(" ")));
        }
        field(50063; "EFT Bank Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
            Caption = 'EFT Bank Account';
        
            trigger OnValidate()
            begin
                TestField("Closure Type", "Closure Type"::"Withdrawal - Death");
            end;
        }
        field(50064; "Sum Insured"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sum Insured';
            Editable = false;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50065; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
        field(50066; "Total Amount (Net)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Account Closure Line"."Amount to Post" where("No." = field("No."), "Member No." = field("Member No."), "Product Class" = filter(Account)));
        }
        field(50067; "Total Amount (Charge)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Account Closure Line"."Amount to Post" where("No." = field("No."), "Member No." = field("Member No."), "Product Class" = filter(Charge)));
        }
        field(50068; "Total Amount (Liabilities)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Account Closure Line"."Amount to Post" where("No." = field("No."), "Member No." = field("Member No."), "Product Class" = filter(Loan)));
        }
        field(50070; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(91000; "Rcv Cheque No"; Code[20])
        {
            TableRelation = if ("Rcv Cheques Type" = filter("Computer Check")) "Cheque Register"."Cheque No." where("Bank Account No." = field("Payment Destination"),
                                                                                                              Issued = const(false),
                                                                                                              Voided = const(false),
                                                                                                              Cancelled = const(false));
            DataClassification = CustomerContent;
            Caption = 'Cheque No.';
            trigger OnValidate()
            var
                ChequeRegister: Record "Cheque Register";
            begin
                TestField("Pay Mode", "Pay Mode"::Cheque);

                if "Rcv Cheque No" <> '' then begin
                    RcvCheckFieldLength("Rcv Cheque No", 6, 6);

                    if "Rcv Cheques Type" = "Rcv Cheques Type"::"Computer Check" then begin
                        if Confirm('Are you sure you want to issue Cheque No. %1', false, "Rcv Cheque No") then begin

                            ChequeRegister.Reset();
                            ChequeRegister.SetRange(ChequeRegister."Cheque No.", "Rcv Cheque No");
                            if ChequeRegister.FindFirst() then begin
                                ChequeRegister."Entry Status" := ChequeRegister."Entry Status"::Issued;
                                ChequeRegister."Issued By" := UserId;
                                ChequeRegister."Issued Doc No." := "No.";
                                ChequeRegister."Cheque Date" := Today;
                                ChequeRegister.Issued := true;
                                ChequeRegister.Modify();

                            end;
                        end else
                            "Rcv Cheque No" := '';
                    end;
                end;

            end;
        }
        field(91001; "Rcv Cheques Type"; Enum ChequeType)
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque Type';
        }
    
        field(50069; "Net Amount"; Decimal)
        {
            Editable = false;
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

    trigger OnDelete()
    begin
        if "Approval Status" <> "Approval Status" then
            Error(Txt0000);
    end;

    trigger OnInsert()
    var
        Temp: Record "User Setup";
        TransacType: Record "Transaction Types";
    begin
        NoSetup.Get();
        NoSetup.TestField(NoSetup."Member Closure Nos.");
        "No. Series" := NoSetup."Member Closure Nos.";
        if NoSeriesMgt.AreRelated(NoSetup."Member Closure Nos.", xRec."No. Series") then
            "No. Series" := xRec."No. Series";
        "No." := NoSeriesMgt.GetNextNo("No. Series");

        "Closing Date" := Today;
        "Entered By" := UserId;
        "Application Date" := Today;

        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        Temp.TestField("Responsibility Centre");
        "Global Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Global Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Responsibility Center" := Temp."Responsibility Centre";

        TransacType.Reset();
        TransacType.SetRange(Type, TransacType.Type::Closure);
        if TransacType.FindFirst() then begin
            "Transaction Type" := TransacType.Code;
            "Include Charges" := true;
        end;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Membership closure";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                NoSetup.Get();
                NoSeriesMgt.TestManual(NoSetup."Member Closure Nos.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Membership closure"; xRecRef: Record "Membership closure"; var IsHandled: Boolean)
    begin
    end;






    procedure fnTestfields()
    begin

        TestField("Member No.");
        TestField(Remarks);
        TestField("Account No.");
        TestField("Pay Mode");
        case "Pay Mode" of
            "Pay Mode"::Cheque:
                begin
                    TestField("Account Type");
                    TestField("Paying Account No.");
                end;
            "Pay Mode"::EFT:
                begin
                    TestField("EFT Options");
                end;
        end;
    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        FosaAc: Record "Account Banking";
        Members: Record Member;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        AccLine: Record "Account Closure Line";
        GenSetup: Record "General Set-Up";
        ProdtCategory: Enum ProductAccountCategory;
        Txt0000: Label 'You cannot delete when status is not open';
        Txt0001: Label 'Member has more outstanding liabilities than available shares';
        Notices: Record "Member withdrawal Notice";
        RegMngt: Codeunit "Register Management";
        PendWithdrawal: Record "Membership closure";
        ErrorOnMinBalTxt: Label 'No enough funds for this transaction';
        ErrorOnNoexistPayFile: Label 'No External Payment file found for this application';
        ErrorOnOutstandLiabilitiesTxts: Label 'Member savings must be more than outstanding liabilities';
        ErrorOnAvailableBalTxt: Label 'Member savings must be more than outstanding liabilities';
        ErrorOnMaturityNotDateTxt: Label 'Membership closure Maturity Notice Date of %1 is greater than today. It should be less than/equal to Today';
        ErrorOnExistApplicTxt: Label 'There is an existing application attached to this Notice No. %1- Application No. %2- %3.';

    procedure getAvailableAmt(): Boolean
    var
        AccCredit: Record "Account Credit";
        MembShares: Decimal;
        Liabilities: Decimal;
    begin

        if Members.Get("Member No.") then begin

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Members."No.");
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
            if AccCredit.FindFirst() then begin
                MembShares := RegMngt.GetOperationAccBalanceTxt(AccCredit."Account Category", AccCredit."Member No.", 4);
            end;
            Liabilities := RegMngt.getCustAccruedIntLoanBalance(0, Members."No.", 0);

        end;
        if MembShares < (Liabilities + "Other Charges" + "Early Exit Charges") then
            exit(true) else
            exit(false)

    end;

    procedure CheckMinRequirement(PostInt: Integer)
    var
        AccountLine: Record "Account Closure Line";
        ExternalPaymt: Record "External Payment";
    begin
        case PostInt of
            0:
                begin

                    Rec.TestField("Document Type");
                    TestField("Pay Mode");
                    if "Pay Mode" = "Pay Mode"::EFT then
                        TestField("EFT Options");

                    if "Pay Mode" = "Pay Mode"::Cheque then begin
                        TestField("Rcv Cheque No");
                        TestField("Rcv Cheques Type");
                    end;

                    Rec.TestField(Remarks);
                    Rec.TestField("Closure Type");
                    Rec.TestField("Close Account");
                    Rec.TestField("Member No.");
                    Rec.TestField("Customer Type");

                    Case Rec."Document Type" of
                        Rec."Document Type"::"Account Closure":
                            begin
                                if FosaAc.Get(Rec."Account No.") then begin
                                    FosaAc.CalcFields("Balance (LCY)");
                                    if Rec."Other Charges" <> 0 then begin
                                        if (Rec."Other Charges" + Rec."Early Exit Charges") > FosaAc."Balance (LCY)" then
                                            Error(ErrorOnMinBalTxt);
                                    end;
                                end;
                            end;
                        Rec."Document Type"::"Membership Closure":
                            begin
                                if Rec."Closure Type" = Rec."Closure Type"::"Withdrawal - Normal" then begin
                                    if Rec.getAvailableAmt() then begin
                                        Error(ErrorOnOutstandLiabilitiesTxts);
                                    end;
                                end;
                            end;
                    End;

                    case "Closure Type" of
                        "Closure Type"::"Withdrawal - Normal":
                            begin
                                Rec.TestField("Account Type", "Account Type"::"Bank Account");
                                if "Pay Mode" = "Pay Mode"::EFT then begin
                                    Rec.TestField("Payment Destination");
                                    Rec.TestField("Payment Destination Code");
                                end;
                            end;
                        "Closure Type"::"Withdrawal - Death":
                            begin

                                ExternalPaymt.Reset();
                                ExternalPaymt.SetRange("Application No.", "No.");
                                ExternalPaymt.SetRange("Member No.", "Member No.");
                                if not ExternalPaymt.FindSet() then begin
                                    Error(ErrorOnNoexistPayFile);
                                end;

                                ExternalPaymt.Reset();
                                ExternalPaymt.SetRange("Application No.", "No.");
                                ExternalPaymt.SetRange("Member No.", "Member No.");
                                if ExternalPaymt.FindSet() then begin
                                    repeat
                                        ExternalPaymt.TestField(Amount);
                                        ExternalPaymt.TestField("Account No.");
                                        if ExternalPaymt."Account Type" = ExternalPaymt."Account Type"::"Bank Account" then begin
                                            ExternalPaymt.TestField("Payment Destination Code");
                                            ExternalPaymt.TestField("External Account No.");
                                            ExternalPaymt.TestField("External Account Name");
                                        end;
                                    until ExternalPaymt.Next() = 0;
                                end;
                            end;
                    end;

                    Rec.TestField("Closing Date");
                    Rec.TestField("Paying Account No.");

                    Notices.Reset;
                    Notices.SetRange("No.", "Notice No.");
                    if Notices.Find('-') then begin
                        case Notices."Closure Type" of
                            Notices."Closure Type"::"Withdrawal - Normal":
                                begin
                                    TestField("Closure Type", Notices."Closure Type");

                                    case GenSetup."A/c Notice Charges Options" of
                                        GenSetup."A/c Notice Charges Options"::"Allow After Notice Expiry":
                                            begin
                                                if Notices."Maturity Date" > Today then Error(ErrorOnMaturityNotDateTxt, Notices."Maturity Date");
                                            end;
                                    end;
                                end;

                            Notices."Closure Type"::"Withdrawal - Death":
                                begin
                                    TestField("Closure Type", Notices."Closure Type");
                                end;
                        end;
                    end;
                end;
            1:
                begin

                    Rec.TestField(Remarks);
                    TestField("Pay Mode");
                    if "Pay Mode" = "Pay Mode"::EFT then
                        TestField("EFT Options");
                    if "Include Charges" then
                        TestField("Transaction Type");
                    Rec.TestField("Document Type");
                    Rec.TestField("Closure Type");
                    Rec.TestField("Close Account");
                    Rec.TestField("Member No.");
                    Rec.TestField("Customer Type");
                    case "Closure Type" of
                        "Closure Type"::"Withdrawal - Normal":
                            begin
                                if "Pay Mode" = "Pay Mode"::EFT then begin
                                    Rec.TestField("Payment Destination");
                                    Rec.TestField("Payment Destination Code");
                                end;
                            end;

                        "Closure Type"::"Withdrawal - Death":
                            TestField("Paying Account No.");
                    end;

                    Rec.TestField("Closing Date");
                    Rec.TestField("Paying Account No.");
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);

                    Notices.Reset;
                    Notices.SetRange("No.", "Notice No.");
                    if Notices.Find('-') then begin

                        case Notices."Closure Type" of
                            Notices."Closure Type"::"Withdrawal - Normal":
                                begin

                                    TestField("Closure Type", Notices."Closure Type");
                                    //if not Gensetup."Override Setup Control" then
                                    // if Notices."Maturity Date" > Today then Error(ErrorOnMaturityNotDateTxt, Notices."Maturity Date");
                                end;
                            Notices."Closure Type"::"Withdrawal - Death":
                                begin
                                    TestField("Closure Type", Notices."Closure Type");
                                end;
                        end;
                    end;
                end;
            2:
                begin
                    Rec.TestField(Remarks);
                    Rec.TestField("Document Type");
                    Rec.TestField("Closure Type");
                    Rec.TestField("Close Account");
                    Rec.TestField("Member No.");
                    Rec.TestField("Approval Status", Rec."Approval Status"::Posted);
                    AccountLine.Reset();
                    AccountLine.SetRange("No.", "No.");
                    AccountLine.SetRange("Account Category", AccountLine."Account Category"::Savings);
                    if not AccountLine.Find('-') then begin
                        Error('No payment account found');
                    end;

                end;
        end;

    end;

    local procedure fnInitialize();
    begin

        "Member Name" := '';
        "Member No." := '';
        "Member Savings" := 0;
        "Transaction Type" := '';
        "Other Charges" := 0;
        "Early Exit Charges" := 0;
        "Outstanding Principal" := 0;
        "Shares Capital" := 0;
        "Total Amount (LCY)" := 0;
        "Total Liabilities" := 0;
        "Total Interest" := 0;
        "Total Loan" := 0;
        "Deposit Refundable" := 0;
        "Total Savings" := 0;
        "Sum Insured" := 0;

    end;

    procedure RcvCheckFieldLength(VarVariant: Text; MinLength: Integer; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be less than %1 or more than %2 Characters.';
    begin
        if (StrLen(VarVariant) < MinLength) or (StrLen(VarVariant) > FldLength) then
            Error(FieldLengthError, MinLength, FldLength);
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeOnValidateAccPost(var Rec: Record "Membership closure"; var xRec: Record "Membership closure"; IsHandled: Boolean; PrintPost: Boolean)
    begin
    end;
}





