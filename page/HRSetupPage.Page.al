page 50121 "HR Setup Page"
{
    ApplicationArea = All;
    Caption = 'HR Setup Page';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "HR Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Visible=false;
                field("Employee Nos."; Rec."Employee Nos.")
                {
                    ToolTip = 'Specifies the value of the Employee Nos. field.';
                }
                field("Leave Application Nos."; Rec."Leave Application Nos.")
                {
                    ToolTip = 'Specifies the value of the Leave Application Nos. field.';
                }
                field("Job Interview Nos."; Rec."Job Interview Nos.")
                {
                    ToolTip = 'Specifies the value of the Job Interview Nos. field.';
                }
                field("Job ID Nos."; Rec."Job ID Nos.")
                {
                    ToolTip = 'Specifies the value of the Job ID Nos. field.';
                }
                field("Job Application Nos."; Rec."Job Application Nos.")
                {
                    ToolTip = 'Specifies the value of the Job Application Nos. field.';
                }
                field("Loan Application Nos."; Rec."Loan Application Nos.")
                {
                    ToolTip = 'Specifies the value of the Loan Application Nos. field.';
                }
                field("Loan Batch Nos."; Rec."Loan Batch Nos.")
                {
                    ToolTip = 'Specifies the value of the Loan Batch Nos. field.';
                }
                field("Hr Loan Nos."; Rec."Hr Loan Nos.")
                {
                    ToolTip = 'Specifies the value of the Hr Loan Nos. field.';
                }
                field("Appraisal Nos."; Rec."Appraisal Nos.")
                {
                    ToolTip = 'Specifies the value of the Appraisal Nos. field.';
                }
                field("Employee Requisition Nos."; Rec."Employee Requisition Nos.")
                {
                    ToolTip = 'Specifies the value of the Employee Requisition Nos. field.';
                }
                field("Disciplinary Cases Nos."; Rec."Disciplinary Cases Nos.")
                {
                    ToolTip = 'Specifies the value of the Disciplinary Cases Nos. field.';
                }
                field("Exit Interview Nos."; Rec."Exit Interview Nos.")
                {
                    ToolTip = 'Specifies the value of the Exit Interview Nos. field.';
                }
                field("Interns Req. Nos"; Rec."Interns Req. Nos")
                {
                    ToolTip = 'Specifies the value of the Interns Req. Nos field.';
                }
                field("Leave Reimbursement Nos."; Rec."Leave Reimbursement Nos.")
                {
                    ToolTip = 'Specifies the value of the Leave Reimbursement Nos. field.';
                }
                field("Notice Board Nos."; Rec."Notice Board Nos.")
                {
                    ToolTip = 'Specifies the value of the Notice Board Nos. field.';
                }
                field("Overtime Req Nos."; Rec."Overtime Req Nos.")
                {
                    ToolTip = 'Specifies the value of the Overtime Req Nos. field.';
                }
                field("Transaction Req Nos."; Rec."Transaction Req Nos.")
                {
                    ToolTip = 'Specifies the value of the Transaction Req Nos. field.';
                }
                field("Training Application Nos."; Rec."Training Application Nos.")
                {
                    ToolTip = 'Specifies the value of the Training Application Nos. field.';
                }
            }
            group("Batch & Templates")
            {
                field("Post NetPay to Fosa"; Rec."NetPay Post Options")
                {

                }
                field("Appraisal Batch"; Rec."Appraisal Batch")
                {
                    ToolTip = 'Specifies the value of the Appraisal Batch field.';
                }
                field("Appraisal Interval"; Rec."Appraisal Interval")
                {
                    ToolTip = 'Specifies the value of the Appraisal Interval field.';
                }
                field("Appraisal Method"; Rec."Appraisal Method")
                {
                    ToolTip = 'Specifies the value of the Appraisal Method field.';
                }
                field("Appraisal Post Period (Period)"; Rec."Appraisal Post Period (Period)")
                {
                    ToolTip = 'Specifies the value of the Appraisal Post Period (Period) field.';
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ToolTip = 'Specifies the value of the Appraisal Template field.';
                }
                field("Base Calender"; Rec."Base Calender")
                {
                    ToolTip = 'Specifies the value of the Base Calender field.';
                }
                field("Appraisal Post Period (To)"; Rec."Appraisal Post Period (To)")
                {
                    ToolTip = 'Specifies the value of the Appraisal Post Period (To) field.';
                }
                field("Default Leave Post Template"; Rec."Default Leave Post Template")
                {
                    ToolTip = 'Specifies the value of the Default Leave Post Template field.';
                }
                field("Leave Batch"; Rec."Leave Batch")
                {
                    ToolTip = 'Specifies the value of the Leave Batch field.';
                }
                field("Leave Template"; Rec."Leave Template")
                {
                    ToolTip = 'Specifies the value of the Leave Template field.';
                }
                field("Positive Leave Post Template"; Rec."Positive Leave Post Template")
                {
                    ToolTip = 'Specifies the value of the Positive Leave Post Template field.';
                }
                field("Negative Leave Post Batch"; Rec."Negative Leave Post Batch")
                {
                    ToolTip = 'Specifies the value of the Negative Leave Post Batch field.';
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
}
