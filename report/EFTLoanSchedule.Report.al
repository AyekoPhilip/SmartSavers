report 50385 "EFT Loan Schedule"
{
    ApplicationArea = All;
    Caption = 'EFT Loan Schedule';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/EFTLoanSchedule.rdl';
    dataset
    {
        dataitem("EFT Transfer Lines"; "EFT Transfer Lines")
        {
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(Payment_Destination; "Payment Destination")
            { }
            column(Payment_Destination_Code; "Payment Destination Code")
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(EFT_Options; "EFT Options")
            { }
            column(Mobile_Phone_No_; "Mobile Phone No.")
            { }
            column(PartialLoanNo; "Partial Loan No.")
            { }
            column(Document_No_; "Document No.")
            { }
            column(ApproveAmt; ApproveAmt)
            { }
            column(Amount; Amount)
            { }
            column(Bank_Code; "Bank Code")
            { }
            column(External_Account_Name; "External Account Name")
            { }
            column(External_Account_No_; "External Account No.")
            { }
            column(Bank_Name; "Bank Name")
            { }
            column(RemaingAmt; RemaingAmt)
            { }
            dataitem(Loans; Loans)
            {
                DataItemLink = "No." = field("Loan No.");
                column(No; "No.")
                {
                }
                column(AccountNo; "Account No.")
                {
                }
                column(AccountName; "Account Name")
                {
                }
                column(AmounttoDisburse; "Amount to Disburse")
                {
                }
                column(ApplicationDate; "Application Date")
                {
                }
                column(ApplicationNo; "Application No.")
                {
                }
                column(ApprovedAmount; "Approved Amount")
                {
                }
                column(OutstandingBalance; "Outstanding Balance")
                {
                }
                column(PaymentDestination; "Payment Destination")
                {
                }
                column(PaymentDestinationCode; "Payment Destination Code")
                {
                }
                column(ProductDescription; "Product Description")
                {
                }
                column(ProductType; "Product Type")
                {
                }
                column(RecommendedAmount; "Recommended Amount")
                {
                }
                column(RequestedAmount; "Requested Amount")
                {
                }
                column(TotalTopUp; "Total TopUp")
                {
                }
                column(LoanPaymentDestination; "Loan Payment Destination")
                {
                }
                column(DisbursementAccountNo; "Disbursement Account No.")
                {
                }
                column(NetAmount; NetAmount)
                { }
                column(Mode_of_Disbursement; "Mode of Disbursement")
                { }
                column(PChargeAmt; PChargeAmt)
                { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                var

                begin
                    NetAmount := 0;
                    if AccBanking.Get("Disbursement Account No.") then begin
                        AccBanking.CalcFields("Balance (LCY)");
                        if "Mode of Disbursement" = "Mode of Disbursement"::"Full Disbursement" then begin
                            NetAmount := AccBanking."Balance (LCY)";
                        end else begin
                            NetAmount := ApproveAmt
                        end;

                    end;

                    PChargeAmt := 0;

                    case TLoans."Mode of Disbursement" of
                        TLoans."Mode of Disbursement"::"Full Disbursement":
                            begin
                                OtherCommitment.Reset();
                                OtherCommitment.SetRange("Application No.", TLoans."Application No.");
                                if OtherCommitment.Find('-') then begin
                                    repeat
                                        PChargeAmt := 0;
                                        Loans."Total TopUp" := 0;
                                    until OtherCommitment.Next() = 0;
                                end else begin
                                    LoanCharge.Reset();
                                    LoanCharge.SetRange("Application No.", "Application No.");
                                    if LoanCharge.FindSet() then begin
                                        repeat

                                            if LoanCharge."Use Percentage" then begin
                                                case LoanCharge."Charge Type" of
                                                    LoanCharge."Charge Type"::"Top up":
                                                        begin
                                                            PChargeAmt := PChargeAmt + Round(("Total TopUp" * (LoanCharge.Percentage / 100)), 0.5, '=')
                                                        end;
                                                    LoanCharge."Charge Type"::General:
                                                        begin
                                                            PChargeAmt := PChargeAmt + Round(("Approved Amount" * (LoanCharge.Percentage / 100)), 0.5, '=');
                                                        end;
                                                    LoanCharge."Charge Type"::Boosting:
                                                        begin
                                                            PChargeAmt := PChargeAmt + Round(("Deposit Purchase" * (LoanCharge.Percentage / 100)), 0.5, '=');
                                                        end;
                                                end
                                            end else begin
                                                PChargeAmt := PChargeAmt + LoanCharge."Charge Amount";
                                            end;
                                        until LoanCharge.Next() = 0;
                                    end;
                                end;
                            end else begin
                            PChargeAmt := 0;
                            Loans."Total TopUp" := 0;
                        end;
                    end;
                end;

                trigger OnPostDataItem()
                begin

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
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                ///CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                ApproveAmt := 0;
                AmountPosted := 0;

                if TLoans.Get("Loan No.") then begin
                    TLoans.CalcFields("Total Amount Disbursed");
                    AmountPosted := TLoans."Approved Amount";

                    case TLoans."Mode of Disbursement" of
                        TLoans."Mode of Disbursement"::"Full Disbursement":
                            begin

                                OtherCommitment.Reset();
                                OtherCommitment.SetRange("Application No.", TLoans."Application No.");
                                if OtherCommitment.Find('-') then begin
                                    ApproveAmt := OtherCommitment.Amount;
                                    RemaingAmt := 0;


                                end else begin
                                    ApproveAmt := TLoans."Approved Amount";
                                    RemaingAmt := 0;
                                end;

                            end else begin
                            PartialLoan.Reset();
                            PartialLoan.SetRange("Entry No", "Partial Loan No.");
                            if PartialLoan.FindFirst() then begin
                                ApproveAmt := PartialLoan.Amount;
                                RemaingAmt := (TLoans."Approved Amount" - TLoans."Total Amount Disbursed")
                            end;
                        end;
                    end;
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
        AccBanking: Record "Account Banking";
        NetAmount: Decimal;
        PChargeAmt: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        LoanCharge: Record "Loan Application Charge";
        PartialLoan: Record "Partial Disbursement Schedule";
        ApproveAmt: Decimal;
        ProductType: Text[150];
        TLoans: Record Loans;
        RemaingAmt: Decimal;
        AmountPosted: Decimal;
        OtherCommitment: Record "Other Commitements Clearance";
}
