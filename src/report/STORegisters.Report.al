report 50348 "STO Registers"
{
    ApplicationArea = All;
    Caption = 'STO Registers';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/STORegister1.rdl';
    dataset
    {
        dataitem(StandingOrderRegister; "Standing Order Register")
        {
            column(AllowPartialDeduction; "Allow Partial Deduction")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AmountDeducted; "Amount Deducted")
            {
            }
            column(DateProcessed; "Date Processed")
            {
            }
            column(DeductionStatus; "Deduction Status")
            {
            }
            column(DestinationAccountType; "Destination Account Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Duration; "Duration")
            {
            }
            column(EFT; EFT)
            {
            }
            column(EffectiveStartDate; "Effective/Start Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(ErrorLog; "Error Log")
            {
            }
            column(Frequency; Frequency)
            {
            }
            column(MemberNo; "Member No")
            {
            }
            column(No; "No.")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(SourceAccountName; "Source Account Name")
            {
            }
            column(SourceAccountNo; "Source Account No.")
            {
            }
            column(StaffPayrollNo; "Staff/Payroll No.")
            {
            }
            column(StandingOrderNo; "Standing Order No.")
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(TransferedtoEFT; "Transfered to EFT")
            {
            }
            trigger OnAfterGetRecord()
            begin
                "Amount Deducted":=Abs("Amount Deducted")
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
}



