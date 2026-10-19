page 50729 "Placed Lien"
{
    ApplicationArea = All;
    Caption = 'Placed Lien';
    PageType = List;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Teller Transaction";
    SourceTableView = where(Type = const(Lien), Posted = const(true), "Cheque Status" = const(Pending), "Approval Status" = filter(<> Rejected));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ToolTip = 'Specifies the value of the Cashier field.';
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                    ApplicationArea = All;
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ToolTip = 'Specifies the value of the Transaction Description field.';
                    ApplicationArea = All;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ToolTip = 'Specifies the value of the Transaction Time field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the approval field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the approval field.';
                    ApplicationArea = All;

                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the approval field.';
                    ApplicationArea = All;

                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the approval field.';
                    ApplicationArea = All;

                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the post field.';
                    ApplicationArea = All;

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Transaction)
            {
                action("Clear Lien")
                {
                    Image = Allocate;
                    ApplicationArea = All;
                    trigger OnAction()

                    var
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                        CollRegister: Record "Collateral Register";
                    begin
                        Rec.TestField(Type, Rec.Type::Lien);
                        if Confirm('Are you sure you want to process the selected transactions?', false) = false then exit;

                        if Rec."External Document No." <> '' then begin
                            CollRegister.Reset();
                            CollRegister.SetRange("No.", Rec."External Document No.");
                            CollRegister.SetRange("Approval Status", CollRegister."Approval Status"::Approved);
                            if CollRegister.FindFirst() then begin
                                Error('This Lien is attached to safe Custody No. %1. Kindly proceed and post it to automatically clear Lien');
                            end;
                        end;

                        if Rec."Approval Status" = Rec."Approval Status"::Posted then
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                        Rec.Modify(true);
                        approvalsMgmt.OnSendTellerTransactionApprovalRequest(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec.TestField(Type, Rec.Type::Lien);
                        approvalsMgmt.OnCancelTellerTransactionApprovalRequest(Rec, true, true);
                    end;

                }

            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Cancel Approval Request_Promoted"; "Cancel Approval Request")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Clear Lien_Promoted"; "Clear Lien")
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



