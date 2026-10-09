page 50645 "Approvals Delegation"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Approvals Delegation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Delegation No."; Rec."Delegation No.")
                {
                    Editable = ShowField;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegation No. field';
                }
                field("Current User"; Rec."Current User")
                {
                    Editable = ShowField;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current User field';
                }
                field("Delegation Start Date"; Rec."Delegation Start Date")
                {
                    Editable = ShowField;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegation Start Date field';
                }
                field("Delegation End Date"; Rec."Delegation End Date")
                {
                    Editable = ShowField;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegation End Date field';
                }
                field("Reason for Delegation"; Rec."Reason for Delegation")
                {
                    Editable = ShowField;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason for Delegation field';
                }
                field("Delegated To"; Rec."Delegated To")
                {
                    Editable = ShowField;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegated To field';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delegate)
            {
                Enabled = ShowField;
                Image = Delegate;
                ApplicationArea = All;
                ToolTip = 'Executes the Delegate action';

                trigger OnAction()
                begin
                    Rec.Delegate(Rec);
                end;
            }
            action(Resume)
            {
                Enabled = ShowField;
                Image = Restore;
                ApplicationArea = All;
                ToolTip = 'Executes the Resume action';

                trigger OnAction()
                begin
                    Rec.Resume(Rec);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Delegate_Promoted; Delegate)
                {
                }
                actionref(Resume_Promoted; Resume)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetAppearance();
    end;

    trigger OnOpenPage()
    begin
        SetAppearance();
    end;

    var
        
        ShowField: Boolean;

    local procedure SetAppearance()
    begin
        ShowField := true;
        if Rec.Status = Rec.Status::Resumed then
            ShowField := false;
    end;
}


