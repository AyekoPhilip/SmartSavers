report 50393 "Create Temp. A/c"
{
    ApplicationArea = All;
    Caption = 'Create Temp. A/c';
    UsageCategory = ReportsAndAnalysis;
    Permissions = TableData "Default Dimension" = rimd, TableData Customer = rimd, TableData Vendor = rimd, 
    TableData "Cust. Ledger Entry" = rimd , TableData "access control" = rimd;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(Member; Member)
        {
            trigger OnPreDataItem()
            var
            accctrl : record "access control";
            begin
                DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
                if ClearData then begin

                end;
            end;

            trigger OnAfterGetRecord()
            begin

                case ValidationType of
                    ValidationType::"Validate Dimensions":
                        begin

                            case ProdDimension Of
                                ProdDimension::Repayment:
                                    begin
                                        VendAc.Reset();
                                        VendAc.SetRange("Member No.", "No.");
                                        if VendAc.FindSet() then begin
                                            repeat
                                                VendAc.Validate("Global Dimension 1 Code", "Global Dimension 1 Code");
                                                VendAc.Validate("Global Dimension 2 Code", "Global Dimension 2 Code");
                                                VendAc.Validate(Status, Status);
                                                VendAc.Modify(true);
                                            until VendAc.Next() = 0;
                                        end;
                                    end;
                                ProdDimension::Banking:
                                    begin
                                        VendAc.Reset();
                                        VendAc.SetRange("Member No.", "No.");
                                        if VendAc.FindSet() then begin
                                            repeat
                                                VendAc.Validate("Global Dimension 1 Code", "Global Dimension 1 Code");
                                                VendAc.Validate("Global Dimension 2 Code", "Global Dimension 2 Code");
                                                VendAc.Validate(Status, Status);
                                                VendAc.Modify(true);
                                            until VendAc.Next() = 0;
                                        end;

                                    end;
                                ProdDimension::"Micro Credit",
                                ProdDimension::Credit:
                                    begin

                                        CustAc.Reset();
                                        CustAc.SetRange("Member No.", "No.");
                                        if CustAc.FindSet() then begin
                                            repeat
                                                if (CustAc."Global Dimension 1 Code" = '') or (CustAc."Global Dimension 2 Code" = '') then begin
                                                    CustAc.Validate("Global Dimension 1 Code", "Global Dimension 1 Code");
                                                    CustAc.Validate("Global Dimension 2 Code", "Global Dimension 2 Code");
                                                    CustAc.Validate(Status, Status);
                                                    CustAc.Modify(true);
                                                end;
                                            until CustAc.Next() = 0;
                                        end;

                                    end;
                                ProdDimension::Loan:
                                    begin
                                        LoanAc.Reset();
                                        LoanAc.SetRange("Member No.", "No.");
                                        if LoanAc.FindSet() then begin
                                            repeat
                                                if ProdFact.Get(LoanAc."Product Type") then begin
                                                    LoanAc.Status := Status;
                                                    LoanAc."Account Dimension" := ProdFact."Account Dimension";
                                                    if CustAc.get(LoanAc."No.") then begin
                                                        CustAc."Account Dimension" := ProdFact."Account Dimension";
                                                        CustAc.Modify(true)
                                                    end;
                                                    LoanAc.Modify(true)
                                                end;
                                            until LoanAc.Next() = 0;
                                        end;
                                    end;
                            end;
                        end;

                    ValidationType::"Create Accounts":
                        begin

                            ProdFact.Reset();
                            ProdFact.SetRange(Status, ProdFact.Status::Active);
                            ProdFact.SetRange("Auto Open Account", true);
                            ProdFact.SetRange("Product Class", ProdFact."Product Class"::Account);
                            if ProdFact.Find('-') then begin
                                repeat

                                    ProdFact.TestField("Account Dimension");
                                    ProdFact.TestField("Posting Group");

                                    case ProdFact."Account Dimension" of
                                        ProdFact."Account Dimension"::Banking:
                                            begin

                                                Banking.LockTable;
                                                RegistryMngt.fnInitializeAccountRec(Member, Banking);

                                                case ProdFact."No. Serialization" of
                                                    ProdFact."No. Serialization"::Automated:
                                                        begin
                                                            Banking.Init();
                                                            Banking."No." := '';
                                                        end;
                                                    ProdFact."No. Serialization"::Manual:
                                                        begin

                                                            RegistryMngt.InitBankingAcEntry(Member, Banking,
                                                            ProdFact."Account No. Suffix", ProdFact."Account No. Prefix",
                                                            "Global Dimension 2 Code", "No.", ProdFact."Product ID");
                                                        end;
                                                end;

                                                Banking."Member No." := "No.";
                                                Banking."Product Type" := ProdFact."Product ID";
                                                Banking."Product Name" := ProdFact.Description;
                                                Banking."Old Member No." := "Old Member No.";
                                                Banking."Old Account No." := Banking."No.";
                                                Banking."Monthly Contribution" := ProdFact."Minimum Contribution";
                                                Banking."Account Category" := ProdFact."Account Category";
                                                Banking."Loan Disbursement Account" := ProdFact."Loan Disbursement Account";
                                                Banking."Customer Posting Group" := ProdFact."Posting Group";
                                                Banking."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                Banking."Account Dimension" := ProdFact."Account Dimension";
                                                Banking."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                Banking.Status := Status;
                                                Banking.Insert(true);

                                                RegtMngt.fnCreateVendorPostAc(Banking."No.",
                                                CopyStr(Banking.Name, 1, 50), Banking."Mobile No.", Banking."Global Dimension 1 Code",
                                                Banking."Global Dimension 2 Code", Banking."Customer Posting Group",
                                                Banking."E-Mail", Banking.Status, Banking."Product Type",
                                                Banking."ID/Passport No.", Banking."Member No.", Banking."Account Category");

                                                if Banking."Account Category" = Banking."Account Category"::Savings then begin

                                                    TempBanking.LockTable();
                                                    RegistryMngt.InitializeTempAccountBanking(Member, TempBanking);
                                                    TempBanking."No." := Banking."No.";
                                                    TempBanking."Member No." := "No.";
                                                    TempBanking."Product Type" := ProdFact."Product ID";
                                                    TempBanking."Product Name" := ProdFact.Description;
                                                    TempBanking."Monthly Contribution" := ProdFact."Minimum Contribution";
                                                    TempBanking."Account Category" := ProdFact."Account Category";
                                                    TempBanking."Loan Disbursement Account" := ProdFact."Loan Disbursement Account";
                                                    TempBanking."Customer Posting Group" := ProdFact."Posting Group";
                                                    TempBanking."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                    TempBanking."Account Dimension" := ProdFact."Account Dimension";
                                                    TempBanking."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                    TempBanking.Status := Status;
                                                    TempBanking.Insert(true);
                                                end;
                                            end;
                                        ProdFact."Account Dimension"::Repayment:
                                            begin
                                                RepaymentAc.LockTable();
                                                RegistryMngt.InitializeRepaymentAcc(Member, RepaymentAc);

                                                case ProdFact."No. Serialization" of
                                                    ProdFact."No. Serialization"::Automated:
                                                        begin
                                                            RepaymentAc.Init();
                                                            RepaymentAc."No." := '';
                                                        end;
                                                    ProdFact."No. Serialization"::Manual:
                                                        begin
                                                            RegistryMngt.InitRepayAcEntry(Member, RepaymentAc,
                                                            ProdFact."Account No. Suffix", ProdFact."Account No. Prefix",
                                                            Member."Global Dimension 2 Code", Member."No.");
                                                        end;
                                                end;

                                                RepaymentAc."Member No." := Member."No.";
                                                RepaymentAc."Product Type" := ProdFact."Product ID";
                                                RepaymentAc."Product Name" := ProdFact.Description;
                                                RepaymentAc."Account Category" := ProdFact."Account Category";
                                                RepaymentAc."Customer Posting Group" := ProdFact."Posting Group";
                                                RepaymentAc."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                RepaymentAc."Account Dimension" := ProdFact."Account Dimension";
                                                RepaymentAc.Status := Status;
                                                RepaymentAc.Insert(true);

                                                RegtMngt.fnCreateVendorPostAc(RepaymentAc."No.",
                                                RepaymentAc.Name, Member."Mobile Phone No", RepaymentAc."Global Dimension 1 Code",
                                                RepaymentAc."Global Dimension 2 Code",
                                                RepaymentAc."Customer Posting Group", Member."E-Mail",
                                                RepaymentAc.Status, RepaymentAc."Product Type", Member."ID No.",
                                                RepaymentAc."Member No.", RepaymentAc."Account Category");
                                            end;

                                        ProdFact."Account Dimension"::Credit,
                                        ProdFact."Account Dimension"::"Micro Credit":
                                            begin

                                                CredAc.LockTable;
                                                case ProdFact."No. Serialization" of
                                                    ProdFact."No. Serialization"::Automated:
                                                        begin
                                                            CredAc.Init();
                                                            CredAc."No." := '';
                                                        end;
                                                    ProdFact."No. Serialization"::Manual:
                                                        begin
                                                            RegistryMngt.InitCreditAcEntry(Member, CredAc, ProdFact."Account No. Suffix",
                                                      ProdFact."Account No. Prefix", "Global Dimension 2 Code", "No.");

                                                        end;
                                                end;
                                                RegistryMngt.InitCreditAcRec(Member, CredAc);

                                                CredAc."Member No." := "No.";
                                                CredAc."Product Type" := ProdFact."Product ID";
                                                CredAc."Product Name" := ProdFact.Description;
                                                CredAc."Monthly Contribution" := ProdFact."Minimum Contribution";
                                                CredAc."Account Category" := ProdFact."Account Category";
                                                CredAc."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                CredAc."Customer Posting Group" := ProdFact."Posting Group";
                                                CredAc."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                CredAc.Status := Status;

                                                case "Customer Type" of
                                                    "Customer Type"::" ",
                                                    "Customer Type"::"Non-Member",
                                                    "Customer Type"::Individual:
                                                        begin
                                                            CredAc."Account Dimension" := ProdFact."Account Dimension";
                                                        end;
                                                    "Customer Type"::Corporate,
                                                    "Customer Type"::Joint,
                                                    "Customer Type"::Groups:
                                                        begin
                                                            CredAc."Account Dimension" := ProdFact."Account Dimension";
                                                        end
                                                end;

                                                CredAc.Insert(true);
                                                RegtMngt.fnCreateCustMemberPostAc(CredAc."No.",
                                                CredAc.Name, CredAc."Mobile No.", CredAc."Global Dimension 1 Code",
                                                CredAc."Global Dimension 2 Code", CredAc."Customer Posting Group",
                                                "E-Mail", CredAc.Status, CredAc."Product Type", CredAc."ID/Passport No.",
                                                CredAc."Member No.", CustAccType::"Credit Account",
                                                CredAc."Account Dimension", CredAc."Account Category");

                                                TempCredAcc.LockTable();
                                                RegistryMngt.InitializeCustTempAccountCredit(Member, TempCredAcc);
                                                TempCredAcc."No." := CredAc."No.";
                                                TempCredAcc."Member No." := "No.";
                                                TempCredAcc."Product Type" := ProdFact."Product ID";
                                                TempCredAcc."Product Name" := ProdFact.Description;
                                                TempCredAcc."Monthly Contribution" := ProdFact."Minimum Balance";
                                                TempCredAcc."Account Category" := ProdFact."Account Category";
                                                TempCredAcc."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                TempCredAcc."Customer Posting Group" := ProdFact."Posting Group";
                                                TempCredAcc."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                TempCredAcc."Account Dimension" := ProdFact."Account Dimension";
                                                TempCredAcc.Status := Status;
                                                TempCredAcc.Insert(true);
                                            end;
                                    end;
                                Until ProdFact.Next() = 0;
                            end;
                        end;
                    ValidationType::"Update Details":
                        begin
                            if IsIESA then begin

                                AccBanking.Reset();
                                AccBanking.SetRange("Member No.", "Union Member No.");
                                AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Money Market");
                                if AccBanking.FindFirst() then begin
                                    AccBanking."Old Member No." := "Union Member No.";
                                    AccBanking."Member No." := "No.";
                                    AccBanking.Modify(true)
                                end;

                            end else begin

                                AccBanking.Reset();
                                AccBanking.SetRange("Member No.", "No.");
                                if AccBanking.FindSet() then begin
                                    AccBanking.ModifyAll(Status, Status);
                                    AccBanking.ModifyAll("Registration Date", "Registration Date");
                                end;

                                CredAc.Reset();
                                CredAc.SetRange("Member No.", "No.");
                                if CredAc.FindSet() then begin
                                    CredAc.ModifyAll(Status, Status);
                                    CredAc.ModifyAll("Registration Date", "Registration Date");
                                end;

                                RepaymentAc.Reset();
                                RepaymentAc.SetRange("Member No.", "No.");
                                if RepaymentAc.FindSet() then begin
                                    RepaymentAc.ModifyAll(Status, Status);
                                    RepaymentAc.ModifyAll("Registration Date", "Registration Date");

                                end
                            end;
                        end;
                end
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(ClearData; ClearData)
                    {
                        Caption = 'Clear Data';
                        ApplicationArea = All;
                    }
                    field(ValidationType; ValidationType)
                    {
                        Caption = 'Operation Type';
                        ApplicationArea = All;
                    }
                    field(ValidateDim; IsIESA)
                    {
                        Caption = 'Is IESA';
                        ApplicationArea = All;
                    }
                    field(ProdDimension; ProdDimension)
                    {
                        Caption = 'Account Dimension';
                        ApplicationArea = All;

                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var

        ClearData: Boolean;
        TempBanking: Record "Account (Procedure)";
        RegistryMngt: Codeunit "Registry Mngt.";
        AccBanking: Record "Account Banking";
        TempData: Record Member;
        loansapp: Record Loans;
        loansrec: Record "Loan Application";
        TempCredAcc: Record "Account (Member)";
        CustAccType: Enum CustAccountType;
        DefDim: Record "Default Dimension";
      
        RepaymentAc: Record "Repayment Account";
        CustRec: Record Member;
        loanclosed: Record "Loans-Closed Account";
        CredAc: Record "Account Credit";
        RegtMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        ProdCategory: Enum ProductAccountCategory;
        AccDimension: Enum AccountDimension;
        CredtMngt: Codeunit "Credit Mgmt.";
        ProdFact: Record "Product Factory";
        Banking: Record "Account Banking";
        VendAc: Record Vendor;
        REPAYAC: Record "Repayment Account";
        
        CustAc: Record Customer;
        LoanAc: Record "Credit Account";
        IsIESA: Boolean;
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        ValidationType: Option " ","Create Accounts","Update Details","Validate Dimensions";
        ProdDimension: Enum AccountDimension;
        GLENTRY: Record  "G/L Entry";
        CUSTNTRY: Record "Cust. Ledger Entry";
        DETCUSENTRY: Record "Detailed Cust. Ledg. Entry";


}
