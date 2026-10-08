page 50917 "Interest Due Periods"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Interest Due Period";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interest Due Date"; Rec."Interest Due Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("New Fiscal Year"; Rec."New Fiscal Year")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }
                field("Date Locked"; Rec."Date Locked")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Closed by User"; Rec."Closed by User")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Closing Date Time"; Rec."Closing Date Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                }
                field("No of Days"; Rec."No of Days")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            separator(Action15)
            {
            }
            action("Create Period")
            {
                Image = AccountingPeriods;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    REPORT.Run(52140799)
                    //CreateInterestDuePeriod.CreateItDuePeriods(Rec);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Create Period_Promoted"; "Create Period")
                {
                }
            }
        }
    }
}




