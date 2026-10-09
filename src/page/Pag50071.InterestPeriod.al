namespace SaccoDatabase.SaccoDatabase;
using Microsoft.Foundation.Period;
using DynamicsNav.SaccoDatabase;

page 50071 "Interest Period"
{
    ApplicationArea = All;
    Caption = 'Interest Period';
    PageType = List;
   /*  Editable = false;
      DeleteAllowed = false;
      ModifyAllowed = false; */
      InsertAllowed = false; 
    SourceTable = "Loan Interest Periods";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Month"; Rec."Period Month")
                {
                    ToolTip = 'Specifies the value of the Period Month field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Period Year"; Rec."Period Year")
                {
                    ToolTip = 'Specifies the value of the Period Year field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the value of the Period Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Opened"; Rec."Date Opened")
                {
                    ToolTip = 'Specifies the value of the Date Opened field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    ToolTip = 'Specifies the value of the Date Closed field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("<Action1102760016>")
            {
                Caption = 'Create Period';
                Image = NewTimesheet;
                //RunObject = report "Create Fiscal Year- Interest";
                trigger OnAction()
                begin
                    currpage.close();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("<Action1102760016>_Promoted"; "<Action1102760016>")
                {
                }
            }
        }
    }
    var
        PrIntPeriods: Record "Loan Interest Periods";
        AccountPeriod: Report "Create Fiscal Year";
        strPeriodName: Text[250];
        Answer: Boolean;
        FiscalYear: Report "Create Fiscal Year";
        DocPostMngt: Codeunit "Doc-PostMgt";
        dtOpenPeriod: Date;
        Question: Text[250];
        PayrollPostMgt: Codeunit "Payroll Post Mngt.";
        MessageTxt: Label 'You have selected NOT to Close the period';
        OncompleteTxt: Label 'Process Complete';
        QuestionTxt2: Label 'A new Period will be opened.\It is assumed that you have no existing period was found.\';

        QuestionTxt: Label 'Once a period has been closed it can NOT be opened.\It is assumed that you have Created and Posted Interest.\';
}
