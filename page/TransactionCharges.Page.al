page 50845 "Transaction Charges"
{
    DeleteAllowed = true;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "Transaction Charge";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ApplicationArea = All;
                }
                field("Percentage of Amount"; Rec."Percentage of Amount")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("ATM Clearing Account"; Rec."ATM Clearing Account")
                {
                    ApplicationArea = All;

                }
                field("ATM Fee (Income)"; Rec."ATM Fee (Income)")
                {
                    ApplicationArea = All;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Staggered Charge Code"; Rec."Staggered Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction Charge Category"; Rec."Transaction Charge Category")
                {
                    ApplicationArea = All;
                }
                field("Recover Excise Duty"; Rec."Recover Excise Duty")
                {
                    ApplicationArea = All;
                }
                field("Account Closure"; Rec."Account Closure")
                {
                    ApplicationArea = All;
                }
                field("ATM Clearing Account Comms. %"; Rec."ATM Clearing Account Comms. %")
                {
                    ApplicationArea = All;

                }
                field("ATM Fee. %"; Rec."ATM Fee. %")
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




