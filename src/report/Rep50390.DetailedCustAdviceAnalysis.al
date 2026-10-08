report 50390 "Detailed Cust. Advice Analysis"
{
    ApplicationArea = All;
    Caption = 'Detailed Cust. Advice Analysis';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DetailedCustAdviseAnalysis.rdl';
    UseRequestPage = true;
    ShowPrintStatus = true;
    dataset
    {
        dataitem("Member Monthly Contribution"; "Member Monthly Contribution")
        {
            RequestFilterFields = "Account No.", "Last Modified Date", Type, "Application No.";
            column(Account_No_; "Account No.")
            { }
            column(Application_No_; "Application No.")
            { }
            column(Type; Type)
            { }
            column(Amount; Amount)
            { }
            column(Amount_Off; "Amount Off")
            { }
            column(Remarks; Remarks)
            { }
            column(Advise_Type; "Advise Type")
            { }
            column(CustName; CustName)
            { }
            column(ProdFactDescript; ProdFactDescript)
            { }
            trigger OnPreDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            begin
                ProdFactDescript := '';
                CustName := '';

                if ProdFact.Get("Product Type") then begin
                    ProdFactDescript := ProdFact.Description
                end;

                if CustRecord.Get("Account No.") then
                    CustName := CustRecord.Name;

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
                    field(SpecficEmp; SpecficEmp)
                    {
                        Caption = 'Specif Employer';
                        ApplicationArea = All;
                    }
                    field(EmployerCode; EmployerCode)
                    {
                        Caption = 'Employer Code';
                        TableRelation = Customer where("Account Type" = filter(Employer));
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
        Contribution: Record "Member Monthly Contribution";
        Account: Record "Account Banking";
        CredAccount: Record "Account Credit";
        Loans: Record "Loans Categorization";
        ProdFact: Record "Product Factory";
        RegMngt: Codeunit "Registry Mngt.";
        SpecficEmp: Boolean;
        EmployerCode: Code[20];
        ProdFactDescript: Text[150];
        CustName: Text[250];
        CustRecord: Record Member;

}
