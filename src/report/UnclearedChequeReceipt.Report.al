report 50257 "Uncleared Cheque Receipt"

{
    ApplicationArea = All;
    Caption = 'Uncleared Cheque Receipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/UnclearedChequeReceipt.rdl';

    dataset
    {
        dataitem(ReceiptsHeader; "Receipts Header")
        {
            column(No; "No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(OnBehalfOf; "On Behalf Of")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(AmountRecieved; "Amount Recieved")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(Cashier; Cashier)
            {
            }
            column(ChequeNo; "Cheque No.")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(Date; "Date")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(ReceivedFrom; "Received From")
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(CompInformation; CompanyInformation.Name)
            {
            }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyTelephone; CompanyTelephone)
            {
            }
            column(CommunicationOnline; CommunicationOnline)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(StaffNo; StaffNo)
            {
            }
            column(CustAddress; CustAddress)
            {
            }
            column(EmailAddress; CustEmail)
            {
            }
            column(SavingsAccountName; SavingsAccountName)
            {

            }
            column(NumberText; NumberText[1])
            {

            }
            column(EntrNo; EntrNo)
            {

            }
            dataitem("Receipt Line"; "Receipt Line")
            {
                DataItemLink = No = FIELD("No.");
                column(LineNo; No)
                {

                }
                column(lineAmount; Amount)
                {

                }
                column(LineAccount_Type; "Account Type")
                {

                }
                column(LineAccount_No_; "Account No.")
                {

                }
                column(LineAccount_Name; "Account Name")
                {

                }
                column(Pay_Mode; "Pay Mode")
                {

                }
                column(Loan_No_; "Loan No.")
                {

                }
                column(Transaction_Type; "Transaction Type")
                {

                }
                column(Product_Type; "Product Type")
                {

                }

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
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
                SavingsAccountName := '';
                BalanceBF := 0;
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;
                EntrNo := EntrNo + 1;

            end;

            trigger OnAfterGetRecord()
            begin
                if CustRec.Get("Member No.") then begin
                    SavingsAccountName := CustRec.Name;
                    CustEmail := CustRec."E-Mail";
                    CustAddress := CustRec."Current Address";
                    StaffNo := CustRec."Payroll/Staff No.";
                    EntrNo := EntrNo + 1;
                end;
                CalcFields("Total Amount");
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, "Total Amount", '');
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
        BalanceBF: Decimal;
        CName: Text[150];
        AppAmount: Decimal;
        Disdate: Date;
        OutBal: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        StartDate: Date;
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
        EndDate: Date;
        StaffNo: Code[10];
        CustAddress: Code[100];
        CustEmail: Text[100];
        CustRec: Record Member;
        EntrNo: Integer;
}



