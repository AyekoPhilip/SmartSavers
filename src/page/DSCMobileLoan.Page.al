page 50591 "DSC Mobile Loan"
{
    ApplicationArea = All;
    Caption = 'DSC Mobile Loan';
    PageType = List;
    SourceTable = "DSC Mobile Loan";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Visible = false;
                }
                field("API Code"; Rec."API Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the API Code field.';
                    Visible = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan No. field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Amount field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }

                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Amount field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Date/Time Captured"; Rec."Date/Time Captured")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date/Time Captured field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }

                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Captured By field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }

                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted By field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.Remarks := CopyStr(Rec.Remarks, 4, 150)
    end;
}



