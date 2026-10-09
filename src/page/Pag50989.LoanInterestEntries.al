page 50989 "Loan Interest Entries"
{
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Loan Interest Entries";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Loan Account No"; Rec."Loan Account No")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Interest Date"; Rec."Interest Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = All;
                }
                field("Mark For Deletion"; Rec."Mark For Deletion")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Repayment Account No."; Rec."Repayment Account No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




