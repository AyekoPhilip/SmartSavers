page 50064 "Cash Management Setups"
{
    PageType = Card;
    SourceTable = "Cash Management Setups";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Payment Voucher Template"; Rec."Payment Voucher Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Voucher Template field';
                }
                field("Imprest Journal Template"; Rec."Imprest Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Journal Template field';
                }
                field("Imprest Surrender Template"; Rec."Imprest Surrender Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Surrender Template field';
                }
                field("Petty Cash Journal Template"; Rec."Petty Cash Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Journal Template field';
                }
                field("Petty Cash Surrender Template"; Rec."Petty Cash Surrender Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Surrender Template field';
                }
                field("Receipt Template"; Rec."Receipt Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Template field';
                }
                field("Staff Claim Template"; Rec."Staff Claim Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff Claim Template field';
                }
                field("Bank Transfer Template"; Rec."Bank Transfer Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Transfer Template field';
                }
                field("Post VAT"; Rec."Post VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post VAT field';
                }
                field("Rounding Type"; Rec."Rounding Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rounding Type field';
                }
                field("Rounding Precision"; Rec."Rounding Precision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rounding Precision field';
                }
                field("Imprest Limit"; Rec."Imprest Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Limit field';
                }
                field("Imprest Due Date"; Rec."Imprest Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Due Date field';
                }
                field("Current Budget"; Rec."Current Budget")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Budget field';
                }
                field("Current Budget Start Date"; Rec."Current Budget Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Budget Start Date field';
                }
                field("Current Budget End Date"; Rec."Current Budget End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Budget End Date field';
                }
                field("Imprest Posting Group"; Rec."Imprest Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Posting Group field';
                }
                field("General Bus. Posting Group"; Rec."General Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the General Bus. Posting Group field';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field';
                }
                field("Check for Committment"; Rec."Check for Committment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check for Committment field';
                }
                field("Petty Cash Max"; Rec."Petty Cash Max")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Max field';
                }
                field("Max Imprests Unsurrendered"; Rec."Max Imprests Unsurrendered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max Imprests Unsurrendered field';
                }
                field("Max Open Documents"; Rec."Max Open Documents")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max Open Documents field';
                }
                field("EFT Path"; Rec."EFT Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EFT Path field';
                }
                field("Append Sign To Documents"; Rec."Append Sign To Documents")
                {
                    Caption = 'Append Signatures on Documents';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Append Signatures on Documents field';
                }
                field("Loan Journal Template"; Rec."Loan Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Journal Template field';
                }
                field("Loan Batch Template"; Rec."Loan Batch Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Batch Template field';
                }
                field("Cheque Reject Period"; Rec."Cheque Reject Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of allowed cheque period';

                }
            }
            group(Numbering)
            {
                field("PV Nos"; Rec."PV Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PV Nos field';
                }
                field("Petty Cash Nos"; Rec."Petty Cash Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Nos field';
                }
                field("Petty Cash Surrender Nos"; Rec."Petty Cash Surrender Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Surrender Nos field';
                }
                field("Imprest Nos"; Rec."Imprest Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Nos field';
                }
                field("Imprest Surrender Nos"; Rec."Imprest Surrender Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Surrender Nos field';
                }
                field("Receipt Nos"; Rec."Receipt Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Nos field';
                }
                field("Donor Workflows Nos"; Rec."Donor Workflows Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Donor Workflows Nos field';
                }
                field("Approvals Delegation Nos."; Rec."Approvals Delegation Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approvals Delegation Nos. field';
                }
                field("Staff Claim Nos"; Rec."Staff Claim Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff Claim Nos field';
                }
                field("Bank Transfer Nos"; Rec."Bank Transfer Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Transfer Nos field';
                }
                field("Profile Delegation Nos"; Rec."Profile Delegation Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Profile Delegation Nos field';
                }
                field("Apportionment Nos"; Rec."Apportionment Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Apportionment Nos field';
                }
                field("Input Tax Nos"; Rec."Input Tax Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Input Tax Nos field';
                }
                field("Service Charge Nos"; Rec."Service Charge Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Charge Nos field';
                }
                field("Service Charge Surrender Nos"; Rec."Service Charge Surrender Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Charge Surrender Nos field';
                }
                field("Service Charge Claim Nos"; Rec."Service Charge Claim Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Charge Claim Nos field';
                }
                field("Budget Approval Nos"; Rec."Budget Approval Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget Approval Nos field';
                }
                field("Proposed Budget Approval Nos"; Rec."Proposed Budget Approval Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Proposed Budget Approval Nos field';
                }
                field("FA Disposal Nos"; Rec."FA Disposal Nos")
                {
                    ToolTip = 'Specifies the value of the FA Disposal Nos field';
                    ApplicationArea = All;
                }
            }
            group(Accounts)
            {
                Caption = 'Accounts';

                field("Approtionment Account"; Rec."Approtionment Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approtionment Account field';
                }
                field("Apportion Template"; Rec."Apportion Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Apportion Template field';
                }
                field("Apportion Batch"; Rec."Apportion Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Apportion Batch field';
                }
            }
            group("Communication")
            {
                field("Finance Email"; Rec."Finance Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finance Email field';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}


