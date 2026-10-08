page 51035 "Application Charges Posted"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Charge Posted";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Product Code"; Rec."Product Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Charge Method"; Rec."Charge Method")
                {
                    ApplicationArea = All;
                }
                field("Use Percentage"; Rec."Use Percentage")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Effect Excise Duty"; Rec."Effect Excise Duty")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                }
                field("Charging Option"; Rec."Charging Option")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Minimum; Rec.Minimum)
                {
                    ApplicationArea = All;
                }
                field(Maximum; Rec.Maximum)
                {
                    ApplicationArea = All;
                }
                field("Additional Charge %"; Rec."Additional Charge %")
                {
                    ApplicationArea = All;
                }
                field(Prorate; Rec.Prorate)
                {
                    ApplicationArea = All;
                }
                field("Staggered Charge Code"; Rec."Staggered Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable := false
    end;
}




