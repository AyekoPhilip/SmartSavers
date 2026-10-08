page 50883 "Cheque Clearance"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Teller Transaction";
    SourceTableView = WHERE(Posted = CONST(true),
                            Type = FILTER("Credit Cheque" | "Cheque Deposit"),
                            "Cheque Status" = FILTER(Pending));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                ShowCaption = false;
                field(No; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    Caption = 'Transaction';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    Caption = 'Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    Caption = 'Time';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Expected Maturity Date"; Rec."Expected Maturity Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field("Date Cleared"; Rec."Date Cleared")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cleared By"; Rec."Cleared By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(View)
            {
                Caption = 'View';
                action("Account Card")
                {
                    Caption = 'Account Card';
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            action(Process)
            {
                Caption = 'Process';
                Image = PutawayLines;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SaccoT: Codeunit "Gen.Jnl.-Post Line";
                begin
                    if Confirm(MsgOnDialogTxt, false) = true then begin

                        Transactions.Reset;
                        Transactions.SetRange(Transactions.Select, true);
                        if Transactions.Find('-') then
                            repeat
                                if Rec."Expected Maturity Date" <= Today then begin
                                    Transactions."Cheque Status" := Transactions."Cheque Status"::Honoured;
                                    Transactions."Date Cleared" := Today;
                                    Transactions.Modify;
                                end;


                            until Transactions.Next = 0;
                        Message(MsgOnCompletionTxt);

                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Process_Promoted; Process)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Budgetary Control', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Category10_caption', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    var
        Transactions: Record "Teller Transaction";
        MsgOnDialogTxt: Label 'Are you sure you want to process the selected transactions?';
        MsgOnCompletionTxt: Label 'The selected transactions have been processed';
}




