report 50013 "Generate Cheque Nos"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            trigger OnAfterGetRecord()
            begin
                BankAccount.Reset();
                BankAccount.SetRange("No.", "Bank Account"."No.");
                if BankAccount.FindFirst() then begin
                    i := 0;
                    repeat
                        i := i + 1;
                        "Cheque Register".Init();
                        "Cheque Register"."Cheque No." := StartingNo;
                        "Cheque Register"."Bank Account No." := BankAccount."No.";
                        "Cheque Register"."Date Generated" := Today;
                        "Cheque Register"."Entry Status" := "Cheque Register"."Entry Status"::Printed;
                        "Cheque Register"."User ID" := UserId;
                        "Cheque Register".Insert();

                        StartingNo := IncStr(StartingNo);
                    until i = NoOfCheques;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Done');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(StartingNo; StartingNo)
                {
                    Caption = 'Starting Cheque No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Cheque No. field';
                }
                field(NoOfCheques; NoOfCheques)
                {
                    Caption = 'No of Leaves';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No of Leaves field';
                }
            }
        }

        actions
        {
        }
    }
    labels
    {
    }

    trigger OnPreReport()
    begin
        if StartingNo = '' then
            Error('Starting cheque nos must have a value');

        if NoOfCheques = 0 then
            Error('No. of leaves must have a value');
    end;

    var
        BankAccount: Record "Bank Account";
        "Cheque Register": Record "Cheque Register";
        StartingNo: Code[10];
        i: Integer;
        NoOfCheques: Integer;
}


