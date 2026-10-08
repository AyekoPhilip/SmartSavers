page 51048 "Credit Mngt. Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Registry Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(Accounts)
            {
                field("New Members"; Rec."New Members")
                {
                    ApplicationArea = All;
                }
                field("Active Members"; Rec."Active Members")
                {
                    ApplicationArea = All;
                }
                field("Dormant Members"; Rec."Dormant Members")
                {
                    ApplicationArea = All;
                }
                field("Active Accounts"; Rec."Active Accounts")
                {
                    ApplicationArea = All;
                }
                field("Dormant Accounts"; Rec."Dormant Accounts")
                {
                    ApplicationArea = All;
                }

            }
            cuegroup(Applications)
            {
                Caption = 'Applications';

                field("Member Pending Approval"; Rec."Member Pending Approval")
                {
                    ApplicationArea = All;
                }
                field("Application Pending"; Rec."Application Pending")
                {
                    ApplicationArea = All;
                }
                field("Changes Pending"; Rec."Changes Pending")
                {
                    ApplicationArea = All;
                }
            }
            cuegroup(Approvals)
            {
                Caption = 'Approvals';
                Visible = true;
                field("Request to Approve"; Rec."Request to Approve")
                {
                    ApplicationArea = All;
                    Caption = 'Requests to Approve';
                    DrillDownPageID = "Request to Approve";
                    ToolTip = 'Specifies the value of the Requests to Approve field';
                }
                field("Requests to Approve"; Rec."Requests to Approve")
                {
                    ApplicationArea = All;
                    Caption = 'Workflows to Approve';
                    DrillDownPageID = "Requests to Approve";
                    ToolTip = 'Specifies the value of the Requests to Approve field';
                }
                field("Requests Sent for Approval"; Rec."Requests Sent for Approval")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Approval Request Entries";
                    ToolTip = 'Specifies the value of the Requests Sent for Approval field';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetFilter("Due Date Filter", '<=%1', WorkDate);
        Rec.SetFilter("Overdue Date Filter", '<%1', WorkDate);
        Rec.SetRange("User ID Filter", UserId);
        ShowCheckForOCR := OCRServiceMgt.OcrServiceIsEnable;
    end;

    var
        OCRServiceMgt: Codeunit "OCR Service Mgt.";
        ShowCheckForOCR: Boolean;
}




