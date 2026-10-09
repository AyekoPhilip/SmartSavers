table 50377 "EFT Transfer Lines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Code[50])
        {
            Caption = 'No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50010; "Document No."; Code[50])
        {
            TableRelation = "EFT Transfer Header"."No.";
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Entered By"; Code[50])
        {
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50012; "Account Type"; Enum "AccountTypesExtended")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                EftHeader.Reset();
                EftHeader.SetRange("No.", "Document No.");
                if EftHeader.FindFirst() then begin
                    case EftHeader."Application Source" of
                        EftHeader."Application Source"::Teller,
                        EftHeader."Application Source"::Benefits,
                        EftHeader."Application Source"::Finance:
                            begin
                                "Product Type" := EftHeader."Product Type";
                                "EFT Options" := "EFT Options"::"Bank Account";
                                "Application Source" := EftHeader."Application Source";
                                "Source of funds" := EftHeader."Source of funds";
                                if EFTHeader."Source of funds" = EFTHeader."Source of funds"::Junior then begin
                                    EFTHeader.TestField("Member No.");
                                    Validate("Customer No.", EFTHeader."Member No.");
                                end
                            end;
                    end;
                end;
            end;
        }
        field(50013; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" else
            if ("Account Type" = const(Customer)) Customer else
            //////<>>>>>>>>
            if ("Account Type" = const("Bank Account")) "Bank Account" else
            //////<>>>>>>>>
            if ("Account Type" = const(Vendor)) Vendor else
            //////<>>>>>>>>
            if ("Account Type" = const(Savings), "Application Source" = filter(Credit))
            "Account Banking" where("Account Category" = filter(Savings)) else
            //////<>>>>>>>>
            if ("Account Type" = const(Savings), "Application Source" = filter(Benefits), "Source of funds" = filter("Fosa Savings" | Junior))
            "Account Banking" where("Account Category" = filter("Specialty Savings" | Junior), "Member No." = field("Member No."), "Balance (LCY)" = filter(> 0), Status = filter(New | Active)) else
            //////<>>>>>>>>
            if ("Account Type" = const(Savings), "Application Source" = filter(Benefits), "Source of funds" = filter(Refunds)) "Account Banking" where("Account Category" = filter("Specialty Savings"),
            "Member No." = field("Member No."), "Balance (LCY)" = filter(> 0), Status = filter(Withdrawn)) else
            //////<>>>>>>>>
            if ("Account Type" = const(Credit), "Application Source" = filter(Benefits)) "Account Credit" where("Account Category" = filter("Shares Deposit"),
            "Member No." = field("Member No."), "Balance (LCY)" = filter(> 0)) else
            //////<>>>>>>>>
            if ("Account Type" = const(Savings), "Application Source" = filter(Teller), "Source of funds" = filter("Fosa Savings"))
            "Account Banking" where("Account Category" = filter("Specialty Savings"), "Balance (LCY)" = filter(> 0), "Member No." = field("Customer No."));
        
            trigger OnValidate()
            var
                SAccounts: Record "Account Banking";
                BankAcc: Record "Bank Account";
                BankCodeStructure: Record Banks;
                EFTHaeder: Record "EFT Transfer Header";
                EFTLines: Record "EFT Transfer Lines";
                ProdFact: Record "Product Factory";
                BosaAc: Record "Account Credit";
                TotalCommittment: Decimal;
                LoanApp: Record "Loan Application";
                Loans: Record Loans;
                ExternalCommitment: Record "Other Commitements Clearance";
                AccountTypes: Record "Product Factory";
                ErrorOnLastWithdrawalTxt: Label 'Member last withdrawal date was %1. The next withdrawal date must be on or after %2';
            begin
                TotalCommittment := 0;
                case "Account Type" of
                    "Account Type"::Credit:
                        begin

                            if BosaAc.Get("Account No.") then begin
                                "Account Name" := BosaAc.Name;
                                "Mobile Phone No." := BosaAc."Mobile No.";
                                "External Account Name" := BosaAc.Name;

                                if Type = Type::Account then begin
                                    "Own Reference" := BosaAc."Member No.";
                                    "Available Balance" := CalcAvailableBal(2);
                                end;

                                EFTHeader.Reset();
                                EFTHeader.SetRange("No.", Rec.No);
                                EFTHeader.SetFilter("Application Source", '<>%1', EFTHeader."Application Source"::Credit);
                                if EFTHeader.FindFirst() then begin
                                    "Available Balance" := CalcAvailableBal(2);
                                end;
                            end;
                        end;
                    "Account Type"::Savings:
                        begin

                            if SAccounts.Get("Account No.") then
                                SAccounts.CalcFields("Balance (LCY)");
                            "Account Name" := SAccounts.Name;
                            "Mobile Phone No." := SAccounts."Mobile No.";
                            if "Source of funds" <> "Source of funds"::Junior then
                                "External Account Name" := SAccounts.Name;

                            if Type = Type::Loan then begin
                                TotalCommittment := 0;
                                "Member No." := SAccounts."Member No.";
                                if "Loan No." <> '' then begin
                                    if Loans.Get("Loan No.") then begin
                                        if LoanApp.Get(Loans."Application No.") then begin

                                            ExternalCommitment.Reset();
                                            ExternalCommitment.SetRange("Application No.", LoanApp."No.");
                                            if ExternalCommitment.FindSet() then begin
                                                ExternalCommitment.CalcSums(Amount);
                                                TotalCommittment := ExternalCommitment.Amount;
                                                Amount := (SAccounts."Balance (LCY)" - TotalCommittment);
                                            end else begin
                                                Amount := SAccounts."Balance (LCY)";
                                            end;
                                        end else begin
                                            if Loans."TopUp Loan" <> '' then begin
                                                Amount := SAccounts."Balance (LCY)";
                                            end;
                                        end;
                                    end;
                                end;
                                "Available Balance" := SAccounts."Balance (LCY)";
                            end;

                            if Type = Type::Account then begin
                                "Own Reference" := SAccounts."Member No.";
                                if AccountTypes.GET(SAccounts."Product Type") then begin
                                    if AccountTypes."Charge Subsiquent withdrawal" then begin
                                        if SAccounts."Next Withdrawal Date" <> 0D then begin
                                            if Today <= SAccounts."Next Withdrawal Date" then begin
                                                //Error(ErrorOnLastWithdrawalTxt, SAccounts."Last Withdrawal Date", SAccounts."Next Withdrawal Date");
                                            end
                                        end;
                                    end;
                                end;

                                if "Source of funds" = "Source of funds"::Refunds then begin
                                    Amount := SAccounts."Balance (LCY)";
                                    "Available Balance" := SAccounts."Balance (LCY)";
                                    "Book Balance" := SAccounts."Balance (LCY)";

                                end else begin
                                    "Available Balance" := CalcAvailableBal(0);
                                    "Book Balance" := SAccounts."Balance (LCY)";
                                end;
                            end;
                        end;

                    "Account Type"::"Bank Account":
                        begin
                            if BankAcc.Get("Account No.") then begin
                                "Account Name" := BankAcc.Name;
                                BankCodeStructure.Reset;
                                BankCodeStructure.SetRange(Code, "Bank Code");
                                if BankCodeStructure.Find('-') then
                                    "Bank Name" := BankCodeStructure.Name;
                                "Branch Code" := BankAcc."Bank Branch No.";
                            end;
                        end;
                end;

                if "Standing Order No" = '' then begin
                    if Amount <> 0 then begin
                    end;
                end;
            end;
        }
        field(50014; "Account Name"; Text[250])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50015; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            TableRelation = if ("Account Type" = const(Savings), "Source of funds" = filter("Fosa Savings")) Member where(Status = filter(Active | New | Dormant)) else
            if ("Account Type" = const(Savings), "Source of funds" = filter(Refunds)) Member where(Status = filter(Withdrawn)) else
            if ("Account Type" = const(Credit)) Member where(Status = filter(Active | New | Dormant), "Terms of Employment" = filter(Pensioner | Contract));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                EftHeader: Record "EFT Transfer Header";
                FosaAc: Record "Account Banking";
                CustRecord: Record Member;
                BosaAc: Record "Account Credit";
                MembCategory: Record "Member Category";
                ErrorOnLessBalTxt: Label 'Member does not have enough balance to transact';
                ErrorOnInvalidMemCategory: Label 'This Member Category is not allowed to Transfer Shares';
            begin
                ClearLines();
                EftHeader.Reset();
                EftHeader.SetRange("No.", "Document No.");
                if EftHeader.FindFirst() then begin
                    case EftHeader."Application Source" of
                        EftHeader."Application Source"::Benefits,
                        EftHeader."Application Source"::Teller,
                            EftHeader."Application Source"::Finance:
                            begin

                                "Product Type" := EftHeader."Product Type";
                                "EFT Options" := "EFT Options"::"Bank Account";
                                "Application Source" := EftHeader."Application Source";
                                "Source of funds" := EftHeader."Source of funds";

                                if ProdFact.Get("Product Type") then begin
                                    if ProdFact."Account Dimension" = ProdFact."Account Dimension"::Banking then begin

                                        "Account Type" := "Account Type"::Savings;
                                        case "Source of funds" of
                                            "Source of funds"::Junior:
                                                begin
                                                    FosaAc.SetRange("Member No.", "Member No.");
                                                    FosaAc.SetRange("Account Category", FosaAc."Account Category"::Junior);
                                                    if FosaAc.FindFirst() then begin
                                                        FosaAc.CalcFields("Balance (LCY)");
                                                        "Available Balance" := FosaAc."Balance (LCY)";
                                                        Validate(Amount,FosaAc."Balance (LCY)");
                                                        if FosaAc."Balance (LCY)" > 0 then begin
                                                            Validate("Account No.", FosaAc."No.");
                                                        end else begin
                                                            Error(ErrorOnLessBalTxt);
                                                        end;
                                                    end;
                                                end else begin

                                                FosaAc.SetRange("Member No.", "Member No.");
                                                FosaAc.SetRange("Account Category", FosaAc."Account Category"::"Specialty Savings");
                                                if FosaAc.FindFirst() then begin
                                                    FosaAc.CalcFields("Balance (LCY)");
                                                    if "Source of funds" = "Source of funds"::Refunds then
                                                        "Available Balance" := FosaAc."Balance (LCY)" else
                                                        "Available Balance" := CalcAvailableBal(0);
                                                    if FosaAc."Balance (LCY)" > 0 then begin
                                                        Validate("Account No.", FosaAc."No.");
                                                    end else begin
                                                        Error(ErrorOnLessBalTxt);
                                                    end;
                                                end;
                                            end;
                                        end;

                                    end;
                                    if ProdFact."Account Dimension" = ProdFact."Account Dimension"::Credit then begin

                                        if CustRecord.Get("Member No.") then begin
                                            CustRecord.TestField("Member Category");

                                            MembCategory.Reset();
                                            MembCategory.SetRange("No.", CustRecord."Member Category");
                                            MembCategory.SetFilter("Terms of Service", '%1|%2', MembCategory."Terms of Service"::Pensioner, MembCategory."Terms of Service"::Contract);
                                            if not MembCategory.Find('-') then begin
                                                Error(ErrorOnInvalidMemCategory);
                                            end;
                                        end;

                                        BosaAc.Reset();
                                        BosaAc.SetRange("Member No.", "Member No.");
                                        BosaAc.SetRange("Account Category", BosaAc."Account Category"::"Shares Deposit");
                                        if BosaAc.FindFirst() then begin
                                            BosaAc.CalcFields("Balance (LCY)");
                                            if BosaAc."Balance (LCY)" > 0 then begin
                                                "Book Balance" := BosaAc."Balance (LCY)";
                                                "Outstanding Balance" := RegMngt.getCustAccruedIntLoanBalance(0, BosaAc."Member No.", 0);
                                                "Available Balance" := CalcAvailableBal(2);
                                                Validate("Account No.", BosaAc."No.");
                                            end else begin
                                                Error(ErrorOnLessBalTxt);
                                            end;
                                        end;
                                    end;
                                end;
                          end;
                    end
                end;
            end;
        }
        field(50016; "External Account Name"; Text[250])
        {
            Caption = 'External Account Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var

            begin


            end;
        }
        field(50017; "Charge Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Charge Amount';
            DataClassification = CustomerContent;
        }
        field(50018; "Don't Charge"; Boolean)
        {
            Caption = 'Do not Charge';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Don't Charge" then
                    "Charge Amount" := 0
                else
                    getCharges;
            end;
        }
        field(50019; "Phone No."; Code[13])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(50020; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::Credit then begin
                    Validate("Account No.");
                end;
                if Amount < 0 then
                    Error(LessThanZeroAmount);
                if Type = Type::Account then begin
                    if Amount > "Available Balance" then
                        Error('Amount cannot be more than available balance');
                end;

            end;
        }
        field(50021; "Amount Text"; Text[250])
        {
            Caption = 'Amount Text';
            DataClassification = CustomerContent;
        }
        field(50022; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                BankCodes.Reset;
                BankCodes.SetRange(Code, "Bank Code");
                if BankCodes.Find('-') then
                    "Bank Name" := BankCodes.Name;
            end;
        }
        field(50023; "Branch Code"; Code[10])
        {
            TableRelation = if (Type = const(Loan)) Banks."Bank No." else
            if (Type = const(Account)) Banks."Bank No.";
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                BankBranch: Record "Bank Branches";
            begin

                BankBranch.Reset();
                BankBranch.SetRange("Branch Code", "Branch Code");
                BankBranch.SetRange("Bank Code", "Bank Code");
                if BankBranch.FindFirst() then
                    "Branch Name" := BankBranch."Branch Name"
            end;
        }
        field(50024; "Bank Name"; Text[100])
        {
            Editable = false;
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(50025; "Over Drawn"; Boolean)
        {
            Caption = 'Over Drawn';
            DataClassification = CustomerContent;
        }
        field(50026; "Standing Order No"; Code[20])
        {
            Caption = 'Standing Order No';
            DataClassification = CustomerContent;
        }
        field(50027; "Standing Order Register No"; Code[20])
        {
            Caption = 'Standing Order Register No';
            DataClassification = CustomerContent;
        }
        field(50028; "Not Available"; Boolean)
        {
            Caption = 'Not Available';
            DataClassification = CustomerContent;
        }
        field(50029; "Charge Account"; Code[20])
        {
            Editable = false;
            Caption = 'Charge Account';
            DataClassification = CustomerContent;
        }
        field(50030; "Transferred"; Boolean)
        {
            Caption = 'Transferred';
            DataClassification = CustomerContent;
        }
        field(50031; "ExportFormat"; Text[78])
        {
            Caption = 'ExportFormat';
            DataClassification = CustomerContent;
        }
        field(50032; "External Account No."; Text[100])
        {
            Caption = 'External Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if StrLen("External Account No.") > 100 then
                    Error('Destnation account no %1 more than 14 characters.', "External Account No.");
            end;
        }
        field(50033; "Multiple Accounts"; Boolean)
        {
            Editable = false;
            Caption = 'Multiple Accounts';
            DataClassification = CustomerContent;
        }
        field(50034; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50035; "Excise Duty"; Decimal)
        {
            Caption = 'Excise Duty';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                GeneralSetUp.Get();
                TCharges := 0;
                if EFTHeader.Get("Document No.") then begin
                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", EFTHeader."Transaction Type");
                    if TransactionCharges.Find('-') then begin
                        repeat
                            ChargeAmount := 0;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then begin
                                if TransactionCharges."Recover Excise Duty" = false then
                                    "Charge Amount" := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                                else
                                    "Charge Amount" := ((Amount * TransactionCharges."Percentage of Amount") * 0.01) + (0.01 * ((Amount * TransactionCharges."Percentage of Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                            end
                            else begin
                                if TransactionCharges."Recover Excise Duty" = false then
                                    "Charge Amount" := TransactionCharges."Charge Amount" else
                                    "Charge Amount" := (TransactionCharges."Charge Amount") + (TransactionCharges."Charge Amount" * (GeneralSetUp."Excise Duty (%)" * 0.01));
                            end;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" then begin
                                                if TransactionCharges."Recover Excise Duty" = false then
                                                    "Charge Amount" := Amount * TariffDetails.Percentage * 0.01 else
                                                    "Charge Amount" := ((Amount * TariffDetails.Percentage * 0.01) + ((Amount * TariffDetails.Percentage * 0.01) * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            end else begin
                                                if TransactionCharges."Recover Excise Duty" = false then
                                                    "Charge Amount" := TariffDetails."Charge Amount" else
                                                    "Charge Amount" := ((TariffDetails."Charge Amount") + ((TariffDetails."Charge Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            end;
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;
                            TChargeAmount += "Charge Amount";
                        until TransactionCharges.Next = 0;
                    end;
                    TCharges += TChargeAmount;
                    "Excise Duty" := TCharges;
                end;
            end;
        }
        field(50036; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
        field(50037; "Physical Address"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50038; "Contact"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact of Beneficiary';
        }
        field(50039; "IBAN No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'IBAN/Swift Code';
        }
        field(50040; "Routing Code"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50041; "Available Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50042; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50043; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50044; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50045; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Account","Loan";
        }
        field(50046; "Loan No."; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Loans where("Outstanding Balance" = filter(> 0));
        }
        field(50047; "Branch Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50048; "Institution Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Bank","Building Society";
        }
        field(50049; "Society Code"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50050; "Own Reference"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50051; "Recipient Reference"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50052; "EFT Options"; Enum "EFTPaymentOptions")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50053; "Mobile Phone No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(50054; "Payment Destination"; Code[100])
        {
            TableRelation = if ("Application Source" = filter(Teller)) "Cust. Bank Account"."Bank Account No." where(Code = field("Payment Destination Code"),
            "Member No." = field("Customer No.")) else
            "Cust. Bank Account"."Bank Account No." where(Code = field("Payment Destination Code"), "Member No." = field("Member No."));
            DataClassification = CustomerContent;
            Caption = 'Destination A/c';
        
            trigger OnValidate()
            begin
                if "Institution Type" = "Institution Type"::Bank then
                    Validate("External Account No.", "Payment Destination");
            end;
        }
        field(50055; "Payment Destination Code"; Code[100])
        {
            TableRelation = if ("Application Source" = filter(Benefits), "Source of funds" = filter(Junior)) Banks.Code else
            if ("Application Source" = filter(Benefits), "Source of funds" = filter("Fosa Savings" | Refunds))
            "Cust. Bank Account".Code where("Member No." = field("Member No.")) else
            if ("Application Source" = filter(Teller), "Source of funds" = filter("Fosa Savings"))
            "Cust. Bank Account".Code where("Member No." = field("Customer No."));
            DataClassification = CustomerContent;
            Caption = 'Bank Code';
        
            trigger OnValidate()
            var
                BanksList: Record Banks;
            begin

                BanksList.Reset();
                BanksList.Setrange(Code, "Payment Destination Code");
                if BanksList.Find('-') then begin
                    "Bank Name" := BanksList.Name;
                    if BanksList."Institution Type" = BanksList."Institution Type"::Bank then begin

                        Rec."Institution Type" := Rec."Institution Type"::Bank;
                        if "Application Source" = "Application Source"::Teller then begin
                            Rec."Recipient Reference" := 'SNAT COOP' + ' ' + "Customer No.";
                            Rec."Own Reference" := "Customer No.";

                        end else begin
                            Rec."Recipient Reference" := 'SNAT COOP' + ' ' + "Member No.";
                            Rec."Own Reference" := Rec."Member No.";

                        end;
                        Rec."Society Code" := '';

                    end;
                    if BanksList."Institution Type" = BanksList."Institution Type"::"Building Society" then begin
                        Rec."Institution Type" := Rec."Institution Type"::"Building Society";
                        Rec.Validate("External Account No.", BanksList."Society Code");
                        Rec."Society Code" := BanksList."Society Code";
                        if "Application Source" = "Application Source"::Teller then
                            Rec."Own Reference" := Rec."Customer No." else
                            Rec."Own Reference" := Rec."Member No.";

                        EFTHaeder.Reset();
                        EFTHaeder.SetRange("No.", "Document No.");
                        EFTHaeder.SetFilter("Application Source", '%1 | %2 | %3', EFTHaeder."Application Source"::Finance,
                        EFTHaeder."Application Source"::Teller, EFTHaeder."Application Source"::Benefits);
                        EFTHaeder.SetRange("Document Type", EFTHaeder."Document Type"::"Electronic Fund Transfer");
                        if EFTHaeder.FindSet() then begin

                            if "Application Source" = "Application Source"::Teller then
                                Rec."Recipient Reference" := 'SNAT COOP' + ' ' + "Customer No." else
                                Rec."Recipient Reference" := 'SNAT COOP' + ' ' + "Member No."

                        end;
                    end;
                    Rec.Validate("Bank Code", BanksList.Code);
                    Rec.Validate("Branch Code", BanksList."Bank No.");

                end;
            end;
        }
        field(50056; "Application Source"; Enum "ApplicationSource")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50057; "Partial Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50058; "External Committment No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50059; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50060; "Outstanding Balance"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50061; "Book Balance"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50062; "Disbursement Date"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50063; "Source of funds"; Enum "SourceOfFunds")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50064; "Customer No."; Code[20])
        {
            TableRelation = if ("Account Type" = const(Savings), "Source of funds" = filter("Fosa Savings")) Member where(Status = filter(Active | New | Dormant)) else
            if ("Account Type" = const(Savings), "Source of funds" = filter(Refunds)) Member where(Status = filter(Withdrawn)) else
            if ("Account Type" = const(Credit)) Member where(Status = filter(Active | New | Dormant), "Terms of Employment" = filter(Pensioner | Contract)) else
            if ("Account Type" = const(Savings), "Source of funds" = filter(Junior)) Member where(Status = filter(Deceased));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            Var
                CustRecord: Record Member;
            begin
                if CustRecord.Get("Customer No.") then begin
                    Validate("Member No.", CustRecord."No.")
                end;
            end;
        }
    }

    keys
    {
        key("Key1"; "No", "Document No.", "Account No.", "Loan No.", "Partial Loan No.")
        {
            Clustered = true;
        }
        key("Key2"; "External Committment No.")
        {

        }
    }

    fieldgroups
    {

    }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin

        if No = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."EFT Line Nos");
            
        end;

        "Entered By" := UserId;
    end;

    trigger OnModify()
    begin

    end;

    var
        SeriesSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BankCodes: Record Banks;
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        TCharges: Decimal;
        RegMngt: Codeunit "Register Management";
        ChargeAmount: Decimal;
        ProdFact: Record "Product Factory";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        TChargeAmount: Decimal;
        EFTHeader: Record "EFT Transfer Header";
        SAccount: Record "Account Banking";
        AvailableBal: Decimal;
        LessThanZeroAmount: Label 'Amount cannot be less than zero (0)';
        CashierTransactions: Record "Teller Transaction";
        GeneralSetUp: Record "General Set-Up";
        EFTHaeder: Record "EFT Transfer Header";

    procedure getCharges()
    var
        Text001: Label 'Account %1 has insufficient funds to enable successful transaction.';
    begin
        GeneralSetUp.Get();
        TCharges := 0;
        if EFTHeader.Get("Document No.") then begin
            TransactionCharges.Reset;
            TransactionCharges.SetRange(TransactionCharges."Transaction Type", EFTHeader."Transaction Type");
            if TransactionCharges.Find('-') then begin
                repeat
                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then begin
                        if TransactionCharges."Recover Excise Duty" = false then
                            "Charge Amount" := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                        else begin
                            "Charge Amount" := ((Amount * TransactionCharges."Percentage of Amount") * 0.01) + (0.01 * ((Amount * TransactionCharges."Percentage of Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                            "Excise Duty" := (0.01 * ((Amount * TransactionCharges."Percentage of Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                        end;
                    end
                    else begin
                        if TransactionCharges."Recover Excise Duty" = false then
                            "Charge Amount" := TransactionCharges."Charge Amount" else begin
                            "Charge Amount" := (TransactionCharges."Charge Amount") + (TransactionCharges."Charge Amount" * (GeneralSetUp."Excise Duty (%)" * 0.01));
                            "Excise Duty" := (TransactionCharges."Charge Amount" * (GeneralSetUp."Excise Duty (%)" * 0.01));

                        end;
                    end;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" then begin
                                        if TransactionCharges."Recover Excise Duty" = false then
                                            "Charge Amount" := Amount * TariffDetails.Percentage * 0.01 else begin
                                            "Charge Amount" := ((Amount * TariffDetails.Percentage * 0.01) + ((Amount * TariffDetails.Percentage * 0.01) * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            "Excise Duty" := ((Amount * TariffDetails.Percentage * 0.01) * (GeneralSetUp."Excise Duty (%)" * 0.01));

                                        end;
                                    end else begin
                                        if TransactionCharges."Recover Excise Duty" = false then
                                            "Charge Amount" := TariffDetails."Charge Amount" else begin
                                            "Charge Amount" := ((TariffDetails."Charge Amount") + ((TariffDetails."Charge Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            "Excise Duty" := ((TariffDetails."Charge Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01));
                                        end;
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;
                    TChargeAmount += "Charge Amount";
                until TransactionCharges.Next = 0;
            end;
            TCharges += TChargeAmount;
            "Charge Amount" := TCharges;

            EFTHaeder.Reset();
            EFTHaeder.SetRange("No.", "Document No.");
            EFTHaeder.SetRange("Application Source", EFTHaeder."Application Source"::Credit);
            EFTHaeder.SetRange("Document Type", EFTHaeder."Document Type"::"Electronic Fund Transfer");
            if EFTHaeder.FindFirst() then begin
                if SAccount.Get("Account No.") then begin
                    SAccount.CalcFields(SAccount."Balance (LCY)");
                    "Available Balance" := TellerMngt.CalcAvailableBal(SAccount."No.");
                    AvailableBal := TellerMngt.CalcAvailableBal(SAccount."No.") + "Charge Amount";
                    if AvailableBal < Amount then
                        Error(Text001, "Account No." + ' :-' + "Account Name");
                end;
            end;
        end;
    end;

    local procedure CalcAvailableBal(SourceInt: Integer) Amt: Decimal
    var
        MinBalance: Decimal;
        Account: Record "Account Banking";
        ProdType: Record "Product Factory";
        AcBosa: Record "Account Banking";
        MembCategory: Record "Member Category";
        CustRecord: Record Member;
        BosaAc: Record "Account Credit";
        RegMngt: Codeunit "Register Management";
        LoanBal: Decimal;
        TotAmt: Decimal;
        TempAmt: Decimal;

    begin
        MinBalance := 0;
        LoanBal := 0;
        Amt := 0;
        TotAmt := 0;
        TempAmt := 0;

        case SourceInt of
            0:
                begin
                    if Account.Get("Account No.") then begin
                        Account.CalcFields(Account."Balance (LCY)", Account."Uncleared Cheques",
                        Account."Authorised Over Draft", Account."Lien Placed", Account."ATM Transactions");
                        ProdType.Reset;
                        ProdType.SetRange("Product ID", Account."Product Type");
                        if ProdType.Find('-') then begin
                            //ProdType.TestField("Minimum Balance");
                            MinBalance := ProdType."Minimum Balance";
                            Amt := Account."Balance (LCY)" - (MinBalance + Account."Uncleared Cheques" + Account."Lien Placed" + Account."ATM Transactions");
                            exit(Amt)
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
                        Amt := (AcBosa."Balance (LCY)" - MinBalance);
                        if Amt < 0 then
                            Amt := 0;
                    end;
                end;
            2:
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

                    if BosaAc.Get("Account No.") then begin
                        BosaAc.CalcFields("Balance (LCY)");
                        LoanBal := RegMngt.getCustAccruedIntLoanBalance(0, BosaAc."Member No.", 0);
                        TotAmt := (BosaAc."Balance (LCY)" - LoanBal);
                        if TotAmt <= 0 then
                            exit(0);
                        TempAmt := (BosaAc."Balance (LCY)" - MinBalance);
                        if TempAmt > 0 then begin
                            if TotAmt > TempAmt then
                                Amt := TempAmt else
                                Amt := TotAmt;
                            exit(Amt);
                        end else begin
                            Amt := 0;
                            exit(Amt);
                        end;
                    end;
                end;
        end;
        exit(0)
    end;

    procedure ClearLines()
    begin
        "Account No." := '';
        "Account Name" := '';
        "External Account Name" := '';
        "External Account Name" := '';
        "Payment Destination" := '';
        "Payment Destination Code" := '';
        Amount := 0;

        "Mobile Phone No." := '';
        "Own Reference" := '';
        "Recipient Reference" := '';
        "Branch Code" := '';
        "Branch Name" := '';
        "Bank Code" := '';
    end;
}




