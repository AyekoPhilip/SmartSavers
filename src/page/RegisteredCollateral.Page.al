page 50736 "Registered Collateral"
{
    ApplicationArea = All;
    Caption = 'Registered Collateral';
    PageType = List;
    CardPageId = "Collateral Register Card";
    SourceTable = "Collateral Register";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Approval Status" = filter(Approved | Posted | Rejected));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    ApplicationArea = All;
                }
                field("Application Type"; Rec."Application Type")
                {
                    ToolTip = 'Specifies the value of the Application Type field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Collateral; Rec.Collateral)
                {
                    ToolTip = 'Specifies the value of the Collateral field.';
                    ApplicationArea = All;
                }
                field("Collateral Limit"; Rec."Collateral Limit")
                {
                    ToolTip = 'Specifies the value of the Collateral Limit field.';
                    ApplicationArea = All;
                }
                field("Collateral Multiplier"; Rec."Collateral Multiplier")
                {
                    ToolTip = 'Specifies the value of the Collateral Multiplier field.';
                    ApplicationArea = All;
                }
                field("Collateral Name"; Rec."Collateral Name")
                {
                    ToolTip = 'Specifies the value of the Collateral Name field.';
                    ApplicationArea = All;
                }
                field("Collateral Perfected"; Rec."Collateral Perfected")
                {
                    ToolTip = 'Specifies the value of the Collateral Perfected field.';
                    ApplicationArea = All;
                }
                field("Collateral Type"; Rec."Collateral Type")
                {
                    ToolTip = 'Specifies the value of the Collateral Type field.';
                    ApplicationArea = All;
                }
                field("Collateral Value"; Rec."Collateral Value")
                {
                    ToolTip = 'Specifies the value of the Collateral Value field.';
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ToolTip = 'Specifies the value of the Date Posted field.';
                    ApplicationArea = All;
                }
                field("Forced Sale Value"; Rec."Forced Sale Value")
                {
                    ToolTip = 'Specifies the value of the Forced Sale Value field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("ID/Passport"; Rec."ID/Passport")
                {
                    ToolTip = 'Specifies the value of the ID/Passport field.';
                    ApplicationArea = All;
                }
                field("Insurance Value"; Rec."Insurance Value")
                {
                    ToolTip = 'Specifies the value of the Insurance Value field.';
                    ApplicationArea = All;
                }
                field("Inward/Outward"; Rec."Inward/Outward")
                {
                    ToolTip = 'Specifies the value of the Inward/Outward field.';
                    ApplicationArea = All;
                }
                field("Joint Ownership"; Rec."Joint Ownership")
                {
                    ToolTip = 'Specifies the value of the Joint Ownership field.';
                    ApplicationArea = All;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ToolTip = 'Specifies the value of the Property Type field.';
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ToolTip = 'Specifies the value of the Registration No. field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
                    ApplicationArea = All;
                }
                field("Year of Manufacture"; Rec."Year of Manufacture")
                {
                    ToolTip = 'Specifies the value of the Year of Manufacture field.';
                    ApplicationArea = All;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ToolTip = 'Specifies the value of the Captured By field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}



