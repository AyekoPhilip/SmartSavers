report 50195 "Member Loan Guaranteed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MemberLoanGuaranteed.rdl';
    Caption = 'Member Loan Guaranteed';
    ApplicationArea = All;

    dataset
    {
        dataitem(AccountBanking; Member)
        {
            RequestFilterFields = "No.";
            column(MemberNo_AccountBanking; AccountBanking."No.")
            {
            }
            column(ProductType_AccountBanking; AccountBanking."Employer Code")
            {
            }
            column(ProductName_AccountBanking; AccountBanking."E-Mail")
            {
            }
            column(MobileNo_AccountBanking; AccountBanking."Mobile Phone No")
            {
            }
            column(No_AccountBanking; "No.")
            {
            }
            column(Name_AccountBanking; Name)
            {
            }
            column(PhoneNo_AccountBanking; AccountBanking."Phone No.")
            {
            }
            column(GlobalDimension1Code_AccountBanking; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_AccountBanking; "Global Dimension 2 Code")
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
            column(EmailAddress; AccountBanking."E-Mail")
            {
            }

            dataitem("Guarantor & Security Posted"; "Guarantor & Security Posted")
            {
                DataItemLink = "Member No." = field("No.");
                DataItemTableView= where("Outstanding Balance"=filter('>0'));
                column(No_; "Loan No.")
                { }
                column(No__of_Loans_Guaranteed; "No. of Loans Guaranteed")
                { }
                column(Member_No___Loanee_; "Member No. (Loanee)")
                { }
                column(Outstanding_Balance; "Outstanding Balance")
                { }
                column(Product_Type; "Product Type")
                { }
                column(CName; CName)
                { }
                column(Amount_Guaranteed; "Amount Guaranteed")
                { }
                column(Deposit_Shares; "Deposit Shares")
                { }
                column(Substituted; GuarantStatus)
                { }
                column(AppAmount; AppAmount)
                { }
                column(Disdate; Disdate)
                { }
                column(OutBal; OutBal)
                { }
                trigger OnAfterGetRecord()
                var
                    Loans: Record Loans;

                begin
                    case Substituted of
                        true:
                            GuarantStatus := GuarantStatus::Substituted else
                                                                            GuarantStatus := GuarantStatus::Active;
                    end;
                    CName := '';
                    AppAmount := 0;
                    Disdate := 0D;
                    OutBal := 0;


                    if Loans.Get("Loan No.") then begin
                        Loans.CalcFields("Outstanding Balance");
                        "Product Type" := Loans."Product Description";
                        CName := Loans."Account Name";
                        AppAmount := loans."Approved Amount";
                        Disdate := Loans."Disbursement Date";
                        OutBal := Loans."Outstanding Balance";

                    end;

                    if "Security Type" = "Security Type"::Guarantor then begin
                        BosaCred.Reset();
                        BosaCred.SetRange("No.", "Guarantor & Security Posted"."Account No.");
                        if BosaCred.FindFirst() then begin
                            BosaCred.CalcFields("Balance (LCY)");
                            "Guarantor & Security Posted"."Deposit Shares" := BosaCred."Balance (LCY)"
                        end;
                    end;
                    
                 

                end;
            }

            trigger OnAfterGetRecord()
            begin

            end;

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
                if StartDate = 0D then StartDate := 20020101D;
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
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';
                    ApplicationArea = All;
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
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
        PLoan: Record Loans;
        GuarantStatus: Option " ",Active,Substituted;
}




