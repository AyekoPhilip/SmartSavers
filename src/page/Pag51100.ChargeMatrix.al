page 51100 "Charge Matrix"
{
    ApplicationArea = All;
    Caption = 'Charge Matrix';
    PageType = List;
    SourceTable = "Charge Matrix";
    UsageCategory = Lists;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting A/c"; Rec."Posting A/c")
                {
                    ToolTip = 'Specifies the value of the Posting Account field.';
                }

                field("Banking A/c (Balance Enquiry)"; Rec."Banking A/c (Balance Enquiry)")
                {
                    ToolTip = 'Specifies the value of the Charge Banking A/c (Balance Enquiry) field.';
                }
                field("Charge Account Withdrawals"; Rec."Charge Account Withdrawals")
                {
                    ToolTip = 'Specifies the value of the Charge Account Withdrawals field.';
                }
                field("Charge Full- Statement"; Rec."Charge Full- Statement")
                {
                    ToolTip = 'Specifies the value of the Charge Full- Statement field.';
                }
                field("Charge Mini-Statement (Credit)"; Rec."Charge Mini-Statement (Credit)")
                {
                    ToolTip = 'Specifies the value of the Charge Mini-Statement (Credit) field.';
                }
                field("Credit A/c (Balance Equiry)"; Rec."Credit A/c (Balance Equiry)")
                {
                    ToolTip = 'Specifies the value of the Charge Credit A/c (Balance Equiry) field.';
                }
                field("Mini-Statement (Banking)"; Rec."Mini-Statement (Banking)")
                {
                    ToolTip = 'Specifies the value of the Charge Mini-Statement (Banking) field.';
                }
            }
        }
    }
}
