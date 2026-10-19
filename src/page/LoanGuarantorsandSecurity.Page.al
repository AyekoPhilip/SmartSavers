page 50826 "Loan Guarantors and Security"
{
    PageType = List;
    SourceTable = "Loan Guarantors and Security";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Security Type"; Rec."Security Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Collateral Reg. No."; Rec."Collateral Reg. No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    ApplicationArea = All;
                }
                field("Deposit Shares"; Rec."Deposit Shares")
                {
                    ApplicationArea = All;
                }
                field("Collateral Value"; Rec."Collateral Value")
                {
                    ApplicationArea = All;
                }
                field("Available Shares"; Rec."Available Shares")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Notification Sent"; Rec."Notification Sent")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
            }
        }
        area(factboxes)
        {
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Sent SMS to Guarantors")
            {
                Image = Notes;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref("Sent SMS to Guarantors_Promoted"; "Sent SMS to Guarantors")
                {
                }
            }
        }
    }

    trigger OnClosePage()
    begin
       
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if LoanApp.Get(Rec."No.") then begin
            LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if LoanApp.Get(Rec."No.") then begin
            LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
        end;
    end;

    trigger OnOpenPage()
    begin
        if LoanApp.Get(Rec."No.") then begin
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then begin
                CurrPage.Editable := false;
            end;
        end;
    end;

    var
        GenSetUp: Record "General Set-Up";
        LoanApp: Record "Loan Application";
}




