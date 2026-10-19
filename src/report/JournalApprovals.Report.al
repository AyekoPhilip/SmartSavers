report 50014 "Journal Approvals"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/JournalApprovals.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.", "Posting Date", "User ID";

            column(GLAccountNo_GLEntry; "G/L Entry"."G/L Account No.")
            {
            }
            column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
            {
            }
            column(DocumentType_GLEntry; "G/L Entry"."Document Type")
            {
            }
            column(DocumentNo_GLEntry; "G/L Entry"."Document No.")
            {
            }
            column(Description_GLEntry; "G/L Entry".Description)
            {
            }
            column(BalAccountNo_GLEntry; "G/L Entry"."Bal. Account No.")
            {
            }
            column(Amount_GLEntry; "G/L Entry".Amount)
            {
            }
            column(UserID_GLEntry; "G/L Entry"."User ID")
            {
            }
            column(SourceType_GLEntry; "G/L Entry"."Source Type")
            {
            }
            column(SourceNo_GLEntry; "G/L Entry"."Source No.")
            {
            }
            column(Appr1; Approver[1])
            {
            }
            column(Appr2; Approver[2])
            {
            }
            column(Appr3; Approver[3])
            {
            }
            column(Appr4; Approver[4])
            {
            }
            column(AppDate1; ApproverDate[1])
            {
            }
            column(AppDate2; ApproverDate[2])
            {
            }
            column(AppDate3; ApproverDate[3])
            {
            }
            column(AppDate4; ApproverDate[4])
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyWebsite; CompanyInfo."E-Mail")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Approvals
                ApprovalEntries.Reset();
                ApprovalEntries.SetRange("Document No.", "G/L Entry"."Document No.");
                ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                if ApprovalEntries.Find('-') then begin
                    i := 0;
                    repeat
                        i := i + 1;

                        if i = 1 then begin
                            Approver[1] := ApprovalEntries."Sender ID";
                            ApproverDate[1] := ApprovalEntries."Date-Time Sent for Approval";

                            Approver[2] := ApprovalEntries."Approver ID";
                            ApproverDate[2] := ApprovalEntries."Last Date-Time Modified";
                        end;

                        if i = 2 then begin
                            Approver[3] := ApprovalEntries."Approver ID";
                            ApproverDate[3] := ApprovalEntries."Last Date-Time Modified";
                        end;

                        if i = 3 then begin
                            Approver[4] := ApprovalEntries."Approver ID";
                            ApproverDate[4] := ApprovalEntries."Last Date-Time Modified";
                        end;
                    until ApprovalEntries.Next() = 0;
                end else begin
                    PostedApprovalEntry.Reset();
                    PostedApprovalEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                    PostedApprovalEntry.SetRange(Status, PostedApprovalEntry.Status::Approved);
                    if PostedApprovalEntry.Find('-') then begin
                        i := 0;
                        repeat
                            i := i + 1;
                            if i = 1 then begin
                                Approver[1] := PostedApprovalEntry."Sender ID";
                                ApproverDate[1] := PostedApprovalEntry."Date-Time Sent for Approval";

                                Approver[2] := PostedApprovalEntry."Approver ID";
                                ApproverDate[2] := PostedApprovalEntry."Last Date-Time Modified";
                            end;

                            if i = 2 then begin
                                Approver[3] := PostedApprovalEntry."Approver ID";
                                ApproverDate[3] := PostedApprovalEntry."Last Date-Time Modified";
                            end;

                            if i = 3 then begin
                                Approver[4] := PostedApprovalEntry."Approver ID";
                                ApproverDate[4] := PostedApprovalEntry."Last Date-Time Modified";
                            end;
                        until PostedApprovalEntry.Next() = 0;
                    end;
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

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ApprovalEntries: Record "Approval Entry";
        CompanyInfo: Record "Company Information";
        PostedApprovalEntry: Record "Posted Approval Entry";
        Approver: array[10] of Code[50];
        ApproverDate: array[10] of DateTime;
        i: Integer;
}


