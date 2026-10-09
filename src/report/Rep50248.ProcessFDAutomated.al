report 50248 "Process FD Automated"
{
    ApplicationArea = All;
    Caption = 'Process FD Automated';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(AccountBanking; "Account Banking")
        {
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(FixedDepositType; "Fixed Deposit Type")
            { }
            column(FixedDepositAmount; "Fixed Deposit Amount")
            { }
            trigger OnPreDataItem()
            begin
                Temp.Get(UserId);
                Temp.TestField("Periodic Journal Batch");
                Temp.TestField("Periodic Journal Template");
                JTemplate := Temp."Periodic Journal Template";
                JBatch := Temp."Periodic Journal Batch";
                IF RunDate = 0D then
                    RunDate := Today;
                if PostAs = PostAs::" " then PostAs := PostAs::"Post Application";
                PostPremty := false;
            end;

            trigger OnAfterGetRecord()
            begin
                case "FD Maturity Instructions" of
                    "FD Maturity Instructions"::"Transfer all to Savings":
                        FDManagement.RollOver(AccountBanking, RunDate, JTemplate, JBatch, 1, PostPremty);
                    "FD Maturity Instructions"::"Renew Principal":
                        FDManagement.Renew(AccountBanking, RunDate, JTemplate, JBatch, 1, PostPremty);
                    "FD Maturity Instructions"::"Renew Principal & Interest":
                        FDManagement.CloseNonRenewable(AccountBanking, RunDate, JTemplate, JBatch, 1, PostPremty);
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
        FDManagement: Codeunit "Banking Procedure Mngt.";
        RunDate: Date;
        JTemplate: Code[20];
        JournalLine: Record "Gen. Journal Line";
        Temp: Record "Banking User Template";
        JBatch: Code[20];
        InterestBuffer: Record "Interest Buffer";
        PostAs: Option " ","Generate Batch","Post Application";
        PostPremty: Boolean;

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;
}



