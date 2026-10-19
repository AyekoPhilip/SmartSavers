page 50116 "HR Job Card"
{
    ApplicationArea = All;
    Caption = 'Job Card';
    PageType = Card;
    SourceTable = "HR Jobs";
    
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Job ID"; Rec."Job ID")
                {
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field("Key Position"; Rec."Key Position")
                {
                    ToolTip = 'Specifies the value of the Key Position field.';
                }
                field("No. Of Posts"; Rec."No. Of Posts")
                {
                    ToolTip = 'Specifies the value of the No. Of Posts field.';
                }
                field("No. of Requirements"; Rec."No. of Requirements")
                {
                    ToolTip = 'Specifies the value of the No. of Requirements field.';
                }
                field("No. of Responsibilities"; Rec."No. of Responsibilities")
                {
                    ToolTip = 'Specifies the value of the No. of Responsibilities field.';
                }
                field("Occupied Position"; Rec."Occupied Position")
                {
                    ToolTip = 'Specifies the value of the Occupied Position field.';
                }
                field("Position Reporting To"; Rec."Position Reporting To")
                {
                    ToolTip = 'Specifies the value of the Position Reporting To field.';
                }
                field("Main Objective"; Rec."Main Objective")
                {
                    ToolTip = 'Specifies the value of the Main Objective field.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Score Code"; Rec."Score Code")
                {
                    ToolTip = 'Specifies the value of the Score Code field.';
                }
                field("Is Supervisor"; Rec."Is Supervisor")
                {
                    ToolTip = 'Specifies the value of the Is Supervisor field.';
                }
                field(Grade; Rec.Grade)
                {
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Total Score"; Rec."Total Score")
                {
                    ToolTip = 'Specifies the value of the Total Score field.';
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    ToolTip = 'Specifies the value of the Vacant Positions field.';
                }
                field("Employee Requisition"; Rec."Employee Requisition")
                {
                    ToolTip = 'Specifies the value of the Employee Requisition field.';
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
