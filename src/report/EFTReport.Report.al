report 50324 "EFT Report"
{
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/report_layout/EFTReport.rdl';

    dataset
    {
        dataitem("EFT Transfer Header"; "EFT Transfer Header")
        {
            RequestFilterFields = "No.", "Date Transferred", "Approval Status";
            column(EFTTransferHeader_RecordTotal; "EFT Transfer Header"."Record Total")
            { }
            column(EFTTransferHeader_CreatedBy; "EFT Transfer Header"."Created By")
            { }
            column(Record_Count; "Record Count")
            { }
            column(No_; "No.")
            { }
            column(EFT_Options; "EFT Options")
            { }
            column(NumberText; NumberText[1])
            { }
            column(Document_Type; "Document Type")
            { }
            column(ProdDescription; ProdDescription)
            { }
            column(Product_Type; "Product Type")
            { }
            column(Account_No_; "Account No.")
            { }
            column(Account_Name; "Account Name")
            { }
            column(Remarks; Remarks)
            { }
            column(Date_Entered; "Date Entered")
            {

            }
            dataitem("EFT Transfer Lines"; "EFT Transfer Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(EntryNo_EFTTransferLines; sno)
                {
                }
                column(Mobile_Phone_No_; "Mobile Phone No.")
                { }
                column(EFTProduct_Type; "Product Type")
                { }

                column(CompanyName; CompanyInformation.Name)
                {
                }
                column(Member_No_; "Member No.")
                { }
                column(Loan_No_; "Loan No.")
                { }
                column(IBAN_No_; "IBAN No.")
                { }
                column(Picture; CompanyInformation.Picture)
                {
                }
                column(Recipient_Reference; "Recipient Reference")
                { }
                column(DocumentNo_EFTTransferLines; "EFT Transfer Lines"."Document No.")
                {
                }
                column(EnteredBy_EFTTransferLines; "EFT Transfer Lines"."Entered By")
                {
                }
                column(AccountType_EFTTransferLines; "EFT Transfer Lines"."Account Type")
                {
                }
                column(AccountNo_EFTTransferLines; "EFT Transfer Lines"."Account No.")
                {
                }
                column(AccountName_EFTTransferLines; "EFT Transfer Lines"."Account Name")
                {
                }
                column(MemberNo_EFTTransferLines; "EFT Transfer Lines"."Member No.")
                {
                }
                column(ExternalAccountName_EFTTransferLines; "EFT Transfer Lines"."External Account Name")
                {
                }
                column(ChargeAmount_EFTTransferLines; "EFT Transfer Lines"."Charge Amount")
                {
                }
                column(DontCharge_EFTTransferLines; "EFT Transfer Lines"."Don't Charge")
                {
                }
                column(PhoneNo_EFTTransferLines; "EFT Transfer Lines"."Phone No.")
                {
                }
                column(Amount_EFTTransferLines; "EFT Transfer Lines".Amount)
                {
                }
                column(AmountText_EFTTransferLines; "EFT Transfer Lines"."Amount Text")
                {
                }
                column(BankCode_EFTTransferLines; "EFT Transfer Lines"."Bank Code")
                {
                }
                column(BranchCode_EFTTransferLines; "EFT Transfer Lines"."Branch Code")
                {
                }
                column(BankName_EFTTransferLines; "EFT Transfer Lines"."Bank Name")
                {
                }
                column(OverDrawn_EFTTransferLines; "EFT Transfer Lines"."Over Drawn")
                {
                }
                column(StandingOrderNo_EFTTransferLines; "EFT Transfer Lines"."Standing Order No")
                {
                }
                column(StandingOrderRegisterNo_EFTTransferLines; "EFT Transfer Lines"."Standing Order Register No")
                {
                }
                column(NotAvailable_EFTTransferLines; "EFT Transfer Lines"."Not Available")
                {
                }
                column(ChargeAccount_EFTTransferLines; "EFT Transfer Lines"."Charge Account")
                {
                }
                column(Transferred_EFTTransferLines; Trans)
                {
                }
                column(ExportFormat_EFTTransferLines; "EFT Transfer Lines".ExportFormat)
                {
                }
                column(ExternalAccountNo_EFTTransferLines; "EFT Transfer Lines"."External Account No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CompanyInformation.Get();
                    CompanyInformation.CalcFields(CompanyInformation.Picture);
                    if "EFT Transfer Lines".Transferred = true then
                        Trans := 'Yes' else
                        Trans := 'No';
                    sno += 1;

                end;
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                ProdDescription := '';

                if FactProd.Get("Product Type") then
                    ProdDescription := FactProd.Description;

                CalcFields("Record Total");
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, ("Record Total"), '');
            end;

            trigger OnPostDataItem()
            begin
                if SendNotification then begin






                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        sno: Integer;
        CompanyInformation: Record "Company Information";
        Trans: Text;
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
        ProdDescription: Text[100];
        FactProd: Record "Product Factory";
        LoansManager: Text[150];
        GeneralManager: Text[150];
        FinanceManager: Text[150];
        CCStoreManager: Text[150];
        SendNotification: Boolean;

}




