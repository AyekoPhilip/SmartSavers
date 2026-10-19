codeunit 50058 "DSC Credit Analysis"
{
    trigger OnRun()
    begin

    end;

    var
        SuccessfullRequestTxt: Label '1';
        Text0001: Label '01|Invalid Entries';
        Text0002: Label '02|Requested amount cannot be zero or less than zero';
        Text0003: Label '03|This member account is not active.';
        Text0004: Label '04|This member account is blocked from transacting.';
        Text0005: Label '05|Member has no transactional phone number found.';
        Text0006: Label '06|This account is not active.';
        Text0007: Label '07|This account is blocked from transacting.';
        Text0008: Label '08|Member has loan that is not performing.';
        Text0009: Label '09|Member Has not made consecutive contribution for last 6 Months';
        Text00010: Label '10|Member not registered for mobile Banking.';
        Text0011: Label '11|This product is not active.';
        Text00011: Label '12|Minimum or Maximum amount must have a value in product type factory';
        Text0012: Label '13|member has an existing same loan with balance. ';
        Text0013: Label '14|Amount applied is more than Loan limit.';
        Text0014: Label '15|Amount applied is either more or less that Max. or Min loan limit.';
        Text0016: Label 'Successfull Application.';
        Text0015: Label '16|System Buffer Error. Please Send Request Again.';
        Text0017: Label '17|Member Account not found';
        Text0018: Label '18|Loan Product type does not exist';
        Text0019: Label '19|Member Loan Limit is zero and therefore does not qualifies for loan application.';
        Text0020: Label '10|Loan application not found. Try again';
        AltCtrl: Codeunit "Register Management";
        LStatus: Enum MobileLoanStatus;
        CustRecord: Record Member;
        Account: Record "Account Credit";
        Loan: Record "Loans Categorization";
        LoanApps: Record "Loan Application";
        Product: Record "Product Factory";
        FactProd: Record "Product Factory";
        ApplicLoan: Record "DSC Mobile Loan";
        RegmntAcc: Record "Account (Procedure)";
        LoansT: Record Loans;
        DscScoringMngt: Codeunit "DSC Credit Analysis";
        CredtMngt: Codeunit "Credit Mgmt.";
        PostedLoan: Record Loans;
        GenPostMngt: Codeunit "Gen.Jnl.-Post Line";
        VarVariant: Variant;
        QualifyAmt: Decimal;

    procedure CheckMemberEligibilityCreteria(MemberNo: Code[20]; ProductID: Code[20]; DocNo: Code[20]; AmtToPost: Decimal; Descript: Text[150]; PhoneNo: Code[20]; InstlPeriod: Integer) LoanNo: Text[150]
    var
        ExistLoan: Record Loans;
    begin
        if (MemberNo = '') or (ProductID = '') or (DocNo = '') or (PhoneNo = '') or (AmtToPost = 0) then begin
            LoanNo := Text0001;
            AltCtrl.BufferFailedLoanApplication('', MemberNo, PhoneNo, AmtToPost,ProductID, Text0001, LStatus::Failed, LoanNo, DocNo);
            exit(LoanNo)
        end else begin
            LoanNo := SuccessfullRequestTxt;
        end;

        QualifyAmt := 0;

        ExistLoan.Reset();
        ExistLoan.SetRange("Account No.", MemberNo);
        ExistLoan.SetRange("Product Type", ProductID);
        IF ExistLoan.FindFirst() then begin
            repeat
                ExistLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
                if ExistLoan."Outstanding Balance" > 0 then begin
                    LoanNo := Text0012 + ExistLoan."No.";
                    AltCtrl.BufferFailedLoanApplication(ExistLoan."ID No.", MemberNo, PhoneNo, AmtToPost,
                    ExistLoan."Product Type", Text0012 + ExistLoan."No.", LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end;
            Until ExistLoan.Next() = 0;
        end;

        CustRecord.Reset();
        CustRecord.SetRange("No.", MemberNo);
        if not CustRecord.FindFirst() then begin
            LoanNo := Text0017;
            AltCtrl.BufferFailedLoanApplication(CustRecord."ID No.",
            MemberNo, PhoneNo, AmtToPost, ProductID, Text0017, LStatus::Failed, LoanNo, DocNo);
            exit(LoanNo);
            
        end else begin

            if (CustRecord."Loan Status" = CustRecord."Loan Status"::Defaulter) or (CustRecord."Mobile Status" = CustRecord."Mobile Status"::Defaulter) then begin
                LoanNo := Text0003;
                AltCtrl.BufferFailedLoanApplication(CustRecord."ID No.",
                CustRecord."No.", PhoneNo, AmtToPost, ProductID, Text0003, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            if AmtToPost <= 0 then begin
                LoanNo := Text0002;
                AltCtrl.BufferFailedLoanApplication('', CustRecord."No.", PhoneNo, AmtToPost,
                ProductID, Text0002, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end else begin
                LoanNo := SuccessfullRequestTxt
            end;

            RegmntAcc.Reset();
            RegmntAcc.SetRange("Member No.", CustRecord."No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
            if not RegmntAcc.FindFirst() then begin
                LoanNo := Text00010;
                AltCtrl.BufferFailedLoanApplication('', CustRecord."No.", PhoneNo, AmtToPost,
                ProductID, Text00010, LStatus::Failed, LoanNo, DocNo);
            end;

            if Product.GET(ProductID) then begin

                if (Product."Minimum Loan Amount" = 0) Or (Product."Maximum Loan Amount" = 0) then begin
                    LoanNo := Text00011;
                    AltCtrl.BufferFailedLoanApplication('', CustRecord."No.", PhoneNo, AmtToPost,
                    ProductID, Text00011, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end;

                if Product.Status <> Product.Status::Active then begin
                    LoanNo := Text0011;
                    AltCtrl.BufferFailedLoanApplication('', CustRecord."No.", PhoneNo, AmtToPost,
                    ProductID, Text0011, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin

                    if (AmtToPost < Product."Minimum Loan Amount") Or (AmtToPost > Product."Maximum Loan Amount") then begin
                        LoanNo := Text0014;
                        AltCtrl.BufferFailedLoanApplication('', CustRecord."No.", PhoneNo, AmtToPost,
                        Product."Product ID", Text0014, LStatus::Failed, LoanNo, DocNo);
                        exit(LoanNo);
                    end
                end;
            end else begin
                LoanNo := Text0018;
                AltCtrl.BufferFailedLoanApplication('', CustRecord."No.", PhoneNo, AmtToPost,
                ProductID, Text0018, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);

            end;

            Account.Reset();
            Account.SetRange("Member No.", CustRecord."No.");
            Account.SetRange("Account Category", Account."Account Category"::"Shares Capital");
            IF Account.FindFirst() then begin
                Account.CalcFields("Balance (LCY)");
                FactProd.Reset();
                FactProd.SetRange("Product ID", Account."Product Type");
                if FactProd.FindFirst() then
                    FactProd.TestField("Minimum Balance");
                IF Account."Balance (LCY)" < FactProd."Minimum Balance" then begin
                    LoanNo := 'Member has shares capital below the required threshhold';
                    AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                    AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end else begin

                LoanNo := '99|Member has no shares Capital';
                AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            Account.Reset();
            Account.SetRange("Member No.", CustRecord."No.");
            Account.SetRange("Account Category", Account."Account Category"::"Shares Capital");
            IF Account.FindFirst() then begin
                Account.CalcFields("Balance (LCY)");
                IF Account."Balance (LCY)" <= 0 then begin
                    LoanNo := '99|Member has no shares Capital';
                    AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                    AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end else begin
                LoanNo := '99|Member has no shares Capital';
                AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);

            end;

            Account.Reset();
            Account.SetRange("Member No.", CustRecord."No.");
            Account.SetRange("Account Category", Account."Account Category"::"Shares Deposit");
            IF Account.FindFirst() then begin
                Account.CalcFields("Balance (LCY)");
                IF Account."Balance (LCY)" <= 0 then begin
                    LoanNo := '99|Member has no shares Deposit';
                    AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                    AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end else begin

                LoanNo := '99|Member has no shares Deposit';
                AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            IF CustRecord.Status <> CustRecord.Status::Active then begin
                LoanNo := Text0003;
                AltCtrl.BufferFailedLoanApplication(CustRecord."ID No.",
                CustRecord."No.", PhoneNo, AmtToPost, ProductID, Text0003, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            END ELSE BEGIN
                LoanNo := SuccessfullRequestTxt
            end;

            IF CustRecord.Blocked <> CustRecord.Blocked::" " then begin
                LoanNo := Text0003;
                AltCtrl.BufferFailedLoanApplication(CustRecord."ID No.",
                MemberNo, PhoneNo, AmtToPost, ProductID, Text0003, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            END ELSE BEGIN
                LoanNo := SuccessfullRequestTxt
            end;

            Account.Reset();
            Account.SetRange("Member No.", CustRecord."No.");
            Account.SetRange("Account Category", Account."Account Category"::"Shares Deposit");
            IF Account.FIND('-') then begin
                IF Account.Status <> Account.Status::Active then begin
                    LoanNo := Text0006;
                    AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                    AmtToPost, ProductID, Text0006, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            Account.Reset();
            Account.SetRange("Member No.", CustRecord."No.");
            Account.SetRange("Account Category", Account."Account Category"::"Shares Deposit");
            IF Account.FIND('-') then begin
                IF (Account.Blocked = Account.Blocked::Payment) or (Account.Blocked = Account.Blocked::All) then begin
                    LoanNo := Text0007;
                    AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", CustRecord."No.", Account."Mobile No.",
                    AmtToPost, ProductID, Text0007, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            if ProductID <> 'DIVIDEND' then begin

                Loan.Reset();
                Loan.SetRange("Account No.", CustRecord."No.");
                Loan.SetFilter("Performance Indicator", '<>%1 & <>%2', Loan."Performance Indicator"::Performing, Loan."Performance Indicator"::Watch);
                IF Loan.Find('-') then begin
                    Loan.CalcFields("Outstanding Balance");
                    if Loan."Outstanding Balance" > 0 then begin
                        LoanNo := Text0008;
                        AltCtrl.BufferFailedLoanApplication('', CustRecord."No.", PhoneNo, AmtToPost, ProductID, Text0008, LStatus::Failed, LoanNo, DocNo);
                        exit(LoanNo);
                    end;

                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            LoansT.Reset();
            LoansT.SetRange("Account No.", CustRecord."No.");
            LoansT.SetRange("Product Type", ProductID);
            LoansT.SetRange("Application Type", LoansT."Application Type"::Mobile);
            LoansT.SetFilter("Approval Status", '%1|%2|%3',
            LoansT."Approval Status"::Open, LoansT."Approval Status"::"Pending Approval",
            LoansT."Approval Status"::Approved);
            if LoansT.FindFirst() then begin
                LoansT.CalcFields("Outstanding Balance");
                if LoansT."Outstanding Balance" = 0 then
                    LoansT.Delete();
            end;

            Account.Reset();
            Account.SetRange("No.", CustRecord."No.");
            Account.SetRange(Blocked, Account.Blocked::" ");
            Account.SetRange(Status, Account.Status::Active);
            Account.SetFilter("Balance (LCY)", '>0');
            Account.SetRange("Account Category", Account."Account Category"::"Shares Deposit");
            if Account.Find('-') then begin
                if AltCtrl.GetMaxContribLimit(CustRecord."No.", Product."Product ID", 90) = 0 then begin
                    LoanNo := Text0009;
                    AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", Account."Member No.", PhoneNo,
                    AmtToPost, Product."Product ID", Text0009, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            if Product."Loan Span" = Product."Loan Span"::"Mobile Loan" then
                QualifyAmt := AltCtrl.GetLoanMaxCreditLimitScoreQC(CustRecord, Product."Product ID", 90, 0) else
                QualifyAmt := AltCtrl.GetDivLoanMaxCreditLimitScore(CustRecord, Product."Product ID", 90, 0);

            if QualifyAmt <= 0 then begin
                LoanNo := Text0019;
                AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", Account."Member No.", PhoneNo,
                AmtToPost, ProductID, Text0019, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            if AmtToPost > QualifyAmt then begin

                LoanNo := Text0013;
                AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.", Account."Member No.", PhoneNo,
                AmtToPost, ProductID, Descript, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end else begin
                LoanNo := SuccessfullRequestTxt
            end;

            if LoanNo = '1' then begin
                AltCtrl.BufferFailedLoanApplication(Account."ID/Passport No.",
                Account."Member No.", Account."Mobile No.", AmtToPost,
                Product."Product ID", Descript, LStatus::Pending, Text0016, DocNo);
            end;
        

            ApplicLoan.Reset();
            ApplicLoan.SetRange("API Code", DocNo);
            if not ApplicLoan.FindFirst() then begin
                LoanNo := Text0015;
                exit(LoanNo);
            end else begin

                if not CheckIfExistLoan(CustRecord."No.", Product."Product ID") then begin
                    LoanNo := CredtMngt.fnCreateLoanApplication(CustRecord."No.", Product."Product ID", AmtToPost, Product."Ordinary Default Intallments");
                    PostedLoan.Reset();
                    PostedLoan.SetRange("No.", LoanNo);
                    if PostedLoan.FindFirst() then begin
                        PostedLoan."Application No." := DocNo;
                        PostedLoan.Modify(true);
                        Codeunit.Run(Codeunit::"Credit Post Mngt.", PostedLoan);
                        LoanNo := '00|' + PostedLoan."No.";
                        exit(LoanNo)
                    end;

                end else begin

                    LoanNo := Text0020;
                    AltCtrl.BufferFailedLoanApplication(ExistLoan."ID No.", MemberNo, PhoneNo,
                    AmtToPost, ExistLoan."Product Type", Text0020, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end;

            end;
        end
    end;

    procedure CheckIfExistLoan(AccountNo: Code[100]; ProdCode: Code[20]): Boolean
    var
        LoanT: Record Loans;
        PFact: Record "Product Factory";
    begin
        if PFact.Get(ProdCode) then begin
            if not PFact."Allow Multiple Running Loans" then begin
                LoanT.Reset();
                LoanT.SetRange("Account No.", AccountNo);
                LoanT.SetRange("Product Type", ProdCode);
                IF LoanT.FindSet() then begin
                    repeat
                        LoanT.CalcFields("Outstanding Balance", "Outstanding Interest");
                        if LoanT."Outstanding Balance" > 0 then begin
                            exit(true)
                        end
                    until LoanT.Next() = 0;
                end;
            end;
        end;
        exit(false)
    end;
}



