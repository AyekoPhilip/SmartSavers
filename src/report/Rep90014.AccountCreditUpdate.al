namespace SaccoDatabase.SaccoDatabase;

report 90014 "Account Credit Update"
{
    ApplicationArea = All;
    Caption = 'Account Credit Update';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly= true;
    dataset
    {
        dataitem(ccountCredit; "Account Credit")
        {
            column(AccountCategory; "Account Category")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
        trigger OnAfterGetRecord()
            begin
          if AccountCredit.Get("No.") then begin
            AccountCredit.Validate("Product Type");
            AccountCredit.Modify;
          end;
            end;
        }
    }



    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
    AccountCredit: Record "Account Credit";
}
