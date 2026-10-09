page 50840 "Loan Appraisal Score"
{
    PageType = List;
    SourceTable = "Loan Application Credit Score";
    SourceTableView = SORTING(Priority);
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                }
                field("Parameter Code"; Rec."Parameter Code")
                {
                    ApplicationArea = All;
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                }
                field("Calculated Success"; Rec."Calculated Success")
                {
                    ApplicationArea = All;
                }
                field("Calculated Failure"; Rec."Calculated Failure")
                {
                    ApplicationArea = All;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Qualifying Amount"; Rec."Qualifying Amount")
                {
                    ApplicationArea = All;
                }
                field(RequestTime; Rec.RequestTime)
                {
                    ApplicationArea = All;
                }
                field("General Output"; Rec."General Output")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




