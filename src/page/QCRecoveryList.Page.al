page 50033 "QC Recovery List"
{
    CardPageID = "Recovery Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Recovery Header";
    SourceTableView = where("Approval Status" = filter(Open | "Pending Approval" | Approved));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                }
                field("Shares Deposits"; Rec."Shares Deposits")
                {
                    ApplicationArea = All;
                }
                field("Application Source"; Rec."Application Source")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {


        }
        area(Processing)
        {
            action("Batch Post")
            {
                Image = ServiceOrderSetup;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    Report.Run(Report::"Purch. Rec.-Post (Yes/No)");
                end;
            }

        }
        area(Reporting)
        {
            action("Generate Entries")
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    Report.Run(Report::"QC Default Recovery");
                end;
            }
            action("Clear Entries")
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustMembr: Record Member;
                    RecHeader: Record "Recovery Header";
                begin
                    RecHeader.SetRange(Posted, false);
                    RecHeader.SetRange("Application Source", Rec."Application Source"::Automated);
                    RecHeader.DeleteAll();
                end;
            }


        }
        area(Promoted)
        {
            group(Category_Report)
            {
                actionref("Batch Post_Promoted"; "Batch Post")
                {
                }
                actionref("Generate Entries_Promoted"; "Generate Entries")
                {
                }
                actionref("Clear Entries_Promoted"; "Clear Entries")
                {
                }
            }
        }

    }
}



