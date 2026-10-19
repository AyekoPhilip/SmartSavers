page 50887 "Checkoff Advice"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Checkoff Advice Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                }
                field("Advice Header No."; Rec."Advice Header No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = All;
                }
                field("Amount On"; Rec."Amount On")
                {
                    ApplicationArea = All;
                }
                field("Amount Off"; Rec."Amount Off")
                {
                    ApplicationArea = All;
                }
                field("Balance On"; Rec."Balance On")
                {
                    ApplicationArea = All;
                }
                field("Balance Off"; Rec."Balance Off")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Advice Date"; Rec."Advice Date")
                {
                    ApplicationArea = All;
                }
                field("Interest On"; Rec."Interest On")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payroll No"; Rec."Payroll No")
                {
                    ApplicationArea = All;
                }
                field("Advice Type"; Rec."Advice Type")
                {
                    ApplicationArea = All;
                }
                field("Employer Account No."; Rec."Employer Account No.")
                {
                    ApplicationArea = All;
                }
                field("Product Search Code"; Rec."Product Search Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    /*  actions
     {
         area(creation)
         {
             action("Export New Loans")
             {
                 Image = Export;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 //RunObject = XMLport XMLport52140645;
                 Visible = false;
             }
             action("Export Stoppages")
             {
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 //RunObject = XMLport XMLport52140645;
                 Visible = false;
             }
             action("Export Adjustments")
             {
                 Image = AlternativeAddress;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 //RunObject = XMLport XMLport52140645;
                 Visible = false;
             }
             action("Generate Advice")
             {
                 Image = CreateLinesFromJob;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 Visible = false;

                 trigger OnAction()
                 begin
                     //PeriodicActivities.MonthlyCheckoffAdvice();
                 end;
             }
         }
     } */
}




