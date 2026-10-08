report 50394 "Reverse Cred. Entry"
{
    ApplicationArea = All;
    Caption = 'Reverse Cred. Entry';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(GLRegister; "G/L Register")
        {
            column(No; "No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(UserID; "User ID")
            {
            }
            trigger OnAfterGetRecord()
            begin
                //AltChannelMgt.PostAutomatedReversal("Document No.");
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
        AltChannelMgt: Codeunit "Alt. Channel (Mobile Mngt.)";
        Respx: Text[250];
}
