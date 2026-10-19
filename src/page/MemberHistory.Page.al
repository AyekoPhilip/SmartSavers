page 51076 "Member History"
{
    ApplicationArea = All;
    Caption = 'Member History';
    PageType = CardPart;
    SourceTable = "Member History";

    layout
    {
        area(content)
        {
            group(General)
            {

                ShowCaption = false;
                Visible = false;

            }
            cuegroup(Control2)
            {
                ShowCaption = false;
                field("No. of Active Loans"; Rec."No. of Active Loans")
                {
                    DrillDownPageID = "Loans Lookup Page";
                    ToolTip = 'Specifies the value of the No. of Active Loans field.';
                }
                field("No. of Closed A/c"; Rec."No. of Closed A/c")
                {
                    DrillDownPageID = "Loans Lookup Page";
                    ToolTip = 'Specifies the value of the No. of Closed A/c field.';
                }
                field("No. of Application"; Rec."No. of Application")
                {
                    DrillDownPageID = "Loans Lookup Page";
                    ToolTip = 'Specifies the value of the No. of Application field.';
                }
                field("Pending Payments"; Rec."Pending Payments")
                {
                    DrillDownPageID = "Loans Lookup Page";
                    ToolTip = 'Specifies the value of the Pending Payments field.';
                }

            }
        }
    }
}
