report 50271 "EFT Transfers Report"
{
    ApplicationArea = All;
    Caption = 'EFT Transfers Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/EFTTransferReport.rdl';
    dataset
    {
        dataitem(EFTTransferLines; "EFT Transfer Lines")
        {
            RequestFilterFields = "Date Posted";
            column(AccountName; "Account Name")
            {
            }
            column(Date_Posted; "Date Posted")
            { }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AmountText; "Amount Text")
            {
            }
            column(AvailableBalance; "Available Balance")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(BranchCode; "Branch Code")
            {
            }
            column(ChargeAccount; "Charge Account")
            {
            }
            column(ChargeAmount; "Charge Amount")
            {
            }
            column(Contact; Contact)
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(EnteredBy; "Entered By")
            {
            }
            column(ExciseDuty; "Excise Duty")
            {
            }
            column(ExportFormat; ExportFormat)
            {
            }
            column(ExternalAccountName; "External Account Name")
            {
            }
            column(ExternalAccountNo; "External Account No.")
            {
            }
            column(IBANNo; "IBAN No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MultipleAccounts; "Multiple Accounts")
            {
            }
            column(No; No)
            {
            }
            column(OverDrawn; "Over Drawn")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(PhysicalAddress; "Physical Address")
            {
            }
            column(Posted; Posted)
            {
            }
            column(RoutingCode; "Routing Code")
            {
            }
            column(Transferred; Transferred)
            {
            }
            column(SourceOfFunds; SourceOfFunds)
            { }
            column(EmailAddress; EmailAddress)
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                EmailAddress := '';
                SourceOfFunds := SourceOfFunds::" ";

                if AccBanking.Get("Account No.") then begin
                    Customer.Reset();
                    Customer.SetRange("No.", "Member No.");
                    if Customer.FindFirst() then
                        EmailAddress := Customer."E-Mail";
                end;

                EFTHeader.Reset();
                EFTHeader.SetRange("No.", "Document No.");
                if EFTHeader.FindFirst() then begin
                    SourceOfFunds := EFTHeader."Source of funds";
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
        EFTHeader: Record "EFT Transfer Header";
        SourceOfFunds: Enum SourceOfFunds;
        EmailAddress: Code[100];
        Customer: Record Member;
        AccBanking: Record "Account Banking";

}



