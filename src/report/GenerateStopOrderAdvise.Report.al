report 50391 "Generate Stop Order Advise"
{
    ApplicationArea = All;
    Caption = 'Generate Stop Order Advise';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(Member; Member)
        {

            column(No; "No.")
            {
            }
            column(Status; Status)
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if Status = Status::Active then begin
                    RegMngt.generateCustomerStopOrder("No.", SpecficEmp);
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
        Contribution: Record "Member Monthly Contribution";
        Account: Record "Account Banking";
        CredAccount: Record "Account Credit";
        Loans: Record "Loans Categorization";
        ProdFact: Record "Product Factory";
        RegMngt: Codeunit "Registry Mngt.";
        SpecficEmp: Boolean;
        EmployerCode: Code[20];
}
