report 50363 "Loan Reminders"
{
    ApplicationArea = All;
    Caption = 'Loan Reminders';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(LoansCategorization; "Loans Categorization")
        {
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingInsurance; "Outstanding Insurance")
            {
            }
            column(OutstandingBill; "Outstanding Bill")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(AmountInArrears; "Amount In Arrears")
            {
            }
            column(DaysinArrears; "Days in Arrears")
            {
            }
            column(Repayment; Repayment)
            {
            }

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");
                if "Product Type" <> 'MSACCOLN' then
                    CurrReport.Skip();
                MonthDue := 0;
                DayDue := 0;
                Month1 := 0;
                Day1 := 0;
                Month2 := 0;
                Day2 := 0;
                Month3 := 0;
                Day3 := 0;
                YearB := 0;
                ReminderMessage := '';
                PenaltyCharged := 0;
                LoanArrears := 0;

                if "Repayment Start Date" <> 0D then begin

                    DueDate := "Repayment Start Date";
                    DayDue := Date2DMY("Repayment Start Date", 1);
                    MonthDue := Date2DMY(Today, 2);

                    case MonthDue OF
                        4,
                        6,
                        9,
                        11:
                            begin
                                if DayDue > 30 then
                                    DayDue := 30 else
                                    DayDue := DayDue;
                            end;
                        2:
                            begin
                                if (DayDue > 28) or (DayDue > 29) then
                                    DayDue := 28 else
                                    DayDue := DayDue;
                            end;
                    end;

                    YearB := Date2DMY(Today, 3);
                    NextDueDate := DMY2Date(DayDue, MonthDue, Date2DMY(Today, 3));
                    ReminderDate[1] := CalcDate('-3D', NextDueDate);
                    ReminderDate[2] := NextDueDate;
                    ReminderDate[3] := CalcDate('1D', NextDueDate);

                    if ReminderDate[1] = Today then begin
                        ReminderMessage := 'Dear member,' + ', Your ' +
                        "Product Description" + ' Balance of KES' +
                        Format("Outstanding Balance") + ' will be due on' + Format(NextDueDate) +
                         'Please repay by dialling *605*5# or via the QC Wallet App. Delay in payment will attract penalty.';

                    end else
                        if ReminderDate[2] = Today then begin
                            ReminderMessage := 'Dear member,'+ ', Your ' +
                            "Product Description" + ' Balance of KES' +
                            Format("Outstanding Balance") + ' is due on' + Format(Today) +
                             'Please repay by dialling *605*5# or via the QC Wallet App. Delay in payment will attract penalty.';

                        end else

                            if ReminderDate[3] = Today then begin
                                ReminderMessage := 'Dear member'+ ', Your ' +
                                "Product Description" + ' Balance of KES' +
                                Format("Outstanding Balance") + ' is overdue' +' '+
                                 '.Pay by dialling *605*5# or via the QC Wallet App. Delay in payment will attract penalty.';
                            end;

                    case Today of
                        ReminderDate[1],
                        ReminderDate[2],
                        ReminderDate[3]:
                            begin
                                if CustRec.Get("Account No.") then begin
                                    SmsNotification.CreateSmsNotif(NotifSource::"Loan defaulted", CustRec."Mobile Phone No",
                              ReminderMessage, "No.", CustRec."No.", false);
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
                group(GroupName)
                {
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
        ReminderMessage: Text[250];
        iEntryNo: Integer;
        DueDate: Date;
        MonthDue: Integer;
        DayDue: Integer;
        Month1: Integer;
        Day1: Integer;
        ReminderDate: array[4] of Date;
        ReminderDate1: Date;
        ReminderDate2: Date;
        ReminderDate3: Date;
        Month2: Integer;
        Day2: Integer;
        Month3: Integer;
        Day3: Integer;
        NextDueDate: Date;
        YearB: Integer;
        CustRec: Record Member;
        ReminderDate4: Date;
        PenaltyCharged: Decimal;
        LoanArrears: Decimal;
        SmsNotification: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
}



