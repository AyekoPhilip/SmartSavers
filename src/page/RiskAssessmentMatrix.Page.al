page 51062 "Risk Assessment Matrix"
{
    ApplicationArea = All;
    Caption = 'Risk Assessment Matrix';
    PageType = List;
    SourceTable = "Risk Assessment Matrix";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                    ShowMandatory = true;
                    ApplicationArea = All;
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

    }
    trigger OnOpenPage()
    begin
        if Applications.Get(Rec.Code) then begin
            if Applications."Approval Status" = Applications."Approval Status"::Open then
                CurrPage.Editable := true else
                CurrPage.Editable := false;
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Applications.Get(Rec.Code) then begin
            case Applications."Approval Status" of
                Applications."Approval Status"::Approved,
            Applications."Approval Status"::"Pending Approval",
            Applications."Approval Status"::Deffered,
            Applications."Approval Status"::Posted,
            Applications."Approval Status"::Rejected:
                    Error('You cannot Delete or Modify an Document whose status is %1', Applications."Approval Status");
            end;

        end;

    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Applications.Get(Rec.Code) then begin
            case Applications."Approval Status" of
                Applications."Approval Status"::Approved,
            Applications."Approval Status"::"Pending Approval",
            Applications."Approval Status"::Deffered,
            Applications."Approval Status"::Posted,
            Applications."Approval Status"::Rejected:
                    Error('You cannot Delete or Modify an Document whose status is %1', Applications."Approval Status");
            end;

        end;


    end;

    trigger OnAfterGetRecord()
    begin

    end;

    var
        Applications: Record "Member Application";
}
