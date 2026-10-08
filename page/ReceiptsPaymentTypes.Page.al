page 50075 "Receipts & Payment Types"
{
    PageType = List;
    SourceTable = "Receipts and Payment Types";
    UsageCategory = lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field';
                }
                field("VAT Chargeable"; Rec."VAT Chargeable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Chargeable field';
                }
                field("Withholding Tax Chargeable"; Rec."Withholding Tax Chargeable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Withholding Tax Chargeable field';
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Code field';
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Withholding Tax Code field';
                }
                field("Default Grouping"; Rec."Default Grouping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Grouping field';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field';
                }
                field("Pending Voucher"; Rec."Pending Voucher")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pending Voucher field';
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account field';
                }
                field("Transation Remarks"; Rec."Transation Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transation Remarks field';
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Reference field';
                }
                field("Customer Payment On Account"; Rec."Customer Payment On Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Payment On Account field';
                }
                field("Direct Expense"; Rec."Direct Expense")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Direct Expense field';
                }
                field("Calculate Retention"; Rec."Calculate Retention")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calculate Retention field';
                }
                field("Retention Code"; Rec."Retention Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Retention Code field';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field';
                }
                field("Based On Travel Rates Table"; Rec."Based On Travel Rates Table")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Based On Travel Rates Table field';
                }
                field("Receipt Reference"; Rec."Receipt Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Reference field';
                }
                field("Based On a Table"; Rec."Based On a Table")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Based On a Table field';
                }
                field("Old Account No"; Rec."Old Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Old Account No field';
                }
                field("Do NOT Allow Apply Twice"; Rec."Do NOT Allow Apply Twice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Do NOT Allow Apply Twice field';
                }
                field("Payment Option"; Rec."Payment Option")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Option field';
                }
                field("Imprest Payment"; Rec."Imprest Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Payment field';
                }
                field("Claim Payment"; Rec."Claim Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claim Payment field';
                }
                field("Cost of Sale"; Rec."Cost of Sale")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost of Sale field';
                }
                field("Check Medical Ceiling"; Rec."Check Medical Ceiling")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check Medical Ceiling field';
                }
                field("Property Receipt"; Rec."Property Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Property Receipt field';
                }
                field("Property Receipt Type"; Rec."Property Receipt Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Property Transaction Type field';
                }
                field("Manual Allocation"; Rec."Manual Allocation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manual Allocation field';
                }
            }
        }
    }

    actions
    {
    }
}


