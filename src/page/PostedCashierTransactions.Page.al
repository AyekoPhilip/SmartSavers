page 50938 "Posted Cashier Transactions"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Teller Transaction";
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE(Posted = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Transactions)
            {
                Caption = 'Transactions';
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No.")
                {
                    Editable = AccNo;
                    ApplicationArea = All;
                }
                field(mNO; Rec."Member No.")
                {
                    Caption = 'Member No.';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = TransType;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FChequeVisible := false;
                        BChequeVisible := false;
                        BReceiptVisible := false;
                        BOSAReceiptChequeVisible := false;
                        AllAmount := false;
                        DiscCH := false;
                        FLien := false;

                        if Rec.Type = Rec.Type::"Cheque Deposit" then begin
                            FChequeVisible := true;
                            DiscCH := true;
                        end;

                        if Rec.Type = Rec.Type::"Bankers Cheque" then
                            BChequeVisible := true;

                        if Rec.Type = Rec.Type::"Credit Receipt" then begin
                            BReceiptVisible := true;
                            AllAmount := true;
                        end;

                        if Rec.Type = Rec.Type::"Credit Cheque" then begin
                            FChequeVisible := true;
                            BOSAReceiptChequeVisible := true;
                            AllAmount := true;
                        end;

                        if Rec.Type = Rec.Type::Lien then begin
                            FLien := true;
                        end;
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = Amont;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = Currr;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                group(BCheque)
                {
                    Caption = '.';
                    Visible = BChequeVisible;
                    field(Payee; Rec.Payee)
                    {
                        ApplicationArea = All;
                    }
                    field("Post Dated"; Rec."Post Dated")
                    {
                        ApplicationArea = All;
                    }
                    field("Bankers Cheque No"; Rec."Bankers Cheque No")
                    {
                        Caption = 'Bankers Cheque No';
                        ApplicationArea = All;
                    }
                }
                group(BReceipt)
                {
                    Caption = '.';
                    Visible = BReceiptVisible;
                    field("Member No."; Rec."Member No.")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                }
                group("Lien Transaction")
                {
                    Caption = '.';
                    Visible = FLien;
                    field("Expiry Date"; Rec."Expected Maturity Date")
                    {
                        Editable = true;
                        ApplicationArea = All;
                    }
                }
                group(FCheque)
                {
                    Caption = '.';
                    Visible = FChequeVisible;
                    field("Drawee Bank Code"; Rec."Drawee Bank Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Drawee Bank Branch"; Rec."Drawee Bank Branch")
                    {
                        ApplicationArea = All;
                    }
                    field("Cheque Type"; Rec."Cheque Type")
                    {
                        ApplicationArea = All;
                    }
                    field(BchequeNo; Rec."Cheque No")
                    {
                        Caption = ' Cheque No';
                        ApplicationArea = All;
                    }
                    field("Bank Account"; Rec."Bank Account")
                    {
                        Caption = 'Bank';
                        Editable = true;
                        Visible = true;
                        ApplicationArea = All;
                    }
                    field("Cheque Date"; Rec."Cheque Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Cheque Status"; Rec."Cheque Status")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Expected Maturity Date"; Rec."Expected Maturity Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    group(BOSAReceiptCheque)
                    {
                        Caption = '.';
                        Visible = BOSAReceiptChequeVisible;
                    }
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Book Balance"; Rec."Book Balance")
                {
                    ApplicationArea = All;
                }
                field("Available Balance"; Rec."Available Balance")
                {
                    Caption = 'Available Balance';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("New Account Balance"; Rec."New Account Balance")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Deposited By"; Rec.Remarks)
                {
                    Editable = Remarrrks;
                    ApplicationArea = All;
                }
                field("ID No"; Rec."ID No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field("Till Name"; Rec."Till Name")
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Signing Instructions"; Rec."Signing Instructions")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attempted Self Transaction"; Rec."Attempted Self Transaction")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Approved Images"; "Member Picture & Signature")
            {
                Caption = 'Approved Images';
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            systempart(Control13; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control12; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Promoted)
        {
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

    trigger OnAfterGetRecord()
    begin

        FChequeVisible := false;
        BChequeVisible := false;
        BReceiptVisible := false;
        BOSAReceiptChequeVisible := false;
        AllAmount := false;
        DiscCH := false;
        FLien := false;

        if Rec.Type = Rec.Type::"Cheque Deposit" then begin
            FChequeVisible := true;
            DiscCH := true;
        end;

        if Rec.Type = Rec.Type::"Bankers Cheque" then
            BChequeVisible := true;

        if Rec.Type = Rec.Type::"Credit Receipt" then begin
            BReceiptVisible := true;
            AllAmount := true;
        end;

        if Rec.Type = Rec.Type::"Credit Cheque" then begin
            FChequeVisible := true;
            BOSAReceiptChequeVisible := true;
            AllAmount := true;
        end;

        if Rec.Type = Rec.Type::Lien then begin
            FLien := true;
        end;

        SetControlAppearance;
        UpdateControl;
    end;

    trigger OnInit()
    begin
        Temp.Get(UserId);

        Jtemplate := Temp."Cashier Journal Template";
        Jbatch := Temp."Cashier Journal Batch";
        TillNo := Temp."Default  Bank";
        MemberNo := Temp."Account No.";
        Excess := Temp."Excess Account";
        Shortage := Temp."Shortage Account";

        if Jtemplate = '' then begin
            Error(Text0001);
        end;
        if Jbatch = '' then begin
            Error(Text0002);
        end;

        if TillNo = '' then begin
            Error(Text0003);
        end;

        if MemberNo = '' then begin
            Error(Text0004);
        end;

        if Shortage = '' then begin
            Error(Text0005);
        end;

        if Excess = '' then begin
            Error(Text0006);
        end;

        UpdateControl;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Temp.Get(UserId);

        Trans.Reset;
        Trans.SetRange(Trans.Cashier, UserId);
        Trans.SetRange(Trans.Posted, false);
        if Trans.Count > Temp."No of Open Transactions" then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.');
        end;
    end;

    trigger OnOpenPage()
    begin

        if Rec.Posted = true then
            CurrPage.Editable := false;
    end;

    var
        
        FChequeVisible: Boolean;
    
        BChequeVisible: Boolean;
        
        BReceiptVisible: Boolean;
        
        BOSAReceiptChequeVisible: Boolean;
        FLien: Boolean;
        Temp: Record "Banking User Template";
        Jtemplate: Code[20];
        Jbatch: Code[20];
        TillNo: Code[20];
        MemberNo: Code[20];
        Text0001: Label 'Ensure the Cashier journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier journal Batch is set up in Banking User Setup';
        Text0003: Label 'Ensure the Default Bank is set up in Banking User Setup';
        Text0004: Label 'Ensure the Cashier Member no is set up in Banking User Setup';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        AccNo: Boolean;
        TransType: Boolean;
        Amont: Boolean;
        Remarrrks: Boolean;
        AllAmount: Boolean;
        Trans: Record "Teller Transaction";
        Text0005: Label 'Ensure the Cashier Shortage Account is set up in Banking User Setup';
        Text0006: Label 'Ensure the Cashier Excess Account iis set up in Banking User Setup';
        Excess: Code[20];
        Shortage: Code[20];
        Currr: Boolean;
        DiscCH: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;


    procedure UpdateControl()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            AccNo := true;
            TransType := true;
            Remarrrks := true;
            Amont := true;
            Currr := true;
        end;


        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then begin
            AccNo := false;
            TransType := false;
            Remarrrks := false;
            Amont := false;
            Currr := false;
        end;


        if Rec."Approval Status" = Rec."Approval Status"::Rejected then begin
            AccNo := false;
            TransType := false;
            Remarrrks := false;
            Amont := false;
            Currr := false;
        end;

        if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
            AccNo := false;
            TransType := false;
            Remarrrks := false;
            Amont := false;
            Currr := false;

        end;
    end;
}




