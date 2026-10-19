report 50196 "Member Loan Guarantors"
{
    ApplicationArea = All;
    Caption = 'Member Loan Guarantors';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MemberLoanGuarantors.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = where("Approval Status" = const(Posted),"No."=filter(<>''),"Outstanding Balance"=filter('>0'));
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(No_; "No.")
            {
            }
            column(Product_Type; "Product Type")
            {

            }
            column(Product_Description; "Product Description")
            { }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingInsurance; "Outstanding Insurance")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(OutstandingBill; "Outstanding Bill")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(Installments; Installments)
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
            dataitem("Guarantor & Security Posted"; "Guarantor & Security Posted")
            {
                DataItemLink = "Loan No." = field("No.");

                column(Loan_No_; "Loan No.")
                {}
                column(Account_No_; "Account No.")
                {}
                column(Amount_Guaranteed; "Amount Guaranteed")
                {}
                column(Deposit_Shares; "Deposit Shares")
                { }
                column(Member_No_; "Member No.")
                { }
                column(Member_No___Loanee_;"Member No. (Loanee)")
                {}
                column(No__of_Loans_Guaranteed; "No. of Loans Guaranteed")
                {}
                column(Name; Name)
                { }
                column(Product_TypeG; "Product Type")
                { }
                column(Substituted;GuarantStatus)
                {
                    
                }
                trigger OnAfterGetRecord()
                begin

                    case Substituted of
                        true:
                            GuarantStatus := GuarantStatus::Substituted else
                                                                            GuarantStatus := GuarantStatus::Active;
                    end;

                    if "Security Type"="Security Type"::Guarantor then begin
                    BosaCred.Reset();
                    BosaCred.SetRange("No.","Guarantor & Security Posted"."Account No.");
                    if BosaCred.FindFirst() then begin
                        BosaCred.CalcFields("Balance (LCY)");
                        "Guarantor & Security Posted"."Deposit Shares":=BosaCred."Balance (LCY)"
                    end;
                    end;
                    if PLoan.Get("Guarantor & Security Posted"."Loan No.") then
                    "Guarantor & Security Posted"."Product Type":=PLoan."Product Description";
                end;

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
        EndDate: Date;
        StaffNo: Code[10];
        CustAddress: Code[100];
        BosaCred: Record "Account Credit";
        PFact: Record "Product Factory";
        PLoan:Record Loans;
        GuarantStatus: Option " ",Active,Substituted;

}



