page 50827 "Member Collaterals"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = Collateral;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                }
                field("Date Collateralised"; Rec."Date Collateralised")
                {
                    ApplicationArea = All;
                }
                field("Collateral Type"; Rec."Collateral Type")
                {
                    ApplicationArea = All;
                }
                field("Collateral Value"; Rec."Collateral Value")
                {
                    ApplicationArea = All;
                }
                field("Registration/Certificate No."; Rec."Registration/Certificate No.")
                {
                    ApplicationArea = All;
                }
                field("Internal Account(Lien)"; Rec."Internal Account(Lien)")
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




