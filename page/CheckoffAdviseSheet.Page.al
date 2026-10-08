page 50738 "Checkoff Advise Sheet"
{
    Caption = 'Checkoff Advise Sheet';
    PageType = Worksheet;
    SourceTable = "Checkoff Advice Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Advice Date"; Rec."Advice Date")
                {
                    ToolTip = 'Specifies the value of the Advice Date field.';
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ToolTip = 'Specifies the value of the Employer Code field.';
                    ApplicationArea = All;
                }
                field("Advice Method"; Rec."Advice Method")
                {
                    ToolTip = 'Specifies the value of the Advice Method field.';
                    ApplicationArea = All;
                }
            }
            repeater(Line)
            {
                Editable = false;
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                    ApplicationArea = All;
                }

                field("Payroll Staff No."; Rec."Payroll Staff No.")
                {
                    ToolTip = 'Specifies the value of the Payroll Staff No. field.';
                    ApplicationArea = All;
                }
                field(Names; Rec.Names)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;

                }
                field("Amount On"; Rec."Amount On")
                {
                    ToolTip = 'Specifies the value of the Amount On field.';
                    ApplicationArea = All;
                    Caption = 'Amount On';
                }

                field("Amount Off"; Rec."Amount Off")
                {
                    ToolTip = 'Specifies the value of the Amount Off field.';
                    ApplicationArea = All;
                    Caption = 'Amount Off';
                }

                field("Balance Off"; Rec."Balance Off")
                {
                    ToolTip = 'Specifies the value of the Balance Off field.';
                    ApplicationArea = All;
                }
                field("Balance On"; Rec."Balance On")
                {
                    ToolTip = 'Specifies the value of the Balance On field.';
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    ApplicationArea = All;
                }
                field("Advice Type"; Rec."Advice Type")
                {
                    ToolTip = 'Specifies the value of the Advice Type field.';
                    ApplicationArea = All;
                }

            }
        }

        area(factboxes)
        {

            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
            part(WorkflowStatusBatch; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Batch Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = true;
            }
            part(WorkflowStatusLine; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Line Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = true;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }

    }
    actions
    {
        area(Processing)
        {
            group("F&unctions")

            {
                Caption = 'F&unctions';
                Image = HRSetup;
                action("Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Visible = false;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        Report.Run(Report::"Member Advice Analysis");
                        CurrPage.Update(false);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F9';


                    trigger OnAction()
                    var
                    begin
                        Report.Run(Report::"Member Advice Analysis");
                        CurrPage.Update(false);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ShortCutKey = 'Ctrl+Alt+F9';
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    begin
                        Report.Run(Report::"Member Advice Analysis");
                        CurrPage.Update(false);
                    end;
                }
                action(PostAndPrint)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                    trigger OnAction()
                    begin
                        Report.Run(Report::"Member Advice Analysis");
                        CurrPage.Update(false);
                    end;
                }

            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Post_Promoted; Post)
                {
                }
                actionref(PostAndPrint_Promoted; PostAndPrint)
                {
                }
                actionref(Preview_Promoted; Preview)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Loan File', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Associated Accounts', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }

    }
}



