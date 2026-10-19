page 50939 "Posted Treasury Transactions"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Treasury Cashier Transaction";
    SourceTableView = WHERE(Posted = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = TransType;
                    OptionCaption = 'Teller Request,Return To Treasury,Issue From Bank,Return To Bank,Inter Teller Transfers,Branch Treasury Transactions,End of Day Return to Treasury';
                    ApplicationArea = All;
                }
                field("From Account"; Rec."From Account")
                {
                    Caption = 'From';
                    Editable = FrAccount;
                    ApplicationArea = All;
                }
                field("From Till"; Rec."From Till")
                {
                    ApplicationArea = All;
                }
                field("To Account"; Rec."To Account")
                {
                    Caption = 'To';
                    Editable = ToAccount;
                    ApplicationArea = All;
                }
                field("To Till"; Rec."To Till")
                {
                    ApplicationArea = All;
                }
                field("Till/Treasury Balance"; Rec."Till/Treasury Balance")
                {
                    Caption = 'End Of Day Till Balance';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    Caption = 'Vault Balance';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = Amnt;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = Currr;
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'Cheque/Document No.';
                    Editable = ExternDoc;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Issued; Rec.Issued)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Time Issued"; Rec."Time Issued")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Issued By"; Rec."Issued By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Received; Rec.Received)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date Received"; Rec."Date Received")
                {
                    ApplicationArea = All;
                }
                field("Time Received"; Rec."Time Received")
                {
                    ApplicationArea = All;
                }
                field("Received By"; Rec."Received By")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Cash on Treasury Coinage"; Rec."Total Cash on Treasury Coinage")
                {
                    Caption = 'Total Cash on Treasury/Teller Coinage';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = Typee;
                    ApplicationArea = All;
                }
                field("Excess/Shortage Amount"; Rec."Excess/Shortage Amount")
                {
                    Editable = Excess;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(Coinage; Coinage)
            {
                Caption = 'Coinage';
                Editable = Cnage;
                SubPageLink = No = FIELD(No);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Print/Preview")
            {
                Image = PrintDocument;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    Treasury.Reset;
                    Treasury.SetRange(No, Rec.No);
                    if Treasury.Find('-') then begin
                        REPORT.Run(52140722, true, false, Treasury);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                actionref("Print/Preview_Promoted"; "Print/Preview")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        if Rec.Posted = true then
            CurrPage.Editable := false;
    end;

    var
        TransType: Boolean;
        FrAccount: Boolean;
        ToAccount: Boolean;
        Amnt: Boolean;
        Currr: Boolean;
        ExternDoc: Boolean;
        Excess: Boolean;
        Cnage: Boolean;
        Typee: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        Treasury: Record "Treasury Cashier Transaction";

    local procedure UpdateControls()
    begin
        if (Rec.Issued = Rec.Issued::Yes) or (Rec.Received = Rec.Received::Yes) then begin
            TransType := false;
            FrAccount := false;
            ToAccount := false;
            Amnt := false;
            Excess := false;
            Currr := false;
            Cnage := false;
            ExternDoc := false;
            Typee := false;
        end else begin
            TransType := true;
            FrAccount := true;
            ToAccount := true;
            Amnt := true;
            Excess := true;
            Currr := true;
            Cnage := true;
            ExternDoc := true;
            Typee := true;

        end;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




