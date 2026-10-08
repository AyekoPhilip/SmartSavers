namespace DynamicsNav.SaccoDatabase.PayrollMgt;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.Company;
using DynamicsNav.SaccoDatabase.HrManagementMgt;

report 50008 "Pr Transfer To Journal"
{
    ApplicationArea = All;
    Caption = 'Payroll Transfer To Journal';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(PrSalaryCard; "Pr Salary Card")
        {
            RequestFilterFields = "Employee Code", "Period Filter";
            column(EmployeeCode; "Employee Code")
            {
            }
            column(EmpName; "Emp Name")
            {
            }
            column(PostingGroup; "Posting Group")
            {
            }
            column(Period_Filter; "Period Filter")
            {

            }
            trigger OnPreDataItem()
            begin
                PostingType := PostingType::Allocated;

                InitJournalTemplate();
                SlipReceiptNo := objPeriod."Period Name" + '-' + Format(Date2DMY(objPeriod."Date Opened", 3));
                case PostingType of
                    PostingType::Consolidated:
                        begin
                            PrPostPayrllMgt.fnconsolidatePayrollPostMgt(SelectedPeriod);
                            postConsolidatedPayrollMgt();
                        end;
                end
            end;

            trigger OnAfterGetRecord()
            begin

                /*  objEmp.Reset();
                 objEmp.SetRange("No.", "Employee Code");
                 objEmp.SetRange(Status, objEmp.Status::Active);
                 if objEmp.FindFirst() then begin

                     objEmp.TestField("Posting Group");
                     getEmployeePostingAc(objEmp."Posting Group");
                     Linenum := Linenum + 1000;

                     case PostingType of
                         PostingType::Allocated:
                             begin

                                 PeriodTrans.Reset();
                                 PeriodTrans.SetRange("Employee Code", "Employee Code");
                                 PeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                                 PeriodTrans.SetFilter("Account No.", '<>%1', '');
                                 if PeriodTrans.FindSet() then begin
                                     repeat

                                         AmountToCredit := 0;
                                         AmountToDebit := 0;

                                         case PeriodTrans."Post As" of
                                             PeriodTrans."Post As"::Credit:

                                                 begin
                                                     AmountToCredit := PeriodTrans.Amount * -1
                                                 end;
                                             PeriodTrans."Post As"::Debit:
                                                 begin
                                                     AmountToCredit := PeriodTrans.Amount
                                                 end;
                                         end;

                                         case PeriodTrans."Account Type" of
                                             PeriodTrans."Account Type"::Customer,
                                                                 PeriodTrans."Account Type"::Vendor,
                                                                     PeriodTrans."Account Type"::"G/L Account":
                                                 begin

                                                     Linenum := Linenum + 1000;
                                                     PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                     PeriodTrans."Payroll Period", PeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                                                     Dim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Employee Code", 0, AmountToCredit,
                                                     PeriodTrans."Post As", PeriodTrans."Loan No.", Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                     Linenum);

                                                 end;
                                             PeriodTrans."Account Type"::Saving:
                                                 begin
                                                     Linenum := Linenum + 1000;
                                                     PrPostPayrllMgt.CreateJnlEntries(Enum::"Gen. Journal Account Type"::Vendor, SlipReceiptNo,
                                                     PeriodTrans."Payroll Period", PeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                                                     Dim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Employee Code", 0, AmountToCredit,
                                                     PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code", Linenum);
                                                 end;
                                             PeriodTrans."Account Type"::Credit,
                                         PeriodTrans."Account Type"::Loan:
                                                 begin
                                                     Linenum := Linenum + 1000;
                                                     PrPostPayrllMgt.CreateJnlEntries(Enum::"Gen. Journal Account Type"::Customer, SlipReceiptNo,
                                                     PeriodTrans."Payroll Period", PeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                                                     Dim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Employee Code", 0, AmountToCredit,
                                                     PeriodTrans."Post As", PeriodTrans."Loan No.", PeriodTrans."Loan Transaction Type", PeriodTrans."Employee Code", Linenum);
                                                 end;
                                         end;

                                         if PeriodTrans."Coop Parameters" = PeriodTrans."Coop Parameters"::Pension then begin

                                             //Credit Payables
                                             Linenum := Linenum + 1000;
                                             PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                 PeriodTrans."Payroll Period", PostingGroup."Pension Employee A/c", Jtemplate, JBatch, Dim1,
                                                                 Dim2, PeriodTrans."Transaction Name" + PeriodTrans."Employee Code", 0, AmountToCredit * -1,
                                                                 PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                 Linenum);

                                             // Debit Staff Expense
                                             Linenum := Linenum + 1000;
                                             PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                 PeriodTrans."Payroll Period", PostingGroup."Pension Employer A/c", Jtemplate, JBatch, Dim1,
                                                                 Dim2, PeriodTrans."Transaction Name" + PeriodTrans."Employee Code", 0, AmountToCredit,
                                                                 PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                 Linenum);
                                         end;

                                         EmployerDed.Reset();
                                         EmployerDed.SetRange("Employee Code", PeriodTrans."Employee Code");
                                         EmployerDed.SetRange("Transaction Code", PeriodTrans."Transaction Code");
                                         EmployerDed.SetRange("Payroll Period", PeriodTrans."Payroll Period");
                                         if EmployerDed.FindSet() then begin

                                             if PeriodTrans."Coop Parameters" = PeriodTrans."Coop Parameters"::NSSF then begin
                                                 //Credit Payables
                                                 Linenum := Linenum + 1000;
                                                 PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                     PeriodTrans."Payroll Period", PostingGroup."SSF Employee Account", Jtemplate, JBatch, Dim1,
                                                                     Dim2, PeriodTrans."Transaction Name" + PeriodTrans."Employee Code", 0, PeriodTrans.Amount * -1,
                                                                     PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                     Linenum);
                                                 //Credit Payables

                                                 // Debit Staff Expense
                                                 Linenum := Linenum + 1000;
                                                 PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                     PeriodTrans."Payroll Period", PostingGroup."SSF Employer Account", Jtemplate, JBatch, Dim1,
                                                                     Dim2, PeriodTrans."Transaction Name" + PeriodTrans."Employee Code", 0, PeriodTrans.Amount,
                                                                     PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                     Linenum);
                                             end;

                                             if PeriodTrans."Coop Parameters" = PeriodTrans."Coop Parameters"::"House Levy" then begin
                                                 //Credit Payables
                                                 Linenum := Linenum + 1000;
                                                 PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                     PeriodTrans."Payroll Period", PostingGroup."House Levy Employee A/c", Jtemplate, JBatch, Dim1,
                                                                     Dim2, PeriodTrans."Transaction Name" + PeriodTrans."Employee Code", 0, PeriodTrans.Amount * -1,
                                                                     PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                     Linenum);
                                                 // Debit Staff Expense
                                                 Linenum := Linenum + 1000;
                                                 PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                     PeriodTrans."Payroll Period", PostingGroup."House Levy Employer A/c", Jtemplate, JBatch, Dim1,
                                                                     Dim2, PeriodTrans."Transaction Name" + PeriodTrans."Employee Code", 0, PeriodTrans.Amount,
                                                                     PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                     Linenum);
                                             end;
                                         end;

                                     until PeriodTrans.Next() = 0
                                 end;
                             end;
                         PostingType::" ":
                             Error('Case condition %1 not implemented.', PostingType::" ");
                     end 
                 end;*/

                 objEmp.Reset();
                objEmp.SetRange("No.", "Employee Code");
                objEmp.SetRange(Status, objEmp.Status::Active);
                if objEmp.FindFirst() then begin

                    objEmp.TestField("Posting Group");
                    getEmployeePostingAc(objEmp."Posting Group");
                    Linenum := Linenum + 1000;

                    case PostingType of
                        PostingType::Allocated:
                            begin

                                PeriodTrans.Reset();
                                PeriodTrans.SetRange("Employee Code", "Employee Code");
                                PeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                                PeriodTrans.SetFilter("Account No.", '<>%1', '');
                                if PeriodTrans.FindSet() then begin
                                    repeat

                                        AmountToCredit := 0;
                                        AmountToDebit := 0;

                                        case PeriodTrans."Post As" of
                                            PeriodTrans."Post As"::Credit:

                                                begin
                                                    AmountToCredit := PeriodTrans.Amount * -1
                                                end;
                                            PeriodTrans."Post As"::Debit:
                                                begin
                                                    AmountToCredit := PeriodTrans.Amount
                                                end;
                                        end;

                                        case PeriodTrans."Account Type" of
                                            PeriodTrans."Account Type"::Customer,
                                                                PeriodTrans."Account Type"::Vendor,
                                                                    PeriodTrans."Account Type"::"G/L Account":
                                                begin

                                                    Linenum := Linenum + 1000;
                                                    PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                    PeriodTrans."Payroll Period", PeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                                                    Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, AmountToCredit,
                                                    PeriodTrans."Post As", PeriodTrans."Loan No.", Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                    Linenum);

                                                end;
                                            PeriodTrans."Account Type"::Saving:
                                                begin
                                                    Linenum := Linenum + 1000;
                                                    PrPostPayrllMgt.CreateJnlEntries(Enum::"Gen. Journal Account Type"::Vendor, SlipReceiptNo,
                                                    PeriodTrans."Payroll Period", PeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                                                    Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, AmountToCredit,
                                                    PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code", Linenum);
                                                end;
                                        PeriodTrans."Account Type"::Credit,
                                        PeriodTrans."Account Type"::Loan:
                                                begin
                                                    Linenum := Linenum + 1000;
                                                    PrPostPayrllMgt.CreateJnlEntries(Enum::"Gen. Journal Account Type"::Customer,
                                                    SlipReceiptNo,
                                                    PeriodTrans."Payroll Period", PeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                                                    Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0,
                                                    AmountToCredit,
                                                    PeriodTrans."Post As", PeriodTrans."Loan No.", PeriodTrans."Loan Transaction Type",
                                                    PeriodTrans."Employee Code", Linenum);
                                                end;
                                        end;

                                        case PeriodTrans."Coop Parameters" of
                                            PeriodTrans."Coop Parameters"::Pension:
                                                begin

                                                    EmployerDed.Reset();
                                                    EmployerDed.SetRange("Employee Code", PeriodTrans."Employee Code");
                                                    EmployerDed.SetRange("Transaction Code", PeriodTrans."Transaction Code");
                                                    EmployerDed.SetRange("Payroll Period", PeriodTrans."Payroll Period");
                                                    if EmployerDed.FindSet() then begin

                                                    //Credit Payables
                                                  Linenum := Linenum + 1000;
                                                    PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                        PeriodTrans."Payroll Period", PostingGroup."Pension Employee A/c", Jtemplate, JBatch, Dim1,
                                                                        Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, EmployerDed.Amount * -1,
                                                                        PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                        Linenum);

                                                    // Debit Staff Expense
                                                    Linenum := Linenum + 1000;
                                                    PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                        PeriodTrans."Payroll Period", PostingGroup."Pension Employer A/c", Jtemplate, JBatch, Dim1,
                                                                        Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, EmployerDed.Amount,
                                                                        PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                        Linenum); 
                                                    end;
                                                end;
                                            PeriodTrans."Coop Parameters"::NSSF:
                                                begin

                                                    EmployerDed.Reset();
                                                    EmployerDed.SetRange("Employee Code", PeriodTrans."Employee Code");
                                                    EmployerDed.SetRange("Transaction Code", PeriodTrans."Transaction Code");
                                                    EmployerDed.SetRange("Payroll Period", PeriodTrans."Payroll Period");
                                                    if EmployerDed.FindSet() then begin

                                                        //Credit Payables
                                                        Linenum := Linenum + 1000;
                                                        PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                            PeriodTrans."Payroll Period", PostingGroup."SSF Employee Account", Jtemplate, JBatch, Dim1,
                                                                            Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, PeriodTrans.Amount * -1,
                                                                            PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                            Linenum);
                                                        //Credit Payables
                                                        // Debit Staff Expense
                                                        Linenum := Linenum + 1000;
                                                        PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                            PeriodTrans."Payroll Period", PostingGroup."SSF Employer Account", Jtemplate, JBatch, Dim1,
                                                                            Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, PeriodTrans.Amount,
                                                                            PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                            Linenum);
                                                    end;
                                                end;
                                            PeriodTrans."Coop Parameters"::"House Levy":
                                                begin
                                                    //Credit Payables
                                                    Linenum := Linenum + 1000;
                                                    PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                        PeriodTrans."Payroll Period", PostingGroup."House Levy Employee A/c", Jtemplate, JBatch, Dim1,
                                                                        Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, PeriodTrans.Amount * -1,
                                                                        PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                        Linenum);
                                                    // Debit Staff Expense
                                                    Linenum := Linenum + 1000;
                                                    PrPostPayrllMgt.CreateJnlEntries(PeriodTrans."Account Type", SlipReceiptNo,
                                                                        PeriodTrans."Payroll Period", PostingGroup."House Levy Employer A/c", Jtemplate, JBatch, Dim1,
                                                                        Dim2, PeriodTrans."Transaction Name" + ' - ' + PeriodTrans."Employee Code", 0, PeriodTrans.Amount,
                                                                        PeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PeriodTrans."Employee Code",
                                                                        Linenum);
                                                end;
                                        end;

                                    until PeriodTrans.Next() = 0
                                end;
                            end;
                        PostingType::" ":
                        Error('Case condition %1 not implemented.', PostingType::" ");
                    end
                end;
            end;

            trigger OnPostDataItem()
            begin

                PrPostPayrllMgt.fnJournalPreviewMngt(Enum::CustomApprovalEntriesDocType::Salary,
                SlipReceiptNo, Jtemplate, JBatch, SelectedPeriod, Enum::BCObjectTypes::Page);

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(PostingType; PostingType)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Type';
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
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin

        PeriodFilter := PrSalaryCard.GetFilter("Period Filter");
        SelectedPeriod := PrSalaryCard.GetRangeMin("Period Filter");

        objPeriod.Reset();
        if objPeriod.Get(SelectedPeriod) then PeriodName := objPeriod."Period Name";
        PostingDate := CalcDate('1M-1D', SelectedPeriod);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);

    end;

    trigger OnPostReport()
    begin

    end;

    local procedure InitJournalTemplate()
    begin

        Temp.Get(UserId);
        Temp.TestField("Pr Salary Journal Template");
        Temp.TestField("Pr Salary Journal Batch");
        Jtemplate := Temp."Pr Salary Journal Template";
        JBatch := Temp."Pr Salary Journal Batch";

        JnlPost.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        case PostingType of
            PostingType::Consolidated:
                begin
                    PrPeriodConsd.SetRange("Payroll Period", SelectedPeriod);
                    PrPeriodConsd.DeleteAll();
                end;
        end;
    end;

    local procedure getEmployeePostingAc(PostingGrp: Code[20])
    begin
        PostingGroup.Get(PostingGrp);
        PostingGroup.TestField("SSF Employer Account");
        PostingGroup.TestField("SSF Employee Account");
        PostingGroup.TestField("Pension Employee A/c");
        PostingGroup.TestField("Pension Employer A/c");
    end;

    local procedure postConsolidatedPayrollMgt()
    begin
        getEmployeePostingAc('PAYROLL');

        PrPeriodTrans.Reset();
        PrPeriodTrans.SetRange("Payroll Period", SelectedPeriod);
        PrPeriodTrans.SetFilter("Account No.", '<>%1', '');
        if PrPeriodTrans.FindSet() then begin
            repeat
                AmountToCredit := 0;
                AmountToDebit := 0;

                case PrPeriodTrans."Post As" of
                    PrPeriodTrans."Post As"::Credit:
                        begin
                            AmountToCredit := PrPeriodTrans.Amount * -1
                        end;
                    PrPeriodTrans."Post As"::Debit:
                        begin
                            AmountToCredit := PrPeriodTrans.Amount
                        end;
                end;

                case PrPeriodTrans."Account Type" of

                    PrPeriodTrans."Account Type"::Vendor,
                        PrPeriodTrans."Account Type"::"G/L Account":
                        begin

                            Linenum := Linenum + 1000;
                            PrPostPayrllMgt.CreateJnlEntries(PrPeriodTrans."Account Type", SlipReceiptNo,
                            PrPeriodTrans."Payroll Period", PrPeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                            Dim2, PrPeriodTrans."Transaction Name" + '-' + Format(SelectedPeriod), 0, AmountToCredit,
                            PrPeriodTrans."Post As", PrPeriodTrans."Loan No.", Enum::"LoanTransactionType"::" ", PrPeriodTrans."Transaction Code",
                            Linenum);

                        end;

                    PrPeriodTrans."Account Type"::Customer:
                        begin
                            case PrPeriodTrans."Account Dimension" of
                                PrPeriodTrans."Account Dimension"::" ",
                                PrPeriodTrans."Account Dimension"::Loan,
                                PrPeriodTrans."Account Dimension"::"Micro Credit",
                            PrPeriodTrans."Account Dimension"::Credit:
                                    begin

                                        Linenum := Linenum + 1000;
                                        PrPostPayrllMgt.CreateJnlEntries(PrPeriodTrans."Account Type", SlipReceiptNo,
                                        PrPeriodTrans."Payroll Period", PrPeriodTrans."Account No.", Jtemplate, JBatch, Dim1,
                                        Dim2, PrPeriodTrans."Transaction Name" + '-' + Format(SelectedPeriod), 0, AmountToCredit,
                                        PrPeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PrPeriodTrans."Transaction Code", Linenum);

                                    end;

                                PrPeriodTrans."Account Dimension"::Banking:
                                    Error('Case condition %1 not implemented.', PrPeriodTrans."Account Dimension"::Banking);
                                PrPeriodTrans."Account Dimension"::Repayment:
                                    Error('Case condition %1 not implemented.', PrPeriodTrans."Account Dimension"::Repayment);
                            end;

                        end;
                    PrPeriodTrans."Account Type"::"Bank Account":
                        Error('Case condition %1 not implemented.', PrPeriodTrans."Account Type"::"Bank Account");
                    PrPeriodTrans."Account Type"::"Fixed Asset":
                        Error('Case condition %1 not implemented.', PrPeriodTrans."Account Type"::"Fixed Asset");
                    PrPeriodTrans."Account Type"::"IC Partner":
                        Error('Case condition %1 not implemented.', PrPeriodTrans."Account Type"::"IC Partner");
                    PrPeriodTrans."Account Type"::Employee:
                        Error('Case condition %1 not implemented.', PrPeriodTrans."Account Type"::Employee);
                    PrPeriodTrans."Account Type"::"Allocation Account":
                        Error('Case condition %1 not implemented.', PrPeriodTrans."Account Type"::"Allocation Account");
                end;

                case PrPeriodTrans."Coop Parameters" of
                    PrPeriodTrans."Coop Parameters"::Pension:
                        begin

                            EmployerDed.Reset();
                            EmployerDed.SetRange("Transaction Code", PrPeriodTrans."Transaction Code");
                            EmployerDed.SetRange("Payroll Period", PrPeriodTrans."Payroll Period");
                            if EmployerDed.FindSet() then begin
                                EmployerDed.CalcSums(Amount);
                                //Credit Payables
                                Linenum := Linenum + 1000;
                                PrPostPayrllMgt.CreateJnlEntries(PrPeriodTrans."Account Type", SlipReceiptNo,
                                                    PrPeriodTrans."Payroll Period", PostingGroup."Pension Employee A/c", Jtemplate, JBatch, Dim1,
                                                    Dim2, PrPeriodTrans."Transaction Name" + '-' + Format(SelectedPeriod), 0, EmployerDed.Amount * -1,
                                                    PrPeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PrPeriodTrans."Transaction Code",
                                                    Linenum);
                                // Debit Staff Expense
                                Linenum := Linenum + 1000;
                                PrPostPayrllMgt.CreateJnlEntries(PrPeriodTrans."Account Type", SlipReceiptNo,
                                                    PrPeriodTrans."Payroll Period", PostingGroup."Pension Employer A/c", Jtemplate, JBatch, Dim1,
                                                    Dim2, PrPeriodTrans."Transaction Name" + '-' + Format(SelectedPeriod), 0, EmployerDed.Amount,
                                                    PrPeriodTrans."Post As", '', Enum::"LoanTransactionType"::" ", PrPeriodTrans."Transaction Code",
                                                    Linenum);
                            end;
                        end;
                end;
            until PrPeriodTrans.Next() = 0
        end;
    end;

    var

        GenJournalLine: Record "Gen. Journal Line";
        PrPostPayrllMgt: Codeunit "Payroll Post Mngt.";
        Temp: Record "Banking User Template";
        ObjtEmp: Record "HR Employees";
        PLoans: Record Loans;
        SaccoTransactionType: Option;

        OutInterest: Decimal;
        OutInsurance: Decimal;
        LRepayment: Decimal;
        OutBills: Decimal;
        RunBal: Decimal;
        PostingType: Option " ",Consolidated,Allocated;
        JnlPost: Codeunit "Journal Post Mngt.";
        PeriodTrans: Record "Pr Period Transaction";
        NssfAmount: Decimal;
        TotNssfAmount: Decimal;
        objEmp: Record "HR Employees";
        EmployeeName: Text[30];
        NssfNo: Text[30];
        IDNumber: Text[30];
        objPeriod: Record "Pr Payroll Period";
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        TotalAmount: Decimal;
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        Linenum: Integer;
        totTotalAmount: Decimal;
        CompanyInfo: Record "Company Information";
        EmployerNSSFNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        DocumentNo: Code[100];
        NHIfAmount: Decimal;
        totNHIFTotalAmount: Decimal;
        PAYEAmount: Decimal;
        totPAYETotalAmount: Decimal;
        PensionAmount: Decimal;
        totPensionTotalAmount: Decimal;
        totHelbTotalAmount: Decimal;
        HelbAmount: Decimal;
        totGratTotalAmount: Decimal;
        GratAmount: Decimal;
        totSaccoTotalAmount: Decimal;
        SaccoAmount: Decimal;
        Pension: Decimal;
        NssfAmountemployer: Decimal;
        TotalNssfAmountemployer: Decimal;
        totTotalNssfAmountemployer: Decimal;
        NssfAmountemployee: Decimal;
        TotalNssfAmountemployee: Decimal;
        totTotalNssfAmountemployee: Decimal;
        GeneraljnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        prsalrycard: Record "Pr Salary Card";
        amount: Decimal;
        TotalamountGrat: Decimal;
        NetPay: Decimal;
        csrcontribution: Decimal;
        CarLoanInt: Decimal;
        Staffloanint: Decimal;
        prEmployee: Record "Pr Employee Transaction";
        TotalAmountarrears: Decimal;
        GratAmountarrears: Decimal;
        toGrossAmount: Decimal;
        SlipReceiptNo: Code[50];
        PostingGroup: Record "Pr Employee Posting Group";
        strEmpName: Text[150];
        AmountToDebit: Decimal;
        AmountToCredit: Decimal;
        IntegerPostAs: Integer;
        //SaccoTransactionType: Option
        PostingDate: Date;
        GlobalDim1: Code[20];
        GlobalDim2: Code[20];
        EmployerDed: Record "Pr Employer Deduction";
        TransCode: Record "Pr Period Transaction";
        LineNumber: Integer;
        MyDialog: Dialog;
        MyNext: Integer;
        PrPeriodTrans: Record "Pr Period Transaction- Consd.";
        PrPeriodConsd: Record "Pr Period Transaction- Consd.";

}