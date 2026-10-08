report 50366 "Official Bank Letters"
{
    ApplicationArea = All;
    Caption = 'Official Bank Letters';
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
            trigger OnPreDataItem()
            begin
                if LetterType = LetterType::" " then Error('Offical Letter Type must have a value.');

            end;

            trigger OnAfterGetRecord()
            begin

                if ChargeStatement then begin
                    if Confirm('Are you sure you want to charge Bank letter on this account?', true) = false then exit;
                    BnkProcMngt.ChargeAccountBankerLetters("No.", ChargeStatement, 1, LetterType);
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
                group(Option)
                {
                    Caption = 'Options';
                    field(ChargeStatement; ChargeStatement)
                    {
                        Caption = 'Charge Official Bank Letter';
                        ApplicationArea = All;
                    }
                    field(LetterType; LetterType)
                    {
                        Caption = 'Offical Letter Type';
                        ApplicationArea = All;

                    }
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                        Visible = false;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                        Visible = false;
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
        BalanceBF: Decimal;
        SavingsAccountName: Text;
        EmployerName: Text[250];
        ChargeStatement: Boolean;
        Employer: Record Customer;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        ReversedEntry: Boolean;
        CommunicationOnline: Text;
        BnkProcMngt: Codeunit "Banking Procedure Mngt.";
        StartDate: Date;
        PLoan: Record "Loans Categorization";
        PLoan3: Record "Loans Categorization";
        EndDate: Date;
        LetterType: Option " ","Financial","Non-Financial";

}



