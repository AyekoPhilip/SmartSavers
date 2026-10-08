page 50765 "SMS Account Subscription"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "SMS Account Subscription";
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
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(SMS; Rec.SMS)
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
            }
            group("Sms Options")
            {
                field("Member Creation"; Rec."Member Creation")
                {
                    ApplicationArea = All;
                }
                field("Deposit Confirmation"; Rec."Deposit Confirmation")
                {
                    ApplicationArea = All;
                }
                field("Cash Withdrawal"; Rec."Cash Withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Loan Application"; Rec."Loan Application")
                {
                    ApplicationArea = All;
                }
                field("Loan Guarantors"; Rec."Loan Guarantors")
                {
                    ApplicationArea = All;
                }
                field("Loan Posted"; Rec."Loan Posted")
                {
                    ApplicationArea = All;
                }
                field("Loan defaulted"; Rec."Loan defaulted")
                {
                    ApplicationArea = All;
                }
                field("Salary Posted"; Rec."Salary Posted")
                {
                    ApplicationArea = All;
                }
                field("Fixed Deposit Maturity"; Rec."Fixed Deposit Maturity")
                {
                    ApplicationArea = All;
                }
                field("InterAccount Transfer"; Rec."InterAccount Transfer")
                {
                    ApplicationArea = All;
                }
                field("Account Status"; Rec."Account Status")
                {
                    ApplicationArea = All;
                }
                field("Status Order Creation"; Rec."Status Order Creation")
                {
                    ApplicationArea = All;
                }
                field("EFT Effected"; Rec."EFT Effected")
                {
                    ApplicationArea = All;
                }
                field("ATM Application Failed"; Rec."ATM Application Failed")
                {
                    ApplicationArea = All;
                }
                field("ATM Collection"; Rec."ATM Collection")
                {
                    ApplicationArea = All;
                }
                field(MSACCO; Rec.MSACCO)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




