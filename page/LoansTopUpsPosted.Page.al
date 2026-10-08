page 50015 "LoansTopUps-Posted"
{
    ApplicationArea = All;
    Caption = 'LoansTopUp-Posted';
    PageType = List;
    SourceTable = "Loans Top up Posted";
    UsageCategory = Lists;
    Editable=false;
    ModifyAllowed=false;
    InsertAllowed=false;
    DeleteAllowed=false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field(Commision; Rec.Commision)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Commision field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan No. field.';
                }
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Top Up field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Balance field.';
                }
                field("Outstanding Bill"; Rec."Outstanding Bill")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Bill field.';
                }
                field("Outstanding Fee"; Rec."Outstanding Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Fee field.';
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Interest field.';
                }
                field("Outstanding Principle"; Rec."Outstanding Principle")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Principle field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field("Untransfered Interest"; Rec."Untransfered Interest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Untransfered Interest field.';
                }
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    begin
        Rec.fnCheckValidRequirement(Rec."Loan No.");
    end;
}



