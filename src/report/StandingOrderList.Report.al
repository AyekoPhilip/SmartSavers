report 50291 "Standing Order List"
{
    ApplicationArea = All;
    Caption = 'Standing Order List';
    UsageCategory = Lists;
    DefaultLayout = RDLC;

    RDLCLayout = './src/report_layout/Standing Order Sumarry.rdl';

    dataset
    {
        dataitem(StandingOrderHeader; "Standing Order Header")
        {
            column(No; "No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(IDNumber; "ID Number")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(AllocatedAmount; "Allocated Amount")
            {
            }
            column(AllowPartialDeduction; "Allow Partial Deduction")
            {
            }
            column(Amount; Amount)
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(AutoProcess; "Auto Process")
            {
            }
            column(Balance; Balance)
            {
            }
            column(BankAccountNo; "Bank Account No.")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(BranchCode; "Branch Code")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(DateReset; "Date Reset")
            {
            }
            column(Description; Description)
            {
            }
            column(DurationMonths; "Duration (Months)")
            {
            }
            column(Effected; Effected)
            {
            }
            column(EffectiveStartDate; "Effective/Start Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(FrequencyMonths; "Frequency (Months)")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(IncomeType; "Income Type")
            {
            }
            column(Invalid; Invalid)
            {
            }
            column(NextRunDate; "Next Run Date")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(Priority; Priority)
            {
            }
            column(ResponsibilityCentre; "Responsibility Centre")
            {
            }
            column(SourceAccountName; "Source Account Name")
            {
            }
            column(SourceAccountNo; "Source Account No.")
            {
            }
            column(SourceAccountType; "Source Account Type")
            {
            }
            column(StandingOrderType; "Standing Order Type")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TransactionBranch; "Transaction Branch")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(TransferedtoEFT; "Transfered to EFT")
            {
            }
            column(Type; "Type")
            {
            }
            column(Unrecovered; Unrecovered)
            {
            }
            column(Unsuccessfull; Unsuccessfull)
            {
            }
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



