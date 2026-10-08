report 50186 "CreateAccLien"
{
    ApplicationArea = All;
    Caption = 'Create Account Lien';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(AccountBanking; "Account Banking")
        {

            column(No; "No.")
            {
            }
            trigger OnAfterGetRecord()
            begin
                Bmngt.PostLien(AccountBanking, Amt, TransDescript, 0, AccountBanking."No.");
            end;

            trigger OnPreDataItem()
            begin
                if Amt = 0 then
                    Error('Amount must have a value. It cannot be zero');
                if TransDescript = '' then Error('Remarks must have a value. It cannot be blank');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(Amount; Amt)
                    {
                        ApplicationArea = All;

                    }
                    field(Remarks; TransDescript)
                    {
                        Caption = 'Remarks';
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
        Amt: Decimal;
        TransDescript: Text[100];
        Bmngt: Codeunit "Banking Procedure Mngt.";

}



