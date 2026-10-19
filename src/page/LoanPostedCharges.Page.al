page 50014 "Loan Posted Charges"
{
    ApplicationArea = All;
    Caption = 'Loan Posted Charges';
    PageType = List;
    SourceTable = "Loan Charge Posted";
    UsageCategory = Lists;
    Editable=false;
    ModifyAllowed=false;
    InsertAllowed=false;
    DeleteAllowed=false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Additional Charge %"; Rec."Additional Charge %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additional Charge % field.';
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application No. field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Amount field.';
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Code field.';
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Description field.';
                }
                field("Charge Method"; Rec."Charge Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Method field.';
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Type field.';
                }
                field("Charging Option"; Rec."Charging Option")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charging Option field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Effect Excise Duty"; Rec."Effect Excise Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Effect Excise Duty field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan No. field.';
                }
                field(Maximum; Rec.Maximum)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum field.';
                }
                field(Minimum; Rec.Minimum)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum field.';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage field.';
                }
                field("Post Charge"; Rec."Post Charge")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Charge field.';
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Code field.';
                }
                field(Prorate; Rec.Prorate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prorate field.';
                }
                field("Staggered Charge Code"; Rec."Staggered Charge Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staggered Charge Code field.';
                }
                field("Use Percentage"; Rec."Use Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Use Percentage field.';
                }
            }
        }
    }
}



