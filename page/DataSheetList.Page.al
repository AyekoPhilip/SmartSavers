page 50942 "Data Sheet List"
{
    DeleteAllowed = true;
    PageType = List;
    SourceTable = "Checkoff Advice Line";
    SourceTableView = WHERE("Repay Mode" = FILTER(Checkoff | " "));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = All;
                }
                field("Interest On"; Rec."Interest On")
                {
                    ApplicationArea = All;
                }
                field("Amount On"; Rec."Amount On")
                {
                    ApplicationArea = All;
                }
                field(TotalAmt; TotalAmt)
                {
                    ApplicationArea = All;
                }
                field("Interest Off"; Rec."Interest Off")
                {
                    ApplicationArea = All;
                }
                field("Amount Off"; Rec."Amount Off")
                {
                    ApplicationArea = All;
                }
                field("Balance On"; Rec."Balance On")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Loan Span"; Rec."Loan Span")
                {
                    ApplicationArea = All;
                }
                field("Advice Date"; Rec."Advice Date")
                {
                    ApplicationArea = All;
                }
                field("Identity No."; Rec."Identity No.")
                {
                    Caption = 'ID No.';
                    ApplicationArea = All;
                }
                field("Payroll No"; Rec."Payroll No")
                {
                    ApplicationArea = All;
                }
                field("Advice Type"; Rec."Advice Type")
                {
                    ApplicationArea = All;
                }
                field("Product Search Code"; Rec."Product Search Code")
                {
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                }
                field("Payroll Staff No."; Rec."Payroll Staff No.")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Member Statistics")
            {
                Image = CoupledCustomer;
                RunObject = Page "Member Statistics";
                RunPageLink = "No." = FIELD("Member No.");
                ApplicationArea = All;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Member Statistics_Promoted"; "Member Statistics")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TotalAmt := Rec."Amount On" + Rec."Interest On";
    end;

    trigger OnOpenPage()
    begin
        Rec.RestrictAccess(UserId);
    end;

    var
        TotalAmt: Decimal;

}




