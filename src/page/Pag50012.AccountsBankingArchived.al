page 50012 "Accounts Banking-Archived"
{
    ApplicationArea = All;
    Caption = 'Accounts Banking-Archived';
    PageType = List;
    SourceTable = "Account Banking";
    CardPageId="Savings Account Card";
    UsageCategory = Lists;
    DeleteAllowed=false;
    InsertAllowed=false;
    ModifyAllowed=false;
    Editable=false;
    SourceTableView= where(Status=filter(Deceased|Frozen|Closed|Withdrawn)); 
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Old Member No."; Rec."Old Member No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Old Member No. field.';
                }
                field("ID/Passport No."; Rec."ID/Passport No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID/Passport No. field.';
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Posting Group field.';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employer Code field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Name field.';
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field.';
                }
                field("Staff/Payroll No."; Rec."Staff/Payroll No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff/Payroll No. field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Category field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
            }
        }
    }
}



