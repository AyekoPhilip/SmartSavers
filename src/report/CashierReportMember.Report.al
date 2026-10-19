namespace DynamicsNav.SaccoDatabase;

using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;

report 50022 "Cashier Report-Member"
{
    ApplicationArea = All;
    Caption = 'Cashier Report-Member';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CashierReceiptMember.rdl';
    dataset
    {
        dataitem(ReceiptsHeader; "Receipts Header")
        {
            RequestFilterFields="No.";
            DataItemTableView=where(Posted=filter(true));
            column(No; "No.")
            {
            }
            column(CompanyInformation; CompanyInformation.Name)
            { }
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
            column(MemberName;MemberName)
            {}
            column(BalanceLCY;BalanceLCY[1])
            {}
            column(LoanBalance;BalanceLCY[2])
            {}
            column(MemberNo; "Member No.")
            {
            }
            column(ChequeNo; "Cheque No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(AmountRecieved; "Amount Recieved")
            {
            }
            column(TotalAmount; "Total Amount")
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
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin

                MemberName :='';
                BalanceLCY[1] := 0;
                BalanceLCY[2] := 0;
                BalanceLCY[1] := RegMngt.fngetAccountBalance("Member No.", Enum::ProductAccountCategory::"Shares Deposit");
                BalanceLCY[2] := RegMngt.fngetAccountBalance("Member No.", Enum::ProductAccountCategory::Loan);
                if CustomerRec.Get("Member No.") then begin
                    MemberName:=CustomerRec.Name
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

        BalanceLCY: array[9] of Decimal;
        RegMngt: Codeunit "Register Management";
        SharesCapital: Decimal;
        CustAge: Integer;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        DepMultiplier: array[5] of Decimal;
        CustEmail: Text[150];
        Employer: Record Customer;
        MemberName: Text[150];
        CustomerRec: Record Member;
        BalanceBF: Decimal;
        CName: Text[150];
        EmpName: Text;
        LastDepositDate: Date;
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
        LoanGuarantTotal: Decimal;
        LastTransDate: Date;

        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[100];
        ProductType: Record "Product Factory";
        MembershipAge: Integer;
        BankingAcc: Record "Account Banking";
        CredAcc: Record "Account Credit";
        LoansT: Record Loans;
        AccType: Enum ProductAccountCategory;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
}
