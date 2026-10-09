report 50187 "Post Standing Order"
{
    ApplicationArea = All;
    Caption = 'Post Standing Order';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(StandingOrderHeader; "Standing Order Header")
        {

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if StandingOrderHeader."Next Run Date" <= Today then begin
                    BnkMngt.PerformPostOnStandingOrder(StandingOrderHeader."Income Type"::Periodic, StandingOrderHeader."No.", 1);
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
        BnkMngt: Codeunit "Banking Procedure Mngt.";
}



