report 50380 "Copy Product"
{
    ApplicationArea = All;
    Caption = 'Copy Product';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(ProductFactory; "Product Factory")
        {
            RequestFilterFields = "Product ID";
            column(ProductID; "Product ID")
            {
            }
            trigger OnPreDataItem()
            begin
                if (ProductID = '') or (AccountDimension = AccountDimension::" ") then
                    Error('Product ID/ Account Dimension must a value. It cannot be blank');

            end;

            trigger OnAfterGetRecord()
            begin
                if "Account Category" = "Account Category"::Savings then begin
                    PFactory.Reset();
                    PFactory.SetRange("Account Category", PFactory."Account Category"::Savings);
                    PFactory.SetRange("Account Dimension", AccountDimension);
                    if PFactory.FindFirst() then
                        Error('Product within the same dimensions already exist');
                end;

                PFactory.Reset();
                PFactory.SetRange("Product ID", ProductID);
                if PFactory.FindFirst() then
                    Error('Product within the same ID already exist');

                PFactory.Reset();
                PFactory.SetRange("Account Category", "Account Category");
                PFactory.SetRange("Account Dimension", AccountDimension);
                if PFactory.FindFirst() then
                    if PFactory."Product Class" = ProductFactory."Product Class"::Account then
                        Error('Product within the same dimensions already exist');
                RegMgt.CopyRecordRef(ProductID, "Product ID", AccountDimension);
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ProductID; ProductID)
                    {
                        Caption = 'New Product ID';
                        ApplicationArea = All;

                    }
                    field(AccountDimension; AccountDimension)
                    {
                        Caption = 'Account Dimension';
                        ApplicationArea = All;

                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        ProductID: Code[10];
        AccountDimension: Enum AccountDimension;
        Factory: Record "Product Factory Temp.";
        PFactory: Record "Product Factory";
        RegMgt: Codeunit "Register Management";
        Varvariant: Variant;

}



