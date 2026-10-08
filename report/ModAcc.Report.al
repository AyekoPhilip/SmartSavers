report 50117 "ModAcc"
{
    ApplicationArea = All;
    Caption = 'ModAcc';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = false;
    dataset
    {

        dataitem(RelationshipTypes; "Relationship Types")

        {

            trigger OnPreDataItem()
            var
                Temp: Record "Relationship Types";
            begin
                Temp.DeleteAll();

            end;

            trigger OnAfterGetRecord()
            begin

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
}



