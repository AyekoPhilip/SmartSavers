report 50370 "Loan Minutes"
{
    ApplicationArea = All;
    Caption = 'Loan Minutes';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoanMinutesReport.rdl';
    dataset
    {
        dataitem(LoansCategorization; Loans)
        {
            RequestFilterFields = "No.", "Account No.", "Product Type";
            DataItemTableView=where("Outstanding Balance"=filter(>0));
            column(No; "No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(RequestedAmount; "Requested Amount")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(Installments; Installments)
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(MinuteNo; MinuteNo)
            { }
            column(Outstanding_Balance; "Outstanding Balance")
            { }

            column(Appraiser; Appraiser)
            {
            }
            column(ApproverI; ApproverI)
            { }
            column(ApproverII; ApproverII)
            { }
            column(ApproverIII; ApproverIII)
            { }
            column(ApprovalDate; ApprovalDate)
            {

            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                MinuteNo := '';
                ApproverI := '';
                ApproverII := '';
                ApprovalDate := 0D;
                Appraiser := '';

                if "Product Type" = 'MSACCOLN' then begin
                    MinuteNo := '';
                    ApproverII := '';
                    ApproverI := "Captured By";
                    Appraiser := "Captured By";
                    ApprovalDate := "Disbursement Date";

                end else begin

                    Loans.Reset();
                    Loans.SetRange("No.", "Application No.");
                    if Loans.FindFirst() then begin
                        Appraiser := Loans."Captured By";
                    end;

                    MinuteNo := "Minute No.";

                    PostedAppEntry.Reset();
                    PostedAppEntry.SetRange("Document No.", Loans."No.");
                    PostedAppEntry.SetRange(Status, PostedAppEntry.Status::Approved);
                    if PostedAppEntry.FindFirst() then begin
                        ApproverI := PostedAppEntry."Approver ID";
                    end;

                    PostedAppEntry.Reset();
                    PostedAppEntry.SetRange("Document No.", Loans."No.");
                    PostedAppEntry.SetRange(Status, PostedAppEntry.Status::Approved);
                    if PostedAppEntry.FindLast() then begin
                        ApproverII := PostedAppEntry."Approver ID";
                        ApprovalDate := DT2Date(PostedAppEntry."Last Date-Time Modified");
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
        Loans: Record "Loan Application";
        MinuteNo: Code[20];
        PostedAppEntry: Record "Posted Approval Entries";
        Appraiser: Code[100];
        ApproverI: Code[100];
        ApproverII: Code[100];
        ApproverIII: Code[100];
        ApprovalDate: Date;
}



