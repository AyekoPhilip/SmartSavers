report 50342 "Process Safe Custody Renewal"
{
    ApplicationArea = All;
    Caption = 'Process Safe Custody Renewal';
    UsageCategory = Administration;
    ProcessingOnly=true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(CollateralRegister; "Collateral Register")
        {
            DataItemTableView=where("Approval Status"=const(Posted));
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(ApplicationType; "Application Type")
            {
            }
            trigger OnPostDataItem()
            begin

            end;
            trigger OnAfterGetRecord()
            begin
                if "Document Type"="Document Type"::Document then begin
                RegMngt.PostSafeCustodyAutomated(CollateralRegister);
                end;
            end;
            trigger OnPreDataItem()
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
    RegMngt: Codeunit "Registry Mngt.";
}



