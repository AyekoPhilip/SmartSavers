page 50892 "Checkoff Advice Header"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Checkoff Advice Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Loan Issue Cut OFF Date"; Rec."Loan Issue Cut OFF Date")
                {
                    ApplicationArea = All;
                }
                field("Loan Interest Cut OFF Date"; Rec."Loan Interest Cut OFF Date")
                {
                    ApplicationArea = All;
                }
                field("Captured By"; Rec."Captured By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(Control10; "Checkoff Advice")
            {
                Editable = EditBuff;
                SubPageLink = "Advice Header No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Export New Loans")
            {
                Image = Export;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CheckoffAdviceHeader.Reset;
                    CheckoffAdviceHeader.SetRange(CheckoffAdviceHeader."No.", Rec."No.");
                    if CheckoffAdviceHeader.Find('-') then
                        XMLPORT.Run(52140645, true, true, CheckoffAdviceHeader);
                end;
            }
            action("Generate Advice")
            {
                Image = CreateLinesFromJob;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // TESTFIELD("Loan Interest Cut OFF Date");TESTFIELD("Loan Issue Cut OFF Date");
                    // IF Processed= FALSE THEN BEGIN
                    // PeriodicActivities.MonthlyCheckoffAdvice(Rec)
                    // END ELSE
                    //  ERROR(Txt0001);
                    // MESSAGE(Txt0002);
                end;
            }
            action("Mark as Processed")
            {
                Image = AlternativeAddress;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //PeriodicActivities.ProcessAdvice(Rec);
                end;
            }
            action("Checkoff Advice - Loans")
            {
                Image = "Report";
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(52140684, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Checkoff Advice - Cummulative")
            {
                Image = "Report";
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(52140678, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Checkoff Advice - Savings")
            {
                Image = "Report";
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(52140679, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Export New Loans_Promoted"; "Export New Loans")
                {
                }
                actionref("Generate Advice_Promoted"; "Generate Advice")
                {
                }
                actionref("Mark as Processed_Promoted"; "Mark as Processed")
                {
                }
                actionref("Checkoff Advice - Loans_Promoted"; "Checkoff Advice - Loans")
                {
                }
                actionref("Checkoff Advice - Cummulative_Promoted"; "Checkoff Advice - Cummulative")
                {
                }
                actionref("Checkoff Advice - Savings_Promoted"; "Checkoff Advice - Savings")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.Processed = true then
            CurrPage.Editable := false;
    end;

    var
        CheckoffAdviceHeader: Record "Checkoff Advice Header";
        EditBuff: Boolean;
}




