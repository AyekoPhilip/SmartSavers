report 50190 "Certificate of Deposit"
{
    ApplicationArea = All;
    Caption = 'Certificate of Deposit';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CertificateOfDeposit.rdl';
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
            column(NegInterestRate; "Neg. Interest Rate")
            {
            }
            column(FDDuration; "FD Duration")
            {
            }
            column(FDMaturityDate; "FD Maturity Date")
            {
            }
            column(FDMaturityInstructions; "FD Maturity Instructions")
            {
            }
            column(FixedDepositAmount; "Fixed Deposit Amount")
            {
            }
            column(FixedDepositType; "Fixed Deposit Type")
            {
            }
            column(IDPassportNo; "ID/Passport No.")
            {
            }
            column(Registration_Date; "Registration Date")
            {

            }
            column(Application_No_; "Application No.")
            {

            }
            column(SavingsAccountNo; "Savings Account No.")
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(InterestExpected; InterestExpected)
            {

            }
            column(WthTax; WthTax)
            {

            }
            column(NumberText; NumberText[1])
            {

            }
            column(Balance__LCY_; "Balance (LCY)")
            {

            }
            column(Neg__Interest_Rate; "Neg. Interest Rate")
            {

            }
            column(RefNo; RefNo)
            {

            }
            column(WtaxRate; WtaxRate)
            {

            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                CalcFields("Balance (LCY)");
                ProdFact.Get("Product Type");
                ProdFact.TestField("WithHolding Tax");
                WthTax := 0;
                InterestExpected := 0;
                WtaxRate := 0;
                WtaxRate := ProdFact."WithHolding Tax";
                Gensetup.Get();
                Gensetup.TestField("Excise Duty (%)");
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, "Balance (LCY)", '');
                InterestExpected := BnkPMngt.CalculateFDInterest(AccountBanking, AccountBanking."Registration Date", 0);
                WthTax := Round((InterestExpected * (ProdFact."WithHolding Tax" / 100)), 1, '=');
                RefNo := AccountBanking."No." + '/' + Format(AccountBanking."Registration Date");
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
        CheckReport: Report Check;
        NumberText: array[2] of Text[150];
        RefNo: Code[100];
        InterestExpected: Decimal;
        WthTax: Decimal;
        FdType: Code[20];
        DuratinFD: Code[20];
        MaturityD: Code[20];
        Rate: Decimal;
        Gensetup: Record "General Set-Up";
        ProdFact: Record "Product Factory";
        BnkPMngt: Codeunit "Banking Procedure Mngt.";
        WtaxRate: Decimal;
}



