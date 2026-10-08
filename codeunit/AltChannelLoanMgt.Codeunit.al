namespace AltChannelPostMgt.AltChannelPostMgt;

using System.Automation;

codeunit 90004 "Rcv09 Alt. Channel Loan Mgt."
{

    procedure Applicmgt(MemberNo: Code[20]; AmtToPost: Decimal; Descript: Text[150]; LoanType: Code[20]; DocNo: Code[20]; SavingsDays: Integer; PhoneNo: Code[20]; IntPeriod: Integer) Response: Code[100]
    var
        Post: Code[100];
        LStatus: Enum MobileLoanStatus;
        CredtMngt: Codeunit "Credit Mgmt.";
    begin
        if (AmtToPost > 0) and (LoanType <> '') and (MemberNo <> '') then begin
            Response := '0';
            Post := '0';
            Response := CheckEligCreteria(MemberNo, LoanType, DocNo, AmtToPost, Descript, PhoneNo, IntPeriod);
        end else begin
            Response := '01|Invalid Entry';
            Logfailedattempt('', MemberNo, PhoneNo, AmtToPost, LoanType, Descript, LStatus::Failed, '', DocNo);
        end;
    end;

    local procedure CheckEligCreteria(MemberNo: Code[20]; ProductID: Code[20]; DocNo: Code[20]; AmtToPost: Decimal; Descript: Text[150]; PhoneNo: Code[20]; InstlPeriod: Integer) LoanNo: Text[150]
    var
        Loanmgt: Record Loans;

        appscoremgt: Codeunit "Rcv07 Credit Score Engine Mgt.";
        scoremgt: Codeunit "Rcv07 Credit Score Engine Mgt.";
        LStatus: Enum MobileLoanStatus;
        custmgt: Record Member;
        accmgt: Record "Account Credit";
        Loan: Record "Loans Categorization";
        LoanApps: Record "Loan Application";
        Product: Record "Product Factory";
        FactProd: Record "Product Factory";
        applicmgt: Record "DSC Mobile Loan";
        RegmntAcc: Record "Account (Procedure)";
        appmgt: Record Loans;
        DscScoringMngt: Codeunit "DSC Credit Analysis";
        CredtMngt: Codeunit "Credit Mgmt.";
        PLoanmgt: Record Loans;
        GenPostMngt: Codeunit "Gen.Jnl.-Post Line";
        VarVariant: Variant;
        QualifyAmt: Decimal;

    begin
        if (MemberNo = '') or (ProductID = '') or (DocNo = '') or (PhoneNo = '') or (AmtToPost = 0) then begin
            LoanNo := Text0001;
            Logfailedattempt('', MemberNo, PhoneNo, AmtToPost, ProductID, Text0001, LStatus::Failed, LoanNo, DocNo);
            exit(LoanNo)
        end else begin
            LoanNo := SuccessfullRequestTxt;
        end;

        QualifyAmt := 0;

        Loanmgt.Reset();
        Loanmgt.SetRange("Account No.", MemberNo);
        Loanmgt.SetRange("Product Type", ProductID);
        IF Loanmgt.FindFirst() then begin
            repeat
                Loanmgt.CalcFields("Outstanding Balance", "Outstanding Interest");
                if Loanmgt."Outstanding Balance" > 0 then begin
                    LoanNo := Text0012 + Loanmgt."No.";
                    Logfailedattempt(Loanmgt."ID No.", MemberNo, PhoneNo, AmtToPost,
                    Loanmgt."Product Type", Text0012 + Loanmgt."No.", LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end;
            Until Loanmgt.Next() = 0;
        end;

        custmgt.Reset();
        custmgt.SetRange("No.", MemberNo);
        if not custmgt.FindFirst() then begin
            LoanNo := Text0017;
            Logfailedattempt(custmgt."ID No.",
            MemberNo, PhoneNo, AmtToPost, ProductID, Text0017, LStatus::Failed, LoanNo, DocNo);
            exit(LoanNo);

        end else begin

            if (custmgt."Loan Status" = custmgt."Loan Status"::Defaulter) or (custmgt."Mobile Status" = custmgt."Mobile Status"::Defaulter) then begin
                LoanNo := Text0003;
                Logfailedattempt(custmgt."ID No.",
                custmgt."No.", PhoneNo, AmtToPost, ProductID, Text0003, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            if AmtToPost <= 0 then begin
                LoanNo := Text0002;
                Logfailedattempt('', custmgt."No.", PhoneNo, AmtToPost,
                ProductID, Text0002, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end else begin
                LoanNo := SuccessfullRequestTxt
            end;

            RegmntAcc.Reset();
            RegmntAcc.SetRange("Member No.", custmgt."No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
            if not RegmntAcc.FindFirst() then begin
                LoanNo := Text00010;
                Logfailedattempt('', custmgt."No.", PhoneNo, AmtToPost,
                ProductID, Text00010, LStatus::Failed, LoanNo, DocNo);
            end;

            if Product.GET(ProductID) then begin

                if (Product."Minimum Loan Amount" = 0) Or (Product."Maximum Loan Amount" = 0) then begin
                    LoanNo := Text00011;
                    Logfailedattempt('', custmgt."No.", PhoneNo, AmtToPost,
                    ProductID, Text00011, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end;

                if Product.Status <> Product.Status::Active then begin
                    LoanNo := Text0011;
                    Logfailedattempt('', custmgt."No.", PhoneNo, AmtToPost,
                    ProductID, Text0011, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin

                    if (AmtToPost < Product."Minimum Loan Amount") Or (AmtToPost > Product."Maximum Loan Amount") then begin
                        LoanNo := Text0014;
                        Logfailedattempt('', custmgt."No.", PhoneNo, AmtToPost,
                        Product."Product ID", Text0014, LStatus::Failed, LoanNo, DocNo);
                        exit(LoanNo);
                    end
                end;
            end else begin
                LoanNo := Text0018;
                Logfailedattempt('', custmgt."No.", PhoneNo, AmtToPost,
                ProductID, Text0018, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);

            end;

            accmgt.Reset();
            accmgt.SetRange("Member No.", custmgt."No.");
            accmgt.SetRange("Account Category", accmgt."Account Category"::"Shares Capital");
            IF accmgt.FindFirst() then begin
                accmgt.CalcFields("Balance (LCY)");
                FactProd.Reset();
                FactProd.SetRange("Product ID", accmgt."Product Type");
                if FactProd.FindFirst() then
                    FactProd.TestField("Minimum Balance");
                IF accmgt."Balance (LCY)" <= 0 then begin
                    LoanNo := 'Member has shares capital below the required threshhold';
                    Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                    AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end else begin

                LoanNo := '99|Member has no shares Capital';
                Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            accmgt.Reset();
            accmgt.SetRange("Member No.", custmgt."No.");
            accmgt.SetRange("Account Category", accmgt."Account Category"::"Shares Capital");
            IF accmgt.FindFirst() then begin
                accmgt.CalcFields("Balance (LCY)");
                IF accmgt."Balance (LCY)" <= 0 then begin
                    LoanNo := '99|Member has no shares Capital';
                    Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                    AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end else begin
                LoanNo := '99|Member has no shares Capital';
                Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);

            end;

            accmgt.Reset();
            accmgt.SetRange("Member No.", custmgt."No.");
            accmgt.SetRange("Account Category", accmgt."Account Category"::"Shares Deposit");
            IF accmgt.FindFirst() then begin
                accmgt.CalcFields("Balance (LCY)");
                IF accmgt."Balance (LCY)" <= 0 then begin
                    LoanNo := '99|Member has no shares Deposit';
                    Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                    AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end else begin

                LoanNo := '99|Member has no shares Deposit';
                Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                AmtToPost, ProductID, LoanNo, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            accmgt.Reset();
            accmgt.SetRange("No.", custmgt."No.");
            accmgt.SetRange(Blocked, accmgt.Blocked::" ");
            accmgt.SetRange(Status, accmgt.Status::Active);
            accmgt.SetRange("Account Category", accmgt."Account Category"::"Shares Deposit");
            if accmgt.FindFirst() then begin
                if accmgt."Balance (LCY)" < Product."Minimum Deposit Balance" then begin
                    LoanNo := Text0009;
                    Logfailedattempt(accmgt."ID/Passport No.", accmgt."Member No.", PhoneNo,
                    AmtToPost, Product."Product ID", Text0009, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            IF custmgt.Status <> custmgt.Status::Active then begin
                LoanNo := Text0003;
                Logfailedattempt(custmgt."ID No.",
                custmgt."No.", PhoneNo, AmtToPost, ProductID, Text0003, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            END ELSE BEGIN
                LoanNo := SuccessfullRequestTxt
            end;

            IF custmgt.Blocked <> custmgt.Blocked::" " then begin
                LoanNo := Text0003;
                Logfailedattempt(custmgt."ID No.",
                MemberNo, PhoneNo, AmtToPost, ProductID, Text0003, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            END ELSE BEGIN
                LoanNo := SuccessfullRequestTxt
            end;

            accmgt.Reset();
            accmgt.SetRange("Member No.", custmgt."No.");
            accmgt.SetRange("Account Category", accmgt."Account Category"::"Shares Deposit");
            IF accmgt.FindFirst() then begin
                IF accmgt.Status <> accmgt.Status::Active then begin
                    LoanNo := Text0006;
                    Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                    AmtToPost, ProductID, Text0006, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            accmgt.Reset();
            accmgt.SetRange("Member No.", custmgt."No.");
            accmgt.SetRange("Account Category", accmgt."Account Category"::"Shares Deposit");
            IF accmgt.FindFirst() then begin
                IF (accmgt.Blocked = accmgt.Blocked::Payment) or (accmgt.Blocked = accmgt.Blocked::All) then begin
                    LoanNo := Text0007;
                    Logfailedattempt(accmgt."ID/Passport No.", custmgt."No.", accmgt."Mobile No.",
                    AmtToPost, ProductID, Text0007, LStatus::Failed, LoanNo, DocNo);
                    exit(LoanNo);
                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            if ProductID <> 'DIVIDEND' then begin

                Loan.Reset();
                Loan.SetRange("Account No.", custmgt."No.");
                Loan.SetFilter("Performance Indicator", '<>%1 & <>%2', Loan."Performance Indicator"::Performing, Loan."Performance Indicator"::Watch);
                IF Loan.FindFirst() then begin
                    Loan.CalcFields("Outstanding Balance");
                    if Loan."Outstanding Balance" > 0 then begin
                        LoanNo := Text0008;
                        Logfailedattempt('', custmgt."No.", PhoneNo, AmtToPost, ProductID, Text0008, LStatus::Failed, LoanNo, DocNo);
                        exit(LoanNo);
                    end;

                end else begin
                    LoanNo := SuccessfullRequestTxt
                end;
            end;

            appmgt.Reset();
            appmgt.SetRange("Account No.", custmgt."No.");
            appmgt.SetRange("Product Type", ProductID);
            appmgt.SetRange("Application Type", appmgt."Application Type"::Mobile);
            appmgt.SetFilter("Approval Status", '%1|%2|%3',
            appmgt."Approval Status"::Open, appmgt."Approval Status"::"Pending Approval",
            appmgt."Approval Status"::Approved);
            if appmgt.FindFirst() then begin
                appmgt.CalcFields("Outstanding Balance");
                if appmgt."Outstanding Balance" = 0 then
                    appmgt.Delete();
            end;
            QualifyAmt := scoremgt.GetQualifyingAmt(custmgt."No.", Product."Product ID", 90, false);
            if QualifyAmt <= 0 then begin
                LoanNo := Text0019;
                Logfailedattempt(accmgt."ID/Passport No.", accmgt."Member No.", PhoneNo,
                AmtToPost, ProductID, Text0019, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end;

            if AmtToPost > QualifyAmt then begin
                LoanNo := Text0013;
                Logfailedattempt(accmgt."ID/Passport No.", accmgt."Member No.", PhoneNo,
                AmtToPost, ProductID, Descript, LStatus::Failed, LoanNo, DocNo);
                exit(LoanNo);
            end else begin
                LoanNo := SuccessfullRequestTxt
            end;

            if LoanNo = '1' then
                Logfailedattempt(accmgt."ID/Passport No.", accmgt."Member No.", accmgt."Mobile No.", AmtToPost,
                Product."Product ID", Descript, LStatus::Pending, Text0016, DocNo);

            applicmgt.Reset();
            applicmgt.SetRange("API Code", DocNo);
            if not applicmgt.FindFirst() then begin
                LoanNo := Text0015;
                exit(LoanNo);
            end else begin

                if not CheckIfExistLoan(custmgt."No.", Product."Product ID") then begin
                    LoanNo := CredtMngt.fnCreateLoanApplication(custmgt."No.", Product."Product ID", AmtToPost, Product."Ordinary Default Intallments");
                    PLoanmgt.Reset();
                    PLoanmgt.SetRange("No.", LoanNo);
                    if PLoanmgt.FindFirst() then begin
                        PLoanmgt."Application No." := DocNo;
                        PLoanmgt.Modify(true);
                        Codeunit.Run(Codeunit::"Credit Post Mngt.", PLoanmgt);
                        LoanNo := '00|' + PLoanmgt."No.";
                        exit(LoanNo)
                    end;

                end else begin

                    LoanNo := Text0020;
                    Logfailedattempt(Loanmgt."ID No.", MemberNo, PhoneNo, AmtToPost, Loanmgt."Product Type", Text0020, LStatus::Failed, LoanNo, DocNo);
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


    local procedure Logfailedattempt(IDNo: Code[20]; MemberNo: Code[20]; TransactionalMobileNo: Code[20];
    Amt: Decimal; ProductID: Code[20]; DescriptTxt: Text[150]; MStatus: Enum MobileLoanStatus; RMarks: Text[150];
                                                                                                                                                                                       DocumentNo: Code[50])
    LoanApp: Record "DSC Mobile Loan";
    begin
        LoanApp.Init();
        LoanApp."Entry No." := InitNextIntDSCEntryNo();
        LoanApp."Document No." := IDNo;
        LoanApp."Account No." := MemberNo;
        LoanApp."Phone No." := TransactionalMobileNo;
        LoanApp.Date := Today;
        LoanApp."Captured By" := UserId;
        LoanApp."Date/Time Captured" := CurrentDateTime;
        LoanApp."Requested Amount" := Amt;
        LoanApp."Product Type" := ProductID;
        LoanApp.Remarks := RMarks;
        LoanApp.Description := DescriptTxt;
        LoanApp.Status := MStatus;
        LoanApp."API Code" := DocumentNo;
        LoanApp."Document No." := DocumentNo;
        if LoanApp."Requested Amount" > 0 then
            LoanApp.Insert(true);

    end;

    local procedure InitNextIntDSCEntryNo(): Integer
    var
        NextEntryNo: Integer;
        RecRef: Record "DSC Mobile Loan";
    begin
        RecRef.LockTable();
        IF RecRef.FindLast() then begin
            NextEntryNo := RecRef."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;


    var
        RegisterNo: Integer;
        FromEntryNo: Integer;
        ProdCategory: Enum ProductAccountCategory;
        ToEntryNo: Integer;
        DescriptionTxt: Text[250];
        ApprovalsMngt: Codeunit "Approval Mgmt.";
        RegistryMngt: Codeunit "Registry Mngt.";
        ApprovalEntry: Record "Approval Entry";
        PostAc: Variant;
        Trans: Record "ATM Transaction";
        MTransactions: Record "Mobile Loan Transaction";
        MobTrans: Record "Mobile Money Transaction";
        NotifSource: Enum NotifSourceType;
        DscScoringMngt: Codeunit "DSC Credit Analysis";
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
}
