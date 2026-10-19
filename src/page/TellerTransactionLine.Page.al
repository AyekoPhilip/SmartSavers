page 50870 "Teller Transaction Line"
{
    PageType = List;
    SourceTable = "Cashier Transaction Line";
    InsertAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Clear Loan"; Rec."Clear Loan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Outstanding Bills"; Rec."Outstanding Bills")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    Visible = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;


                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Minimum Balance Attained"; Rec."Minimum Balance Attained")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
            group(Control24)
            {
                ShowCaption = false;
                fixed("Account Details")
                {
                    group(Membership)
                    {
                        Caption = 'Membership';
                        field("Member Nos"; Rec."Member No.")
                        {
                            Caption = 'Member Nos';
                            Editable = false;
                            ApplicationArea = All;
                        }
                    }
                    group(Amounts)
                    {
                        Caption = 'Amounts';
                        field(Balance; Rec.Amount)
                        {
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            Visible = true;
                            ApplicationArea = All;
                        }
                    }
                    group(Balances)
                    {
                        Caption = 'Total Amount';
                        field(TotalBalance; Rec.Amount + TotalAmount - xRec.Amount)
                        {
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            Visible = true;
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }

    }

    actions
    {
        area(creation)
        {


        }
        area(Processing)
        {
            action("Suggest Accounts")
            {
                Caption = 'Suggest Account';
                Enabled = true;
                Image = Allocate;
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()

                begin
                    //  BnkMngt.CreateCredReceiptLine(Rec, 0);
                end;

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Suggest Accounts_Promoted"; "Suggest Accounts")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcBal;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CalcBal;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CalcBal;
    end;

    trigger OnOpenPage()
    begin

        //**Prevent modification of approved entries
        Ctrans.Reset;
        Ctrans.SetRange(Ctrans."No.", Rec."Transaction No.");
        if Ctrans.Find('-') then begin
            if Ctrans.Posted then
                CurrPage.Editable := false
            else
                CurrPage.Editable := true;
        end;
        CalcBal;
    end;

    var
        Ctrans: Record "Teller Transaction";
        CashierTransactionLines: Record "Cashier Transaction Line";
        TotalAmount: Decimal;
        CashTrans: Record "Teller Transaction";
        BnkMngt: Codeunit "Banking Procedure Mngt.";

    procedure CalcBal()
    begin
        TotalAmount := 0;
        CashierTransactionLines.Reset;
        CashierTransactionLines.SetRange("Transaction No.", Rec."Transaction No.");
        CashierTransactionLines.CalcSums(Amount);
        TotalAmount := CashierTransactionLines.Amount;
        if CashTrans.Get(Rec."Transaction No.") then begin
            Rec."Member No." := CashTrans."Member No.";
        end;
    end;
}




