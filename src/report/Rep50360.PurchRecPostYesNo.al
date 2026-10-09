report 50360 "Purch. Rec.-Post (Yes/No)"
{
    ApplicationArea = All;
    Caption = 'Purch. Rec.-Post (Yes/No)';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    UsageCategory = Administration;
    dataset
    {
        dataitem(RecoveryHeader; "Recovery Header")
        {
            DataItemTableView = where(Posted = const(false), "Application Source" = const(Automated), "Application Type" = filter("Recovery from Shares"));
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ApplicationType; "Application Type")
            {
            }
            column(ApplicationSource; "Application Source")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Codeunit.Run(Codeunit::"Purch. Recov.-Post (Yes/No)", RecoveryHeader)
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

}



