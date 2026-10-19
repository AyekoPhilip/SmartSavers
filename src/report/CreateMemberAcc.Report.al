report 50379 "Create Member Acc."
{
    ApplicationArea = All;
    Caption = 'Create Member Acc.';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(Temp; "Temp Data")
        {
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            trigger OnPreDataItem()
            begin
                DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
                if AccountType = '' then Error('Account Type must have a value. It cannot be blank');
            end;

            trigger OnAfterGetRecord()
            begin
                Member.Reset();
                if IsISESA then
                    Member.SetRange("Union Member No.", "No.") else
                    Member.SetRange("No.", "No.");
                if Member.FindFirst() then begin

                    ProdFact.Reset();
                    ProdFact.SetRange(Status, ProdFact.Status::Active);
                    ProdFact.SetRange("Product ID", AccountType);
                    ProdFact.SetRange("Product Class", ProdFact."Product Class"::Account);
                    if ProdFact.Find('-') then begin

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
                                               Member."Global Dimension 2 Code", "No.", ProdFact."Product ID");
                                            end;
                                    end;

                                    Banking."Member No." := "No.";
                                    Banking."Product Type" := ProdFact."Product ID";
                                    Banking."Product Name" := ProdFact.Description;
                                    Banking."Old Member No." := Member."Old Member No.";
                                    Banking."Old Account No." := Banking."No.";
                                    Banking."Monthly Contribution" := ProdFact."Minimum Contribution";
                                    Banking."Account Category" := ProdFact."Account Category";
                                    Banking."Loan Disbursement Account" := ProdFact."Loan Disbursement Account";
                                    Banking."Customer Posting Group" := ProdFact."Posting Group";
                                    Banking."Withdrawal Option" := ProdFact."Withdrawal Option";
                                    Banking."Account Dimension" := ProdFact."Account Dimension";
                                    Banking."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
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
                                    RepaymentAc.Insert(true);

                                   if not vendor.Get(RepaymentAc."No.") then begin
                                    RegtMngt.fnCreateVendorPostAc(RepaymentAc."No.",
                                    RepaymentAc.Name, Member."Mobile Phone No", RepaymentAc."Global Dimension 1 Code",
                                    RepaymentAc."Global Dimension 2 Code",
                                    RepaymentAc."Customer Posting Group", Member."E-Mail",
                                    RepaymentAc.Status, RepaymentAc."Product Type", Member."ID No.",
                                    RepaymentAc."Member No.", RepaymentAc."Account Category");
                                    end; 

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
                                          ProdFact."Account No. Prefix", Member."Global Dimension 2 Code", "No.");

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

                                    case Member."Customer Type" of
                                        Member."Customer Type"::" ",
                                        Member."Customer Type"::"Non-Member",
                                        Member."Customer Type"::Individual:
                                            begin
                                                CredAc."Account Dimension" := ProdFact."Account Dimension";
                                            end;
                                        Member."Customer Type"::Corporate,
                                        Member."Customer Type"::Joint,
                                        Member."Customer Type"::Groups:
                                            begin
                                                CredAc."Account Dimension" := ProdFact."Account Dimension";
                                            end
                                    end;

                                    CredAc.Insert(true);
                                    RegtMngt.fnCreateCustMemberPostAc(CredAc."No.",
                                    CredAc.Name, CredAc."Mobile No.", CredAc."Global Dimension 1 Code",
                                    CredAc."Global Dimension 2 Code", CredAc."Customer Posting Group",
                                    Member."E-Mail", CredAc.Status, CredAc."Product Type", CredAc."ID/Passport No.",
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
                                    TempCredAcc.Insert(true);
                                end;
                        end;
                    end;
                end;
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
                group("Account Category")
                {
                    field(AccountType; AccountType)
                    {
                        Caption = 'Account Type';
                        TableRelation = "Product Factory" where("Product Class" = const(Account));
                        ApplicationArea = All;
                    }
                    field(IsISESA; IsISESA)
                    {
                        Caption = 'Is IESA Member';
                        ApplicationArea = All;
                    }
                     field(ValidationType; ValidationType)
                    {
                        Caption = 'Validation Type';
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
        PFact: Record "Product Factory";
        AccountDimension: Enum AccountDimension;
        AccountType: Code[10];
        IsISESA: Boolean;
        CustRecord: Record Member;
        AccountCategory: Enum ProductAccountCategory;
        CredAcRecordEntry: Record "Account Credit";

        RegMngt: Codeunit "Registry Mngt.";
        Customers: Record Customer;
        vendor: Record Vendor;
        RegisterManagement: Codeunit "Register Management";
        AccType: Enum CustAccountType;
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        Member: Record Member;
        ClearData: Boolean;
        TempBanking: Record "Account (Procedure)";
        RegistryMngt: Codeunit "Registry Mngt.";
        AccBanking: Record "Account Banking";
        TempData: Record Member;
        TempCredAcc: Record "Account (Member)";
        CustAccType: Enum CustAccountType;
        DefDim: Record "Default Dimension";
        RepaymentAc: Record "Repayment Account";
        CustRec: Record Member;
        CredAc: Record "Account Credit";
        RegtMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        ProdCategory: Enum ProductAccountCategory;
        AccDimension: Enum AccountDimension;
        CredtMngt: Codeunit "Credit Mgmt.";
        ProdFact: Record "Product Factory";
        Banking: Record "Account Banking";
        VendAc: Record Vendor;
        CustAc: Record Customer;
        ValidateDim: Boolean;
        ValidationType: Option " ",Account,ProductType,ReqAmount,DisDate,Installment,"Loan Account","Generate Batch","Check Member","Update Account","Update Status";

}



