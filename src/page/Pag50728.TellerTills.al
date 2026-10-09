page 50728 "Teller Tills"
{
    ApplicationArea = All;
    Caption = 'Teller Tills';
    PageType = List;
    SourceTable = "Bank Account";
    UsageCategory = Lists;
    CardPageId = "Bank Account-Banking";
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Bank Type" = filter(Cash | Treasury));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Min. Balance"; Rec."Min. Balance")
                {
                    ToolTip = 'Specifies a minimum balance for the bank account.';
                    ApplicationArea = All;
                }
                field(CashierID; Rec.CashierID)
                {
                    ToolTip = 'Specifies the value of the CashierID field';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                    ApplicationArea = All;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ToolTip = 'Specifies a number of the bank branch.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                    ApplicationArea = All;
                }
                field("Bank Type"; Rec."Bank Type")
                {
                    ToolTip = 'Specifies the value of the Bank Type field';
                    ApplicationArea = All;
                }
            }
        }

    }
    actions
    {
        area(Reporting)
        {
            group(Reports)
            {
                Caption = 'Cashier Statement';
                action("Cashier Statement")
                {
                    Image = CustomerGroup;
                    trigger OnAction()
                    Var
                        Bnk: Record "Bank Account";
                    begin
                        Bnk.Reset();
                        Bnk.SetRange("No.", Rec."No.");
                        if Bnk.FindFirst() then begin
                            Report.Run(Report::"Daily Cash (Teller) Report", true, false, Bnk)
                        end;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                actionref("Cashier Statement_Promoted"; "Cashier Statement")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Temp: Record "User Setup";
    begin
        Temp.Get(UserId);
        if not temp."Show All" then begin
            Rec.FilterGroup(2);
            Rec.SetRange(CashierID, UserId);
            Rec.FilterGroup(0);
        end;
    end;
}



