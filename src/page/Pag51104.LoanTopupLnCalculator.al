page 51104 "Loan Topup- Ln. Calculator"
{
    ApplicationArea = All;
    Caption = 'Loan Topup- Ln. Calculator';
    PageType = List;
    SourceTable = "Loans Topup-Ln. Calculator";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ToolTip = 'Specifies the value of the Loan Top Up field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Settlement Fee"; Rec."Settlement Fee")
                {
                    ToolTip = 'Specifies the value of the Settlement Fee field.';
                }
                field("Untransfered Interest"; Rec."Untransfered Interest")
                {
                    ToolTip = 'Specifies the value of the Untransfered Interest field.';
                }
                field(Commision; Rec.Commision)
                {
                    ToolTip = 'Specifies the value of the Commision field.';
                }

                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ToolTip = 'Specifies the value of the Outstanding Balance field.';
                }
                field("Outstanding Bill"; Rec."Outstanding Bill")
                {
                    ToolTip = 'Specifies the value of the Outstanding Bill field.';
                }
                field("Outstanding Fee"; Rec."Outstanding Fee")
                {
                    ToolTip = 'Specifies the value of the Outstanding Fee field.';
                }
                field("Outstanding Insurance"; Rec."Outstanding Insurance")
                {
                    ToolTip = 'Specifies the value of the Outstanding Insurance field.';
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ToolTip = 'Specifies the value of the Outstanding Interest field.';
                }
                field("Outstanding Principle"; Rec."Outstanding Principle")
                {
                    ToolTip = 'Specifies the value of the Outstanding Principle field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                }

                field("Total Outstanding Amount"; Rec."Total Outstanding Amount")
                {
                    ToolTip = 'Specifies the value of the Total Outstanding Amount field.';
                }
                field("Total Total Up"; Rec."Total Total Up")
                {
                    ToolTip = 'Specifies the value of the Total Total Up field.';
                }

            }
        }
    }
}
