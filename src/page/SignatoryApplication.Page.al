page 50784 "Signatory Application"
{
    AutoSplitKey = true;
    CardPageID = "Signatory Application Card";
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Signatory Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control9)
            {
                ShowCaption = false;
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                }
                field("Staff/Payroll"; Rec."Staff/Payroll")
                {
                    Caption = 'Staff/Payroll No';
                    ApplicationArea = All;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Signatory Type';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //*
        UpdateControl;
    end;

    trigger OnOpenPage()
    begin
        //*
        UpdateControl;
    end;


    procedure UpdateControl()
    var
        MemberAppl: Record "Member Application";
    begin

        if MemberAppl.Get(Rec."Account No.") then begin
            case MemberAppl."Approval Status" of
                MemberAppl."Approval Status"::"Pending Approval", MemberAppl."Approval Status"::Approved, MemberAppl."Approval Status"::Rejected, MemberAppl."Approval Status"::Posted:
                    begin
                        CurrPage.Editable := false;
                    end;

                MemberAppl."Approval Status"::Open:
                    begin
                        CurrPage.Editable := true;
                    end;
            end;
        end;
    end;
}




