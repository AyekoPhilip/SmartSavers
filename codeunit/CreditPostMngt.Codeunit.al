codeunit 50021 "Credit Post Mngt."
{

    TableNo = Loans;
    trigger OnRun()
    var
    begin
        RunWithCheck(Rec)
    end;

    var
        LoanApplication: Record Loans;
        CredMgt: Codeunit "Credit Mgmt.";
        Temp: Record "Banking User Template";
        InterestLineEntry: Record "Interest Line";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        Post: Codeunit "Journal Post Mngt.";
        Linenum: Integer;
        Text00002: Label 'Interest Charged-';
        TextDescription: Label 'Principal amount-';
        Amt: array[7] of Decimal;
        JournalLines: Record "Gen. Journal Line";
        InitPost: Codeunit "Initialize Gen. Jnl.-Post";
        GeneralSetUp: Record "General Set-Up";
        GenJournal: Record "Gen. Journal Line";
        AccBanking: Record "Account Banking";
        CredAcc: Record "Account Credit";
        TextE0009: Label 'Excise Duty on-';
        Text001Description: Label 'Loan-';
        Text002Description: Label 'Deposit Purchase-';
        NotificationTemplates: Record "Notification Template";
        SmsNotification: Codeunit "SMS Notification";
        Member: Record Member;
        DocsMngt: Codeunit "Doc. Mngt";
        MonthCont: Record "Member Monthly Contribution";
        AcCatType: Enum ProductAccountCategory;
        AdviceType: Enum AdviseType;
        NotifSource: Enum NotifSourceType;
        VarVariant: Variant;
        LnApplic: Record "Loan Application";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        Text016: Label 'You cannot Post %1-%2 because there is at least one transaction %3 for this transaction.';
        DscMobLn: Record "DSC Mobile Loan";

    procedure RunWithCheck(var LoanApplic2: Record Loans)
    begin
        LoanApplication.Copy(LoanApplic2);
        Code(LoanApplication, true, Today);
        LoanApplic2 := LoanApplication
    end;

    procedure RunWithoutCheck(var LoanApplic2: Record Loans; PostInt: Boolean)
    begin
        LoanApplication.Copy(LoanApplic2);
        Code(LoanApplication, false, Today);
        LoanApplic2 := LoanApplication
    end;

    procedure "Code"(RecRef: Record Loans; CheckLine: Boolean; PostingDate: Date)
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: array[3] of Decimal;
        PostedLoan: Record Loans;
        VarVariant: Variant;
        CustRecord: Record Customer;
        CreditAccounts: Record "Credit Account";
        RegMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        GenLines: Record "Gen. Journal Line";
        LoanChrg: Record "Loan Charges";
        Registry: Codeunit "Registry Mngt.";
        MonthCont: Record "Member Monthly Contribution";
        ProdFact: Record "Product Factory";
        AccruedInt: Decimal;
        TempRec: Record "User Setup";

    begin
        RecRef.fnTestFields;
        PassDocumentNo;

        if TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 1) then
            Error(Text016, RecRef."Account Name", RecRef."No.");

        CustRecord.Reset();
        CustRecord.SetRange("No.", RecRef."Loan Account");
        CustRecord.SetRange("Account Dimension", CustRecord."Account Dimension"::Repayment);
        if not CustRecord.Find('-') then begin
            CreditAccounts.Reset();
            CreditAccounts.SetRange("No.", RecRef."Loan Account");
            if CreditAccounts.FindFirst() then begin
                RegMngt.fnCreateCustMemberPostAc(CreditAccounts."No.",
                    CreditAccounts.Name, '',
                    CreditAccounts."Global Dimension 1 Code",
                    CreditAccounts."Global Dimension 2 Code",
                    CreditAccounts."Customer Posting Group", '',
                    CreditAccounts.Status, CreditAccounts."Product Type",
                    CreditAccounts."ID No.",
                    CreditAccounts."Member No.",
                    CustomerAccType::"Loan Account",
                    AccDimension::Repayment, ProdCategory::" "
                );
            end;
        end;

        RecRef.CalcFields("Amount Guaranteed", "Total TopUp");
        Amt[1] := 0;
        Amt[2] := 0;

        GenJournal.LockTable;
        Linenum := Linenum + 1000;
        InitPost.InitializeDebitEntry(RecRef, GenJournal, 0);
        GenJournal."Line No." := Linenum;
        GenJournal."Journal Template Name" := Jtemplate;
        GenJournal."Journal Batch Name" := JBatch;
        GenJournal."Posting Date" := PostingDate;
        GenJournal.Validate(Amount, RecRef."Approved Amount");
        GenJournal.Description := CopyStr(TextDescription + RecRef."No.", 1, 50);
        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
        if GenJournal.Amount <> 0 then
            GenJournal.Insert(true);

        AccBanking.Get(RecRef."Disbursement Account No.");
        Linenum := Linenum + 1000;
        InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
        GenJournal."Line No." := Linenum;
        GenJournal."Journal Template Name" := Jtemplate;
        GenJournal."Journal Batch Name" := JBatch;
        GenJournal."Posting Date" := PostingDate;
        GenJournal."Document No." := RecRef."No.";
        GenJournal.Validate(Amount, RecRef."Approved Amount" * -1);
        GenJournal.Description := CopyStr(Text001Description + RecRef."No.", 1, 50);
        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
        if GenJournal.Amount <> 0 then
            GenJournal.Insert(true);

        AccruedInt := 0;
        if RecRef."Product Type" = 'DIVIDEND' then begin
            case RecRef."Interest Calculation Method" of
                RecRef."Interest Calculation Method"::"Straight Line":
                    begin
                        AccruedInt := Round(RecRef."Approved Amount" * (ProdFact."Interest Rate (Min.)" / 100), 0.01, '>');
                    end else begin
                    AccruedInt := Round(RecRef."Approved Amount" * (ProdFact."Interest Rate (Min.)" / 100), 0.01, '>');
                end;
            end;

        end else begin

            case RecRef."Interest Calculation Method" of
                RecRef."Interest Calculation Method"::"Straight Line":
                    begin
                        AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 100), 0.01, '>');
                    end else begin
                    AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 100), 0.01, '>');
                end;
            end;
        end;

        case RecRef."Charge Interest on Posting" of
            RecRef."Charge Interest on Posting"::"Pro-rate",
            RecRef."Charge Interest on Posting"::"Full Interest":
                begin
                    Linenum := Linenum + 1000;
                    Linenum := PerformPostOnUpfrontInt(RecRef."No.", RecRef."No.",
                    PostingDate, Dim1, Dim2, Jtemplate, JBatch, AccruedInt,
                    RecRef."Account No.", Linenum, RecRef."Product Type",
                    RecRef."Charge Interest on Posting");

                    AccBanking.Get(RecRef."Disbursement Account No.");
                    Linenum := Linenum + 1000;
                    InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal."Document No." := RecRef."No.";
                    GenJournal.Validate(Amount, AccruedInt);
                    GenJournal.Description := CopyStr('Interest Paid on-' + RecRef."No.", 1, 50);
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);

                    Linenum := Linenum + 1000;
                    InitPost.InitializeDebitEntryInt(RecRef, GenJournal, 0);
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal.Validate(Amount, AccruedInt * -1);
                    GenJournal.Description := CopyStr('Interest Paid On-' + RecRef."No.", 1, 50);
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);
                end
        end;

        Post.CompletePosting(Jtemplate, JBatch);

        TempRec.Reset();
        TempRec.SetRange("Account Type", TempRec."Account Type"::"Automated Posting");
        if TempRec.FindFirst() then begin
            PostedLoan.Reset();
            PostedLoan.SetRange("No.", RecRef."No.");
            if PostedLoan.FindFirst() then begin
                PostedLoan."Posted By" := TempRec."User ID";
                PostedLoan."Date Posted" := Today;
                PostedLoan."Time Posted" := Time;
                PostedLoan.Validate("Disbursement Date", Today);
                PostedLoan."Interest Posting Date" := CalcDate('30D', Today);
                PostedLoan."Loan Status" := PostedLoan."Loan Status"::Issued;
                PostedLoan."Approval Status" := PostedLoan."Approval Status"::Posted;
                PostedLoan.Modify;
                Commit();

                DscMobLn.Reset();
                DscMobLn.SetRange("Document No.", PostedLoan."Application No.");
                if DscMobLn.FindFirst() then begin
                    DscMobLn."Loan No." := PostedLoan."No.";
                    DscMobLn."Receipt No." := PostedLoan."Account No.";
                    DscMobLn."Approved Amount" := PostedLoan."Approved Amount";
                    DscMobLn.Remarks := 'Posted sucessfully';
                    DscMobLn."Captured By" := TempRec."User ID";
                    DscMobLn.Posted := true;
                    DscMobLn."Posted By" := UserId;
                    DscMobLn."Date Posted" := Today;
                    DscMobLn."Time Posted" := Time;
                    DscMobLn.Status := DscMobLn.Status::Posted;
                    DscMobLn.Modify(true)
                end;

            end;

            CredMgt.CreateLoancategory(PostedLoan);
            if Member.Get(PostedLoan."Account No.") then begin
                Member."Mobile Status" := Member."Mobile Status"::Active;
                Member.Modify(true);

                SmsNotification.CreateSmsNotif(NotifSource::"Loan Posted",
                Member."Mobile Phone No",
                'Loan Application successfully posted and credited to your Fosa Account. Thank You',
                Member."No.",
                Member."No.", false);
            end;
        end;
    end;


    local procedure PassDocumentNo()
    begin
        GeneralSetUp.Get;
        Temp.Reset();
        Temp.SetRange("Account Type", Temp."Account Type"::"Automated Posting");
        if Temp.FindFirst() then begin
            Temp.TestField("Loans Template");
            Temp.TestField("Loans Batch");
            Jtemplate := Temp."Loans Template";
            JBatch := Temp."Loans Batch";
            Post.ClearJournalLines(Jtemplate, JBatch);
            Dim1 := Temp."Shortcut Dimension 1 Code";
            Dim2 := Temp."Shortcut Dimension 2 Code";
        end;

    end;


    procedure PerformPostOnUpfrontInt(LoanNo: Code[20]; DocNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]; ChargeOption: Enum ChargeInterestDue): Integer
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
    begin
        if Loans.Get(LoanNo) then begin
            ProductType.Get(Loans."Product Type");
            ProductType.TestField("Interest Account (G/L)");
            Post.PostJournal(GnlTemplate, GnlJBatch, LineNo,
            Enum::"Gen. Journal Account Type"::Customer,
            DocNo, Text00002 + LoanNo, RunBal, Loans."Loan Account", PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account",
            ProductType."Interest Account (G/L)",
            Loans."Account No.", DActivity, DBranch,
            Enum::"LoanTransactionType"::"Interest Due",
            Loans."No.", Loans."Group Code", '',
            Enum::"Gen. Journal Document Type"::" ",
            Loans."Currency Code", Enum::"Gen. Journal Document Type"::" ");
            exit(LineNo)
        end
    end;


    procedure PostDepositPrch(LoanNo: Code[20]; DocNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]): Integer
    var
        Loans: Record Loans;
        CredAc: Record "Account Credit";
    begin
        if Loans.Get(LoanNo) then begin
            if Loans."Deposit Purchase" > 0 then begin
                Loans.TestField("Deposit Purchase Account");
                if CredAc.Get(Loans."Deposit Purchase Account") then begin
                    LineNo := LineNo + 1000;
                    Post.PostJournal(GnlTemplate, GnlJBatch, LineNo,
                    Enum::"Gen. Journal Account Type"::Vendor, DocNo, Text00002 + LoanNo, RunBal,
                      Loans."Disbursement Account No.", PDate,
                      Enum::"Gen. Journal Account Type"::"G/L Account", '',
                      Loans."Account No.", DActivity, DBranch,
                      Enum::"LoanTransactionType"::" ",
                      Loans."No.", Loans."Group Code",
                    '', Enum::"Gen. Journal Document Type"::" ",
                    Loans."Currency Code",
                    Enum::"Gen. Journal Document Type"::" ");

                    LineNo := LineNo + 1000;
                    Post.PostJournal(GnlTemplate, GnlJBatch, LineNo,
                    Enum::"Gen. Journal Account Type"::Customer,
                    DocNo, Text00002 + LoanNo, RunBal * -1,
                    Loans."Deposit Purchase Account", PDate,
                    Enum::"Gen. Journal Account Type"::"G/L Account", '',
                    Loans."Account No.", DActivity, DBranch,
                    Enum::"LoanTransactionType"::" ",
                    Loans."No.", Loans."Group Code", '',
                    Enum::"Gen. Journal Document Type"::" ",
                    Loans."Currency Code",
                    Enum::"Gen. Journal Document Type"::" ");

                    LineNo := LineNo + 1000;
                    LineNo := fnPostLoanDepositCharges(Loans."No.", GnlTemplate,
                    GnlJBatch, LineNo, PDate,
                    DocNo, Loans."Account No.", Loans."Disbursement Account No.",
                    DActivity, DBranch,
                    RunBal, Loans."Account No.");

                end
            end;
            exit(LineNo)
        end;
    end;


    procedure fnPostCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: Decimal;
    begin
        GeneralSetUp.Get;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", LoanNo);
        LoanChargePosted.SetFilter("Charge Type", '<>%1', LoanChargePosted."Charge Type"::Boosting);
        if LoanChargePosted.Find('-') then begin
            repeat
                LoanChargePosted.TestField("Account No.");
                ChargeAmt := 0;
                LineNo := LineNo + 1000;

                JournalLines.Init;
                JournalLines."Journal Template Name" := Gnltemplate;
                JournalLines."Journal Batch Name" := GnlJBatch;
                JournalLines."Line No." := LineNo;
                JournalLines."Posting Date" := PostDate;
                JournalLines."Document No." := DocNo;
                JournalLines."External Document No." := ExtDocNo;
                JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                JournalLines.Validate(JournalLines."Account No.", AccountNo);
                JournalLines.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                if not LoanChargePosted."Use Percentage" then begin
                    JournalLines.Validate(Amount, LoanChargePosted."Charge Amount");
                end else begin
                    if Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '=') < LoanChargePosted.Minimum then begin
                        JournalLines.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                    end else begin
                        JournalLines.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '='));
                    end;
                end;
                JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                JournalLines.Validate("Bal. Account No.", LoanChargePosted."Account No.");
                JournalLines."Shortcut Dimension 1 Code" := Dim1;
                JournalLines."Shortcut Dimension 2 Code" := Dim2;
                if JournalLines.Amount <> 0 then
                    JournalLines.Insert(true);
                ChargeAmt := JournalLines.Amount;

                case LoanChargePosted."Effect Excise Duty" of
                    LoanChargePosted."Effect Excise Duty"::Yes:
                        begin
                            GeneralSetUp.TestField("Excise Duty (%)");
                            GeneralSetUp.TestField("Excise Duty G/L");
                            LineNo := LineNo + 1000;
                            JournalLines.Init;
                            JournalLines."Journal Template Name" := Gnltemplate;
                            JournalLines."Journal Batch Name" := GnlJBatch;
                            JournalLines."Line No." := LineNo;
                            JournalLines."Posting Date" := PostDate;
                            JournalLines."Document No." := DocNo;
                            JournalLines."External Document No." := ExtDocNo;
                            JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                            JournalLines.Validate(JournalLines."Account No.", AccountNo);
                            JournalLines.Description := CopyStr('Excise Duty on-' + LoanChargePosted."Charge Description", 1, 50);
                            JournalLines.Validate(Amount, Round((GeneralSetUp."Excise Duty (%)" / 100) * (ChargeAmt)));
                            JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                            JournalLines.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                            JournalLines."Shortcut Dimension 1 Code" := Dim1;
                            JournalLines."Shortcut Dimension 2 Code" := Dim2;
                            if JournalLines.Amount <> 0 then
                                JournalLines.Insert(true);
                        end;
                end;
            until LoanChargePosted.Next = 0;
            exit(LineNo);
        end;
    end;


    procedure fnPostRefCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: Decimal;
        TransType: Record "Transaction Types";
        TieredChargeLine: Record "Tiered Charges Line";
    begin
        GeneralSetUp.Get;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", LoanNo);
        LoanChargePosted.SetFilter("Charge Type", '%1', LoanChargePosted."Charge Type"::"Top up");
        if LoanChargePosted.Find('-') then begin
            repeat
                LoanChargePosted.TestField("Account No.");
                ChargeAmt := 0;
                LineNo := LineNo + 1000;

                JournalLines.Init;
                JournalLines."Journal Template Name" := Gnltemplate;
                JournalLines."Journal Batch Name" := GnlJBatch;
                JournalLines."Line No." := LineNo;
                JournalLines."Posting Date" := PostDate;
                JournalLines."Document No." := DocNo;
                JournalLines."External Document No." := ExtDocNo;
                JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                JournalLines.Validate(JournalLines."Account No.", AccountNo);
                JournalLines.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);

                if LoanChargePosted."Staggered Charge Code" = '' then begin
                    if not LoanChargePosted."Use Percentage" then begin
                        JournalLines.Validate(Amount, LoanChargePosted."Charge Amount");
                    end else begin
                        if Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '=') < LoanChargePosted.Minimum then begin
                            JournalLines.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                        end else begin
                            JournalLines.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '='));
                        end;
                    end;
                end else begin

                    TransType.Reset();
                    TransType.SetRange(Code, LoanChargePosted."Staggered Charge Code");
                    if TransType.FindFirst() then begin
                        TieredChargeLine.Reset();
                        TieredChargeLine.SetRange(Code, TransType.Code);
                        if TieredChargeLine.FindSet() then begin
                            repeat
                                if (ApprovedAmt >= TieredChargeLine."Lower Limit") and (ApprovedAmt <= TieredChargeLine."Upper Limit") then begin
                                    JournalLines.Validate(Amount, Round(ApprovedAmt * (TieredChargeLine."Charge Amount" / 100), 1, '='));
                                end;
                            until TieredChargeLine.Next() = 0;
                        end;
                    end;
                end;
                JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                JournalLines.Validate("Bal. Account No.", LoanChargePosted."Account No.");
                JournalLines."Shortcut Dimension 1 Code" := Dim1;
                JournalLines."Shortcut Dimension 2 Code" := Dim2;
                if JournalLines.Amount <> 0 then
                    JournalLines.Insert(true);
                ChargeAmt := JournalLines.Amount;

                case LoanChargePosted."Effect Excise Duty" of
                    LoanChargePosted."Effect Excise Duty"::Yes:
                        begin
                            GeneralSetUp.TestField("Excise Duty (%)");
                            GeneralSetUp.TestField("Excise Duty G/L");
                            LineNo := LineNo + 1000;
                            JournalLines.Init;
                            JournalLines."Journal Template Name" := Gnltemplate;
                            JournalLines."Journal Batch Name" := GnlJBatch;
                            JournalLines."Line No." := LineNo;
                            JournalLines."Posting Date" := PostDate;
                            JournalLines."Document No." := DocNo;
                            JournalLines."External Document No." := ExtDocNo;
                            JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                            JournalLines.Validate(JournalLines."Account No.", AccountNo);
                            JournalLines.Description := CopyStr('Excise Duty on-' + LoanChargePosted."Charge Description", 1, 50);
                            JournalLines.Validate(Amount, Round((GeneralSetUp."Excise Duty (%)" / 100) * (ChargeAmt)));
                            JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                            JournalLines.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                            JournalLines."Shortcut Dimension 1 Code" := Dim1;
                            JournalLines."Shortcut Dimension 2 Code" := Dim2;
                            if JournalLines.Amount <> 0 then
                                JournalLines.Insert(true);
                        end;
                end;
            until LoanChargePosted.Next = 0;
            exit(LineNo);
        end;
    end;


    procedure fnPostLoanDepositCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: Decimal;
    begin
        GeneralSetUp.Get;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", LoanNo);
        LoanChargePosted.SetFilter("Charge Type", '%1', LoanChargePosted."Charge Type"::Boosting);
        if LoanChargePosted.Find('-') then begin
            LoanChargePosted.TestField("Account No.");
            ChargeAmt := 0;
            LineNo := LineNo + 1000;

            JournalLines.Init;
            JournalLines."Journal Template Name" := Gnltemplate;
            JournalLines."Journal Batch Name" := GnlJBatch;
            JournalLines."Line No." := LineNo;
            JournalLines."Posting Date" := PostDate;
            JournalLines."Document No." := DocNo;
            JournalLines."External Document No." := ExtDocNo;
            JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
            JournalLines.Validate(JournalLines."Account No.", AccountNo);
            JournalLines.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
            if not LoanChargePosted."Use Percentage" then begin
                JournalLines.Validate(Amount, LoanChargePosted."Charge Amount");
            end else begin
                if Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '=') < LoanChargePosted.Minimum then begin
                    JournalLines.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                end else begin
                    JournalLines.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '='));
                end;
            end;
            JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
            JournalLines.Validate("Bal. Account No.", LoanChargePosted."Account No.");
            JournalLines."Shortcut Dimension 1 Code" := Dim1;
            JournalLines."Shortcut Dimension 2 Code" := Dim2;
            if JournalLines.Amount <> 0 then
                JournalLines.Insert(true);
            ChargeAmt := JournalLines.Amount;

            case LoanChargePosted."Effect Excise Duty" of
                LoanChargePosted."Effect Excise Duty"::Yes:
                    begin
                        GeneralSetUp.TestField("Excise Duty (%)");
                        GeneralSetUp.TestField("Excise Duty G/L");

                        LineNo := LineNo + 1000;
                        JournalLines.Init;
                        JournalLines."Journal Template Name" := Gnltemplate;
                        JournalLines."Journal Batch Name" := GnlJBatch;
                        JournalLines."Line No." := LineNo;
                        JournalLines."Posting Date" := PostDate;
                        JournalLines."Document No." := DocNo;
                        JournalLines."External Document No." := ExtDocNo;
                        JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                        JournalLines.Validate(JournalLines."Account No.", AccountNo);
                        JournalLines.Description := CopyStr('Excise Duty on-' + LoanChargePosted."Charge Description", 1, 50);
                        JournalLines.Validate(Amount, Round((GeneralSetUp."Excise Duty (%)" / 100) * (ChargeAmt)));
                        JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                        JournalLines.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                        JournalLines."Shortcut Dimension 1 Code" := Dim1;
                        JournalLines."Shortcut Dimension 2 Code" := Dim2;
                        if JournalLines.Amount <> 0 then
                            JournalLines.Insert(true);
                    end
            end;
            exit(LineNo)
        end;
    end;


    procedure PostLoanTopup(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoansTopupPosted: Record "Loans Top up Posted";
        RecRef: Record Loans;
        TextTopup: Label 'Loan cleared-';
        GenLines: Record "Gen. Journal Line";
        LoanChargePosted: Record "Loan Charge Posted";
    begin
        LoansTopupPosted.Reset;
        LoansTopupPosted.SetRange("Loan No.", LoanNo);
        LoansTopupPosted.SetRange("Account No.", AccountNo);
        if LoansTopupPosted.Find('-') then begin
            repeat

                if RecRef.Get(LoansTopupPosted."Loan Top Up") then begin
                    RecRef.CalcFields("Outstanding Principal", "Outstanding Bill",
                          "Outstanding Interest", "Outstanding Insurance");

                    if RecRef."Outstanding Interest" > 0 then begin

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch, LineNo,
                        Enum::"Gen. Journal Account Type"::Vendor, DocNo,
                        'Interest Cleared on-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Interest",
                        RecRef."Disbursement Account No.", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account",
                        '', RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::" ", '',
                        RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch, LineNo,
                        Enum::"Gen. Journal Account Type"::Customer, DocNo,
                        'Interest Paid-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Interest" * -1,
                        RecRef."Loan Account", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::"Interest Paid",
                        RecRef."No.", RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");
                    end;

                    if RecRef."Outstanding Bill" > 0 then begin

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Vendor,
                        DocNo,
                        'Bills Cleared-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Bill",
                        RecRef."Disbursement Account No.", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::" ", '',
                        RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Customer,
                        DocNo,
                        'Bills Paid' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Bill" * -1,
                        RecRef."Loan Account", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::"Penalty Paid",
                        RecRef."No.", RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");
                    end;

                    if RecRef."Outstanding Principal" > 0 then begin
                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Vendor,
                        DocNo,
                        'Principal Cleared-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Principal",
                        RecRef."Disbursement Account No.", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::" ",
                        '', RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Customer,
                        DocNo,
                        'Principal Paid-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Principal" * -1,
                        RecRef."Loan Account", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::Repayment,
                        RecRef."No.", RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");
                    end;
                end
            until LoansTopupPosted.Next = 0;
        end
    end;















}



