page 51036 "Loans Top Up Posted"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loans Top up Posted";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = true;
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Editable =true;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = true;

                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable =TRUE;
                }
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Untransfered Interest"; Rec."Untransfered Interest")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Outstanding Principle"; Rec."Outstanding Principle")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Outstanding Bill"; Rec."Outstanding Bill")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Outstanding Fee"; Rec."Outstanding Fee")
                {
                    ApplicationArea = All;
                     Editable = true;
                }
                field("Settlement Fee"; Rec."Settlement Fee")
                {
                    ApplicationArea = All;
                     Editable = true;
                }
                field(Commision; Rec.Commision)
                {
                    ApplicationArea = All;
                     Editable = true;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                     Editable = true;
                }
                field("Total Total Up"; Rec."Total Total Up")
                {
                    ApplicationArea = All;
                     Editable = true;

                }

            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
      //  CurrPage.Editable := false
    end;
}




