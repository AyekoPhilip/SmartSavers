namespace SaccoDatabase.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;

page 50140 "Hr Leave Application"
{
    ApplicationArea = All;
    Caption = 'Leave Application';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "Hr Leave Mgt.";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;

                field("Applicant Staff No.";
                Rec."Applicant Staff No.")
                {
                    ToolTip = 'Specifies the value of the Staff No. field.', Comment = '%';
                Style = StandardAccent;
                StyleExpr = true;
            }
            field(Name; Rec.Name)
            {
                ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                Style = StandardAccent;
                StyleExpr = true;
            }
            field("Job Title"; Rec."Job Title")
            {
                ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                Style = StandardAccent;
                StyleExpr = true;
            }
            field(Gender; Rec.Gender)
            {
                ToolTip = 'Specifies the value of the Gender field.', Comment = '%';
                Style = StandardAccent;
                StyleExpr = true;
                Editable=false;
            }
            field("Alternative CellPhone No."; Rec."Alternative CellPhone No.")
            {
                ToolTip = 'Specifies the value of the Alternative CellPhone No. field.', Comment = '%';
                Style = StandardAccent;
                Editable=false;
                StyleExpr = true;
            }
            field("Applicant Comment"; Rec."Applicant Comment")
            {
                ToolTip = 'Specifies the value of the Applicant Comment field.', Comment = '%';
                Style = StandardAccent;
                StyleExpr = true;
            }
        }
            group("Leave Calculation")
            {
                Editable=Rec."Approval Status"=Rec."Approval Status"::Open;
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ToolTip = 'Specifies the value of the Days Applied field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Return Date"; Rec."Return Date")
                {
                    ToolTip = 'Specifies the value of the Return Date field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Allocation Days"; Rec."Allocation Days")
                {
                    ToolTip = 'Specifies the value of the Allocation Days field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Leave Days"; Rec."Total Leave Days")
                {
                    ToolTip = 'Specifies the value of the Total Leave Days field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Leave Taken"; Rec."Total Leave Taken")
                {
                    ToolTip = 'Specifies the value of the Total Leave Taken field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Current Balance"; Rec."Current Balance")
                {
                    ToolTip = 'Specifies the value of the Current Balance field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Other Information")
            {
                Editable=Rec."Approval Status"=Rec."Approval Status"::Open;
                field(Reliever; Rec.Reliever)
                {
                    ToolTip = 'Specifies the value of the Reliever field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Reliever Name"; Rec."Reliever Name")
                {
                    ToolTip = 'Specifies the value of the Reliever Name field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Details of Examination"; Rec."Details of Examination")
                {
                    ToolTip = 'Specifies the value of the Details of Examination field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Exam"; Rec."Date of Exam")
                {
                    ToolTip = 'Specifies the value of the Date of Exam field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Supervisor No."; Rec."Supervisor No.")
                {
                    ToolTip = 'Specifies the value of the Supervisor No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Supervisor Email"; Rec."Supervisor Email")
                {
                    ToolTip = 'Specifies the value of the Supervisor Email field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Trail Information")
            {
                Editable = false;

                field("Time Created"; Rec."Time Created")
                {
                    ToolTip = 'Specifies the value of the Time Created field.', Comment = '%';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ToolTip = 'Specifies the value of the Time Posted field.', Comment = '%';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.', Comment = '%';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ToolTip = 'Specifies the value of the Date Posted field.', Comment = '%';
                }
                field("Approved Days"; Rec."Approved Days")
                {
                    ToolTip = 'Specifies the value of the Approved Days field.', Comment = '%';
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("Applicant User ID"; Rec."Applicant User ID")
                {
                    ToolTip = 'Specifies the value of the Applicant User ID field.', Comment = '%';
                }

                field("Applicant Supervisor"; Rec."Applicant Supervisor")
                {
                    ToolTip = 'Specifies the value of the Applicant Supervisor field.', Comment = '%';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }
}
