report 50188 "Process Cheque Clearance"
{
    ApplicationArea = All;
    Caption = 'Process Cheque Clearance';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;

    dataset
    {
        dataitem(TellerTransaction; "Teller Transaction")
        {
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if (TellerTransaction.Type = TellerTransaction.Type::"Cheque Deposit") or (TellerTransaction.Type = TellerTransaction.Type::"Credit Cheque") then begin
                    BnkMngt.ClearCheques(TellerTransaction);
                end else begin
                    CurrReport.Skip();
                end;
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
                group(GroupName)
                {
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
        BnkMngt: Codeunit "Banking Procedure Mngt.";
        WeekDay: Text;
}



