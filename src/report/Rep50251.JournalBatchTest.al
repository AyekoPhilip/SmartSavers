report 50251 "Journal Batch Test"
{
    ApplicationArea = All;
    Caption = 'Journal Batch Test';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/JournalTest.rdl';

    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(AccountCategory; "Account Category")
            { }
            column(AccountDimension; "Account Dimension")
            { }
            column(AccountNo; "Account No.")
            { }
            column(AccountType; "Account Type")
            { }
            column(Amount; Amount)
            { }
            column(BalAccountNo; "Bal. Account No.")
            { }
            column(BalAccountType; "Bal. Account Type")
            { }
            column(CreditAmount; "Credit Amount")
            { }
            column(DebitAmount; "Debit Amount")
            { }
            column(DocumentDate; "Document Date")
            { }
            column(DocumentNo; "Document No.")
            { }
            column(DocumentType; "Document Type")
            { }
            column(JournalBatchName; "Journal Batch Name")
            { }
            column(JournalTemplateName; "Journal Template Name")
            { }
            column(LoanNo; "Loan No.")
            { }
            column(LineNo; "Line No.")
            { }
            column(PostingDate; "Posting Date")
            { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
            { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            { }
            column(TransactionType; "Transaction Type")
            { }
            column(Description; Description)
            { }
            column(AccName; AccName)
            { }
            column(AmountInArrears; AmountInArrears)
            { }
            column(ApplicType; ApplicType)
            { }
            column(AccruedInt; AccruedInt)
            {

            }

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
               // CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
               // CompanyInformation."Home Page";
            end;

            trigger OnAfterGetRecord()
            begin
                AmountInArrears := 0;
                AccruedInt := 0;

                if "Transaction Type" = "Transaction Type"::"Interest Due" then begin
                    AccruedInt := Amount
                end else begin
                    AccruedInt := 0
                end;

                case "Account Type" of
                    "Account Type"::Customer:
                        begin
                            if Accredit.Get("Account No.") then begin
                                AccName := Accredit.Name;
                            end else begin

                                LoanApp.Reset();
                                LoanApp.SetRange("Loan Account", "Account No.");
                                if LoanApp.FindFirst() then begin
                                    AccName := LoanApp."Account Name";
                                    AmountInArrears := LoanApp."Amount In Arrears";
                                end else begin
                                    AmountInArrears := 0;
                                end;
                            end;

                        end;

                end;
                ApplicType := ApplicType::" ";
                RecHeader.Reset();
                RecHeader.SetRange("No.", "Document No.");
                if RecHeader.FindFirst() then begin
                    case RecHeader."Application Type" of
                        RecHeader."Application Type"::"Recovery from Shares":
                            ApplicType := ApplicType::"Recovery from Deposits";
                        RecHeader."Application Type"::"Recover from guarantors":
                            ApplicType := ApplicType::"Recover from guarantors";
                        RecHeader."Application Type"::"Fosa Recovery":
                            ApplicType := ApplicType::"Fosa Recovery";
                        RecHeader."Application Type"::"Place Lien":
                            ApplicType := ApplicType::"Place Lien"

                    end;

                end;
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


        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        AccruedInt: Decimal;
        AccName: Text[150];
        Accredit: Record "Account Credit";
        LoanApp: Record "Loans Categorization";
        LonsCatg: Record "Loans Categorization";
        AmountInArrears: Decimal;
        RecHeader: Record "Recovery Header";
        ApplicType: Option " ","Recovery from Deposits","Recover from guarantors","Place Lien","Fosa Recovery";
}



