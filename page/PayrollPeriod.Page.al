page 50111 "Payroll Period"
{
    ApplicationArea = All;
    Caption = 'Payroll Period';
    PageType = List;
    Editable = TRUE;
    DeleteAllowed = true;
    ModifyAllowed = TRUE;
    InsertAllowed = TRUE;
    SourceTable = "Pr Payroll Period";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Month"; Rec."Period Month")
                {
                    ToolTip = 'Specifies the value of the Period Month field.';
                }
                field("Period Year"; Rec."Period Year")
                {
                    ToolTip = 'Specifies the value of the Period Year field.';
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the value of the Period Name field.';
                }
                field("Date Opened"; Rec."Date Opened")
                {
                    ToolTip = 'Specifies the value of the Date Opened field.';
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
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
                Caption = 'Close Period';
                Image = ClosePeriod;
                trigger OnAction()
                begin

                    fnGetOpenPeriod();
                    Question := QuestionTxt + ' Do still want to close [' + strPeriodName + ']';
                    Answer := Dialog.Confirm(Question, false);
                    if Answer then begin
                        PayrollPostMgt.fnClosePayrollPeriod(fnGetOpenPeriod(), '');
                        Message(OncompleteTxt);
                    end else begin
                        Message(MessageTxt);
                    end;

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

    procedure fnGetOpenPeriod(): Date
    begin
        PayPeriod.SetRange(Closed, false);
        if PayPeriod.FindFirst() then begin
            strPeriodName := PayPeriod."Period Name";
            dtOpenPeriod := PayPeriod."Date Opened";
            exit(dtOpenPeriod)
        end else begin
            
            dtOpenPeriod := CalcDate('-1M', Today);
            strPeriodName := Format(dtOpenPeriod, 0, '<Month Text>')
        end;
    end;

    var
        PayPeriod: Record "Pr Payroll Period";
        strPeriodName: Text[250];
        Answer: Boolean;
        dtOpenPeriod: Date;
        Question: Text[250];
        PayrollPostMgt: Codeunit "Payroll Post Mngt.";
        MessageTxt: Label 'You have selected NOT to Close the period';
        OncompleteTxt: Label 'Process Complete';
        QuestionTxt: Label 'Once a period has been closed it can NOT be opened.\It is assumed that you have PAID out salaries.\';

}
