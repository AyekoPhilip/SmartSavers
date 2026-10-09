report 50044 "Gen. Dividend Mngt"
{
    ApplicationArea = All;
    Caption = 'Generate Dividend Mngt';
    UsageCategory = None;
    Permissions = TableData "Cust. Ledger Entry" = rimd, TableData "Detailed Cust. Ledg. Entry" = rimd;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem("Dividend Simulation Header"; "Dividend Simulation Header")
        {

        }
        dataitem(AccountCredit; "Account Credit")
        {
            RequestFilterFields = "No.", "Member No.", "Product Type", Status, "Employer Code";
            column(No; "No.")
            {
            }
            column(Name; Name)
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
            column(Status; Status)
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            trigger OnPreDataItem()
            begin
                DocumentNo := "Dividend Simulation Header"."No.";
                if DocumentNo = '' then Error('Document No. must have a value. It cannot be null');

                DividendProgression.SetRange("Header No.", "Dividend Simulation Header"."No.");
                DividendProgression.DeleteAll();

                DividendSetup.Get();
                DividendSetup.TestField("Start Date");
                DividendSetup.TestField("End Date");
                if DividendSetup."Start Date" > DividendSetup."End Date" then
                    Error('Start Date cannot be greater than End Date');
            end;

            trigger OnAfterGetRecord()
            begin

                ProdFact.Get("Dividend Simulation Header"."Product Type");
                ProdFact.TestField("Dividend Calc. Method");
                ProdFact.TestField("Minimum Balance");
                ProdFact.TestField("Interest Rate (Max.)");

                case ProdFact."Account Category" of
                    ProdFact."Account Category"::"Shares Capital":
                        begin
                            DivProcess.fnCalculateCustDivdends(AccountCredit, "Dividend Simulation Header"."Product Type", "Dividend Simulation Header"."No.");

                        end;
                    ProdFact."Account Category"::"Shares Deposit":
                        begin
                            case Status of
                                Status::Deceased,
                                Status::Withdrawn:
                                    begin
                                        CurrReport.Skip();
                                    end else begin
                                    DivProcess.fnCalculateCustDivdends(AccountCredit, "Dividend Simulation Header"."Product Type", "Dividend Simulation Header"."No.");
                                end
                            end
                        end
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
                group(Options)
                {
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;
                        Visible = false;
                        Caption = 'Document No.';
                        TableRelation = "Dividend Simulation Header"."No." where(Status = filter(<> Posted));
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
        DividendSetup: Record "Dividend SetUp";
        DocumentNo: Code[100];
        ProductType: Code[50];
        ProdFact: Record "Product Factory";
        DividendProgression: Record "Dividend Progression";
        StartDate, EndDate : Date;
        BosaAc: Record "Account Credit";
        DivProcess: Codeunit "Dividend Process";
}
