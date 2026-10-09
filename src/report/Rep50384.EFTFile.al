report 50384 "EFT File"
{
    ApplicationArea = All;
    Caption = 'EFT File';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/EFTFile.rdl';
    dataset
    {
        dataitem("EFT Transfer Header"; "EFT Transfer Header")
        {
            column(Date_Entered; "Date Entered")
            { }
            column(Account_No_; "Account No.")
            { }
            column(RecipienceRef; RecipienceRef)
            { }
            dataitem(EFTTransferLines; "EFT Transfer Lines")
            {
                DataItemLink = "Document No." = field("No.");
                column(AccountNo; "Account No.")
                { }
                column(Document_No_; "Document No.")
                { }
                column(Own_Reference; "Own Reference")
                { }
                column(EftlineRecipienceRef; "Recipient Reference")
                { }
                column(AccountType; "Account Type")
                { }
                column(AccountName; "Account Name")
                { }
                column(Society_Code; "Society Code")
                { }
                column(Institution_Type; "Institution Type")
                { }
                column(Amount; Amount)
                { }
                column(BankCode; "Bank Code")
                { }
                column(BankName; "Bank Name")
                { }
                column(BranchCode; "Branch Code")
                { }
                column(BranchName; "Branch Name")
                { }
                column(DocumentNo; "Document No.")
                { }
                column(ExternalAccountName; "External Account Name")
                { }
                column(ExternalAccountNo; "External Account No.")
                { }
                column(IBANNo; "IBAN No.")
                { }
                column(LoanNo; "Loan No.")
                { }
                column(MemberNo; "Member No.")
                { }
                column(No; No)
                { }
                column(RecipienceAc; RecipienceAc)
                { }
                column(RecipienceAccountType; RecipienceAccountType)
                { }
                column(RecipienceName; RecipienceName)
                { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    RecipienceAc := '';
                    RecipienceAccountType := '';
                    RecipienceName := '';
                    if "EFT Options" = "EFT Options"::"Bank Account" then begin
                        RecipienceAc := 'RECIPIENT ACCOUNT';
                        RecipienceAccountType := 'RECIPIENT ACCOUNT TYPE';
                        RecipienceName := 'RECIPIENT NAME';
                    end else begin
                        RecipienceAc := 'TO ACCOUNT';
                        RecipienceAccountType := 'TO';
                        RecipienceName := 'PAYEE NAME';
                    end;

                    if "EFT Options" = "EFT Options"::"Money Wallet" then begin
                        if CustRec.Get("Member No.") then begin
                            CustRec.TestField("Mobile Phone No");
                            if CopyStr(format(CustRec."Mobile Phone No"), 1, 3) <> '268' then
                                "External Account No." := '268' + CustRec."Mobile Phone No";
                        end;
                    end;
                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                RecipienceRef := '';
                if BankAcc.Get("Account No.") then
                    RecipienceRef := BankAcc."Bank Account No."
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
        RecipienceRef: Code[100];
        BanksList: Record Banks;
        CustRec: Record Member;
        BankAcc: Record "Bank Account";
        RecipienceName: Text[150];
        RecipienceAc: Text[150];
        RecipienceAccountType: Text[150];

}
