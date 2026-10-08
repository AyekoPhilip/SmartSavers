report 50279 "Account Closure Report"
{
    ApplicationArea = All;
    Caption = 'Account Closure Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/AccountClosure.rdl';

    dataset
    {
        dataitem(Membershipclosure; "Membership closure")
        {
            DataItemTableView = where(Posted = const(true), "Document Type" = filter("Account Closure"));
            RequestFilterFields = "No.";
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
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(BenevolentFund; "Benevolent Fund")
            {
            }
            column(CloseAccount; "Close Account")
            {
            }
            column(ClosingDate; "Closing Date")
            {
            }
            column(ClosureType; "Closure Type")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(DepositRefundable; "Deposit Refundable")
            {
            }
            column(EarlyExitCharges; "Early Exit Charges")
            {
            }
            column(EnteredBy; "Entered By")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(IncludeCharges; "Include Charges")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(LoansOption; "Loans Option")
            {
            }
            column(MemberName; "Member Name")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MemberSavings; "Member Savings")
            {
            }
            column(No; "No.")
            {
            }
            column(NoticeMDate; "Notice M. Date")
            {
            }
            column(NoticeNo; "Notice No.")
            {
            }
            column(OtherCharges; "Other Charges")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(ProductFactory; "Product Factory")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(SharesCapital; "Shares Capital")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(TotalAmountLCY; "Total Amount (LCY)")
            {
            }
            column(TotalInterest; "Total Interest")
            {
            }
            column(TotalLoan; "Total Loan")
            {
            }
            column(Transaction; Transaction)
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(ReasonText; ReasonText)
            {

            }
            column(ProductDescription;ProductDescription){}
            column(Producttype;Producttype){}
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
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                //CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                if NoticeRec.Get("Notice No.") then
                    ReasonText := NoticeRec."Description For Withdrawal" else
                    ReasonText := '';
                closureline.Reset();
                closureLine.SetRange("No.", "No.");
                closureLine.SetRange("Product Class", closureLine."Product Class"::Account);
                if closureLine.FindFirst() then
                    if Loantype.Get(closureLine."Product Type") then
                        Producttype := closureLine."Product Type";
                ProductDescription := Loantype.Description

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
        closureLine: Record "Account Closure Line";
        Loantype: Record "Product Factory";
        NoticeRec: Record "Member withdrawal Notice";
        ProductDescription: Text[150];
        ReasonText: Text[200];
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        Producttype: Code[20];
}



