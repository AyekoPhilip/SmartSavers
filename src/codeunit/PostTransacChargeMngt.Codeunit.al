codeunit 50073 "Post Transac. Charge Mngt."
{
    trigger OnRun()
    begin
    end;

    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AcctType: Enum "Gen. Journal Account Type";
        TransacType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";

    procedure fnPostTransactionCharges(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date; GenLine: Integer; ExtDocNo: code[20])

    begin

        GenSetup.Get();
        ChargeAmount := 0;

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.FindFirst() then begin

            TransactionCharges.TestField("G/L Account");
            case TransactionCharges."Charge Type" of
                TransactionCharges."Charge Type"::"Flat Amount":
                    begin
                        TransactionCharges.TestField("Charge Amount");
                        ChargeAmount := TransactionCharges."Charge Amount";

                    end;
                TransactionCharges."Charge Type"::"% of Amount":
                    begin
                        TransactionCharges.TestField("Percentage of Amount");
                        ChargeAmount := (Amt * TransactionCharges."Percentage of Amount") * 0.01

                    end;
                TransactionCharges."Charge Type"::Staggered:
                    begin
                        TransactionCharges.TestField("Staggered Charge Code");
                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := (Amt * TariffDetails.Percentage * 0.01);
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;

                    end;
            end;

            LineNo := LineNo + GenLine;
            JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo,
            AcctType::Vendor, DocNo, TransactionCharges.Description,
            ChargeAmount, AccountNo, TransactionDate, AcctType::"G/L Account",
            TransactionCharges."G/L Account", ExtDocNo, Dim1, Dim2, TransacType::" ",
            '', '', '', DocType::" ", '', DocType::" ", '');

            if TransactionCharges."Recover Excise Duty" then begin
                GenSetup.TestField("Excise Duty (%)");
                GenSetup.TestField("Excise Duty G/L");

                LineNo := LineNo + 10000;
                JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo, AcctType::Vendor,
                DocNo, TransactionCharges.Description,
                Round((ChargeAmount * (GenSetup."Excise Duty (%)" / 100)), 0.5, '='),
                AccountNo, TransactionDate, AcctType::"G/L Account",
                GenSetup."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::" ",
                '', '', '', DocType::" ", '', DocType::" ", '');

            end;
        end;
    end;

    procedure fnPostLoanCharge(RecRefNo: Code[100]; AmountToDisburse: Decimal; AccountNo: Code[100]; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date; GenJLine: Integer; ExtDocNo: code[20]): Integer
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: array[9] of Decimal;
        ChargeLine: Integer;

    begin
        GenSetup.Get();
        ChargeAmt[1] := 0;
        LineNo := GenJLine;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", RecRefNo);
        LoanChargePosted.SetFilter("Charge Type", '<>%1 & <>%2 & <>%3 & <>%4', LoanChargePosted."Charge Type"::"Top up",
        LoanChargePosted."Charge Type"::Boosting, LoanChargePosted."Charge Type"::Restructure,
        LoanChargePosted."Charge Type"::Prorate);
        if LoanChargePosted.Find('-') then begin
            repeat
                LoanChargePosted.TestField("Account No.");

                case LoanChargePosted."Charge Method" of
                    LoanChargePosted."Charge Method"::"Flat Amount":
                        begin
                            LoanChargePosted.TestField("Charge Amount");
                            ChargeAmt[1] := LoanChargePosted."Charge Amount";

                        end;
                    LoanChargePosted."Charge Method"::"% of Amount":
                        begin
                            LoanChargePosted.TestField(Percentage);
                            ChargeAmt[1] := Round((AmountToDisburse * (LoanChargePosted.Percentage / 100)), 0.5, '=');

                        end;
                    LoanChargePosted."Charge Method"::Staggered:
                        begin
                            LoanChargePosted.TestField("Staggered Charge Code");

                            TariffDetails.Reset;
                            TariffDetails.SetRange(TariffDetails.Code, LoanChargePosted."Staggered Charge Code");
                            if TariffDetails.Find('-') then begin
                                repeat

                                    if (AmountToDisburse >= TariffDetails."Lower Limit") and (AmountToDisburse <= TariffDetails."Upper Limit") then begin
                                        if TariffDetails."Use Percentage" = true then begin
                                            ChargeAmt[1] := Round((AmountToDisburse * TariffDetails.Percentage * 0.01), 0.5, '=');
                                        end else begin
                                            ChargeAmt[1] := TariffDetails."Charge Amount";
                                        end;
                                    end;
                                until TariffDetails.Next = 0;
                            end;

                        end;
                end;

                LineNo := LineNo + 100;
                JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo,
                AcctType::Vendor, DocNo, LoanChargePosted."Charge Description",
                ChargeAmt[1], AccountNo, TransactionDate, AcctType::"G/L Account",
                LoanChargePosted."Account No.", ExtDocNo, Dim1, Dim2, TransacType::" ",
                '', '', '', DocType::" ", '', DocType::" ", '');

                case LoanChargePosted."Effect Excise Duty" of
                    LoanChargePosted."Effect Excise Duty"::Yes:
                        begin
                            GenSetup.TestField("Excise Duty (%)");
                            GenSetup.TestField("Excise Duty G/L");

                            LineNo := LineNo + 100;
                            JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo, AcctType::Vendor,
                            DocNo, LoanChargePosted."Charge Description",
                            Round((ChargeAmt[1] * (GenSetup."Excise Duty (%)" / 100)), 0.5, '='),
                            AccountNo, TransactionDate, AcctType::"G/L Account",
                            GenSetup."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::" ",
                            '', '', '', DocType::" ", '', DocType::" ", '');
                        end;
                end;
                ChargeLine := ChargeLine + LineNo;
            until LoanChargePosted.Next() = 0;
            exit(ChargeLine)
        end;
    end;

    procedure PostDefinedCharge(RecRefNo: Code[100]; ChargeType: Enum ChargeType; AmountToDisburse: Decimal; AccountNo: Code[100]; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date; GenJLine: Integer; ExtDocNo: code[20]; SettFee: Decimal; DebitAcType: Enum "Gen. Journal Account Type"; LoanTransType: Enum "LoanTransactionType"; LoanNo: Code[100]): Integer
    var
        LoanChargePosted: Record "Loan Product Charges";
        ChargeAmt: array[9] of Decimal;
        LoansTopupPosted: Record "Loans Top up Posted";
    begin
        GenSetup.Get();
        ChargeAmt[1] := 0;
        LineNo := GenJLine;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Product Code", RecRefNo);
        LoanChargePosted.SetRange("Charge Type", ChargeType);
        if LoanChargePosted.FindFirst() then begin
            LoanChargePosted.TestField("Charges Account");

            ChargeAmt[1] := AmountToDisburse;

            LineNo := LineNo + 100000;
            JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo,
            DebitAcType, DocNo, LoanChargePosted."Charge Description",
            ChargeAmt[1], AccountNo, TransactionDate, AcctType::"G/L Account",
            LoanChargePosted."Charges Account", ExtDocNo, Dim1, Dim2, LoanTransType,
            LoanNo, '', '', DocType::" ", '', DocType::" ", '');

            case LoanChargePosted."Effect Excise Duty" of
                LoanChargePosted."Effect Excise Duty"::Yes:
                    begin
                        GenSetup.TestField("Excise Duty (%)");
                        GenSetup.TestField("Excise Duty G/L");

                        LineNo := LineNo + 100000;
                        JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo, AcctType::Vendor,
                        DocNo, LoanChargePosted."Charge Description",
                        Round((ChargeAmt[1] * (GenSetup."Excise Duty (%)" / 100)), 0.5, '='),
                        AccountNo, TransactionDate, AcctType::"G/L Account",
                        GenSetup."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::" ",
                        '', '', '', DocType::" ", '', DocType::" ", '');
                    end;
            end;
            exit(LineNo)
        end;
    end;

    procedure fnPostAlternateLoanCharge(RecRefNo: Code[100]; ChargeType: Enum ChargeType; AmountToDisburse: Decimal; AccountNo: Code[100]; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date; GenJLine: Integer; ExtDocNo: code[20]; SettFee: Decimal; DebitAcType: Enum "Gen. Journal Account Type"; LoanTransType: Enum "LoanTransactionType"; LoanNo: Code[100]): Integer
    var
        LoanChargePosted: Record "Loan Product Charges";
        ChargeAmt: array[9] of Decimal;
        LoansTopupPosted: Record "Loans Top up Posted";
    begin
        GenSetup.Get();
        ChargeAmt[1] := 0;
        LineNo := GenJLine;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Product Code", RecRefNo);
        LoanChargePosted.SetRange("Charge Type", ChargeType);
        if LoanChargePosted.FindFirst() then begin
            LoanChargePosted.TestField("Charges Account");

            case LoanChargePosted."Charge Method" of
                LoanChargePosted."Charge Method"::"Flat Amount":
                    begin
                        if LoanChargePosted."Charge Type" <> LoanChargePosted."Charge Type"::Prorate then
                            LoanChargePosted.TestField("Charge Amount");
                        if SettFee <> 0 then
                            ChargeAmt[1] := SettFee else
                            ChargeAmt[1] := LoanChargePosted."Charge Amount";

                    end;
                LoanChargePosted."Charge Method"::"% of Amount":
                    begin
                        LoanChargePosted.TestField(Percentage);
                        ChargeAmt[1] := (AmountToDisburse * (LoanChargePosted.Percentage / 100));

                    end;
                LoanChargePosted."Charge Method"::Staggered:
                    begin
                        LoanChargePosted.TestField("Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, LoanChargePosted."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (AmountToDisburse >= TariffDetails."Lower Limit") and (AmountToDisburse <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmt[1] := (AmountToDisburse * TariffDetails.Percentage * 0.01);
                                    end else begin
                                        ChargeAmt[1] := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;

                    end;
            end;

            LineNo := LineNo + 100000;
            JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo,
            DebitAcType, DocNo, LoanChargePosted."Charge Description",
            ChargeAmt[1], AccountNo, TransactionDate, AcctType::"G/L Account",
            LoanChargePosted."Charges Account", ExtDocNo, Dim1, Dim2, LoanTransType,
            LoanNo, '', '', DocType::" ", '', DocType::" ", '');

            case LoanChargePosted."Effect Excise Duty" of
                LoanChargePosted."Effect Excise Duty"::Yes:
                    begin
                        GenSetup.TestField("Excise Duty (%)");
                        GenSetup.TestField("Excise Duty G/L");

                        LineNo := LineNo + 100000;
                        JnlPostMngt.CreateJnl(JTemp, JBatch, LineNo, AcctType::Vendor,
                        DocNo, LoanChargePosted."Charge Description",
                        Round((ChargeAmt[1] * (GenSetup."Excise Duty (%)" / 100)), 0.5, '='),
                        AccountNo, TransactionDate, AcctType::"G/L Account",
                        GenSetup."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::" ",
                        '', '', '', DocType::" ", '', DocType::" ", '');
                    end;
            end;
            exit(LineNo)
        end;
    end;



    procedure fngetLastGenJlineNo(DocumentNo: Code[20]; JTemp: Code[10]; JBatchTemp: Code[10]): Integer
    var
        LineNo: Integer;
    begin
        GenJournalLine.SetCurrentKey("Line No.");
        GenJournalLine.Ascending(false);

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Document No.", DocumentNo);
        GenJournalLine.SetRange("Journal Template Name", JTemp);
        GenJournalLine.SetRange("Journal Batch Name", JBatchTemp);
        if GenJournalLine.FindLast() then begin
            LineNo := GenJournalLine."Line No.";
            exit(LineNo)
        end;
    end;

}
