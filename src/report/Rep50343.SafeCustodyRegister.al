report 50343 "Safe Custody Register"
{
    ApplicationArea = All;
    Caption = 'Safe Custody Register';
    UsageCategory = ReportsAndAnalysis;
    ShowPrintStatus = false;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/SafeCustodyRegister.rdl';
    UseRequestPage = true;
    dataset
    {
        dataitem(CollateralRegister; "Collateral Register")
        {
             DataItemTableView=where("Document Type"=const(Document),"Approval Status"=const(Posted));
            column(AccountName; "Account Name")
            {}
            column(AccountNo; "Account No.")
            {}
            column(IDPassport; "ID/Passport")
            {}
            column(MaturityDate; "Maturity Date")
            {}
            column(MaturityInstructions; "Maturity Instructions")
            {}
            column(No; "No.")
            {}
            column(PolicyEndDate; "Policy End Date")
            {}
            column(PolicyNo; "Policy No.")
            {}
            column(PolicyStartDate; "Policy Start Date")
            {}
            column(PostedBy; "Posted By")
            {}
            column(PropertyType; "Property Type")
            {}
            column(SCDuration; "SC Duration")
            {}
            column(SavingsAccountNo; "Savings Account No.")
            {}
            column(ThirdPartyAccess; "Third Party Access")
            {}
            column(ThirdPartyAccessIDPassport; "Third Party Access ID/Passport")
            {}
            column(TransactionType; "Transaction Type")
            {}
            column(ApplicationDate; "Application Date")
            {}
           column(Inward_Outward;"Inward/Outward")
           {}
           column(Date_Posted;"Date Posted")
           {}
           column(Document_Type;"Document Type")
           {}
           column(DateCollected;DateCollected)
           {}
           trigger OnPreDataItem()
           begin

           end;
           trigger OnAfterGetRecord()
           begin
            DateCollected:=0D;
            CollectReg.Reset();
            CollectReg.SetRange("Collateral Register No.",CollateralRegister."No.");
            CollectReg.SetRange("Inward/Outward",CollectReg."Inward/Outward"::Returned);
            if CollectReg.FindFirst() then begin
                DateCollected :=DT2Date(CollectReg."Date Posted");
            end else begin
                DateCollected:=0D;
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
    CollectReg: Record "Security Collection";
    DateCollected: Date;
}



