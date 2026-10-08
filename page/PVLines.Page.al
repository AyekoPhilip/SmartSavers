page 50095 "PV Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Payment Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = True;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Type field';
                }
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Grouping field';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Editable = false;
                    Visible = false;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Account Type field';
                }

                field("Account No."; Rec."Account No.")
                {

                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No field';
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    Visible = DocReleased;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Posting Type field';
                }
                field("Account Name"; Rec."Account Name")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Account Name field';
                }
                field(Description; Rec.Description)
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field(Amount; Rec.Amount)
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Amount field';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("VAT Code"; Rec."VAT Code")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the VAT Code field';

                    trigger OnValidate()
                    begin

                    end;
                }
                field("W/Tax Code"; Rec."W/Tax Code")
                {
                    Caption = 'W/Tax Code';

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the W/Tax Code field';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("W/T VAT Code"; Rec."W/T VAT Code")
                {
                    Caption = 'W/T VAT Code';

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the W/T VAT Code field';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Retention Code"; Rec."Retention Code")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Retention Code field';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the VAT Amount field';
                }
                field("W/Tax Amount"; Rec."W/Tax Amount")
                {
                    Caption = 'W/Tax Amount';

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the W/Tax Amount field';
                }
                field("W/T VAT Amount"; Rec."W/T VAT Amount")
                {
                    Caption = 'W/T VAT Amount';
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the W/T VAT Amount field';
                }
                field("Retention Amount"; Rec."Retention Amount")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Retention Amount field';
                }

                field("Net Amount"; Rec."Net Amount")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Net Amount field';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    Editable = true;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Applies-to ID field';
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    Editable = TRUE;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Applies-to Doc. Type field';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    Editable = TRUE;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field';
                }
                field(Purpose; Rec.Purpose)
                {

                    ShowMandatory = true;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Purpose field';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field';
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[5] field';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[6] field';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[3] field';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[4] field';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[7] field';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[8] field';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }

                field(AppliedDoc; AppliedDoc)
                {
                    Caption = 'Applied Doc No.';
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applied Doc No. field';
                }
                field("Our Account No."; Rec."Our Account No.")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Our Account No. field';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Dimensions)
            {
                Enabled = false;
                Image = Dimensions;
                ApplicationArea = All;
                ToolTip = 'Executes the Dimensions action';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                    CurrPage.SaveRecord();
                end;
            }
            action("Apply Entries")
            {
                Caption = 'Apply Entries';
                Ellipsis = true;
                Image = ApplyEntries;
                ShortCutKey = 'Shift+F11';
                ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';
                Visible = not DocPosted;
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
            action("Suggent Payment Lines")
            {
                Image = Payment;
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Executes the Suggent Payment Lines action';

                trigger OnAction()
                begin

                end;
            }
            action("Purch. Invoice")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Executes the Purch. Invoice action';

                trigger OnAction()
                var
                    PurchInv: Record "Purch. Inv. Header";
                begin
                    PurchInv.Reset();
                    PurchInv.SetRange("No.", Rec."Vendor Invoice");
                    Report.RunModal(Report::"Purchase - Invoice", true, true, PurchInv);
                end;
            }
            action("View Applied Entries")
            {
                Image = Approve;
                Visible = DocPosted;
                ApplicationArea = All;
                ToolTip = 'Executes the View Applied Entries action';

                trigger OnAction()
                begin
                    // PaymentMgt.ViewAppliedEntries(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AppliedDoc := Rec.GetAppliedDoc();

    end;

    trigger OnInit()
    begin
        ClaimVisible := false;
        ImprestVisible := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    trigger OnOpenPage()
    begin
        AppliedDoc := Rec.GetAppliedDoc();
    end;

    var
        Payments: Record "Payments Header";
        CanEdit: Boolean;
        ClaimVisible: Boolean;
        DocPosted: Boolean;
        DocReleased: Boolean;
        ImprestVisible: Boolean;
        IsStatusPending: Boolean;
        LevyVisible: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        AppliedDoc: Code[50];

}