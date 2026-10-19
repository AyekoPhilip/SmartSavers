page 51087 "Bank List-Changes"
{
    ApplicationArea = All;
    Caption = 'Bank List-Changes';
    PageType = List;
    SourceTable = "Bank Account-Change";
    UsageCategory = Lists;
    Editable = true;
    ModifyAllowed = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Code';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Name';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                }

                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';

                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Branch Name';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;

                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;

                }

            }
        }
        area(factboxes)
        {
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
        area(navigation)
        {
            action("Direct Debit Mandates")
            {
                ApplicationArea = Suite;
                Caption = 'Get Customer Existing Accounts';
                Image = MakeAgreement;
                ToolTip = 'View or edit bank account.';
                trigger OnAction()
                var
                    BankChangeRec: Record "Bank Account-Change";
                    CustomerBankDetail: Record "Cust. Bank Account";
                    RegMngt: Codeunit "Register Management";
                    Recx: Record "Member Changes";
                begin
                    Recx.Reset();
                    Recx.SetRange("No.", Rec."Application No.");
                    if Recx.Find('-') then begin
                        RegMngt.getCustomerBankDetailsCodeNoCode('', Recx."Member No.");
                    end;

                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Direct Debit Mandates_Promoted"; "Direct Debit Mandates")
                {
                }
            }
        }
    }
}
